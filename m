Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592E634ABF3
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCZPwt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhCZPwO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:14 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8920C0613BC
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:13 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z3so5838516ioc.8
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rN2PgEUoE0VAabXTyRei4LXsCskRh+40CD93NSR8D88=;
        b=KJ3URsr2+El4FxfCA8c7L51+fhXuXtrsjZWFWyHE7R6k9nTc1M1DlINsINUJirgUPB
         Z3wZpiceIuWWtTJQGTpkH81BrxXE0dP7vWS8VyTyZ0GxJtAnfpYu/9U/bTunxyCglnV2
         k0C4L+vUQfHrmvzRBqPDqXVxXOSFxpfijM8uZzeGrxWbiwbsW2FrASsyTTbCJPmZWi3C
         /CkCeJW6rxcExu8d4zzYvZbYjyhmdDP1E0Nwl1JVIUXH4QrubWe3Cb5kITSHSxy5SqZr
         qazYNDOQvkrtCOzIoaIjQGVtShsjA35zEfyjFkgvEBMb6dpMuWpdderVewkojUfWElfD
         8ikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rN2PgEUoE0VAabXTyRei4LXsCskRh+40CD93NSR8D88=;
        b=E4aHNzONy+WfuZsuCIWZzJMO0OT/LWXn7ZGRxFtebFFBZFIG9p4OmsJ1ScaV8hb1z9
         qRbDrkzgLVHo3tkGUxOHx6EU9RVtOVj4cA3TyNFaXukVBi8jpjldwaNZhBo+8yE/nbtn
         aQX363rZcNQG/E3FrvIwlN5rRvxMJAD/g6tERwck5OTaBDMuFhF+ZUxsZNDai0sCYELB
         WPrIJ55929quW8oMDgNbcNZ/RnuIUm86sVBi5QL4GN9RCacLPgMbvsywHOkcrskdzXun
         LDZLwa0G4WLzqRNBgMMZtuy5RekaUcBJ8Xgc+sL9DJEQ5VUshsQK9TLTBcZ1PjPt8T8C
         FpSQ==
X-Gm-Message-State: AOAM532CJRNtkY1OaApLuNPwxfAQQIKeSlc/YTsE2TkRgKI2gS7lsTb7
        Ln7YbW6MMvkihHg2C702mmPYcLk1wyzmXQ==
X-Google-Smtp-Source: ABdhPJwbc9ed6etEN77W64nWaH3EB8QHDF36SzXvH0lrD5tJF02+SGtboS+GTw/fc3JkC5P7hE7VTg==
X-Received: by 2002:a05:6638:ec7:: with SMTP id q7mr12573466jas.54.1616773933022;
        Fri, 26 Mar 2021 08:52:13 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/10] io_uring: fix timeout cancel return code
Date:   Fri, 26 Mar 2021 09:51:25 -0600
Message-Id: <20210326155128.1057078-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

When we cancel a timeout we should emit a sensible return code, like
-ECANCELED but not 0, otherwise it may trick users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7b0ad1065e3bd1994722702bd0ba9e7bc9b0683b.1616696997.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 350418a88db3..4d0cb2548a67 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1247,7 +1247,7 @@ static void io_queue_async_work(struct io_kiocb *req)
 		io_queue_linked_timeout(link);
 }
 
-static void io_kill_timeout(struct io_kiocb *req)
+static void io_kill_timeout(struct io_kiocb *req, int status)
 {
 	struct io_timeout_data *io = req->async_data;
 	int ret;
@@ -1257,7 +1257,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req, 0);
+		io_cqring_fill_event(req, status);
 		io_put_req_deferred(req, 1);
 	}
 }
@@ -1274,7 +1274,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		if (io_match_task(req, tsk, files)) {
-			io_kill_timeout(req);
+			io_kill_timeout(req, -ECANCELED);
 			canceled++;
 		}
 	}
@@ -1326,7 +1326,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 			break;
 
 		list_del_init(&req->timeout.list);
-		io_kill_timeout(req);
+		io_kill_timeout(req, 0);
 	} while (!list_empty(&ctx->timeout_list));
 
 	ctx->cq_last_tm_flush = seq;
-- 
2.31.0

