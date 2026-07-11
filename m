Return-Path: <io-uring+bounces-13934-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id sdPNCp0JUmrOLQMAu9opvQ
	(envelope-from <io-uring+bounces-13934-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:15:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B43C740FF5
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:15:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eude5mWc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13934-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13934-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F07C3047244
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EA4380FE6;
	Sat, 11 Jul 2026 09:12:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D9E3839BA
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:30 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761151; cv=none; b=OeqH9jXbeH+nN/rvnJsDuRCdygfdw4bGybVikYEQl1Zi4qkb56TRVcTpYfD8QfDLcvifPusTtlG0HmaAevoiZfWzt1dcm8nAbATjaByMtfR66GEhSM45fnfJ9CiEh6glMlRzV2cpnrXWpEJRnwkwsVDsTpa5xNo2h1MoYNzuf1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761151; c=relaxed/simple;
	bh=y6yQSGnAR5XQ47wvKONskzfyKnoHkUX2B4v2Pz6YZH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3md5pZ4CVAM++dZ/pVz5ajei5MJpy4I+4pXDUgtDe8rsjgXlxnPuSmSC+4lONMehrzJqgzyez2QYaj2Pep6gwxmLHAsR1h88rv6r+9AG1DEXGXnwPRX1ou9HCWwjxxvXgbfe4VNHmMQ6v7zsM1vMVmtbj683+aIsnz3EkDNtak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eude5mWc; arc=none smtp.client-ip=209.85.208.52
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-698bf053053so2596524a12.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761149; x=1784365949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=usGHobRrb/n60uWolYcRXowPvM2AUlugjjkqCBNhRKI=;
        b=eude5mWcNyyus8asPYhEfH9d7sxcvBeCtJBCFjL3keMZM9eMn0yO6ssrJp3WbXGZDG
         /+cp7NdblLhg7iJpQfJH2iksvq0wTkP9CwtBePlsZtraYDS368To7QcSlste/K5EYYsf
         Fr6XEpK0g4PNJ8NjYRS2wY5MDvn6wqU4xAvyBaVQQZWJ4Iy0ffd7elvuIPu6Zap/Qq21
         wO4bqu5Ai0JXXcrcq4E/j3afeDVhXxEX0BZLZQswcZNTiL7pNNtx3uZ8uLXcD069imMN
         sMIS1XjiR3TrF422RZV9ZBuesgqPvHU+NBZUoR/yMllQp8SOQ9x0MgXEIZh6DNR1y4U4
         qo3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761149; x=1784365949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=usGHobRrb/n60uWolYcRXowPvM2AUlugjjkqCBNhRKI=;
        b=rU82bl7SziIRhuZd7k4HuAgGFzNcA42OoC2EFoca872JA6YSGHRXLFwJlJIIgTjE/6
         3CvL7c5Lr1ESI9JdU0QR4OCqjgmBjBZHeT5pkqjKrQxeDyjUjsa/w5u1608/afSdOby4
         QIokXusJqbHmWf91PXZLQ2tqrB+njA0bvdVhMFbsG0UCUcmvqUUaS57qeQcqtaJEylZc
         yXCjtdQlnQdq5RDYIuHGzk1OcTYbGrWmQa6VTL2D1N6jrZewOk0/BnaqSX4tyQRtzEW3
         pASnLFkpNpKbjuG8ocJT1FNwAui7hmA4uXt5zLdKP2Q9oJy3ka+WPCgRgmDT1ibhMc4F
         6vwQ==
X-Gm-Message-State: AOJu0YzerC1ebPolhy00BiZVha/2GT2mQmdHzg4uKzJ6USnS+9TGBe8P
	jo4GC3RluvmksczvAcu0Kp5peAm5QhNS7cRo6pNXwUr8tudPUZMBbpm5FJRoHA==
X-Gm-Gg: AfdE7cnlvj1AVfxOiJFDL9dXCZ+fkjI7V4jrxCIQzJeJMIgD5nEa/c/iEQPSxOsMOfo
	F5V/F2HncCVX7m5DSa2kp6dN/OGK2QzJFHSDRvNeF6bBF/E9G7f8SaLkP0kNflyB44p2MaGyp0k
	HjyVXSAQqouXvtWEEu2cmXvhSTiWYdAo4iMbZw/jENu5KucTlzSuUzJGH7Xor1CuK3+aSShjeK9
	2OLqU84q68L+MdH40UsH1e9SH6PEknu91iR1KETM3OAoP95C34C9v3TkLikaML5mWyDGntkKFD+
	1PbOe845CjBXK0pNQTc39RBGMnflIko67X54vjZVoiyRPuSBaR5luzopu2WrNnw2C3StNW7eCHa
	mtgroxDvyvQzjlkulvJG6bA/amoYe3z+xUvTaaixCZbuOvOa4ukQdcAupxFTjEEDQJazHIvQ1U1
	O9RO8OuG+E1p/12UviJrS8qqdiAf0PqqLbMeqLUHxM9eHyPJiS8uvSAlcZiRUXRk/T9d/PU4Q38
	cVNvkkIFOOOMmq+fMkTk+i6VhTZtqcXbdZMjVhXeuBBIVxIK52hLgPzrQ==
X-Received: by 2002:a05:6402:158d:b0:69a:af38:2fc0 with SMTP id 4fb4d7f45d1cf-69c5f1212cbmr1028448a12.20.1783761148913;
        Sat, 11 Jul 2026 02:12:28 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 07/17] io_uring/zcrx: add helper for deriving area token
Date: Sat, 11 Jul 2026 10:11:30 +0100
Message-ID: <1805d75d8f37c1fa412d67394e2c7805bbfa15a9.1783616211.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13934-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 7B43C740FF5

Add zcrx_area_id_to_token() to deduplicate the way the area token is
calculated out of the area index.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 9f21ae61b862..cfbfbd262f90 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -39,6 +39,11 @@
 
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
+static inline u64 zcrx_area_id_to_token(u32 area_id)
+{
+	return (u64)area_id << IORING_ZCRX_AREA_SHIFT;
+}
+
 static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
 {
 	return pp->mp_priv;
@@ -527,7 +532,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	area->free_count = nr_iovs;
 	/* we're only supporting one area per ifq for now */
 	area->area_id = 0;
-	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
+	area_reg->rq_area_token = zcrx_area_id_to_token(area->area_id);
 	spin_lock_init(&area->freelist_lock);
 
 	ret = io_zcrx_append_area(ifq, area);
@@ -1525,7 +1530,7 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 	area = io_zcrx_iov_to_area(niov);
 	offset = off + (net_iov_idx(niov) << ifq->niov_shift);
 	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
-	rcqe->off = offset + ((u64)area->area_id << IORING_ZCRX_AREA_SHIFT);
+	rcqe->off = offset + zcrx_area_id_to_token(area->area_id);
 	rcqe->__pad = 0;
 	return true;
 }
-- 
2.54.0


