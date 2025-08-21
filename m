Return-Path: <io-uring+bounces-9160-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC593B2FC65
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98F84A005DD
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 14:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070EE28134C;
	Thu, 21 Aug 2025 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YPbBnAPT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDF724DCF6
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786005; cv=none; b=kNhOLyicoQnOuNvlOrwthZCAU/WUUzMmddYprBvhWN5cTL+H0tEH8I7HMBIE2tZf2P1U6URPFeiBQ0ssysaDepOlqBF3Gn2fMgfN0dZRbTloT0Vmy66SIyg1BkGt+D7js5XGms+8YzvxhaqVvZ3TammLsHv+cgo3sYyxJWXZZ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786005; c=relaxed/simple;
	bh=FJnk3uTROHPTmKkA08/RhvDrtZdwecJd7881kB/Io2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuDosKmRySM1IhIEF7Gh+HJsK+uz5fPLFJMa50NAIXfx0pL0Mnxpv+sGdIEuVRN4Pe1tRwSoezVgssPx4cniJEQJ9+K8vja0/GOP/Ur9jBkd7JZ0uxx0zm24oSzTKOqoy3h3pcjZ0Bzxc2HIGSSRuRxZ/02xU4lE/I8kly1hIbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YPbBnAPT; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3e57010bc95so7632725ab.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 07:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755786002; x=1756390802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XmKTd6DChalHxJNKAsFEuKPqsFnH55iED9kA3/7w4WE=;
        b=YPbBnAPT5MMp+CrfKYWbldC/AxWzTPXSiq49jo60QHInpO30ukgSuX8IXuVP3zlmyi
         +GegL5oJt48kGXbOwejPamknheD4bBUslRZGcf5lJJa0YxIP2g4VT0zrOgRSt/fGBqQv
         tz/bLucNcCuZelTztlfqPT0fq0cUSGHgrGfIAGAN92wjgPOTIxGrPmbaP/wODgzkBJBm
         UIo5OY9E3d3k+GFDqmZecdenNwrEKk8GQG7YHPzK5wh8aE2mzjnHm8SvvpMKZa/MuXOh
         rsVAatqCKDsZ7LMUexGXSgZt9w+N6oPpYkhJurZV8agYcQ4KHaADYgRUea1DKk7Adn7J
         Mv8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755786002; x=1756390802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XmKTd6DChalHxJNKAsFEuKPqsFnH55iED9kA3/7w4WE=;
        b=VTzkoUeeTnr5DRC87yjmHbvikeS4y4Qc0n1orh+eLYEwwiJwFNfnq8zdZvMjAOUiS0
         RTToXpNs3T/SGy/uv7+aZR5UXaUjd1Ie7MpUo97H+1LMTRd0u9isLxSxCiyo9pQ7MvdM
         JK8xRPtuidD/ScZNJNqb839IATrLFGvrI2kG9SJejsm2xbU8ZrUbBDwH6XAiWPAMr/PJ
         xtlhfZT7dDHL/41ZtB+T9tHOCYMcXUNbQzuhVoZV+QEQF3SVkouvFXpSU1swQ4l6Nn0q
         4JJTt1R168ZBAJdndaFRW2xwz5T8lErkyna8X3VgCsrEaHsWJ85dIrWl2drrECw1+lNx
         uPKw==
X-Gm-Message-State: AOJu0YysUcQATLkCnDANf2gZA7l73rMQnNo0bbgy14+JLmfKbKNLYbRq
	IoEZ2q3s2BNU0zsjVokFibdX/eV6b9B3lQBuCddOz51AOZ2AWs7/7N1Hcwv7xnKJyN16odKMSOj
	vUXHI
X-Gm-Gg: ASbGncsj/MlMk5hBY6TL+DacwOiCfv/SI6AyZGigyz7bKKsvKZWZDLgmWF87NYo06Ss
	EmxTB+mROwIFYzjeWG/EBI7QXbtiw4EpypM2Um+TQCYpJGDJqGi9uMwMZf9hr3cCuaWRbNV2gZW
	IIkJ1q5HHpNFfk8tNcVGvk/R5BfO5PrE8Nb8GIfFfPR9RsDpvmofA1cnM4WItqRj6DuWVZb5MUN
	tl3mOHA6yzbXBSJOkvBdUq3pI1sBImbnv/okCgwsENCZqmB9jn2B/HU/I4kqxNZuxMpPqfKNZZq
	LKmOIJJTk5jfL4dlQaM8dL+fRK5gl8DXyJDjEiRmSvQJK5mRnQmFJMnIBiKXm9zTfsN9KR9XPKA
	AQN5GxQ==
X-Google-Smtp-Source: AGHT+IEP4FA1db8T7fwUC0yaixaf0rKws5McODtgshcsePcf9PhduNOfHYGi3ky/aYGBX02T5gAhvQ==
X-Received: by 2002:a05:6e02:3e04:b0:3e6:ab3a:f9e with SMTP id e9e14a558f8ab-3e6d84ea743mr38031225ab.24.1755786002247;
        Thu, 21 Aug 2025 07:20:02 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e58c1basm73196595ab.5.2025.08.21.07.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 07:20:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] io_uring: add UAPI definitions for mixed CQE postings
Date: Thu, 21 Aug 2025 08:18:02 -0600
Message-ID: <20250821141957.680570-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821141957.680570-1-axboe@kernel.dk>
References: <20250821141957.680570-1-axboe@kernel.dk>
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
index 1e935f8901c5..7af8d10b3aba 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -491,12 +491,22 @@ struct io_uring_cqe {
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


