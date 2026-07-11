Return-Path: <io-uring+bounces-13974-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id b5+LMnceUmq6MAMAu9opvQ
	(envelope-from <io-uring+bounces-13974-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:44:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 440DC741486
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:44:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MUgRBfag;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13974-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13974-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9E818303AA38
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67573BB126;
	Sat, 11 Jul 2026 10:41:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553083B7B84
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:41:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766485; cv=none; b=AaPdcYfWus0YpwzABu9KFjhD6FPRo2NU5Dw4A1FtFm9zHcVU7K3pKEUJ316mjikGZI7FQSdc8F4QUh/ls/R0iF1kSPpVZ3LmylIe88BE/zGkte+Wa9Y/B1kBSJ0N0PWoPrCi61fn7Gn7OpVVQ0QcLexZe4Rw/PsnrZXBhyE+1+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766485; c=relaxed/simple;
	bh=fZdiAzGz7MDT4+l8yg8JqDcusAXgcqCF0bEYj/RAbu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpjNSJsES5F8qujoYXDmMXMFG03Q/84RNU/VfrHJ+VFJsvDntoOg5xM/hdAnHWyFBL8I+5uiJhng0VKRW4SL2DVIKeO08PbVpnZfAdo5NgUJ0kRVdv8F24M5prqHz4Q1PEgARSGAASqjmHWEI+UaIHoDdvUfVi8NuyAiS0keEaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MUgRBfag; arc=none smtp.client-ip=209.85.208.45
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69c7697d523so287328a12.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766483; x=1784371283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MsN2Bg58rEwq83AyY9vwpi88nOUpz5zJ1GusdkCgnH0=;
        b=MUgRBfagVEV3tdVmkz1L6Vuo4yWb3P9Tuwm0rD+oF0Nr0h+I/ze+pR9XviEks+bKik
         wv57Fi+dP6tsrTyrEI3AZb+raz74y3XpjFlZcajQ499xz04THk3SCRJA8LLH8g10Cs8v
         SaJ3G2DNK3p3wTDJ1y5osFDnwRWm90BK8GCEsDaoeuJaye5OPSP5Aeo9werdpkyJ5R2X
         RvS3lh0pj08pNmBq9HWGSYUQVTsBpvB7DVxD0ygSFE4mY0DXRXAOOVAAh7YsD32tpMmK
         gsSUrvh5H6OgbggupB+cAk3Zyh7tJblKpElBISOjSyLP3uwW69kL9BczT11PGaEdoPuE
         P39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766483; x=1784371283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MsN2Bg58rEwq83AyY9vwpi88nOUpz5zJ1GusdkCgnH0=;
        b=NFvE2UY0AJqQDI0Iw4Ifi1ODuq532VuvJd4ScvURl9h3Fu7Om5xABnxZNHj1Hb9I8y
         EOLDuHB1O5EpAwEdFAJXudBmqE/xsmtzDfh712GJe4FtKf6/A3HnFSlDLB+C9ddQul0A
         M1vQ/+6y6idr0q7+H56qq1nDp+1B3HP9fkHt/G9BA0IkXE83bE11kmvilxFbppFWFeu9
         SZdMuG7vIInViBcklgKtxK9xoNSvujvHjoBFx2+36AO+bZ9L7xU7gMaVxUCnOkEk2zSa
         8VHHAkxIG0ENB5JD6SEz0m9A752na277HUuo0uZcFJwOIz7tygsCRcOj8XuBBz5Z0aze
         fF4A==
X-Gm-Message-State: AOJu0Yx05Jix1zhQAjn1lKMbKGESuOhjBhm467ffwLJLwygDuKRBRwA/
	bOoVI7AI3PFeMmJQgx1ynO6+RU4zftzzmig5VJ7PBQ8IFr65LptMQZj7fEE6pg==
X-Gm-Gg: AfdE7clrAzEP1f/jWigINhT9PPM4DQJaveKoQuodYNNYcpyamAS1pDT0JvUYd5MYsta
	v8B8Rwxe8q2TV8ed3+gAKSV6GlSYx3Apsjplyw6ZfEqWVG/GQjCs8ZYlzVFX4rT6KeLhEUMRhp8
	ByY86undzCPxziSzTHX6JyyKVKikoEDeLte8nGhMspcvXHBg0RQHX5WltGeU3G9cSg/SJvQl4v5
	1ErzFMlJVLRT629tZoCiEZQPEJXrWFGSeZACbhJpEh44lsIyNkaEh4LwAKQJYcFbm5qw/gtZfJ2
	OghBYNG7Ud+vhveTp4qLWbO8TS3VQ2vet13CyYTL9xnKvG4NAywXBbG53Uzhn/dKNPptgtQkLEg
	2myxd06DT12Pc1MYbkliMKO4Z+VdMfBTjU/Dfv9y1cSHW70FPrEOQ27qc71xJ3cSPk+6SGDbZ/p
	TsouOSj3GPrkzHnuoVddxxM8r22if9uzEI0UakBgzyweSJSsYZlbSqJNNPrh30/ZTpqATQxJhyj
	sFm9F3GaTNzS0SDk6qDLeDdVcK2lky1b02I1ePjUPIuwLPHWw==
X-Received: by 2002:a17:907:cf87:b0:c12:80a9:d571 with SMTP id a640c23a62f3a-c161e9a4fc5mr102428666b.24.1783766482745;
        Sat, 11 Jul 2026 03:41:22 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:41:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 17/17] io_uring/zcrx: don't reload skb_shinfo
Date: Sat, 11 Jul 2026 11:40:10 +0100
Message-ID: <a190271e54e46afe752ee37411bc0ac46d87a11b.1783616211.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13974-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 440DC741486

Keep skb_shinfo in a local variable so that it doesn't reload it on
every iteration of the loop.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 74046a09911a..0aa6455971d6 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1836,6 +1836,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct io_kiocb *req = args->req;
 	struct sk_buff *frag_iter;
 	unsigned start, start_off = offset;
+	struct skb_shared_info *shi;
 	int i, ret = 0;
 
 	len = min_t(size_t, len, desc->count);
@@ -1871,17 +1872,15 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	}
 
 	start = skb_headlen(skb);
+	shi = skb_shinfo(skb);
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		const skb_frag_t *frag;
-		unsigned frag_end;
+	for (i = 0; i < shi->nr_frags; i++) {
+		const skb_frag_t *frag = &shi->frags[i];
+		unsigned frag_end = start + skb_frag_size(frag);
 
 		if (WARN_ON(start > offset + len))
 			return -EFAULT;
 
-		frag = &skb_shinfo(skb)->frags[i];
-		frag_end = start + skb_frag_size(frag);
-
 		if (offset < frag_end) {
 			unsigned copy = min(frag_end - offset, len);
 			unsigned frag_off = offset - start;
-- 
2.54.0


