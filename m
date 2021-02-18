Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C8431EEFB
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhBRSwX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbhBRSgg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:36:36 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A47C061A2B
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:52 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id n10so4843019wmq.0
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wxOhdz7WBLAuwrBQC4Rj4MCuTO8JEwrFm+bR0joYRWg=;
        b=kETWqFAygxj+DSl0LznIgYgXmWDmQGpZTUwXa0lWWx8a9WVGz4KVHNCfJFpH5Ydxwn
         vnguuZQypgSZssiDI2VnsZGITWARzDqtqx4gsOSlaHjpvkzKIEsWLMFBkGMx1k05vZwb
         85XoIK07EKUNBov2WfRlzAI7034CiYe196XY4GD3gJAv38Re7th+BUtP0ZlvaoLqpZoN
         pgKao6U3MdKk6PsxrchAoIF4gk7+gresFvs5wORaVUJXUfWXHFBnIHp4tb2gOfMGDPPe
         maFZ1XBAmhHBP7mmLxaA8Z4+fSQWhs5wdaRM1x51LHWR1++LMJS+IbOwxUzIiSKJ9vVt
         w0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wxOhdz7WBLAuwrBQC4Rj4MCuTO8JEwrFm+bR0joYRWg=;
        b=W9Qhx3SCdq9rKl1+EkVIHKab2lR/3eRFZvcJWE+Tk1gcD8bkZDKphacAZLdmu5z/Lz
         wSryDF+kirrqta3P981ssn1l574qzrtfNFcI7lbUQLa9f0G5TDyDGum4kMHwtZnUkmBW
         DRqpaRZ64q6WfHc8r7/gE5li/nR+KIbEklbaqvR77Xa0xk3+j/WSkj/MEqFXxfE6ovNq
         RtRVMSS9PuQz0maUEErI7M3HUAFPe3LtwmvwvZR8hrTno5QD1vrIDa7Fj/JYT79vy2V6
         zuNx5vAwLun/Qb4OUSnMzZmVS50HAGUiOKwWsitI2pZGRrzk+iZ4xmLjLNvdSGfudPmh
         sG8A==
X-Gm-Message-State: AOAM530KIzAorKUr3EMgZ0dyKhkpApgMo+pyNyZGcvgc1TQiEtoKXZQi
        0TWyfvOo7hULMiFX+ze82VOmbUgT681n8w==
X-Google-Smtp-Source: ABdhPJxFmanTqUPQmcSaumy8jdkSQm8NktthO0tbu0TUhbT2AA/ftPyRsAFuiZZQhwOwKmd51GIx0g==
X-Received: by 2002:a1c:a795:: with SMTP id q143mr4793800wme.113.1613673231226;
        Thu, 18 Feb 2021 10:33:51 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/11] io_uring: don't submit link on error
Date:   Thu, 18 Feb 2021 18:29:43 +0000
Message-Id: <f239e685be6b1ec9110a7b79d57f52e51a120206.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we get an error in io_init_req() for a request that would have been
linked, we break the submission but still issue a partially composed
link, that's nasty, fail it instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fe2379179b00..62688866357c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6763,6 +6763,9 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 fail_req:
 		io_put_req(req);
 		io_req_complete(req, ret);
+		/* fail even hard links since we don't submit */
+		if (link->head)
+			link->head->flags |= REQ_F_FAIL_LINK;
 		return ret;
 	}
 
@@ -6791,11 +6794,8 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			ctx->drain_next = 1;
 		}
 		ret = io_req_defer_prep(req, sqe);
-		if (unlikely(ret)) {
-			/* fail even hard links since we don't submit */
-			head->flags |= REQ_F_FAIL_LINK;
+		if (unlikely(ret))
 			goto fail_req;
-		}
 		trace_io_uring_link(ctx, req, head);
 		link->last->link = req;
 		link->last = req;
-- 
2.24.0

