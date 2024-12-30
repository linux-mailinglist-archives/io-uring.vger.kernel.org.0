Return-Path: <io-uring+bounces-5632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC249FE672
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 14:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69E017A150F
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 13:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0914F1A08B5;
	Mon, 30 Dec 2024 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGcQOSNA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5001B1A83F0
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 13:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735565388; cv=none; b=acqYeYx5t+4KFu2Y4kHsEyPNWhrNopxxlCmAvr7wbS3VTsmhVud0dycIZVtYPGvmgpoJDbrSvAnHRfaULEWmHkyKHS6vFAbi4JChxpggntqqbe0XwaHa/CAALwzG097NyCQYqEzuqAJ2AmYbbLb8bQEBASnD2mx20sbYm+z/x70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735565388; c=relaxed/simple;
	bh=me7i5q4jrFspSMqrXH9ZEGUZiiADFqgD+/KWA9+Z5HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkECFDkn9jPej9OSKMET6Cw9F8Peq/S8jJIRj00gRwZzlBS1cjDyxvwvO9EaBa5gQD4B1tjOO5l6hG+JFLocowwOXN7kojnYNTfPtT2BeqyEBSxJ25s1l39eyp2CtN1FHmx1Gz3xTKX4hYrmHUq6uaN1csaqGbGR57ioWUDD8HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XGcQOSNA; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d8de655efaso586531a12.1
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 05:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735565385; x=1736170185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9O0UtBRpJq8GiVtrDcFOtQ56EeyOUld69ffwr5omEOg=;
        b=XGcQOSNAxsfiGiT7eayZ2VohaeWW/8J06xwJH74aCK/6zsCy4SCLGSB9IwboxTt+yE
         2tomv/+zABFS6QfJfnClN3LFQl7Nco+BtsKmsTAakd7WVxCWBheeQBs2YoB02N7xYA4J
         iEeodRHJC0u/XGY9/E1yJNsPFfNG/8SleZzqx9/EJ5ZTXD2qRg7cFHiX5RbhdXXQEND2
         X6K/1YPXqjsaY4WcTVvlCN+9d5DFp1Rk/EIMHMtPuHkArHqHjMkFQVkuxdWn3ptJ/RI8
         ap5QTg3BqrQFORnDAkAUqsoEt2E1rE3/gA+xu6+pcD8vHeOLYWYYaMTyMHEsGzfkH247
         8/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735565385; x=1736170185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9O0UtBRpJq8GiVtrDcFOtQ56EeyOUld69ffwr5omEOg=;
        b=l8+du4BHqBbN4TREhE9xJolUlPoQloc0CCuGeNesv67K+70FLu+Hcccv0J22bFhNKR
         A/Zq7n0m7J5A8K/XvsbTmWEbKJ+wh6wMuQQ+AwX0G7k+A5c1m+qkO1nWUyLrOR1F2eGX
         2L/TghGBlsO6r6sohAy9PMZAx+p7PTlkxQiArmxTBbAjGFdO+1WxxvG43n+A31Bh3QWU
         kyjNHjyDEk668fPVq9HwL2rBmHBgAXjiZePBLjvVZQCxTzlTVqfIyce1566wcB78O61A
         cTaD2lMD/Oi5UDNq1iq1WmYQ/KSmXQWJkEd4bue7nJPPxe/UF653UNiXSELUB+BIrf22
         7ssg==
X-Gm-Message-State: AOJu0Ywl6uoxjmB8v+ce5XH+38FHlY5OS5hiWMAaZ8De51pEILhcPo9o
	qxhmOldj3Xop5lC7EBEZgqkClofybwXTnzLy2pX3eeNZZow4q9byjQKQIA==
X-Gm-Gg: ASbGnct1HIzVMM9uoQK1jTMyFYxVGoZ4OgYYeQ4+pLDaX5GmHXs3GBZJnMvygYzkFGQ
	HoH0JwUPBCGuiXoWalbUL/VFOGSK2GXCUE7cVqTv94f5f6cehrs50Cks/Ig0QgbbtzW7CUg5CF0
	ezAdPofFoL/6kHIn8dh5EuHwm26lI/c1yubDkcrOO4PLgt3SX17FuVliNxbBpCPd40glot5VpCz
	h6liAKRObNCtwOLtpXlqfuJOpbgRn9W/m8xoTY6CgKWYu7gHJwLtlGU76+N93lND2wn5A==
X-Google-Smtp-Source: AGHT+IFyuJfn/TqhXOLROym+BT2SAb4BiW52u3rt8LRlkFldETVwh+n4r61L/NCEM4xjXrjZOS+W1Q==
X-Received: by 2002:a05:6402:2802:b0:5d3:d7c1:31a4 with SMTP id 4fb4d7f45d1cf-5d81dd5e8famr37519908a12.7.1735565385280;
        Mon, 30 Dec 2024 05:29:45 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.209])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679f35csm14694286a12.51.2024.12.30.05.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2024 05:29:44 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 2/4] io_uring: add registered request arguments
Date: Mon, 30 Dec 2024 13:30:22 +0000
Message-ID: <cb3cc963ad684d5687b90f28ff9d928a20f80b76.1735301337.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1735301337.git.asml.silence@gmail.com>
References: <cover.1735301337.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similarly to registered wait arguments we want to have a pre-mapped
space for various request arguments. Use the same parameter region,
however as ->wait_args has different lifetime rules, add a new instance
of struct io_reg_args.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 2 ++
 io_uring/register.c            | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 49008f00d064..cd6642855533 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -299,6 +299,8 @@ struct io_ring_ctx {
 
 		struct io_submit_state	submit_state;
 
+		struct io_reg_args	sqe_args;
+
 		/*
 		 * Modifications are protected by ->uring_lock and ->mmap_lock.
 		 * The flags, buf_pages and buf_nr_pages fields should be stable
diff --git a/io_uring/register.c b/io_uring/register.c
index b926eb053408..d2232b90a81d 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -607,6 +607,9 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 		ctx->wait_args.ptr = io_region_get_ptr(&ctx->param_region);
 		ctx->wait_args.size = rd.size;
 	}
+
+	ctx->sqe_args.ptr = io_region_get_ptr(&ctx->param_region);
+	ctx->sqe_args.size = rd.size;
 	return 0;
 }
 
-- 
2.47.1


