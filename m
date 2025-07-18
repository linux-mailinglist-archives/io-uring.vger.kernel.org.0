Return-Path: <io-uring+bounces-8718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECF69B0AA78
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 20:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 901DD188D6EA
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 18:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723232DAFDD;
	Fri, 18 Jul 2025 18:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RK1ovfoh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE22E6D31
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865067; cv=none; b=kBc52aVWjy6tKiGFJTjwEbucNIAxF21l0BWcaQwoXyu2KkteCuEgezz3bKARKzSgx0nf4kxOswB94sHfIklIw3l8p33iRVt4nGxbuHNR/03K86E1EAX8q4Sui+InmYIzljrpLc9GquZqAJHIp7H4hBPHCKpqvRBPgwV3SWxAyv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865067; c=relaxed/simple;
	bh=x77tjbpYV+Ley1dPIR/6FMHVIn65I2E5XTV4qLsrNGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4Q9oEh+Y1IpG1Yj3Iudf+sJ5wu+847Hfx3ZvjbbxRWoMb7SsSAx52sqstqfbAu5Kwe2JygBxnEF4dv4cfGk4dl4GFHlBy/EK0pfdxkZc5b+Z6j2qWpLUC9sLxyjR/bWyffyPP8eiicUamwY32AG0pTz2MoUTOorLExYf0SJrY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RK1ovfoh; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-60c01b983b6so5282469a12.0
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 11:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752865063; x=1753469863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbmhbfe2BfhOOQ3Bv2X7w3hfUG0xVoaSZJ8dkxyVA+U=;
        b=RK1ovfohRFbotonIAiUbwdDLaswwQ1dv6bUW0TVQ7F4e+rvnEHYkDJvQdw4EPZYjs/
         m4Wk12//7uRB+lkPUTQQFcJmbTWfRQblCmvKI5l0VZ2F4dg0trF80B16cXi5BmrJdLQE
         hmeSqEJ+5mxQGy7VsVEFQedd89tP5RsEvkm3Ugs/jakLCpE651UlSm7MvxYXrX1kYQUc
         2eO8crbLIY3FQ9UXk+hzRCLWkpRNBw6u3twcLTVrWaY1wEBqIxEoG9rWZz/huTewZGAR
         ectQzrPH6OG+aLEVdoKeW04LVnUmzG+xFVCPaCoVq3KWG87iuxHqEkS+L/99lF4krkIa
         J3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865063; x=1753469863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbmhbfe2BfhOOQ3Bv2X7w3hfUG0xVoaSZJ8dkxyVA+U=;
        b=QkTk3KVBK0PPQpKudcbZ5LgxcWqrOpYjmH8vgw44dnfkF8gm4xljl9KoV9S2hrwryc
         MtToU/BP97PUA73CqBY0ek6Xjl7mQW3Xa+QwQHZ9tUYYcG4Gjl+h3lerg5PoGJeahgkY
         db2+MSkaUNgmc8UyN3Jl4BjcpFSBA0ofo/R4Y/v92u7JGU+gerOkefuUK8nI/E0u1O5Z
         AQAIsQXWvEzgSO4uaTdpB8mxohlpkcN56igDyKF1pwwVrQBAsh+cKPoD33trzunbs0gE
         5pXrS7aZTet8qEIj3MqLg/TUY+4VdiqqKaM+GQ2OmRdph8CaAbC8O0zoqNz+5Neu1fXL
         2R9w==
X-Gm-Message-State: AOJu0YwmRO5TjNT3oMFLwWVrPLOp/AHXKIb2PGGki9j2J5OJ0yl081gM
	3zPNwIcFSvXYF4lpiJIJeGDevCan53bcPpENk2wuJQQOpP1qBN+FOhyzTQm3BA==
X-Gm-Gg: ASbGnctyfb8t+NKLv0noiW0F/zQUg3DhbAnuwXUmf3KfP127wU8ZtBlLMvX35ue/m54
	ASQ2jvzkjseJrznEqcVaUilR9KxG/nyAdqvK/FpprSxw1gYrVdz+PwmOVmsfYmb5FDGHi2byqCh
	ExKl3np6AV2K1IFYwS6U8sjwew4l8KLGyI2I4bGkNZFFSFauYKQPyxKfokP2JMuVEHlfdFkoazQ
	IjBD5bh2/70/kINGgYuO1O8MnpK6O9Xg6KbhNm2nN/qaJKv748Z9BrQlnMmCLNlg3oPNJJWkAM9
	hWQHQa2oBsrKiEN/YS64GCIKHvBNRGZc0gjuH3X11DkMtWmxJ1UJFu4hnt9U+X0bdOx6fVUoCV3
	xgAvu2/JdS6HzRR4FXHaZ/YVLehuSsXFDbenFgg8MXjVtHWM=
X-Google-Smtp-Source: AGHT+IHrGNLdDV3sfrM6D9xH1vnrRrOk7zBE5zrHTCLY5M0H1gid8bBGmS5sVWWcDlN8sdKAb5WhUA==
X-Received: by 2002:a05:6402:2786:b0:612:d5aa:a9e5 with SMTP id 4fb4d7f45d1cf-612d5aac0ddmr2486385a12.5.1752865062813;
        Fri, 18 Jul 2025 11:57:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.246])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-612c8f09dbcsm1379130a12.12.2025.07.18.11.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 11:57:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH v2 1/3] io_uring: export io_[un]account_mem
Date: Fri, 18 Jul 2025 19:59:02 +0100
Message-ID: <ea4794741e7f6508ad85bd5373e3a0336419d7ea.1752865051.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1752865051.git.asml.silence@gmail.com>
References: <cover.1752865051.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export pinned memory accounting helpers, they'll be used by zcrx
shortly.

Cc: stable@vger.kernel.org
Fixes: cf96310c5f9a0 ("io_uring/zcrx: add io_zcrx_area")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 4 ++--
 io_uring/rsrc.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 043018bc9b9c..f75f5e43fa4a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -55,7 +55,7 @@ int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 	return 0;
 }
 
-static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
 	if (ctx->user)
 		__io_unaccount_mem(ctx->user, nr_pages);
@@ -64,7 +64,7 @@ static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 		atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
 }
 
-static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
 	int ret;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 25e7e998dcfd..a3ca6ba66596 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -120,6 +120,8 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages);
+int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
+void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
 
 static inline void __io_unaccount_mem(struct user_struct *user,
 				      unsigned long nr_pages)
-- 
2.49.0


