Return-Path: <io-uring+bounces-7976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1A0AB6544
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 10:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A018D1882AB3
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 08:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6198521A928;
	Wed, 14 May 2025 08:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C4HvHTai"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE68216386
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 08:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209997; cv=none; b=JKtBNGLVJBVpDrnzV8UyMfz8kOzNmB+Rvyi/j/n4BfeV5GGM95m+21NvC0mw+VrGIXaAWV61dwhkoAZET/p4qxWjMaXy44cBrj1WpvqfY874LFIC7DTWyGMdwDMfiEYS0DVdNDs2UHi+ZnxedfNMGv/FdfL/nguN/xERg/KhVgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209997; c=relaxed/simple;
	bh=URW5YqgyN62yy+XpIjhhcZIKj5N5LFR6dxvVwxuPPYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6iua1fm2/rBQLvBij2tgSHkhHtpKNDjfmZ34L8EpuQKWp5XK03YrmGzTlbGs1x1+xRlOg2gAOwAWgmMfVRD1znMP6D+4+VoQfHPthpzIrYEvEed7+ki0TLl/mQLJ5YwZ4sMBVaGLIODHERn5QsrLXqPE0APUPbbuprDphDRPhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C4HvHTai; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-326c1795b8bso7725501fa.1
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 01:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747209993; x=1747814793; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5GupTiufOMHp8cMgc0RzGQ8H9vC2TwuQbUn8RWQ3oRY=;
        b=C4HvHTaiIsQ2vGvyOprlwrpJ2WLZbHUNFFT4kM/Ib298b2g6hvwriKhznWaLCFLWP2
         oJ4mW+ujqT1k/TJZJ863epGhpP4Fp8r6OqI0VzMA6aVzaCQpR8D8rFRMqACsU7SetlQ6
         pClLp9OqgS249g/eHvoc9mvdSLwaOeF71kCA61Ulb/5+L/jL79rqBl0X8574IakaOFga
         jwENMVRy1F4oYhubGyeXrGMAdrfDTzwOrRAUR+AWU0wnHf3JQ6xqvDHvO+MFTEliHAhr
         H3Pj4lt7Ksv4TuaPB/YKP9tMcCppHKgLOLpQ3zZ9kJUJca32r9fQMKsw5487IZHAygF4
         SAnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747209993; x=1747814793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5GupTiufOMHp8cMgc0RzGQ8H9vC2TwuQbUn8RWQ3oRY=;
        b=SC6A+sjbeJHLeiRXAlOuSV2gHBNJ1L4OAvv/69b+Hgmds35Eg6qaIisQwDissE4ZDk
         kKb9U+JoiFpJvDeooE0phdqJYsE+Iz2XOmYP2tpR9bnzikseLlYVeqMiySITLNYDGRJe
         AWrvs2OxYnzUwfKUmXIVa3GsxLBR9WddP9dRJ8BSvbj8eJOo5/NdtRxAuTIDFrBJKghc
         YrhfUMowT/VmfJj4B2ij88CNbU+RYn4C7AUXXH0XamvXClxWVuMl9UfoVj7XudD36TqT
         c0tTkxOO8RNZ+vwQPPcbr1kaVGL9sqYiYz/AWceZsBtXiRhILEB/lfT75pUhC2RNBP+2
         G9uQ==
X-Gm-Message-State: AOJu0YwG4/4q4xNBN4W9NDi1T/KjTyqeEiJ6ESsWEvEBanPqNi8+XGJd
	kOGwUmNyh52IjpiYejDbBjky6SgM+a/FAygxUS2YVHth3BL7Lm3Nrvutwg==
X-Gm-Gg: ASbGnctl0d/2vPa/PSRoncJrbI64fJVon+9GwzxjdtTejMWi4lDNYF3Ii31vnIqOyop
	S02TAR2+dvhUwFevEggmIKa+/9pjqbNl3PUKDZfZgqBk+GSRb8xpRx3VXDRAhx2STWXa81/mvGY
	hZSQIvhCMBDOOsKebxlbeTQCek0w2QdLGT35SUQX3b3UOQbMS5fZVLRMhaINFVmqiz40kfBf1BM
	5aGdXW593OxDFD+KcMPBEOzIzgmQaifyni+GLhiOvtAQmVKJaT6AXsT0Zl7vbjU40jN4w1GcWcQ
	4Me/ezMyVdhJqXaYWnJdnMMUPaPmyumZXBE=
X-Google-Smtp-Source: AGHT+IH/U4JttLj+dzxPqiTfdp7YxL52ZTHyBofYlJtpGmbLacM+6zkEpHIOU09ErKTAZW6Qj498uA==
X-Received: by 2002:a17:907:1ca8:b0:acf:dca5:80f7 with SMTP id a640c23a62f3a-ad4d52be77dmr634051166b.26.1747209982210;
        Wed, 14 May 2025 01:06:22 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ee61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fd29adb7absm4969579a12.32.2025.05.14.01.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 01:06:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring: add lockdep warning for overflow posting
Date: Wed, 14 May 2025 09:07:23 +0100
Message-ID: <c187a13dfee3a73fcf4f28a05d72e07cf146e924.1747209332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747209332.git.asml.silence@gmail.com>
References: <cover.1747209332.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_cqring_event_overflow() must be called in the same CQ protection
section as the preceding io_get_cqe(), otherwise overflowed and normal
CQEs can get out of order. It's hard to debug check that exactly, but we
can verify that io_cqring_event_overflow() is called with the CQ locked,
which should be good enough to catch most cases of misuse.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 927d8e45dbdb..da1075b66a87 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -754,6 +754,8 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
 	gfp_t gfp = GFP_KERNEL_ACCOUNT;
 	bool queued;
 
+	io_lockdep_assert_cq_locked(ctx);
+
 	if (is_cqe32)
 		ocq_size += sizeof(struct io_uring_cqe);
 	if (locked)
-- 
2.49.0


