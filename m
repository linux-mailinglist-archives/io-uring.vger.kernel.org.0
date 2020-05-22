Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1B1DDC15
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 02:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgEVAVy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 20:21:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbgEVAVx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 20:21:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M0Lqjx070274;
        Fri, 22 May 2020 00:21:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=loyUxyMweLpCbvim+ajGljocYXZ0uP64zNhcYYpebHs=;
 b=S4k/kOVp9iymTKWYcQISrqqGG24e2WFgY+X4pRw2savCIrIONtgmAQrRTvBe/Jlt84Ut
 /HFkR229IGQaZZM+t1lRoahGwyk+PPTJMoSSBJsBLwHwqQoUt+kmZyV/ZYP42BwGUGli
 oyKGWGkfiULoC/QsoN9qRTUg2GuN7K0ugbZvIm/NXLct10AFToz7G56FfDEasKjmgOQ5
 GYY1hLtazl6+2CptCS3N8Kncix49oJgCwkreR6iVyWwek+XAIuVyQ/hIxrH2N3zTNu7/
 sGXkpJcMRJxkDC56WEK022NTDOdnLCKj0UWcbtJFh7dcR6s4wA1gTEEa+yba8IMhEuNs LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284mb8t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 00:21:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M0JHHw092123;
        Fri, 22 May 2020 00:19:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 315023beqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 00:19:51 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M0Jo1M022335;
        Fri, 22 May 2020 00:19:50 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 17:19:50 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: call statx directly
Date:   Thu, 21 May 2020 17:19:37 -0700
Message-Id: <1590106777-5826-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590106777-5826-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1590106777-5826-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=1 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220001
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Calling statx directly both simplifies the interface and avoids potential
incompatibilities between sync and async invokations.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 53 +++++++----------------------------------------------
 1 file changed, 7 insertions(+), 46 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12284ea..0540961 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -427,7 +427,10 @@ struct io_open {
 	union {
 		unsigned		mask;
 	};
-	struct filename			*filename;
+	union {
+		struct filename		*filename;
+		const char __user	*fname;
+	};
 	struct statx __user		*buffer;
 	struct open_how			how;
 	unsigned long			nofile;
@@ -3368,43 +3371,23 @@ static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 
 static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	const char __user *fname;
-	unsigned lookup_flags;
-	int ret;
-
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
-	if (req->flags & REQ_F_NEED_CLEANUP)
-		return 0;
 
 	req->open.dfd = READ_ONCE(sqe->fd);
 	req->open.mask = READ_ONCE(sqe->len);
-	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	req->open.fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->open.buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	req->open.how.flags = READ_ONCE(sqe->statx_flags);
 
-	if (vfs_stat_set_lookup_flags(&lookup_flags, req->open.how.flags))
-		return -EINVAL;
-
-	req->open.filename = getname_flags(fname, lookup_flags, NULL);
-	if (IS_ERR(req->open.filename)) {
-		ret = PTR_ERR(req->open.filename);
-		req->open.filename = NULL;
-		return ret;
-	}
-
-	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
 
 static int io_statx(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_open *ctx = &req->open;
-	unsigned lookup_flags;
-	struct path path;
-	struct kstat stat;
 	int ret;
 
 	if (force_nonblock) {
@@ -3414,29 +3397,9 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 		return -EAGAIN;
 	}
 
-	if (vfs_stat_set_lookup_flags(&lookup_flags, ctx->how.flags))
-		return -EINVAL;
+	ret = do_statx(ctx->dfd, ctx->fname, ctx->how.flags, ctx->mask,
+		       ctx->buffer);
 
-retry:
-	/* filename_lookup() drops it, keep a reference */
-	ctx->filename->refcnt++;
-
-	ret = filename_lookup(ctx->dfd, ctx->filename, lookup_flags, &path,
-				NULL);
-	if (ret)
-		goto err;
-
-	ret = vfs_getattr(&path, &stat, ctx->mask, ctx->how.flags);
-	path_put(&path);
-	if (retry_estale(ret, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
-	if (!ret)
-		ret = cp_statx(&stat, ctx->buffer);
-err:
-	putname(ctx->filename);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
@@ -5198,8 +5161,6 @@ static void io_cleanup_req(struct io_kiocb *req)
 		break;
 	case IORING_OP_OPENAT:
 	case IORING_OP_OPENAT2:
-	case IORING_OP_STATX:
-		putname(req->open.filename);
 		break;
 	case IORING_OP_SPLICE:
 	case IORING_OP_TEE:
-- 
1.8.3.1

