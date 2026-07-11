Return-Path: <io-uring+bounces-13962-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ahT1DuYdUmqdMAMAu9opvQ
	(envelope-from <io-uring+bounces-13962-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 176D1741431
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:41 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dk76b49m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13962-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13962-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 58117303F700
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D79F285CB4;
	Sat, 11 Jul 2026 10:40:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E6D3BB9ED
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:40:44 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766446; cv=none; b=tMNglytMlHpvlOD21jUOjkpmHHO66xA+H4ia3iBgh02pJI1du0fMiBlKR/k2xpJR43uGVD5vcsTtPlPA19PiUFy07DoRoI3y+v5aL4KBek6WG1ab2Tt7w7Hw48tOjQDM5PY9BdTLvuMdRQy1sK6ElUirTcjln1evTeGtydYHfnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766446; c=relaxed/simple;
	bh=vXLXGlirW74iLjcp76e+jYwoFmdKKciWzpMx5TOLBD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lL6LRHhz5JYCdAd3hL8hYaepIHMtLKusWVGOrYFOuX/7foQ6CrFn/RjKBD/pbBfgCBFh37tNqZhMAGr5Chr0/vAIu6ThGKZHGKZrniB45pbQx4RR8ar6rpFZWJ8kXbY79SEuW+ce+1P3ZQveV1AQ0aSQCoFmcaPZlA6FNmCZ/4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dk76b49m; arc=none smtp.client-ip=209.85.208.50
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-697cee2eb6dso1747530a12.0
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766443; x=1784371243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JRXQoFwCCrM5mcf0PRKuJdMsq0ptHmdatjnuBeJf1+Q=;
        b=Dk76b49mhG2iga3Jl2URxqXdJWoPxasK8KME7MLv8WtCL3eWTMIhUIOJsuolaOlV7e
         K6TKA5Y6KGvY/Y08+PxkJWcZwbGscpYY5MPj+HfJg0GztvXgB1NjkXXtlc7Us8u+hcHb
         rG0XkyNiXg9qIL+BVwRG8ZfYej4XZBiKi9kTYcpfvUk8+Ms9cTt52VeqS/1AB2gVe4tu
         yO7yAxeLaAMJ92+DmWzRAKF90vAKMqEQq3krGbUSokC3YDVqSwHUQXaWrbQFgTNW6EBG
         /vHdoUPrcWHXfKtfPfJXRFvvvhRj1oKLIJQ0kKamIS3J+ZTKH16YYl/hbuGdbfI/FMaV
         J3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766443; x=1784371243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JRXQoFwCCrM5mcf0PRKuJdMsq0ptHmdatjnuBeJf1+Q=;
        b=oz7XHuwbqigmKs/o2IsQmtFVw/NNqX5puEsqclr8X+Kl78D2Jqql8pOVmr1uN1lE4k
         wfrsYETOcWfEIvjFWHsEPa17n+t8KVfo8zlgtTQbrNoUQIgYDObi2E2K1WTzzAiNIXIc
         iBCI/1FOKYwvusFR2nRfwINikvdhepGqZynzEnChfL86MQa/EZPnnZZh/CFs1nxz4BLI
         hOS4g0jhDZCgyC9pVYArtKqrnbyjGqvtgyXjP/VFgtEFjGhC/zjZBak2o5uMCas/8mPL
         QQzQQBw8SggYEgRCvtavCMYUOUiU0+r1cWXiS07/IofcCaxQAlQAM99Yga+Gyp61S4cn
         U9KQ==
X-Gm-Message-State: AOJu0Yz+ERTbkyB2OLSpNfKuzVwCl3TDky2GA5lvjdFrI3zd6snkvzII
	4ZFYgPPSfYcXAPg8RbnzSiwdpIA3rROIvHqg8lkB/GY9b1Kz/CqmP04I2heYjw==
X-Gm-Gg: AfdE7cmGe0Zo6drM+U9o2wcp3evRn1mtaIkqlY6P5eTDapwZwXPn4dks7BgpfqR/zNw
	x136nIQ6mLNPb/0CGVLS0UslhuPxojfVsMWTCt4ISckzO7U8cqxxvkNshP+Qw+GnEHNhGtJhV35
	tMYG8pLtlgGs2IR3i0DC727VinQRl1v8DIGwW6PHceLQ7/MEVVQVE9eF+3wPPzTwTnfvcobgxOy
	QRapr6BLEd2ZGnaaf7+oWiGKLVVhQ9WrGf6yNnrLBo2PIC/38HEnv2aag2Z8zIi1TiyfkjazW/+
	PHV4uByqwyq5uOkU0dNqyUbTwelGSgRoMQmyUw8WFwg7JotCbSaXLRENkaqwFJDD/MdlWfn/FYd
	ip6u3UFzzzdlIf6CJUyA4xtHA2KgqAi4txfIhnQn4PpLDpYK2YNfQhHQmtdceV7iRxL46c9euIV
	b3o5S/+XnNlLlpxr9AiGMZxv5imjOSn3o2dukWQsXD4xtWC8hXXhbIHK4bFntmft1Xu9NshxZFa
	FxU4ODCe8m+5BvZ4OFIE2jAWPnP9lYyDNby75K3O1I1WbVIUQ==
X-Received: by 2002:a17:906:f591:b0:c12:5d9b:6956 with SMTP id a640c23a62f3a-c161e530d9amr74677366b.9.1783766442893;
        Sat, 11 Jul 2026 03:40:42 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:40:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 05/17] io_uring/zcrx: coalesce same-niov RQEs on refill
Date: Sat, 11 Jul 2026 11:39:58 +0100
Message-ID: <267af1e26c3b17fd9fa9b56e4b2316d7412546db.1783616211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783616211.git.asml.silence@gmail.com>
References: <cover.1783616211.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13962-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:netdev@vger.kernel.org,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 176D1741431

With large rx piages I often see >10 sequential RQEs referring to the
same niov. Instead of putting them one by one, count such RQEs during
parsing and batch refcounting for the niov.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 56 +++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 1b8d748b35e7..cb73dca3c1ee 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -359,16 +359,16 @@ static inline atomic_t *io_get_user_counter(struct net_iov *niov)
 	return &area->user_refs[net_iov_idx(niov)];
 }
 
-static bool io_zcrx_put_niov_uref(struct net_iov *niov)
+static bool io_zcrx_put_niov_uref(struct net_iov *niov, unsigned refs)
 {
 	atomic_t *uref = io_get_user_counter(niov);
 	int old;
 
 	old = atomic_read(uref);
 	do {
-		if (unlikely(old == 0))
+		if (unlikely(old < refs))
 			return false;
-	} while (!atomic_try_cmpxchg(uref, &old, old - 1));
+	} while (!atomic_try_cmpxchg(uref, &old, old - refs));
 
 	return true;
 }
@@ -1163,6 +1163,22 @@ static inline bool io_parse_rqe(struct io_uring_zcrx_rqe *rqe,
 	return true;
 }
 
+static bool zcrx_put_refill_niov(struct net_iov *niov, struct page_pool *pp,
+				 unsigned refs)
+{
+	netmem_ref netmem = net_iov_to_netmem(niov);
+
+	if (!io_zcrx_put_niov_uref(niov, refs))
+		return false;
+	if (page_pool_unref_netmem(netmem, refs) != 0)
+		return false;
+	if (unlikely(niov->desc.pp != pp)) {
+		io_zcrx_return_niov(niov);
+		return false;
+	}
+	return true;
+}
+
 static unsigned io_zcrx_ring_refill(struct page_pool *pp,
 				    struct io_zcrx_ifq *ifq,
 				    netmem_ref *netmems, unsigned to_alloc)
@@ -1170,34 +1186,34 @@ static unsigned io_zcrx_ring_refill(struct page_pool *pp,
 	struct zcrx_rq *rq = &ifq->rq;
 	struct io_uring_zcrx_rqe *rqe;
 	struct zcrx_rq_iter it;
+	struct net_iov *niov = NULL;
+	unsigned niov_refs = 0;
 	unsigned allocated = 0;
 
 	guard(spinlock_bh)(&rq->lock);
 
 	zcrx_rq_iter_init(&it, rq);
 
-	while (zcrx_rq_iter_next(&it, rq, &rqe)) {
-		struct net_iov *niov;
-		netmem_ref netmem;
+	while (allocated < to_alloc - 1 && zcrx_rq_iter_next(&it, rq, &rqe)) {
+		struct net_iov *next_niov;
 
-		if (!io_parse_rqe(rqe, ifq, &niov))
-			continue;
-		if (!io_zcrx_put_niov_uref(niov))
+		if (!io_parse_rqe(rqe, ifq, &next_niov))
 			continue;
-
-		netmem = net_iov_to_netmem(niov);
-		if (!page_pool_unref_and_test(netmem))
-			continue;
-
-		if (unlikely(niov->desc.pp != pp)) {
-			io_zcrx_return_niov(niov);
+		if (niov == next_niov) {
+			niov_refs++;
 			continue;
 		}
+		if (niov && zcrx_put_refill_niov(niov, pp, niov_refs)) {
+			netmems[allocated] = net_iov_to_netmem(niov);
+			allocated++;
+		}
+		niov = next_niov;
+		niov_refs = 1;
+	}
 
-		netmems[allocated] = netmem;
+	if (niov && zcrx_put_refill_niov(niov, pp, niov_refs)) {
+		netmems[allocated] = net_iov_to_netmem(niov);
 		allocated++;
-		if (allocated >= to_alloc)
-			break;
 	}
 
 	smp_store_release(&rq->ring->head, rq->cached_head);
@@ -1401,7 +1417,7 @@ static void zcrx_return_buffers(netmem_ref *netmems, unsigned nr)
 		netmem_ref netmem = netmems[i];
 		struct net_iov *niov = netmem_to_net_iov(netmem);
 
-		if (!io_zcrx_put_niov_uref(niov))
+		if (!io_zcrx_put_niov_uref(niov, 1))
 			continue;
 		if (!page_pool_unref_and_test(netmem))
 			continue;
-- 
2.54.0


