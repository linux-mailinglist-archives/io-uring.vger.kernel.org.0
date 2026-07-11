Return-Path: <io-uring+bounces-13968-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 1Z5wEDYeUmqoMAMAu9opvQ
	(envelope-from <io-uring+bounces-13968-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:43:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC66474145F
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:43:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jqVxRcO2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13968-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13968-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D16293056F2D
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33AB3BB9ED;
	Sat, 11 Jul 2026 10:41:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A073BADA7
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:41:06 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766467; cv=none; b=QSqIRtAYxd4fLMit1+N5Bmj8Abj+wcXzh6Te4soou2Yy4uiTOzNng2/FVkJtWhNrP0NitIcKE3WlDAc+qOSdozln8lAN0xesdfv5Tfx+nbUW5s8HJQURtj+FcYJFAePUWNpdg9vFM4ujZbfDImHjyjAoPqM77DO9Bi2kWuEYfEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766467; c=relaxed/simple;
	bh=XcwPk/xz4rph3atCxJxjVPf0kH5YBWVnQhnf5gTxLeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7WRwrsQP7gbP5D8hBYBSwEhBR/BV6+o0WavBNLIKr/mf/UuMvVayGtfxQnCiD7n4TQlrLFNO/MjJwfcsePQw0cCEhZCXGuerPr7EsfjqIDoZd8iTOxDiC2zJcccGXS1+G40zHRu/FYtEB9CgDSjKhxFWlpPioa/oKuHq03AwlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jqVxRcO2; arc=none smtp.client-ip=209.85.218.45
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15e3141d02so203297966b.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766465; x=1784371265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yAT9Ipoiha/afQJ9Xt4cvUQUYBf0y1hE71aqbx/vl+E=;
        b=jqVxRcO2beiHeGqIK7kLY8pPEd8NxN1RwGVqV33vQakilL6HaHbYMuC0QL8aUmT/Wr
         w/wGpOfg6spR5oxmmgXIDdFequYUJUz7KeokiJDIKTX+XhBu3OluZHVOGkiLlzrNvIIO
         YrC4f14pMdcv7FMl3/MXIyFoABXnIdsYROjQ8l6F7jeQlSlhWhOBbw1Sq0TnneIw4N4b
         vn7yolmkZO79qwOM3HZL8Un5mLvudyX+QW8DIuPqcq1ovAK3DtaDpBpEb6Tl8Tgmk7jz
         u6l3YyeroLNwBmkeNEIGSk7j9Jpg7ssOcsqdt8CWJX1IVsi8ajncCTwuvy7EiIuEybRE
         R1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766465; x=1784371265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yAT9Ipoiha/afQJ9Xt4cvUQUYBf0y1hE71aqbx/vl+E=;
        b=RfssCUDLtGXBZBIqyiWHRn8ppigCHt6//AwFahtV4bQTukOOwOFM/849uFGUhttD/n
         lTl8KVdW6rbPteyDl16/RBXIv4wGoCnszmjTDQ6QXRP3nsg8Fmdw/2Y1bDiUbytLljK+
         S8IoWXlINImvAaf0KBJ7IhE32inMKrFqT1GaIAX8Amg3m7awO/o6mNSvqgknPZzk0zAd
         1PgudHO6h/6Ihj2Ssq0vXiNCu+FNddY14pN0M3ryjbphu55ehw7FZdeiQsnD9Cf/jLKs
         34Td/JBJT/MtK2sBCyEIJ+YUERN2CJ5bD7hybZSkqDml90m22EaQek0tU2ZDjYIvtr3w
         h3+Q==
X-Gm-Message-State: AOJu0YxMD0tn0lSAfYReQQvwNso04L39vg/fkJKQTuFq7tJIYKjitkiv
	A3SGwdhDmlrNeYM4Z5rlUMFIWIwtAjQmHjpwq5ohqBOb6XkpqhAWE7oIXZtphg==
X-Gm-Gg: AfdE7ckg7EOsM6GzzTLxbd9EVlbJxO/bBkSQ646F6w2CArfEPOHXLDs58jWYTmwHxcY
	SRck1L4etcIUsSoOGZw9XKpKpgNlcaOgQd6jOLyxV30J03uiKOuR0UgCoY4DJlkWzXcLlJUZKtN
	4LuX4nDEu7DOl+onTS6Tv5irQet6jQjXe3OCqgUQeKlz9gZhUlAuRxhyNtEhQ98rm75BlO+0j0x
	xENxcyCEmI3KBI96g8JjzywNA2NPhZw2xuz3Bvqjlh+/iQSx8W+6fqicDt93x8XSucu0FeVoO3q
	dOd4r+hN4uObje3A+iECb5bXuoqjB5p9XxrDxgGcpLXUUu6PK5LY2oZMrGnWUbD2PcLz/lv1rVP
	/lWCPWZGaOLcObgyuIRORt2f1c8YyKirAt7BBWjBZmLaYc0ZBYOSeV4EYxI8DRnDvcGNMKXrqpg
	ODX8VGw45owBSs4FBPBgynoNMDfjiknOrOLKb6hJPS7ps0FDaPMZi7nXQvhieoO8VVuAduvKZAJ
	uYEIMmFQfqB5sajNq1WhGfbQrCFqSibz8VJZb5C18nfnS0v7A==
X-Received: by 2002:a17:906:fe01:b0:c15:c3bb:c90a with SMTP id a640c23a62f3a-c161f3cff37mr90002966b.35.1783766464499;
        Sat, 11 Jul 2026 03:41:04 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:41:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 11/17] io_uring/zcrx: split append out of area creation
Date: Sat, 11 Jul 2026 11:40:04 +0100
Message-ID: <62a444a72bf8574c92e4e97751fd8b39b5f17082.1783616211.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13968-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: CC66474145F

A preparation patch, move appending an area from __zcrx_create_area()
to the caller.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 4936d92f6339..40cabf4384d1 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -471,6 +471,7 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 
 static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_area_reg *area_reg,
+			       struct io_zcrx_area **res_area,
 			       u32 rx_buf_len)
 {
 	int buf_size_shift = PAGE_SHIFT;
@@ -544,10 +545,8 @@ static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 	area->area_id = 0;
 	area_reg->rq_area_token = zcrx_area_id_to_token(area->area_id);
 	spin_lock_init(&area->freelist_lock);
-
-	ret = io_zcrx_append_area(ifq, area);
-	if (!ret)
-		return 0;
+	*res_area = area;
+	return 0;
 err:
 	if (area) {
 		io_zcrx_unmap_area(ifq, area);
@@ -560,7 +559,19 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_area_reg *area_reg,
 			       struct io_uring_zcrx_ifq_reg *reg)
 {
-	return __zcrx_create_area(ifq, area_reg, reg->rx_buf_len);
+	struct io_zcrx_area *area;
+	int ret;
+
+	ret = __zcrx_create_area(ifq, area_reg, &area, reg->rx_buf_len);
+	if (ret)
+		return ret;
+
+	ret = io_zcrx_append_area(ifq, area);
+	if (ret) {
+		io_zcrx_free_area(ifq, area);
+		return ret;
+	}
+	return 0;
 }
 
 static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
-- 
2.54.0


