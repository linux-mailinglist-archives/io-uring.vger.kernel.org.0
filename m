Return-Path: <io-uring+bounces-2118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4CE8FD0B6
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CA021C22E52
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58131D53F;
	Wed,  5 Jun 2024 14:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ju2enn2B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722591D524
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597194; cv=none; b=XDjVzetg6ksqNi0MGn/0sGDVFf1BOJ5pM4/Rj9J8n5UeNyGNXctheb8n0yH7qVZgrLumBITcSPOGtD0ULBCBDZnt7TgXr8RzqIoxIOpY2JM+FuQqJYQWXoiU68hyahifSuJOFF03GFGD/NcnDQ9pf31DjufLGKIQnPzf70W5u4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597194; c=relaxed/simple;
	bh=ZxUqacrgcB+gIX50cKma8/WkESJan7gE3fo++Ia6ESc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOR9QSiwHVeOrfLHU8GA51J6DcXJJKeNFdzmQvUN40FnSt91ZWCup5W4wNc4Dxz3M9M2pTPVXoQZQhUxkSZC977T/Ih7TzyDiuI7iJmDkqWFON4HW9e2eUEDcejugpYatfRtniD+uC0sKms9XsOMkNUhgrdfo793kh4G1QENojg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ju2enn2B; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6f93fe6d11aso74195a34.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597192; x=1718201992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vvVkg3/KW9P0mu9B789CugsGlim6x0bnl0gXJoooKGI=;
        b=ju2enn2BhhRMK3JcCTuMng1OJPelppH/gyd7bdjVuBehC2X44G9/2xpKB+rvTLACo2
         IweSZz0TwMrFChAVaWcvFF559iHaaSfosFQSsBkbJ7+KMZUe8KtxoFeBZHZYP9AkP4dA
         hWPwbIj8HpvVKa3lqT9GksoAvdp/WIZjuivdrHwor2ifX0RZTUQ3nCVO2NiqkaGF340w
         4kKmJd71AJL0HIGYSqDGJSVqIMhYInrBbGZ+jnJVbJfr4IoXyh/zzJuwgQjxho9G+RHq
         lJ4JQ5YAqdYE9CbFNhxZVK3B+Gk71Xo1JX4wy1vmwRUJ4hWkxfOrmDQJHZSgI76Anlyn
         b14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597192; x=1718201992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vvVkg3/KW9P0mu9B789CugsGlim6x0bnl0gXJoooKGI=;
        b=F5g7ydSqOUoImJxuRWr/cLUlvat+RzwEvPuY8BOKNnc9PFsruv7J6gClehXHRiHmsR
         OtU7MUkMFLVhi3FYEzMwksyddhQtMiONO8O9EsKP6fKUZ2pKKQFedrlMeAOp1mRpfDmb
         uSECc1y/rg6hgvnuOloJGkTnjzs8NJv7n2lF4auqKcsAUJfeVoXW65gVXLcAYLy4gp65
         /AqtHMdezXZA8A5PCDQUuSEzH5Q9AZ2SGSnbqcO+JjI5Vf/XrSqBdVVITzDX6jJ2vSl/
         Of4SDc9GtfTaT6N0LkIWHpBpJTqXXRWH3A6jaidYX0jiGvlgTM3rvuNFejT2jsyAACPL
         fMlA==
X-Gm-Message-State: AOJu0YzKg9CVJlBBgujI2Ydau4ij3IYUl1hc8DpC2ajdFHokP1Hzhnl1
	SwUkn7P4eYFjSOZyM/UXyU1nFNcdyOHuUfi4uIstH2305byAMSeiZ0IJR1dW9amQpp8sFmSRyqh
	W
X-Google-Smtp-Source: AGHT+IEp+Gn0OJtHxlgK0ZaEj0MFNY8oX6fLSDxjMLd2QQpjWB67yHb8a4gRdyLmic+2Kflmqi1QCg==
X-Received: by 2002:a05:6871:b06:b0:24f:e599:9168 with SMTP id 586e51a60fabf-25121cda5dcmr2663221fac.1.1717597191890;
        Wed, 05 Jun 2024 07:19:51 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] io_uring/msg_ring: add basic wakeup batch support
Date: Wed,  5 Jun 2024 07:51:16 -0600
Message-ID: <20240605141933.11975-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605141933.11975-1-axboe@kernel.dk>
References: <20240605141933.11975-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor in the number of overflow entries waiting, on both the msg ring
and local task_work add side.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 9a7c63f38c46..eeca1563ceed 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -109,6 +109,8 @@ static void io_msg_add_overflow(struct io_msg *msg,
 				u32 flags)
 	__releases(&target_ctx->completion_lock)
 {
+	unsigned nr_prev, nr_wait;
+
 	if (list_empty(&target_ctx->cq_overflow_list)) {
 		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &target_ctx->check_cq);
 		atomic_or(IORING_SQ_TASKRUN, &target_ctx->rings->sq_flags);
@@ -117,10 +119,14 @@ static void io_msg_add_overflow(struct io_msg *msg,
 	ocqe->cqe.user_data = msg->user_data;
 	ocqe->cqe.res = ret;
 	ocqe->cqe.flags = flags;
-	target_ctx->nr_overflow++;
+	nr_prev = target_ctx->nr_overflow++;
 	list_add_tail(&ocqe->list, &target_ctx->cq_overflow_list);
 	spin_unlock(&target_ctx->completion_lock);
-	wake_up_state(target_ctx->submitter_task, TASK_INTERRUPTIBLE);
+	rcu_read_lock();
+	io_defer_tw_count(target_ctx, &nr_wait);
+	nr_prev += nr_wait;
+	io_defer_wake(target_ctx, nr_prev + 1, nr_prev);
+	rcu_read_unlock();
 }
 
 static int io_msg_fill_remote(struct io_msg *msg, unsigned int issue_flags,
-- 
2.43.0


