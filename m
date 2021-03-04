Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932C732D9C8
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhCDS5z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbhCDS5r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:47 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E29C061762
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:32 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id e10so28598135wro.12
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WDhgHjmLzz8YLNluAywStLsLsPBY94SJvWVb1ieS7AE=;
        b=ZS2bTpOney2l/DlWuQ7dpcEhl021C495HRDyRic/26h80IUwWR3wkt61D7WvYwcweS
         DAzdLf4wBRpQN+fkIX4gJOqevqn7clDXH3846iV98JrlftOQZFm8QuM89rfgv2gL3yde
         on8YOGuNSNQc/jfPR9aC+uktGD1Rksge2xmEea6DGXlLZZHMsVTUf0Q0F4NVX0fuLgYT
         +5xTd52fbKRH6qqJgh6kRIerxgPsWGAK4nC5YXxOzY1+DCimzkqlPb6QRAXEMNlgcrqx
         DiTLEnF/72MbchFIw9QxSCAg54CdMW6p/c9Fpnn0a5A5J9uHiFF5KJeOoJOvDy7PcLdO
         UqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WDhgHjmLzz8YLNluAywStLsLsPBY94SJvWVb1ieS7AE=;
        b=DNIe51IAKsDyADLqYD63twZmgb0YyN5UtGJDJRewQuAId5Ehn5F7r0Sve9QLDMfx7O
         0qR6tfIs6Cd9OabWwVIcNnbdGKH1Xvzw17DDYOSitmXRAUyidFxsosfcQaI+lfMYAKiC
         PB+ZAfBMh3CfejE/tKI/9mdY8QU2pvssS0Afdv23iuh7vfY751atcDo/NHl5ALe8gVFJ
         0z2jDrWUNp6QZj38b5h3H2rrJF+UJ4Z8Zp0fmjwFBt00J8gw1RLW+jIWlkImrllVcMIf
         1DC5PPZi/9Nc0IwyMpdjcEaHdSBMb02x9Cq0KNbPD05gkpAfu58ikiKCcqheSCGiUjSg
         Ty2A==
X-Gm-Message-State: AOAM532hp+5tr+gfl41K2J+j9yrufKg3dnmZOgw6HfbaSeISK/scDG82
        z56q6WqXee+WXIIttIxHmMw=
X-Google-Smtp-Source: ABdhPJyrPOdsQs3tv6C8m+vAmkXbZonNRVYsj6fT4MJRe/HVuTlZ9vLlrTS77gPFWDjg9Bk+U4Z64g==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr5505394wrt.203.1614884190762;
        Thu, 04 Mar 2021 10:56:30 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:30 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/11] io_uring: optimise io_dismantle_req() fast path
Date:   Thu,  4 Mar 2021 18:52:19 +0000
Message-Id: <96304060dca30e94a523879cd47cf04c5d106e0a.1614883423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put REQ_F_WORK_INITIALIZED check together with slow path
REQ_F_NEED_CLEANUP/etc. Also don't reload req->flags twice but cache it
in a var.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d50d0e98639b..c4ebdf1f759f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1670,24 +1670,28 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 
 static void io_dismantle_req(struct io_kiocb *req)
 {
-	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
-		io_clean_op(req);
-	if (req->async_data)
-		kfree(req->async_data);
+	unsigned int flags = req->flags;
+
 	if (req->file)
-		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
-	if (req->fixed_rsrc_refs)
-		percpu_ref_put(req->fixed_rsrc_refs);
+		io_put_file(req, req->file, (flags & REQ_F_FIXED_FILE));
+	if (flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
+		     REQ_F_INFLIGHT)) {
+		io_clean_op(req);
 
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_ring_ctx *ctx = req->ctx;
-		unsigned long flags;
+		if (req->flags & REQ_F_INFLIGHT) {
+			struct io_ring_ctx *ctx = req->ctx;
+			unsigned long flags;
 
-		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		list_del(&req->inflight_entry);
-		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
-		req->flags &= ~REQ_F_INFLIGHT;
+			spin_lock_irqsave(&ctx->inflight_lock, flags);
+			list_del(&req->inflight_entry);
+			spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+			req->flags &= ~REQ_F_INFLIGHT;
+		}
 	}
+	if (req->fixed_rsrc_refs)
+		percpu_ref_put(req->fixed_rsrc_refs);
+	if (req->async_data)
+		kfree(req->async_data);
 }
 
 /* must to be called somewhat shortly after putting a request */
-- 
2.24.0

