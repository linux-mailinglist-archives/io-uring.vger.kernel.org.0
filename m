Return-Path: <io-uring+bounces-1547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5AC8A4FF4
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 14:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E25A1C20756
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 12:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B86127E01;
	Mon, 15 Apr 2024 12:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d3EQmJpM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A62126F38
	for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 12:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713185414; cv=none; b=oOJxcEneQUyVzrTkOwkzhMTC4+app8ZxmBG1GsDm+kGdlDj8lsPyNEQxFTr0QECAQsEmOIr/RZ3XssizgwU7ekqpPHVvJMPe2WVjrN7FBL3WCkmnNWDG9LgORpQU4JX6DOt2xwE53gkMq950z6d1RVSOInJ5BZ/1AXGfNZImijk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713185414; c=relaxed/simple;
	bh=CHCF8k6Kh5Xm/SQkuxGeqHbf4NgLSHUbwK3H3HZoOog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNb8ygCuBt99oR95OmEQpQ1EwqzzgYGpYUSWceA0WOEMT8BEHG44xleYRWyxUgfCHFQT0xl3cdbJPzjV9XZ2PeLrnwjxZm59ofBC5VuFQzKBaJNFZ4Osr0ELBLvwzQzHM9HQwLDpZpO6D7dYJ62e8fOdcgw14MnuKig3cku2FJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d3EQmJpM; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-346b94fa7ecso3060907f8f.3
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 05:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713185411; x=1713790211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMVAnWOzczCOg7Kso9czT9v06/sxRgMSvtaGJ+5gesY=;
        b=d3EQmJpMeN1M5aEtfpO5uLp+5aVNCeTDELnOgi+TuOmPXGK3bQ4CtL7Q8rCm9g9WGd
         O8zryYnWLDvVm1hAAQ+HiZ1XpLHsLLp6Tjx8f4ZgZ/I14p0He4yGHBEfVqbZkyIgcPEZ
         yKEioAvFnfk8pb4QriQIJVGLErMYKgE8Y7EosiuUcEsdUbLQkPPrZlgcg0xRes89gpwO
         VGuPZjabxs4Hty39r7omd9zejBSmHdl6RSaLCZr8aqoRFwPQhq923kF9jAN/NPxMw33q
         XVou7O3ePSERVN3Lje9hsZ0B4SqFsKUQkStRN0pWCV6zyvWWvO24faLVLbe1TFcj2ELR
         QU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713185411; x=1713790211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMVAnWOzczCOg7Kso9czT9v06/sxRgMSvtaGJ+5gesY=;
        b=R2eCLEUjWeYQzabnoQYP5TlZTf4gx/rZxmho8/zH1CM03ESeYfsq2GOBzoRcnNFb77
         Zqp/10L6dK9qqt1BfmO/xUV396mMGoQxzo8A0HIXrwq3/8qSftnXa51ueh25C2J74sB0
         yB6IYp2uiugmSQCwGCwJmGPXcp3jCFvsl3iEqiF2aaISklOhIwO3Mip6QV8JJmfBd5o0
         A3ZD98yEgE6v6KkxnAVESULq0Y89ZQCh0LmmIGsM7KtuSebvxRJDZBfzn4GWws9XX8sJ
         VMCNGMp7NnOQbCTzqp4SvF6kiV1UueZttAH7SjzLnvWuBupaSC4EQnR69sVLnrGUq4VR
         2yDw==
X-Gm-Message-State: AOJu0YzEUGg50jmDerofsS72sfxjVd6UZkLFUqpnGf4HaGP2cIuk+xgu
	VqMY5/VqklHMjLMfrF4oNnfU2aUwP83BnleYsUsih6eBMZB7FPY9XgFu5g==
X-Google-Smtp-Source: AGHT+IFxRO7srSNwRVEg38vUHHB/rITW5jIflQ2eitYmxqmH8XbiqvdStGFvtY9fV7fBmnrjry4PWg==
X-Received: by 2002:a05:6000:1a8b:b0:347:9e5a:3078 with SMTP id f11-20020a0560001a8b00b003479e5a3078mr3952423wry.1.1713185410788;
        Mon, 15 Apr 2024 05:50:10 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-93.dab.02.net. [82.132.213.93])
        by smtp.gmail.com with ESMTPSA id h15-20020adff4cf000000b003432ffc3aeasm12022170wrp.56.2024.04.15.05.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 05:50:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [for-next 1/3] io_uring/notif: refactor io_tx_ubuf_complete()
Date: Mon, 15 Apr 2024 13:50:11 +0100
Message-ID: <43939e2b04dff03bff5d7227c98afedf951227b3.1713185320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1713185320.git.asml.silence@gmail.com>
References: <cover.1713185320.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Flip the dec_and_test "if", that makes the function extension easier in
the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index b561bd763435..452c255de04a 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -37,10 +37,11 @@ static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 			WRITE_ONCE(nd->zc_copied, true);
 	}
 
-	if (refcount_dec_and_test(&uarg->refcnt)) {
-		notif->io_task_work.func = io_notif_tw_complete;
-		__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
-	}
+	if (!refcount_dec_and_test(&uarg->refcnt))
+		return;
+
+	notif->io_task_work.func = io_notif_tw_complete;
+	__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
 }
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
-- 
2.44.0


