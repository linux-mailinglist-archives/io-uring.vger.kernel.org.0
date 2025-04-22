Return-Path: <io-uring+bounces-7623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD310A96F2A
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0BAF1B60E43
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0915FB95;
	Tue, 22 Apr 2025 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f1HpgV8f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EDF28A3E1
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745333017; cv=none; b=d8/J6KgF3bBcgis1J5UMTFS7Qdz+oh6WpW0Nfd65pbExWTPsOKZnxqDc1oJybvDRht3BFrognf11goLk87nunRxRgE2uifXtYL/lIj5fitHIHV4h238EdKuyxXmWyUal+PfAUhHeqVw6esPIZMsh4FXmJYGnWrZIue3Y3oqYq1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745333017; c=relaxed/simple;
	bh=UkunO+LQ3n8l2wK80Tkl3FgY+s6E5wq73sLk6kFKaj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOJadHQewHZx/63Mqh7LAwoBmejfggc/OpIijKDK5cC0VFI12m7cQvsHH9SfhM7WmPvyFUs00xzI8JDuYTjQf/IuTL6l9l6MLSib3AtkeGzUPnhWif+EF7hRkJKzjXY9nIrqKIKfu0Jvuk4VfJD1FpuYwQLBHAwUbCk34kRtRF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f1HpgV8f; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5e5dce099f4so6420743a12.1
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 07:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745333014; x=1745937814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytX5PnuAvl+uSBHFhhilk9kHuR65JjURXJPPDxRIf/E=;
        b=f1HpgV8fkZGngjdcaWaHE11oyoYuXj7//6zWHTntqIANmJeTd/616R5mRGFMhcKveG
         nKPIvKZJ7g8bdp/xOFAd3XTiZvuVuCA+1U/ka94coV2P+dJQxiDAadS/jccXxCzxQ7Oe
         5Er1lbjq2blzwpfC9yS3E59uKRiAMTcqN3yHK1ABs2DSeE1uqAoQIBw0oshrUBX4w6n/
         Ah6WwwnzA/+YM80Ib0IqnYIWa/PaKWh/oGz3aEEHYf4ZJCOLRxwu1sNYKnQFL8yrWUvM
         J6Rralym6ITVlwVMRMt55APt53/GyZ4TWokdAKBBCxyn+2ywO/3xS9VCMtOv5M4t5F1U
         tdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745333014; x=1745937814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ytX5PnuAvl+uSBHFhhilk9kHuR65JjURXJPPDxRIf/E=;
        b=Nbwzj3A4q0bzdvxNIkw1jDJPKzlnnA+eeg+w0/CSug4VSsyFZs+qHXaWVRnfrOE4St
         tSERzN247n/uE+XkawqNiMbFLUV7To7ur5nF8+P/Fqi2/I17aH2mCldx5aSRgKMRsbVm
         nk7PbS2yftHkcefYkTtPYuphAkOOReyxIFJG8GnQcsDM21D/KEOS+fsG+w6vP/cic/W/
         wdpSD22I+Tfh6XFdHuLKvefw9gga2SGe65bfrg4Ivuh2e/74cg7P6w97DDn+DsLW4ci4
         Jo7++pwIDegtgDhVtyEaIdzXkRusgkM0fsf2tP3UriLgzRTPgJeyJlccGbQr0b/rEJ5j
         hY7A==
X-Gm-Message-State: AOJu0Ywl5wDUzqnS4khYY3SPeMYIesnBR3mOCY0TdneD6L84aFkcOS6C
	EdhjVmIJNxU/9db/vydTbpvJ3Sn6JyWTGdAOETPR1ZUF8gPcXn9lHt3x7A==
X-Gm-Gg: ASbGncsaLE8gNQtahmfB9B4Sr4pPCTQNXLIS2ZjxA75pbMI2IWfr1VmNNRIYOTz1B2Y
	VszDXtsxCn/ir5VAPBcDEzdU5vwklcH/dMdpeK2Q3T2STy7i28VAcCv2nObJSnfItBoArQqJouv
	JKR/JiB7dhgqgh01vmbBykjxNo5Bzuh7RhWpfHlOCWEAe2i7zgTZkmuX1/+FKWru26MV6mtohWC
	lam3fsLpZMDkj9+LvM5epctMWmFioenjZkjEB1VcuBANeezuK0aCwVFRRBuWD8/1Fat6MqKQqcE
	Pqj9LxEd7NSYuQiyW4WodXh0
X-Google-Smtp-Source: AGHT+IFi7k1TQuhmy5RIAVUB09reghns0OBPyMdGFwaCjQNIUarqCG0R0fL8ukEAwsFtKIsA4hD3TA==
X-Received: by 2002:a17:907:1c90:b0:aca:96a7:d373 with SMTP id a640c23a62f3a-acb74ddd2f4mr1246158466b.57.1745333013621;
        Tue, 22 Apr 2025 07:43:33 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be5e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef475c1sm655374966b.126.2025.04.22.07.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 07:43:33 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 3/4] io_uring: export io_coalesce_buffer()
Date: Tue, 22 Apr 2025 15:44:43 +0100
Message-ID: <99eafabfd2b92d9994825aaa7d022de80e5e0a10.1745328503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745328503.git.asml.silence@gmail.com>
References: <cover.1745328503.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll need io_coalesce_buffer() in the next patch for zcrx, export it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 2 +-
 io_uring/rsrc.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b4c5f3ee8855..572edf843f40 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -681,7 +681,7 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
-static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
+bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
 				struct io_imu_folio_data *data)
 {
 	struct page **page_array = *pages, **new_array = NULL;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 6008ad2e6d9e..2621be73e7e2 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -87,6 +87,8 @@ int io_buffer_validate(struct iovec *iov);
 
 bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 			      struct io_imu_folio_data *data);
+bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
+			struct io_imu_folio_data *data);
 
 static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
 						       int index)
-- 
2.48.1


