Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DC32335F3
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgG3PqR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbgG3PqP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:46:15 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B77BC061575
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:15 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id bo3so5811244ejb.11
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lkVNRGqvovpkO0vvfjPZf4RMrKCDcojcYbtJ9ZUqSHg=;
        b=KLSQuNL+7Ogo1FaNe3TXhqCisHcMLP7U9cApXn0HzDFGZIzsPJ9+84NJHg/mqaUKwK
         GMcW+NiyaK/llX1UC4k8Jrm53m21e2EPkCKubYBx9xSmc3T1eHcjO704p3N3o0WaKuom
         jR4Y50tQOehpva9AS3lV86b1JhR6+znqoYv34VrimUVRevUMGUadfGpIy0Toft9d2qRb
         Crs/VRh9ob8YdW/Rv0oeFOTEXLf3sNJe3MnxrLrpagY97naWqTpw/ylQN/HsR6t1gbOx
         hi8ilzsx2ooIKHxy5M67F1kpuDU7zt+7yT3Amf6YNlfU9jDPTEjYU5++som+bcvmLP5B
         VnKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lkVNRGqvovpkO0vvfjPZf4RMrKCDcojcYbtJ9ZUqSHg=;
        b=au/LTbBy0HSzXtB6BRCmpS0uJgnZbAj6r9gXV5mXj8ObOSr1M/3HnicKQh6NfzSTwv
         gwUCss9Q/mrlMf9pewmWCsXll6O740UpxAGtmVZm+eHIi4n6KK2V5N0XqtWJukdA5HVH
         Zq4Db2Df652+ii18H+AY9Qajvq+RXKLyVRaqO6Ia+DV0DuHuMc6v4uwZWTdxvH+/ywg0
         DPziqAVfD6AxGy/fZYGr+N77c0YWX9Za7p5/3zY8CeKwRfgKAe56f9c39PFyayzyqYBV
         HC4KNoME7hQ71jpMBtFEjWnMvEOrMIS/H/IPHhM14YvNP99aREs3osmVCNMaMAdM1fTw
         sFWA==
X-Gm-Message-State: AOAM531PF/hB7CkycZP4Q8hgBy/BGS8pNwgwgBqq8IvpstDlIPw7sZNp
        hjyL1CjanhGSnEzZhlcWTCY=
X-Google-Smtp-Source: ABdhPJwodrHt4r4h3QLMvAKbMSq7Iq6asfwZKJ1F1RFt131mF0UUnKL4BxS2ErI6YvqJAzyEzUYh4w==
X-Received: by 2002:a17:906:17c1:: with SMTP id u1mr3156191eje.536.1596123974311;
        Thu, 30 Jul 2020 08:46:14 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g25sm6740962edp.22.2020.07.30.08.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 08:46:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/6] io_uring: get rid of atomic FAA for cq_timeouts
Date:   Thu, 30 Jul 2020 18:43:50 +0300
Message-Id: <9ef9e3f5b7e473dfa1f362a86f6afb6e54c2b4ba.1596123376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1596123376.git.asml.silence@gmail.com>
References: <cover.1596123376.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If ->cq_timeouts modifications are done under ->completion_lock, we
don't really nee any fetch-and-add and other complex atomics. Replace it
with non-atomic FAA, that saves an implicit full memory barrier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index efec290c6b08..fabf0b692384 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1205,7 +1205,8 @@ static void io_kill_timeout(struct io_kiocb *req)
 
 	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
 	if (ret != -1) {
-		atomic_inc(&req->ctx->cq_timeouts);
+		atomic_set(&req->ctx->cq_timeouts,
+			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
 		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
@@ -4972,9 +4973,10 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
-	atomic_inc(&ctx->cq_timeouts);
-
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	atomic_set(&req->ctx->cq_timeouts,
+		atomic_read(&req->ctx->cq_timeouts) + 1);
+
 	/*
 	 * We could be racing with timeout deletion. If the list is empty,
 	 * then timeout lookup already found it and will be handling it.
-- 
2.24.0

