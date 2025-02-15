Return-Path: <io-uring+bounces-6471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FACFA36BFE
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 05:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47BE41892EE7
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 04:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D3C189BB8;
	Sat, 15 Feb 2025 04:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="yE7dAqjH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7741624F5
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 04:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739593142; cv=none; b=aT5VKIynUEVVsRkdGvPOX/iNM4uophO2ZiJarzy0S22iUAFPvo4Bh4ovMirCkYaBt47vTeoPYOI2dVvmR724TPXXwmJ5HTMqaeqLKFuPAN2jmIwS+3ZWJZu8nQ/diOTH93Cb2QalUCRmmgGsLTLkvd4t6jU/wB33c3Sz+7q+RfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739593142; c=relaxed/simple;
	bh=7sKOotP6EARfr5pUIimzhLWR2nCVEdFzBfFCwpNzCps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THOZGd4URPmGpBucHrndHklpo1jvcb+9JrA9ZzcFRRgTG4Cif/PQc+BbZrKN+nS664+W2QiVwfEff+v5vqswA82sgCBdqcHnr03dBD/m2x7HbepAaWm53DTyIX0vi3VLYMb9s1ORrYID+V6MkkBAXutRgDdg030GfWGyricvCkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=yE7dAqjH; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-220ec47991aso20960245ad.1
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 20:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739593140; x=1740197940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D4+HbkDYu6j05HD1JJO0SEA5BbDKjRZbm/0wQZTO5D4=;
        b=yE7dAqjHbVrglRbc52Hw/6Ulfx1HfQ5/PrIe1H4kRJ8vkXDzRt3xbGOurISQ1myroe
         h/RuXlBBfpPChNwqSEDc4gWO5LUsfUB2hfQ/4UWKNpXOwM5mAfCTsamms/Z+BkA4xCee
         y3m4j3xaE5IKr86fFDmOH8m2EVoj1QHqRWk7ADJkb8/CrvexQbdVjY7qrBbnZ3XThQgV
         bXdrKMwPHBw76M+RuMoViFOe6NUh5pyH4aj0DbpDozkmnHhBTTkxHagE2D58EFIMdPLz
         kwn3lH1r179UOQZTsUvA74T4UFGzbvVn/TmKuceOhtN5x2d4e5ooC3a1K4Qahjp+TVlk
         CIHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739593140; x=1740197940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D4+HbkDYu6j05HD1JJO0SEA5BbDKjRZbm/0wQZTO5D4=;
        b=XJK8sLSv1DOhMAv2p5a7A1wOriS5mD0Hwq0U0hUBXU31lTEzzB2VlRtrqeqpYuYazd
         WZ7e9VyX8DrOL3mb5Ut0UNr38TA+dFJYZfCfEDcdNDPRHOu8sduN0ImlZB/Ehc8jJQQb
         EvpQaaxnBQhXXJN0ogEikMMAOLfZ06215y/z2n7SEnKJMbXBlkyHrdRoscLSn35oV3Ic
         w2mdg7/+bnKzH8lXXqB4QskQWPuc+SkFuoJUuDoJz8jUjNzivHY6TOS9m4f+GeC8vqyU
         ZQsGFH10i2NmFWwpRRplUBsWUq7DGcpUJt9wOOdCQ1c8eE7BY95OqK70V201Vyb3bP6C
         FlnQ==
X-Gm-Message-State: AOJu0YwctjtbNR9Wng1fOnP2EGIqJ+hUn9fVZAdrNPFRkZayX+eUfPUn
	SIKcHbkfb054KPzNfLnNwhxQpBji0tfvLCwhrWwk0GV9lxxj79EXAGQOkvwKlQ7xya3IOYYWyri
	j
X-Gm-Gg: ASbGncs9BxmoGzTqjpt3kjB1RulaiGpuBj7YhC0uZDRVLQQKFftRBOTbi/5GMz/g/iG
	QDdGAKriZzeeghvV+OB0gEq6vYz3TD60k12AQJL0UpqhVsziqan0bMAY2rRuj0X0cjbmMeTnEAC
	j+zpdm2JxCZNjt2CFIaElEmSk3m4B97qXALq4vtjYfZXP3hdt0BhPbTRFaDe/TEwWBvVVjfV/OK
	WtKOsTEmz278b4v8ukOYKBm13jj0+nb3vm8bwo9Te4SGQ1w/+zMBkT13JI2Qt4ilMP0sjJb6aM=
X-Google-Smtp-Source: AGHT+IF9b8i30EinfTriNoPGjzMLpD5+XGqXYWt9WyDkTgrioOdqSeE//2eiElRigFcLCLZWmp7I4w==
X-Received: by 2002:a17:902:d502:b0:220:d6be:5bba with SMTP id d9443c01a7336-2210408f37fmr29842675ad.33.1739593140507;
        Fri, 14 Feb 2025 20:19:00 -0800 (PST)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d556d473sm36073305ad.166.2025.02.14.20.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 20:19:00 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing v1 2/3] zcrx: add basic support
Date: Fri, 14 Feb 2025 20:18:56 -0800
Message-ID: <20250215041857.2108684-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250215041857.2108684-1-dw@davidwei.uk>
References: <20250215041857.2108684-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add basic support for zcrx with a thin wrapper around
IORING_REGISTER_ZCRX_IFQ and a struct for the refill queue.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 src/include/liburing.h | 12 ++++++++++++
 src/liburing-ffi.map   |  1 +
 src/liburing.map       |  1 +
 src/register.c         |  6 ++++++
 4 files changed, 20 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 49b4edf437b2..6393599cb3bf 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -132,6 +132,16 @@ struct io_uring {
 	unsigned pad2;
 };
 
+struct io_uring_zcrx_rq {
+	__u32 *khead;
+	__u32 *ktail;
+	__u32 rq_tail;
+	unsigned ring_entries;
+
+	struct io_uring_zcrx_rqe *rqes;
+	void *ring_ptr;
+};
+
 /*
  * Library interface
  */
@@ -265,6 +275,8 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 
 int io_uring_register_napi(struct io_uring *ring, struct io_uring_napi *napi);
 int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi *napi);
+int io_uring_register_ifq(struct io_uring *ring,
+			  struct io_uring_zcrx_ifq_reg *reg);
 
 int io_uring_register_clock(struct io_uring *ring,
 			    struct io_uring_clock_register *arg);
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 83593a33826a..cedc71383547 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -222,6 +222,7 @@ LIBURING_2.9 {
 		io_uring_register_wait_reg;
 		io_uring_submit_and_wait_reg;
 		io_uring_clone_buffers_offset;
+		io_uring_register_ifq;
 		io_uring_register_region;
 		io_uring_sqe_set_buf_group;
 } LIBURING_2.8;
diff --git a/src/liburing.map b/src/liburing.map
index 9f7b21171218..81dd6ab9b8cc 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -109,5 +109,6 @@ LIBURING_2.9 {
 		io_uring_register_wait_reg;
 		io_uring_submit_and_wait_reg;
 		io_uring_clone_buffers_offset;
+		io_uring_register_ifq;
 		io_uring_register_region;
 } LIBURING_2.8;
diff --git a/src/register.c b/src/register.c
index 0fff208cd5f5..99337d13135d 100644
--- a/src/register.c
+++ b/src/register.c
@@ -422,6 +422,12 @@ int io_uring_clone_buffers(struct io_uring *dst, struct io_uring *src)
 	return io_uring_clone_buffers_offset(dst, src, 0, 0, 0, 0);
 }
 
+int io_uring_register_ifq(struct io_uring *ring,
+			  struct io_uring_zcrx_ifq_reg *reg)
+{
+	return do_register(ring, IORING_REGISTER_ZCRX_IFQ, reg, 1);
+}
+
 int io_uring_resize_rings(struct io_uring *ring, struct io_uring_params *p)
 {
 	unsigned sq_head, sq_tail;
-- 
2.43.5


