Return-Path: <io-uring+bounces-8312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B365CAD6BB9
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 11:09:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A2731885D8E
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 09:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F07E2288F9;
	Thu, 12 Jun 2025 09:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UR8M+9XB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448D12248BE;
	Thu, 12 Jun 2025 09:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719313; cv=none; b=GapZSGg06fJ6wZ26SP+rInAbtamV4de5eqbqMwN5Z6N4kOoydXAc1WHRzLL86byOBFHbFstnw0+FbpOUfHLPWLZMqXQ5+KeABOCgSMmni6V4MzqiO8TvdRnzvHFTLy9wQ/ITP+bOvcrbtPyWhb6f6ulrffZwWN+67rEJRnFVmd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719313; c=relaxed/simple;
	bh=nTZJriIp1djOLQaXw/g0JiXOhMKvEhbG6BTzngNoGo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGeVtxt+Vmy0JlNZI7AGRWcdnDjy5tJWbm3C+hM4pNwkU+lObEcap+juazvz5KHb6DRRn2TW4jJ7e1Mk57DqEB+ehOvCweMnRHhd9QLVl/lrUYR0Ig7xo4eWsTcWTcytPRwotXE5jTp04J/vPvBt6J9xwHNexyKleoWU4v9cY4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UR8M+9XB; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-addcea380eeso129808766b.0;
        Thu, 12 Jun 2025 02:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749719309; x=1750324109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zuilydyXbNjFR34NNrISeNbAq3PlldzfUTk8m53/PN0=;
        b=UR8M+9XBuFs7cfDyXqcglMxVe2pHHTIV8D4ZB1+wsrmaP65giJPsOUiYdsiQp/ah0y
         ppWom/+SUVPukYiAukSLa/XOPDy2oQm9pB7K+XAl5W5RTdxEi7pifxXQMVJ7gIQRoeG+
         eLXr63t/6FCBIU3qy13qd5FfZ8gTK6N0hxQFK9TJ2lExUwdCpdBx/l9Lnkl487E8CURA
         ueUK9B8uodNlYNVHJIHZALiGOggJEPAQUKGPmXH+RV1rzMOgA9M4dk9hQO3X74WB6qt+
         PBKWymzs1oFXeWFY2kVtNieGMfDXlzJ0LcpOmAOGlqdx9YTzJyHJAjROHh0aYpdilIGR
         qn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749719309; x=1750324109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zuilydyXbNjFR34NNrISeNbAq3PlldzfUTk8m53/PN0=;
        b=jH5keHo+Tnu1p9PIZuZL3VXllX1JaNLfC2FQneCZhjLxxc9X+2KNUcx5ZZoS2jPN0m
         0iCZ6/vOkaC2XjcYe4ivgQI02BP5ZIlzQQThrWJydAQ3GpoNfOyXZrEHfV9iuevZ46o4
         Vr28m8OJ0j1IOkjpTlUGHWqLKzYDdwy3uUmXURWNFEH4yEcPXVtR0Ea6apmM8KUAqXRK
         veLUtOSu1b4MKzZ8K1cudICVQm/xle+mWkJbJwhBhLFhcde/+B/P2AvMCOSBeaDesBNR
         Y1jUlRgLy8FKwmwaZbxbnjYwXgcs9ht0FDGTQvOKHTUrJmISWyc2pMgroNndfubsCNiX
         P+Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWofE+QumNR1A2QjIKjpxGElTQIJORn9oTpm6R9gve5nSBGVMQUcL/ZYFOMByQ8/+I5McJXsrI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5v9XEknIT5VVbdDgGBldZX0RZMaOYYZiWwmjZzcwV+uGNy1k1
	9oK9Sut2cnxcA+h9uYFfu1qPIyqpH1x8jR7P5SBlKS7W0GgUYFfQh9bZSJGFbQ==
X-Gm-Gg: ASbGncvP6Klxt2XtmraGCHRzOxV65z5LcBwQcjK7l4/NOrRl0+2RzAY13w6ja9G0QyF
	Qy1rGnviy3IL2nsGNKHAj9Y6ZOC1xKfifKthd6gQENpj0kuoKNgxxHJfpRfisiOVph9T2P+wwiW
	buAbAVQWn6F3xLyA2Lm44bH7g+6mUKWgnhedZZFicNMMMyfrv78u/DbUQwahub0TZzqVnscWSUu
	j2GIOvLyg3UbBEIy7G/YJiSJngP3lZSzZEEGX0n89etd8CTBYgwAgcuEB7yTQ5vLBHLGA6hILtc
	7WEg9upd15DwRVVMZAv7/MYkXr2V+KOKSXWyGONEhhsI
X-Google-Smtp-Source: AGHT+IH55Mv/H20foz9kI2qpxXC9wYTyjhCcnxFGFsFG/MSSH1fheKHSSzPqnKuETM5a3KdXOSDLTA==
X-Received: by 2002:a17:906:6a10:b0:ad8:a935:b90b with SMTP id a640c23a62f3a-adea93b051fmr238561366b.28.1749719308971;
        Thu, 12 Jun 2025 02:08:28 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adeaded7592sm96883166b.155.2025.06.12.02.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 02:08:28 -0700 (PDT)
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
	Richard Cochran <richardcochran@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>
Subject: [PATCH v3 1/5] net: timestamp: add helper returning skb's tx tstamp
Date: Thu, 12 Jun 2025 10:09:39 +0100
Message-ID: <1c21f70cd46cbac49fe5e121014bc72393135c81.1749657325.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749657325.git.asml.silence@gmail.com>
References: <cover.1749657325.git.asml.silence@gmail.com>
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
 include/net/sock.h |  9 +++++++++
 net/socket.c       | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 92e7c1aae3cc..0b96196d8a34 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2677,6 +2677,15 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
 			     struct sk_buff *skb);
 
+enum {
+	NET_TIMESTAMP_ORIGIN_SW		= 0,
+	NET_TIMESTAMP_ORIGIN_HW		= 1,
+};
+
+bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
+int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
+			 struct timespec64 *ts);
+
 static inline void
 sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
 {
diff --git a/net/socket.c b/net/socket.c
index 9a0e720f0859..9bb618c32d65 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -843,6 +843,51 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
 		 sizeof(ts_pktinfo), &ts_pktinfo);
 }
 
+bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk)
+{
+	const struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+	u32 tsflags = READ_ONCE(sk->sk_tsflags);
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
+int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
+			  struct timespec64 *ts)
+{
+	u32 tsflags = READ_ONCE(sk->sk_tsflags);
+	ktime_t hwtstamp;
+	int if_index = 0;
+
+	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
+	    ktime_to_timespec64_cond(skb->tstamp, ts))
+		return NET_TIMESTAMP_ORIGIN_SW;
+
+	if (!(tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) ||
+	    skb_is_swtx_tstamp(skb, false))
+		return -ENOENT;
+
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
+		hwtstamp = get_timestamp(sk, skb, &if_index);
+	else
+		hwtstamp = skb_hwtstamps(skb)->hwtstamp;
+
+	if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
+		hwtstamp = ptp_convert_timestamp(&hwtstamp,
+						READ_ONCE(sk->sk_bind_phc));
+	if (!ktime_to_timespec64_cond(hwtstamp, ts))
+		return -ENOENT;
+	return NET_TIMESTAMP_ORIGIN_HW;
+}
+
 /*
  * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
  */
-- 
2.49.0


