Return-Path: <io-uring+bounces-8356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE69DADAC38
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 11:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A99427A78CE
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 09:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC8D2741DA;
	Mon, 16 Jun 2025 09:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d1XO+6sj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A9226E153;
	Mon, 16 Jun 2025 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750067129; cv=none; b=njzfEQB7UEXC3GVvnGK39A6GYrHee0RcJUiW1xJwIhGlVB+L61OjZ5LBRa12D5tdFvPbWKTxtncBOd1q8lGRse+jpQDx73ClhhvKhR3kF3VEqc+EPsRUm346X1eyhSo3nONOdrinzo5xvdo4UIslg/mhWXDdZ433MEjhNNtFXno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750067129; c=relaxed/simple;
	bh=D5rhHDl0StL/pdpG3QWLRi8bZuyZ5bGyZFCtDVG2qqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwrQEDPivr/Gl6OZvNai01LohG+2YfAdW34BK9O05XiF3ymYYy4ui/MYuLMIgTKAYM19jqj/m52Ksp3gA6OqFrVgxxqH2RZP4V0cf92DAayPh+RiYm6uErXTRR1+/JD6DoQLVPYbzG/wiyxYPuaqfDOTCpsNcER6nOUBv9iGlxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d1XO+6sj; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-adb5cb6d8f1so779167066b.3;
        Mon, 16 Jun 2025 02:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750067125; x=1750671925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ohFf6bXXS0P1gLCQx6l4BK5GavoMdO0g5g6ZmRQsBQ=;
        b=d1XO+6sje6/aPlnm6j3wUZ5N5dSbdy6wwVQ93tzxtAMNBVMUUxb5mf4PZq6ceMLChg
         AOEhximvr66gCju6ShqpvrSTHeCO6t6mLkwtVTLfBbKWvsPa4BfJSawN3x5CTF6g7BOZ
         69D6AtCLwlXIxplLqGmbAxCwtyzLMoq+kcOWJeb45+W+rJSchDPqV0nibDHNs3kFnJBN
         c9z0u8V9XodF5uoNrl8y6jV4aegqIR0zQsncMdHjkyM6r1A3ll9tbYEfuV15sV97raP1
         VFIjYePYf2sjBL275+95JxYDCRMV22qva66sOZu51s0+2Wsxtl2NMJzRYhscjRtqeLUl
         IQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750067125; x=1750671925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ohFf6bXXS0P1gLCQx6l4BK5GavoMdO0g5g6ZmRQsBQ=;
        b=nu+t0nmoesVNWF7nB/q780jJ/ypQQVeZTibg5H99+PdHcXX/Br+qavf8u1XjkGa41V
         gTW5ft9TE4+HLFJzLTp42P/gHMVkhJA4QyAY35tN1IRm0EjOhqjnSVMGtX7KP7xV/ZXc
         CFkGQF35HDarUEGk0bB2IAy3sdYL4ox5MHc9NEDSgy+q7AiYbw4w9dVA3GXt0h8TA+TB
         4aKqRxGXL95ONFcmOeBSxNRViNzUmG2f5l6XOmcNzdfob+eWPJhIJcyhJMhJAOOIdkmx
         rWnoQE4nCGOfEkgZ5R6chXHcobmPNkhZ3QH1/Rs37R13YWtGKYlzNm154+U5NAhWArh4
         YxrA==
X-Forwarded-Encrypted: i=1; AJvYcCWLp3wJfDg4ndVPdQNdx+WYSJDZz40stsP4lUKfTwyAhRT+cVhZGEEvN2h+roiLRZWpRjdiVY8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK7i4ixgE/s2ykXGQZoKzZqD2+qgKAuYPEs9DBg2BVctHYsj/x
	Kpr2NAGIdMFT6p7EwP534YzI1hhrm4rKjyiYPq87DsgxURMEjF9mQA//HMUM5Q==
X-Gm-Gg: ASbGncsSFCwWgWDSpErXwq+v39eOE5lezrXEyXHleZKJYS3kcLlVTOBetZCCaedUHtI
	0B4NoD9+kFWvLz1bdJs1K06nxW/hdo1qt3IxD7NBojDaKS9ePBBG/fZKcbLyXfGNzL2gl75z1s3
	Lyzf6HDMBhOgDl7GC1vegaWUFCxqkKvpAlw/XHeZ3p92R0/oXdbM40MEvzdq9lXdiOBLL7e/lJe
	rt4mh578GPOfEHiqc6W9yzKRvh9kXFlsvPleIe774/Fc0vVFkMMb4dOSG0KlbqudKuLVv/V3oY8
	Tb1l1cMEm3cIz5M9E4DKu60WjcMehWUBb6poi8vOtPqjuQ==
X-Google-Smtp-Source: AGHT+IG6+ny3vZAtm+efTIpHJQCMAfoxgIXS7u96fVQHYaiJ0GPCboIPLm19OQFhaLXK3OAmfAoNyw==
X-Received: by 2002:a17:907:1c21:b0:ad2:39a9:f1b2 with SMTP id a640c23a62f3a-adfad4f4e60mr676823666b.59.1750067125099;
        Mon, 16 Jun 2025 02:45:25 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a3c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8159393sm629363266b.15.2025.06.16.02.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 02:45:24 -0700 (PDT)
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
Subject: [PATCH v5 1/5] net: timestamp: add helper returning skb's tx tstamp
Date: Mon, 16 Jun 2025 10:46:25 +0100
Message-ID: <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750065793.git.asml.silence@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
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
 include/net/sock.h |  4 ++++
 net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 92e7c1aae3cc..f5f5a9ad290b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
 			     struct sk_buff *skb);
 
+bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
+int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
+			 struct timespec64 *ts);
+
 static inline void
 sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
 {
diff --git a/net/socket.c b/net/socket.c
index 9a0e720f0859..2cab805943c0 100644
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
+		return SOF_TIMESTAMPING_TX_SOFTWARE;
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
+	return SOF_TIMESTAMPING_TX_HARDWARE;
+}
+
 /*
  * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
  */
-- 
2.49.0


