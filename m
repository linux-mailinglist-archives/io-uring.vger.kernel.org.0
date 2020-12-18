Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE292DE8C5
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgLRSIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:08:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgLRSIX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:08:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3wJ0160567;
        Fri, 18 Dec 2020 18:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=tS81DgQYTOsrXIhyypdlHBrZ1cqU0TuE1Q2CQjEeAsU=;
 b=CpM4xkezjuKFNdNqxWa9MqfITsEm6qC7pedPX671xUpzROifVkBYsMG4bSF0S3pgPVvR
 X2CeSmOTDB6r0ElcloSQuZL3tA0F8j6PQwtW5+yiAcGZ25PYPOjbvhpL5RamVzyE96eu
 AIWL+UOSh6EC7ejOp0XxJUvOHAYBYGF+vH4WzQqSEFoX55KWZHxnzYf3kKN0yUg6U9rM
 EWkHCTyi+RCti+j0S45+m0kLZpUNcpE8MwLXlnrZspCxVIPS3Vbcfzme2bO7EKHjSpbS
 IAMAoqs07S0Ea0YgQaXH22NPKr3E5kMMWp9iy4/f8KEBR29FFe43EP2Lcvh3eeE2WBch iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35cntmkfkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:07:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5Rl0095930;
        Fri, 18 Dec 2020 18:07:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35e6ev0xnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII7cRe003601;
        Fri, 18 Dec 2020 18:07:38 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:38 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 04/13] io_uring: generalize io_queue_rsrc_removal
Date:   Fri, 18 Dec 2020 10:07:19 -0800
Message-Id: <1608314848-67329-5-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
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

Generalize io_queue_rsrc_removal to handle both files and buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a14f1ba..c47f2ac 100644
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
@@ -7526,8 +7537,9 @@ static int io_sqe_alloc_file_tables(struct fixed_rsrc_data *file_data,
 	return 1;
 }
 
-static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
+static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
+	struct file *file = prsrc->file;
 #if defined(CONFIG_UNIX)
 	struct sock *sock = ctx->ring_sock->sk;
 	struct sk_buff_head list, *head = &sock->sk_receive_queue;
@@ -7596,7 +7608,7 @@ static void __io_rsrc_put_work(struct fixed_rsrc_ref_node *ref_node)
 
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
-		io_ring_file_put(ctx, prsrc->file);
+		ref_node->rsrc_put(ctx, prsrc);
 		kfree(prsrc);
 	}
 
@@ -7675,6 +7687,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->rsrc_list);
 	ref_node->rsrc_data = ctx->file_data;
+	ref_node->rsrc_put = io_ring_file_put;
 	ref_node->done = false;
 	return ref_node;
 }
@@ -7836,8 +7849,7 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
-				 struct file *rsrc)
+static int io_queue_rsrc_removal(struct fixed_rsrc_data *data, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
 	struct fixed_rsrc_ref_node *ref_node = data->node;
@@ -7846,7 +7858,7 @@ static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
 	if (!prsrc)
 		return -ENOMEM;
 
-	prsrc->file = rsrc;
+	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &ref_node->rsrc_list);
 
 	return 0;
@@ -7855,7 +7867,7 @@ static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
 static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
 					struct file *file)
 {
-	return io_queue_rsrc_removal(data, file);
+	return io_queue_rsrc_removal(data, (void *)file);
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-- 
1.8.3.1

