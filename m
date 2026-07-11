Return-Path: <io-uring+bounces-13960-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Hv0FHc0dUmqTMAMAu9opvQ
	(envelope-from <io-uring+bounces-13960-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E05EE74140B
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ghIg4nZR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13960-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13960-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 52E7A30298BD
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBA33BB11D;
	Sat, 11 Jul 2026 10:40:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F4A3BBA0F
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:40:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766440; cv=none; b=RaX7KDEIgQSVWvpAPZl84usu4x0MtSrnY5wd6p3eiAUhRzHve2Xw4ArktfX2TlIXhf+qdTYuB2d5Q6yGZH1sVPPz5MJX7fDdusxuUpTgT1jwI4GOTrBbQl2SLKoONxkuRwxqsRLctceaOlS04dAb8QXQF+zCthy43I3xnlYox9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766440; c=relaxed/simple;
	bh=E6cOOOK8JRaX4aDVdN1M0+1MtzS0eNCG8VJsAdIuLwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8/OTKRnaXAsSHkSgdZkBZMSsDesQd3x9gliZ29dboL9X4JMqpYu6FTN0HqJAgAwaM7hDytKY/Aa5aXpjqSRe3LeltJ6Zr+LEN/cVSJpIeykX4WH0kK5bJaQgs0pdj/DirtasidBURZy55JQbVjM64j2aTyR/eQQZRiFLzrVRg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ghIg4nZR; arc=none smtp.client-ip=209.85.218.52
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso213362466b.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766437; x=1784371237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dvOpz0r7ZGyorI3Hc7NN1bB6/9+WhAP8KvikiSMDSlo=;
        b=ghIg4nZRSWfB3jpks7gT83/0l/RxVwSxmKgfxiCZYYLw46eGpI2jHcaU6vNj19s0Or
         mSjLfJMtFTYh1K45TajB0uwoY7KstWyZd8rtYapWiIdCPMTGUL8ptP24WCS4u/i6Lk7m
         +lso9rw7fUdp86lOudMl6hUeVAyqHur9NOWsGvjnVJxH2cnWNCstDcWEdJoBXtTIqCDp
         nDwS9KOJkJx+aQMlYRJ5Uu+nJprf0HVA8Dro0vR6a4frPsFJHjTr6K4vsCzaa9SJHOCN
         lbcg+eRZN40L4b19HYTPSfezILC3IsXn7uBT+ZfUZF3kGtSs+JvgqDA4HSsJxSlwG5LB
         kYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766437; x=1784371237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dvOpz0r7ZGyorI3Hc7NN1bB6/9+WhAP8KvikiSMDSlo=;
        b=lOPt4sIz4tZlVLXf8ervGKnErlQ+Bh/E4bv7TAyrfNQ5B75gPSUiA1y1Ow153MqVbT
         e2HB7/rB8/Ng2wO4rivoiUESPA7lCZO52Zsr4y53XhLzhltXugpBKGnBO/ce1ZDqAcHh
         hNj8J4w5upLipmTG5NfRkB0SugXlO/Ir951oZZhRiS8VDvE5+ZyHr3ykawi0WHY1U1gJ
         ETQGQqbaTcsSehOgQ9scrd9Pbfl0YCEXH7vGCw4LUfMA+4g713hh6NrzelWvAgoLVC3H
         3vxlykAcVtOlLJln0OBuFPBrvDjmZ8qvTU3vI4j9cqKroP7YdT13P6Xn5kjEqdS5gbLr
         y21Q==
X-Gm-Message-State: AOJu0Yw6qJ0wBCxqNtaKSkZAnXIVi/nvnouo9Y0sQbqsbHvJBVKJibpq
	jtEeBZ3vaZ54UEe0fa+I6zQgtvSlt1hVro5U5XmiIdYIlS1a3tU7fd5ZSPKJhw==
X-Gm-Gg: AfdE7cm2PckxN7a4cIhvMDKpHn1alHpIvZOBDgeMIvdsRB4zIArjCCOP1Emzyx0XnJg
	w+tKl3ER1zrTXNgYi2I2VlrqEn2H336UY+45BT+ORFNO6sRBf4yHJyArhjRxgxspkCnq0yx+QEB
	7/IjXd8vXgWdrOOh6mjNZMBdyoKhFBmGBZ8VOMbJnOlztxGt1VRJE3l1+sf33a0VRS0PuxhFfl9
	+JIzyGGCv3/JS1LkKtv5bKfnaRrkZN21s7uafx1U7/LVMRYL49Xq0d0DspxFoDMNIk4I2yA7bNx
	7y/DEMGdo/UyvDzzkc3fO/2XXwqZvcI1Cgs4EI+7cZ2JGaUL8SEQyyrH2ujTDFBZ7VvxKVh5IWM
	uGM77j6jCsTlf7ZjwjGku36m2hEZcbuXXzZ3GVdyc1QHe1AKtFk6Xs3CFRyAZFfcsMXFjpMs0/G
	TzklRJk8h0djib/63L74traz45kyQg4yUIg1x6A8zdF3v/ig6Ybb/jLtLgEh7eE1X0Iop+53aSt
	2Q2qgZYK2tKtBhF2/2fmiVzBq+J5k5xiQLAJwWlNR2UhtNNdA==
X-Received: by 2002:a17:907:9604:b0:c12:34ed:e108 with SMTP id a640c23a62f3a-c161f37e257mr76942666b.58.1783766437237;
        Sat, 11 Jul 2026 03:40:37 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:40:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 03/17] io_uring/zcrx: add RQ iterator
Date: Sat, 11 Jul 2026 11:39:56 +0100
Message-ID: <ee60806a753b75c2cbc6edaf8d0cb468e7b9d0cf.1783616211.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13960-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: E05EE74140B

Add a iterator structure and helper functions for the refill queue
processing to avoid polluting io_zcrx_ring_refill() with extra state
and logic once it's extended in following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index c4a9a663eba4..45b178afbbc3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1088,6 +1088,10 @@ void io_unregister_zcrx(struct io_ring_ctx *ctx)
 	xa_destroy(&ctx->zcrx_ctxs);
 }
 
+struct zcrx_rq_iter {
+	int rqes_left;
+};
+
 static inline u32 zcrx_rq_entries(struct zcrx_rq *rq)
 {
 	u32 entries;
@@ -1103,6 +1107,24 @@ static struct io_uring_zcrx_rqe *zcrx_next_rqe(struct zcrx_rq *rq, unsigned mask
 	return &rq->rqes[idx];
 }
 
+static inline void zcrx_rq_iter_init(struct zcrx_rq_iter *it,
+				     struct zcrx_rq *rq)
+{
+	it->rqes_left = min_t(unsigned, zcrx_rq_entries(rq), ZCRX_REFILL_CAP);
+}
+
+static inline bool zcrx_rq_iter_next(struct zcrx_rq_iter *it,
+				     struct zcrx_rq *rq,
+				     struct io_uring_zcrx_rqe **rqe)
+{
+	it->rqes_left--;
+	if (unlikely(it->rqes_left < 0))
+		return false;
+
+	*rqe = zcrx_next_rqe(rq, rq->nr_entries - 1);
+	return true;
+}
+
 static inline bool io_parse_rqe(struct io_uring_zcrx_rqe *rqe,
 				struct io_zcrx_ifq *ifq,
 				struct net_iov **ret_niov)
@@ -1131,17 +1153,15 @@ static unsigned io_zcrx_ring_refill(struct page_pool *pp,
 				    netmem_ref *netmems, unsigned to_alloc)
 {
 	struct zcrx_rq *rq = &ifq->rq;
-	unsigned int mask = rq->nr_entries - 1;
-	unsigned int rqes_left;
+	struct io_uring_zcrx_rqe *rqe;
+	struct zcrx_rq_iter it;
 	unsigned allocated = 0;
 
 	guard(spinlock_bh)(&rq->lock);
 
-	rqes_left = zcrx_rq_entries(rq);
-	rqes_left = min_t(unsigned, rqes_left, ZCRX_REFILL_CAP);
+	zcrx_rq_iter_init(&it, rq);
 
-	for (; rqes_left; rqes_left--) {
-		struct io_uring_zcrx_rqe *rqe = zcrx_next_rqe(rq, mask);
+	while (zcrx_rq_iter_next(&it, rq, &rqe)) {
 		struct net_iov *niov;
 		netmem_ref netmem;
 
-- 
2.54.0


