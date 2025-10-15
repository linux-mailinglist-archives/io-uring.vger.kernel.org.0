Return-Path: <io-uring+bounces-10017-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D1AA1BDE646
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 14:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8CE344E6292
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 12:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C621C2D7810;
	Wed, 15 Oct 2025 12:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTqRZKOm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0582FFDF1
	for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 12:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760529974; cv=none; b=nWWeINIwmmmkqYtBkcERKIsz9f/Z5I/TB03T6YeZMV/GH2IV94j9dE8Eny0jQsRqjC2+O7eObFoYr6af3PoNZphsoC8VLtm5HFP0UoY8ZzSsbnnvzkLu17bto5Bwl3Jv1Ihovy5yHkRqtIzAyHwjMbq09C5JvfiCcHCkV114mIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760529974; c=relaxed/simple;
	bh=bgRRNzMzN8HQfKyxydMglAIahJTMB5pi0XFQ8lQTSzo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tf4rgythEzH6kuuLLHNQajZ6V7zr10M7ce+iVOq1wzMl//mCVsOkvyG/JiYjwH7d9heUs3DkYp4TPxUuswdluHUisG/GXN7hlT00h2pDz0RgYeIaIpDjYjBvCOZrlzuM2JTf3lnxDum7tZwjS+6WfcBZR0t8R/BPYSMY4XxVZlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTqRZKOm; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ecdf2b1751so4710816f8f.0
        for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 05:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760529971; x=1761134771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=otde7B2fz5+6/ygm3wwUVX/qbOtIAIEpLhd6ib59KI4=;
        b=jTqRZKOmMR+Cf5M2hzwRhiMTDiF8Ljopi5ClMUwdlPJ8uezMg1qW7LLEnLZ2FuJ7fR
         5Nialat6gEA6Ud/qyYlXVqkNuZpb71XrTs+/pBdEctBrbiFMK5j48oxVFtPv8SGM/CPJ
         7mt0OhH4bGNTp2Y6Scv20fqdvVFr62d3jQVYHo+b8EPqZR6VlDY/epIDuBLC+sBRcR+c
         8j+fZlRqAvJqHVevZ80KRZWb4kPTlhBQv6FY6lsk2VweUoMlAZ8pzinzcdGObwamQQb7
         EZhxWzEqe9O8mivdIBG84h6DVw+vDXGK0AKP7ilZRAsRLh/GLZunbtzAav35ih1GdWtK
         d9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760529971; x=1761134771;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=otde7B2fz5+6/ygm3wwUVX/qbOtIAIEpLhd6ib59KI4=;
        b=W5yfaE78DNNMMmPbQE5NfyKRJPZrR5yHpcGnA4CjNjTkVxdvKot0oE5iO1gwvxaqHM
         z4FR+ZhbgiK47kmcAy/r9EsIRYKNq9LBTtF85AFydlbzFQRRgub2EaZ20FnYO+d0KVdx
         6OpckQuD9HOYIIGDubNRluZj60vtUsaRpsny+hV42C3KAihbgss5vizgQFwuReRcqoTs
         ssmRnSAzMdmwPV7XwRQ7TOaUDqFc7qvBVtN2PbASTC/aCXqTyCl3oHVIn6QyarXb+zrq
         X9jg3cRe+wZJf5IPhA00Bh08Jnyh1E+9zGqmlS15HWKOdUslgSCqKrfvi/AtaIRQPLNU
         3Oig==
X-Gm-Message-State: AOJu0YzzaaPay1kmPcAA7V2AOkuXzhk+K7Ia7E0GnIBoWLW0quhqvz2x
	/6SCJmL0+18u3r/po5NX0IPvn04884PjO+qW2m3tzs31ON0W8g2iNq/G3YhoQA==
X-Gm-Gg: ASbGncu7pGOkFBhXiynKysKo0GFtv0/rpg9o5G0Q9aEBLITAIllPl8bqiB94DZp96GM
	AtcaFiw6PYlne6ThFk2LXSOvPL+Zgo3Q90FwbKnpqiZ5BgONxNnaWqF5P45nHM//RVDvCwOtGvX
	HintXfmE1485m5Vhy92+rSuILzPHzxXl5yxy7R3NRWFU/Zu2nR4IiEAgbkklXeT6fBrdyM1sxMp
	V9txU8T9ho1rEorCsINj5KW5WrDknVtMrMCmtqpj4co4xipL2feXZN4PQOheswXre4By8AxAX2h
	/SKUahS/pE9/ft7WGyzq/DD/xdYei3EDepOGSCj3mraCWYp4vRxqm4OjZNUQ5XYpCivGNH89Ie6
	At2Sr9mArHGGqXwa2elOfI6FEMhsQg0DWwcI=
X-Google-Smtp-Source: AGHT+IEBKU6wz921ViEVy1mMeFfPkr5SerQMlGpKy1oAhsN210tfknB2gIfPhPJ67019rrVO1SVxmA==
X-Received: by 2002:a05:6000:2501:b0:3ec:dd12:54d3 with SMTP id ffacd0b85a97d-4266e8d8bfdmr17624039f8f.35.1760529970810;
        Wed, 15 Oct 2025 05:06:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f5a4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57d4bbsm29187274f8f.2.2025.10.15.05.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 05:06:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: protect mem region deregistration
Date: Wed, 15 Oct 2025 13:07:23 +0100
Message-ID: <8842bdc39d78941e83e14e27d8177d9f0a451695.1760530000.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_create_region_mmap_safe() protects publishing of a region against
concurrent mmap calls, however we should also protect against it when
removing a region. There is a gap io_register_mem_region() where it
safely publishes a region, but then copy_to_user goes wrong and it
unsafely frees the region.

Cc: stable@vger.kernel.org
Fixes: 087f997870a94 ("io_uring/memmap: implement mmap for regions")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/register.c b/io_uring/register.c
index 43f04c47522c..58d43d624856 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -613,6 +613,7 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	if (ret)
 		return ret;
 	if (copy_to_user(rd_uptr, &rd, sizeof(rd))) {
+		guard(mutex)(&ctx->mmap_lock);
 		io_free_region(ctx, &ctx->param_region);
 		return -EFAULT;
 	}
-- 
2.49.0


