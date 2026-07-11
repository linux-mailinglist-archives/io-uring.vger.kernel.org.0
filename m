Return-Path: <io-uring+bounces-13973-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id jF9hJm0eUmq2MAMAu9opvQ
	(envelope-from <io-uring+bounces-13973-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:43:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B53741474
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:43:57 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H0nbvqu+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13973-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13973-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9EE593068117
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96986397329;
	Sat, 11 Jul 2026 10:41:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BB23BB9FC
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:41:21 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766483; cv=none; b=TyeU8Z4BldvXmnBYvRoponBA340kJJkPMr5d5MIEgGNhh4v/EEE3FbgdYi7nLVWcptn+I/9kiXksumCYzD78nLYsiyM+xs0Yd62DuEslyi5HhfDBW/CJyTrKXGLdUGeAv0jEVeRQjwOWQfotXyDT/jzn5P//QTl1JrgYMKLZQHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766483; c=relaxed/simple;
	bh=3C5ZHtmURh7dwurigU+mzj8rTDm7QKCNJ6nCU+yuRWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAFqGt/T98rhC5gW394J6RdEzuwQDLy3Q1SLl+YHIIy6SfzPYmPoFXp75iXL5AbPmDIA35Su1/x9J0fnvQpjVCIOFNFEsZ2ibX3AFuMf4qWyoz6gezEnFFDTCZBnVn6z4MV6E8vPe1dmqyUHGWN6mPFJxC/Q31eUGxLMmYrL1fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H0nbvqu+; arc=none smtp.client-ip=209.85.218.41
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15cd3fd760so207987566b.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766480; x=1784371280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YzxgLXuoC3y9XYCE+1b8RBAVVFev+ejEK09g/vo1UEs=;
        b=H0nbvqu+fPC8w5bfHmfEl/v5wPLcbO8aITWDR2aLRh6TY2UIvEcJFID5mF7Lqma4uo
         JkMHZWwfu0so+xZnuLyNRJ7bADe+/PhyvEF2NIK3lVgXy5WG0MB/k7CE6ZwgbQpA8CLI
         dE6VDu7vQg9ekIHAr7nwqftgRIMlKUWlB37mA06M1NVQVVehGjaDYE+I0cjW8wcIr12j
         aK6GrVAnANAdR1+5zrnRD2fY/6OPd29QZ2Xa9Rs6QAfln7EAz0CQp0NrsKCXsgXbhdHj
         2U26h+Nc+eglkxfr7vp/M1it2Iu/qs3Ynehaf2FUa8ZKjPwIY+GVZdNkcXAk14sJwJyE
         RJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766480; x=1784371280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YzxgLXuoC3y9XYCE+1b8RBAVVFev+ejEK09g/vo1UEs=;
        b=X3Gq7GoqYddeuh1acUTpZnmsXvEY9T2UI84VJLiv3XTcYdjIpt0AYBu76lr9cDyMPG
         wWGvGNonmkJQ4mQ0LLB9Zb4CkEWWBeZpyTYrfkrrIPpD/Z0bLrp80ssaHsicHtS+WEQT
         uYNcddqHJULNROHXf0ZvYNZwZnElAExFRiaz/dThIzbnpSjJRHUxaVuTa3pZ2dsvy6IT
         tja/FcvdBZwGtOLmfyflZc1kB6kdpYFocNO8MST3eXYZT4XIO28hbnqQDx+B8yg5fHJM
         8wLkqoaQh5qhCWYyM1xD1/9hADalTQ3qcFv24yGnJZERGzdSecBNZAZA6CjNFPg6Ymel
         svoQ==
X-Gm-Message-State: AOJu0YzS4dyAzaLYqTkkXb1AW9u8aNPuqMTFqSfXvewI+P+boaym41YL
	q5NRgfsEmgcyGqjJrlOtqIzvNugx0JGYhWPA0WPGovMLEFlMwNMi6b4sgtLcug==
X-Gm-Gg: AfdE7clfW88q9mKxIWPYb/ET2ARb5AI4rm1K5zQnFpn13lp5tuVOMXSJToQ3ZK+eDsL
	xOmx1tot8Xm6CCcHQJ7j74+RvSgCua62elJKgu1wOIYeer5myMGUyl8h3EPZ3JYgzYEQcfdA3xH
	47o6wVuaSYICIgCARfUTWK/N17nAKY0gdZvWkPGlzGgfoA1pWi6/MlaEEsaGXprYAocVbmCbjhU
	kocr4fxo8TA9A+ezVeENAJ2ApH54kcJQtuNhssLNCwlUMIfHLfvaUJLjcKFnOIvfm/QpalAfqUH
	QaSUpAxgkyrHDRYc8ZUTIETUxpnc8MiyEME5LzyFooexxAi0oQuHlhfbBvAt3cOU3D0l1meb5mN
	Y4nUayRfzRNBVw90rYivlBeAb8lQ3shg5yOVL6w3A7EQJLAj+05YSOSxYrSbXo2/JbKlDwx9MFR
	9MZSiZLZ/MfJAOJ8tX/xAbrZ4KaV0u//uGNoa3qRBAHNloeZzGZbwYnrb1phKwghEHZrzhZjp2l
	MmIiGodOecB7UBEEjlQQ3GI1L9Z8AvS6c9AW0zKYwLkIuFt+78t+5uMMfWM
X-Received: by 2002:a17:907:6e89:b0:c11:ff2c:4f33 with SMTP id a640c23a62f3a-c161f3886bdmr89040966b.45.1783766480430;
        Sat, 11 Jul 2026 03:41:20 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:41:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 16/17] io_urint/zcrx: narrow var scope in io_zcrx_recv_skb()
Date: Sat, 11 Jul 2026 11:40:09 +0100
Message-ID: <87e57608b1525ebcf4cb1cf29b00ca76ba3b982b.1783616211.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13973-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 12B53741474

A preparation patch that limits scopes of a couple variables in
io_zcrx_recv_skb() and rename them, it makes it easier to reason about
the code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f7592a3c058d..74046a09911a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1836,8 +1836,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct io_kiocb *req = args->req;
 	struct sk_buff *frag_iter;
 	unsigned start, start_off = offset;
-	int i, copy, end, off;
-	int ret = 0;
+	int i, ret = 0;
 
 	len = min_t(size_t, len, desc->count);
 	/*
@@ -1875,20 +1874,19 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		const skb_frag_t *frag;
+		unsigned frag_end;
 
 		if (WARN_ON(start > offset + len))
 			return -EFAULT;
 
 		frag = &skb_shinfo(skb)->frags[i];
-		end = start + skb_frag_size(frag);
+		frag_end = start + skb_frag_size(frag);
 
-		if (offset < end) {
-			copy = end - offset;
-			if (copy > len)
-				copy = len;
+		if (offset < frag_end) {
+			unsigned copy = min(frag_end - offset, len);
+			unsigned frag_off = offset - start;
 
-			off = offset - start;
-			ret = io_zcrx_recv_frag(req, ifq, frag, off, copy);
+			ret = io_zcrx_recv_frag(req, ifq, frag, frag_off, copy);
 			if (ret < 0)
 				goto out;
 
@@ -1897,24 +1895,23 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 			if (len == 0 || ret != copy)
 				goto out;
 		}
-		start = end;
+		start = frag_end;
 	}
 
 	skb_walk_frags(skb, frag_iter) {
+		unsigned frag_end;
+
 		if (WARN_ON(start > offset + len))
 			return -EFAULT;
 
-		end = start + frag_iter->len;
-		if (offset < end) {
+		frag_end = start + frag_iter->len;
+		if (offset < frag_end) {
+			unsigned copy = min(frag_end - offset, len);
+			unsigned frag_off = offset - start;
 			size_t count;
 
-			copy = end - offset;
-			if (copy > len)
-				copy = len;
-
-			off = offset - start;
 			count = desc->count;
-			ret = io_zcrx_recv_skb(desc, frag_iter, off, copy);
+			ret = io_zcrx_recv_skb(desc, frag_iter, frag_off, copy);
 			desc->count = count;
 			if (ret < 0)
 				goto out;
@@ -1924,7 +1921,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 			if (len == 0 || ret != copy)
 				goto out;
 		}
-		start = end;
+		start = frag_end;
 	}
 
 out:
-- 
2.54.0


