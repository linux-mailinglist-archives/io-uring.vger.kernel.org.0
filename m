Return-Path: <io-uring+bounces-66-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38F4D7E4AFB
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68F141C20D6A
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5958C2CCA2;
	Tue,  7 Nov 2023 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="0qfxYbvB"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E6B2BD03
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:11 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C46B10EB
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:11 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cc29f39e7aso42066725ad.0
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393270; x=1699998070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DEYoqijzZJW9k3dNn5XO9gR9ltrXX/l1ozIXtxfwbU8=;
        b=0qfxYbvBi+FA5VLTVj5BUubHqOc0REVtaihsVsYyZEw8gMK3yYSvFhiRDwQTldCckd
         mUEF6RbihQb2N3f18LEW+YZesQBu8NkmWAImGfMOdB+K1+AR1DimFMenOlMnda1DtEPC
         wgPko3l31ONOiit4m2cn/oAG/0g8rx/xlsNHXj1QJtqybpFrBvAPHyqpe2dFAD6sy1LM
         VylFuHQXLqaOapxPH4Dd07SF8BtMZUjz+I8uW8PgObEAZtkHl0mSkHU8D2wqHO7fO1FK
         wj4eeK02VFgmxqYgSdOvTOQN4tSTfFXl+5pBOlmb/nR1Yg6bwIb/w/yddAiSqZuDN1x7
         wyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393270; x=1699998070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DEYoqijzZJW9k3dNn5XO9gR9ltrXX/l1ozIXtxfwbU8=;
        b=CaPE2V7NaugAbzqzqh/42heHhXwyM11+16a8IOho/Fpx9HcCJrykjfGHy2sttW4AbZ
         hclJejOvOeFv4r51a7Fm0VoGyA6ckiK4dgHOiIxae4EjZEBbIv4ugzzJmTt4YwSJMsMJ
         xhch9e3Yc8atV9BKl9EN7Ge8le4VUJ9p8ExjiHr+aV+5ZMvNrKOYBBOcHWMHV6ESTlVn
         TKMoqI6IUxxIchDe9WUKuQDKaqkujctWY/PD/jeEfS3Yv0poFxrOGDxMP6AcE2xARcAD
         9lSJOlBn5yIpwk04j3wT8rIKVpzh5occCPXKRz69km2OODHc1wgBypyYOgriyDLARFI2
         Iwqg==
X-Gm-Message-State: AOJu0YxntehZBDr1axAguc5CDlp2YQfSlWsXmGkdjceOM+DvMiEJD+gg
	TC/qAvanb7eWX6oiCrTWudaoDXH8RtXg9KRcwjhT0g==
X-Google-Smtp-Source: AGHT+IEKSuqqWQvMVmIb/Hqh7B+Gxlpgb+OwjhNZAxtVTPcTPHKznyOvGf1WAmMO7Igy9ntVidWomg==
X-Received: by 2002:a17:903:230c:b0:1cc:6e42:1413 with SMTP id d12-20020a170903230c00b001cc6e421413mr256995plh.57.1699393270702;
        Tue, 07 Nov 2023 13:41:10 -0800 (PST)
Received: from localhost (fwdproxy-prn-001.fbsv.net. [2a03:2880:ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id u1-20020a170902e80100b001cc3a6813f8sm268781plg.154.2023.11.07.13.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:10 -0800 (PST)
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
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 16/20] net: execute custom callback from napi
Date: Tue,  7 Nov 2023 13:40:41 -0800
Message-Id: <20231107214045.2172393-17-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
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

Experimental and might go away after convertion to custom page pools.
It has to share more code with napi_busy_loop(). It also might be
spinning too long a better breaking mechanism.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/busy_poll.h |  2 ++
 net/core/dev.c          | 51 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 4dabeb6c76d3..292c3b4eaa7a 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -47,6 +47,8 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget);
+void napi_execute(unsigned int napi_id,
+		  bool (*cb)(void *), void *cb_arg);
 
 #else /* CONFIG_NET_RX_BUSY_POLL */
 static inline unsigned long net_busy_loop_on(void)
diff --git a/net/core/dev.c b/net/core/dev.c
index 02949a929e7f..66397ac1d8fc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6291,6 +6291,57 @@ void napi_busy_loop(unsigned int napi_id,
 }
 EXPORT_SYMBOL(napi_busy_loop);
 
+void napi_execute(unsigned int napi_id,
+		  bool (*cb)(void *), void *cb_arg)
+{
+	bool done = false;
+	unsigned long val;
+	void *have_poll_lock = NULL;
+	struct napi_struct *napi;
+
+	rcu_read_lock();
+	napi = napi_by_id(napi_id);
+	if (!napi)
+		goto out;
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
+out:
+	rcu_read_unlock();
+}
+
 #endif /* CONFIG_NET_RX_BUSY_POLL */
 
 static void napi_hash_add(struct napi_struct *napi)
-- 
2.39.3


