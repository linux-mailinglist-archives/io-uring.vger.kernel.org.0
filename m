Return-Path: <io-uring+bounces-985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1707B87D65E
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4654A1C22105
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 21:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2869746544;
	Fri, 15 Mar 2024 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HFXaLInw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735B0481BA
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 21:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710539251; cv=none; b=BL78IfI0xBfDVp2lMq8+2CzyeT4d+2AFh2Noc923X2T77+th1pkTlTw9UaP7IvLT/dlHP3KASu5a4ef79OA8o06rOPMkTGzixAJ6o74vlOBerK+FWllOkEgYz5Yup1CwhBCFF/jtwsD7iPgdcXtP7xoo/rBxqT9xjLDlD/rGZCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710539251; c=relaxed/simple;
	bh=j9NhxQQrGcKYlrA72sJUr+2amqXP/8iB15dKRw8WgEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmRKCL2iCHJOSWoDy4Id6ofElqhJvfevJRtwz233sTc77NeNDpJZ1jom7/scLuHTUwm4MMEwE/4tThYKaWOIe9PAwekEIw0yrOiXF/NA9CfDPdLq7HQj3HtaxQde1vGRuhJyIScWWGwjMuyeJCfJ4K5r70X5KWs0OY3pj7RadpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HFXaLInw; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-41402466fb8so6117085e9.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 14:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710539247; x=1711144047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxQKVMLtAtMT4U+g+357Xz8uc4uGRjSVOIaXOKfo2ks=;
        b=HFXaLInwhB3Rjbx1wqelptcHrxjn49GyLJOV0542D4ge4My6RxkIHIvcUgCX/wR2wa
         j7HLPqpMmaCQ6q7on4kdJL/akgnTH46DV7lrLVMoAMG/J2GT8QsqaeYDmwilkPCtcaDO
         a5csOlQAnscnVzRNfne0KQeZcbQCDkFrjDJqIYThoySm6FjLiciYJs3RB6/URpUS1XY+
         2TxDn/T1dZYVPJerk9r7PKQuv+AE9eVmhUn9hO3ZFJTbjFwrkOb3JbpAxgz8gXk7ripz
         LAa2LWW29X6jBaZImZHVyxQG83cYV5QHMKoEiUFw2fSnm/7YrPJCFQMi8aiuTb7eUnLW
         RzCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710539247; x=1711144047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pxQKVMLtAtMT4U+g+357Xz8uc4uGRjSVOIaXOKfo2ks=;
        b=gJUb9nwBD4Lkbbf8mQCyQNtn4BE5ECXSVRqOPfC4x6dHLPer1pCVxWJ5+g/uvloMsq
         13Ofd57O9DN7SbswvQdHd8X6Uot+sQ+W9+jB3LWI2JlpDDRDakU4MyQWTkxQ+XKCxjvi
         YahzVI6RcqZIZp02k3yDEYFtdjXPsUDXy5nZ45aipawFPQjOq85IFqCYyjQMM0240pBL
         1g1VzcJQm31Esyo/qxXHvkzOyRk+0QhMUSS4tv7tE8mWLrD0uNLqvPMkmYqTF7NA6shO
         W2RuS7w0g91JJZb/IDOKDS/41W//iVK5aKx7L69OBFIS6YklLMIkTXcl+FZtEXHuzwCY
         eA+Q==
X-Gm-Message-State: AOJu0YwtzgmdiBJ5iUAP3ocaBUR6jnbg2l2qFBduW/wG2cH5wKmIHN5Y
	I+82muQApJeV2MgE26Rg4maKpzvuiiTwPoA1q2lTNhHhY9ol0sLNL6fE/HNi
X-Google-Smtp-Source: AGHT+IFJTsXSS2W9IJN3GtoxBJlbZTS95R+WLk1wyGUmB/JVQN3INu8ggTfvGWunQus/JdiLocEUPw==
X-Received: by 2002:a05:600c:4f91:b0:413:2852:2835 with SMTP id n17-20020a05600c4f9100b0041328522835mr4426778wmq.17.1710539246953;
        Fri, 15 Mar 2024 14:47:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id m15-20020a05600c4f4f00b004130c1dc29csm7040881wmq.22.2024.03.15.14.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 14:47:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring: remove current check from complete_post
Date: Fri, 15 Mar 2024 21:46:00 +0000
Message-ID: <c6a57b44418fe12d76656f0a1be8c982f5151e20.1710538932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710538932.git.asml.silence@gmail.com>
References: <cover.1710538932.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

task_work execution is now always locked, and we shouldn't get into
io_req_complete_post() from them. That means that complete_post() is
always called out of the original task context and we don't even need to
check current.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 023fcf5d52c1..025709cadab9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -978,7 +978,7 @@ void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (ctx->task_complete && ctx->submitter_task != current) {
+	if (ctx->task_complete) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
-- 
2.43.0


