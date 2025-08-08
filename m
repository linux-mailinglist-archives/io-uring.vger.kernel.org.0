Return-Path: <io-uring+bounces-8911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA922B1ED97
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D39AD1AA3A48
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1843D285068;
	Fri,  8 Aug 2025 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OyYzmLEd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F5B1C2437
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672630; cv=none; b=qXjueRJQf1v/vEOi7Dp3FDZQ2TaQf4lRMsqYEa2bdjrHes8LnbYctqI34aaEhPJlnNhH/GY2z0GXN9ZVX9RLqUL4z9NU3kp9Q3z2qdjSuTXud7PBb2nodZ3nb5xuGHJLTsR6DmHbx65BA7J74Q9KVzlq9S9yNGTaRYH+tD7qufo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672630; c=relaxed/simple;
	bh=xPbQByOSrp5RjthTsozUAYWwOm+oe6o8g7NeUaZb8D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqRLcRq9vevY4b7IM4tQJBtAvzJz3OW0IIlaG6xkeV70o5wYGyeSyy9/0fOBORb/vX31Es/f0KNB8jSTdei4fp1L4Oo6rd6W/9LOpvUjwZfp09ugXgpXBCsPF6HMpCPBKeC/uFlmwjDuRIk/AvBfplPEs4rI1s0x5PcG8OylUpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OyYzmLEd; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-8817b8d2d0eso79348339f.0
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754672626; x=1755277426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2xVFfFNBhrna6vpBjgVFxc6A1YA4pymbCKu8QgDnYw=;
        b=OyYzmLEdftnBR+ie5vZCZcrR93mk6GtsaNsEVyGpzrlE8QxdyAsZ0qy5BCt9iLuw8M
         YHztrBa7D7qy0p0GcUj8PpwoOURgYEFVpmDZvDMOjcqaSxMCEYLCYCo4goNlKTgqeg9E
         lJADGT8OraRZwZg6S60EgkNZnk7Skv+PLKCoa5uNd7FLlB4HZ/z5ZLxpxqsVCspWbtUM
         fwDOU8pqKxOLeN8+Hllpr3cnRjg4soj4KxnrrUX6MuFtxbVp5467HeYzs7sGGisEa2MT
         WBt8CqCChDTlv5NMSTEzmvb7oJCN420K8Gs2xodczik4x4bYNABSxR7GMjxY931iQqXJ
         QR2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672626; x=1755277426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2xVFfFNBhrna6vpBjgVFxc6A1YA4pymbCKu8QgDnYw=;
        b=fLGupR6q2OrpUTbF8zc5FObu/JWN9KZT3h/girIM0+yoD9OGLAm2DEiB2Bn5qPcdtf
         buQmw5hXRMsil87F1G2//PFuZRQ814kKd29QNBLVa2Y8tQQaTfPVIvgR3e83qfSVwkv5
         +Y+2st+UJvEffSreqplSLcU2O7Xc5VyQeeVSqJyUItsg7Dk5D2Cn8/2r78YBVAIYxTUo
         NCZDTlWxhIopf+Mrk8dVlmELNMMAGPULRwmIiuW3nmInBlEaEoPKFRGIZfs/QgM1nqOI
         hCHEgXPuhCJ5E0AW7I2TOitguRZ9udt7cwRVVyvLNQoKvFX8Ime8ohfc1QBV6fk+OzJ4
         VoQQ==
X-Gm-Message-State: AOJu0Ywg4RVxJvUqUOX95lahUoCDForLFQBaXe4omEFrP9GozXrOXrLA
	1MTMA7zqZZEIgdarFf2eIfQA3n5DUSBur3Bd/8pGF58GmK9yMZzMPes9zEWvgyI5/z4nDzYsQMN
	5OVn9
X-Gm-Gg: ASbGncsZFDcsinmIbgS5WMtEeCdwkzyctdE0fgJRRsNu1H40j4w8WX9sdgoKdke2Zsv
	wQpnJvv8INGPV1VtqoHy3LQ0U2CYScoIA7LPzBuoPH77vkW0XSRYBEYCWde50KxNbJ2ah876Pxa
	xgiucXVjgXowzqwsAgHbddWTGkPL6l3JNnDPKPaMSOLjsXf+icNsDS58ALNxP5oHOyW6tScgXOk
	NNkZIHqgKP0e++Hy/JuzpIiShloZ/4dzcIZet3DXsvxla0Mv9mx3Ey3v7ZK7qZkuXWlkOAVWDHw
	nuQfqa/nSjPjYrH0hCeIbZ1Y+3pLByWyni1xAjsxabQiQBdz1/ZMA/SKdRaQADcxCQ+87rIzTBZ
	18gyz2g==
X-Google-Smtp-Source: AGHT+IGTqeFzXc4ewBFRPHr6gALN5jYYgZ6xbkBFc3rCCzC7JqnmrRImM5vcCgupiDLvzDLT0PZ+eg==
X-Received: by 2002:a05:6602:2d82:b0:883:e4c9:93bc with SMTP id ca18e2360f4ac-883f1259016mr642955339f.9.1754672626179;
        Fri, 08 Aug 2025 10:03:46 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f198d65esm68203439f.20.2025.08.08.10.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:03:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] io_uring: add UAPI definitions for mixed CQE postings
Date: Fri,  8 Aug 2025 11:03:02 -0600
Message-ID: <20250808170339.610340-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808170339.610340-1-axboe@kernel.dk>
References: <20250808170339.610340-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds the CQE flags related to supporting a mixed CQ ring mode, where
both normal (16b) and big (32b) CQEs may be posted.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6957dc539d83..69337eb1db33 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -487,12 +487,22 @@ struct io_uring_cqe {
  *			other provided buffer type, all completions with a
  *			buffer passed back is automatically returned to the
  *			application.
+ * IORING_CQE_F_SKIP	If set, then the application/liburing must ignore this
+ *			CQE. It's only purpose is to fill a gap in the ring,
+ *			if a large CQE is attempted posted when the ring has
+ *			just a single small CQE worth of space left before
+ *			wrapping.
+ * IORING_CQE_F_32	If set, this is a 32b/big-cqe posting. Use with rings
+ *			setup in a mixed CQE mode, where both 16b and 32b
+ *			CQEs may be posted to the CQ ring.
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
 #define IORING_CQE_F_NOTIF		(1U << 3)
 #define IORING_CQE_F_BUF_MORE		(1U << 4)
+#define IORING_CQE_F_SKIP		(1U << 5)
+#define IORING_CQE_F_32			(1U << 15)
 
 #define IORING_CQE_BUFFER_SHIFT		16
 
-- 
2.50.1


