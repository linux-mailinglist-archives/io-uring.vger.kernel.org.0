Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BD432EBD7
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 14:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhCENDH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 08:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhCENCu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 08:02:50 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CA7C061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 05:02:50 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id w7so1369034wmb.5
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 05:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+ObTNgSd09eRQpAwnn8xtmEA4U5DFkTVKZtzsEwS5f0=;
        b=cFuqVkaeQioq6UcGDJXqboEd0cJ/I34AJHKrhScYPlhVonTWUQX0neAwBX8rKdkECC
         /tOyfY4E+2QzyNyW4WHIFNtxmrLFSIXYO3YH2dwiDysArE79N/rv2i/85BuWzb99R31G
         9wIJFzoFPwN3DoiINNR/Q0zXQj1mcQ1Ny7LZh3wY4dx3rIc9qHyKg2MrZcCCz9Juj0WB
         doVSn77nrC5S7bLGdmx4Y92aMCLAw0FyumvXjES/vK7T9LXwZtppMji/Wa8sBPbuivA/
         nT4GRaMYiJzwx1WCez3B3z8JytjmeDRVI805fDkqC8FoJ4QIkFPNRSjKzo8wIcdloEHZ
         Volw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ObTNgSd09eRQpAwnn8xtmEA4U5DFkTVKZtzsEwS5f0=;
        b=jsy2WraKzsZ5lkM/1VhkPMeuHF2fj2cHLP5IU+TYEDQWyqRn1hWsnm7FRAlnXb8NbR
         kjHS9XxCab4M/xcoZq+Z3qIwGTOr3IWdNFKbixkKyWz4aa7NUG3stRVdWAYUojmwOl6U
         05wP96LG60G1N/GSbCprzp2tGUYJ5rD8/m5mm4MgYby8t4ozxfb9poQ3NtPYFz9hR+mP
         lpnwA1Qn8/JiJmKqXudd0o/3SMtmMbiwJF/59p4uU1Sp+P3zy19Oz90nbd3I2ql29+SQ
         pyGINwHzq5LJ0Gk8G4qZNt797AYmgxuPfYKDOonUgg3fy1Ugdf7NSi5PhDe/FCDNsiGs
         n6RA==
X-Gm-Message-State: AOAM531dMC5NUNlHk+gKKMsLEEhMHQ9EY8WxUM9SZJd4BISKgs7tgwcG
        UQ8ffOfNwd68paA6cHc0LAB3/itsjMds0A==
X-Google-Smtp-Source: ABdhPJwKjP9A2fJlwF6A8F0ItVDIkHZ4sx89fTFcdjlee4+izpQ52GHaJIDWTCVcc1Y7oJnI4H0Vxg==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr8785936wmj.76.1614949368907;
        Fri, 05 Mar 2021 05:02:48 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id h20sm4345385wmm.19.2021.03.05.05.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 05:02:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 6/6] io_uring: warn when ring exit takes too long
Date:   Fri,  5 Mar 2021 12:58:41 +0000
Message-Id: <30036d3b1c7c1bd9a57f0f7787f18d94ad57e8c3.1614942979.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614942979.git.asml.silence@gmail.com>
References: <cover.1614942979.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use system_unbound_wq to run io_ring_exit_work(), so it's hard to
monitor whether removal hang or not. Add WARN_ONCE to catch hangs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92ba3034de64..116d082a248f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8552,6 +8552,7 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
+	unsigned long timeout = jiffies + HZ * 60 * 5;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
 	int ret;
@@ -8564,10 +8565,14 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
+
+		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 
 	mutex_lock(&ctx->uring_lock);
 	while (!list_empty(&ctx->tctx_list)) {
+		WARN_ON_ONCE(time_after(jiffies, timeout));
+
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
 		exit.ctx = ctx;
-- 
2.24.0

