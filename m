Return-Path: <io-uring+bounces-13939-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 5f0CLw0JUmq3LQMAu9opvQ
	(envelope-from <io-uring+bounces-13939-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:12:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9609D740FAE
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:12:45 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kng2+QtY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13939-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13939-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A7FAF3012547
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B68384CFB;
	Sat, 11 Jul 2026 09:12:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D614C3019DC
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:37 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761159; cv=none; b=h0+if8JdUiLQ0joOKqmC+rDqJtb4m0eQnpfA1xceX/c9vqlmQkbhxn+TcZxzXvFiGRoh+zAQRKcfqzMmmH1zuqzZ2TlLPBrcs6XvAsB7TbZsSzCSclAnDknbfPBMLgFyNj4mICjfHFxV7ouQRJelMHTRpOYqlfgeP791+kZkmAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761159; c=relaxed/simple;
	bh=V2IGT/K8yGUqp1JXHxJ3f4qnE8XDEMisHjgGH09AwF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBSuhsyGCo1/66uYhA3y8R+cON4yw92sb7VuShI777NlBJ2SLr06GnchcowQWW6R8oMKTzwPjdf8KnxB4JwVg9Jer+xQIa6qclObQ5dARgTenjasUVsaH2diPtLjoBlgXRVaMxB7nPh8udyOCM5WOvGrr/R49SrltQpluZAyUQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kng2+QtY; arc=none smtp.client-ip=209.85.218.53
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c12614b81c9so317516666b.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761156; x=1784365956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=edaLm3WR+Fb5O6dJt/wBHgk0B8eZBQJTOHLXheg92Oc=;
        b=Kng2+QtYuG4K3cx+pH9kAMX7Z8FU28+XqhmBdCq5m2cWllV2WH8Om4PrqsVDBlxJtr
         2WV5eUcphanHm9zC2WjWr82Cj2sC/UKECK4a5+5hP6OKhWRllofmG2kfEb2XRXyX7ho0
         9MaZ+rVHsUzbibScFpKHF6nApPzO4qOHe6I2Lz0yVuWu6uU9meKW4+6tn2hoceHuXzTc
         zfsOXuOpnBOQTaISW4jBk5x2/OYcvEvSbQvUmXH+k35VDzvJrr/czwfpP+HAASZ6XTXD
         TKvUCOpeiu/PbF1cL9uxewP+0DFOGGUdnRSIWVBe5gH+dZgSmHL+px16wou2pAJzWEUQ
         ooQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761156; x=1784365956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=edaLm3WR+Fb5O6dJt/wBHgk0B8eZBQJTOHLXheg92Oc=;
        b=czKOG08JH20CjUWkgNx7hckv0PiWHRqtkCkUIaY5jGwvd7cTryIqC4ufQxfUtYJy89
         IOkGIqHZMqEIqaexhFnDNFnxGIiukhRDTcH7xIMcAgT2xtRkryVN9AaucyfC/22FzOUU
         ucsEoKEG5DxKQQa06ozCo8Bo6gRCUPU5DRRHk5LenYHQ/YYNN/pvB85w5mMYIr1zeO3O
         Icz9uP9snwn/BrvTWmW+oqdIv50ur32R1uOYkcC+ipVfMf+2d6fpKHKeZfkKuQg6xWQ9
         g0IoRXsjbY/42roODgv98svf/Q1TBBiGvKC0o0bhUqKJRy4LaphVeF12bIEJWueQLrNx
         WcTA==
X-Gm-Message-State: AOJu0YyRPR7wv9aIDskRmjC+3TKlFMlk0+HIAgbs9vIi63xA7bp5SzZ/
	yAcjbZnnloSVQZoDfkyQ3PBj/x5UCCR+JwRbNQ2+M6/oVWtk7UGFf1o8XALzdQ==
X-Gm-Gg: AfdE7ckCyu0ylLybl0oriIv9l4H5WFc2gZTXNuVmU68gf99ZYrN0A/tEG0mj+xYGH5D
	lfGpKpbpn5J1iiozlG8hDpLKVp5ADa8Lb8O28FH8O6K6+BbtUNB1z34y2nDjcUXCwRdhsr1F4zq
	u+j3/mv6e3qWrY8OHBS+TLp/xesfH4Ora7oXHZ/JR143yeCvbaUuRjoDy+PctQVbjJ61xK7Po9Y
	MWJVkoOaCgopVhSN0quY5YvIr+qO9ZcPcoiWO3CPlVU20I8BEYEgw6WP4AQ5sz7/29u/r1mkqpc
	tmDySVBA0wN5lR68haZQ2SxrJIb2B6QtaduFuAXE2RizuB0ENnTVtWf5kkZ8h7uRYPRC/BSCTE7
	NDLBYBxIfigBnqM6JiASLM7ZPHQnDjVZZxSeZ9FjAoBPBaY/cX/B7uMLTz0MPkCdStURLBbvO/t
	rypPM017O7H1xT3g8IfGitBtOCK+AYOlRZ8mRvw7xDJIb1LeAcSBUANrDeLuRQ97lb+xKONK0Ye
	eXI13w0tsnZOvc8NvkCrXkO2mNFM1JDKjLmlcLoS+O9hMLChLTTNvxFag==
X-Received: by 2002:a17:907:1804:b0:bec:929b:cee6 with SMTP id a640c23a62f3a-c161ea0f8e4mr83871266b.20.1783761156188;
        Sat, 11 Jul 2026 02:12:36 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:34 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 10/17] io_uring/zcrx: unmap under netdev lock
Date: Sat, 11 Jul 2026 10:11:33 +0100
Message-ID: <cf52185c92e3099d805d9a0e9b1af13b30776aa1.1783616211.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13939-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9609D740FAE

Make sure we unmap areas while closing a queue.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 86e8046e98c4..4936d92f6339 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -311,6 +311,9 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 {
 	int i;
 
+	if (!area)
+		return;
+
 	guard(mutex)(&ifq->pp_lock);
 	if (!area->is_mapped)
 		return;
@@ -438,7 +441,8 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
 			      struct io_zcrx_area *area)
 {
-	io_zcrx_unmap_area(ifq, area);
+	if (WARN_ON_ONCE(area->is_mapped))
+		return;
 	io_release_area_mem(&area->mem);
 
 	if (area->mem.account_pages)
@@ -545,8 +549,10 @@ static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (!ret)
 		return 0;
 err:
-	if (area)
+	if (area) {
+		io_zcrx_unmap_area(ifq, area);
 		io_zcrx_free_area(ifq, area);
+	}
 	return ret;
 }
 
@@ -600,11 +606,12 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 	}
 
 	if (netdev) {
-		if (ifq->if_rxq != -1) {
-			netdev_lock(netdev);
+		netdev_lock(netdev);
+		if (ifq->if_rxq != -1)
 			netif_mp_close_rxq(netdev, ifq->if_rxq, &p);
-			netdev_unlock(netdev);
-		}
+
+		io_zcrx_unmap_area(ifq, ifq->area);
+		netdev_unlock(netdev);
 		netdev_put(netdev, &netdev_tracker);
 	}
 	ifq->if_rxq = -1;
@@ -1389,8 +1396,7 @@ static void io_pp_uninstall(void *mp_priv, struct netdev_rx_queue *rxq)
 	struct io_zcrx_ifq *ifq = mp_priv;
 
 	io_zcrx_drop_netdev(ifq);
-	if (ifq->area)
-		io_zcrx_unmap_area(ifq, ifq->area);
+	io_zcrx_unmap_area(ifq, ifq->area);
 
 	p->mp_ops = NULL;
 	p->mp_priv = NULL;
-- 
2.54.0


