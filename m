Return-Path: <io-uring+bounces-8203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A403ACDA16
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 10:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D91AD1887C5C
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 08:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23AF328B50A;
	Wed,  4 Jun 2025 08:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdXV1QQI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A30528A3EF;
	Wed,  4 Jun 2025 08:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749026489; cv=none; b=qwG7NrTutD7AfzYcgp16GanwUMGruCqZMHxctmpdDO6mOIjstuZwEMOkT2EhFQHOvwBFjlJnWLWSHr5m35cCLrxYVR7UKey9c6c3K8KSQr5ehwro7qlvnaBGcort5pmdt7+nDglggKX94KlMXv5UqBmo9EWLJgWM0GLmz/TRl+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749026489; c=relaxed/simple;
	bh=5nxSp0GOUb5g/d3J7oWCEcpx3qhCY3M/v3P2TzoB+GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEh4wUxu2bfv7JzsI/Yi2IXo6Dfh/3dvj//5GOaLaXXklwv6zsObmuNcR7j77bmFlOVZKRHeJyAV/W/mlLJoKJKA5ZASP0quGNxuwHNc4b8iOge7sga3oZqnxdTlFOJQkaKEExQh0AkWvASoUIoFKn90jzeAlDI4UJhX8gA/puE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LdXV1QQI; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-606bbe60c01so2906960a12.2;
        Wed, 04 Jun 2025 01:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749026485; x=1749631285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3zCdyQTLsrA0GWREphiZTYKRopF5OF8cN/7Q0ajCSQw=;
        b=LdXV1QQIgR2b7RDURY8KDLHm9v0wgbKXJIdWWtAqE4FQV2ZdxKd16w3r+hNaib5TuB
         l51srDNLgC9pEE7mDhLYNTD1HX5Gaksszspaf9lY7ufC1y9vZnP3DtW/GAMcwKTskGEL
         VynMKW1QwLes2K/cuQ9nGRWbeMEIHzf8QYa5OOxVMaEeQ5uLsykFfLzxXKqcoQVTDAd+
         kK8v8x0DlePYTHrlwtX59l7MzOX0KlU9mCjb50DtFDtv3J9DcdJG/19KoJ3NMrI1nhdX
         SVJQ1RHcnpgQby71bH+8X6Ilp0V49vsLE/7c/EgrCyM7SLqJa8+bdxjAHJaJm+imAURQ
         vbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749026485; x=1749631285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3zCdyQTLsrA0GWREphiZTYKRopF5OF8cN/7Q0ajCSQw=;
        b=tUwEXl2c1SljkxtNLg+SDNEqR7KAAYRWInZG1P7MgVF4oze0M+tzvG63gSehojpY6i
         CRinoW7MX3wZ46EL25I6xdGUwF+rYIrT2LSL23eUxWZ85wl3i9tXHEoqjGT2pAPtbzXX
         tiqK/wFoXVRqeugTkgxOdGQwundyhCO3PQRzeEF0nEyX93l2mqK+aST0HmxguMLURvOm
         DQ03zzQTKU1FBLD9sbZWHr5Zi9V5No6S6H/Qnrc1ftjWO6oE/Ko9wZ0xM4jcmCkO7FU1
         L7rfGITQL8ScVw+5wJxo2MqG/9/h01RxELXSyo+ygfrxFTBOGm94Zh8S6yPBq/KmXSWn
         7qpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIKJrbsyyM/fDkAC9OrJdIK6LnEwwwKiRiY82grKmFH93KP4uB3U3z/TzZAA1/Rn7GIwFi4U0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGzNepSKECD/SkZx0lGVChD0TpnMvklyTgt4+XQBY3Jq0h8uxX
	hMFm+V4rPnbqHNlxv3wBmX64V/Ji14RMzAawM7IYsdWnbxW6UCiPrmg0ed25Cw==
X-Gm-Gg: ASbGnct11By/DmNmmIsAJeNnxCqKlCJ975mu09cF1ufNKKzCueJs58GIQe2nn2Rv4D9
	CPRa/54Vwu+WNYcQ77rJeSWw0ORSY0HMVaaPbdL3fUteDlJzQl6H6ApBGz4p/9DgKFmAMVj2uvT
	J5Ula/Awz1ZpsxN3Z3gkc24IoVWTXDWeCODlTVOI/X3+UfcMnyrAgte327jAZeW83+C6xRGyt1W
	vRPRG7OYr8yAMlY5Lr4B0AQCEN4w6A9rPFeqUrvVQVqtyER785cOnw6JbGpttVawM+YivCkM3u6
	fU1N4aW/GN1YiPiIbjaWJ9AkV8ReznLR22gg0eaElI/p4GM3RmPdPqzO
X-Google-Smtp-Source: AGHT+IG6ekUjH258OEhDAUWRVVXXPKjJTeyzTBHu9KS2wPPUOLP3DVUzeZZEkM1E+cOvi79EQDvnaA==
X-Received: by 2002:a05:6402:350c:b0:601:6c34:5ed2 with SMTP id 4fb4d7f45d1cf-606e91ff78cmr1978949a12.4.1749026484808;
        Wed, 04 Jun 2025 01:41:24 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-606f3ace23bsm544261a12.12.2025.06.04.01.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 01:41:23 -0700 (PDT)
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
Subject: [PATCH v2 1/5] net: timestamp: add helper returning skb's tx tstamp
Date: Wed,  4 Jun 2025 09:42:27 +0100
Message-ID: <3fd901885e836b924b9acc4c9dc1b0148612a480.1749026421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749026421.git.asml.silence@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
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
 net/socket.c       | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 92e7c1aae3cc..1cd288880ab3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
 			     struct sk_buff *skb);
 
+bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
+bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
+			  struct timespec64 *ts);
+
 static inline void
 sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
 {
diff --git a/net/socket.c b/net/socket.c
index 9a0e720f0859..e9c8f3074fe1 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -843,6 +843,49 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
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
+bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
+			  struct timespec64 *ts)
+{
+	u32 tsflags = READ_ONCE(sk->sk_tsflags);
+	ktime_t hwtstamp;
+	int if_index = 0;
+
+	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
+	    ktime_to_timespec64_cond(skb->tstamp, ts))
+		return true;
+
+	if (!(tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) ||
+	    skb_is_swtx_tstamp(skb, false))
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


