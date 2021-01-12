Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3F42F3DE2
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbhALVs4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 16:48:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40582 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393293AbhALVgN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:36:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLYGsI005824;
        Tue, 12 Jan 2021 21:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ayhtN4eIkM8i/9wjY0V2fReyPM4t/0xsE6t1l25FzkY=;
 b=0ZHYDC1ym85CGYQrRGBHzeHXR0GzMUGgKcsubFIOCIzO47L9am40fMpy2pxGE+90yhNg
 jScox+yWzCUb8sZnTXNEgT+nUF8JyMTn4WOeisz30ZyvbYkrA8iTiPgsvDr9nfXyVxo6
 uTrROVHJCHwwl+gOmVzTeqjkN23rejeBuDEYeiVJx0qiCpHOTr5zohKlrF4LRYOiAZ09
 +lDyUi2bdrp1en54+PH76SYpHM1WoU4PE+hx8l/O72KG6QbeiF9mCbDDu0UReRSJ2LSV
 g9h+QJpvwZx+klNFcwGsR4vyfYOjV0Rrjqa4fJniVOQIQJW+CLBBbkjcbvX7KTwyAaBO bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 360kcyrkn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:35:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLEbdj105232;
        Tue, 12 Jan 2021 21:33:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 360kehsfy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:30 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10CLXTJb031646;
        Tue, 12 Jan 2021 21:33:29 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:29 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 12/13] io_uring: call io_get_fixed_rsrc_ref for buffers
Date:   Tue, 12 Jan 2021 13:33:12 -0800
Message-Id: <1610487193-21374-13-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120128
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_get_fixed_rsrc_ref() must be called for both buffers and files.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ab0ff1..37639b9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1079,12 +1079,11 @@ static inline void io_clean_op(struct io_kiocb *req)
 		__io_clean_op(req);
 }
 
-static inline void io_set_resource_node(struct io_kiocb *req)
+static inline void io_get_fixed_rsrc_ref(struct io_kiocb *req,
+					 struct fixed_rsrc_data *rsrc_data)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	if (!req->fixed_rsrc_refs) {
-		req->fixed_rsrc_refs = &ctx->file_data->node->refs;
+		req->fixed_rsrc_refs = &rsrc_data->node->refs;
 		percpu_ref_get(req->fixed_rsrc_refs);
 	}
 }
@@ -2921,6 +2920,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	req->buf_index = READ_ONCE(sqe->buf_index);
+	if (req->opcode == IORING_OP_READ_FIXED ||
+	    req->opcode == IORING_OP_WRITE_FIXED)
+		io_get_fixed_rsrc_ref(req, ctx->buf_data);
 	return 0;
 }
 
@@ -6453,7 +6455,7 @@ static struct file *io_file_get(struct io_submit_state *state,
 			return NULL;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
-		io_set_resource_node(req);
+		io_get_fixed_rsrc_ref(req, ctx->file_data);
 	} else {
 		trace_io_uring_file_get(ctx, fd);
 		file = __io_file_get(state, fd);
-- 
1.8.3.1

