Return-Path: <io-uring+bounces-553-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 899EC84BB06
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:34:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39D0328944A
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9199046AD;
	Tue,  6 Feb 2024 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fSagLxsh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70D6139D
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707237270; cv=none; b=X8MLtuxVXfH4xv7fxmOhD55/8rpXqPbHqClH69eNngv6FeGigFoud8GJazd+clRF3Jf8Wn/egP0zq2owL7X2AMz0W560e/0PSTQ/B35T6q0SwgTI2uDjov4AUK+x/NujOr4Jst1yBPH3NJyBZXlt1bqWlHbFr73dfpmh7QCPZQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707237270; c=relaxed/simple;
	bh=5KFgeQ6e+GH7Q24OQeSwNCVYVJdZ6g3TXCXyGyBVLYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMGYt8IsYUKrEyc7cfaNxPv91g5xK6WBF0//xsIuXAQjbJG5HzOiQuzqw9jiVC3xQMh9BD5reNhH7ZBbF/B8YvZALxVnC6dpnl/7byzAopBk9D6ei7rM/qAEd7jTO0Co0hUaqMqj4uzNEby4MbKAau9N6eenw+B4czdWZaOpVdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fSagLxsh; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7c3e06c8608so30351939f.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707237267; x=1707842067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0353+KBVocmpwKcAzO+oB9LTsTL8XRLqxQjtjBy7bs=;
        b=fSagLxshIyGqzyDUgX9AxyqedKyuzAPmCBcGHpQbuV39OiQkUo6yDFLAXItWtPdRy0
         SJDyJvQi95y5jtjXP5JMPFx5lkKZeYROV+fEIznyQrMw1PDQrFjtuKYchIXkzvfvPuyF
         O2gNk6WQm8oV9M1VhjcTPg4gH099BCEffI3lVnpW6nQWhw5jDReIulx5O/vDrrdx87P+
         sktvFSDY0rqB+YTwyrgeTrL0SOCGlYMQSV5CeTbTLEoMlX66I0TU/OYsYDJJF5PoRklc
         vdJaHjtq2D+L7x3tFR+WsX0IHC0g808gWyZjnOR9T1DkpqTWmrZC11h3AeNR8afX07eK
         p76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707237267; x=1707842067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0353+KBVocmpwKcAzO+oB9LTsTL8XRLqxQjtjBy7bs=;
        b=gSgvQ1WZOLzuUd16a08KJ9qoCOyOjhe7U+jYcAMdeQvekDGcugB7baYx56tZd9loMJ
         pl5voxkPya7JizzHyGERbw8niwK5ldkS43GGzN44J3a1EEGiSsQbulBZrYXH+UpAfDz8
         HrGXvRalvzBcjv76ScX6MhS4eIdvMcRa7fwqeaacZnvJdHdsmzDSY+//pSZoqeReupEM
         9ON6y8Dp9oSyv/tv84ndmLOrby69m5o/MTcpyhEs9RtQpA3aRUGq67bFdN0XkP84sLCS
         lUDZDzf/X0qqZLA2HTk1qi6uKk8Qqx5b26oRwN5BnZ5kP/iSkskELWK63/JF4YC2cHTU
         ITRA==
X-Gm-Message-State: AOJu0YxAKymemJ9QeVS+uHUcOwZUAjO/egoVnkCkafRz9pxUt1V/XrYp
	ukgjcCtNhiGWPV8Y53hELCnKNNKRMHP7sCIWIyvH0Kg8IrjmwADBzz8MbXzyDrOcEJVzQqX0OyW
	hj+E=
X-Google-Smtp-Source: AGHT+IF/n2KlENyGG3ALXOXFV+e79eF9Gqsg0GmWLEX7EhXQSiDddLnvyXLjHknyagAhuVi06/MP9w==
X-Received: by 2002:a6b:db13:0:b0:7c3:edbb:1816 with SMTP id t19-20020a6bdb13000000b007c3edbb1816mr2814224ioc.2.1707237267608;
        Tue, 06 Feb 2024 08:34:27 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUyZK1/82Kc/YPV5epMBRym5L6ZevyHgFMilH16dIqUcUTIYFlDhIc41WQ9jYWqKcDmW3GWFpFVyKHlzCLk/MGchldJIJA40J0thaG50aWEGpYRg6IRumt2U6w7u/MptjuxjFkk9TwyOxdyn+Wdh5N40iKEgjRMrmVaQ/D5pn05nsI=
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u8-20020a02aa88000000b00471337ff774sm573316jai.113.2024.02.06.08.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:34:26 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: kuba@kernel.org,
	olivier@trillion01.com,
	Stefan Roesch <shr@devkernel.io>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] net: split off __napi_busy_poll from napi_busy_poll
Date: Tue,  6 Feb 2024 09:30:03 -0700
Message-ID: <20240206163422.646218-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206163422.646218-1-axboe@kernel.dk>
References: <20240206163422.646218-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefan Roesch <shr@devkernel.io>

This splits off the key part of the napi_busy_poll function into its own
function, __napi_busy_poll, and changes the prefer_busy_poll bool to be
flag based to allow passing in more flags in the future.

This is done in preparation for an additional napi_busy_poll() function,
that doesn't take the rcu_read_lock(). The new function is introduced
in the next patch.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Link: https://lore.kernel.org/r/20230608163839.2891748-2-shr@devkernel.io
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 net/core/dev.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index cb2dab0feee0..1eaed657f2c2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6177,8 +6177,12 @@ static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 	clear_bit(NAPI_STATE_SCHED, &napi->state);
 }
 
-static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool prefer_busy_poll,
-			   u16 budget)
+enum {
+	NAPI_F_PREFER_BUSY_POLL	= 1,
+};
+
+static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
+			   unsigned flags, u16 budget)
 {
 	bool skip_schedule = false;
 	unsigned long timeout;
@@ -6198,7 +6202,7 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool
 
 	local_bh_disable();
 
-	if (prefer_busy_poll) {
+	if (flags & NAPI_F_PREFER_BUSY_POLL) {
 		napi->defer_hard_irqs_count = READ_ONCE(napi->dev->napi_defer_hard_irqs);
 		timeout = READ_ONCE(napi->dev->gro_flush_timeout);
 		if (napi->defer_hard_irqs_count && timeout) {
@@ -6222,23 +6226,23 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool
 	local_bh_enable();
 }
 
-void napi_busy_loop(unsigned int napi_id,
-		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+static void __napi_busy_loop(unsigned int napi_id,
+		      bool (*loop_end)(void *, unsigned long),
+		      void *loop_end_arg, unsigned flags, u16 budget)
 {
 	unsigned long start_time = loop_end ? busy_loop_current_time() : 0;
 	int (*napi_poll)(struct napi_struct *napi, int budget);
 	void *have_poll_lock = NULL;
 	struct napi_struct *napi;
 
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
 restart:
 	napi_poll = NULL;
 
-	rcu_read_lock();
-
 	napi = napi_by_id(napi_id);
 	if (!napi)
-		goto out;
+		return;
 
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		preempt_disable();
@@ -6254,14 +6258,14 @@ void napi_busy_loop(unsigned int napi_id,
 			 */
 			if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
 				   NAPIF_STATE_IN_BUSY_POLL)) {
-				if (prefer_busy_poll)
+				if (flags & NAPI_F_PREFER_BUSY_POLL)
 					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
 				goto count;
 			}
 			if (cmpxchg(&napi->state, val,
 				    val | NAPIF_STATE_IN_BUSY_POLL |
 					  NAPIF_STATE_SCHED) != val) {
-				if (prefer_busy_poll)
+				if (flags & NAPI_F_PREFER_BUSY_POLL)
 					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
 				goto count;
 			}
@@ -6282,11 +6286,12 @@ void napi_busy_loop(unsigned int napi_id,
 
 		if (unlikely(need_resched())) {
 			if (napi_poll)
-				busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
+				busy_poll_stop(napi, have_poll_lock, flags, budget);
 			if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 				preempt_enable();
 			rcu_read_unlock();
 			cond_resched();
+			rcu_read_lock();
 			if (loop_end(loop_end_arg, start_time))
 				return;
 			goto restart;
@@ -6294,10 +6299,19 @@ void napi_busy_loop(unsigned int napi_id,
 		cpu_relax();
 	}
 	if (napi_poll)
-		busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
+		busy_poll_stop(napi, have_poll_lock, flags, budget);
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		preempt_enable();
-out:
+}
+
+void napi_busy_loop(unsigned int napi_id,
+		    bool (*loop_end)(void *, unsigned long),
+		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+{
+	unsigned flags = prefer_busy_poll ? NAPI_F_PREFER_BUSY_POLL : 0;
+
+	rcu_read_lock();
+	__napi_busy_loop(napi_id, loop_end, loop_end_arg, flags, budget);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(napi_busy_loop);
-- 
2.43.0


