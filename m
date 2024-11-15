Return-Path: <io-uring+bounces-4726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4C89CF2BB
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:22:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54ABEB2D568
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8E818E047;
	Fri, 15 Nov 2024 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZXzNbRy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5678E1D63E9
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689644; cv=none; b=N8c5AMmrQnyu7VMFYnfYeahSBlq/8n5r95csQVaZIWn8IqbPCBBYotIjYO0gmR6akO1+qmmcMx8mujAkwITQxNa9/B6nJqAOVaN2nmngWwlPq8shR3yHD7TF6mjGEKyiYlOQVN5R3o5Eblmbgf129zdR7tWM7ppMDd5ukj7Rax4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689644; c=relaxed/simple;
	bh=bOXuPylse+C0vi8bk1k20OU0yKwquVaExqg5AhfYLSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=on/zeXmfyvmb4WbMHxPH2W6s0K3T6q/ctFspR/2iFn0SVkm2/CyClgzbkctqwYpO82+U+0445nPUmUgfENYiaojOqXCYUGBLsTGu2FPJGFfWqSS9GWDjEDctl2FlAVIZy1o36cHWZnkN5jnSJ0helH4d27Ml4mP4oX80BV8myys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KZXzNbRy; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38224150a84so754638f8f.3
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 08:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731689639; x=1732294439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hwyltf5fgdrVd41AJQ/C7rIRuEDCxBHV6H77DqLRdb4=;
        b=KZXzNbRy1aVv2k3pZXJmAm0h6RVFQryRlwiBJDYdKaqz9HHm/thVFBIM0yJPwE+pc0
         0zlYDpvtAVpGLW7qD+JBQEH96ZCHyvwDdFhVdEEJ7K7/0QobS+Yg3pCpszuFvYISCw6L
         wrhmAej3BJiuW/NxLG4F/4mJhkAUnAjsZXMwp3jypROR8NXKvHRF++egRjLhCiBMSmYc
         kCKisernwLcQbAqYdJv7GfmZZfLZCjReO3fybzyDv1JJRo5WccYqF57KsIwAC1+fuEX3
         wYkQ2kF5ybkzF4Td5233lCvDxQ5YhisMGnDdBNXJWhvHr/0payLOQoFtvfCg3SSPcMwd
         umaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731689639; x=1732294439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hwyltf5fgdrVd41AJQ/C7rIRuEDCxBHV6H77DqLRdb4=;
        b=YpoGiPH1zUZgv/lt5Os8StO+xqy6DPaui6bDp8/oZN6GHqU8lpO7JMwqzNB9H3p4gF
         i0IjBzH7mx+P7pY+RvTY1OHqXqJKi28WgDnb18afxv1K/xgHi6ZqhGu/tyS1dP1b8sCC
         ZpOjfRr2WBNrKlrNehORiGmmJO4zirAPLnzQ/8XdU7aDppVm1GG+tmWWlZC/IHcCSORu
         Afq80Zs+A6VeVSWlFtTuNcUU9KPSI+8DSCxqTAt26WAmZMmLFGXMNOt7kLqbymmmyqlB
         OFM3gwr65jq0UQEWLRkn5Dx0AygVBdXEsTp32q2W9KaIwudnuv/XHx4O/hcHaSXjvFZh
         zAEg==
X-Gm-Message-State: AOJu0Yy8xAX0Awm3HxLcvdMJ2SJn3f9ORc+69KBaCMlzkrckhukQmDX4
	6qC077cEqfVidP37MGTIckMCakV/WbFwAu06ZNjcZa2samEOicqc7YzVbQ==
X-Google-Smtp-Source: AGHT+IHhc6W2CBpBVUaNB+nRWT4f1P9CdoYttfXdopSeDREMkkE+HLarg3fNyxnQPY5sSCCJDHazAA==
X-Received: by 2002:a05:6000:a0c:b0:382:1ade:83ee with SMTP id ffacd0b85a97d-3822590646emr3010701f8f.23.1731689639428;
        Fri, 15 Nov 2024 08:53:59 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae2f651sm5011895f8f.87.2024.11.15.08.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 08:53:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 2/6] io_uring: disable ENTER_EXT_ARG_REG for IOPOLL
Date: Fri, 15 Nov 2024 16:54:39 +0000
Message-ID: <a35ecd919dbdc17bd5b7932273e317832c531b45.1731689588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731689588.git.asml.silence@gmail.com>
References: <cover.1731689588.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IOPOLL doesn't use the extended arguments, no need for it to support
IORING_ENTER_EXT_ARG_REG. Let's disable it for IOPOLL, if anything it
leaves more space for future extensions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bd71782057de..464a70bde7e6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3214,12 +3214,8 @@ static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 
 	if (!(flags & IORING_ENTER_EXT_ARG))
 		return 0;
-
-	if (flags & IORING_ENTER_EXT_ARG_REG) {
-		if (argsz != sizeof(struct io_uring_reg_wait))
-			return -EINVAL;
-		return PTR_ERR(io_get_ext_arg_reg(ctx, argp));
-	}
+	if (flags & IORING_ENTER_EXT_ARG_REG)
+		return -EINVAL;
 	if (argsz != sizeof(arg))
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
-- 
2.46.0


