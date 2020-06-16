Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D1C1FC261
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 01:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgFPXgW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 19:36:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40124 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgFPXgV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 19:36:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNWLmL040877;
        Tue, 16 Jun 2020 23:36:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=k6PIalYXpzOX88AyXrLiEOv8L6n5Qid4HjVLiRVZFW8=;
 b=fWM4FQKyzN+wSF1U654d/jMAKsOa0svkFdzz6IAydEM/73RDJHqEr3ufNovbecyBvfCe
 CnbhAYPfZH6kdN8kynX08VqLzvcqYqdrUWR5AtYrhZ6tmusF44jof2aFpnunvcNR/Al9
 8EjabyQ8a7HqaNuyh2B91StmK+e1T2ghwnuzDi3vyALu9rtOehsjgo+KA1zTVRmRBwKZ
 Ot+xotQV4dFKYcYmivwHoQLpCDvAP+wCQ8golMBLyybTz9ISX9IEj8LQGy0osMc1iONG
 Sp227UK9V120MNMqOI5nriIRJZuAV6xV001R+KbOslhk+olLEdok0Ht/Ibq91Ka46hBg Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31q65yr9ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 23:36:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNT5ls049733;
        Tue, 16 Jun 2020 23:36:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31q66maswf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 23:36:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05GNaGV3019775;
        Tue, 16 Jun 2020 23:36:16 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 16:36:16 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: rename ctx->account_mem field
Date:   Tue, 16 Jun 2020 16:36:08 -0700
Message-Id: <1592350570-24396-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 suspectscore=3 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160162
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rename account_mem to limit_name to clarify its purpose.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ebd3f62..0bcbc1a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -226,7 +226,7 @@ struct io_ring_ctx {
 	struct {
 		unsigned int		flags;
 		unsigned int		compat: 1;
-		unsigned int		account_mem: 1;
+		unsigned int		limit_mem: 1;
 		unsigned int		cq_overflow_flushed: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
@@ -7055,13 +7055,13 @@ static inline int __io_account_mem(struct user_struct *user,
 
 static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
-	if (ctx->account_mem)
+	if (ctx->limit_mem)
 		__io_unaccount_mem(ctx->user, nr_pages);
 }
 
 static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
-	if (ctx->account_mem)
+	if (ctx->limit_mem)
 		return (__io_account_mem(ctx->user, nr_pages));
 
 	return 0;
@@ -7882,7 +7882,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 {
 	struct user_struct *user = NULL;
 	struct io_ring_ctx *ctx;
-	bool account_mem;
+	bool limit_mem;
 	int ret;
 
 	if (!entries)
@@ -7921,9 +7921,9 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	}
 
 	user = get_uid(current_user());
-	account_mem = !capable(CAP_IPC_LOCK);
+	limit_mem = !capable(CAP_IPC_LOCK);
 
-	if (account_mem) {
+	if (limit_mem) {
 		ret = __io_account_mem(user,
 				ring_pages(p->sq_entries, p->cq_entries));
 		if (ret) {
@@ -7934,14 +7934,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 
 	ctx = io_ring_ctx_alloc(p);
 	if (!ctx) {
-		if (account_mem)
+		if (limit_mem)
 			__io_unaccount_mem(user, ring_pages(p->sq_entries,
 								p->cq_entries));
 		free_uid(user);
 		return -ENOMEM;
 	}
 	ctx->compat = in_compat_syscall();
-	ctx->account_mem = account_mem;
+	ctx->limit_mem = limit_mem;
 	ctx->user = user;
 	ctx->creds = get_current_cred();
 
-- 
1.8.3.1

