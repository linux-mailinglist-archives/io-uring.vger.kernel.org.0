Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3092EBBA7
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 10:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbhAFJ1c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 04:27:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAFJ1b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 04:27:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10698xps155607;
        Wed, 6 Jan 2021 09:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=C5Kq07wiNBQ4rVv897deaByc527PdhtjKPiJX1mh5ls=;
 b=vCeORKPMxyQlqDy2r58qBwj35pk6WypqsSVUyHm8EHVn6gJCLp8lGHwP6I+UR51JY1j0
 HOCpo8somKXRb/Ah6APFT/AEjg8xKo/xlR/cVraUefOvAGGgHTzZQ5dGbArczKmVPz3j
 HhyB952AgBNntfWJJmF4NeqrPZMYS3JgTY2UOPnY5M6Iqv/G7Sk8nl5DpkdI8jMAQ2FG
 MUYA7eISE1oY+2q+ydAaXlluBz5TUdmH1clfnCbFfZdMnBgCBVV1vZMvl0UiTH4ufHG+
 ttIApAVbaVsqM4CdbQ/PqH4hmILnTU/aPp1b4N5sROxDs88MCGMDA25f7LI0Tsk2pgTu 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35w5420wb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 09:26:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1069BOLP147152;
        Wed, 6 Jan 2021 09:26:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35w3g0rh1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 09:26:48 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1069QkNa003217;
        Wed, 6 Jan 2021 09:26:46 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 01:26:46 -0800
Date:   Wed, 6 Jan 2021 12:26:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] io_uring: fix an IS_ERR() vs NULL check
Message-ID: <X/WCTxIRT4SHLemV@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060056
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The alloc_fixed_file_ref_node() function never returns NULL, it returns
error pointers on error.

Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..2234ce03034a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7255,8 +7255,8 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 	backup_node = alloc_fixed_file_ref_node(ctx);
-	if (!backup_node)
-		return -ENOMEM;
+	if (IS_ERR(backup_node))
+		return PTR_ERR(backup_node);
 
 	spin_lock_bh(&data->lock);
 	ref_node = data->node;
-- 
2.29.2

