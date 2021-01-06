Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE282EC54A
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 21:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbhAFUmS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 15:42:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56686 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbhAFUmR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 15:42:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KYwcL052619;
        Wed, 6 Jan 2021 20:41:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=fKHBNKLIPD4hun+9F85gBg0Xvq8Mg+IPsy2rxEiVOGs=;
 b=LPmc3fkskOWcOgM7p3BWcmenk6dfcPKEcizpUDlg1ra5N49algYo/47Mh6Zat+8MKmhn
 yJ50k7emuTJPFu/QLWaedjHI5225TfoJNpEQfj9Agm3H9qJl8RVdpWV1F+DqPBQSCHtU
 qDra7rhxhKmWcJjsppbLJTXiQAWlMW02ahBO1dOU9bdhaDtpYqszuWgvP4oBQLWrnyGD
 UwZRbHNHLbewc3feljfD6Q9ZEHLjdRfm27o7+o5N4GNeiw+7JydZ+9s/iKAV++kgDaIW
 nRRQX3Bieub6iaKd6Tje38BgmLtzbOsDkDEasFJDcVwg7yJ4hz90ADIq4oEKoKPce+t0 wA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepm9sa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 20:41:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KZbLP145530;
        Wed, 6 Jan 2021 20:39:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35w3g1jf24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 20:39:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106KdXfk029344;
        Wed, 6 Jan 2021 20:39:33 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 20:39:33 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v4 10/13] io_uring: generalize files_update functionlity to rsrc_update
Date:   Wed,  6 Jan 2021 12:39:19 -0800
Message-Id: <1609965562-13569-11-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Generalize files_update functionality to rsrc_update in order to
leverage it for buffers updates.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 19 ++++++++++++++-----
 include/uapi/linux/io_uring.h |  6 +++++-
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fbff8480..b956029 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5951,7 +5951,7 @@ static int io_async_cancel(struct io_kiocb *req)
 }
 
 static int io_rsrc_update_prep(struct io_kiocb *req,
-				const struct io_uring_sqe *sqe)
+			       const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
 		return -EINVAL;
@@ -5968,8 +5968,11 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_files_update(struct io_kiocb *req, bool force_nonblock,
-			   struct io_comp_state *cs)
+static int io_rsrc_update(struct io_kiocb *req, bool force_nonblock,
+			  struct io_comp_state *cs,
+			  int (*update)(struct io_ring_ctx *ctx,
+					struct io_uring_rsrc_update *up,
+					unsigned int nr_args))
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_rsrc_update up;
@@ -5979,10 +5982,10 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 		return -EAGAIN;
 
 	up.offset = req->rsrc_update.offset;
-	up.fds = req->rsrc_update.arg;
+	up.rsrc = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_sqe_files_update(ctx, &up, req->rsrc_update.nr_args);
+	ret = (*update)(ctx, &up, req->rsrc_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ret < 0)
@@ -5991,6 +5994,12 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
+static int io_files_update(struct io_kiocb *req, bool force_nonblock,
+			   struct io_comp_state *cs)
+{
+	return io_rsrc_update(req, force_nonblock, cs, __io_sqe_files_update);
+}
+
 static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	switch (req->opcode) {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 77de7c0..f51190b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -288,7 +288,11 @@ enum {
 struct io_uring_rsrc_update {
 	__u32 offset;
 	__u32 resv;
-	__aligned_u64 /* __s32 * */ fds;
+	union {
+		__aligned_u64 /* __s32 * */ fds;
+		__aligned_u64 /* __s32 * */ iovs;
+		__aligned_u64 /* __s32 * */ rsrc;
+	};
 };
 
 #define io_uring_files_update	io_uring_rsrc_update
-- 
1.8.3.1

