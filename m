Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD6233A818
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 22:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCNVB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 17:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhCNVBS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 17:01:18 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20F8C061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:17 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o16so4701917wrn.0
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Q0EmV+OtdoGwPI7T6HqCd/uQDtHk+yQ0AYYFAqCfni8=;
        b=n9PGK5yAq7SD1qN2+7NclZtVOzrx4kfrmpl6Ubdgzw9aHFFbT49A2ChXrhcKxpdfC0
         +LIDWo8osCPnduXbUfANnwGbv2BcTZt1j6QNuVi41SpcnSLmRLzc1DoeK6Z6pON9Q0qs
         e/Ovo3/S/O5ovemQjzmMYAxey8X4FFyvhunGMoteIosV9vwuBDMCzF2VwmHYL+DuNJtj
         fPp5rMNizvlyb38m3nczOZUDbnSaMwOCAxdbxno9rbpD2U6GloL4Yz5vLWPt8NwUs7xd
         WaYtq6dHokuxFWLbtYZiA5AZovZsDxRw62MTpiDMa+Ag3D8EEb/wgZ7rXF/tktSfHyMn
         SK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q0EmV+OtdoGwPI7T6HqCd/uQDtHk+yQ0AYYFAqCfni8=;
        b=Duf1RWqHpcErUoiviGpEVKIiGnAMqJvffphgUbKUCYnjjgNUmXLRH7sL5GcDKhChzl
         pPUQBOxKmd6XV6ZHGXRtVyHUwow/ri8RurU++tIXOLTPGbAaYTIDdTMVZ3ZLJvK0EIpK
         oNTi+kXLHl++9iK7hxThBNBpJGlJnE1kYoCcdvxPgMhCNZm1faRDEMIb1MBarqLNBn4Y
         7vZL7SpzhEYHDFCHh7PnbWbdZ6anZZ5AmYU+KxQXd0Zkw8PVYTOfgXdm7ZPxUqM57v1E
         PXlhbqyHrMutfl5g6b2crWzy4vAa0npNMA2BmnpIcGxhoLc/BDJQ19CXW5/N+cP1N50W
         KupQ==
X-Gm-Message-State: AOAM530jOfloNioi16q1S/Mg2eSz3LwD/XzPXk/kPPqVx0stuHynZ2VD
        dqcyF1WxN7WqfXPdLksAc722n/J+wzW+XA==
X-Google-Smtp-Source: ABdhPJyZGEBwTe61PqSsjfw0EBBLPMUcbi/bQV1NKvmKws5TOKHi5OUbiqw9EzB9EtQQyR/Gic1eFw==
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr24183156wrr.297.1615755676646;
        Sun, 14 Mar 2021 14:01:16 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.154])
        by smtp.gmail.com with ESMTPSA id q15sm16232527wrx.56.2021.03.14.14.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 14:01:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: fix ->flags races by linked timeouts
Date:   Sun, 14 Mar 2021 20:57:08 +0000
Message-Id: <d6fc2ca1d9718df7720f23b88284cfe0b231d5ec.1615754923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615754923.git.asml.silence@gmail.com>
References: <cover.1615754923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's racy to modify req->flags from a not owning context, e.g. linked
timeout calling req_set_fail_links() for the master request might race
with that request setting/clearing flags while being executed
concurrently. Just remove req_set_fail_links(prev) from
io_link_timeout_fn(), io_async_find_and_cancel() and functions down the
line take care of setting the fail bit.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 642ad08d8964..4fd984fa6739 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6197,7 +6197,6 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-		req_set_fail_links(prev);
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req_deferred(prev, 1);
 	} else {
-- 
2.24.0

