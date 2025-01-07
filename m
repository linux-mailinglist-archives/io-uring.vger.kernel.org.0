Return-Path: <io-uring+bounces-5725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB0E1A041E9
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 15:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 348DC1887BC6
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 14:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C831F4261;
	Tue,  7 Jan 2025 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L88F8N7b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB151F2C3D
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 14:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736259046; cv=none; b=lw7LWbkwdSq0yBzdIOiot50XSUGySj+8KhMA6H1/KJOzLLujTv0+TiQq72bqz68C7cUT2Q9iq8Ez2DMJWazl2A/xZIblI8sQxwdOQiNtIP2MmhMu5L4u3JME4EtIGpi2+Gl43e23LSBvrKQ1DE70tykjIoc8U8oAVQ1L3wGsQz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736259046; c=relaxed/simple;
	bh=MEEnoD736nXMRaRroyFZYN838NcR9tKuIPT5or2uKWE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U8Uljbj1GYjEGFx3joBrmevj3AqcyfSqEI1rcr+tk9aCiduCGkQCYH7v30cHqm/ZJ6mewEL2K1KA93vqTHXvR7GrXm/tasg0RRPTRhv9VvYfRVuzkQKtOqxJOh6UV0uXsl955lIseeHBpmSdMtjvU8Wpl6nBE0vsNASvHw5ADTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L88F8N7b; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-385d7b4da2bso13248014f8f.1
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 06:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736259041; x=1736863841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qnwXJEBJox0MWBDFWur/ugZo03oZa1ceuyqdoA0x+vs=;
        b=L88F8N7bx26j3rMR1s9Y4tRsKRPrabi6N++m7VirDqo4rJeNzZPMfM4xJE2RS1jhSr
         8NAEk6rORVIPqpe6MVCyB/WDLIgcZNys9C0RTF6KROyxbNh/Fl8rEfMkdM+mrbYeRwkn
         aEeAK4c2/p5qOsBOR4ucyGze6MEjmITPPndzEW54RDwS+6M4CMJu/DeUtWC3dANqvStm
         gemUwozpkx8hco4gZBMUIaytFcy4WqFYA/pQivMMsh8HfpSCMDh420AmErVoQfkwcDeH
         hJAwAmntexQSG+xDqCRwJOSTNKd/Mgt/3OyYYrAkW+uKrni6ppmjMWbN3hLpLoQu201C
         69AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736259041; x=1736863841;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qnwXJEBJox0MWBDFWur/ugZo03oZa1ceuyqdoA0x+vs=;
        b=o1tsmnrVCOw+DW3CvubMlfUm8eJQr49ZxJR/XkhaB++i9GbGplux0cI4FnpDb8Dd2p
         /+M7xlVCUcIAm8UvKXIFeL2xc2gPGaAC24IB3i8KcIdfW8lZ/cPijx6iSDX8paMnjKOr
         TezDKJug1nggMz73+Ji47oNfO6AN5JlJTkBuVYl3/RXCvnbDT6Lplgo+SiP7bUdoxF88
         ZktNapP1dpKnsYXQH4TpH06MsHcLIzdaR5fDZn4YLnfO3SAf/hfGtxZzer7eylBS/J6Y
         PXU8EdGzM+BpN29geTU3JwjI2QKAp5wo8N0FenmB+P/zc2jda7tR0ezKrM43wzJg2X8u
         kijQ==
X-Gm-Message-State: AOJu0YyA74vCUhpTJMBnqenNE28XtR0XQQnoztHYYxXOPSmGHra58aND
	EUhPJ6kHwNcA4lq2oqFlcKNpCPplfa5UtYPm+A0bQNJ4SRCSkz0g6HJPHw==
X-Gm-Gg: ASbGncsVettsu7ZHKWytKnDnbLxq2n8+JAEi4ELq4E/S5iXqK27a/2eITJTMxzPMNwo
	ODfhZdnzwcWBiIczRiJU8ZU+9yqI3GepYEnJH1WsbfBIiH9dZFu2I9MbFYs9C3/Gg0KItXmYl62
	TEMBmH72RbZDCvjn7VZhY4xNxRk3wf+grKnG1lumDkpO+CePngQ540IT8Sub7117ZMcNAH5JjmN
	AXJwWcAwF4Fq6ZZISf5L9x/e857zKR+tylyS0o0
X-Google-Smtp-Source: AGHT+IE5nagIWO9GDJ6LyWL/vWI1Iio+OEKPEjvb40GecFxQIb/3R9CkudCe1p3qLQ3sWMkr9XChzg==
X-Received: by 2002:a05:6000:1acb:b0:386:3213:5ba1 with SMTP id ffacd0b85a97d-38a221f2fbdmr51597278f8f.24.1736259040354;
        Tue, 07 Jan 2025 06:10:40 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:944d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aaf6a8aa27asm973373766b.18.2025.01.07.06.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 06:10:39 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring: silence false positive warnings
Date: Tue,  7 Jan 2025 14:11:32 +0000
Message-ID: <7e5f68281acb0f081f65fde435833c68a3b7e02f.1736257837.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we kill a ring and then immediately exit the task, we'll get
cancellattion running by the task and a kthread in io_ring_exit_work.
For DEFER_TASKRUN, we do want to limit it to only one entity executing
it, however it's currently not an issue as it's protected by uring_lock.

Silence lockdep assertions for now, we'll return to it later.

Reported-by: syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 032758b28d78..f65e3f3ede51 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -127,6 +127,9 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 #if defined(CONFIG_PROVE_LOCKING)
 	lockdep_assert(in_task());
 
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		lockdep_assert_held(&ctx->uring_lock);
+
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		lockdep_assert_held(&ctx->uring_lock);
 	} else if (!ctx->task_complete) {
@@ -138,9 +141,7 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 		 * Not from an SQE, as those cannot be submitted, but via
 		 * updating tagged resources.
 		 */
-		if (percpu_ref_is_dying(&ctx->refs))
-			lockdep_assert(current_work());
-		else
+		if (!percpu_ref_is_dying(&ctx->refs))
 			lockdep_assert(current == ctx->submitter_task);
 	}
 #endif
-- 
2.47.1


