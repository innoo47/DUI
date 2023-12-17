//
//  ViewController.swift
//  Board
//
//  Created by 박인호 on 2023/09/10.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class BoardViewController: UIViewController {
    
    @IBOutlet weak var mTVBoard: UITableView!
    @IBOutlet weak var mLBUserId:UILabel!
    
    var ref: DatabaseReference!
    
    var mBoardTableViewCell:BoardTableViewCell!
    var marBoardList:Array<BoardDto>?
//    
    var BoardID: String = ""
//    var boardId: String = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.onDoUILogic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.onDoDataLoad()
    }
    
    //
    func onDoUILogic(){
        
        self.ref = Database.database().reference()
        
        self.onDoDataLoad()

        self.initTableView()
        
        self.mTVBoard.reloadData()
    }
    
    // Firebase에서 데이터를 가져오는 메소드
    func addFirebaseBoard() {
        // Firebase 데이터베이스에서 "게시판" 데이터를 가져옴
        print("addFirebaseBoard")
        
        self.ref.child("게시판").queryOrdered(byChild: "regDate") // 시간을 기준으로 정렬
            .observe(.value) { (snapshot) in
            
            self.onDoDataReset()
            
            for child in snapshot.children {
                if let Snapshot = child as? DataSnapshot,
                   let boardData = Snapshot.value as? [String: Any],
                   let UID = boardData["UID"] as? String,
                   let title = boardData["title"] as? String,
                   let context = boardData["context"] as? String,
                   let regDate = boardData["regDate"] as? String{
                    
                    let dump = BoardDto.init()
                    
                    dump.uuid = UID
                    dump.title = title
                    dump.context = context
                    dump.regDate = regDate
                    
                    self.marBoardList?.append(dump)
                    
                    self.mTVBoard.reloadData()
                    
                    self.GoToBottom()
                    
                } else {
                    print("error")
                }
            }
        }
    }
    
    
    func initTableView(){
        
        self.mTVBoard.delegate = self
        self.mTVBoard.dataSource = self
        
        let pNibBoardTableViewCell:UINib? = UINib.init(nibName: BoardTableViewCell.Cell_Identifier, bundle: nil) as UINib
        if let pNib = pNibBoardTableViewCell {

            self.mTVBoard.register(pNib, forCellReuseIdentifier: BoardTableViewCell.Cell_Identifier)
        }
        self.mBoardTableViewCell = Bundle.main.loadNibNamed(BoardTableViewCell.Cell_Identifier, owner: self, options: nil)?.last as! BoardTableViewCell

        print("Cell_Identifier: \(BoardTableViewCell.Cell_Identifier)")
        self.mTVBoard.reloadData()
    }
    
    
    func onDoDataLoad(){
        
        // 삭제
        self.marBoardList = nil
        self.marBoardList = Array<BoardDto>.init()
        
        // 갱신
        self.mTVBoard.reloadData()
        
        
        if let uuid = AppStorage.sharedInstance.getUUID(){
            
            self.mLBUserId.text = uuid
        }
        
        self.addFirebaseBoard()
    }
    
    func onDoDataReset(){
        
        // 삭제
        self.marBoardList = nil
        self.marBoardList = Array<BoardDto>.init()
    }

    
    // 작성 버튼 클릭시
    @IBAction func onClickBoardWrite(_ sender:UIButton){
        

    }

    
    func GoToBottom() {
    
        DispatchQueue.main.async {
            
            if let list = self.marBoardList{
                
                let row = list.count
                
                let indexPath = IndexPath(row: row-1, section: 0)
                self.mTVBoard.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
}

extension BoardViewController:UITableViewDelegate, UITableViewDataSource{


    // MARK: - UITableView
    
    // 테이블 뷰가 몇 개의 섹션을 가져야 하는지를 결정
    func numberOfSections(in tableView: UITableView) -> Int {

        let sectionCount:Int = 1
        return sectionCount
    }

    // 각 섹션에 표시할 행(셀)의 수를 지정합니다. 수는 marBoardList 배열에 있는 요소 수에 기반
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var rowCount:Int = 0
        guard let pArBoardList = self.marBoardList else {
            
            return 0
        }
        rowCount = pArBoardList.count
        return rowCount
    }

    // 각 행(셀)의 높이를 설정합니다. 여기서는 모든 행에 대해 높이가 80.0 포인트로 고정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let nRow : Int = indexPath.row

        var mCellRowHeight:CGFloat = 80.0
        return mCellRowHeight
    }

    // row cell  테이블 뷰 셀을 만들고 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let nRow : Int = indexPath.row

        // marBoardList 배열이 nil이 아닌지 확인
        if let pArBoardList = self.marBoardList{
            
            // nil이 아니면 'BoardTableViewCell.Cell_Identifier' 식별자를 사용하여 재사용 가능한 셀을 가져오려 시도  셀을 가져올 수 있으면 marBoardList에서 가져온 데이터를 기반으로 셀의 내용을 구성
            let dequeueReusableCell:BoardTableViewCell? = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.Cell_Identifier) as? BoardTableViewCell
            
            
            if let cell = dequeueReusableCell {
                  
                let pBoardDto = pArBoardList[nRow]
                cell.mLBTitle.text = pBoardDto.title
                if let regDate = pBoardDto.regDate{
                    
                    cell.mLBRegDate.text = CommonUtil.getDateDuration(regDate)
                }
                 
                return cell
            }
            
            return dequeueReusableCell!
        }
        else{

            // marBoardList가 nil이면 바로 새로운 셀을 만들어 반환
            let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.Cell_Identifier, for: indexPath) as! BoardTableViewCell

            return cell
        }
    }
    
    
    // 셀 클릭시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---------")
        let nRow = indexPath.row
        print("\(nRow) Cell")

        if let pArBoardList = self.marBoardList {
            // indexPath.row에 해당하는 데이터 가져오기
            let pBoardDto = pArBoardList[nRow]

            // pBoardDto 내의 변수에 접근
            if let sUID = pBoardDto.uuid, let sRegDate = pBoardDto.regDate {
                self.BoardID = sUID + sRegDate // 게시물 식별 코드
//                self.BoardID = boardId
                print("UID : ",sUID)
                print("regDate : ",sRegDate)
//                print("boardId : ",boardId)
                print("BoardID : ",BoardID)
                
                // ShowViewController를 UIStoryboard에서 인스턴스화
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let boardDetailVC = storyboard.instantiateViewController(withIdentifier: "ShowViewController") as? ShowViewController {
                    // 데이터 설정
                    boardDetailVC.boardID = BoardID
                    
                    // 뷰 컨트롤러 이동
                    self.navigationController?.pushViewController(boardDetailVC, animated: true)
                }
            } else {
                print("uuid 또는 regDate가 없습니다.")
            }
        }
    }


}

