//
//  Constraints.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import Firebase
import FirebaseFirestore

//let STORAGE_REF = Storage.storage().reference()
let DOC_USERS = Firestore.firestore().collection("users")
let DOC_ITEMINFOS = Firestore.firestore().collection("item-infos")
let DEFAULT_IMG_URL = URL(string: "https://jisu-kim.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F0d6b7d80-74ae-4a17-a551-b380b34cc9dc%2FdefaultProfile.png?id=82c80c56-da0a-44e3-82ae-714b0db9e587&table=block&spaceId=62bcc770-ebe8-4b54-b628-19fda021f488&width=1720&userId=&cache=v2")!
