Return-Path: <io-uring+bounces-315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A2F819203
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 025EC1F2188C
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3874B40BE0;
	Tue, 19 Dec 2023 21:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="dCsXqDtQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33A3405C6
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d3ce28ac3cso16788065ad.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019860; x=1703624660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxpOp5keoBQGOz00dSxKjcoORly3Uq6QcOZ8S/MSAKQ=;
        b=dCsXqDtQQRdS3qE2x27ZjDcAt67Sxxj3q5igk7TxkZ7nIOZpby+uKKUQVB4gyTNR2B
         d/L3Wpryht4RLo4k/VLZvzmRNzmt5fUat5grHDhOtZgChXjsR5otxIYKad4XuUJyY0Fk
         zx0b8m/zhlm9lzDjzaosaAtMzmQ4BWFP7oaZccY2Z4/vpXsfE8yEcycYeI6k8YK25iHd
         GWbnI3Wx4fwBP/OAD9HUMlgpNmm0kna8DXXEVjtzE67UZtOZxo10aXK3Dj2XqMzJDHSd
         xxlnPBXLh7ACFeLSdSXiB+sbaDE6l13TnIDlTzitzRhwD17Sy6gYrLqhODabsWHvzvp9
         kq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019860; x=1703624660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GxpOp5keoBQGOz00dSxKjcoORly3Uq6QcOZ8S/MSAKQ=;
        b=jm3jfXT/8bICV2L3UQBEtH/F1ah3X1Cn4IJwAQ4eiBHH4y+S0K3PXz9tlBtsK77oLk
         B5OzDpEoMqP9RvkkPbXd8xbOKwkwuri8TUBlAsB4WmPItDdwruYUpBSvUTLxPsstmCaB
         GjMKGzrfo9/A41NdgG965aDVuspmH1BHcm7DcxOLYhfMZ61lp+lxDirYIInBlM6MQoaW
         QY4VvjvrdEcWN0INBh0/yeZRURigFHgeBZcLdW6VkkYr0SDd5UyTGfPgBRj1N9QklZc+
         auD4Hi2JnyadCWKsDE7Fb6BCo5w8ZtDl1Nzbdb3DPaQBJEh1YWWsUstmRn/nM9aWwrG7
         21RA==
X-Gm-Message-State: AOJu0YyBZw170CMORZ+vXCw1HPrxMGFD+mNnoruel2nZFmVkZbvj3F68
	iYDwgv1dsQJyYjEJ6SunkHNWrBnkhvuZkEpgRn+BnQ==
X-Google-Smtp-Source: AGHT+IGggFl0JrUM4oTE/WqbU6Jj7xNuoLiaUQdJMih11dS+6jNAD97QTKlC1myhDJGi0F2OblMPZQ==
X-Received: by 2002:a17:903:11c5:b0:1d0:6ffd:8367 with SMTP id q5-20020a17090311c500b001d06ffd8367mr9469743plh.114.1703019860208;
        Tue, 19 Dec 2023 13:04:20 -0800 (PST)
Received: from localhost (fwdproxy-prn-013.fbsv.net. [2a03:2880:ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id l5-20020a170903120500b001d349fcb70dsm12563264plh.202.2023.12.19.13.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:19 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v3 16/20] net: execute custom callback from napi
Date: Tue, 19 Dec 2023 13:03:53 -0800
Message-Id: <20231219210357.4029713-17-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Sometimes we want to access a napi protected resource from task
context like in the case of io_uring zc falling back to copy and
accessing the buffer ring. Add a helper function that allows to execute
a custom function from napi context by first stopping it similarly to
napi_busy_loop().

Experimental, needs much polishing and sharing bits with
napi_busy_loop().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/busy_poll.h |  7 +++++++
 net/core/dev.c          | 46 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 4dabeb6c76d3..64238467e00a 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -47,6 +47,8 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget);
+void napi_execute(struct napi_struct *napi,
+		  void (*cb)(void *), void *cb_arg);
 
 #else /* CONFIG_NET_RX_BUSY_POLL */
 static inline unsigned long net_busy_loop_on(void)
@@ -59,6 +61,11 @@ static inline bool sk_can_busy_loop(struct sock *sk)
 	return false;
 }
 
+static inline void napi_execute(struct napi_struct *napi,
+				void (*cb)(void *), void *cb_arg)
+{
+}
+
 #endif /* CONFIG_NET_RX_BUSY_POLL */
 
 static inline unsigned long busy_loop_current_time(void)
diff --git a/net/core/dev.c b/net/core/dev.c
index e55750c47245..2dd4f3846535 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6537,6 +6537,52 @@ void napi_busy_loop(unsigned int napi_id,
 }
 EXPORT_SYMBOL(napi_busy_loop);
 
+void napi_execute(struct napi_struct *napi,
+		  void (*cb)(void *), void *cb_arg)
+{
+	bool done = false;
+	unsigned long val;
+	void *have_poll_lock = NULL;
+
+	rcu_read_lock();
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
2.39.3


