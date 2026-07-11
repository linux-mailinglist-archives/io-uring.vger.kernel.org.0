Return-Path: <io-uring+bounces-13935-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 5l5kIr0JUmrTLQMAu9opvQ
	(envelope-from <io-uring+bounces-13935-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:15:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D22EC741001
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:15:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BC1HFqEd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13935-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13935-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C0408304DBA9
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48FBA384254;
	Sat, 11 Jul 2026 09:12:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F15384CFB
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:32 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761154; cv=none; b=dWN7/EsRouEU5CbqvgVHXZewJLweEa+8FMchfXFTyxvFn47pgqqz02cDic4rKMgGt+5JbS2ZReMlesvzWRmcU6quuQ61crzb0Itt1HZkZLpLRw9YrsiRGykOGOegsWAD7qBsecZ89yxaQ7wxjLZAIKLmuOOnl6R18tm+q/yhO6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761154; c=relaxed/simple;
	bh=iUPgH6JWPillkH2re/aBw/XfF6x479iYGVbuII+TcKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fqp/iXMEhm72tTEre2aBZyutexQdzrFHgjgziVb6AP0G74wYDys2BKdTtIagO1iuSzDwEbIxsHGyQ8Vjpb/uqvIyg5bfBndNaJ/cZZ8kHIPRCYgy6N8YhJ8mRR7CJAxg6HjfwFJ9gLZj+bd6PkLGovOmMg+6Z1xEBGf18rR4YP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BC1HFqEd; arc=none smtp.client-ip=209.85.208.49
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-698beff7178so3053986a12.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761151; x=1784365951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2uJksSIFTYd6T6NwSs+FCH5o6kh84G3qPp3LKMAk37I=;
        b=BC1HFqEdqpLJ02eNfEQh4x3qmfUuGxuyZ8z98qbCkkBa+uaBFU1I6MOu3lDgAAJfjf
         xjdH7tT8oGl0sHgKPnLkYYwsu6iOmePzyGga1sKeiCf6TKD4WTLXNJ2TD1+ERCMS4TD1
         04CaYs8vzg7KyczYKGP5DIStrOHk/KrIxvf7cA7OgImyE0BJ8mF4Ae+nJ3TGhM+7anSX
         qj+D6+0ZJjT8uQWTjepF1DpUJsuIeACi10mLsbWt0JuoQnYG4REPY5gDA8DxOl2MZUTI
         E5460MXzO7xWoWzV6EjnN/0dG2CqCYHwAzmL5vpGx4Ofu6poeGgyh2QcYlgEedYq1IrJ
         5pJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761151; x=1784365951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2uJksSIFTYd6T6NwSs+FCH5o6kh84G3qPp3LKMAk37I=;
        b=G0d5jEPDgK5LkEfivhkSeIqcbcWmB/1Fz0ZHI5jBLkvP5M6xHFucBipIIX6YpF2ibN
         kRIx1AVI/9x55r90JqeKra9n95HB+DvbEPSOeMgMsXBr6SKklk+GaInereJiX5z2Rdkk
         mcjbiO3R6Wr9xxcBB7F8v+vQJEsbB3fgkHP8eliGOByVZxBbWzZdMKxY/gtBDQPFf53P
         KBwHeDTUvNUd+QZaYU6hxUyHlx09XOr2QrHPH+z37ZRalrSm4HRNeq2RlPmkIjBRwrgI
         +qSxOV9+Ejy+nf6Aarie1+Nqua12p/L5TXcwnRTnOPp75Wiy9BC+ojFGzm42Ywkm2SX7
         rR4A==
X-Gm-Message-State: AOJu0YwKqm9w9Fedz/e8gu4yUE45GScDMGPeu1DUHTNeKoYHqsKTkEQn
	rB7j45m7cqXAkKwIuVITQZtlFxBmkSG7EmzilfPr52schgVB5bJEI04y0G6Qqw==
X-Gm-Gg: AfdE7cl/EKx1zKeB6SMsGgqhfQn2GUaqTeIOJIIdB6KFhCK0RjFJafpKKdz7Zp9LSzI
	JxkJV7/HRWGbKJHV8XQExoesp3OFyL+XAYTUaXOLKeZRmk8fXOTU/bPagJRNm92GNrTYLkAK77V
	UnLYE2PGW6IKNJFIkTEH3IBSizYBNf0/gORSwWLCdn+7xRPlOMzvdpCLHQ/mATmCZGidBxzPdNg
	2NSsyHTPAK7Z0gqVZ1PKJmq0AmKWlCDyI8GhweoJkR1oDel2qREJIDIVqzPd76XQuSDw054zcZ4
	yJQRi5fK/e916Hb23na5n+nXvXY92G1PlKGPTB2x0vZF6rAEctapNW9hr/uXf/OgoHGb4Qa78L8
	fD6AhBWxq8m1rxziHPPuzlaIIrU5rtFzMSEL344Ofb6J3TE8bme4LTxiFhQPjeBknz2D7wvlqJL
	LyBgA9eoSWj68wroAXS516NPbdvJeLGRkgzHNE84pALneDeVKK6+WXnguLAoq+39rGBXCNHlQQq
	EsMjNLGcbSVzxOHuFkv4a7TXktEEFMSzBWid56LATBSH4w=
X-Received: by 2002:a05:6402:2351:b0:698:9251:2f72 with SMTP id 4fb4d7f45d1cf-69c5f25b789mr1174608a12.35.1783761139565;
        Sat, 11 Jul 2026 02:12:19 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 04/17] io_uring/zcrx: cache RQ tail
Date: Sat, 11 Jul 2026 10:11:27 +0100
Message-ID: <7d51b1e59c510acad94fcd0c00b617f075748a2d.1783616211.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13935-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: D22EC741001

The RQ tail is updated by the user space. Cache it to reduce cache line
bouncing. Refilling now tries to exhaust the previous batch of rqes, but
since it could be too low, the iterator is allowed to recalculate the
rqes to process once after synching the tail value.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 27 +++++++++++++++++++++------
 io_uring/zcrx.h |  1 +
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 45b178afbbc3..1b8d748b35e7 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1090,16 +1090,22 @@ void io_unregister_zcrx(struct io_ring_ctx *ctx)
 
 struct zcrx_rq_iter {
 	int rqes_left;
+	bool flushed;
 };
 
-static inline u32 zcrx_rq_entries(struct zcrx_rq *rq)
+static inline u32 __zcrx_rq_entries(struct zcrx_rq *rq)
 {
-	u32 entries;
+	u32 entries = rq->cached_tail - rq->cached_head;
 
-	entries = smp_load_acquire(&rq->ring->tail) - rq->cached_head;
 	return min(entries, rq->nr_entries);
 }
 
+static inline u32 zcrx_rq_entries(struct zcrx_rq *rq)
+{
+	rq->cached_tail = smp_load_acquire(&rq->ring->tail);
+	return __zcrx_rq_entries(rq);
+}
+
 static struct io_uring_zcrx_rqe *zcrx_next_rqe(struct zcrx_rq *rq, unsigned mask)
 {
 	unsigned int idx = rq->cached_head++ & mask;
@@ -1110,7 +1116,8 @@ static struct io_uring_zcrx_rqe *zcrx_next_rqe(struct zcrx_rq *rq, unsigned mask
 static inline void zcrx_rq_iter_init(struct zcrx_rq_iter *it,
 				     struct zcrx_rq *rq)
 {
-	it->rqes_left = min_t(unsigned, zcrx_rq_entries(rq), ZCRX_REFILL_CAP);
+	it->rqes_left = min_t(unsigned, __zcrx_rq_entries(rq), ZCRX_REFILL_CAP);
+	it->flushed = false;
 }
 
 static inline bool zcrx_rq_iter_next(struct zcrx_rq_iter *it,
@@ -1118,8 +1125,16 @@ static inline bool zcrx_rq_iter_next(struct zcrx_rq_iter *it,
 				     struct io_uring_zcrx_rqe **rqe)
 {
 	it->rqes_left--;
-	if (unlikely(it->rqes_left < 0))
-		return false;
+	if (unlikely(it->rqes_left < 0)) {
+		if (it->flushed)
+			return false;
+		rq->cached_tail = smp_load_acquire(&rq->ring->tail);
+		it->rqes_left = min_t(unsigned, __zcrx_rq_entries(rq),
+				      ZCRX_REFILL_CAP);
+		it->flushed = true;
+		if (--it->rqes_left < 0)
+			return false;
+	}
 
 	*rqe = zcrx_next_rqe(rq, rq->nr_entries - 1);
 	return true;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 3cdfa4415d62..0eb7ea35a9ff 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -53,6 +53,7 @@ struct zcrx_rq {
 	struct zcrx_rq_hdr		*ring;
 	struct io_uring_zcrx_rqe	*rqes;
 	u32				cached_head;
+	u32				cached_tail;
 	u32				nr_entries;
 };
 
-- 
2.54.0


