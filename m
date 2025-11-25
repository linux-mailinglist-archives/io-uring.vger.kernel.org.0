Return-Path: <io-uring+bounces-10803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A2AC877A8
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 00:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 331EB3B5029
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 23:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422FC2ED853;
	Tue, 25 Nov 2025 23:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HPoyD+Gj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35AD2F25E1
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 23:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764113984; cv=none; b=DRu3i/eyFnbbGWztcfbwDtSyrwBj7XPrMLZJmol4KROsv1Rq0MiSJGPG4gTawLesOfl2Kl5ONRfyf2VFaBmMVJ71/312JcEj24A3GpBg3jEH/apW+iEUdDDey3KYyMxHD52MZYg92uQPH0eAZsd2PPy4J3xYN07jPe5Z1U/aEi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764113984; c=relaxed/simple;
	bh=oPe4d1Dt/kF8ouGFjdvfRNnkBvKL4QPie4rpDGptmqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4hqfqLW+KCkw2Sg4nktX9ZTYs17cCCYEWH8MJV4mNuOw/QYf+T7FQm8NkdfoDBuGmrW0SHzAJ/PW3FxRXW38XdfqL5+9ZbRnoVyzVqJMnv12XQVJ8F3j0kYE4BOtQdZeVQwm5Bxck9sKmceiVZ00v149FGfB9RNjkTeuZdWYDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HPoyD+Gj; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-297f6ccc890so5888775ad.2
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 15:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764113981; x=1764718781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVcZ1kjlWKJeBcL9Jbm6axJm3ukOLpidER5l9zdbGNM=;
        b=HPoyD+Gj9Wx3+XeE+UvYoDA3BuWm7JFY6qqpMQEOfyzcfRanKgXpzDa5ShQHQJr8eP
         vB8KpwWkvkA6M1eAJmoS7plC9o5xsVPFCIPILa+gpHvBI7seeIvRNIGONupu5/Y3nhEw
         WuPhlQtIOBIWA7CI4HtThy7BTF+8jtSMwC0/b/3VGTdfH6O72FMZPZbMpT95Z0YmDlmR
         jQlYjJpPfnv6+Bx5EiQZxxFs8Ez7agMlBOHLgdiLcBeP7qVqjS4eykUT0b4RJFwrPvD9
         F136HTMrj8Wxtv490i+9OXiS4mpjfpMC0hskaQco1EEJnvprHMXOj9VVO4NFU+n17jEf
         yKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764113981; x=1764718781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oVcZ1kjlWKJeBcL9Jbm6axJm3ukOLpidER5l9zdbGNM=;
        b=kp3D36FqtM5fT6kLOkD12EBUYVPPWUVJzO4e4p5psq7rPcjVZ8/eVExYNjFUxDKALA
         uudO5aOw7FK1vuEO+qh/ygdClUWBMDVPY86TYfqWk82GdH4Kak6E3GbxyjXPNDLFgD7Y
         dhjz5qdP3HcdxtYzMbQqK9AoTJdiew3vjTSmHPdLO+/GT+8XJBC3+tprRJ20QX6Vu4GG
         Gqe9qgPhzTvsXMl/UDbvVKKQnB0SDvcJZH+sr+NYXy2XJeTPoGsR2EW7SM+l5IDn7JmN
         YkOIXmiEWasPK+3vj1toEB6EXhNfbxDLH1s7Utx45Y02zG7De/tJgkShH4zMhoxCy9bM
         niPg==
X-Gm-Message-State: AOJu0YyXR+x6QhHHmGNxsN1leijLRrafgMrkx/oDZKQjeBOoIXQWwTf5
	gCqeISoQwwO4vyPL6LpCx8FOh1SvWLaxWxeo9zhhur5p5IkMXW/wVO50fo1qdj1ze/qEPEh7Wr7
	JidTmAiFsYaKXvPfEAkYrXBAilvKizNHYEiEo
X-Gm-Gg: ASbGncuQG9HFp/oPQQR40q0vYLZB6djBVVbLx7083xw0LK/Ng1LkLZpxCNDHuwCwdtY
	XO3NYKfgrBzDFvQdchLnqY/mdpB5/MTjemvoSbJzv/sEsfwQ4EjhTdab869srKxxlhwEuJ0r/iC
	ZSrwlgvzRchQ3LuvrCMAgW8eK98/D57VqAoLk2q3TC5CgkN2aLADClWscsZzHKRuA6ZqAvJCigl
	IXskhflvzub8x258fevLiWm5vuMx3tb5ozeFinC0KXKTYXNx9DPTfWnno/XYo6wviDx9HbXUSF4
	gEuUmemK8UTNr/Cl9q3URgWHDFMs/KSorkdUvW7Pz1FI9R6Ktxdm1evn04irhGYSsXy9lOrONBD
	poy6b2Yf06g6ETPqv9cr1zoBW9h/p2SYs3D1bfoFp6w==
X-Google-Smtp-Source: AGHT+IHC6KWWpHlL/oKY1CixtwVh6OZTqTPIxixKTx2gsuf5v2kwMO7SEEwbn2xVUTsk5aIP+iAbsXidd/38
X-Received: by 2002:a17:903:388d:b0:299:db45:c5a9 with SMTP id d9443c01a7336-29b702764c5mr95171425ad.9.1764113980973;
        Tue, 25 Nov 2025 15:39:40 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-29b5b2420a7sm21392035ad.52.2025.11.25.15.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:39:40 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 7C3D33400B6;
	Tue, 25 Nov 2025 16:39:40 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 74912E41EF2; Tue, 25 Nov 2025 16:39:39 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 1/4] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
Date: Tue, 25 Nov 2025 16:39:25 -0700
Message-ID: <20251125233928.3962947-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251125233928.3962947-1-csander@purestorage.com>
References: <20251125233928.3962947-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IORING_SETUP_SINGLE_ISSUER doesn't currently enable any optimizations,
but it will soon be used to avoid taking io_ring_ctx's uring_lock when
submitting from the single issuer task. If the IORING_SETUP_SQPOLL flag
is set, the SQ thread is the sole task issuing SQEs. However, other
tasks may make io_uring_register() syscalls, which must be synchronized
with SQE submission. So it wouldn't be safe to skip the uring_lock
around the SQ thread's submission even if IORING_SETUP_SINGLE_ISSUER is
set. Therefore, clear IORING_SETUP_SINGLE_ISSUER from the io_ring_ctx
flags if IORING_SETUP_SQPOLL is set.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1e58fc1d5667..05a1ac457581 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3473,10 +3473,19 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	 */
 	if ((flags & (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED)) ==
 	    (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED))
 		return -EINVAL;
 
+	/*
+	 * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
+	 * but other threads may call io_uring_register() concurrently.
+	 * We still need uring_lock to synchronize these io_ring_ctx accesses,
+	 * so disable the single issuer optimizations.
+	 */
+	if (flags & IORING_SETUP_SQPOLL)
+		p->flags &= ~IORING_SETUP_SINGLE_ISSUER;
+
 	return 0;
 }
 
 static int io_uring_fill_params(struct io_uring_params *p)
 {
-- 
2.45.2


