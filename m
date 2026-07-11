Return-Path: <io-uring+bounces-13963-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 8EkQFNodUmqaMAMAu9opvQ
	(envelope-from <io-uring+bounces-13963-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3E1741420
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:29 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gptpNEyh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13963-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13963-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 90D0F3012CC7
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21027374198;
	Sat, 11 Jul 2026 10:40:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908833BB699
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:40:47 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766449; cv=none; b=aWHQkZrLGUqy7XXTJT/bocy/TxaVJAxjWujR/kDeNY55pnmha0IEq7T5Gx7jUhnI2UAKuH1Fy8BKhwuIJ7JNZkws5y4xS2qQnWhNCqV237XMA9yTzhR1v8T2x6J+TvSU3I50qvAaWeMnXGg4e2KgbS6/d+hLcEuP6xULoYiJdX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766449; c=relaxed/simple;
	bh=7ymV105ZmGGl8uhZGojt5WY8AiecF8ThAvKoxYEWg6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0alRFn1zOXUXZt+8tlqE+4F1ibpcj0BJRlxmFH4TnHW8vlOYvTsNJb7SssXMqxVVORYmX4LkGApzD/L6iXegD8cNVDj1O1s2rwlFK4kc0TaPPKhUompNus9e7O1cm1KxjJA+2qlLDGN4hxXPuw+djQAgqDSFv1mF9yZb8i1xjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gptpNEyh; arc=none smtp.client-ip=209.85.208.45
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-698aa7ba3e6so3031062a12.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766446; x=1784371246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kn8FUFZkw8BUpz/Wxz48LtuZ9xzNk4cNG4d+dWzPPVE=;
        b=gptpNEyhE+uGgbJe6OxjGk6EO3+PgRCCd08/RescpF8E2LB6Qw3iOkjoD+O08PxOHp
         mqd6iBmhSPXAPvq0noIhtLRhwiMjTBZKfNiJxxTJiANcfworgkxqCmU6Bqpt2B9pFSr8
         fUKX/foiiM2ObHICUlvcrLV3l33AgpekYOuq2pCKnRu4USl2CMNgv/BvTrkI6Of6aO5c
         nGk5o2jsuitmFzPdcO93JqhtXkZDs2Dm7ID0d7vxJW1D7W4XL9qTs57Ajn/YdGuqNEmj
         HP/m1pvPsteFUa2j9Hb7wIp/OLAyc705lyUjfNhg4HP2+KQTwLpw9U5WXiqjy7xKm2gP
         b+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766446; x=1784371246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kn8FUFZkw8BUpz/Wxz48LtuZ9xzNk4cNG4d+dWzPPVE=;
        b=X5/ykUlq3ii1R4G5lrIiIz28msYtxqv0XZJ7N++t/Xf27ql5e4v8kczfvTbI4qRE15
         ZC8lCHty7vtHmlk31BXQ3vClqJKfRGKKakHCB7ht9n4ylzgIp4YjffdhKme8K5hfPPBk
         6GrFr3jqeZorSMxR2L2WfwL11mQaQGsns5yL7iZyhdc1lL/upuWFQQ/S3dlRg5o4qO+i
         LqEpuUYIlKR9DV2NpXC2LL8TtP1Vv3JEj2/xbaV1bdPY1n5N4XLurwrsjuvCHsb8yNeX
         anbvTJ9gP8K/1EIvHPMKt0NGoh33T0mYLqiObkPJ/SoSz8Oft/+5EXqOnkSYE4awdU5I
         nWOQ==
X-Gm-Message-State: AOJu0YxCyFCCBwgA+p2rqopVxn6C8qGWMRk5xut/1GUgpSMIIQ5U5evo
	S3WppNKqfH1f1krRwwZAdcu0QZ7fv5MOrzVvAZjmtnSzmmOFBf/8gUlencglZg==
X-Gm-Gg: AfdE7cm/0lRwZ1yV2cBBq92GoD6A4ezE/iEgEoKzhKhOQhTdt5Ca0DmEUYzOVqeX5EE
	tChCD9gR/sxoGOmjSH4O5DBKtfpM5fSnCVx6IRF2PNSgt8Aaz4KYoLAdS+cNCbOCLPAWZxw+2wq
	NzfkUyQaE9YbpzryBurAIVr8AOV/jxrtFi3Y9fibVceDVdSqrMHcMS1+2/MqfucWPmjMwgWhXR+
	qmJWokL2tMpUMKpY32FdAQvWaVEXuZVSLMWUksTBBDkJ8ntfmSIBVDteXkqILztsdhrmzMVOpXP
	q7CDltmN7wJJFT324yHRs/ojtQB99XelHCKJtVKPXXoEKRWK8Dr0NWZdKP/4e0g8DmJlm6nM+eQ
	9/LdY51B3xRnIaato9xsnTmKfOJu8rZJz4zwoVQ69/5ueXQpFmxMDYDiqbLYw2KU3jlyQT2nM72
	wXbpfJ1WUZk+hpyDXKhBn1sOvpvgZ4Rxl4bJlQxAUll1Y5co287e4Ett/J4Qhc82U7dwPjiWxk9
	csaBOpRnvJ5hDJZ2PXCRKlZosRHjcjtEEykjRnIX5dRIDGPzbamI00p2Pz3
X-Received: by 2002:a17:906:2a09:b0:c12:a5fb:ff22 with SMTP id a640c23a62f3a-c161f442fcdmr64377966b.50.1783766445969;
        Sat, 11 Jul 2026 03:40:45 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:40:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 06/17] io_uring/zcrx: constify area_reg on import
Date: Sat, 11 Jul 2026 11:39:59 +0100
Message-ID: <a9f68c5d19cba8243062c5eb15afd0eefede6ade.1783616211.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13963-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4F3E1741420

io_import_area() doesn't modify its struct io_uring_zcrx_area_reg
argument, add const to enforce that, it'll make later modifications
easier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index cb73dca3c1ee..9f21ae61b862 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -136,7 +136,7 @@ static void io_release_dmabuf(struct io_zcrx_mem *mem)
 
 static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 			    struct io_zcrx_mem *mem,
-			    struct io_uring_zcrx_area_reg *area_reg)
+			    const struct io_uring_zcrx_area_reg *area_reg)
 {
 	unsigned long off = (unsigned long)area_reg->addr;
 	unsigned long len = (unsigned long)area_reg->len;
@@ -208,7 +208,7 @@ static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pag
 
 static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_zcrx_mem *mem,
-			  struct io_uring_zcrx_area_reg *area_reg)
+			  const struct io_uring_zcrx_area_reg *area_reg)
 {
 	struct page **pages;
 	int nr_pages, ret;
@@ -274,7 +274,7 @@ static void io_release_area_mem(struct io_zcrx_mem *mem)
 
 static int io_import_area(struct io_zcrx_ifq *ifq,
 			  struct io_zcrx_mem *mem,
-			  struct io_uring_zcrx_area_reg *area_reg)
+			  const struct io_uring_zcrx_area_reg *area_reg)
 {
 	int ret;
 
-- 
2.54.0


