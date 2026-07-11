Return-Path: <io-uring+bounces-13971-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NBLDNfAdUmqgMAMAu9opvQ
	(envelope-from <io-uring+bounces-13971-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9488474143C
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:52 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CxTK7Ye8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13971-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13971-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B44FB30254B6
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3723B7B84;
	Sat, 11 Jul 2026 10:41:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374AA3BB12C
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:41:15 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766476; cv=none; b=C+bRdtQJQnOUSihAE3r5psgkvDp/9/Bj3QjbwYI39IaH68m2Zc3InOjdB42GCwmITQ+9cR2NsTAiz78wcnByjT7F8vdZs7ABCcVWkOrUEKyRSQFm3a8KtXgXPezlmcnFw66q4Nx+umKHjVCQ8Qa7WS8BwMNcghs1qVHIFy2qQd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766476; c=relaxed/simple;
	bh=+C7cPzjwGMWMdaEB6N7/7Fw5Ykm4MeNmkgQgkpbFji0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0D6ceeyev+GTjPLkOrIPk9/eonzWo2Swxuj7EotJjUjKOaTCj2KgTOxEC4RHabjKvDhCr1GO2i0pCrCMKKcUMIlGHaTnTIYT/QyR1gIivSkR1sHBpekUsFHTOQFxbo2DJ91nAhasScCrugsa+UV7XHR7ior3w8PdJzlbHaR6DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CxTK7Ye8; arc=none smtp.client-ip=209.85.218.41
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15b509c323so237675466b.0
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766474; x=1784371274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KLch5rOjo1OUqV8WnEBuRJy4+y7CJW6bTYiu9b+/qjk=;
        b=CxTK7Ye8bgoIAYchoaLCcwAQPjqThiLIlfHMOxAgt8xCQz/w0jzYbw9022B9TpSZYn
         IzA2b/npV7plVnspn+iggNZO5A/W/3dVTu3p1JgiC9GwTNOHGx0ZBQG9aBsHRv/KoWBC
         l9ZTDC6uioB9z4DO2zH707crxYqiTqv2gBzpINYz+HzFv9cwcAdOmZtsTLcCRcg9cq5w
         kO719NzL8fa93T+JhHiMy/Ty+Hn86XafDQOg9wKJxL+n5X20fUD0fidS6fJOrVaBRN9R
         dc8UJnxKvBlH7Ccb7ATVArkDoIZ5A1XV2gXxLeyPHhEJy/YoEg8keBGIoyFcs/44NxNZ
         ucGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766474; x=1784371274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KLch5rOjo1OUqV8WnEBuRJy4+y7CJW6bTYiu9b+/qjk=;
        b=bpsnjsa5R93qzhqxkIWrpfA6PE4z6SbCO1cHODNNm0vqN4aqcOgeamsO/qeiNJpv5J
         m7uTOh46NuMbHpvD513WiBGicc6An1hHoNOSa1TeCheoPyJBtJfSkmM7KRaMyuIGOx0T
         TIlLNxoDMdRnyKaOrgRrDSR43365Vn3uRsQXbD6XhuhGBFB1+YR11y12GkK++hhL2/Ie
         HRFYTz02/0m7tndVxFR19sIQyiCjDOEcjs3EZ7smTcZJ2vDnc1SYaGDMdaOZYQk9aj2f
         xCVg9wrcyxXGtJyqFr2jLJzThBTLalExcPOaL3Lx2jsXqhgGsi0pVocpLJlV3BYA7yvv
         Ap4g==
X-Gm-Message-State: AOJu0Ywyb2Tu8HewU3BBYXWrQ2QvS9c5zzv5XOgJnsxNaRsxIlD32rLT
	KHqXfLUN934l6Tvap28uMuwY/mutUhb3/fl4gZsKdL9/Q2PNybp3iOUce0P1+w==
X-Gm-Gg: AfdE7cnJaDdCDbKGlY3eNYrKIJDKPBMbBV9h23U4NA4RfHTLHOcjNw0BC3FvZrH3qHI
	uKV/GbS7CcpcxHUuyr64K4ecZsxCj/1lpub4WNsZAaYwmQevedvaARZj4JPhhjr8ccbmOFZoV2x
	E/h9mg6i836OJg71C8nm3HpAb4/G9boP8H1+UXAMqbkjzMD1uuzqbg8TZBzYhwEjwMvAUWNHxdi
	UfqWQOPpMjSnmeTIBf713wgh8ekm4bk/DO8vjWmVyGsTopSB6xGzNQBQ6SkvV0AEYitJR0qaccI
	tqyUkAo4JHajAYPK7MnrleEbSuSvD8BC9gxRrzjBorqIlEJWc1f0bU7Y8+qXm+XpS4qCze4wHZP
	rJQ3eyaFuPbrGoLbu+WwlFuvrTxhGuY/i4nvLZrDMgiRbZu5FbHn5E1L+Plg5Cm6otxejP1Lfva
	s5rLKxkSJ7Qc0muOm+dSGyhnGGBAbDxGMo8JRKlYm+hM+V89agTtZdcAN8H5/Ihni7XrasjStPL
	DCPFvGOj2Cl/OIRnopNNX6BAdHuUPpOykVhTp5ysRxTUzK8xA==
X-Received: by 2002:a17:907:742c:b0:c05:a987:6818 with SMTP id a640c23a62f3a-c161f359e0dmr64588366b.45.1783766473643;
        Sat, 11 Jul 2026 03:41:13 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:41:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 14/17] io_uring/zcrx: pass area_id to __zcrx_create_area()
Date: Sat, 11 Jul 2026 11:40:07 +0100
Message-ID: <d40ecb7a6e912bd32ece44a9e4c001c9de05d832.1783616211.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13971-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 9488474143C

Instead of generating an area id inside of __zcrx_create_area(), let the
caller to pass it. It needs the id to derive the user token, and we
might need to know it before creating and publishing the area.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 474ffc217b0b..3f61f942c393 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -44,6 +44,11 @@ static inline u64 zcrx_area_id_to_token(u32 area_id)
 	return (u64)area_id << IORING_ZCRX_AREA_SHIFT;
 }
 
+static inline u32 zcrx_next_area_id(struct io_zcrx_ifq *zcrx)
+{
+	return zcrx->nr_areas;
+}
+
 static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
 {
 	return pp->mp_priv;
@@ -472,6 +477,8 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 
 	if (WARN_ON_ONCE(ifq->kern_readable != kern_readable))
 		return -EINVAL;
+	if (WARN_ON_ONCE(area->area_id != zcrx_next_area_id(ifq)))
+		return -EINVAL;
 
 	old_areas = ifq->areas;
 	old_nr = ifq->nr_areas;
@@ -494,9 +501,10 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 }
 
 static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
-			       struct io_uring_zcrx_area_reg *area_reg,
+			       const struct io_uring_zcrx_area_reg *area_reg,
 			       struct io_zcrx_area **res_area,
-			       u32 rx_buf_len)
+			       u32 rx_buf_len,
+			       u32 area_id)
 {
 	int buf_size_shift = PAGE_SHIFT;
 	struct io_zcrx_area *area;
@@ -565,9 +573,7 @@ static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 	}
 
 	area->free_count = nr_iovs;
-	/* we're only supporting one area per ifq for now */
-	area->area_id = 0;
-	area_reg->rq_area_token = zcrx_area_id_to_token(area->area_id);
+	area->area_id = area_id;
 	*res_area = area;
 	return 0;
 err:
@@ -583,9 +589,12 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_ifq_reg *reg)
 {
 	struct io_zcrx_area *area;
+	u32 id = zcrx_next_area_id(ifq);
 	int ret;
 
-	ret = __zcrx_create_area(ifq, area_reg, &area, reg->rx_buf_len);
+	area_reg->rq_area_token = zcrx_area_id_to_token(id);
+
+	ret = __zcrx_create_area(ifq, area_reg, &area, reg->rx_buf_len, id);
 	if (ret)
 		return ret;
 
-- 
2.54.0


