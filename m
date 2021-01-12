Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1972B2F3E03
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbhALWAz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 17:00:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47084 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437183AbhALVeP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:34:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLXXoa114953;
        Tue, 12 Jan 2021 21:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=lnOu16bjKKAkYFQiBWyPSBXV51RsYyhzwEbyq5ijBIM=;
 b=KUUQdrn72L4Z6xyA3BOPqDuziZBiEZAo3z56rIV8Qbh00c7MMsf6X6eJ7Jhj+pDzKx9C
 QP8h88uFrOZBPQg72mU3d1mNfr/wcDSDTNSzWE99IYl4/fQKTiYmcMSBtU0Uwp2AKzXg
 6JAX7vJnHWWL8SSvlqGez3OSHKqfsldnAXv+Ca0C+1c5UY60stkKnxHoTD4NzjSt0of4
 VOvqo/FWjMoNK6MriGtLpiFB7MP36mTsOCwx6YnLtGrh1atvWmbujVnV67gUuRisxgpK
 DrLfCUF5k/vftOaml0Tk90UG6JsHlEwHHbtYkzWGXZTb9JrMkGjmqg7KeXoBqqpCiL+7 Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 360kg1rk02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLEcS1105365;
        Tue, 12 Jan 2021 21:33:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 360kehsfww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CLXQBk011344;
        Tue, 12 Jan 2021 21:33:26 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:26 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 02/13] io_uring: generalize io_queue_rsrc_removal
Date:   Tue, 12 Jan 2021 13:33:02 -0800
Message-Id: <1610487193-21374-3-git-send-email-bijan.mottahedeh@oracle.com>
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

Generalize io_queue_rsrc_removal to handle both files and buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 195ba12..12eede8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -195,13 +195,22 @@ struct io_mapped_ubuf {
 	unsigned long	acct_pages;
 };
 
+struct io_ring_ctx;
+
 struct io_rsrc_put {
 	struct list_head list;
-	struct file *file;
+	union {
+		void *rsrc;
+		struct file *file;
+		struct io_mapped_ubuf *buf;
+	};
 };
 
 struct fixed_rsrc_table {
-	struct file		**files;
+	union {
+		struct file		**files;
+		struct io_mapped_ubuf	*bufs;
+	};
 };
 
 struct fixed_rsrc_ref_node {
@@ -209,6 +218,8 @@ struct fixed_rsrc_ref_node {
 	struct list_head		node;
 	struct list_head		rsrc_list;
 	struct fixed_rsrc_data		*rsrc_data;
+	void				(*rsrc_put)(struct io_ring_ctx *ctx,
+						    struct io_rsrc_put *prsrc);
 	struct llist_node		llist;
 	bool				done;
 };
@@ -7552,8 +7563,9 @@ static int io_sqe_alloc_file_tables(struct fixed_rsrc_data *file_data,
 	return 1;
 }
 
-static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
+static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
+	struct file *file = prsrc->file;
 #if defined(CONFIG_UNIX)
 	struct sock *sock = ctx->ring_sock->sk;
 	struct sk_buff_head list, *head = &sock->sk_receive_queue;
@@ -7622,7 +7634,7 @@ static void __io_rsrc_put_work(struct fixed_rsrc_ref_node *ref_node)
 
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
-		io_ring_file_put(ctx, prsrc->file);
+		ref_node->rsrc_put(ctx, prsrc);
 		kfree(prsrc);
 	}
 
@@ -7701,6 +7713,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->rsrc_list);
 	ref_node->rsrc_data = ctx->file_data;
+	ref_node->rsrc_put = io_ring_file_put;
 	ref_node->done = false;
 	return ref_node;
 }
@@ -7858,8 +7871,7 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
-				 struct file *rsrc)
+static int io_queue_rsrc_removal(struct fixed_rsrc_data *data, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
 	struct fixed_rsrc_ref_node *ref_node = data->node;
@@ -7868,7 +7880,7 @@ static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
 	if (!prsrc)
 		return -ENOMEM;
 
-	prsrc->file = rsrc;
+	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &ref_node->rsrc_list);
 
 	return 0;
@@ -7877,7 +7889,7 @@ static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
 static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
 					struct file *file)
 {
-	return io_queue_rsrc_removal(data, file);
+	return io_queue_rsrc_removal(data, (void *)file);
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-- 
1.8.3.1

