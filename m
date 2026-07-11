Return-Path: <io-uring+bounces-13955-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 5zU2GlAMUmosLgMAu9opvQ
	(envelope-from <io-uring+bounces-13955-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:26:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C39067410D6
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:26:39 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TzoUuPBu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13955-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13955-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FABB3053891
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF793388E4D;
	Sat, 11 Jul 2026 09:23:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D387238734E
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:23:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761790; cv=none; b=myquRHAdNx/RSHrVjcyleWpDsyngA0YQrxExf8mcnz9wjigzTPQXunVNi841lErcztjaQswjTHsDRS5oWyBoOTEai++2wpKBFoArNsbj74rGamB7lc+G51xYEWnQc8vQaqcj/9zU1F7jpr0GtjlWPFydYM/Y6uEwB79/nx8lwkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761790; c=relaxed/simple;
	bh=TD0DvdzuAgcOk6opvxNJfsY619z4frlhiDPT+sR+SFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlClFZMim/aiDjxzcbTuiTSV5dDIK/eNdJQCr7yoJUQGm7qblZHpi5BOUeg+6Vz01Ni5I4DZ7AhCsBCbxzUGPeQCZeDHNL09wQIU80HuYht1zBnEXRNBAB6W0HojjNg5P9gg9hjV67GLkrbC7jXeaRX7e0k6NGODbIr0bUr3SCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TzoUuPBu; arc=none smtp.client-ip=209.85.218.53
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15f360851aso243966366b.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761786; x=1784366586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gm+lTnqmWwDxeir2CXikUHR7rj6T9P4bxZUxOe+cAx0=;
        b=TzoUuPBupoFRicy0XwHTMUPznkBhf4Or+RGhsdXH/1o+iar4MAwGj2lPwFniBzNp/M
         Q92J0QKrYAucb1p1UpZ0Ot5iyKbz7rS6riZv7X2ePzueSN5EiGHtZf3PEgD1ewCZr+D/
         T/Ikt4djBfTmV9Z9qDLIw/DTL4WmJycofrIZk/1dOziqFfIYFMOqbbnc7cFM50sWH99E
         hYGphIXxUyLx8PhFsPem5o8RwSTkPClbr11zKQfsOhm4fINxKFVVCJBLHUHaMX0EdTs/
         NOU+Qt8SyoJJYHvY2AZQmvMSGm6H7kWFwZBYDY6HK1vpT2R6n4D1ejSQL+jJ2EaFEAlE
         R5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761786; x=1784366586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gm+lTnqmWwDxeir2CXikUHR7rj6T9P4bxZUxOe+cAx0=;
        b=JzG+KSi3nAzLGIgqqBloLN2cB8xAxRcU8NO7OCSvTibZXToJnvLlLDJBmxoZiLOUkg
         g+0zCC59zJp74GbOFVw7gDe4ndYCyutKJ2hRcCtpAMsFuP4C71eOwevir7PAaabAj7Je
         UzJLyeKIbNA0l6qggdXG119oGQofhNC5KCF/RQkwsJ5miv7m7jzLRG4Dm1f3OJhWYczk
         LTN6vhKW9rd0MWQZWOnt3qLhFp4YPEI6i4SOAma9FA8DU/KbojgJiJlTfBjK/p+Hxj0l
         JG4RDuBX4fOe+TxLpzliLMqMDXgnjKnX6SN6MvtKvMHc+qLJpo8gmqs/Ol+ZcxY+b1vK
         YexA==
X-Gm-Message-State: AOJu0YyvQw2DJYrGMKTwLj4hw5Pp5KFOHILnsqWXaXZvvqjDF7BQcC4u
	AWDVwm1ELmeBWHFSCmSGOC3LOVs0DSh1BNJSn6d4jxQiPktpQ/AlXxaX
X-Gm-Gg: AfdE7ckOuWa4pWHwiYjB4n8FXguhpnXfKF2c5z0K+avwzzG2JemBlmR+3W3ax9zYYdO
	CjIFgeti+bzp2oWtt9rR1wQXEyUa09xxy5z6gf5/luKC/b5IvEMWdjpmldZC4r1SwHj6ztBsRmj
	3RrpEcYjzevm8MJsUKXyOW/gSNtQFL7N8DjgkAHsPhizn8x1PSmU/iC+IOVq/el0euQY0qBYpSZ
	YuK4TbB/gStyNfphvpUBwm6FdSotd9z5/9jciqeK+d5zcNiWc4pKJ/fx0xVbUAzk6nWTGRrElsK
	CdYADHbLUD9W9qkPLNQoliqxSS5Ulr/vfUnFDwadst1zr0sDubZz+63kUplLG8mbYsMYG9Hw7G5
	7ZMuzM4+riBfmT+FMUxIQZwixas+DSjIOzrYDLQCZylMQlCR5M8MkNRaRO5Uc4ziUiI6Ksmb1eO
	tTyqQN0GqzHK+tl5yyrYwox8A4XfuRDA66zV+p5qQFwlq7Mj9XzLSnJPlB2LFQh0C45M5LxneFg
	Z6V6rTXFcCxIzaqZk0HR1GL8ofVXSNg/aJvZCiuBXikdoU=
X-Received: by 2002:a17:907:3f9c:b0:c16:26c7:6ba8 with SMTP id a640c23a62f3a-c1626c78accmr54130766b.6.1783761786090;
        Sat, 11 Jul 2026 02:23:06 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d3859f69sm517493566b.27.2026.07.11.02.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:23:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 9/9] io_uring/zcrx: add rq_lock cache of "user" niov refs
Date: Sat, 11 Jul 2026 10:22:19 +0100
Message-ID: <a866ed180eb5b7512b7fba0d4d6f431fcacee650.1783619193.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13955-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: C39067410D6

Now the "user" refs are acquired and released by NAPI/page pool for the
optimised path, cache them on the NAPI side and protect it by rq.lock.
Store it in net_iov as we'd be touching the cache line by refilling soon
anyway.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 23669471a8f0..04a80d1a2b3a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -393,9 +393,20 @@ static inline atomic_t *io_get_user_counter(struct net_iov *niov)
 
 static bool io_zcrx_put_niov_uref(struct net_iov *niov, unsigned refs)
 {
-	atomic_t *uref = io_get_user_counter(niov);
+	unsigned *cached_ref = &niov->mp_private;
+	atomic_t *uref;
 	int old;
 
+	lockdep_assert_held(&io_zcrx_iov_to_area(niov)->ifq->rq.lock);
+
+	if (likely(*cached_ref >= refs)) {
+		*cached_ref -= refs;
+		return true;
+	}
+	refs -= *cached_ref;
+	*cached_ref = 0;
+
+	uref = io_get_user_counter(niov);
 	old = atomic_read(uref);
 	do {
 		if (unlikely(old < refs))
@@ -744,6 +755,16 @@ static void io_zcrx_scrub_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *are
 {
 	int i;
 
+	scoped_guard(spinlock_bh, &ifq->rq.lock) {
+		for (i = 0; i < area->nia.num_niovs; i++) {
+			struct net_iov *niov = &area->nia.niovs[i];
+			unsigned *ref = &niov->mp_private;
+
+			atomic_add(*ref, &area->user_refs[i]);
+			*ref = 0;
+		}
+	}
+
 	/* Reclaim back all buffers given to the user space. */
 	for (i = 0; i < area->nia.num_niovs; i++) {
 		struct net_iov *niov = &area->nia.niovs[i];
@@ -1327,9 +1348,9 @@ static void zcrx_release_skbs(struct io_zcrx_ifq *ifq)
 		for (i = 0; i < shi->nr_frags; i++) {
 			const skb_frag_t *frag = &shi->frags[i];
 			struct net_iov *niov = netmem_to_net_iov(frag->netmem);
+			unsigned *ref = &niov->mp_private;
 
-			/* Take niov references the skb holds */
-			io_zcrx_get_niov_uref(niov);
+			*ref += 1;
 		}
 		shi->nr_frags = 0;
 
-- 
2.54.0


