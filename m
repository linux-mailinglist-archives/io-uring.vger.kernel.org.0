Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857882F3E05
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbhALWA6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 17:00:58 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47082 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437178AbhALVeP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:34:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLXXke114952;
        Tue, 12 Jan 2021 21:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=NyT7SDn3wlmsLtqvmzkyu+PnYYERjOGKVWcfMKdlIcc=;
 b=nx2EzDvSgvpN9lcPkDWNPhz/lySSUv0fxYlT7+dlN8wmwXm7tR1XkaI5qnOYR/Eq+5wf
 YoboI9dPLKZ63DyWiUJYc8v6tTmPX9oa18FFfdfX3IqV0C/nXpErcbGlze2ygNMdGU42
 U5faXuvcjxuG07jyuQj7mbRaRpg9beAXb2u2HYsGMiHzT1mXbrgd+ccRSFplZ0FxhRzM
 mfmxcOjGjRzgVTYhXvw6/zjFMYYMxuDSTBmJyT465e5Qgj4S73LCFwJcoh61tjcy1ysv
 rU4fGbWxfmo4eBO2sMelVFpWygMSUruTfZ9UzfCleLWgvk6GmcGctd1Af69/YBi3rKkt KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 360kg1rk07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLEbnl105255;
        Tue, 12 Jan 2021 21:33:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 360kehsfxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CLXSW5023064;
        Tue, 12 Jan 2021 21:33:28 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:28 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 08/13] io_uring: generalize files_update functionlity to rsrc_update
Date:   Tue, 12 Jan 2021 13:33:08 -0800
Message-Id: <1610487193-21374-9-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120128
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
index 6ebfe1f..f9f458c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5954,7 +5954,7 @@ static int io_async_cancel(struct io_kiocb *req)
 }
 
 static int io_rsrc_update_prep(struct io_kiocb *req,
-				const struct io_uring_sqe *sqe)
+			       const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
 		return -EINVAL;
@@ -5971,8 +5971,11 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
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
@@ -5982,10 +5985,10 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 		return -EAGAIN;
 
 	up.offset = req->rsrc_update.offset;
-	up.fds = req->rsrc_update.arg;
+	up.rsrc = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_sqe_files_update(ctx, &up, req->rsrc_update.nr_args);
+	ret = (*update)(ctx, &up, req->rsrc_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ret < 0)
@@ -5994,6 +5997,12 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
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

