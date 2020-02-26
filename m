Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273C716F9AC
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 09:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgBZIi7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 03:38:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44660 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgBZIi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 03:38:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8bfkv157629;
        Wed, 26 Feb 2020 08:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=acpLegKDnU44X1fRbDFiV4FGyBMPOWOiU9STyDSbBAY=;
 b=XVbbGf+CU/1nfp8cxB3Ti/kDZxHlO3nwMTsDYkleaW0wvMxZPY/lnts/Lj5eQHrdq9dr
 Y/Q7slRYS0ziB0c7yKjKS9sxK1FtH99BMalmxTbChWIFwEZE8WcAPTa/6H6cu7aka287
 1+M+6GGKiUpC6PP6s6oZsGu1ZN2WGDUd5YvMz6PqEWD3JVeWWDytukFC+dr5TAbCcXRa
 Z3ImBvOyKjJLS2UTLqi1fnGIj4C+wFXYy4347abylOs+m/UMAlQ8UYp+UgoNNV17sTJA
 UxMDUoAvNJOSd2lL2UY1KWSIsSnO30UT+bFwaAmp9wPlnleTi2nHeuC8deTNOTVdTgZn cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ydcsrhxat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:38:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8adkN044043;
        Wed, 26 Feb 2020 08:38:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ydcs9b4cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:38:57 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01Q8cuJl010146;
        Wed, 26 Feb 2020 08:38:56 GMT
Received: from localhost.localdomain (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 00:38:56 -0800
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, martin.petersen@oracle.com,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        io-uring@vger.kernel.org, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 3/4] block_dev: support protect information passthrough
Date:   Wed, 26 Feb 2020 16:37:18 +0800
Message-Id: <20200226083719.4389-4-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200226083719.4389-1-bob.liu@oracle.com>
References: <20200226083719.4389-1-bob.liu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Support protect information passed from use sapce, on direct io
is considered now.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 fs/block_dev.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 69bf2fb..10e3299 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -348,6 +348,13 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 	loff_t pos = iocb->ki_pos;
 	blk_qc_t qc = BLK_QC_T_NONE;
 	int ret = 0;
+	struct iovec *pi_iov;
+
+	if (iocb->ki_flags & IOCB_USE_PI) {
+		ret = iter_slice_protect_info(iter, nr_pages, &pi_iov);
+		if (ret)
+			return -EINVAL;
+	}
 
 	if ((pos | iov_iter_alignment(iter)) &
 	    (bdev_logical_block_size(bdev) - 1))
@@ -411,6 +418,16 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 				polled = true;
 			}
 
+			/* Add protection information to bio */
+			if (iocb->ki_flags & IOCB_USE_PI) {
+				ret = bio_integrity_prep_from_iovec(bio, pi_iov);
+				if (ret) {
+					bio->bi_status = BLK_STS_IOERR;
+					bio_endio(bio);
+					break;
+				}
+			}
+
 			qc = submit_bio(bio);
 
 			if (polled)
-- 
2.9.5

