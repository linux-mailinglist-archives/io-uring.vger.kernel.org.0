Return-Path: <io-uring+bounces-4748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C66E09CF910
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E86F1F2149F
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 22:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCE51FDFB5;
	Fri, 15 Nov 2024 21:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qk2sRBUJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154D91FDF92
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 21:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706412; cv=none; b=SS2NIN/CLkvB/gsXfeTwdB6eImK5g6V1OheSZfE2K4pCUdccpTw746gPxbeY0OpdYVfpnCt7b9IqXwSL1CZLv036B7yuwtBGxw4+NcQDVHbTO7LoaQR1IPTztp9zB9DilRXjuSzoHx8NXQMvY5TsHg3H22d3yER5hv+W8y0dPa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706412; c=relaxed/simple;
	bh=NeFPRkwmvOW6soOcqIGT9FpG7YZZwdysSVuoqA9P5z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ06kQCIJYNAM6yoKoETffe5ttNeg7/6G7h4ujLbU6XA9N0NYNjg8dXYkINP4rzTldY8R22zpwaWljUafX2Bdew5TpWd2KvwflQx32vrRppv9h01hZFCVAJxNAYZastGHn+ZmztlRhmuwEPqp2A7IJ/hMx90x2QmN4untqAGloo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qk2sRBUJ; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-37ed3bd6114so18849f8f.2
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 13:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731706409; x=1732311209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q4sux6pWyRAdlHsTgCCZRgw8Yi6YXBTsftdjdD/Maio=;
        b=Qk2sRBUJZCJ88o5WC+eOHkekgF1IRT/ay957FUM8X82TTEnTmbFGnMkfMjSrh3PSLy
         obuE7HG4fGlzVtngtVcxV7F3Rgz4UVlZ3qu+JwL7YdmqcKqxeLjB+c9V0AfHWgkACYW9
         16Z5uGg2SnQT8sWRwyrsoGSxLFDmQica/RLiSwHgNFKJvv1IbtYf+YNPtRZcgUTndgQ+
         y3kDyB1dligbHPC6k2MPanCxl8/d5YdAO+jrKvX0vOVZIn0ILer5mTBbMJE6vAI2K6S0
         5vobZ1bB670RzZ5BRQCI0tuzEJbJAFQRBg2EgvcwgXMB/AN6rHIIVQzp9z+blYgPQBBI
         5USw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731706409; x=1732311209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q4sux6pWyRAdlHsTgCCZRgw8Yi6YXBTsftdjdD/Maio=;
        b=m4aLmaCm/xC9EiBWug2030n9bS3wb01xujCQWBY96I3oRd0oh6jbYB18MEl0DBqrre
         pVd2ZDgQ4vf2uU3Ac2y2NdbDS57Rxx3H5nIcA1av95mYDq/0XAVQb5wRHkcbzOFCxhLv
         Illzwghf6x1YOtbL4gWc3F40m5T8IVjynct3bq20Tz2HB8/uuhJUb7OTz7FFJlCFa5Fw
         yjerTh7iuQwNLGraho2Vj4cx53BYadaFPld3yWNynofyvOppHGbTu7ogOa8urbo9sJl6
         FwYVOxGsj5pWdw6NnEFwVFohRopUbPVBpHFn/t9+v28u1mrKxU88NIopPA4NnaKWQHkB
         Qwag==
X-Gm-Message-State: AOJu0Yw1qw+IaoBrWmvTG7ih5DEXStMBAXDJO/2Bk9y+QZRysTgUlE3k
	oigDOL5CwClpQ8OooxItgs0HUWclu/t6ZUOcKdpbZTnqFsBmN6a1e6qvVA==
X-Google-Smtp-Source: AGHT+IFPVKoaLc/qoNtWrBqMcwqO+QcyAsEAYrKKPJ0914eDVkvMvgGRosZj8FigQrvrux8ns/Q+pg==
X-Received: by 2002:a05:6000:2c6:b0:381:ebf4:b57a with SMTP id ffacd0b85a97d-38225a925e5mr3723229f8f.44.1731706409049;
        Fri, 15 Nov 2024 13:33:29 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm3397258f8f.97.2024.11.15.13.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:33:27 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 8/8] Remove leftovers of old reg-wait registration api
Date: Fri, 15 Nov 2024 21:33:55 +0000
Message-ID: <3c0b35b519e0ee52c4fe8ed5aa1c2498a55470e9.1731705935.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h |  3 ---
 src/liburing-ffi.map   |  2 --
 src/liburing.map       |  2 --
 src/setup.c            | 10 ----------
 4 files changed, 17 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 81ffe6e..627fc47 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -289,9 +289,6 @@ int io_uring_register(unsigned int fd, unsigned int opcode, const void *arg,
  */
 int io_uring_register_region(struct io_uring *ring,
 			     struct io_uring_mem_region_reg *reg);
-struct io_uring_reg_wait *io_uring_setup_reg_wait(struct io_uring *ring,
-						  unsigned nentries, int *err);
-void io_uring_free_reg_wait(struct io_uring_reg_wait *reg, unsigned nentries);
 
 /*
  * Mapped buffer ring alloc/register + unregister/free helpers
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 117a46a..9af1fb9 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -221,8 +221,6 @@ LIBURING_2.9 {
 		io_uring_resize_rings;
 		io_uring_register_wait_reg;
 		io_uring_submit_and_wait_reg;
-		io_uring_free_reg_wait;
-		io_uring_setup_reg_wait;
 		io_uring_clone_buffers_offset;
 		io_uring_register_region;
 } LIBURING_2.8;
diff --git a/src/liburing.map b/src/liburing.map
index 46edbc9..9f7b211 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -108,8 +108,6 @@ LIBURING_2.9 {
 		io_uring_resize_rings;
 		io_uring_register_wait_reg;
 		io_uring_submit_and_wait_reg;
-		io_uring_free_reg_wait;
-		io_uring_setup_reg_wait;
 		io_uring_clone_buffers_offset;
 		io_uring_register_region;
 } LIBURING_2.8;
diff --git a/src/setup.c b/src/setup.c
index 7c0cfab..d4694f5 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -686,13 +686,3 @@ int io_uring_free_buf_ring(struct io_uring *ring, struct io_uring_buf_ring *br,
 	__sys_munmap(br, nentries * sizeof(struct io_uring_buf));
 	return 0;
 }
-
-void io_uring_free_reg_wait(struct io_uring_reg_wait *reg, unsigned nentries)
-{
-}
-
-struct io_uring_reg_wait *io_uring_setup_reg_wait(struct io_uring *ring,
-						  unsigned nentries, int *err)
-{
-	return NULL;
-}
-- 
2.46.0


