Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17FA2DE8D4
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgLRSKY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:10:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgLRSKY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:10:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3pRE149267;
        Fri, 18 Dec 2020 18:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ybQMxo2uak/0qmm/3sJZcnXmn1OBRexlTQEpgF5uYa8=;
 b=OQdrP3W6Qlg+9Objhs0OHBiJUf1zepSiAjW8Oa+jpV0cClK6Da97+K9m6plfAd8g1pmc
 DPyjUAvqRuSupIrtsATULLEj4z6g0Pg81k3Q5z0b07tJl9JtjcqAhjZQniekn2meSBgA
 xTRiaj/loUCm/maTSt6vAvVHSnjTBVmgU9gJrn/7YcK+/WrRR7YOJHVEfwBn5NqIWzwF
 aghcKIzS1OP6bjvjXBes1jhGQu+usjE6achk+mETwW0MrHVIjh87aRtRxmHHf2dh83Tn
 /ot0OfddS3nebTHGeLk/TbUQ2uQnF0BCzN9YgLPy9CszU1Kp6HGx1apcNuRC6xgxZuj5 ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35cntmkfux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:09:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5OXf028539;
        Fri, 18 Dec 2020 18:07:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35d7eskjqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:40 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BII7esN016606;
        Fri, 18 Dec 2020 18:07:40 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:40 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 10/13] io_uring: generalize files_update functionlity to rsrc_update
Date:   Fri, 18 Dec 2020 10:07:25 -0800
Message-Id: <1608314848-67329-11-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
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
index 7e1467c..dbac1ea 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5963,7 +5963,7 @@ static int io_async_cancel(struct io_kiocb *req)
 }
 
 static int io_rsrc_update_prep(struct io_kiocb *req,
-				const struct io_uring_sqe *sqe)
+			       const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
 		return -EINVAL;
@@ -5980,8 +5980,11 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
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
@@ -5991,10 +5994,10 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 		return -EAGAIN;
 
 	up.offset = req->rsrc_update.offset;
-	up.fds = req->rsrc_update.arg;
+	up.rsrc = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_sqe_files_update(ctx, &up, req->rsrc_update.nr_args);
+	ret = (*update)(ctx, &up, req->rsrc_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ret < 0)
@@ -6003,6 +6006,12 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
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
index d421f70..8cc672c 100644
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
 
 #define IO_URING_OP_SUPPORTED	(1U << 0)
-- 
1.8.3.1

