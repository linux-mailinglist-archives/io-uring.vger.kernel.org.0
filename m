Return-Path: <io-uring+bounces-7754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4C2A9F16C
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 14:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E41A84618A0
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 12:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58E926A0AF;
	Mon, 28 Apr 2025 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mofVb9Fy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB19268C73
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 12:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844708; cv=none; b=fo7l9YuXttEZJMchFMyveANtdO/jSb7Dy2U/k3D7xVt0RVrovkJfg6IM/M6AN+HyjBV9HoHaUPRANTjMum6aBQiQQMEPz+wV7hB8qkxrosEZTvxAWsP8TpV9CxdSySObYmJRXZ+WwIcGRpvxK+3KrAtJrtKQZ3FbtsNCxxFd08Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844708; c=relaxed/simple;
	bh=VVGnEzUGGapWXp1aZnSsLsXGBwRZqjkXFGVaOvJJFn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqtFW4Me9ytq95hsHFmaDuBnkHwqoeEieSqBllsQwOXDOkyXE+T1/RpR+Tj6s0RzPzbTgemii4ISl8uzFqMIYjLgUAwa2MKatR/tWxb/0yytuHyljU40WQ7oI2sGe/31AUJue9X63pqOJWuQAvMY/jRPNS3QpV8wJO9/RFaZFXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mofVb9Fy; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac2902f7c2aso788650466b.1
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 05:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745844705; x=1746449505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/apEXpAdbGphrrv4qcpPfW6L31chjY0GoV0mm/oaF5g=;
        b=mofVb9FyANG9rYErzyt2Br90Ydr4Ukm8P+S2qsjwDXaQ18vZW3nGEQ2BSXtRz2RNmD
         PvYMp9d4qzm8xNzpJ3+IwbOG8+/yQZxwQ897LvDCHUdn5/4LgAyBbFO8gPghr5Q9dYBj
         R4oCDRSSigKa9fxwA0Xse2C0kxp6DxY01DIpX8o5dvMFJNIykTmCEmnhMmIAX6FCcCq5
         7CbCRTJmdKtC9Y1yk0HcwaZC2dlpqVLo05lYOmOoWQiPjn2jBc7xlRkjNKqEnyunFcYa
         JC2vx8ZanE/8zO34zTvLJQspgi8UFvxhaUvGIdnvjf9+CwjQrE/kIW6Cs1yU52t8aTff
         SUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745844705; x=1746449505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/apEXpAdbGphrrv4qcpPfW6L31chjY0GoV0mm/oaF5g=;
        b=hxMlyaY+dvKi9pOP9UaxkxTM8pIi5wdrtMvhVicglvWrpksHgg7KKkJ+o3KkFcn/c4
         mRfWq7Ak/RpsoSNFb6gX/hunqldydP9ECneuSp096Ane41v6dtZtR+lCRxKO45Uf+qOW
         ljtJdeHmoVWmBrnE1EFy5TQ8xA0RqB+GDLJRftr3vYHNPmq4NXF4cin9FK5kK5krRVY7
         R+3z5xiLmpY/qxJ1FSij5SRjybUjH0DRILkfesc4OksVmwRIvx0Wef15gVcL1pWR1bza
         QtEr1scMBDAzUWx3fqb6DJXhrg1ur06FbL4wSR5ItymfveXL0UA0fQCn6v1tx26VHo69
         enjQ==
X-Gm-Message-State: AOJu0YxobFK8jdwyEhUjCHF7TqXmFyHfiDOALXe0TGnp4MlKZ/3oTR+n
	JTz0x/isXBls9pPzQf0BZsGrTvNeEGpMKDIEQdfkt4yIgYtek5xmcech2g==
X-Gm-Gg: ASbGnctnRkuXAiqTD7dVAFYYTGbQYKQHX0YkOS/J+LOnXLCk5KN+SnOj7PFIZBqpHI8
	Aw/NcTHRW9q202XpJTgvktMsm6NmXNXf1D1AP+bV5NhsIPnQcfiHK+WHqQlyNQcUDLRJm+y/KJU
	BQJZgt4IV9PlNQ7TiBRSQCN15phrnU5E/JqKxvGL7yi20pyY+ImkJzDGN3Zeg0XZWhmfr+/Ebv2
	yeqsvYdqhAYCAf939BTqbKsT9y18y/ngwgUagtjU8NCIgB8/IcuDGNK9oIvJLaXBqtGIoxAaMo4
	iBME/YHT2rkJeMoLS2/Gj8J61Cqpi7k4UmY=
X-Google-Smtp-Source: AGHT+IGojl2kzKhDRPQPUuWjQ/B9Qx+sLxY6pA3MQzY+6OTgxgKu88pwR8BYI/TFOMXl6Vr5iQ/GuQ==
X-Received: by 2002:a17:907:a07:b0:ace:3952:c375 with SMTP id a640c23a62f3a-ace7133c37dmr967067466b.42.1745844704941;
        Mon, 28 Apr 2025 05:51:44 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c92c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e58673dsm613010766b.76.2025.04.28.05.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 05:51:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH RFC 3/7] net: timestamp: add helper returning skb's tx tstamp
Date: Mon, 28 Apr 2025 13:52:34 +0100
Message-ID: <73287c9af35f3f7294d7dcd31772692f33b5b330.1745843119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
References: <cover.1745843119.git.asml.silence@gmail.com>
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
 include/net/sock.h |  3 +++
 net/socket.c       | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 694f954258d4..37fb15a04799 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2661,6 +2661,9 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
 			     struct sk_buff *skb);
 
+bool skb_get_tx_timestamp(struct sock *sk, struct sk_buff *skb,
+			  struct timespec64 *ts);
+
 static inline void
 sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
 {
diff --git a/net/socket.c b/net/socket.c
index 9a0e720f0859..2ae776011ca1 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -843,6 +843,38 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
 		 sizeof(ts_pktinfo), &ts_pktinfo);
 }
 
+bool skb_get_tx_timestamp(struct sock *sk, struct sk_buff *skb,
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
2.48.1


