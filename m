Return-Path: <io-uring+bounces-8235-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 280E7ACF846
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 21:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F2DA3AF9C5
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 19:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7266F27C16A;
	Thu,  5 Jun 2025 19:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PqzDpbSG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AF227F16B
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 19:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749152857; cv=none; b=pJK3sOa46mIFynL+8IPfBAONPSm8JFqVpAl/FKdvw59EJK0xvPCWPsz3QG0gshInTmoAReuil1vnh36BneZOzttAer+CuujW3xlwEQhdOjr/jQk1sAPpWjvk96GY/MTup37dM0kTkYZ4XCLkQ11x5Ra1FaobKSBBzkj+rC2NVy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749152857; c=relaxed/simple;
	bh=YnABps+bbs9751Jm1YZV26kZPIcGjyuCM8vcMPWwUoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aguEllje+o38al8tfCZOTDTRSY8iE7H38C18EogHqzhJzi6rsInvCvzLWrkvm2/n/jBsarzjWeL2jAO7GnS1DMaDTvPWrMMi6DP6Wc6kGVlaACmJhJtdwSK9LotegZCHglUx+N4Gb6uQyyfPovLqNTNcfkW1XK0qxp9wmKYK0k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PqzDpbSG; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-86d0c598433so42037139f.3
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 12:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749152853; x=1749757653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSUsG5inAqTmNNBiSgZniZY0DhKikjHXJm9k57XD/58=;
        b=PqzDpbSGtVKvkBtAWpAA6iA99r/56LfGXGMJH3uRWo7vhMXFbOZ37aZ/ym34OQf/2R
         BSx+KzozvzGqZHmknwV3DL44NU7t4RLSRKTvZkbpq2YjNqubhGPZ401fULYViwEHZ+Fy
         ar9iJZ0dc4wrXXdSGmRIQVmj2aqIylo4yDzkgebnxeElaXFVQbH+J/4TVBFYrymw5t4H
         w5szw5LwFEWYg9cc1EDkkxVNVKLVkBbmXGmNT10J8UlJANiJNf+L7kqmbVvfmepMo3nW
         /3h8IhjIiSLYhnUymUJpRvgLkqC4/82DjXAeivTFaWUeNpG0YLkbMc9fy++fsypDJ4nQ
         rIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749152853; x=1749757653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSUsG5inAqTmNNBiSgZniZY0DhKikjHXJm9k57XD/58=;
        b=KA63T5f6iI2Rbl+9/kodBcsckEXtB3wxPhVT3MIYQARHUCxAfRuDw8KLWm4qi/EFke
         C9ig7UBLLnT9AZ1Gija+NQrQ2PCZZvLGlfN0IKH/Tc0Z7AM3jKPkHy2oyNO3S9emYx87
         TVUIYGeNXOgb8aBYUWfXgIP6c1dO2/srK4Qzj/46ejEDb9ZzX5L7LcAkFIcXfOKpIXhC
         2a2HbQ9v+1CK+8cdIe7kY9jUUrpmQLDsnuFgef2BLJW0005oq/F4DRFeTmI/XYbjHhA0
         68byc4opz3LkWzCb3p3UNnn5iVf2rS/xbYkhFcq4Ybv1f1BcnCHLH0NKnQ+Tfa2SxU42
         woFw==
X-Gm-Message-State: AOJu0Yz1qJ4eTyggSmLSCDqnwNbFvd/T+Rh2Zwl5kX0eKtN+8TMuWpYD
	fxIisTrD2Pt1c/yaxyF0W5V/NzEHP4HLD16Pf3tauv5lFZ1ZDz8LxttI2zpahTY3kzOEzPX9eBU
	wxhTD
X-Gm-Gg: ASbGncvZ+76RmyVcz3HV09yjxhAzaKawVw9qhNY+Cg1ndY0kpfEgstFZsMtOm1awkp6
	5YWC7oAibZL8HlEUXu0koD3XrhLdKvhQ/5h4pZTMwjoVHe5xlMoG9pfUZlq/XTAZjoPXj7xEFKR
	n15NHmBnESdHz8WmVVIeMrTcdDFOM3+vZySIreT040fEmI07KX+1ZgvSzMI56loYDF6FenLDmGn
	iC32ZVRaHer6TmiKzirADfNKu1kLJTRLuL+17kl4Xh/JqYuiGqnYf6b+NQSvoOYIrcdltrT2jKj
	0vVGYIZEpVXsAbnIwX44ySPICfyRb33t6u6V/J++aZ41MnT3aabvIuI=
X-Google-Smtp-Source: AGHT+IEsFD7T4Tv49J5skwyMJIEvQaTfLnR9AEHbos8cGidVFyFHh7NB5odNAp5tshmjs5LI4FPjSw==
X-Received: by 2002:a05:6602:6a8a:b0:85b:538e:1faf with SMTP id ca18e2360f4ac-8733666758fmr110709339f.7.1749152853177;
        Thu, 05 Jun 2025 12:47:33 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e79acfsm317783639f.19.2025.06.05.12.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 12:47:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: add IO_URING_F_INLINE issue flag
Date: Thu,  5 Jun 2025 13:40:41 -0600
Message-ID: <20250605194728.145287-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605194728.145287-1-axboe@kernel.dk>
References: <20250605194728.145287-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set when the execution of the request is done inline from the system
call itself. Any deferred issue will never have this flag set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 2 ++
 io_uring/io_uring.c            | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 2922635986f5..054c43c02c96 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -26,6 +26,8 @@ enum io_uring_cmd_flags {
 	IO_URING_F_MULTISHOT		= 4,
 	/* executed by io-wq */
 	IO_URING_F_IOWQ			= 8,
+	/* executed inline from syscall */
+	IO_URING_F_INLINE		= 16,
 	/* int's last bit, sign checks are usually faster than a bit test */
 	IO_URING_F_NONBLOCK		= INT_MIN,
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf759c172083..079a95e1bd82 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1962,7 +1962,8 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 {
 	int ret;
 
-	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER|
+				IO_URING_F_INLINE);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.49.0


