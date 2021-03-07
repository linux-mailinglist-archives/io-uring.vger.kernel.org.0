Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BE733002E
	for <lists+io-uring@lfdr.de>; Sun,  7 Mar 2021 11:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhCGKzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Mar 2021 05:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbhCGKza (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Mar 2021 05:55:30 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1341C061760
        for <io-uring@vger.kernel.org>; Sun,  7 Mar 2021 02:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=IxC1ng2QsXyXZE/9AJyObkep3sgTTWZwXSNYwKqOSfY=; b=c7gmeAxJFggZgVVyRaJWZR4SB1
        pEnrwnL51+WVq3vu4+c0VSEBAk8PTHwE7Myuw0pTLJWkufOhHROvZbkM2UpdBs0/8LATSrFaUkd81
        OZZ4e5xNoDxMLETYfeMt346gWFWIL/RrA2XfpFhUi0qyljkCDc3RcYi0rCvHRK4ICTVJaPWu+/hEr
        97ZWPoo1j7DJp1R3L/0zEliyygsly95akief9mG9ejna+M5sLcYHxm4azSesyVQDs9E12Sk8zEkRK
        Bu22d7DDuwk1iciYfpErxloccLLZQv+n1y0CHO3WjXp10WmN3wpxrpvmIfC0I+fQ0/7Pa9EZK60/u
        P71EVnnAr9no/ek9wsMiFHMMmoBNoESVSZID98EiQLn+cli20v9PvocLG/eEQOV39Da+C8cybY0DZ
        RjRwr+If9TRCAz4Cdh6lgRJACCFcqwB249iEBh9aUlu6dALMYZcl4mVzXLVH4fbRVghr7P6PgvavI
        LKU0KP5CL/eHDoFNUfMu9LjM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lIr47-0000O0-HE; Sun, 07 Mar 2021 10:55:15 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 1/2] io_uring: run __io_sq_thread() with the initial creds from io_uring_setup()
Date:   Sun,  7 Mar 2021 11:54:28 +0100
Message-Id: <20210307105429.3565442-2-metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210307105429.3565442-1-metze@samba.org>
References: <20210307105429.3565442-1-metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With IORING_SETUP_ATTACH_WQ we should let __io_sq_thread() use the
initial creds from each ctx.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3b8838123cc5..133b52a9a768 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -380,6 +380,7 @@ struct io_ring_ctx {
 	/* Only used for accounting purposes */
 	struct mm_struct	*mm_account;
 
+	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
 	struct wait_queue_head	sqo_sq_wait;
@@ -6719,7 +6720,13 @@ static int io_sq_thread(void *data)
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			const struct cred *creds = NULL;
+
+			if (ctx->sq_creds != current_cred())
+				creds = override_creds(ctx->sq_creds);
 			ret = __io_sq_thread(ctx, cap_entries);
+			if (creds)
+				revert_creds(creds);
 			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
@@ -7150,6 +7157,8 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 
 		io_put_sq_data(sqd);
 		ctx->sq_data = NULL;
+		if (ctx->sq_creds)
+			put_cred(ctx->sq_creds);
 	}
 }
 
@@ -7888,6 +7897,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			goto err;
 		}
 
+		ctx->sq_creds = get_current_cred();
 		ctx->sq_data = sqd;
 		io_sq_thread_park(sqd);
 		mutex_lock(&sqd->ctx_lock);
-- 
2.25.1

