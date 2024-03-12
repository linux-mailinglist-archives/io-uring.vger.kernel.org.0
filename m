Return-Path: <io-uring+bounces-916-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7E5879DD2
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05D251F20FF8
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27BA14601C;
	Tue, 12 Mar 2024 21:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="SYlvft1j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF3F146008
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279889; cv=none; b=dFJI1g9CNxK72vVESsMFL4Pbn5P5Be913bGXWKxjjPLkYifVKk6SPUdiH6UaqoESpQcP91ssVYQGBfBCimeEY1Spj3Cx+XN+Tesuf4nvw0hXVMpmu8FYrewhwKNDDwsAx5Ddbp6gP+7K7yNYetdOT4zFK8MUQK+Z8B0fkHV2Bjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279889; c=relaxed/simple;
	bh=1hALqYekJ2oj/HWhQXcw5HAvfVNul9K500R6znLcI+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU/slkEl8vmZcX3IY0EUpKD2znbR1Jer+d2lrSpQIazOx/8e94xBSF2ZYSqKdFT4fM8YzOAuBQwjKHwmKQO3/PeG6Ch1OzvgIwy0rY/IUp6WYMZ+6UspqS2PUDvuyUrt5+ZZhoh8gsshL0easzYCZKaKpn08by4w/Q9i/IC6zXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=SYlvft1j; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dd7df835a8so32323665ad.1
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279887; x=1710884687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZRO95Kdke95/CXsJPGgRoGGIRwQcdQkfuE0TmEZDZS0=;
        b=SYlvft1jWwOMtcS6s89Cjb61ZLegX7DX1xcpbZtv0dXXIOeyB5CKX5KXtlFKh/uVrh
         7b9HeKbjBMHTzgG+UDLNz8L3CN0y5jgbp3S8DI7vYwTqEzn0lIBFng31Nh7EjTmeMffB
         ce3Go5Ypk3WYG4P0EV0of89ZMb2K6kzzkVgnNYHrlXCESMVEHau5FQkhDaSe0RyyYV/0
         fK2H+Mi1LwuwSsb+lbSr+fYMkx6wAe5/P+ok3GEFZg1DmRcsS90HcqUwt8+yDhWbPr+x
         IdqhwWvvIu7ef0wHGwFZd95HGAhlEcGz9dZmMNrcRnRZ0ArDQosPdomwdLBrDQKylVCO
         qqIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279887; x=1710884687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZRO95Kdke95/CXsJPGgRoGGIRwQcdQkfuE0TmEZDZS0=;
        b=CtxcQfxiQhdnXf8F/cgyYYNkt8azrYy+1WSk6RKEz/ntUmmVbPIjWuDlboQD1T/LRt
         hHHqS8xkqdBVtloB9FT6lcjnmWeGtfEWjOHXcq8ah6WtYw89PURGB8D6L/68gMSaP2Pj
         8kaAN7mRUzC9jplYl86jS71xhT0EhsD/Qd8fF144pWzaNSVUxSdK40MK/jb/YZgC1qtG
         zsJPHHU/WLRYDCE4HrBevcqupstxIVIpQEiEMWOgRxxvUlKOHdosPx/9eR41eP8H1KL9
         1TN9onu2Dodc3TlCdb9cI4lLl0hWeWv+9Nzx75ZC3vBRIlSDN0ZhJHTp6bY2RDA1jArg
         EjFw==
X-Gm-Message-State: AOJu0YxQgo2XplBlfUoamJahFB256Jz7meUc2Z4Vyev27gJv5hgMlbea
	q8mb8BI66R3TfFQXohgOqQK+oWQctDk1Ox8hd4yJvaLtG6Up6wMmhJJM3qEDQ0h/j/WHhPIomJJ
	4
X-Google-Smtp-Source: AGHT+IF31cYyvpgFJ1C6r8UOXG8CtpluFYbareGQQz76ulAvEHus9G0Qt/JlvJonH+TOMzSuV3P70g==
X-Received: by 2002:a17:902:cf04:b0:1dd:b6b8:3d8e with SMTP id i4-20020a170902cf0400b001ddb6b83d8emr2107298plg.12.1710279887530;
        Tue, 12 Mar 2024 14:44:47 -0700 (PDT)
Received: from localhost (fwdproxy-prn-006.fbsv.net. [2a03:2880:ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id mm16-20020a1709030a1000b001dcc97aa8fasm7244800plb.17.2024.03.12.14.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:47 -0700 (PDT)
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
Subject: [RFC PATCH v4 14/16] net: execute custom callback from napi
Date: Tue, 12 Mar 2024 14:44:28 -0700
Message-ID: <20240312214430.2923019-15-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
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
index 9b09acac538e..9f4a40898118 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -47,6 +47,8 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget);
+void napi_execute(struct napi_struct *napi,
+		  void (*cb)(void *), void *cb_arg);
 
 void napi_busy_loop_rcu(unsigned int napi_id,
 			bool (*loop_end)(void *, unsigned long),
@@ -63,6 +65,11 @@ static inline bool sk_can_busy_loop(struct sock *sk)
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
index 2096ff57685a..4de173667233 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6663,6 +6663,52 @@ void napi_busy_loop(unsigned int napi_id,
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
2.43.0


