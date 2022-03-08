Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1784D1BF9
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347922AbiCHPnA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347916AbiCHPm4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:42:56 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1723B4ECFD
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:00 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220308154158epoutp03b064f0d6db79ab9662b5f588b4d9f1d0~aciVW_gYI2451824518epoutp035
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:41:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220308154158epoutp03b064f0d6db79ab9662b5f588b4d9f1d0~aciVW_gYI2451824518epoutp035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754118;
        bh=eQY981qQJsial6Teqout4wQZLQ5cka3Wr/hRVUCufOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoBjpVsjBBRNJs3Qn2CLiaUfinCSDtsJE05MyGLUpc3OVjxZv/m1nbv5cSFjYrpE4
         wMehDn1GR6MczyXCcoeDxxhcGvQlnPyEZ5UbhtJxt8hKg0bx8rJGeQlLw7bdN5uO3U
         /I64vA0B6xaJfzhLwnfNf5UgX4cqpjzChaSg0rSU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220308154157epcas5p29c6de2e29e8cdd6bbe0d9ce3231d80bb~aciUhE2X42884128841epcas5p2R;
        Tue,  8 Mar 2022 15:41:57 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KCfhL0vJwz4x9Pp; Tue,  8 Mar
        2022 15:41:54 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.E6.46822.A6677226; Wed,  9 Mar 2022 00:29:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220308152655epcas5p4ae47d715e1c15069e97152dcd283fd40~acVMtmpUO1273712737epcas5p4d;
        Tue,  8 Mar 2022 15:26:55 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220308152655epsmtrp13252b6f06a1190aaa59bc4780bbeae64~acVMsu3R20125001250epsmtrp1N;
        Tue,  8 Mar 2022 15:26:55 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-f6-6227766ab17d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        14.51.29871.FB577226; Wed,  9 Mar 2022 00:26:55 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152653epsmtip1170e3b67827d9ab191f908af9edbf8ad~acVKoUDEa1072310723epsmtip1o;
        Tue,  8 Mar 2022 15:26:53 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 02/17] fs: add file_operations->async_cmd()
Date:   Tue,  8 Mar 2022 20:50:50 +0530
Message-Id: <20220308152105.309618-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJsWRmVeSWpSXmKPExsWy7bCmpm5WmXqSwexXrBbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdsbv5kOMBZPYK+Y2/2JpYHzC2sXIySEhYCLxoO8vUxcjF4eQwG5GiZs9
        +9ggnE+MEvcuzGeFcL4xSpz/NYUZpuXZocdgtpDAXkaJPUeyIIo+M0r8WfMXKMHBwSagKXFh
        cilIjYiAl8T92+/BBjELdDFJvN13nw0kISxgLbF0+iwWEJtFQFVi+53pYEN5BSwlujZNZYNY
        Ji8x89J3dhCbU8BK4uetrawQNYISJ2c+AetlBqpp3jqbGWSBhMABDonuOd+YQI6QEHCROL1T
        EGKOsMSr41vYIWwpiZf9bVB2scSvO0ehejsYJa43zGSBSNhLXNzzF2wOM9Az63fpQ4RlJaae
        WscEsZdPovf3EyaIOK/EjnkwtqLEvUlPoeErLvFwxhIo20Oi88c9NkjA9TJK9O+TnsCoMAvJ
        O7OQvDMLYfMCRuZVjJKpBcW56anFpgVGeanl8EhOzs/dxAhO1lpeOxgfPvigd4iRiYPxEKME
        B7OSCO/98ypJQrwpiZVVqUX58UWlOanFhxhNgeE9kVlKNDkfmC/ySuINTSwNTMzMzEwsjc0M
        lcR5T6dvSBQSSE8sSc1OTS1ILYLpY+LglGpgst574HNvd/lXtx0Fd1c8qGYJYki1vlq1/y/3
        9PtPn/7bdGhGlObll9sKZQ+3dZ4WrhOw+Rbqvznx88L2zc974h5kBBhKCUhZhHxzZIz5x1a8
        YILM36k+0pJ+nAvkOjrOHhN7m/JxRlTIFabjJyZ+Pa10v1OzKv7X07W9n6weJs96VPo/0/j6
        y2KzWWrtGTLvsn60+/3bHxJ5y8yJ10TQeWdaYoyOC7/5TcHkn7d4L09jtnT7v3fnv7ZCe5sr
        tep/fFszny3r7BRRdnO2WLTAPkvywg02//VaIV0cb9uqs7xmrtkVFxnmFcu6KPHz3COiHzY4
        tcpnB8huZXjXVPfS7uKalBX//1ZND2dbyPNeiaU4I9FQi7moOBEAOTRKRl8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJTnd/qXqSwbkrGhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr43fzIcaCSewVc5t/sTQwPmHtYuTkkBAwkXh2
        6DEziC0ksJtRYu2/AIi4uETztR/sELawxMp/z4FsLqCaj4wSl3umADVwcLAJaEpcmFwKUiMi
        ECBxsPEyWA2zwAwmiZ7mzywgCWEBa4ml02eB2SwCqhLb70wHW8YrYCnRtWkqG8QCeYmZl76D
        LeMUsJL4eWsrK8RBlhIr1v1mg6gXlDg58wnYHGag+uats5knMArMQpKahSS1gJFpFaNkakFx
        bnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcDxpae5g3L7qg94hRiYOxkOMEhzMSiK898+rJAnx
        piRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXA1PT58kQpURXJ
        PYbX7ZxKJ8//URD1VLV69iTLMJm0ojvOfbuv3t/722H91H+zFe9fPcz2U6jVzMuW68Hv+HUn
        Yo41TIv8v6Va26JK36Y4v5mxWWxln9gdMcMr+8+uf5lS8GSiw663BysityyXV9bS4T4+ybcz
        M+uesp2XY/HCg94axruX6Yqzme9Kkd3TcviG2N18rYhTuSsZurj5zW/ObDyzanFeKIszx2TR
        SWqmlk932x3gdtq0tpHpzbuPk54IF1xoKln+Rem4YsqZH7cE8iM+ND9gVd585HWrFK9giN/M
        ewtNqqOSjI816epN7/gmsLLwo37plpDdG+8z3G7m/v3yuFVa1bbdqUHH9m24rMRSnJFoqMVc
        VJwIAHF55LcWAwAA
X-CMS-MailID: 20220308152655epcas5p4ae47d715e1c15069e97152dcd283fd40
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152655epcas5p4ae47d715e1c15069e97152dcd283fd40
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152655epcas5p4ae47d715e1c15069e97152dcd283fd40@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

This is a file private handler, similar to ioctls but hopefully a lot
more sane and useful.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index e2d892b201b0..a32f83b70435 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1977,6 +1977,7 @@ struct dir_context {
 #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
 
 struct iov_iter;
+struct io_uring_cmd;
 
 struct file_operations {
 	struct module *owner;
@@ -2019,6 +2020,7 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+	int (*async_cmd)(struct io_uring_cmd *ioucmd);
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.25.1

