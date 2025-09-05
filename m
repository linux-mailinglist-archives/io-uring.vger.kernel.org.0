Return-Path: <io-uring+bounces-9584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AAAAB45289
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 11:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46FCDB60240
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 09:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16D92853E7;
	Fri,  5 Sep 2025 09:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZytPNDN/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC21D284695
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 09:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062984; cv=none; b=ZHXNfY45ECwlF8K/GVXP/21UEofkkjrHS+5nAykyWMxalBJWPTRQL2aGOBjBMgdOI7s1XnTlB/lmQxaybZKCwZ5euTevmuTiXcgrfRWabX6R5vCVNLMEdB8Wazx9RmobwP0sZdmIT9rUWXTYJcQbnPm9ns4uog100dzouMh73RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062984; c=relaxed/simple;
	bh=jYtZGnUPk8TgIyW+b8csFVYVlJvMLTdatpkz7jEPuI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8s5LsMob3XMMtTThhgIT3TXKmDe8Vg5Lwid4vzNMMV+gZzv0jQhORqcgQrVm5KcntGcpUCnE/eiBhsKas1XlLsqFbTdMt44swguz9kZ3Zu9JhBscj3obDrv1egtPOjXZZ4vhkS0A9gliLIP7DiuuA5AOFd31QKtnHk5q0r/O2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZytPNDN/; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3d3ff4a4d6fso1443822f8f.0
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 02:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757062981; x=1757667781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ubNq+Qi0idaAj0yap4V8A/g4fdG3/e0+F+Gyy6T2N0=;
        b=ZytPNDN/bO1rJbp4sxIwfh7qTsjtSjIXDKu/yYuLQ7WAzWkDF7ldDYuC9aW4IbvS9O
         nHEetN7ZAmBIQSk6X5K5paJIL+MDpM4GFAjtaZk6LQzUEST8jbhIl2A5jvHlxiE9b7iD
         lW/oXGutBpeuwiFZfTlux5N1c5ZH/T6uAiI8ugHdFMI/6owhphB5LdDQIqeCXkUHytBz
         S7HNZVmL6RFunGIEQffx7ftAx/ZMHm3I/M2/QIxmfKA6+VyJIg0Ccm+iaTV9VlAnzOlw
         RoN44j1+0rpLtxkCcKXmFmSVTrwxnbxxV8NzOv8f/61oBOQAQnqEVdUw1OHVSYjEEZ9w
         hKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757062981; x=1757667781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ubNq+Qi0idaAj0yap4V8A/g4fdG3/e0+F+Gyy6T2N0=;
        b=lAaYTtG+wAS9gZ4DgV2WUWAKCBYk+uwVbEPPegqF8MvE8f32NeNcUvvlVWVtc8EA8r
         eDpT2rK+fV3QJ7nb08dgDGzHTKPtzYeNvtEFL4u+sqXbBCjSEmQv89sZHOedUY9pNaRK
         uzpmwj5kn+3eNBdQ+FjXlleB7iarhIHXJf1XrlfNA5uhHUNORqLQcyI/VY3yOGKNY55r
         VSPKw6IqwdfWAybeCYGBYCgwnNWBFHS+oDXty0ECQ8VWAVgkYXMt3UdGlfwJAL9mVSf8
         fNYhX4flk9ZFu+rOlb2O9eUaOWaesNLChF9wp0ayF/tVySI0fNdaZcLzwwPi/2LL8BU7
         ghiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaiKOBfX695PpRhjHH3nUtCjZ9hadAi9D2WOFBa9vmjqx1JvT8vjKl7gT9WlT7XHA71uGfgivQfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPCBNnmEkf1oFOKL3VJhrsv3xTeurLbLfC5FBtuqiwCHb/4k1y
	igrOChUktFPpitR99XphlaHoTuXXVS9Fo71yYOprydt0WOUHEw+eCD+ecWhQ2hoKJxU=
X-Gm-Gg: ASbGnctPoea5sMKtUsEK1MKVgxfc+6WUzSQ1o1XEiitnlOw8CjoaKlij2ilX9sJiJKm
	QvwdgcNalMp9f4i+C095ecAlyz7hWh2/emaal902zTBg93Emdiuid0MvFPKb5KaextyoPOTLmW3
	yi96Pq8rOZl59EtDgLF4G7mQrQV5OsS5cwupPJ/pSFamOHUkFcUt/LXqRnIjImAy0jv2z2r7koS
	obbd7WnJwNJV5B4+1Nm5mGCfySYHTJYxWsIf/TeOQ1MNZGGgGijSMMXK6GBEL49PDCV0qusbZzA
	dOVxqsra2Tq+Tb7LofCKbWii3eGq/r9ytLjJoI/uHdkx0IFXc2Vxqcdt+3sO3t97Xt1fHI5gq1T
	v0x25+asfc4m4zXfdv4nsD3TD4lUFrt6lnWOoIHQmYv32qWnx4Wx0TPBMfA==
X-Google-Smtp-Source: AGHT+IFcTOET/gdirbR7ulY8RekMt7OMSfV1l5dnHmKT/NuEkW0FIbB2FKJIsT6nvYtvE2OtXaSIvw==
X-Received: by 2002:a05:6000:3110:b0:3d0:b3cc:c1ff with SMTP id ffacd0b85a97d-3d1de4bc2e1mr17930105f8f.39.1757062980901;
        Fri, 05 Sep 2025 02:03:00 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d66b013b7dsm19653105f8f.28.2025.09.05.02.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:03:00 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/2] io_uring: replace use of system_wq with system_percpu_wq
Date: Fri,  5 Sep 2025 11:02:39 +0200
Message-ID: <20250905090240.102790-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905090240.102790-1-marco.crivellari@suse.com>
References: <20250905090240.102790-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

system_wq is a per-CPU worqueue, yet nothing in its name tells about that
CPU affinity constraint, which is very often not required by users. Make
it clear by adding a system_percpu_wq.

queue_work() / queue_delayed_work() mod_delayed_work() will now use the
new per-cpu wq: whether the user still stick on the old name a warn will
be printed along a wq redirect to the new one.

This patch add the new system_percpu_wq except for mm, fs and net
subsystem, whom are handled in separated patches.

The old wq will be kept for a few release cylces.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c6209fe44cb1..2a6ead3c7d36 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2986,7 +2986,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	 * Use system_unbound_wq to avoid spawning tons of event kworkers
 	 * if we're exiting a ton of rings at the same time. It just adds
 	 * noise and overhead, there's no discernable change in runtime
-	 * over using system_wq.
+	 * over using system_percpu_wq.
 	 */
 	queue_work(iou_wq, &ctx->exit_work);
 }
-- 
2.51.0


