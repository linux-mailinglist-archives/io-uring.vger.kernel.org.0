Return-Path: <io-uring+bounces-13945-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id XLqtE4wKUmroLQMAu9opvQ
	(envelope-from <io-uring+bounces-13945-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:19:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B25741039
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:19:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JO1kwogK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13945-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13945-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A53F308461F
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76FD43859F7;
	Sat, 11 Jul 2026 09:12:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04436384CCA
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:56 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761178; cv=none; b=L1Zfbtw8KIoYoIJnRAlqc9O3Qhv4/5xF8yeWWQUbnlk8ajYAbu/HtwDh+XXA2Me71p44mhB7yulxKFRV+Uc78V1Loysu32Psi14TTgwuzJ3zqam6xHdzqJCkwaBfneECmbIPOfivTleu5PSp3RmF3Y1SBAdQAI2BqawSkEPBNQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761178; c=relaxed/simple;
	bh=3C5ZHtmURh7dwurigU+mzj8rTDm7QKCNJ6nCU+yuRWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVAu4nAAFEVSvCl/R5eKzIRR1PmkKi55ja5HyrBF0oTcBzTLunKP3KtmUr5CaEbnoCKi2H+Y8jF036dqm9jimPZxJcPue9GCDyvZL+fNln1iuDRy3Xu3qoq8wU9N3yd2w7aLfHnahXxxvRMUjIrc/7w2xfNszKBbOcZKDvuXVPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JO1kwogK; arc=none smtp.client-ip=209.85.218.43
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15b33f7b23so231126766b.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761175; x=1784365975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YzxgLXuoC3y9XYCE+1b8RBAVVFev+ejEK09g/vo1UEs=;
        b=JO1kwogKRafSX0F121xcUzaKzMp7HJcn3wj1X9HtzjTdR2e++X4krz9dzfN/osaeYI
         gw9mQTy6d+gImmgNgqBnCJmjDfaYo2BHnlKqvpziUupeQtvk39JdVBmuv2aquXsI126h
         j//+xYVOy649sYDLN5OETE+q4tUweN3JkaOhR1NTN5AHAAZJ3ZmNJorQxXVzpLXRq/nB
         OkvSxvKXdOqyNyZWHNIE9duHItpv9n++o82Uat97YCfkQ8NGez7mpvjcZPKn0ab6TWgF
         pU0evEN17N66Hf60jysolQ6HwYHm13s0hTvGYeuj3YXO8eLeeRa7bv4qCj7YCn9zIB2T
         vp4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761175; x=1784365975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YzxgLXuoC3y9XYCE+1b8RBAVVFev+ejEK09g/vo1UEs=;
        b=XZbJfzWdSLeUqZPjCL35L59UHe2w9PGEuv1dzS72DY2Wh/eQ5UcxmmBRWegeRxs5OU
         SDaTwvYI7blNTC7VZOuDg6kQ3TcTrzbvMFwqAVGrZbmyN8A+IP8yQ5AYK0Fl31WMBp1k
         L2ZfGzlrpRAuHGApF1QVx3yXSwjq7g/XVZiN+PW01NdmDNHR7g3x8Zy9TDJpecNP+NJ9
         nfvj+oHJ8ixKcbBKvxlOnh7iVb9DR/x5Z6Mqx16BP/j0zY3SDkRBmEsdVy62gWgLhbsL
         C5JzQBF/0MJ9KhjM5tqtby+GChyCv721SLwB062drJfRgu1yQUFYerC5QRnmxBDMe25F
         ScTw==
X-Gm-Message-State: AOJu0YyKhMT2Gw930DvkTiz+kD/IANVBX/oY4tFx8U1Te+yvjwsAB5v4
	qnELiPquM394Z44c0n/viEaVs7gNhW/mbeZPqtHTYg6AQ9CXGZnrJoGQortW3g==
X-Gm-Gg: AfdE7claXIFpXPTrkyY0B9lv89siVXdHpvNqRwjZEGyOLCwIOJSvMkrnfx0yYA/+AD/
	yinxH8CgvoBRg9/DFdYnrwNZut/hCUjc2LPX1uFF6ABtEL9WH4qWLmmI26cl2DOa7M+b7uzQcH0
	lCiDMCpHX1bP+1hQkwJZirY1XJ/ktDbRzBBT2N2/Zm9+B2U3ErffG/FWENSMtmeO+6IUo5MkAGJ
	/MMS+63oafDkJebFMdjiaT7xgb/Vc6W5xz+eAf7Irqig2oY/b3bmEtohL7YL52xmJms35DWiBsi
	HNGee96e1Wo6VZIZfm7QVvdXJGSG4GBCNrT4LmTkJ1+5OhHQXPvL1PRM8/XFWX8nG2O5hgS7IN8
	i6WgqX8O2JgsonJbBAzF8cftI7Y33U855rhhmE3cHs4H5NKfPM1D00y8WgBd0aTey1hwQMDF9D5
	9zHyFssKNM73wjrn4rcjOjknB+AIETLNVG0r5u4xaK/lPKApsZv26wRnQujDWs33Jl8zM5NOlD4
	wO72DEomU+02cvekRcPbbU2oJC5TzvEgYKEBc8xNoAki30=
X-Received: by 2002:a17:907:3f05:b0:c15:cfd7:fdcf with SMTP id a640c23a62f3a-c161e9d8a53mr73323066b.29.1783761175341;
        Sat, 11 Jul 2026 02:12:55 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 16/17] io_urint/zcrx: narrow var scope in io_zcrx_recv_skb()
Date: Sat, 11 Jul 2026 10:11:39 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13945-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 87B25741039

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


