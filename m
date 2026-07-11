Return-Path: <io-uring+bounces-13943-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /tiPNCIJUmq9LQMAu9opvQ
	(envelope-from <io-uring+bounces-13943-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:13:06 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A839D740FBE
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:13:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VJSdxCQF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13943-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13943-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 24022300D4CE
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D39384CD1;
	Sat, 11 Jul 2026 09:12:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C86B384250
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:51 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761172; cv=none; b=sZYq6wAt9u84zF41xk7P5ujl0QZFj8UvQJe2cAsFzrfoPek1GbSXvOI813C1DfdRkF9+tP1OzZtPs9HoiRmQZ9Wy7Vw8MYdSe+6kPDO5Wn4rxMeGZvMaQrHseRyX354Qk095pYBWVNZmAPXNDgd1Qdah66DLlyUPT52qRz1ovuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761172; c=relaxed/simple;
	bh=+C7cPzjwGMWMdaEB6N7/7Fw5Ykm4MeNmkgQgkpbFji0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSM9HcP4IwfyqEx3qpqYNxWWRU6p3/Cf61epXBYNJs0zvgqDb8WsieqCOAA7Jj2EwffzNbAYHjHDPMszfUsDPED3g0yMSYLDLTw8AhSlm5yZR+uVrQT7rTx5jkiEHZfyvDL2XjYPxeFil50HR0LK4WtVWSgdD2KPCZLx8GZxVb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJSdxCQF; arc=none smtp.client-ip=209.85.208.43
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69532288224so3114336a12.0
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761170; x=1784365970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KLch5rOjo1OUqV8WnEBuRJy4+y7CJW6bTYiu9b+/qjk=;
        b=VJSdxCQFvql5+d70p1Ara25SL/to/WtQ4iXHyPYElthcnxEsNUxTk1yO1y5fZ3o2In
         Rtc20izaZPOBbuI8YzGZ1B9eW1GpwXjqSyc8oELcqKu2VyLKfCT9t6cx24Et0G7zCw4N
         WjMM6EfcYdP/6N7YB+E1XEbEIFB2MU1U6WXBHdH1j3oX5x3B1M4CbSAc4e2A8n8S+JjQ
         yeJ9zTZz4l8zxyrtUV1xl4tY4Sf/0ZPgNHbfk4bL2kaiW2OdOqhqjnpRHh9PaVS1NsKL
         2BGOrRdLmHGu3i/0fgc/Bl3nd1knZBlh2ZwmZlZuOLttpgW1pPyPZaW/SIBoYemZgiM3
         Soow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761170; x=1784365970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KLch5rOjo1OUqV8WnEBuRJy4+y7CJW6bTYiu9b+/qjk=;
        b=pSTkCuwKvVBVUFvpc9Ts7Ddm14hyHBYfZXHEmY0XK4ZPlRfYKlLqSuetyZmXmtRpx6
         CXWfruCOnj9cS/oUM5M1RyLUqLnd1+1AmVWzP9NEvIo92BK1KnzheWBgXGSN/xkXOH6C
         TYWy0aeFgGMX+zeDVXtUurj1GcJ1EZYll9ZmbSCY2Z5zn8HJ2KnSWpVbLBuRgTZt1zRc
         ezHWQqnbyx4sYaFq7v+9vB9efVO9cdv6Fge9g8PtZ+1Xfq1ZAAABz+JldaBiEx8RCZKy
         DTf/kAjZuXxLIO+iHdrJLCxt/gNLAL/aoSmpwpSpWDD/9urBIFCdoNn0RJ+fR5uSD1Vf
         j3Dw==
X-Gm-Message-State: AOJu0Yyd05MqaqRCfyrasqedKOgIJ70un8joVfgjSmXj1fiWsxhWSPKd
	SrZ7s1ksMLz9nKKlmAuIsVZJYAbjJEHU3awHfE6oCq3cobcWJYiF3tcOm5bWAA==
X-Gm-Gg: AfdE7cn31Tf4YOx/7ZiYHfW7Z13JX6FWYlgE52drB9UQfGhnWw2jP03PyFCx2iDH7UI
	r10/7rQrEv53ujDfBsLSTPnYaQOqmw1ZS6U8agrvBXdv0DKlD1jZIZMKdMhBOqpGVr6NAw8ubMI
	uaT6ropxrCw6k49/yJ1TCozUNoLj58veUp9gNPUYgmrGiCjRr88xd3Fx3LBmwk33ZinKSte14hs
	1Kg9qKxCA7cPm2Dd70U8txJFVeD3tIF37+W6iapDZWRwnlu7XThozpy2TpPDrIktww0LmZHc5ZK
	OuUNIqkNl3NpTGBI4TmJt31A1duBQq3I009v7hBAVuJT4UTSdRvHIWAaTAscOisBO9mU6ihJDds
	+89V75R3vVtc+enIdNboqnCnDj8B7QG0dkCdmeXZvtb6mXs4Ebqr7rg+xjK7mdE2+P1BAFVUKJn
	/tvenxLFIW2fYZZr2Xcer7PwBM9Ngajf2rBLd/lAGV4g+SHkmLoNP2Tcg/dfAaNZZEhoe6dlHUo
	lydREW7eHItfgxIvhBbQ+ueQJckVu9DCcgie/+l3HN/xY8=
X-Received: by 2002:a05:6402:3207:b0:698:add4:7f5e with SMTP id 4fb4d7f45d1cf-69c5f0cfec4mr1113289a12.11.1783761169632;
        Sat, 11 Jul 2026 02:12:49 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 14/17] io_uring/zcrx: pass area_id to __zcrx_create_area()
Date: Sat, 11 Jul 2026 10:11:37 +0100
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
	TAGGED_FROM(0.00)[bounces-13943-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: A839D740FBE

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


