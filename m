Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915172FBA7D
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391775AbhASOzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389132AbhASNiI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:38:08 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC42C061796
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:44 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m2so1311218wmm.1
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yY7Jn/nzZmg1R639vLwU26xQwu2dSAHo1SUMsrr0+bU=;
        b=uJd+6zdJoC2zMtAkQliH0IeMa0gCWwZiKftOL6CJDghYcThmbqHgp6YCBobjEW8tJc
         hOjN4p4YWGEkStmVkwD63Wnmu6SiuT+g9X3snK84Z/0fbfF1y4IsxsTLPxZzriPITcxW
         wdbVdCxCGkjCN2TQ1wBRjgmS6RKE/YeoIHx7OggVuptt+VKewFQ2p85T5IPSERAIIBW9
         RCnE6QPGVF86XF8vkIA+q8L8z0Tc6Toga/isHMmeA0oQci8um4C0plF1rNkwcurnt8S1
         uL671+pWVlZVQNR9ML4GBilgigbonSFciDdRlgeEkO9U1EJ29y7Dvo7ypj51aHoCa+bZ
         aNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yY7Jn/nzZmg1R639vLwU26xQwu2dSAHo1SUMsrr0+bU=;
        b=V/3kknp4vYtybyOEfKpgVCSyyJcaO+YY2twdCc9v7bnu0uzpW9HkQYQZhpGsrFtgme
         UVGjb84Ped0BQ5tvYq7W/D0Km8+sBZV1YU/FL4tZ5k5WFlO+3oJbAfIFYCTkJA19ThEH
         n182vPILJyN3S6kbW93KmizEdFZVKZQmviHpQmqcxnSZuwNgW1rgMqmY+IYc6sUemcxM
         TIz+dPm0qh0xlJ0sRMeaDrZlFlOMRDt0YPAYDk4/re+TYco2rqXUDDAOnaDMWfN3uUNs
         KrL5eEENsouldO+WJxgg3dmiZdFhrd0vz9pM4dg3i8GpNvXxY0motX0YR3BPbTgSqe/y
         7SBg==
X-Gm-Message-State: AOAM532Hz/AZvKVEiyUbuBx/xnvDYNwK3gW6wf1Ie0XEVDBe/F/OAK0f
        JPn0MD0716wZgdtAT1oUZePcCgRwm7fRYQ==
X-Google-Smtp-Source: ABdhPJyF+z6+2/U1BKNS2GXSeoA0Vk4N1g9A6xbH9OiK6TGVhyLv5JQMwqF8UitTmDmvjJ/OE1vAdg==
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr4072518wmq.63.1611063403151;
        Tue, 19 Jan 2021 05:36:43 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/14] io_uring: help inlining of io_req_complete()
Date:   Tue, 19 Jan 2021 13:32:45 +0000
Message-Id: <4ca07fa0795c558ca59f8e053bcb4cff996607c9.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_req_complete() inlining is a bit weird, some compilers don't
optimise out the non-NULL branch of it even when called as
io_req_complete(). Help it a bit by extracting state and stateless
helpers out of __io_req_complete().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a004102fbbde..b0f54f4495c7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1868,7 +1868,8 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static void io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
+static void io_req_complete_nostate(struct io_kiocb *req, long res,
+				    unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
@@ -1879,6 +1880,7 @@ static void io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
+	io_put_req(req);
 }
 
 static void io_submit_flush_completions(struct io_comp_state *cs)
@@ -1914,23 +1916,27 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 	cs->nr = 0;
 }
 
-static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
-			      struct io_comp_state *cs)
+static void io_req_complete_state(struct io_kiocb *req, long res,
+				  unsigned int cflags, struct io_comp_state *cs)
 {
-	if (!cs) {
-		io_cqring_add_event(req, res, cflags);
-		io_put_req(req);
-	} else {
-		io_clean_op(req);
-		req->result = res;
-		req->compl.cflags = cflags;
-		list_add_tail(&req->compl.list, &cs->list);
-		if (++cs->nr >= 32)
-			io_submit_flush_completions(cs);
-	}
+	io_clean_op(req);
+	req->result = res;
+	req->compl.cflags = cflags;
+	list_add_tail(&req->compl.list, &cs->list);
+	if (++cs->nr >= 32)
+		io_submit_flush_completions(cs);
+}
+
+static inline void __io_req_complete(struct io_kiocb *req, long res,
+				     unsigned cflags, struct io_comp_state *cs)
+{
+	if (!cs)
+		io_req_complete_nostate(req, res, cflags);
+	else
+		io_req_complete_state(req, res, cflags, cs);
 }
 
-static void io_req_complete(struct io_kiocb *req, long res)
+static inline void io_req_complete(struct io_kiocb *req, long res)
 {
 	__io_req_complete(req, res, 0, NULL);
 }
-- 
2.24.0

