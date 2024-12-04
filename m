Return-Path: <io-uring+bounces-5221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7534B9E45D4
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 21:33:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40A58B87786
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D52214A8A;
	Wed,  4 Dec 2024 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Dm3D/f/s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3FE214A7C
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332974; cv=none; b=YYaZx7KQQEVmwjJPIV/8Ljaz7chwwk3VMEe9GAuoQbpvx78S5NChn96JxglRjf/AK+MVJyjnx7nWrYgH2jr+QdqJtOTOoMZJQ4rXic7780hYZ6pFXvr+MylTmOazbm5d9sPKvDqlrK9+HLr/9zwHjhpVwKPdWbj7WW3E4/TuCMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332974; c=relaxed/simple;
	bh=WHdljndrLX/WO0D/Hih/8dp2+dGDExOdcjt97asBdaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIGKLs1hKk+zSmHTkLt1tF2/pfw8cYpqiEoi97s73Mt+h7+g4yhKrAoMN7kFhsKxbRakI1L1ZkUAb8iAVzJf1gppZOVcZdEZlpqab8n3jCoiqTYvV5ko6c1uK+7k5zeKptNuyAACO6L2DDS46XQRAiKHudgYRYTj/7Hw07dXsAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Dm3D/f/s; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7ea9739647bso38816a12.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332972; x=1733937772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=clZWVy4EcXukFFQnbW8FtGJr5BpqkMoC1pIMi8Z2Vw8=;
        b=Dm3D/f/sFIFBJaWN+ZfBZuZYphWCX/5E7LBuZb0Uos9sVZ+VRYi+AuSdmzH96tCZl4
         fly1gEN3n5whXXi017SvVwfko7drpfGhZg5Vt7YrujWQLhWj4Ren/BRVSI5YOGqO1TxA
         mdEDLBRICHlRuuIQjKd1N+a/G880ycAv4ahR+H/LaCfhIC115m1x1Dxo/WEIPOUoPCBM
         mBETBYm4GD7bd9ci21JBEu8NRyTdFvOPW9i96mgsUHt417+wiD8kOpp+/xEzDANikoyK
         itboLWblqkxfAdAVIT2K88mNVTKtHdQct2fUAStjUJHSZCaU1jLEOQ3UKjTtUrksZjAn
         qJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332972; x=1733937772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=clZWVy4EcXukFFQnbW8FtGJr5BpqkMoC1pIMi8Z2Vw8=;
        b=NDqkTZDwH9dakpa1rxhmzHiQj38QWg+F85zVIC01zucVmZ1WcUM1uJdhzBuLVfoe56
         Of6++uIW4k5OS0wlBCpbLKE740im0CQedOd3zGKZr7R9HBnN8pUkZSw5ON8eJ+A9F+/u
         RMv/59e1sD+jw/FcOKxyIdVC+E8RPJLXnJtPYtLKpQg+b9Wl/Cdy8n90P8rVJCMExIWP
         7d1Ttk3lfKEJJG7VdA8jRNTqaYruJSMoHPz0rEi4cxxAuqP+OewMOJJd81aaFP9oxuXw
         wb2IX/xJvUHLDZ19azevYGWE94oCqyn9O7Dx/mUL+S+z3XD7Z5DCAE4j2u8AcS20w4V1
         WWWQ==
X-Gm-Message-State: AOJu0Yy1ewzzGJJq/LJXzkYtstY/M/oPOLB7dnUhYofD58on1YMLZ/dH
	eekuZd4BLbqwUpBr1aEMXQFa3cRMS+EA03sTswGazRqEkzhDaqhepv/NPQEFzh+O6xmyW6dEClN
	0
X-Gm-Gg: ASbGncu9l6vI7k7hHKpvHrS3Fi7uVqUzaAlb0sk/JXKslxfaa+YNrJayQhwHRiCvO2j
	AW1CPVV4wrat4d2qqOZCM8ziK+UbMhsKAdj/ns6C/c1uDkS6v/KGANGn8VF52RTrpRPQp1jrdvY
	p0LgzI6tC41IOHLKt0ARZHF+qWBl1mE8G42NXxjotRYJvRY1L4kMa5QbNWUMVg6C5uFL3DvTio9
	scSygZ9Ttp9iY5wUG8ypeIzmQvO1f6lHlg=
X-Google-Smtp-Source: AGHT+IHYNGJ20r1qF8Ua9ywD8LbGi631u93tMXMSNXdEzlI+eP3aqY2pccobSUDIDagwc7wnxdzzjw==
X-Received: by 2002:a05:6a20:3d85:b0:1e0:ca95:2de8 with SMTP id adf61e73a8af0-1e16542f2b2mr10586118637.46.1733332972203;
        Wed, 04 Dec 2024 09:22:52 -0800 (PST)
Received: from localhost ([2a03:2880:ff:11::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72565b4868dsm7674371b3a.105.2024.12.04.09.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:51 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v8 08/17] net: add helper executing custom callback from napi
Date: Wed,  4 Dec 2024 09:21:47 -0800
Message-ID: <20241204172204.4180482-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

It's useful to have napi private bits and pieces like page pool's fast
allocating cache, so that the hot allocation path doesn't have to do any
additional synchronisation. In case of io_uring memory provider
introduced in following patches, we keep the consumer end of the
io_uring's refill queue private to napi as it's a hot path.

However, from time to time we need to synchronise with the napi, for
example to add more user memory or allocate fallback buffers. Add a
helper function napi_execute that allows to run a custom callback from
under napi context so that it can access and modify napi protected
parts of io_uring. It works similar to busy polling and stops napi from
running in the meantime, so it's supposed to be a slow control path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/busy_poll.h |  6 +++
 net/core/dev.c          | 81 ++++++++++++++++++++++++++++++++---------
 2 files changed, 70 insertions(+), 17 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index c858270141bc..d2ae1b4bf20c 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -47,6 +47,7 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget);
+void napi_execute(unsigned napi_id, void (*cb)(void *), void *cb_arg);
 
 void napi_busy_loop_rcu(unsigned int napi_id,
 			bool (*loop_end)(void *, unsigned long),
@@ -66,6 +67,11 @@ static inline bool sk_can_busy_loop(struct sock *sk)
 	return false;
 }
 
+static inline void napi_execute(unsigned napi_id,
+				void (*cb)(void *), void *cb_arg)
+{
+}
+
 #endif /* CONFIG_NET_RX_BUSY_POLL */
 
 static inline unsigned long busy_loop_current_time(void)
diff --git a/net/core/dev.c b/net/core/dev.c
index 13d00fc10f55..590ded8cc544 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6351,6 +6351,30 @@ enum {
 	NAPI_F_END_ON_RESCHED	= 2,
 };
 
+static inline bool napi_state_start_busy_polling(struct napi_struct *napi,
+						 unsigned flags)
+{
+	unsigned long val = READ_ONCE(napi->state);
+
+	/* If multiple threads are competing for this napi,
+	 * we avoid dirtying napi->state as much as we can.
+	 */
+	if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
+		   NAPIF_STATE_IN_BUSY_POLL))
+		goto fail;
+
+	if (cmpxchg(&napi->state, val,
+		    val | NAPIF_STATE_IN_BUSY_POLL |
+			  NAPIF_STATE_SCHED) != val)
+		goto fail;
+
+	return true;
+fail:
+	if (flags & NAPI_F_PREFER_BUSY_POLL)
+		set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
+	return false;
+}
+
 static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
 			   unsigned flags, u16 budget)
 {
@@ -6426,24 +6450,8 @@ static void __napi_busy_loop(unsigned int napi_id,
 		local_bh_disable();
 		bpf_net_ctx = bpf_net_ctx_set(&__bpf_net_ctx);
 		if (!napi_poll) {
-			unsigned long val = READ_ONCE(napi->state);
-
-			/* If multiple threads are competing for this napi,
-			 * we avoid dirtying napi->state as much as we can.
-			 */
-			if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
-				   NAPIF_STATE_IN_BUSY_POLL)) {
-				if (flags & NAPI_F_PREFER_BUSY_POLL)
-					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
+			if (!napi_state_start_busy_polling(napi, flags))
 				goto count;
-			}
-			if (cmpxchg(&napi->state, val,
-				    val | NAPIF_STATE_IN_BUSY_POLL |
-					  NAPIF_STATE_SCHED) != val) {
-				if (flags & NAPI_F_PREFER_BUSY_POLL)
-					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
-				goto count;
-			}
 			have_poll_lock = netpoll_poll_lock(napi);
 			napi_poll = napi->poll;
 		}
@@ -6507,6 +6515,45 @@ void napi_busy_loop(unsigned int napi_id,
 }
 EXPORT_SYMBOL(napi_busy_loop);
 
+void napi_execute(unsigned napi_id,
+		  void (*cb)(void *), void *cb_arg)
+{
+	unsigned flags = NAPI_F_PREFER_BUSY_POLL;
+	void *have_poll_lock = NULL;
+	struct napi_struct *napi;
+
+	rcu_read_lock();
+	napi = napi_by_id(napi_id);
+	if (!napi) {
+		rcu_read_unlock();
+		return;
+	}
+
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+
+	for (;;) {
+		local_bh_disable();
+
+		if (napi_state_start_busy_polling(napi, flags)) {
+			have_poll_lock = netpoll_poll_lock(napi);
+			cb(cb_arg);
+			local_bh_enable();
+			busy_poll_stop(napi, have_poll_lock, flags, 1);
+			break;
+		}
+
+		local_bh_enable();
+		if (unlikely(need_resched()))
+			break;
+		cpu_relax();
+	}
+
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
+	rcu_read_unlock();
+}
+
 void napi_suspend_irqs(unsigned int napi_id)
 {
 	struct napi_struct *napi;
-- 
2.43.5


