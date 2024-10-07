Return-Path: <io-uring+bounces-3450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F5E9939FF
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D34EB226D0
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403F8192B8D;
	Mon,  7 Oct 2024 22:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="jHgI35/Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9B818C92F
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339399; cv=none; b=gnqn+dc6VfpIN4SElaW4/g3TF6ab7RwxtDv0MPQXxFxdwSvYrQnowMcz+hS68Q0BLKC/gs99a4oh6rnkYTrmZIjZ3eag4z9cTy23HfYQGfNIYYJUrA7r4J3dCei6GfH5jY7+CFjvKBZW88uYEExiMTwYpE3+5oGCPT8LavzTS60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339399; c=relaxed/simple;
	bh=zIru/BLVEHCMXIaDhxnz8dkzIlpsBj3/Ne9ovJPqNQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJ2fVOlyXhArbhHgcKcVUPVxrpyW4/SuRncYU1DUwRwfNCq9sCtNDTb4sTYuSOONuR9/B6lWTXkGG5XAzI7V19eaBVXNke+AEvS4gFUiDwL04j/13AIWywzILnIjZYJAoU3PQpM2FpOmgTxnMswuB3viQ/c2cRuHDlgss0IkD4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=jHgI35/Y; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-71df468496fso2394187b3a.1
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339397; x=1728944197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JgRkWbTo4LNXX7PdXh2qka6BqUOW0eDFLQUXUzzANfY=;
        b=jHgI35/Ya45E+PZgZMDNdOqsTD4iYKjSuBrU3TBlK560JIg9GBDGyR34aWe+ZGqTY6
         lnSN5mcseEtbDFWmfAyJY0tFGpGh22ooxLkejeimRCR+ahMjNikXwwZwR7DVYGXyXYYK
         jkMq3p9xoTeOBYbHzwEYTdB6BSrBlpAujksYYPNl8uZZDM+B212Yoay+yl2qo9ItEWHH
         pJz1zAjo4bdfmMQlGYZ85HPYN9BqknNrudMfX40eMhp4engvi5vETeimQgeL2Xwl79OE
         kgBbo6HHPyKf5DW10uJWnGa+ZXZup1+Uy+BGWhGK5dgSZpjEoY8vr8AoGxG5KVCkA3FR
         c4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339397; x=1728944197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JgRkWbTo4LNXX7PdXh2qka6BqUOW0eDFLQUXUzzANfY=;
        b=BwCt6LY4ALn5LZVxM79FqawgeoEPw3XFGTs8Zgr8lfcw+o7glLwDMDeHSCiPuf+4pk
         vLyylq1naklkt/FQMUhxGTuHUiJCpvRKglYMHuZtxTa+PzNb7pMi+4LjC7VqHILrH5jw
         htQTiwgCS5RACiyPFldhqtDQ22YDGAv1w6SVFLRyUPzEJddUgpaF64SktJh8fbyqXota
         xpgGw+678lnu4vE1+qQ9D/sM575G+FIeDy7mCKtKTFEXok9O8HvdZHhkqxXxV4wza/Ul
         4wbf1Y96CoIEcSaY26n0u4U+voL/ePHPYiKN/pAl+nr42a005h/SnSLb42FtLMBe8vIl
         GCbw==
X-Gm-Message-State: AOJu0YyC41Yh2xLkG0TivXrgxB5yOEx0Ow65ywxgIETMEcr0qSYLYYg9
	8mjm8pHURxAu3tgeRJDAeOAsAfCHsqdTDotFKo+hTGAiq6GSiHiJwM06AvtfpFJp6Qt1FKmF7H7
	i
X-Google-Smtp-Source: AGHT+IG0MogFJnFezjnGnU9rzQH0+lSqNIR7z+19K7U333m4qAPP5cH5BZLzZI0dCicMLH9pGlRSSQ==
X-Received: by 2002:a05:6a00:170d:b0:71d:fea7:60c5 with SMTP id d2e1a72fcca58-71dfea7614dmr10901490b3a.19.1728339397202;
        Mon, 07 Oct 2024 15:16:37 -0700 (PDT)
Received: from localhost (fwdproxy-prn-060.fbsv.net. [2a03:2880:ff:3c::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0cccba9sm4914089b3a.60.2024.10.07.15.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:36 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 08/15] net: add helper executing custom callback from napi
Date: Mon,  7 Oct 2024 15:15:56 -0700
Message-ID: <20241007221603.1703699-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
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
 include/net/busy_poll.h |  6 +++++
 net/core/dev.c          | 53 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

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
index 1e740faf9e78..ba2f43cf5517 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6497,6 +6497,59 @@ void napi_busy_loop(unsigned int napi_id,
 }
 EXPORT_SYMBOL(napi_busy_loop);
 
+void napi_execute(unsigned napi_id,
+		  void (*cb)(void *), void *cb_arg)
+{
+	struct napi_struct *napi;
+	bool done = false;
+	unsigned long val;
+	void *have_poll_lock = NULL;
+
+	rcu_read_lock();
+
+	napi = napi_by_id(napi_id);
+	if (!napi) {
+		rcu_read_unlock();
+		return;
+	}
+
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+	for (;;) {
+		local_bh_disable();
+		val = READ_ONCE(napi->state);
+
+		/* If multiple threads are competing for this napi,
+		* we avoid dirtying napi->state as much as we can.
+		*/
+		if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
+			  NAPIF_STATE_IN_BUSY_POLL))
+			goto restart;
+
+		if (cmpxchg(&napi->state, val,
+			   val | NAPIF_STATE_IN_BUSY_POLL |
+				 NAPIF_STATE_SCHED) != val)
+			goto restart;
+
+		have_poll_lock = netpoll_poll_lock(napi);
+		cb(cb_arg);
+		done = true;
+		gro_normal_list(napi);
+		local_bh_enable();
+		break;
+restart:
+		local_bh_enable();
+		if (unlikely(need_resched()))
+			break;
+		cpu_relax();
+	}
+	if (done)
+		busy_poll_stop(napi, have_poll_lock, false, 1);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
+	rcu_read_unlock();
+}
+
 #endif /* CONFIG_NET_RX_BUSY_POLL */
 
 static void napi_hash_add(struct napi_struct *napi)
-- 
2.43.5


