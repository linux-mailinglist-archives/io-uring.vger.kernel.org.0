Return-Path: <io-uring+bounces-4163-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8CF9B566A
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:06:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17FDEB21744
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 23:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7246720C465;
	Tue, 29 Oct 2024 23:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Ull04dqe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706CA20C302
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 23:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730243171; cv=none; b=aU+6+AqPH3nvf0UMtXoQuGp5XhDmgXvNq//+KcGdDoWLbjRIMostPZo1AbGzsmIqkK9havBsDXZge/AlV29K9HFOfryEFW8wTlQDYHexSRTAGTqMj7rSHvcUJElY32DxMWpa1iWXG2sMnehDny8hywbBECM7XRsTA11SAgAECbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730243171; c=relaxed/simple;
	bh=40TRLrkxLiE/L93cu7fVtrl05gtC+YqtB6WtAY0jo/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnPZkKZiqNxTzZAi64N2lSn+TmzTsl156jf4VEHnrDbXBTOtFPXRUiGY0eBVMyon7sqZSzB5ogaYou9UK+57Q7PbEOsNBtVKLIayIrM6UTyr5capxaiL4ZOyOrQ0wdf7fd7KTOstMdH16LK+FVmH1yRHdjQKE8qzlkCLbuD8Nv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Ull04dqe; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20c7edf2872so2436115ad.1
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 16:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1730243169; x=1730847969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmyth23R42frMPjJlMy8hhDb4L00WvoqlDbMJmlZ6cY=;
        b=Ull04dqe+xTwg7DDlTqze5O9HbYy86RP70haCmnWOCwT+WHXFqQ3EAjuKUiXbCB6FX
         MjywAk8YlBt1sBlU9ywQWLIxpxZdqh3B+wvZ0eCTTgXxTN6EKM1IhlL+iyZdVUw6XlnA
         41yDxklyFkXmTE9RcUz8Xh1dW0QtJ/GQgPe2UDB8+rAopYzdqrd+6zQTKCTmWZlATDCg
         uyizd0RMqBskqCQkqRYdUc20lYMQQdhLW6G9i3Zi0R7wcHH06M98tS/1tpnSctwaNQ3a
         /sPmiGFJiFtIXz3oWZATwwHrs/hv+6nVHtY2kdT+ulKusjnI/4FLFDtTk+1AyYqd9Wqm
         FSQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730243169; x=1730847969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tmyth23R42frMPjJlMy8hhDb4L00WvoqlDbMJmlZ6cY=;
        b=aP/hAryvdwVA74Wmsg3upxHon5FNTJH16XOOiTPq0mglX3c4TyBVghs8gBqXMGZ5Bn
         18Rr/znRCrhbOAr8TTivop4kQE6lP2+3RJnBy99YbKMDE3oDhhPK9bl0y8l3VruCYdk+
         OE3CJzs1MCd3eDiao4p74ZlrScTJIlGDnSD9nptBBn4bNFOAM42kcW7gPwTagQwpQz5i
         lRRRk8wEoHEhAR7z63tMopHBb6L5ypnqtOR0KkQwMlnlwJlqFTtCbv0E7aPPOtuNNvFT
         q+ZhzJud2tAORLaOHD5p3G0Ekj/cuSeVRqqJuhXa75GY1CbacX7cAFIi2HInG3yn7cfY
         LthA==
X-Gm-Message-State: AOJu0Yx/5RLqtUfgxGc76x4jaLwnP/TpiBF3Hwe9k6knHyMNy5Gn6jqt
	Kr48fPWe3iMDGdeidtSkM4mt2+eBs0DNxiPioSo2F0BYpNPO7yMG1Dvn7peYQ4vv8/Y+w0YcIdU
	bphM=
X-Google-Smtp-Source: AGHT+IExC/U1U4b4/0PK/2AJaQ87tHNCdGw58CkvecpCo0J1vfWKEV+tydRUwVnhwunMpnh0LOh75g==
X-Received: by 2002:a17:90b:1e04:b0:2c9:90fa:b9f8 with SMTP id 98e67ed59e1d1-2e92238987amr5663596a91.10.1730243168719;
        Tue, 29 Oct 2024 16:06:08 -0700 (PDT)
Received: from localhost (fwdproxy-prn-000.fbsv.net. [2a03:2880:ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa638e7sm229352a91.31.2024.10.29.16.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 16:06:08 -0700 (PDT)
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
Subject: [PATCH v7 08/15] net: add helper executing custom callback from napi
Date: Tue, 29 Oct 2024 16:05:11 -0700
Message-ID: <20241029230521.2385749-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029230521.2385749-1-dw@davidwei.uk>
References: <20241029230521.2385749-1-dw@davidwei.uk>
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
index c682173a7642..5ea455e64363 100644
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
@@ -6503,6 +6511,45 @@ void napi_busy_loop(unsigned int napi_id,
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
 #endif /* CONFIG_NET_RX_BUSY_POLL */
 
 static void __napi_hash_add_with_id(struct napi_struct *napi,
-- 
2.43.5


