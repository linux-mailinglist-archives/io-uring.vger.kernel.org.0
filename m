Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB40F47B8AA
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhLUC4a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:56:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12798 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbhLUC43 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:56:29 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211221025628epoutp01f21994ab180ed7518407b9993bb12e74~Cpa_lnCQO1841718417epoutp01Q
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:56:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211221025628epoutp01f21994ab180ed7518407b9993bb12e74~Cpa_lnCQO1841718417epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055388;
        bh=/KXeRqRmtKhe4hlLhbh4cf3uc4RF2AMH9nkqKc284KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbQ/1KhZw9DjEtCyVV8mhwHKGEwRzSLOP0tJYlN7XIXDf6uC8r1mv6mmHXzZ0iJDR
         4EHfxDItAKkm8pd3Lq4vVuCvh0hyhx2gKf6lJXiCpj7SjQJOM/XAl5Dq1u84DRagI1
         zfDjs5LB3v8uNWGaDxNBJFM7+aYiMeoUkj9taQVE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20211221025627epcas5p2e477d0414a432cbbd50852455c1f21cc~Cpa_A6Vkw2587925879epcas5p2o;
        Tue, 21 Dec 2021 02:56:27 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4JJ1Lb3VVnz4x9Q7; Tue, 21 Dec
        2021 02:56:23 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5D.E1.46822.75241C16; Tue, 21 Dec 2021 11:56:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20211220142235epcas5p3b8d56cd39d9710278ec3360be47f2cca~CfIwWbsyc2729127291epcas5p3K;
        Mon, 20 Dec 2021 14:22:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142235epsmtrp1b36578b55c298b1b473d0ff329d0c514~CfIwVp8QL2445924459epsmtrp1b;
        Mon, 20 Dec 2021 14:22:35 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-91-61c142575288
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.85.29871.BA190C16; Mon, 20 Dec 2021 23:22:35 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142233epsmtip18e0a7b5c3cb5a6b825868840f277c672~CfIuivTvM0637906379epsmtip1p;
        Mon, 20 Dec 2021 14:22:33 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 04/13] io_uring: modify unused field in io_uring_cmd to store
 flags
Date:   Mon, 20 Dec 2021 19:47:25 +0530
Message-Id: <20211220141734.12206-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmhm6408FEg7eXpCyaJvxltlh9t5/N
        YuXqo0wW71rPsVh0nr7AZHH+7WEmi0mHrjFa7L2lbTF/2VN2izU3n7I4cHnsnHWX3aN5wR0W
        j8tnSz02repk89i8pN5j980GNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnXHl/l2Wgr+sFevvHmRrYPzI0sXIySEh
        YCIx/fExRhBbSGA3o8T5tcpdjFxA9idGiXN75zNDJL4xSkxtEIBpeLbtFTtE0V5GiWe9n9gh
        ij4zSqy6wNPFyMHBJqApcWFyKUhYRCBa4sLza2wgNrNAB6PEzm5bEFtYIFji7MmfYK0sAqoS
        Jz/sBjuCV8BCYuGKGYwQu+QlZl76DlbDKWApcXj2MjaIGkGJkzOfsEDMlJdo3jqbGeQeCYGp
        HBJXVh5lhmh2kTh67gQbhC0s8er4FnYIW0riZX8blF0s8evOUahmoOOuN8yEBou9xMU9f5lA
        nmEGemb9Ln2IsKzE1FPrmCAW80n0/n7CBBHnldgxD8ZWlLg36SkrhC0u8XDGElaQMRICHhI/
        V9RBwq2HUWLyiUfMExgVZiH5ZxaSf2YhbF7AyLyKUTK1oDg3PbXYtMAoL7UcHsXJ+bmbGMFJ
        VstrB+PDBx/0DjEycTAeYpTgYFYS4d0ye3+iEG9KYmVValF+fFFpTmrxIUZTYIBPZJYSTc4H
        pvm8knhDE0sDEzMzMxNLYzNDJXHe0+kbEoUE0hNLUrNTUwtSi2D6mDg4pRqYFI9sFjrS9jpX
        73/s8cYbUvMOPLzvceHI0w3OjaucdsWWFWYkzkq3u5PwKnx776Mla/YYl8l9yLzRwHyrZJe8
        5NHcKfUP3+Uve5Rru0j0eeia+FPpT6/P9v347skOj/VG2j/ZjLvWJJ7KWJEpz5Idv8rZ1uyR
        wt23i3WS13y/fXpx7Zm1nWbPtieIKrEbm5+4I+Z6/tkijTup92Z7XltT9cvgwRTr84+yFTy2
        uz69U50xZd+09BUFe3/mat+M4V3pp2NhPc/vomZj8OPT+9fnemeHdC8oXhNiUzJPtN1hflNH
        7eI3Sd7cETePsiguqFy66Oq+BztM9Ngcg6VeqdmeSi0SdFH94eu2VYiFh4tLTomlOCPRUIu5
        qDgRAMGwUes7BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSnO7qiQcSDU6vEbRomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr48r9uywFf1kr
        1t89yNbA+JGli5GTQ0LAROLZtlfsXYxcHEICuxklfm18wAaREJdovvaDHcIWllj57zlU0UdG
        iY8rnjF3MXJwsAloSlyYXApSIyIQK/Hh1zEmkBpmgUmMEhv6H4A1CwsESmz+uYEJxGYRUJU4
        +WE3I4jNK2AhsXDFDEaIBfISMy99B6vnFLCUODx7GdgRQkA1Jz58YYGoF5Q4OfMJmM0MVN+8
        dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECI4GLc0djNtX
        fdA7xMjEwXiIUYKDWUmEd8vs/YlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnN
        Tk0tSC2CyTJxcEo1MImw9/x8d/hgZLrjZW9503+11v/371w036de3tMns+nUURlG4Z/S01lT
        3kYFv+VfNKd4UXKK8dXfG1OuHr7eMN+1oGhxqVYfz/cV7tGfjPI0PD6eqzLyr/USYN36w/mP
        Y5z40yc3Jlsc3bV+0RSJurM3jC99n8CabMY4Y2O+as6L8NXb8h/3chmc7/J9Vr9nfWfp3mk/
        5ERrz9wujJfrcS7WnrbsYVPG1CtTT2nN6fO/rPnW9Gnj820r13q0/z8+4fIeZifuZ+YOyacn
        Xv6feGbmy08Vr2ad/OS5Kn3Ji6oPodvWSvWWx93dJ50S/nmupN2pO4c2CzW+v3Dm87I+yZX7
        OT4/uizAt6T10vPQqawSSizFGYmGWsxFxYkAT4aFBfUCAAA=
X-CMS-MailID: 20211220142235epcas5p3b8d56cd39d9710278ec3360be47f2cca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142235epcas5p3b8d56cd39d9710278ec3360be47f2cca
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142235epcas5p3b8d56cd39d9710278ec3360be47f2cca@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

This patch modifies the unused field in io_uring_cmd structure to store
the flags. This is a prep patch for providing fixedbufs support via
passthrough ioctls.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index f4b4990a3b62..5ab824ced147 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -12,7 +12,7 @@
 struct io_uring_cmd {
 	struct file	*file;
 	__u16		op;
-	__u16		unused;
+	__u16		flags;
 	__u32		len;
 	/* used if driver requires update in task context*/
 	void (*driver_cb)(struct io_uring_cmd *cmd);
-- 
2.25.1

