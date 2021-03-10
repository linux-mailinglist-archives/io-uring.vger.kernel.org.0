Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9973E334BCA
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhCJWol (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbhCJWoL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:11 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AED2C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:11 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u18so9214198plc.12
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/169Xyn1JmSkJx1e4eqE3DNITjGVrffT7BYU35x5cs=;
        b=13fiy4ZotVG/JNHrCb9YlAl2qgU8qQ908OxqpyPXfqtu9eTrFwplHRWttM4BN3093J
         qZToPsjXLERKJss4WYwMkM+6UyahQd8hdOzg5sFxoa0rIe45YsCYnThmLPrH3ugCT5M9
         vEDx1y7OasnDebx4IEtbn8JAWd1HpGXVm+ESLDdXVvulC5gbMdmphtj8aKEK31d0ba4I
         JT0Fo1SP7n4veeh5gqsEeIohmP455/AqwL+AsRLVHmEWrjxQHP3BdnlGk1IwRiwdsCiu
         kOQ8bwPzLMqOIV8Xe3A/yFVIgLmm4uX5NE28qGxUxRQIF9PiJB764tI2LRsSGThNyWLe
         Lg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/169Xyn1JmSkJx1e4eqE3DNITjGVrffT7BYU35x5cs=;
        b=VPfsmRCmp7QgLNIj6m4LP0YO0Og6Cj86HtrzqkcqbPC879TV4eiLOyd2yIRBFW0f4h
         CKiEKSxzF0KhebOlQxkmoGyXIX3dKibJU9RMnExtwgfom2lJfYBQvSo5pfpiTqVbIypZ
         RcXQxLhFHIIb+ZMuAB+Vaj9AvivsXmGQPtpTRFOh6iX3aoexoZy42xhJB0sRJZITN4Pf
         X/3F/HTzBcFO9E22HS+G+CRe40HZk12fpCSo/Mz7dU05PwfxVR9a8xpGR0J7+RzPaSLZ
         FUL3u6dEOvZeSvwywWiKLr/kSvg5ujhYfaAkCIu/BYbBOuIIaMb40xvswXPTEQ6EUaLL
         qD2A==
X-Gm-Message-State: AOAM530COpxeqPdL6wb+DZ7ocwNHrpS913RdYKLDej+Gmwgy38iuAoWO
        rNWw4bnYqpMQP214SoixKXeJveRuXRLmAg==
X-Google-Smtp-Source: ABdhPJyT+4HXAGzdDGL3Jyf4rQUPzMEhax3Pu7pmHaXp48lky/AJ1LViLfjjIiF2gVldimcZ0a2hlw==
X-Received: by 2002:a17:90a:c289:: with SMTP id f9mr5784185pjt.105.1615416250936;
        Wed, 10 Mar 2021 14:44:10 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/27] io_uring: don't take task ring-file notes
Date:   Wed, 10 Mar 2021 15:43:37 -0700
Message-Id: <20210310224358.1494503-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

With ->flush() gone we're now leaving all uring file notes until the
task dies/execs, so the ctx will not be freed until all tasks that have
ever submit a request die. It was nicer with flush but not much, we
could have locked as described ctx in many cases.

Now we guarantee that ctx outlives all tctx in a sense that
io_ring_exit_work() waits for all tctxs to drop their corresponding
enties in ->xa, and ctx won't go away until then. Hence, additional
io_uring file reference (a.k.a. task file notes) are not needed anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8a4ab86ae64f..f448213267c8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8821,11 +8821,9 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 			node->file = file;
 			node->task = current;
 
-			get_file(file);
 			ret = xa_err(xa_store(&tctx->xa, (unsigned long)file,
 						node, GFP_KERNEL));
 			if (ret) {
-				fput(file);
 				kfree(node);
 				return ret;
 			}
@@ -8856,6 +8854,8 @@ static void io_uring_del_task_file(unsigned long index)
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
 
+	if (!tctx)
+		return;
 	node = xa_erase(&tctx->xa, index);
 	if (!node)
 		return;
@@ -8869,7 +8869,6 @@ static void io_uring_del_task_file(unsigned long index)
 
 	if (tctx->last == node->file)
 		tctx->last = NULL;
-	fput(node->file);
 	kfree(node);
 }
 
-- 
2.30.2

