Return-Path: <io-uring+bounces-4743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD329CFA23
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CF3DB47F6C
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 22:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9BB31FDF9F;
	Fri, 15 Nov 2024 21:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWE0hcE0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCB91FDF92
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 21:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706402; cv=none; b=Gynun1Bie0xrN/ANtCvfDv5LnrWbOT2QW1KLph2jDBro8jUxUzwyJV+D+5XaPBAGkGLz6uVFKmAGN9bw8WWjKi3DHf1jhEd1zpI1WxMAIYr1GC3tcL/N5/6maWxCFm87e1Ph2AoqW4EFRjFmVn8xPc6eIZLolKtKY+zo7LFHoro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706402; c=relaxed/simple;
	bh=wwGynPXkF20AraUsK2w2sohhhqLepUdz8Q0unalezdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mopFz7SNIqLgCwbmPy9Ei/14pKiouhU1gpuSCze+SPZIfBivZOiPgEbMAakqUsHDgSGZa1HVVGv0GYJ64VDJIub4hErhcHJk7nIrg/jaWsHzi2CVImuwFyXzzftp6OgpwYw4MoZ/pNpDXjPLfrQyS6m2sWs29+pjqqhMovciRSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWE0hcE0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43158625112so798015e9.3
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 13:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731706394; x=1732311194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YNM2WJwBXprOb2QXvwXlSAYOSUSwg9yszuSdSI916n0=;
        b=cWE0hcE0+Ogqxgiv1Wr8Euafk0J3u04H5kqlKk6VuP2VovN3OeoYERzv6sIJcSka4g
         HeRUrfz3EjNr4mvjrWOUkZpDL64V45y0v20/k8qoR/p0hia5LLIKbt7HTiVE1z+5itEP
         btRlwFEnJBSckSFG0vtEFQdJVUVj4OnA3se8nRvRTW+qIjxcaAgTXTJ4kYfBUyK1I5lU
         pAhI4k0K5gksHuqrnqrT0a8mjTgeUXS+n0om4mYEYn5zolEiQZmEhPqay9TZUIiV4Rxg
         NtnmrOv6clNGpxqMbIwnXu5KO4XcHnXvGzyHFshC6FnAlebCZvR3Jv2I+b61xB7Eo9Wr
         H1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731706394; x=1732311194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YNM2WJwBXprOb2QXvwXlSAYOSUSwg9yszuSdSI916n0=;
        b=lDdgABvcpVkevOhC4dlWCo162gk/R0ZmooY22NeovqPd+EpVUNJcBaoj9y0hoWsX19
         CJjdG29idnWQ6uMmm91izLtgZm0uWEkTL39zltgmnLW1FHHWjs8lwFSe6Q+zpNMrxReT
         bPPNtJXgHpbiSeJPYdBg3vGUsF9JXLAzFpiDiPM/8BUO1SeYc3Q6dCel7LUMbXxSphMT
         1Sv/0cBTPbPjZE95dZpj9uteWIgqb4NqL49jnjdRJEsEdTdennyZSp3OLeUO1XEVs1eG
         RQytFa9b/jbJkZ4XxVJBg80f8sOLbve6ZZXvqRM/NRtyILFQOo3Eos6YyV1+0UUWTh1s
         IDuw==
X-Gm-Message-State: AOJu0YwITRRoWsoQkwMD71NF+TbrVGRdAGtMX5T/4beFp4i5ospOM3TA
	AlLTePdhwlTKbxckpMupWBeGafgvyeFFJktvvflsp9GW2BQCf14Z/OHtrg==
X-Google-Smtp-Source: AGHT+IFr1yNDAeV0E8HJX8oyRBmW6eWQ77dafhJ8oZIW2UrxNZP4AbKAL45fMzRj2yt8Vg3R2d+TVg==
X-Received: by 2002:a05:6000:481c:b0:382:d0b:179a with SMTP id ffacd0b85a97d-382258f0beamr3061457f8f.6.1731706394306;
        Fri, 15 Nov 2024 13:33:14 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm3397258f8f.97.2024.11.15.13.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:33:13 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 3/8] queue: add region helpers and fix up wait reg kernel api
Date: Fri, 15 Nov 2024 21:33:50 +0000
Message-ID: <c70d4c2ecbec2ec0005903d559bf7c4975a305e6.1731705935.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731705935.git.asml.silence@gmail.com>
References: <cover.1731705935.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now the kernel expects a byte offset instead of a
struct io_uring_reg_wait index. Also add a helper
for registering a region of memory.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 4 +++-
 src/liburing-ffi.map   | 1 +
 src/liburing.map       | 1 +
 src/queue.c            | 4 +++-
 src/register.c         | 6 ++++++
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 4d45dca..81ffe6e 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -285,8 +285,10 @@ int io_uring_register(unsigned int fd, unsigned int opcode, const void *arg,
 		      unsigned int nr_args);
 
 /*
- * Mapped/registered wait regions
+ * Mapped/registered regions
  */
+int io_uring_register_region(struct io_uring *ring,
+			     struct io_uring_mem_region_reg *reg);
 struct io_uring_reg_wait *io_uring_setup_reg_wait(struct io_uring *ring,
 						  unsigned nentries, int *err);
 void io_uring_free_reg_wait(struct io_uring_reg_wait *reg, unsigned nentries);
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 0985f78..117a46a 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -224,4 +224,5 @@ LIBURING_2.9 {
 		io_uring_free_reg_wait;
 		io_uring_setup_reg_wait;
 		io_uring_clone_buffers_offset;
+		io_uring_register_region;
 } LIBURING_2.8;
diff --git a/src/liburing.map b/src/liburing.map
index 998621d..46edbc9 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -111,4 +111,5 @@ LIBURING_2.9 {
 		io_uring_free_reg_wait;
 		io_uring_setup_reg_wait;
 		io_uring_clone_buffers_offset;
+		io_uring_register_region;
 } LIBURING_2.8;
diff --git a/src/queue.c b/src/queue.c
index 1692866..5f28e01 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -324,6 +324,8 @@ int io_uring_submit_and_wait_reg(struct io_uring *ring,
 				 struct io_uring_cqe **cqe_ptr,
 				 unsigned wait_nr, int reg_index)
 {
+	unsigned long offset = reg_index * sizeof(struct io_uring_reg_wait);
+
 	struct get_data data = {
 		.submit		= __io_uring_flush_sq(ring),
 		.wait_nr	= wait_nr,
@@ -331,7 +333,7 @@ int io_uring_submit_and_wait_reg(struct io_uring *ring,
 				  IORING_ENTER_EXT_ARG_REG,
 		.sz		= sizeof(struct io_uring_reg_wait),
 		.has_ts		= true,
-		.arg		= (void *) (uintptr_t) reg_index,
+		.arg		= (void *) (uintptr_t) offset,
 	};
 
 	if (!(ring->features & IORING_FEAT_EXT_ARG))
diff --git a/src/register.c b/src/register.c
index d566f5c..0fff208 100644
--- a/src/register.c
+++ b/src/register.c
@@ -470,3 +470,9 @@ int io_uring_register_wait_reg(struct io_uring *ring,
 {
 	return -EINVAL;
 }
+
+int io_uring_register_region(struct io_uring *ring,
+			     struct io_uring_mem_region_reg *reg)
+{
+	return do_register(ring, IORING_REGISTER_MEM_REGION, reg, 1);
+}
-- 
2.46.0


