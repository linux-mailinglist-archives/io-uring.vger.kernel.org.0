Return-Path: <io-uring+bounces-2825-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E398C955E99
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 20:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99E4E1F213BF
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 18:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7389938DE4;
	Sun, 18 Aug 2024 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XICVtIUD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CB3145B26
	for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724007330; cv=none; b=Sy0GZ0/wo0KQ+/eVo8Z/9qK27ZYkRJGSkPTZLNJBfdJUQG+ZJPMlSIh7Te6JNO4EEaU15zJjPzln+ORYj3KjgVZBf3oVy2cOVqs7szb92HYA837p4C4lb6e1bw9IXtEM5OiUIJ7FMC/OiFsqcyfJtVZ2/lPXXrfUef5Qv2KPdpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724007330; c=relaxed/simple;
	bh=FGikn6XePRAfCT1OgXm3UI93niF4mDZfTpgatgOQ9xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWN7SmOgqqg+b6a2h9XuqVjWKSNcp9CfmduYNSWqC+WFyUGnNSeOcjka/3s1l9CLbl8jkX7/kc0NwCJtb9mYURQedKHGSv5SSY87nk3qxYtaYHcnXqgoYVnAK2OeTU1l06oYknUq8DyKffFEIp8MnHHHN9kZfW2iB/p83j3SASo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XICVtIUD; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5becdf7d36aso2307590a12.1
        for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 11:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724007327; x=1724612127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwTtmvG5xQ2kbqf9TLb/9oN0eEv+JOHQx6L7riycuOI=;
        b=XICVtIUDZXAXtbsc/6zz/dvgyITCyriDU4mJymzjoQ6AXFmrE95Jdj4jSR4kQTlzN8
         sNIfGG8x0NegF5QSkCrwH0NTUK3E3JLsrYsvEbeZTNjp9U1Hp1LvxsoyAz49q/oJoHIj
         YKcrd/kuYtYUZZD32yjaWnx+GGSl/8d+0Y+fN6Vqpenv5JYqqIHEITWG0fcu+68jbHqT
         Fbmlc/JICm3aeN8vf0FWqXvXJbo5+sNEyBlH8b3d8/WTKHONvLpi5L1cty9oWKdAFLwi
         ngP7K8PU3mhhMcpBz0l+y68tncP1+n2kKiKbQv/r2oi5p7I5D6TNNTy7iyUVHUII1Yev
         3bTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724007327; x=1724612127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DwTtmvG5xQ2kbqf9TLb/9oN0eEv+JOHQx6L7riycuOI=;
        b=mycUJkc3miQvN1ZjWd2iio41rhipocBF4Tr9R0SgBupCOwBMj50vRFEpxagkToJCGG
         yu90m9HHgIcUSo2ONxbEGd07GlK5o78pK7uitm0vMlKdmttRDdJyGeME3JFFwlc+POta
         X2pEcSHXxLi1slujr3yZTTSmviCOI2N5n8IsM0G055lu3R2tb7/k+kr5XoP1VUoIoTRs
         QjGfYJGH1NfJX8doT5owZjQGf+JesmwRwHEU8s4Rsk5Y42psDUM2oOEMh5tJhZY3PKYO
         iHk5irkR94POf8RtZyOlz3/eZbuhSGFLJjxvqBIYroKdQ+mI348R596H8tg/4sKDWY62
         zdDw==
X-Gm-Message-State: AOJu0YxeQ9ce/Sd5sQE+aH7/07JxIE8jIJycrhVhHsvK6XeKoD2Yq/Nq
	jUJ0ETKUCFJ1r811srxQ4R1Ppm9x3lxHzPPS5v+1pQBzj96jFy/4ehLROg==
X-Google-Smtp-Source: AGHT+IE5Pai9Nxi1buPJHdLQHRDpStoidzxnpoQ7hNQqQMN+ggbfMYipdnrGT9k0X/mqj4yEJcyIrg==
X-Received: by 2002:a05:6402:520c:b0:5be:fa5f:565 with SMTP id 4fb4d7f45d1cf-5befa5f0661mr1066777a12.13.1724007326619;
        Sun, 18 Aug 2024 11:55:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbbe274asm4867959a12.8.2024.08.18.11.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 11:55:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 2/4] src/register: add clock id registration helper
Date: Sun, 18 Aug 2024 19:55:42 +0100
Message-ID: <54a3393887e816ebf27ce3d50b7128adff6425dd.1724007045.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1724007045.git.asml.silence@gmail.com>
References: <cover.1724007045.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 3 +++
 src/liburing-ffi.map   | 2 ++
 src/liburing.map       | 2 ++
 src/register.c         | 6 ++++++
 4 files changed, 13 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 1092f3b..53c94c4 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -241,6 +241,9 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 int io_uring_register_napi(struct io_uring *ring, struct io_uring_napi *napi);
 int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi *napi);
 
+int io_uring_register_clock(struct io_uring *ring,
+			    struct io_uring_clock_register *arg);
+
 int io_uring_get_events(struct io_uring *ring);
 int io_uring_submit_and_get_events(struct io_uring *ring);
 
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 476d7fd..a0bea31 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -206,4 +206,6 @@ LIBURING_2.7 {
 } LIBURING_2.6;
 
 LIBURING_2.8 {
+	global:
+		io_uring_register_clock;
 } LIBURING_2.7;
diff --git a/src/liburing.map b/src/liburing.map
index fa096bb..79f6068 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -97,4 +97,6 @@ LIBURING_2.7 {
 } LIBURING_2.6;
 
 LIBURING_2.8 {
+	global:
+		io_uring_register_clock;
 } LIBURING_2.7;
diff --git a/src/register.c b/src/register.c
index 9acc36f..c0690a8 100644
--- a/src/register.c
+++ b/src/register.c
@@ -366,3 +366,9 @@ int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi *napi)
 {
 	return do_register(ring, IORING_UNREGISTER_NAPI, napi, 1);
 }
+
+int io_uring_register_clock(struct io_uring *ring,
+			    struct io_uring_clock_register *arg)
+{
+	return do_register(ring, IORING_REGISTER_CLOCK, arg, 0);
+}
-- 
2.45.2


