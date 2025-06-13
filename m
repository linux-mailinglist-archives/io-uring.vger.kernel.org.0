Return-Path: <io-uring+bounces-8335-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2317CAD9472
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 20:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4885D174233
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 18:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C92230BEF;
	Fri, 13 Jun 2025 18:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IgDMQjVL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5810E202963;
	Fri, 13 Jun 2025 18:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839485; cv=none; b=dl1F3ghsu77Z//ygSmRaqZbb/Br8YPsHBqEYDWxSXLBxaJwrNyVk7mge+kGj4mR9JLl63ftGvqtIPShewMROzkZREBOPA6vYAk3Shl1HNnrFLyxjJYqS0o9STwDeTee3mhw9UDri0W0N/xx9FCSzzP3sJ0Lygq2uZApPulAgv6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839485; c=relaxed/simple;
	bh=OL8EPIlZntC/SAKEnC/SzZaTWYznk/uH60N2h1ol5CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRzNxp0s/2j8QQtr/q1nQkfwTml/vLUjYlJ+wwn5Jq+OfVxJFUQCaT4TdE64P+jiPNG1G7yj0LUwXRmKXqe+GixILaYBtnmjP+3Z6cN/W/UlPrQUsPqIFqSVaeI5GBzBimv44rVtbxnk35fv1HzkoWsdRevJnehz+LcVoxGp+UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IgDMQjVL; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ad8826c05f2so450293166b.3;
        Fri, 13 Jun 2025 11:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749839481; x=1750444281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1tvGN/avKr60NZFEAFHQz/to81E+Q3SxTZdSAx4duc=;
        b=IgDMQjVLrgjeUJ7VLHd60Mv4IryMGa6hkvVlQgUoWPkxWFCnkErIKtSuFOK7PmQNOi
         wZG7+XknprI2Vv31qiNl8J1n3Rtikb0xCLX7s5X22KGOoedCVEIgyJ6q5FdZxhzWdDcO
         v5liAFP5NwmnsDrfxpWXUAM0rRK4pnPBngoTgrL5DpbVW1WjagKHrg7ImaP8PLANSZwV
         dkYBUPaonqRw/gelse8QzOLTZRomcrxlR2TPLdNnddQM9nrx5os/lAD5qjk4yMmD26Y+
         NZrSibqV/2Nqureog/pqeU63qWiNotPYMMY1dmYHyTqHEFRuSgQC5zMbT+JYDCjTuScq
         T69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839481; x=1750444281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1tvGN/avKr60NZFEAFHQz/to81E+Q3SxTZdSAx4duc=;
        b=DUJO9fHc263PulQXl4ydAbKrhtfVILfC0EAeISWNOIJh/uVLUGR4zQwQR/9eo5wzu7
         3UsjWvIxjeZeKPkmN4CNNtMjt/kTuEG5lyIhtfR0oOW6lIJTBPX9raBseBYlh9nJO9wH
         KAdJIAMj+QDxkNEsUoriw0kPMATBshBWRdzModrnB4wlx7GRgRMMX4byOqyijARY1F4L
         dgbY/BS0xUy7WcZskB6Qp2FR90OHUTj2J3iaVs4FjdnLG+lnHiiypB/4pJD01TWAKcQ1
         a94seYBDmBYqVNaxvaRsfiIjXQp6DrGoATM4u2IwD9RJTxGmJ73J0lr63DS8OqmUjq1E
         c2hA==
X-Forwarded-Encrypted: i=1; AJvYcCUgYHcVBRvcY0WIqRUTD/nzZ/KrKCvCNBSIKmzq7tyv/DxHKDPyPxQNy4YhQwEmyUhWbego4is=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcRqlDCb6TEVmfnOyR8X1qZFqnPSxpMlOK0GqLPH/r7FsWd5Uv
	e+GlMl7sJEuHsFymxoRM3OFFGczdwF+AiivFBlCbeO0JdgKW3QshfHHwiSy7xg==
X-Gm-Gg: ASbGncutiPIKI4RP6zvdnQ+PKwtOIZcDwXPvhcZ5O+hhqwVPgMgnK2qrnqJJvYTLVyh
	l7pvSR0hlQ5RecoSNUMh+75Yp0iE6JvBwTUQ/O1iyDxyYdb4VOM7l3d1DA2DxL+S7BIZY6Bb1IZ
	NAnYY+XOJMkNGKQwzmIRalYjOxFvlTWSkk2WEIf24WbzOuj/+KzoPyqdOHq42d4s+dzUlx9hs6j
	EnNjgKudqCmiXUYuxMIj+nyzEIi/FYeUURjKgLF4K9nDGURp02J3kQpRf79cZykDjI6l5APGrm4
	f/vUQXYlBbk4MaoWFlpu8gs94V4mGdW+RKEXZ4Z5esl6sXaWsKqZdUeR1ArniHWMsi7830UdRA=
	=
X-Google-Smtp-Source: AGHT+IE2XxS7FlhUlOSsXZCGVXqaRhwOGJIjFyalru1VNtzCzxJ3+jEk7+UkxyIC+/K8Hxwjx0vK2A==
X-Received: by 2002:a17:907:9626:b0:ade:40cb:2517 with SMTP id a640c23a62f3a-adfad450a9amr21699866b.30.1749839481032;
        Fri, 13 Jun 2025 11:31:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adf688970a1sm54772466b.175.2025.06.13.11.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:31:20 -0700 (PDT)
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
Subject: [PATCH v4 1/5] net: timestamp: add helper returning skb's tx tstamp
Date: Fri, 13 Jun 2025 19:32:23 +0100
Message-ID: <766c5e599bc94296fe58087e4c30226260cddff8.1749839083.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749839083.git.asml.silence@gmail.com>
References: <cover.1749839083.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
associated with an error queue skb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/sock.h |  9 +++++++++
 net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

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
index 9a0e720f0859..eefbd730a9a2 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -843,6 +843,52 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
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
+
+	return NET_TIMESTAMP_ORIGIN_HW;
+}
+
 /*
  * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
  */
-- 
2.49.0


