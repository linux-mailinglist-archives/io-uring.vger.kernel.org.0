Return-Path: <io-uring+bounces-3747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A029A11F5
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9F902834BD
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A788A216420;
	Wed, 16 Oct 2024 18:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="h7RLT7OZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F317215F6E
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104793; cv=none; b=ngkAN/ucXjUwpUVJPCdsKOcUN7gDQ4Lw+9aqhocrGY+VrByqsZxanyC2COJvPFqzDngN7oCZX2rzDg5sURG4OQ3dZkfajEKMeztJw2xtTJEcuvHW5cQffNrsm0RW/36EsVpwWrA6apHdvd1zY6h9U9lc+OLcf26dUSylTTFYE9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104793; c=relaxed/simple;
	bh=A45LcKejhku6kiwYYxqy5WdOuv5BPW+KlIxNe+zpclg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+zrn6/IQbjTUKVQwCIfvWq5noAS+IiPcd4eDkw7qGf8seJ+kBCSuxy9KU7Bb3JArzvTaITpi/xoAbtFxjrs6GUcOk76wPz32HsntDyQkDDMZq9t2ptsfN99e6FmzPwztmeGTXREhbyvqp6tAF5GvI4d8l+PyI6DItMvyj6DLVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=h7RLT7OZ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71e4e481692so97185b3a.1
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729104791; x=1729709591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=apJGwAUYt00y9e1Uwo5xTUJdF3GLIZYTh851xLLFxXk=;
        b=h7RLT7OZq0R8zVVyu6sF3mOxoauPKLPfPuehhCItE1m0Q2BifURS4deHFimc9hjIn0
         EJmi87woNEBKUQql8m8bVEYO9OUf+NHYXW2vDdqFcjVQhTWqPtUwZY73N8YnkXyKF69I
         hax44UkN/6JqdnSvd0LrlzmuqpYjj7v9TLabMyI8YOgFUPRPzS6l5Ykm4/BCpZ+7zNqg
         qsSZNTGwO8KfQkVf+jutaZlRr8VsO+39qiNKMBOulK/Ifa+gQ7Eh15U/pDxXB/DSwZ39
         WJF04O1hjXT9wGCCqbpLGvHG38NakOapJ0E4RjdYItPhKTjBI9lTmumH/l0eUEd0199V
         rmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104791; x=1729709591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=apJGwAUYt00y9e1Uwo5xTUJdF3GLIZYTh851xLLFxXk=;
        b=btUuJWSBATt575C+Q9Fx9u4DswweIAIJwBs+FW6FtjitfCS8huXtAMvV7JkzMTjYke
         oeWDtSx8OMOtMgAcwH1zBrZZoegainEPX08S+nW1xEZ761bDPM2WaMMNe4AiTQKSn3zO
         ZOzIFrzqUN9ADEddG5YL+IEDWdhkNdWcZr6vDkOdjCHpkilMBE/1Ch8ObPhD/ij0gR7+
         DUNMl3U05+9TJALVmnl0laowkhasQ1Gwf0aS91a6SMa0gZ5eprCGOF8Yev2lINKx7fr3
         VNLEOJPHkUrRNIvjRKZ1o3hTHLY53WlGord1cqL0B65TNYtt4XW/vHctwSFmuoqDXrn3
         oYiw==
X-Gm-Message-State: AOJu0Yys609Z7AIiUVVtweC6kBGXTd4yZlRgJ3WMUS0iLlKn3TnNwwIG
	FkLXms/wygwayGBZ2ywg/IAPSChxPUAZAQqrsl+rnCIjibgkJk7T89TJlX/LUemR77FrKVIfpJl
	e
X-Google-Smtp-Source: AGHT+IGTZ20yd5Juz+WkfKgvQG56lqh6jBNe39ZC5JtKYUomLGJOK0M8dRPpLQStZ31INSvELCg7ZQ==
X-Received: by 2002:a05:6a00:13a3:b0:71d:f7ea:89f6 with SMTP id d2e1a72fcca58-71e4c1c00f4mr25661805b3a.18.1729104791470;
        Wed, 16 Oct 2024 11:53:11 -0700 (PDT)
Received: from localhost (fwdproxy-prn-032.fbsv.net. [2a03:2880:ff:20::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e77371796sm3409607b3a.31.2024.10.16.11.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 11:53:11 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH v6 08/15] net: add helper executing custom callback from napi
Date: Wed, 16 Oct 2024 11:52:45 -0700
Message-ID: <20241016185252.3746190-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241016185252.3746190-1-dw@davidwei.uk>
References: <20241016185252.3746190-1-dw@davidwei.uk>
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
 include/net/busy_poll.h |  6 ++++
 net/core/dev.c          | 77 ++++++++++++++++++++++++++++++++---------
 2 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index f03040baaefd..3fd9e65731e9 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -47,6 +47,7 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget);
+void napi_execute(unsigned napi_id, void (*cb)(void *), void *cb_arg);
 
 void napi_busy_loop_rcu(unsigned int napi_id,
 			bool (*loop_end)(void *, unsigned long),
@@ -63,6 +64,11 @@ static inline bool sk_can_busy_loop(struct sock *sk)
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
index c682173a7642..f3bd5fd56286 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6347,6 +6347,30 @@ enum {
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
@@ -6422,24 +6446,8 @@ static void __napi_busy_loop(unsigned int napi_id,
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
@@ -6503,6 +6511,41 @@ void napi_busy_loop(unsigned int napi_id,
 }
 EXPORT_SYMBOL(napi_busy_loop);
 
+void napi_execute(unsigned napi_id,
+		  void (*cb)(void *), void *cb_arg)
+{
+	struct napi_struct *napi;
+	void *have_poll_lock = NULL;
+
+	guard(rcu)();
+	napi = napi_by_id(napi_id);
+	if (!napi)
+		return;
+
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+
+	for (;;) {
+		local_bh_disable();
+
+		if (napi_state_start_busy_polling(napi, 0)) {
+			have_poll_lock = netpoll_poll_lock(napi);
+			cb(cb_arg);
+			local_bh_enable();
+			busy_poll_stop(napi, have_poll_lock, 0, 1);
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
+}
+
 #endif /* CONFIG_NET_RX_BUSY_POLL */
 
 static void __napi_hash_add_with_id(struct napi_struct *napi,
-- 
2.43.5


