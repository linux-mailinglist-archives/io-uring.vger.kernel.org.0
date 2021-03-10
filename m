Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798FC334BCF
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhCJWom (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbhCJWoQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:16 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78288C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:16 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id w8so2446292pjf.4
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4GUWC0zErNLyPWwsx1ktFxyX361EiTLRAH2+zmX1Iss=;
        b=JwGDP6SUQWDVn7zRPi0XBS+HgBGFpM8q61CdE2h5w3FHWldfKYDI6t8pkyoyBFgn+9
         u7PjLJZBfKYBzr/okIEefwUEHkdvwY6mjam01XilMrgQN55hwRO4JzlpgB78AenK8vqQ
         hq2dj6uGUHISreonHXhqeAL7BD64kzWp06uGl4C2kiiQoHsBltHvZvJNAOlxdp1o4dMh
         +s/L5vnb3FHFR999l3fWayb998lJ2miygUPGElBaLFcSm6W0RmBDeWZXdTTKMLNpLeyt
         p2NLQvhvsRdHXd6nQLiWY4IgDSLY5147obrWUhS+2DKjc1U99BbinI7aEcZ+4EzAQbBX
         ld4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4GUWC0zErNLyPWwsx1ktFxyX361EiTLRAH2+zmX1Iss=;
        b=U3vd5o4Fvf7RFS+VBoyZB8wo5CgrlRUbjygc4Y6/8OkbEnLyLFvJFvsqffAFSlHC1X
         DM0nb6RJ1F42DwyQ2jnoXOSX1bLtHFCBdAZByrvXITQc80UZHMwjLS/8fsSZEN97MgI7
         rHBv2JXS9WtPw94mxNdjei3vjBWaB5JPu2umQeLqAF6lOKY9WkAhiXr4ejF8QYgVPTFV
         Pxlia9CW5E+ANtT9m3R1l8R/iUHK7QbiKrHHx3or/+DN2ON0s3l4YWE6qXelW6zniKPB
         1ZHBoSLtYi68Ar6H4A4yqnTXqhoCQ5926jjJnicsh5H4jhSib+9IZjCumUZMrLToJgJ2
         Moew==
X-Gm-Message-State: AOAM531x0GgYTdhWw6XYe8WAExaMOeRwJ9XMmTOnz5fOb8DoM52eYchl
        MpgEIRMMzlNz+auVMtvr4jfbAqfRKnuNhA==
X-Google-Smtp-Source: ABdhPJwnaW5pBXesv0hiRXM29W/KlEvtsjCDgusbjdLWfgIiOGAQLM02f1XPM5T8Xkg6kjIEoFwiJg==
X-Received: by 2002:a17:90a:55ca:: with SMTP id o10mr5559152pjm.173.1615416255817;
        Wed, 10 Mar 2021 14:44:15 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:15 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/27] io_uring: run __io_sq_thread() with the initial creds from io_uring_setup()
Date:   Wed, 10 Mar 2021 15:43:42 -0700
Message-Id: <20210310224358.1494503-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

With IORING_SETUP_ATTACH_WQ we should let __io_sq_thread() use the
initial creds from each ctx.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8c74c7799960..4d3333ca27a3 100644
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
@@ -7152,6 +7159,8 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 
 		io_put_sq_data(sqd);
 		ctx->sq_data = NULL;
+		if (ctx->sq_creds)
+			put_cred(ctx->sq_creds);
 	}
 }
 
@@ -7890,6 +7899,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			goto err;
 		}
 
+		ctx->sq_creds = get_current_cred();
 		ctx->sq_data = sqd;
 		io_sq_thread_park(sqd);
 		mutex_lock(&sqd->ctx_lock);
-- 
2.30.2

