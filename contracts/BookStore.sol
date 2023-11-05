// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

    contract BookStore {
        uint public tax;
        address immutable taxAccount;
        uint public bookId;
        BookStruct[] books;
        mapping(address => BookStruct[]) public bookOf;
        mapping(uint => address) public sellerOf;
        mapping(uint => bool) public bookExist;
        
        struct BookStruct {
            uint id;
            address seller;
            string name;
            string description;
            string author;
            uint cost;
            uint timestamp;
        }

        event Sale(

            uint id,
            address indexed buyer,
            address indexed seller,
            uint cost,
            uint timestamp
        );

        event Created(

            uint id,
            address indexed seller,
            uint timestamp
        );

        constructor (uint _tax){
            tax = _tax;
            taxAccount = msg.sender;
        }

        function createBook (
            string memory name,
            string memory description,
            string memory author,
            uint cost
        ) public returns (bool){
            require(bytes(name).length > 0, "Name empty");
            require(bytes(description).length > 0, "Description empty");
            require(bytes(author).length > 0, "Author empty");
            require(cost > 0, "Price can not be empty");

            sellerOf[bookId] = msg.sender;

            books.push(
                BookStruct(
                    bookId++,
                    msg.sender,
                    name,
                    description,
                    author,
                    cost,
                    block.timestamp

                )
            );
            emit Created(
                bookId++,
                msg.sender,
                block.timestamp
             );
            return true;

        }

        function payForBook(uint id_) public payable{
            require(bookExist[id_],"Book does not exist");
            require(msg.value >= books[id_].cost, "Not enough balance");
            address seller = sellerOf[id_];

            uint fee = (msg.value/100)*tax;
            uint amount = msg.value-fee;
            payTo(seller, amount);
            payTo(taxAccount, fee);

            bookOf[msg.sender].push(books[id_]);

            emit Sale (
                id_,
                msg.sender,
                seller,
                books[id_].cost,
                block.timestamp

            );
        }

        function payTo(address to_, uint amount) internal returns(bool){

            (bool succeeded,) = payable(to_).call{value: amount}("");
            require(succeeded, "Payment failed");
            return true;
        }

        function myBooks(address buyer) public view returns (BookStruct[] memory){
            return bookOf[buyer];
        }

        function getBooks() public view returns(BookStruct[] memory){
            return books;
        }

        function getBook(uint id_) public view returns(BookStruct memory){
            return books[id_];
        }


        }
 











