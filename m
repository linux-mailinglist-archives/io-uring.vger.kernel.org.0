Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E581614D5
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 15:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgBQOj5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 09:39:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46622 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbgBQOj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 09:39:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01HEdTud037611;
        Mon, 17 Feb 2020 14:39:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=/RsUM0cYVyqA/cCWPFMFhh+8+wcAeB1+dhDPB6wI3fY=;
 b=Xlm7iKCs5Apv3gic8QeuL8eyx80DfWe7Jxpz4b+XjZaTUnmYWJdLqsKBJL+sQtVI+MQr
 HPA8++HxloMX54apnYaRjk/NDTDm27t8yuF9zh5nRHuWBpJmnEC6sVzM83aSztd+9jhB
 i3bW0kDaPI9pkGzpqXpEhOym2IvfFGxHAXWv1887QnGvD8HwuVWTxeM2NplDZzqyc31W
 e5i5lT/Hkxh7zrQKZ7F/SirWov5JF6FT+wPPG2nA8AFNsqD+9I9pBHE9U+3AvCCdzy8W
 pgt6r5A2oChPTjXc9skhpwOhbA33sylU7YwMrn7a88AmOYKNRMchk4kN/e6ef8hDjTXE DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2y68kqrkj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 14:39:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01HEc6MD082315;
        Mon, 17 Feb 2020 14:39:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y6t4g775e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 14:39:53 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01HEdqwE016983;
        Mon, 17 Feb 2020 14:39:52 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Feb 2020 06:39:52 -0800
Date:   Mon, 17 Feb 2020 17:39:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] io_uring: remove unnecessary NULL checks
Message-ID: <20200217143945.ua4lawkg22ggfihr@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9533 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=989 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9533 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 clxscore=1011 mlxscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170121
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The "kmsg" pointer can't be NULL and we have already dereferenced it so
a check here would be useless.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 72bc378edebc..e9f339453ddb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3065,7 +3065,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 			if (req->io)
 				return -EAGAIN;
 			if (io_alloc_async_ctx(req)) {
-				if (kmsg && kmsg->iov != kmsg->fast_iov)
+				if (kmsg->iov != kmsg->fast_iov)
 					kfree(kmsg->iov);
 				return -ENOMEM;
 			}
@@ -3219,7 +3219,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 			if (req->io)
 				return -EAGAIN;
 			if (io_alloc_async_ctx(req)) {
-				if (kmsg && kmsg->iov != kmsg->fast_iov)
+				if (kmsg->iov != kmsg->fast_iov)
 					kfree(kmsg->iov);
 				return -ENOMEM;
 			}
-- 
2.11.0

