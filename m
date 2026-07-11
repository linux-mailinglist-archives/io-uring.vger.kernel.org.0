Return-Path: <io-uring+bounces-13941-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id WKrxNDwKUmrfLQMAu9opvQ
	(envelope-from <io-uring+bounces-13941-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:17:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C9B6741023
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:17:48 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TAQVodJQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13941-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13941-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0FAEB306E4FB
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB74A384CCA;
	Sat, 11 Jul 2026 09:12:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5B13019DC
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:45 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761167; cv=none; b=Z4upONJfq+WcERvDSWI/+T4GcXiKLtvEZI8oCdHMfL7qSb6KowJoceNAt2fmSTx+XQUviSICm0QZvm6UPZSfH4pnFEszn/rjPfgyx0meBWDx05nNYxnUoxvxFnDM0A0bnj+A/YflDf36TjlhuAxPYVYtMjR6wBsDHjWN8K5Px/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761167; c=relaxed/simple;
	bh=XcwPk/xz4rph3atCxJxjVPf0kH5YBWVnQhnf5gTxLeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2J/Hcv/7MoFA27X+GYmRh7ptujlrY7VHVp/6Z7Lh4R1mKDVK3KEODwTu84BYZOSAdtDEbRlj65WqjdmAPrxlv2oPnhm6P0JCwC7+RIRft3D2dWe6AfOUN3aphydO4LKGEzsuwWIn7P5tm/rnLEqtjTtGpdcd8sdwI8DsigfAj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TAQVodJQ; arc=none smtp.client-ip=209.85.208.47
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-69531108f25so2759577a12.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761164; x=1784365964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yAT9Ipoiha/afQJ9Xt4cvUQUYBf0y1hE71aqbx/vl+E=;
        b=TAQVodJQn2UjmKoOffW8l4Uteldwh1EvDFr8ruREbkspV+qLEUTATwmwgs5Zu26AfX
         mObc1eC+h5Ea1s5ZZNABPA2lz3U0NKhXvWfcQtUpfnsVStvQSaxvrN9kXo3d9BuGBMJL
         lPByB/35u5Vo5KWka0UQLuNUGQ1qesvlrIdwSX1yV3NjSuNLTo3FNb18Fh3W5FXG76G/
         iUfWTY+MZ0VLWf8ywTf0RH9/MK06U1bL/UnoINbnnNWTiqlkWs1PY5GR5dvBmZ69SJua
         QNLj8TRrRbWXVFRVyR5jEol2hicLnGVvEDdCywDBMAhpb2Gb6XGaAWS31BLntzLBmwE2
         tj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761164; x=1784365964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yAT9Ipoiha/afQJ9Xt4cvUQUYBf0y1hE71aqbx/vl+E=;
        b=XXXAI+a7sgLmvPreUYe/61SZI+DG9Sqn5JYLu/4CcKwy9s0LLpg73uMSAVw0jsMqwe
         WbpIWWi83/VClJ743BFHfPCXlmtKsIEYy7W+1Xidzv0pJ5U2ZL5vr/XI3S+rYlB6JdEH
         VJ8MA22CI8o96rVbcpqC6JjGuoAgJBqC1/zPI0Dy/pfY8WY4hbASESdXbt8+WZccik5w
         4sXxAjy/9m5VY1S8sU6N24SRrVYeX8sRzDkh7jkLXTuG6oQt1hbxRFA1VCnfN8mja+3E
         X98sPjpom1bVsXXVaZYtp4QcS97VZrpDpXjCpunUCdEQzlUz/YrV+eKKtEkWC02Uda3z
         62Ng==
X-Gm-Message-State: AOJu0Yz1WhsOCXTuL0PhLIi4xC6v81p3kzSGQdNB8ZLkGN4qI5sf/BK8
	qhVtqaahZaqmsfV7G/2oj7w2XF0l01ve2QY9A2JiPzZOciYdm0Yv5nPT9FVU9A==
X-Gm-Gg: AfdE7ckWL1iK6l21nC1BUP03dkE6NPKuDyORmbJkcNorPHBbYX93AYIdz1njIPXR4mD
	NudEAbA70Akjag3rMrGLD3kue8xC/J8bkFNrwtxwVP5zek88gxj55WYYOiTwOXQYtE7kCuFBkt8
	mpE4QJlKssOyIdddBMFExzujLoWK5kbxJqYI9n4LmV4uZ6DqjJMPRY3vSjKfaDtrRNp6Q0xr+hu
	XdhTpc+yh4MPmwKx+BcuyYlurJn8euS1s8FEHR6sErBmd0GyMpVjRemL3vJWBXYLvTmFCv5mrFC
	OraYBY7U+SkHPrxmXRlzSOn1AP4ESuTTj0qSlrB8aBx+UCLc44XUf7oqQ2eCdSx3S7kAQ2vahHt
	WNzx2FeoPauMI/9p21cuYgJ8iTgpa4IA5One4I4lUeakFxF22SyuQj26Pz7J+icRe9B32WDxgyk
	5gWmXnybqkDxidNGOY7ijPr+45fb2ae8QwI27g6f8414qbFtn9//tjGFHooI3nt3RcrCImm+MgK
	CiBX8TLfDc04wOfRjfm2ttumt6cXZnk8w53A2vnnj054bE=
X-Received: by 2002:a05:6402:26ce:b0:697:d4ee:ab97 with SMTP id 4fb4d7f45d1cf-69c5f0e2b31mr987820a12.12.1783761158039;
        Sat, 11 Jul 2026 02:12:38 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 11/17] io_uring/zcrx: split append out of area creation
Date: Sat, 11 Jul 2026 10:11:34 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13941-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 2C9B6741023

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


