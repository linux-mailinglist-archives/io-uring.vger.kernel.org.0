Return-Path: <io-uring+bounces-13954-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id oXgpLDMMUmonLgMAu9opvQ
	(envelope-from <io-uring+bounces-13954-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:26:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6C227410CD
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:26:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zi0+QbBt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13954-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13954-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A44C1304DFE9
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B1F4387585;
	Sat, 11 Jul 2026 09:23:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0664525B0B8
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:23:04 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761786; cv=none; b=fCrVaX+sohDuUuGf/xMZ3jlybp2QIjSKLJx8XIEgTcG0tX3+T0tYdt1ikhH9crJolJ6e+uP1HjOWiRFL5gn+6jFyW874hXuzf70ln3blScKM8u+qX8Rvn0EIBfp30aWK3ZWKdGQBCgC74N3C+Eh/DGb+qXhwoBGxXMoJn1K0wKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761786; c=relaxed/simple;
	bh=w5gP4i8nA4yRX2rouKTaGTuvg441hZXElpGa9JUERWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMXYy3gYUetBC8CMwIB1BbGVEY5EgsoDirp+zvj1kvUNEyhhlRqRMW3qhp7RM0xD62y+Sw2KxFMVuCZjSP0aiDX89FV4RMlIVc8An+GndOBralZlmNKhAW6S9JBVgM+xQMqd/k4CUHeqcONwOCZcLFCmlttVcNbB0et61bNAKTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zi0+QbBt; arc=none smtp.client-ip=209.85.208.52
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6983f20a8bfso2613052a12.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761783; x=1784366583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BtP7rhvmzwHbUusKt6iPMmMpBZakgxbufeBSajlZBtg=;
        b=Zi0+QbBtXYchHZJdQ/S2J2Dc+TPZ5fvy8N049QocBs1g3LSH3IlpgkikIrryNbh3HT
         UIyaPI5vj7B0adz9dHTyZxhkuhFsj+4v2On3dNzo/eAQIwXcmIxy1mRi3/wIjkNyaI8x
         cDYyUYixu6TeFY4GHRdWUd1us7SfsN01w5Va4Oi5LI6kpWnKIhFiBebDucy31hvy9aRi
         /CRGsp6demg26Vk/1qLAKdmef2FaktIf5G1NACHg8mkbsBn9tR7W32ImJ53ItLhJuUo5
         usbnMA8XJERpAGAxSD+aqA4lxO6RiLmfL4ncepG3gTFeTa8eTDJ3ba4OXeCgK+DrcByx
         DUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761783; x=1784366583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BtP7rhvmzwHbUusKt6iPMmMpBZakgxbufeBSajlZBtg=;
        b=GsVdrOxgTNZZboKe9eQXiOXFdBk4How9JOU0BP4KqsN3yFrzDau4vpmpSQVgckCyir
         sowT8cJAendxpqSZeLyA+/1NvKVGW7ZKPOltvioDFkSZDIdwYGgHocXrlN9n0219XAIz
         uZJtVVQSwVO5t0sjH+l3EwTSrJ2pPuxTTs9ta59rIhsi7JnvFVKBlHaUY26V7n1lgIrw
         WqIm/4L0el94Og26tH2Ahb3zY3ujbvrEmRfYpfJCDtN3lqTIt41cDDgwZPxLYppvteM8
         tZWtqoGDbC22vPB33g9OaBjcePUlQG/mwkL6WUdJh3PIfOWYzb4EKKl4UCgWepOiHIX/
         GcDQ==
X-Gm-Message-State: AOJu0YwwoYdGLs61jXk6s7Sr6HB0Mb62+9Tf08PlslbbCjB6gZYZbPKl
	EnyRSU9XSbBHoJemfASWk3ZQPdN+q2Q+ZrKoU3FYgy6ocwBt3vGvBFkhVrfmxw==
X-Gm-Gg: AfdE7cl+SFEaWCDedijyOc5zvhxKQ/QLx61Z3Qq5Sm0nOzJkiuIP+70+gJEo/ORObf5
	yDIDsnSA8Rhbg2S7hS2NtgNu0cnjkbBSVQTB3HUioWQx7kWTHEzsW+cVU46cDZFPGFADkv+5UtR
	PFBVuCerqzOLsyXt0JNTT75knbBvKBBijuKE++gC/5ktdlG0uJClaVdGKwtMCWZvHRVdHGNjQ7I
	9RtB5wDsb6ridONCKIqqokZl/cxDQyL+NcQuehSsHZ/5lON5VAKr5+rFs282NPJbktq2Jxw8qus
	barxljY6hT6qQndfT40K+gCn0yBZR1XPhJv5PrRaefdHxseXclmcG2ClKjAbK7EjES/S2jV8R0b
	VFFHUGE2IGVHoK3XWd5jmDZWP7eu9o4J4/FfC4W0nGhsf0BgwENZyieBqCq0sIXByWm9FCkKB5T
	U72yPkOrTP6WyuV45cf4hcXGMU4rQodc+8wYYV+Qac1FUZ23jbJBcNvzVFihmzjQrhCGSOGP4DH
	oh/LFFOeEyY2pFzCKwnpShUTw+WaFOfYRJN/E31WqzRcHo=
X-Received: by 2002:a17:906:f5a1:b0:c16:1579:762b with SMTP id a640c23a62f3a-c161f3b54ecmr79745966b.52.1783761783384;
        Sat, 11 Jul 2026 02:23:03 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d3859f69sm517493566b.27.2026.07.11.02.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:23:02 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 8/9] io_uring/zcrx: steal niov refs
Date: Sat, 11 Jul 2026 10:22:18 +0100
Message-ID: <421a7de8c5ddffd3461e416998f6fb034ffb0282.1783619193.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13954-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:netdev@vger.kernel.org,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D6C227410CD

In zcrx_release_skbs(), we reference all niovs of an skb and then
immediately put them down. Optimise it by stealing the frags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 3d5d5c9fd9a5..23669471a8f0 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1317,11 +1317,22 @@ static void zcrx_release_skbs(struct io_zcrx_ifq *ifq)
 {
 	while (1) {
 		struct sk_buff *skb = __ptr_ring_consume(&ifq->skb_ring);
+		struct skb_shared_info *shi;
+		unsigned i;
 
 		if (!skb)
 			break;
 
-		zcrx_user_ref_frags(ifq, skb, 0, -1U);
+		shi = skb_shinfo(skb);
+		for (i = 0; i < shi->nr_frags; i++) {
+			const skb_frag_t *frag = &shi->frags[i];
+			struct net_iov *niov = netmem_to_net_iov(frag->netmem);
+
+			/* Take niov references the skb holds */
+			io_zcrx_get_niov_uref(niov);
+		}
+		shi->nr_frags = 0;
+
 		if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
 			__kfree_skb(skb);
 		else
-- 
2.54.0


