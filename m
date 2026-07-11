Return-Path: <io-uring+bounces-13951-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id zbTDOYULUmoSLgMAu9opvQ
	(envelope-from <io-uring+bounces-13951-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:23:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E4F741099
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:23:17 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EGoUWgev;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13951-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13951-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BA32E3021D00
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65CD386422;
	Sat, 11 Jul 2026 09:22:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B2838888B
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:22:54 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761776; cv=none; b=jiPHGeq71CjOCo8z+GGqERbnoI5oaSNM5ue2TaWfrZZyuj1PkPBFbpQRvIQ/ruwLUOzsU4lH0DmNRnxkms42UvfsTB4H5/v1xQX2BnFNLo31CdQMOpZJ/NWQTL0/3LuYamSCwgmqmU0Jhs96Zvoec8BG509spJlj/m9vfdic6l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761776; c=relaxed/simple;
	bh=EigAQ+Gs6wOyOUQ21ddB43sniRuCHDpP2vI8P9ls7RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYhikv8RVYi4x/aXihvXDI10/8w8HAs4urRk0/bMehsCUoG1ftV5X0tYFWFDcV0yIRXkUHAtSpMhVmdlabGxB1dC1rybFnYsK7bPzwocwXv13EKAp0Ew0xHVyDVjAzKg0ecPuyFgfjY9mK1ijbqXg50RV0PXwsrn3ymRDr4pv0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EGoUWgev; arc=none smtp.client-ip=209.85.218.46
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15ee037bc0so247466266b.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761773; x=1784366573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4B1lqE8n7nUyqUjZF7GKHI5KXE8E3ivf478nMKbaOZc=;
        b=EGoUWgev+wv4D5vtIuGBW8q5kbwRfy1Bd6inDoYqBFfNjnVAo+yv5GRKrZLkyeMQ/8
         lw14dK/RuGm80yRW/hY45QvJIs+qLRnTZBMtPYzQ2HmBNHRf7x/qU6dHww2IN1TrQ6qN
         mm7+wgkhE1UUi/Xcsig6u16wzQtPTxojpq37bdrEfM2Scz0x6t5jVLOxjZm/TBu/brjy
         666PyBqWnvmyMHDNwJo3s6iAsh7CKpG80HE+6G9lkdxyKz5UU+d4e8YlGTyYEXpA6kB2
         J7jUZN0Ya4OkY5MYI+XxMrRKjj9nY3hZ2duCDPUfriPURX/kD/cXmyIBqgHxeECFLtnT
         Uq7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761773; x=1784366573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4B1lqE8n7nUyqUjZF7GKHI5KXE8E3ivf478nMKbaOZc=;
        b=k2k+iz57S1Ial1ShxoCLOVEWrJ3bbGIkt+WV4eZUm3nSky8Q17ze9DGBMPWIskOIsH
         dvk/lCYYKHDk5vVg2z0fD/DF78T/OXF63cOQB+EkIQpyyGPXQUAH1oNLp+bSsYomQThH
         4WsC0/ZBLDu76khmpd7QEDuftBLpUYDWYWIaLrDeWxJX/Gj2EuLHvp8pGA9fvceE8zTK
         VxO7gLQu1gesR9SB7M4EgpWleTrRSjrwRcgZB6syRd/Hy9hu3uqJZHhB1RJ4rADGmazx
         fLOMwoymQShBJoQaRaiB79oDhkmAzFPsjSroYCXh1t8rSxYf42sqlOPw2SenuWQrAuSI
         oSGw==
X-Gm-Message-State: AOJu0YzsTYJpJFCv31sjPUwQp2x3S1g/gqi/eJgZZMxYFGSy+Cw3aoJm
	5fV10MCgDMgpE4p8GF1CQgUj/3uc4uSDruHQALx1t+UZEMbCPRjHrGI2
X-Gm-Gg: AfdE7clHKP+amJNK4Z74wA7Y8F4vhvI2hCVMchBxoYbvRhzkOZInjjclU9ij3CLVaa4
	bzw+HJyItamwbNQZfYm05mzMUpAaI0a+n1VNhwvaWHQxvWN7nOXjsvefB4JelyYuoSjVvDKNlZK
	IVcpqN71nIOAnYjGxaagOVTt+fJvhMtxvCoECs8XNcCXWazPUOBLlXLHnyVbzxAf1+kFKrbeU0t
	JU/f3FOzHsn8sENb7AL4AvDjqLBHIo+LnQn6IygqFeATB2pBmYyXaOMWSK76B4FEyDE4lW1/XN0
	r1ADuKhXAsKnDjVOjkTWfg9I64UdaXfIHvhJDTh0E+Y743v1s1NjlLlaTuXvptbrdvpIjin+WYj
	bA0VLMQaTLe6GK3co2jFXyUtzVLpQpBXYhkoi7Bx8pTnu06dm+rB8ZweBvR3MPf0B5xCBdiO3Cx
	mD2dhErc9dtL5dCLfpTlYHS3hGcHLDKMqFsE9pOk/NK/Ub87JS53ccbtLpghjJgpGgS129Cd76G
	uw32K/MmLZ2cwyVH842JIkrYrzCixNEDWTOV6BCg44ne2Q=
X-Received: by 2002:a17:907:1604:b0:c12:9a2b:4838 with SMTP id a640c23a62f3a-c161e944c84mr95905466b.26.1783761773503;
        Sat, 11 Jul 2026 02:22:53 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d3859f69sm517493566b.27.2026.07.11.02.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:22:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 5/9] io_uring/zcrx: split io_zcrx_recv_frag()
Date: Sat, 11 Jul 2026 10:22:15 +0100
Message-ID: <032d682ac44315a6115f0c2bb14e02e62a6c6b9c.1783619193.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783619193.git.asml.silence@gmail.com>
References: <cover.1783619193.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13951-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:netdev@vger.kernel.org,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 74E4F741099

In preparation for having more elaborate reference counting for niovs,
split normal pages handling (copy path) out of io_zcrx_recv_frag() and
inline it into callers. Also move refcounting out of it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 162e67287916..80aa68ab9968 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1800,30 +1800,16 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 	return ret;
 }
 
-static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-			     const skb_frag_t *frag, int off, int len)
+static int zcrx_recv_niov(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+				struct net_iov *niov, int off, int len)
 {
-	struct net_iov *niov;
-	struct page_pool *pp;
-
-	if (unlikely(!skb_frag_is_net_iov(frag)))
-		return io_zcrx_copy_frag(req, ifq, frag, off, len);
-
-	niov = netmem_to_net_iov(frag->netmem);
-	pp = niov->desc.pp;
+	struct page_pool *pp = niov->desc.pp;
 
 	if (!pp || pp->mp_ops != &io_uring_pp_zc_ops || io_pp_to_ifq(pp) != ifq)
 		return -EFAULT;
 
-	if (!io_zcrx_queue_cqe(req, niov, ifq, off + skb_frag_off(frag), len))
+	if (!io_zcrx_queue_cqe(req, niov, ifq, off, len))
 		return -ENOSPC;
-
-	/*
-	 * Prevent it from being recycled while user is accessing it.
-	 * It has to be done before grabbing a user reference.
-	 */
-	page_pool_ref_netmem(net_iov_to_netmem(niov));
-	io_zcrx_get_niov_uref(niov);
 	return len;
 }
 
@@ -1892,9 +1878,25 @@ static int __zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 			return -EFAULT;
 		start = frag_end;
 
-		ret = io_zcrx_recv_frag(req, ifq, frag, frag_off, copy);
-		if (ret < 0)
-			goto out;
+		if (unlikely(!skb_frag_is_net_iov(frag))) {
+			ret = io_zcrx_copy_frag(req, ifq, frag, frag_off, copy);
+			if (ret < 0)
+				goto out;
+		} else {
+			struct net_iov *niov = netmem_to_net_iov(frag->netmem);
+
+			ret = zcrx_recv_niov(req, ifq, niov,
+					     frag_off + skb_frag_off(frag),
+					     copy);
+			if (ret < 0)
+				goto out;
+			/*
+			 * Prevent it from being recycled while user is accessing it.
+			 * It has to be done before grabbing a user reference.
+			 */
+			page_pool_ref_netmem(net_iov_to_netmem(niov));
+			io_zcrx_get_niov_uref(niov);
+		}
 
 		offset += ret;
 		len -= ret;
-- 
2.54.0


