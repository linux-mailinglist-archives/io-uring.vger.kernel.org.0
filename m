Return-Path: <io-uring+bounces-2943-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1993B95DEBD
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 17:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 103D91C20F26
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 15:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20589364BA;
	Sat, 24 Aug 2024 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CbNLXPZ4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47BB1EA80
	for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 15:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724514367; cv=none; b=nnrv358VdjMzljzY+Uar9r++iH/EyDQDFnB1vIdhKtNrh6gaK3GiFgElL34/xHZlBg5OpVanqaggXWZjaoJJaZQOo7RS+NoUNxyRutwuXdTYCQfbmqsG2xXG9wPjpZSdHC/QAofoXc46H8X52FAGVfKZlAehoar8Knrl7efkr2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724514367; c=relaxed/simple;
	bh=Wcv6w+BIn8JWKraCksQKIpkC+br4o1NF2DF3lqGr2/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fm9oIHrZAox4L4qNTa/JDuWVNAWSmXZ2ymm2ZMgohNpoOZv6uBQ/w9a7RcXsUQeUlnrxzRQQTEqxblhR41nl12306Dpo3QiJkzCaTQFElON9/V3JYv1A96lK0Y1SLoefitdEqI0h53MFApZcNv06xCdBWk/eg46QUgXA6+jRi/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CbNLXPZ4; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2d3c396787cso2407453a91.1
        for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 08:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724514363; x=1725119163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYBi4XLMwDLtdov1Ccq79qgk5GT+Q1dHBt7qkDvz7i0=;
        b=CbNLXPZ4TwIKbwjXHhiOlzn/YmYE3EJtd53UE8qgwc90KeQxCgfQls6C/ErNZRB59t
         sj5Rn7qmJH5BBg6UTSITEr5PBhKkDSA2jOuR2EX/1Bl3fdVy/dFbHU0s39S6Twzc0Mq/
         icoVePgmgUyWXdypFuTiZY1d6baG/yx6MOcR6RliOWzr6hOTiLSKgCKlyEWQ4t/RWUco
         /ALTwu6CclthFmypylYccu57oU8fgtWjtJUkjxIcbu9zIL3CW28hBLMhM8DfUWqac/yM
         /R5r8M4vskZKTt2iJ16y4R0aA0wCslMCaK8/Uxf3H3MvMu3bejWHUrAx5V+MopObYEBR
         GtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724514363; x=1725119163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QYBi4XLMwDLtdov1Ccq79qgk5GT+Q1dHBt7qkDvz7i0=;
        b=FWlAjkkbZVGhHJTi8vIyoJhrU490V4i2HOU9o/1C7yaxdcRSXSbcu3pYldrKqx/Kgo
         iboGf5KYwZ5hCu7PMX48d+PLX/dPiy3CKGFzZIREA0PdmgjD2Ft2KFpYQ0kEYSjTX93G
         ZoTBtqwfF+G0xU/8fWXdYGFy+AWaLTUGgQOVHIOFHgJFT/ZvmJA+mgPCbId8Dd0t3rMK
         wdR1o4YYyGGKJ0KKm2AXpsbiREi4nPRQYgWuP6WTQIOZQd6UOHWwlGjSP4UcruoO2fFR
         tmRlvCJIwGhHcdRDo8RjFG/jGtBFK7r1OrCgDo93nFh5qmaOLiQJpdsjdQu9rdlCHPD2
         E0og==
X-Gm-Message-State: AOJu0YyszJAcP9SWb017yGHMjlJ+0UqguSHAKuxYdLmuAhzF8DIsrI75
	9TgALDwz5L38EugK4GmVLDxqIwdmoOByvACoMI6z6xtZeMFX5yc/0bZcw8JchnM4mOUF1AMkRSM
	b
X-Google-Smtp-Source: AGHT+IHEwNVXZEMSZmAk7mJJ7J93XmSIxqR+2jN/Jldp2TOMaqjLrmrtm2qao0v39TaRMlc2LlWD/w==
X-Received: by 2002:a17:90a:600c:b0:2d3:c2a0:a0f5 with SMTP id 98e67ed59e1d1-2d646bc144fmr5236594a91.11.1724514363529;
        Sat, 24 Aug 2024 08:46:03 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eb9049b0sm8596939a91.17.2024.08.24.08.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 08:46:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/kbuf: move io_ring_head_to_buf() to kbuf.h
Date: Sat, 24 Aug 2024 09:43:55 -0600
Message-ID: <20240824154555.110170-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240824154555.110170-1-axboe@kernel.dk>
References: <20240824154555.110170-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for using this helper in kbuf.h as well, move it there and
turn it into a macro.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 6 ------
 io_uring/kbuf.h | 3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c69f69807885..297c1d2c3c27 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -132,12 +132,6 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 0;
 }
 
-static struct io_uring_buf *io_ring_head_to_buf(struct io_uring_buf_ring *br,
-						__u16 head, __u16 mask)
-{
-	return &br->bufs[head & mask];
-}
-
 static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					  struct io_buffer_list *bl,
 					  unsigned int issue_flags)
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 43c7b18244b3..4c34ff3144b9 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -121,6 +121,9 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
+/* Mapped buffer ring, return io_uring_buf from head */
+#define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
+
 static inline void io_kbuf_commit(struct io_kiocb *req,
 				  struct io_buffer_list *bl, int nr)
 {
-- 
2.43.0


