Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77B92EC537
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 21:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbhAFUkQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 15:40:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44928 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbhAFUkQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 15:40:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KXQKa101792;
        Wed, 6 Jan 2021 20:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=8sc3U3PmmOlNqzrryimvM6ui30iv/5oSijD2G38ebmo=;
 b=TaVepjCtDsoPnWnAqb2yw/rZEQuZv0VHXC6QO3q0hl3RRnOtT1LlxtvQ3DSTDh0hIIOs
 yhiRRzwsunbKfL+cx5dp1vIcpkdcfzicW0180Y7445pISgSsM6s8GIgQek5yEaQVywTa
 807q9Y4UIr4pRxWbXCBKrPWS8yhp0YGbYWtG5PEUMwuSFohmZ9FXE82GaMFm1/m61kTS
 uR5lQPtmsPZw0RsYHWbTe6zdPDj+2hkA9vSvNFSqmTEgD/PhTOD0PzMsd0z6zSjqyRjx
 Cb3QE+LHgSA9aE4HXKPp9XrWYiqWlkjCWtc6SxaliA8mclURIdJJguFb/BAGcDNmQERw pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35wftx9bsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 20:39:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KZbN6145471;
        Wed, 6 Jan 2021 20:39:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35w3g1jf1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 20:39:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106KdVZY027124;
        Wed, 6 Jan 2021 20:39:32 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 20:39:31 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v4 04/13] io_uring: generalize io_queue_rsrc_removal
Date:   Wed,  6 Jan 2021 12:39:13 -0800
Message-Id: <1609965562-13569-5-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Generalize io_queue_rsrc_removal to handle both files and buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c5d8c3..88baa13 100644
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
@@ -7557,8 +7568,9 @@ static int io_sqe_alloc_file_tables(struct fixed_rsrc_data *file_data,
 	return 1;
 }
 
-static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
+static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
+	struct file *file = prsrc->file;
 #if defined(CONFIG_UNIX)
 	struct sock *sock = ctx->ring_sock->sk;
 	struct sk_buff_head list, *head = &sock->sk_receive_queue;
@@ -7627,7 +7639,7 @@ static void __io_rsrc_put_work(struct fixed_rsrc_ref_node *ref_node)
 
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
-		io_ring_file_put(ctx, prsrc->file);
+		ref_node->rsrc_put(ctx, prsrc);
 		kfree(prsrc);
 	}
 
@@ -7706,6 +7718,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->rsrc_list);
 	ref_node->rsrc_data = ctx->file_data;
+	ref_node->rsrc_put = io_ring_file_put;
 	ref_node->done = false;
 	return ref_node;
 }
@@ -7863,8 +7876,7 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
-				 struct file *rsrc)
+static int io_queue_rsrc_removal(struct fixed_rsrc_data *data, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
 	struct fixed_rsrc_ref_node *ref_node = data->node;
@@ -7873,7 +7885,7 @@ static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
 	if (!prsrc)
 		return -ENOMEM;
 
-	prsrc->file = rsrc;
+	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &ref_node->rsrc_list);
 
 	return 0;
@@ -7882,7 +7894,7 @@ static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
 static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
 					struct file *file)
 {
-	return io_queue_rsrc_removal(data, file);
+	return io_queue_rsrc_removal(data, (void *)file);
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-- 
1.8.3.1

