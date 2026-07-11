Return-Path: <io-uring+bounces-13967-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id RxuHBt4dUmqcMAMAu9opvQ
	(envelope-from <io-uring+bounces-13967-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA1474142C
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:33 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AttOGcVj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13967-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13967-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4B9603014363
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8703BB13A;
	Sat, 11 Jul 2026 10:41:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338913BB11D
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:41:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766465; cv=none; b=to/aBTiAhHaIp9lXM0TANps5iRsvNqiMbdM8XP7FFYs3sMQvtAqO81yvDJ93A2+D2aBojzEQjBxxOxIGXLg57VdKxCld1HO8ArNrvH3JSlvHsQlavpnwyIC3Gtf9WlCl3f5tttB68rkeixceaeCP/I2Suvb18FvMFTket20NRIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766465; c=relaxed/simple;
	bh=V2IGT/K8yGUqp1JXHxJ3f4qnE8XDEMisHjgGH09AwF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuzGyyYOGcOzP5/aQhDsjpU6NHKf9cLBZv3S/qd8kCzx6RwW2PbEL8ZX7jr/fiUt5AkalQkGuxaxM+dFJc098LhBd+iXjuBRU/62k+NyHc5hBzZ5gvRa++6lx9SMFmAC1f4MT8TAV8DvGiHqoHP4Ics3wX0uu8BMqqqWCxt+qAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AttOGcVj; arc=none smtp.client-ip=209.85.218.41
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15f6de6cdfso243298966b.0
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766461; x=1784371261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=edaLm3WR+Fb5O6dJt/wBHgk0B8eZBQJTOHLXheg92Oc=;
        b=AttOGcVj9vTk6BecAhg866vo7lhSLf45xap+HvsWQrW+sbIfspAFjKKkt9HRiWaKWe
         nI+MdyvXZM1A2wkeH4exUe+D4ttxP47wF0025X2NfQunpiALBt+KOhafkohAoGPPXoMY
         RqosBvVqNYU2AZ4AKdzX2CN1VqsEe+Jh9LgXPJR0QsPyuvtDIZCIZ/nyqWnQBtxK59Io
         dOzNdmrJ85ww7PZkPHObByw6nnOoIkGD+9KdOExmvBjcQDfYnavq547lEsBk+0bluTuQ
         9XcS44zK3d5i1Q1SAPLHii413leJ0nAkjNxqhgHGi0hdLXlyt8MlmTUy4uSKgr3NMWmh
         vXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766461; x=1784371261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=edaLm3WR+Fb5O6dJt/wBHgk0B8eZBQJTOHLXheg92Oc=;
        b=j1n5n+rbcYnSVNDrOghaUfv9ppSpHXSidkbRsWNt8gELmXpE46Jh3Pb76/SadXcrGz
         FLTQlg3eZM1MywKxNelJ16M4hGJwq5WvPdCf/4xbmAR7Bhd7Yev/6ix/OyiHK5UU7+YX
         i9tz3wIy8a2i2zwqVzBEOvirHSLe313N9hRRyz84w+1IRVrdgAk2Jd3n0Bex3lkiFwCW
         yPiAdi6FlJc7fDaz+6Jo/+z10ol++uDa0OH0oj1Wipyrus+5EFe0qIn+OdRNAeaiCtC0
         V0IatMew+LL7sI2tdg9+kN06wwkg5rK7qfiQGM0dhJRO91EtxxefxNcL2rijjSsRw1th
         upEA==
X-Gm-Message-State: AOJu0Yz5xAqP2hfHE+43giTzj4LTaJEBfur4NYnY9V7tXxYH1zvRdDmG
	itYeZeeKW37eSLM4tXMhlcjWK6WzcSFZCJjs1CSInCaPl0Q/wfOyIZlvwqbcyA==
X-Gm-Gg: AfdE7ckOsrw66hCyskMM20iWxHPvLhSQFc2Z4wqpzJ1ymutkklm/JMFwc9rJCed8+7Z
	GTFMk9E7m/Fr3w+cXaxq+EoOFFA27XdmtJN4lJzd6icIJVCh3E3ON4swKRthZaF03CdcwAt2g+q
	o9g/cajMIkB8M2YRG5nwRgHf6GUYV1owznYSW0NFDSUnCRVCzBei946vaFcxuDymNwrqzWMi+CX
	tH742IAHKzyp1fEBzJsZEdHjaZLfRFBra13zds7KI4juMOLSAE5CBxSSlKwlodymgi948Ds1ge+
	lfmsJzGwgUkj9XwMJXTVhR2HMjzqnONlq0Edr0CCwUVSd+wtGV1CwQ+DwnNDEDpRZG02xyB4WK5
	i0E+/7nAKvYSkiyuDWWHdBtK57wRykeyzMxveXmzkaoklbSHS1qao3DXrZTMBirCQJnAKZGDs4G
	BhA3VrcOunI591NDrA6arLZMImKJgZNAHbpXATX5MURxF6rmfwmwiay/Tu9c73AC+9UP795KlUL
	PcJEiUEBGKwBBUW8grnn1sUwSH7fLeE92gcqvrOgxnr7ipmoA==
X-Received: by 2002:a17:907:bac8:b0:c15:f6b6:18f4 with SMTP id a640c23a62f3a-c161ea5e6d2mr80976066b.24.1783766461630;
        Sat, 11 Jul 2026 03:41:01 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:40:58 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 10/17] io_uring/zcrx: unmap under netdev lock
Date: Sat, 11 Jul 2026 11:40:03 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13967-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
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
X-Rspamd-Queue-Id: DDA1474142C

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


