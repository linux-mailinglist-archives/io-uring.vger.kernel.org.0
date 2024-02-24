Return-Path: <io-uring+bounces-689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CA98622AF
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 06:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FA661C21B83
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 05:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F8016429;
	Sat, 24 Feb 2024 05:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="t/+drhIz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D096E13FE5
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 05:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708751270; cv=none; b=AMuHLOsG03m+usCnS1VGO/ZCTUMQELh3Mf7XfAEUxR0csFNjN4xvXF5IEhp6UprXG8YAdDVjwJx8Os+z3n3hXL3rZF9mxv1HeqXRUsymXYPbao5x37eQxE2/bRG9da80a+FDlAnHW5SZFJD1NarHoypu2mYtdM+AwSUXzH26P/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708751270; c=relaxed/simple;
	bh=MUCelfbEnJxFc4UHpHb7G3ylE0wMOiFfSiBd7d0DJ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdqyU9wkRM20820yPmJzJ9WI5yIm4OJwx9WvDD/JE/1J8aEWO/5rVIAl6JIZu9q6cFW3pzyNHTp0rNXHZnGKLeeUBk8GU1g2nc2/hUz0vm2/r3RNfnZKd4XAwbuwZ+5VfShBYaHEW9AupMNUS6H1eOjAwRXDhFzNtHaUFII+TGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=t/+drhIz; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dbf1fe91fcso13463525ad.3
        for <io-uring@vger.kernel.org>; Fri, 23 Feb 2024 21:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708751268; x=1709356068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7/8si6PIugm/jB7oq1cCOR5SjQTiCtweC1NZaO9RyUw=;
        b=t/+drhIzf7O8IuRssSrGg/xX/azyByl9zJhPXcPbkSeO5YGPnv2XrFpzZQlxbPiWCo
         PyHZcJhyEKaWXThmgJqBeQtONqi00qSZCZ97MpPjyVrjaqT8c9XdogaMTT6oPQ1GH6Lq
         /AU8lDVVViQBHBwmAdMGp444nmwvPYN5d7wXgv+s8VbKLPVOkjTUVzNsaa3+ArMDwf/G
         +jDu48XfLnSXszQxVhk/RXAFQRTekVWhPV+kfxeWr6e4VZzVl1FIbXwZoX/dGUzceoFT
         jgxj2mHfwFhtoqBh3xl4V5Zx16t+iIIwJvetR0H0xAKfX4DKmLW27eVg7pifnWuWNPsd
         6w4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708751268; x=1709356068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/8si6PIugm/jB7oq1cCOR5SjQTiCtweC1NZaO9RyUw=;
        b=lbxI3OhPey6rVKoxv3a9rQg2RvHCun3R0I+DRrL4M/vWzIlC3eOCs5P8GcV9ip9qYl
         kAvhjT2BA9fTG52SBsIujiX172q9QClImH3ui3qlAffBT3Hy3cMz4cXW74qsokPJsNef
         /uNkOUFKWtbyOrBuTT4yPEZgp9ElfWManvXH2ZVt8tlMNWHag2MsjovH9JjrG+uqMNdO
         xADbDSoN2S/Oxlbb1CvzoJAC+2DhVk1yUHpWJkkzvQZPj8vV6gnd0vlHNO14YxKjOhtI
         DO8q5Sst8PDkktSc90//OcVgoFOdhVIhxyLAGlq0q/Gg7hDOpGZlprczAFi0DMNa6HdI
         5X7A==
X-Gm-Message-State: AOJu0YzSVjh2UA6pUOfwKDStiIRpeDhXx4xzJZynZJ8Qa09rC+peCFcm
	pqzhbjmunOHE5v/E+JEzAnQQhWSZ9KkDbKod5T1OhA+UH60Inenkdc9OUOV7BYSMKdw4FMvARwi
	k
X-Google-Smtp-Source: AGHT+IEeQEvl+Mp9NheHJPx3zrz3pgzqlutQxuiT0sREP9a7FR2DnCRfK4y/ewMMw+/SuLva6AGkkQ==
X-Received: by 2002:a17:902:eb8c:b0:1d8:ee44:629d with SMTP id q12-20020a170902eb8c00b001d8ee44629dmr2367222plg.30.1708751267886;
        Fri, 23 Feb 2024 21:07:47 -0800 (PST)
Received: from localhost (fwdproxy-prn-000.fbsv.net. [2a03:2880:ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id z5-20020a170902ee0500b001d9620dd3fdsm259882plb.206.2024.02.23.21.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 21:07:47 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 3/4] liburing: add helper for IORING_REGISTER_IOWAIT
Date: Fri, 23 Feb 2024 21:07:34 -0800
Message-ID: <20240224050735.1759733-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240224050735.1759733-1-dw@davidwei.uk>
References: <20240224050735.1759733-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

Sync include/liburing/io_uring.h and add io_uring_register_iowait()
helper function.

Currently we unconditionally account time spent waiting for events in CQ
ring as iowait time.

Some userspace tools consider iowait time to be CPU util/load which can
be misleading as the process is sleeping. High iowait time might be
indicative of issues for storage IO, but for network IO e.g. socket
recv() we do not control when the completions happen so its value
misleads userspace tooling.

Add io_uring_register_iowait() which gates the previously unconditional
iowait accounting. By default time is not accounted as iowait, unless
this is explicitly enabled for a ring. Thus userspace can decide,
depending on the type of work it expects to do, whether it wants to
consider cqring wait time as iowait or not.

Signed-off-by: David Wei <davidhwei@meta.com>
---
 src/include/liburing.h          | 2 ++
 src/include/liburing/io_uring.h | 3 +++
 src/register.c                  | 6 ++++++
 3 files changed, 11 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 6850fa7..5e39cc6 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -241,6 +241,8 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 int io_uring_register_napi(struct io_uring *ring, struct io_uring_napi *napi);
 int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi *napi);
 
+int io_uring_register_iowait(struct io_uring *ring, int enabled);
+
 int io_uring_get_events(struct io_uring *ring);
 int io_uring_submit_and_get_events(struct io_uring *ring);
 
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index bde1199..ba94955 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -570,6 +570,9 @@ enum {
 	IORING_REGISTER_NAPI			= 27,
 	IORING_UNREGISTER_NAPI			= 28,
 
+	/* account time spent in cqring wait as iowait */
+	IORING_REGISTER_IOWAIT			= 29,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/src/register.c b/src/register.c
index f9bc52b..7f2890e 100644
--- a/src/register.c
+++ b/src/register.c
@@ -368,3 +368,9 @@ int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi *napi)
 	return __sys_io_uring_register(ring->ring_fd,
 				IORING_UNREGISTER_NAPI, napi, 1);
 }
+
+int io_uring_register_iowait(struct io_uring *ring, int enabled)
+{
+	return __sys_io_uring_register(ring->ring_fd,
+				IORING_REGISTER_IOWAIT, NULL, enabled);
+}
-- 
2.43.0


