Return-Path: <io-uring+bounces-1483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD5689E7C6
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 03:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FB9D2843E1
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 01:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D0A391;
	Wed, 10 Apr 2024 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Onr6nkP5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D92865C
	for <io-uring@vger.kernel.org>; Wed, 10 Apr 2024 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712712433; cv=none; b=MSkjhjoYlag+iaZ4pkdwrse5vYdQmt366cw9NrW6ti69+Q13QzwMeETCbSvs63VWMf+Qtkb+p6Qn1bMZn7z+6qbyfhAJfEqSkWX4Wyj5+R980jj45wqp2s8RSsDpE2ybIaLLykxRk9dpQa0rid4g2PY/0k/vkdetWE3iIFlnuTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712712433; c=relaxed/simple;
	bh=3ukB7rgy9eN+tu/3UVQoUkyNBH6lutv+Ep5PTj8gU3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSgbf9Jj1UzbScZx+9lxkgpOPvoqdKQNXMiuu/lYX3DgILVQKeafjrFQwb1ipy4Etx/wgK0zYG5Up4+dYmMNJCbMstBxfwb/3W2u4sNrkW7zOrB/K/PEyaT3LFTpU6eZnXkJtmaFppeZ2qX/DPku/4PQBO41Bj3oZ6u7kXYNxNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Onr6nkP5; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3462178fbf9so582421f8f.1
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 18:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712712429; x=1713317229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0LSk2ZnzPF0+Dkd4LZNo7M6iJ8DiupkfPWyBVZ3fxk=;
        b=Onr6nkP5C188UNjeSi/pHDNsAMLYEBOgSOFcHGa4hFmLRMwoJNaDANeK57oRdX9Ha3
         zePUhKvQ6fcqSCZlkmibQp4U+36v6vjLVEF5YSj5W6Wagbu8iBhZ27lex6HfHf3TMJaT
         zA2kCMwHhXl3PwFEZgMu/4xVycnE4nbKyV6f8OFNWvKzVvGOF+LRmpUt6XzQfKt1a0cP
         cov0LaV7NQIQX1u7KBQsexXPtNj5I4EL571iWtJH3u9vjO9f7XGY6QptKiKNfKF3Podq
         T1EpSKPIUrbYjcGn8chcF6SXqrYM0vRrleMCdVQR5b4097ikArfynO8I8iieT4rkyd9A
         La/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712712429; x=1713317229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0LSk2ZnzPF0+Dkd4LZNo7M6iJ8DiupkfPWyBVZ3fxk=;
        b=vjoUk52mLhuIP5necjkBwl8biOYRkptVGhOazzrzaHkSi6B+pGdGzh7uc8BcMueXGJ
         gOLQmSes/TbxOg3CKxkfBr0FEIWxnLnINzBUfKQTWss5RN8URDkgqEUUtfnTxRJZXZro
         Fla72JjqEENchY17etNzb8jk3I7tkHCE1iVK9akHDYoKwcUM6oKsjaaSivhJGBkGYYtZ
         E4hsIWBY+hl3DVyoU2ruWSNXEqy/9Uwj+97DbGNy7Kg2PoICevpNdaoGr0n7YkWk1xea
         xMrCdBSi+Ip3NuBD3jsT23e5rCgxXmboHhcMPrFSj7dbzIHbdVyuduS00j7Hz6d3nYKZ
         9vXw==
X-Gm-Message-State: AOJu0Yy260onIww65rco45CSMtnoQbP1ap7zRyp3Aw1ma89dzDolt9KU
	LUKU8H1lZfUL4RUMU0tSxyId0ZPOIpdS8BmWam4QWzkc+tYe9AGJewuhOcDc
X-Google-Smtp-Source: AGHT+IGmEqFw/p0OeGWUDzJVLGovCFdd0MpgfGSE2JSkNDcS+Jj7R0aejjbaPk3tDoNuYubE/h6neQ==
X-Received: by 2002:adf:f783:0:b0:33e:69db:bf9e with SMTP id q3-20020adff783000000b0033e69dbbf9emr1097470wrp.67.1712712429483;
        Tue, 09 Apr 2024 18:27:09 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id r4-20020a5d6944000000b00343b09729easm12737693wrw.69.2024.04.09.18.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 18:27:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 1/5] io_uring: unexport io_req_cqe_overflow()
Date: Wed, 10 Apr 2024 02:26:51 +0100
Message-ID: <f4295eb2f9eb98d5db38c0578f57f0b86bfe0d8c.1712708261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712708261.git.asml.silence@gmail.com>
References: <cover.1712708261.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are no users of io_req_cqe_overflow() apart from io_uring.c, make
it static.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8df9ad010803..7e90c37084a9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -819,7 +819,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-void io_req_cqe_overflow(struct io_kiocb *req)
+static void io_req_cqe_overflow(struct io_kiocb *req)
 {
 	io_cqring_event_overflow(req->ctx, req->cqe.user_data,
 				req->cqe.res, req->cqe.flags,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 1eb65324792a..624ca9076a50 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -62,7 +62,6 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 }
 
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
-void io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
-- 
2.44.0


