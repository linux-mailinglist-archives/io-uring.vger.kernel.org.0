Return-Path: <io-uring+bounces-2564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E788B93B033
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:16:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D9A31F215E5
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 11:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2EA6155C88;
	Wed, 24 Jul 2024 11:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8K8S9Be"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09DA14A4EF
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819768; cv=none; b=YC1KAKaHOotY60vHNuK7XNswLT7q4zLadPDVIGsEQZ95WcTNmgBHowNIB9ByoIgqQLOlQr1vN+mv5oMyLDxSAdX+5rZo9t7HVYwPIgC40zszVEyzSjJJbTo5g4L7xMPRTCkzk+yEwjeRmYenVAat8/uRwHKJkVcBK/CneYy+64U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819768; c=relaxed/simple;
	bh=3sdvc815DW75anbjVVeV+zP+kZVDiZoG/xwWKJkzMrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtwZEn2ctZjt3uuG91MC3ICqPI0jICkFR6xStnj0uSKG/MUHo6iVGM9FTmqPzUw3/4jiKYP9pn1van1fgDx2410stKQyStwA/77aqutH0uw5expN8zVAaIeikcSDQ3teNnyZIixu50DnYUBWYKef5hL0SL9jKlrRixYH8jUfJx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8K8S9Be; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-595856e2336so1394236a12.1
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 04:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721819765; x=1722424565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/70Vkq2b20w7LRsi+Hhz8GdJRzslLKPyFL21ZYqpEk=;
        b=H8K8S9BeE/w6B3wRBIHoO2BhxU2FRXPWC07IaQO7KVfWSYuzZRZjud6S2XI06aEJqV
         jGVEGpiQLPhevii5/ENmL4/puVjDxeqhuAuqGws1PqZGfUI3/StNxcH5VFrY+6dMm8FT
         vOQwdx4XgGngfyZy1bvFmUVbrJpy+02RFBe7E6USph+oqWtNoB1YriBthTbRFp9zzpXT
         hCrUjEHqshcT8Kd/2T2b6FuL+hYCOyRhdkbbbYMo10EvhD60Bsn8oaY0NgcMQQLMiHxL
         s9GkT52seqQnVsQfQCVzC368JPkeYdKunHybjzE+y5uBPkak91uAMC4Zu03TFrvX2V5R
         08SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721819765; x=1722424565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K/70Vkq2b20w7LRsi+Hhz8GdJRzslLKPyFL21ZYqpEk=;
        b=naP9DMl2oPNt0ABIlteQSy5rNX95twVvOdqoEWaIQwPp80IDYJ/W7vsIbRl1PaPUyp
         4fqo/dA49AuAGMK47NxgKYACtzOEUDxKLyXitPJ6JmwLtei2rXF+N+zBbNywbfEjPFcj
         vJTMS/vErKdfZkA7H7e70rREywrDIb9pXMdnMT7q8n4C+AG20edAr2JRYopLgHwSkv5l
         IW9yTBnqMussNDj6dlTEJXT4R3kmSe3Hwt9eyeUBr3WTjaXXE2qmYngKiQ1ALkByGMnm
         K1om5K5zuHV5rUvaUipGfA4AskyEnQSZVqv6qKIm31vu2afetOrtim2s0/u5u1a5QHG1
         +n0A==
X-Gm-Message-State: AOJu0Yyi3O4R/bhB5rV1O6bFVr04S30aDCRRQAdV/oP0wzvwzpUMq8S7
	tCPtPrJlroH2Iuoe3l3D82JzwW3zCkAg7jRxiGCg3I8pFYsLDlERD/eoDA==
X-Google-Smtp-Source: AGHT+IHDKhUlpcs5d+NDR13HMumpqPfVusW/o6e463ggbj91rLCq7XVxhxWY0rs/xely8XEbgn57rA==
X-Received: by 2002:a50:bac2:0:b0:58c:b2b8:31b2 with SMTP id 4fb4d7f45d1cf-5ab1b44f534mr1214885a12.17.1721819765102;
        Wed, 24 Jul 2024 04:16:05 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a745917f82sm5006310a12.85.2024.07.24.04.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 04:16:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 3/6] io_uring: fix io_match_task must_hold
Date: Wed, 24 Jul 2024 12:16:18 +0100
Message-ID: <3e65ee7709e96507cef3d93291746f2c489f2307.1721819383.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1721819383.git.asml.silence@gmail.com>
References: <cover.1721819383.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The __must_hold annotation in io_match_task() uses a non existing
parameter "req", fix it.

Fixes: 6af3f48bf6156 ("io_uring: fix link traversal locking")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 1c9bf07499b1..9973876d91b0 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -639,7 +639,7 @@ void io_queue_linked_timeout(struct io_kiocb *req)
 
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
-	__must_hold(&req->ctx->timeout_lock)
+	__must_hold(&head->ctx->timeout_lock)
 {
 	struct io_kiocb *req;
 
-- 
2.44.0


