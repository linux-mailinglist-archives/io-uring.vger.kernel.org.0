Return-Path: <io-uring+bounces-4672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 67AA19C81D1
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 05:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6710B24C98
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 04:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246391E882F;
	Thu, 14 Nov 2024 04:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CeY6ZZ23"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED7B1E8826
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 04:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731557643; cv=none; b=d9KrPp++ONauOa60fy0v5CL95RndMYq8Oz5i2ecGk6bqAY99TuDZuSvbvK09H56O2l0c78R/AFANopwDZO0H6F7oRODGrJZgjXzXrcnjIO+jyHsU1pfgWv+TlEgr59N3NxkLceFMwX31c4HUm/cuO6p3YyETmcVk2Hf597h9Ivo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731557643; c=relaxed/simple;
	bh=bOXuPylse+C0vi8bk1k20OU0yKwquVaExqg5AhfYLSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3cz5g9Q/Ukqwt3K+WAACk4kkadAalJYrdGgG/p4OXr5o/XT2HtHfjk6JKX+/dmG6OOT+DW8fXW2tTbSr9PLhyTPfSSXbKNSUVriGgVz9BLGMmE9PwuGe0WQ/S5qF77LD62Dhiv0tVM+SZhuMvmzl6h3426PcxE9enMxj8dAMqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CeY6ZZ23; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4315e62afe0so1969605e9.1
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 20:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731557639; x=1732162439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hwyltf5fgdrVd41AJQ/C7rIRuEDCxBHV6H77DqLRdb4=;
        b=CeY6ZZ23I7bZ8ULSUFhhZ0JOIQ41+pjd7YdU48OwjyOPzjpvX1QnOVqu0hpI8Z/YO8
         oEg27T+1oUZELq5DXx2TK6cEc6Zv8ROMXhUTTId4vBvMorrgCIFJVLWvYuUwiQUC4cow
         mgPAx5PtQCV3jSKHKIGQurwct5hCu/rt/N5KU+wyvml4kCdnn9x2/CYpT0JUvU1aVxJQ
         yNeCp8WyfMI1nN+yzs9BUeBjurR+sYYfMc/t7Ogss+ys9kdchhcHordDf1j58J6yEIlB
         EkTmub1vRognRbh5h/DqIOjB61wOOClU3T+dIBgOWnpclxXxVTdXzp1QPc3PPP36G+rY
         skAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731557639; x=1732162439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hwyltf5fgdrVd41AJQ/C7rIRuEDCxBHV6H77DqLRdb4=;
        b=XOfRDOs93ah1vRWT1uXGeK7z0X8tjIdu5F1REPP5dUCZMPoU6ncYY8fc0Ud1EVFMLb
         WAyXjb/kFIGnR0TWaS3wDu/rHCBKTc/DQGJ/iAL1fCSfGx2rRTd82ke8+pCD6ffkmVgJ
         7Kp9Bt0zOVTYN8h+KyEjbUbMIsn2LMfiBwV71oEnfSQP7dd2SDFdHx0Wt6MfzQR5IbvB
         FCq3p9mwI4Tq6F1/qJJsaoLRBuoApGkP1oYU0KiVQzNca9PAS65xXlBfMAf5LQl3y9IW
         Ad44nB8WiVBQBDNluW7ix1MCFEiJCMcogdeb5dfS76bu4T2cTkjB7TtGxEwHDLnvl2wN
         bf2g==
X-Gm-Message-State: AOJu0YyWH8ABEhDPXdDwQlPLwOqHhpcZo+LF+SqQIz+1kJYnLMPkokNv
	qzMctYsplCo8rWUL+fe1K0ClJypKy+QkSWmRENntnyRAUCppd94Xm0O5JA==
X-Google-Smtp-Source: AGHT+IGKIufDLs3bta+PL+WA+/3gFF+wlnPP7XlwH8u9p++yKtxJ2th3LO/5NHZPaUSIR0vd+/G2JQ==
X-Received: by 2002:a05:6000:1564:b0:37d:4d21:350c with SMTP id ffacd0b85a97d-381f186cc7fmr18473685f8f.13.1731557639328;
        Wed, 13 Nov 2024 20:13:59 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae311fbsm251936f8f.95.2024.11.13.20.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 20:13:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/6] io_uring: disable ENTER_EXT_ARG_REG for IOPOLL
Date: Thu, 14 Nov 2024 04:14:21 +0000
Message-ID: <a35ecd919dbdc17bd5b7932273e317832c531b45.1731556844.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731556844.git.asml.silence@gmail.com>
References: <cover.1731556844.git.asml.silence@gmail.com>
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


