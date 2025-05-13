Return-Path: <io-uring+bounces-7967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D638AB5B28
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 19:26:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 859447A1B45
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 17:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E33382BF3EA;
	Tue, 13 May 2025 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gp7JKznL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8281DF258
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 17:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157155; cv=none; b=C/Uo8bu2Jd4d0bsw9omm+E0QqK2qvsPyMnuE6WRHO0cn4WBb2J4V6iJieP90GJ18vjUiUHNX9VA5T+QjHgSIArLq6hdOLafKoDSWjoiq/tmLXTe5EOhDrtb92IzPWiU8AWDi6b0a330a5skPGunAf+7orGWTssZB8J8IfhFROJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157155; c=relaxed/simple;
	bh=7PE8cCtnBO1yxB95fDSEOVx5UfSWrFbsNwyYr5x6Wts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtvimGk8lCsMKm5yoN9riuuCkPU3pJEydXTgL6Tw9Sy2zbl5CS04YRtB9LYFSeeu1+XL9rBzmmhQlSYjFJAhVoKZ505QjaH5+0RXhyWjDzU7TmC7p8D6+AEkmEbFBtFvO+EqwqEm59EmHgrjKnjlH0Rd8XaNC0cWMLO1hRg7dwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gp7JKznL; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43d0359b1fcso653685e9.0
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 10:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747157152; x=1747761952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=51oOnrXxZ3/akZgJaFC+xfr3MCnAAkvpqzr1wD9AzcA=;
        b=gp7JKznLarfNlAT8SltZNuT/fLUEq3ZmPC3jiPvldOoXB3kSEIIyhZ18iGTThItpLd
         CciVJM9LHjYgR2n6Hc0ushU6tVRKF8BpRWoLvE+5VOD+p0GhAm6tgGENCGteKOV7Bm9o
         3WCxH5QlPlgHGI8F0qcDE+Oj8a1jQtE88NEaydoFofuRlulBYRYAtRfQAzyCOa6EPZd9
         dXk0m/hyB5umxZzEl+mhCMfJOnXkpHIyeiHszLfZpeGjABaXEW7X5yMW9TkMsKXa0Mnc
         WONVK6E49zmluFH505ywfVzDoKv2FDAyHu0+Xb0kGmgZwKfIN6Fu924wo0SJk81d+fJ2
         hDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157152; x=1747761952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=51oOnrXxZ3/akZgJaFC+xfr3MCnAAkvpqzr1wD9AzcA=;
        b=EitRZEB0XtqKjg6Nh8k18ciUe8VaD8qaxGxcLIeFFFZX7IWMTS2UMIvY8Y0Uyk2oaF
         8LbJwWQxpWW0lvyBVpooGClx9tgOxfl2DXZN/uND92mAgR8p44YDNFKM1S0F+iK2tEyG
         m3fSp59U+rOnTAGMtgAX4ShDmegAfDC0x06/lDTzLpe1UZjjY+KqFAYlO7KggJbVDosg
         w9LCC4Stm/UYCQtGRNjTj9j5bA8qHdK19vVCe2sYteaJse7zBA3A8eaQCKus0s5mQAf9
         sM5LL3+ShnGbqfKDvVm0xX6iophkxeTocn6sX8FFL+QY27GCwBqINFtMcJpNX6nIccr0
         jXCw==
X-Gm-Message-State: AOJu0YzEh6aZbUwLJRgrKoL83iUYX11EUTBngtKd5ns5nCRLn1eKthee
	I1FGOUoWEnPQ8PpUdd5Fc4DTO1ppN3wO22oQpepMU3FjtLyat5/lZ8Ff+A==
X-Gm-Gg: ASbGncsi766TUqC1vSOky5F7fnG1aCo5qM5uRYbHzCaLBT2a4vRINVPdTA30etgEzkj
	uei/HBg9gdjC2KYa7itY4mGhZgRA+aTzLPstm9RBs5MMlJf8RegU0mng7i4FXxgm7/ikg4p8DZk
	9Mj6oFwsev6m8jZpV81p2Z5P4O7/K1gj2klK0AgRjyMrT5PMbL6tBs9NZ1Wr4GAU5ZZeWgyjsz6
	ywxgDqp+OWqyj7aYQBYq/vLvqvROY2rbAQUFmpaBy2zZb7e1+cQz0xxniwDZG+BA9vtC3mJUiwb
	5uitwLhwEiBCsEdJb1LBBHYgFeMXv6Kb9456jcMKcfZ3RTw7/W/SmkGi5fyHqXQQ1A==
X-Google-Smtp-Source: AGHT+IGLqcl8JtplqdKSHPWbBMqcqsluKqHTteorDB4oWrhBl4bInFu9EecVinpoA0551CWsgmHicw==
X-Received: by 2002:a05:600c:4f53:b0:439:8878:5029 with SMTP id 5b1f17b1804b1-442f1a0d906mr3672575e9.2.1747157151663;
        Tue, 13 May 2025 10:25:51 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67e0ff1sm173034745e9.14.2025.05.13.10.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 10:25:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/6] io_uring/kbuf: don't compute size twice on prep
Date: Tue, 13 May 2025 18:26:49 +0100
Message-ID: <7c97206561b74fce245cb22449c6082d2e066844.1747150490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747150490.git.asml.silence@gmail.com>
References: <cover.1747150490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size in prep is calculated by io_provide_buffers_prep(), so remove
the recomputation a few lines after.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 406e8a9b42c3..eb666c02f488 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -509,8 +509,6 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EOVERFLOW;
 	if (check_add_overflow((unsigned long)p->addr, size, &tmp_check))
 		return -EOVERFLOW;
-
-	size = (unsigned long)p->len * p->nbufs;
 	if (!access_ok(u64_to_user_ptr(p->addr), size))
 		return -EFAULT;
 
-- 
2.49.0


