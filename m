Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5422D1D29
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgLGWSu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:18:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43694 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgLGWSt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:18:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9q3c132248;
        Mon, 7 Dec 2020 22:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=5yaruAs6fD3AgQoTwQLInNq0UME1OflyJpRbvZZeyz4=;
 b=QYC0cqiyTh+hhJdYdq0L+OUMPczmIhPs5VQh0tPTWQiRXFZDB8GCntgzrEo3hvH5ACZF
 +pE0maEbvmKFqgV3vz5vIyL+/BgxrxWA8GNjuRzpYplempwtYn4z3APPEFLLmpZnMLG1
 hJvaMm53rcyVUnmFtBtI9vDVLlceBz/jyDm54TFbV37LkoKfgKdEHCmZ0LUKhoafHrLC
 fGUPaM+P33d/SrDhebjHAdRIF/iag7QHl0Hib5l9HmlUX32EVTBFCQS9GQWQtSIfqq7i
 vX/B7DI3DrwnMxTSKVCO6yDisoiZQ9lELtp+8dXffmGWVwHEaA081kojPVIK+PnmSwGF 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3581mqqvbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:18:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MAV9a064039;
        Mon, 7 Dec 2020 22:16:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 358m3wxb9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7MG54C004824;
        Mon, 7 Dec 2020 22:16:05 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:04 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 04/13] io_uring: rename fixed_file variables to fixed_rsrc
Date:   Mon,  7 Dec 2020 14:15:43 -0800
Message-Id: <1607379352-68109-5-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Change fixed_file_refs names to fixed_rsrc_refs, and change
set_resource_node() to io_get_fixed_rsrc_ref() to make its function
more clear.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2b42049..33b2ff6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -733,7 +733,7 @@ struct io_kiocb {
 	u64				user_data;
 
 	struct io_kiocb			*link;
-	struct percpu_ref		*fixed_file_refs;
+	struct percpu_ref		*fixed_rsrc_refs;
 
 	/*
 	 * 1. used with ctx->iopoll_list with reads/writes
@@ -1060,13 +1060,13 @@ static inline void io_clean_op(struct io_kiocb *req)
 		__io_clean_op(req);
 }
 
-static inline void io_set_resource_node(struct io_kiocb *req)
+static inline void io_get_fixed_rsrc_ref(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->fixed_file_refs) {
-		req->fixed_file_refs = &ctx->file_data->node->refs;
-		percpu_ref_get(req->fixed_file_refs);
+	if (!req->fixed_rsrc_refs) {
+		req->fixed_rsrc_refs = &ctx->file_data->node->refs;
+		percpu_ref_get(req->fixed_rsrc_refs);
 	}
 }
 
@@ -1964,8 +1964,8 @@ static void io_dismantle_req(struct io_kiocb *req)
 		kfree(req->async_data);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
-	if (req->fixed_file_refs)
-		percpu_ref_put(req->fixed_file_refs);
+	if (req->fixed_rsrc_refs)
+		percpu_ref_put(req->fixed_rsrc_refs);
 	io_req_clean_work(req);
 }
 
@@ -6397,7 +6397,7 @@ static struct file *io_file_get(struct io_submit_state *state,
 			return NULL;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
-		io_set_resource_node(req);
+		io_get_fixed_rsrc_ref(req);
 	} else {
 		trace_io_uring_file_get(ctx, fd);
 		file = __io_file_get(state, fd);
@@ -6766,7 +6766,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->ctx = ctx;
 	req->flags = 0;
 	req->link = NULL;
-	req->fixed_file_refs = NULL;
+	req->fixed_rsrc_refs = NULL;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
-- 
1.8.3.1

