Return-Path: <io-uring+bounces-8135-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8730CAC8D6D
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 724704A6123
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 12:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF31F22B59C;
	Fri, 30 May 2025 12:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h96kjmYR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E421C9EE;
	Fri, 30 May 2025 12:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748607440; cv=none; b=H7/ZqIUuRtowSb+a/xZlM0VeUGfzjj/h98P/DfiRx7uO39o/7z5x8K/mBHI2sVjpBjPkbhXD44/NKWNQVhsmBHvXBQSO9+Y8iJmhGVelYInLRRPjUfc2UJUpcnFCtHEOctYq3lxuQTcUNRzLMRHffES1Yrh9Py72o0ocGqHNLmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748607440; c=relaxed/simple;
	bh=YbfIkc//Kmljvr0OZiIDpcB+fBCJ+pbNP/fXoRedj4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJqA+7YYNonH1t6zDLMBdSeRoJI/Njc4gSbKpk5mEmJDiFzUya4YxclFSdI82keuETvdrQ1sq+aVhvI2NXFis/qVOjN9D1rJCED5yYUv3gU5raIsWgJ33EUpQrh4eqg/hJg7XBm56FeFVKWB3JvC2FMz3oy9keVXSRzzqRmHf3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h96kjmYR; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad89333d603so371296966b.2;
        Fri, 30 May 2025 05:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748607436; x=1749212236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ir6qIV4Qi5CAi8BKrklc5pqwQtTpVQLCz2EN46firE=;
        b=h96kjmYRIprQJT+JPlF/yg8qy8thpLJvpoHkBLeAi1qKBU5vt+bBfA7IZa+d7RKyJN
         wBHsl+Xs52XNqr5eL2VzoDRgo1riqeH1yxyqKbW1AAJRGWES5/gl+0hdk1E9+6a5HZAX
         81hziO0U3PyNXUnjmm0toNcggCCDmihgfVYTwa1YIVUj1cUF3SPtYwcfDwxHombwOrVp
         HANozS5qeetMnophwp3r0ElR46oBOQ8/BHq+CtTL//9OhlStoFeLNnyuZr1nXPlntJ4w
         6epHZmcTd+HlCsyF3avWXmr6+ovW4HV9LcAhtgs2jZuUvbS+wxZxoCmmDWT33bfZVpMp
         s9eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748607436; x=1749212236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ir6qIV4Qi5CAi8BKrklc5pqwQtTpVQLCz2EN46firE=;
        b=aba3VO7JyLQ+fKNBcRe0gjto4N1kBwSpyujxOSLmxMCca9PkT3iys9tJbLR/rwDcin
         xVosz6+Ipo4Qtpa/Iu2BD1F+f7wKIh3O/PguPq6UQu7xVMy8eI9gqWNciUQ5fAUREE/S
         kewlLZPAWA8IhfqTZBU/6kD68Lwfj+wdYhuSY8XZ1pfND6t9nac/dh3TRV/3kEU84yLx
         0GSe2sDxeenvrVMdVs4YwaJfGxnMS64BvJBYdF6P+u42K5THslJib3/Cbwharhcf2QRK
         NNnsidVS8rImd7fFzls1dg4ZD5+BX+moaVvJQuugIWfroHnEOK8xWTjH1GJplMQrBPrn
         fwzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWj8caPulmAmPFrMwRL9a/ypKn/GC9lH/l5V+/Cb3HG+c1Pnz20NUpJAsNLnDnRD8RcK/u0abs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9qUnWbnXrB+aaq/u7OGEhRwma/8VoXD/vOaWD4RQlUnGNySuP
	7pez7h5h3FHNiNI9Rfc+28WvYUtjuiVJElMonWYJ1Tp3sdWf3uH6kmkBVERb+Q==
X-Gm-Gg: ASbGncvlLwt9jOE4rTn07G/iKchpiDu2l7XY35DzjpsqIbYwlfCJVL33mV+8v0k3Pdk
	/C1M0oo/fhU5C2tEr+nA7ArdBypk+2DgqWVe9uHegnuKAIyN7AXSgpVdbB0GFdXZ6HaUtmSYYKx
	zAICccp7qlBZZwvEjr34DVJ4xiskzJdmTmHLJPlm4BqYzr5Fdjqgca8RaNCGVZSy+SmaCaED5Sp
	Xcj8nYCi9TTGxbMChtIgenMi7zXz6ThbtKVgZPJgJAvsEiQfks2WK4wF9uVTgWtboZZ1oXjHgx3
	vEQQ2pYcZQRCYiqeyYAXy2WKxEzKWeaXMXc=
X-Google-Smtp-Source: AGHT+IGHW1q9k2QHuemDmWVc766bpzqUcJ0Dtv/D5xosMv11AvcZ7hWp8q2EprkT559mXBXieddHpg==
X-Received: by 2002:a17:906:730a:b0:ad8:9257:5742 with SMTP id a640c23a62f3a-adb32284e2bmr310935066b.15.1748607435488;
        Fri, 30 May 2025 05:17:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5d82ccedsm318566966b.48.2025.05.30.05.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:17:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 1/5] net: timestamp: add helper returning skb's tx tstamp
Date: Fri, 30 May 2025 13:18:19 +0100
Message-ID: <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748607147.git.asml.silence@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
associated with an skb from an queue queue.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/sock.h |  4 ++++
 net/socket.c       | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 92e7c1aae3cc..b0493e82b6e3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
 			     struct sk_buff *skb);
 
+bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk);
+bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
+			  struct timespec64 *ts);
+
 static inline void
 sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
 {
diff --git a/net/socket.c b/net/socket.c
index 9a0e720f0859..d1dc8ab28e46 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -843,6 +843,55 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
 		 sizeof(ts_pktinfo), &ts_pktinfo);
 }
 
+bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk)
+{
+	u32 tsflags = READ_ONCE(sk->sk_tsflags);
+	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+
+	if (serr->ee.ee_errno != ENOMSG ||
+	   serr->ee.ee_origin != SO_EE_ORIGIN_TIMESTAMPING)
+		return false;
+
+	/* software time stamp available and wanted */
+	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) && skb->tstamp)
+		return true;
+	/* hardware time stamps available and wanted */
+	return (tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
+		skb_hwtstamps(skb)->hwtstamp;
+}
+
+bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
+			  struct timespec64 *ts)
+{
+	u32 tsflags = READ_ONCE(sk->sk_tsflags);
+	bool false_tstamp = false;
+	ktime_t hwtstamp;
+	int if_index = 0;
+
+	if (sock_flag(sk, SOCK_RCVTSTAMP) && skb->tstamp == 0) {
+		__net_timestamp(skb);
+		false_tstamp = true;
+	}
+
+	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
+	    ktime_to_timespec64_cond(skb->tstamp, ts))
+		return true;
+
+	if (!(tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) ||
+	    skb_is_swtx_tstamp(skb, false_tstamp))
+		return false;
+
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
+		hwtstamp = get_timestamp(sk, skb, &if_index);
+	else
+		hwtstamp = skb_hwtstamps(skb)->hwtstamp;
+
+	if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
+		hwtstamp = ptp_convert_timestamp(&hwtstamp,
+						READ_ONCE(sk->sk_bind_phc));
+	return ktime_to_timespec64_cond(hwtstamp, ts);
+}
+
 /*
  * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
  */
-- 
2.49.0


