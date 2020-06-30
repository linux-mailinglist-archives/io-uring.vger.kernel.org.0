Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FF320F778
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 16:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgF3Opv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 10:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgF3Opu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 10:45:50 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABAEC061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:45:50 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k1so8571134pls.2
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=tSW7eBksZE3b7445fKBP7+L9Y0c0uj0XOSf8oMJYLU8=;
        b=dvPOQ7fbqo9SPd8yyZbSoEnPR5jfD/+L/S01xgjhEnxLPisRsqW7R598haJq+tEIML
         3BCNcrLB2fWvUg7pHrSyCEZgdTd5XCoaeml6wG45YLAWtYAZOAs2yfbkhfzeVRWX0xFv
         1j14ct7rELZbd1fvXCR6nWQ9+w6IaN9vkdW31BbLFEs0Vl3vu8PYPnHPOQEoL1pmJT3S
         eJb7wMECMCe+HYllp8uCxc18beX0M/JL5FbXFq3wivbRdoFleoi5IFwBrWasO77BXJ+C
         6bT3L5svvgT13Cl3GdzPtqrv7GJYcKndjffypX7DjVmTX/lPiJQAqoTvQUoblx27MSH4
         qzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=tSW7eBksZE3b7445fKBP7+L9Y0c0uj0XOSf8oMJYLU8=;
        b=GwjsRmJrsMucpSr7bZeJdODTLfCgVEQFkqBjWYsvB8NNZx0sSndbgLxhvh/lHWoHiQ
         fuDzr1iSKa53k1TP3uRZ+OBfEnvqSqHfoQ6BkgO/9NtikURT0CV8VSzNMhR/0Prbng6R
         qfXvfCXroIJqjhM0wzu74t3vymDrICx4RI+Z9fBBk5yV81TDY9lcLFki5e2/pdaTMFk+
         l49BrILCunIG1LA/TTGGOX1br26yKoOQRt0pTnFSCfwfZyv52MHdRq7noOv6ALoj28cw
         KsdPx8zLpK4SzlHl7xQfUHx9MQE3K6HbwCqFVS0UoeEQaHWxI75pqnLfuZoIZgBIbuLs
         6q9w==
X-Gm-Message-State: AOAM530wlm+WVEDH/SHTI9mFbaPwkBK+0bHKvreBtS2wpTSALXQY2S86
        6qpKTir0ICLkA7hUPI8a8He4b2+aqVh3zA==
X-Google-Smtp-Source: ABdhPJzGLK1FEpa57qSK78voIknEtnN2O3a+xh4woM0IFyMP0hKrwn1Pz+XOTiy5lB4HyblLnz0s/Q==
X-Received: by 2002:a17:90a:304:: with SMTP id 4mr22066176pje.219.1593528349686;
        Tue, 30 Jun 2020 07:45:49 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4113:50ea:3eb3:a39b? ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id j26sm1420967pfe.200.2020.06.30.07.45.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 07:45:48 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: clean up io_kill_linked_timeout() locking
Message-ID: <fa6a7b43-bf4c-735a-f465-2ab223638d7b@kernel.dk>
Date:   Tue, 30 Jun 2020 08:45:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Avoid jumping through hoops to silence unused variable warnings, and
also fix sparse rightfully complaining about the locking context:

fs/io_uring.c:1593:39: warning: context imbalance in 'io_kill_linked_timeout' - unexpected unlock

Provide the functional helper as __io_kill_linked_timeout(), and have
separate the locking from it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9bc4339057ef..3c12221f549e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1569,28 +1569,38 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 	return false;
 }
 
-static void io_kill_linked_timeout(struct io_kiocb *req)
+static bool __io_kill_linked_timeout(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link;
-	bool wake_ev = false;
-	unsigned long flags = 0; /* false positive warning */
-
-	if (!(req->flags & REQ_F_COMP_LOCKED))
-		spin_lock_irqsave(&ctx->completion_lock, flags);
+	bool wake_ev;
 
 	if (list_empty(&req->link_list))
-		goto out;
+		return false;
 	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
 	if (link->opcode != IORING_OP_LINK_TIMEOUT)
-		goto out;
+		return false;
 
 	list_del_init(&link->link_list);
 	wake_ev = io_link_cancel_timeout(link);
 	req->flags &= ~REQ_F_LINK_TIMEOUT;
-out:
-	if (!(req->flags & REQ_F_COMP_LOCKED))
+	return wake_ev;
+}
+
+static void io_kill_linked_timeout(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	bool wake_ev;
+
+	if (!(req->flags & REQ_F_COMP_LOCKED)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+		wake_ev = __io_kill_linked_timeout(req);
 		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	} else {
+		wake_ev = __io_kill_linked_timeout(req);
+	}
+
 	if (wake_ev)
 		io_cqring_ev_posted(ctx);
 }

-- 
Jens Axboe

