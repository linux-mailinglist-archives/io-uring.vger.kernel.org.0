Return-Path: <io-uring+bounces-13958-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id q9eoIq0dUmqMMAMAu9opvQ
	(envelope-from <io-uring+bounces-13958-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:40:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0287413FB
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:40:45 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PtlkbAzA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13958-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13958-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CC4543011A5E
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB6B3BB68F;
	Sat, 11 Jul 2026 10:40:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF083BADB5
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:40:33 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766436; cv=none; b=LGJeRTOCzXlqUw3KzXo4LVO/PFmftfWSEQSCCKV2QsvVVy7tNMRkvOxM9gCzBVJuR0m2aF6o2/a3CcJ4bXm3hexuUq0v/jTHsKHDUoxG8gl6GvyoYSHvol9KJAohbH9gpdczTVklbGWYSqMZpzpJx3+e5JAT8BUWcsKhY4pSxzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766436; c=relaxed/simple;
	bh=O9J/2l2LcB+jyMFa6SaQuqJkPyhfu3duBPFRLNJ2SpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUhpqJnlvbJcWEVlUDCAJ5LoQQOJn3UZowQ6w9XNlTxNIEXuWq62a/uH6eAvw/2t33DnpYeZWyV4oxLFQmrV/12ArcFtFfqMvlZjbQisvIlsek4RYew1iYs52Urd+7PzdMrKuxR3xfB4wJLSa2YYnvB93oyuhXquCB3QRaceF4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PtlkbAzA; arc=none smtp.client-ip=209.85.208.46
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6976b0c5adbso3472611a12.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766431; x=1784371231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nlpMAjb/Om74qf+FFxwyoZxa1Yqnmh7GeyI4L+jcCaY=;
        b=PtlkbAzAyAFtNdMm33NPgBxL53l3UdRDA9D/htJGaSTZCgi5S75v7OgtiZhzvqNCwB
         CkTcboiP1m9J/oZVlmHmS2fgHSSpljP4LGX1Rs6dKVhkD05rF//Qwcujhwv0TtWnEytF
         UMzm1OJ2u/OB0Ex7We3mLD3PGZQm7hYUJQTWVC7zv/apB2XJT36KwOCe68d8O+EwJ0Vw
         JkSCyQPoVouFZShf5Vj30bwD6x0W/hr692275R3mo54qu5G/4R4iw5CT+xdIaTmt1FXA
         /b3cOAEZuSV6LIIMrMRRL3Xw2ZZdnWrXD2xWj6ZeI5fEeJ7VLu79lD9qKa1Ao/oLYNI7
         6+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766431; x=1784371231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nlpMAjb/Om74qf+FFxwyoZxa1Yqnmh7GeyI4L+jcCaY=;
        b=XRgT/QUpJCxcueAd8HtZ4dUXEzanLYPdJkQevDSGuXm935vhOfuAp7FlUDJe2V0r/7
         /hnU/rrFWgJkJF95N3Vu7a9FlJ4dlQ6zTsLnyiEQpLZzvfySOmEPd3iQsPogVrLl/i6c
         xKuMz1Ta4palG/OP0zboJDx6sdxwNSLGG+OZGPEYpMS8yQfakXcQmDly879FU192dnVq
         F1Uz3lJh+9Qdv9bJmmMBFrLp2Ma7VNBoyUAW6bNwPZcCZVgZPadRbO4S+Mh7Zai7Qk0b
         x9bNvH2d7evc7ajGz5d14yztAgl5/xnBGd8eDbQ6aadzV+c0VlwGETvTdez1w2RFWxgy
         Ds7w==
X-Gm-Message-State: AOJu0YxiBU+3cJpU8rjvSMune/PmUEd+KRohlEVCHP9Gfl7c3mnvhuiN
	guB9enHawchvLOi/TyxA6+6PgvLMHJUaxkiC89amOeNE7LH5yMHAxeW3zRfAVQ==
X-Gm-Gg: AfdE7ckRI87BoxlMawaJdtcgGXuugE+o1UsGWvgd7t9aMWJbIgIDoln3v6aPxlDpEv2
	/WZGmbFGsDQJAgaSAPUsn3u12L/5JtKTUKpsrTxkQ+0ErDGeUSc4JiQfpfi0Mvv7T06Zis8XPBF
	dzvQwQdclAd7OzW6KjSftjqPCPAN1OuVEUHGXSBpY7qgl6gJSmLDyDcXmtG0UdDlua6ox1SAqF0
	zxcU2mtPwd6B7VmjQBdHISZzuvYSKX9PveloRXAZfOwoQfO/wJ9oFzkeywQyvQbCAdkW+g33BHM
	wzhAvJaLRWKzrP0XHAKBqY5ExFrBkC4g7gVbxzkTNL6HtqmKsaAzCCcyA9yyp8jz2IETMOf6sL0
	2wccYkhz2bkvo7AW4zSFm65DC1gd//GYwhuqrrOopXCLW0jiIWFfpvAopc0CJjo343DidSOhdlZ
	82k/PYKeITuSV9Iqz3HWzqx0GBnz0GV/6hI9aX5CTKJos+5TNVPzS5I5AjkHHOLr6WmGmeJUvUt
	9nC+6XTQ8I3kTkyz2VnpRk/lU7JYknuxVbfTjgDCe6lZQJmKw==
X-Received: by 2002:a17:907:3d0d:b0:c12:b227:c0c8 with SMTP id a640c23a62f3a-c161f39350dmr80077666b.50.1783766431223;
        Sat, 11 Jul 2026 03:40:31 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:40:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 01/17] io_uring/zcrx: scale refilling with large pages
Date: Sat, 11 Jul 2026 11:39:54 +0100
Message-ID: <dea84f254f89c7e799a24790f2ebc37a08b59720.1783616211.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13958-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 6F0287413FB

io_zcrx_ring_refill() caps the loop by mixing the max number of
allocated netmems and the number of available RQEs together, which
caps the number of entries to process the pp cache size. As a result,
when niovs are heavily fragmented, the refilling logic allocates only a
small number of niovs per call on average and sometimes even none.

Keep a separate counter for the number of processed RQ entries, which is
capped by a roughly calculated from the page size value to keep the
cache full. And separately break if it allocates enough niovs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 6bd71435e475..8348413d6d24 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -28,6 +28,13 @@
 #include "zcrx.h"
 #include "rsrc.h"
 
+#define ZCRX_MAX_FRAGS_PER_PAGE MAX(PAGE_SIZE / 1024, 1)
+/*
+ * We need a reasonable limit to be able to fill in 64 entries on average
+ * for 1500 byte MTU. Over-estimate it to keep it pow2.
+ */
+#define ZCRX_REFILL_CAP MIN(64 * ZCRX_MAX_FRAGS_PER_PAGE, 1024)
+
 #define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
 
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
@@ -1125,17 +1132,15 @@ static unsigned io_zcrx_ring_refill(struct page_pool *pp,
 {
 	struct zcrx_rq *rq = &ifq->rq;
 	unsigned int mask = rq->nr_entries - 1;
-	unsigned int entries;
+	unsigned int rqes_left;
 	unsigned allocated = 0;
 
 	guard(spinlock_bh)(&rq->lock);
 
-	entries = zcrx_rq_entries(rq);
-	entries = min_t(unsigned, entries, to_alloc);
-	if (unlikely(!entries))
-		return 0;
+	rqes_left = zcrx_rq_entries(rq);
+	rqes_left = min_t(unsigned, rqes_left, ZCRX_REFILL_CAP);
 
-	do {
+	for (; rqes_left; rqes_left--) {
 		struct io_uring_zcrx_rqe *rqe = zcrx_next_rqe(rq, mask);
 		struct net_iov *niov;
 		netmem_ref netmem;
@@ -1156,7 +1161,9 @@ static unsigned io_zcrx_ring_refill(struct page_pool *pp,
 
 		netmems[allocated] = netmem;
 		allocated++;
-	} while (--entries);
+		if (allocated >= to_alloc)
+			break;
+	}
 
 	smp_store_release(&rq->ring->head, rq->cached_head);
 	return allocated;
-- 
2.54.0


