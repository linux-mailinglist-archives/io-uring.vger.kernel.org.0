Return-Path: <io-uring+bounces-6347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BECA31685
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 21:21:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E851E3A6CF5
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 20:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143DC262D39;
	Tue, 11 Feb 2025 20:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="e25u7Awp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f100.google.com (mail-io1-f100.google.com [209.85.166.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64401D8DF6
	for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 20:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739305254; cv=none; b=YChGrBVRacsy9gtLArbVgfy3G+vTD6aS8I5+KgoBmyKxuqXEC6AHHHp5c/kLRHcBRnqSasOtWj9Y04Isb6vClNSyaWJxYz6wKvOxzZCXmIngvxe8vfZdcmc6d3S0l+o3EtbDHtIjKitglbJq5swBUQXbwV4d37VpTC/vgvJDEl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739305254; c=relaxed/simple;
	bh=PU/4T9e5pHugUm+/ZNeeDqDdiuPHBuEOUvo8/mnQE9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ya/5fmOv/X3tiM81ELfe18lutVNpsi2yGTNzy0fehqTj7e5p3edYNSd7t2WHvmwcUzRG4a54pTwy/BWfuNcoCJokVfC9G4xakh8MVrpBthnp4m0H6NX+WAiI/dlSbo6OxsqklRUhAyn/Nh3bUpifBbfJnMRhZByIhna7XMQen/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=e25u7Awp; arc=none smtp.client-ip=209.85.166.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f100.google.com with SMTP id ca18e2360f4ac-852234ac7efso21558439f.2
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 12:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739305250; x=1739910050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=csJ7f6rdwklnGRErPjOt9JKitwpK8CwkZyN2fZNR+N8=;
        b=e25u7AwpN460hhdt4i2ViH9/bz6ojk36ckyTWTl7Ql7+BGhj49LhsG90/+Hw0AUJwX
         /HRN2//HYcjsk3HsjojPoGVO/L6xgjA7RG4CLSY9QjOksAsMuG7CCfKKv0L7PVlCT5Wb
         g4k02gDZ8ehX4ozE1oo3j1cNwbAjaxpVJcXvSX7liBVARqd+3KUXab1BbNmoxP61ML6G
         JkFo1DYw/kVAX2TdRgJMR10O3TGLaksoAy9aEZNsoiv1gvAay0xeOitCFLx6Tikz3ZFt
         4fmJcRr2mcCvbnB+fAtOaEDjWh/oSFwJYGHq5vBPU3CjEzoWHsutOX+fG/GsojpwhvfH
         8CbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739305250; x=1739910050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=csJ7f6rdwklnGRErPjOt9JKitwpK8CwkZyN2fZNR+N8=;
        b=SmEYn0H2X83drjUn7Et7DWRjCIeyjzN6z5/Ybvktp+7h6x1PGBJamT2SHU8C/iRewE
         V84fmZV672eYQW+3ALVEAuMsaFSCbX/xwUXs8mn+II0NXBksO4zYS4Qf3/oevgc4dYZ2
         SyzMTgOyGlwsQU2dtYI37hi9dztoGYhlTxQlsHFZn3BOaOmSkqLPINAMZPext37oebCe
         o6k+yVYuAhwg7yoVkDD1WBaRu0UZVxWMl5BnOiQeiatkLCeFCBT3jtbByezciGROjgHW
         nySzvJj0lUk7nFY/jHXQs8Au1fQ0sh1SOAMAQU4bH1tOnNjZ0SGR5PqbVlLElfRZOndD
         IeMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVLVlBm/iZF07OuVLg6ktXVmcCEiyaMcEoab8hkkDnhQLoYSIL1QASmK5LySnw0jFWsOa4jXQMmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfaJgj4PWUvQwGrrXsmGGuOjNICn+kgdo2g4wtQAwEWHSonciN
	PGhQc0zhHnjvMX+b3xIrdvqyHBx1c+pcKOP5UI45ZXvt27JmqtFDnig4rXjovpx8WN1aWLwU/iA
	Wd+Cf4WudoBRuKtk6dPc5aR59t8wxbofp
X-Gm-Gg: ASbGnctlHAdoCfHDuI98VIC+EKNyMf+JgQo60SU/++HS/Pzu03BMAwlpeXxvAj22cA5
	xBl3v8myoQcxSNb8J9l3x4pb1GSZo9iPASOUYsR1bjSV61ldV+BSkQUh4GDFj/AX8+5qWpsy26y
	Z1+bQ63/p2tmZwCjH/uigKao59yPI3fPQg9HiFPlVgQ21+iYBN21LKb0vsU4dSyIe03lROaZ68n
	VuIOYYQ6FUAYhi0uNf+7b8+ZgbxgQlHkLF9BG9CiU8rSOEWXPcVj4DdFqCzVN5nHykAEdDoMLU/
	eWvIswuc4cfbHJozwH1DGjE3CzyXGdIrJdSRpA==
X-Google-Smtp-Source: AGHT+IHsTrPbdU/3vEFLg/XqPk1UsqIU4VwKugBocGrCcrJHn8lsYoNhUdDT/80cjTS/VgudnAQcEG0cfPfN
X-Received: by 2002:a05:6602:13c2:b0:854:a5e8:3294 with SMTP id ca18e2360f4ac-85555dad5ebmr23112439f.3.1739305249960;
        Tue, 11 Feb 2025 12:20:49 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id ca18e2360f4ac-854f669af2asm61994339f.18.2025.02.11.12.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 12:20:49 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id E2C543404B6;
	Tue, 11 Feb 2025 13:20:48 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id D1687E40DF3; Tue, 11 Feb 2025 13:20:18 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: use IO_REQ_LINK_FLAGS more
Date: Tue, 11 Feb 2025 13:19:56 -0700
Message-ID: <20250211202002.3316324-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the 2 instances of REQ_F_LINK | REQ_F_HARDLINK with
the more commonly used IO_REQ_LINK_FLAGS.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ec98a0ec6f34..8bb8c099c3e1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -108,15 +108,17 @@
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
+#define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
+
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
 				REQ_F_ASYNC_DATA)
 
-#define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
+#define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | IO_REQ_LINK_FLAGS | \
 				 REQ_F_REISSUE | IO_REQ_CLEAN_FLAGS)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
 #define IO_COMPL_BATCH			32
@@ -129,11 +131,10 @@ struct io_defer_entry {
 	u32			seq;
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
 #define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
-#define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
 
 /*
  * No waiters. It's larger than any valid value of the tw counter
  * so that tests against ->cq_wait_nr would fail and skip wake_up().
  */
@@ -1155,11 +1156,11 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 
 	/*
 	 * We don't know how many reuqests is there in the link and whether
 	 * they can even be queued lazily, fall back to non-lazy.
 	 */
-	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
+	if (req->flags & IO_REQ_LINK_FLAGS)
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
 	guard(rcu)();
 
 	head = READ_ONCE(ctx->work_llist.first);
-- 
2.45.2


