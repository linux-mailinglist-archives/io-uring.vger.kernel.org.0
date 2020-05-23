Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43831DF4DA
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 06:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387446AbgEWEdo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 00:33:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387430AbgEWEdn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 00:33:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4X79R075131;
        Sat, 23 May 2020 04:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=csR/9uQq7g8oWxg9R0qkRysbmLcV7PGtH5ro26drzUA=;
 b=X26SHZfcC5ceklgwnHLJdETBKFWMQtAQ6Wgg5Wi+r0BRtkr3ou3e9bz9BnE3YArJW0JE
 SH4lui60C1CBn/gBVtgrlyjMwzJIodStCXOmCj3/v2WdNH9mDZcRVPLZlbmK9Ha53Jxn
 Q7mguJZYxNIzaCnn9zz0/HmSDXqrA7U5JqQvm6RLLMs5iLPaST+U+K80ul2FerB72SI4
 nPXCcRUToiX2ilX5Chx4eTNDRvi0s5S3ZydGEMpfyx7rUcwdt3SgGkqK+W/phZDPgm8s
 f7vNwE8JAg99ra0dOBdMMBrTSKn8BxBhmkarrz+K5iXVt6B+F9ZTtHUV1AR7oUNT5tQF rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 316uskg2t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 04:33:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4StMX128581;
        Sat, 23 May 2020 04:31:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 316sv8pet2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 04:31:41 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04N4VdXh014355;
        Sat, 23 May 2020 04:31:39 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 21:31:39 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 3/4] io_uring: call statx directly
Date:   Fri, 22 May 2020 21:31:18 -0700
Message-Id: <1590208279-33811-4-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=1
 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 lowpriorityscore=0
 suspectscore=1 spamscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 cotscore=-2147483648 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230036
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Calling statx directly both simplifies the interface and avoids potential
incompatibilities between sync and async invokations.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 50 ++++----------------------------------------------
 1 file changed, 4 insertions(+), 46 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fba0ddb..e068ee5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -481,7 +481,7 @@ struct io_statx {
 	int				dfd;
 	unsigned int			mask;
 	unsigned int			flags;
-	struct filename			*filename;
+	const char __user		*filename;
 	struct statx __user		*buffer;
 };
 
@@ -3374,43 +3374,23 @@ static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 
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
 
 	req->statx.dfd = READ_ONCE(sqe->fd);
 	req->statx.mask = READ_ONCE(sqe->len);
-	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	req->statx.filename = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->statx.buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	req->statx.flags = READ_ONCE(sqe->statx_flags);
 
-	if (vfs_stat_set_lookup_flags(&lookup_flags, req->statx.flags))
-		return -EINVAL;
-
-	req->statx.filename = getname_flags(fname, lookup_flags, NULL);
-	if (IS_ERR(req->statx.filename)) {
-		ret = PTR_ERR(req->statx.filename);
-		req->statx.filename = NULL;
-		return ret;
-	}
-
-	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
 
 static int io_statx(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_statx *ctx = &req->statx;
-	unsigned lookup_flags;
-	struct path path;
-	struct kstat stat;
 	int ret;
 
 	if (force_nonblock) {
@@ -3420,29 +3400,9 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 		return -EAGAIN;
 	}
 
-	if (vfs_stat_set_lookup_flags(&lookup_flags, ctx->flags))
-		return -EINVAL;
-
-retry:
-	/* filename_lookup() drops it, keep a reference */
-	ctx->filename->refcnt++;
-
-	ret = filename_lookup(ctx->dfd, ctx->filename, lookup_flags, &path,
-				NULL);
-	if (ret)
-		goto err;
+	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
+		       ctx->buffer);
 
-	ret = vfs_getattr(&path, &stat, ctx->mask, ctx->flags);
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
@@ -5204,8 +5164,6 @@ static void io_cleanup_req(struct io_kiocb *req)
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

