Return-Path: <io-uring+bounces-13937-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 4PTQHs4JUmrWLQMAu9opvQ
	(envelope-from <io-uring+bounces-13937-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:15:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E1374100E
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:15:58 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QqYsoYkZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13937-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13937-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B33C3051A79
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C8B384CCA;
	Sat, 11 Jul 2026 09:12:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8A638423A
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:34 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761156; cv=none; b=aAV4c+irkDfoijUojdxIpACsVlhCRU+LdloDDrubGPDpb9GsxmDC9+7EMeiBS02DSEbzCKOgAdW3q22KjqO3TYrPUqIa1XJTHbh42V4KZkeZGYURFqKOlgQR+nqJbRVNTgXSr+IQ6Hu0yg2KSEoL6d7ZYLQD4SSqFeHBIaODEh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761156; c=relaxed/simple;
	bh=iblavB93AxCL3yvmozWyZOBWp012W9mfxgmu0H2OZkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuv3KsWq8EWXjb1MoxWd89R3hYZ/To1VNJRmbY8tsttzwA+bVPLreJs4gtfKm7QVK6Lf1qP1pOJurqlFBuSlwY5o8CW8GakU1aTiuFISpuAoNwiqIpxW/VtDWFqBWbmBJLowGUoXsY7mkC34gKkNigLLDKPLAiRwGEABRGaLqcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QqYsoYkZ; arc=none smtp.client-ip=209.85.208.52
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6986578d8c0so2430948a12.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761153; x=1784365953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=68WsJOLW2BWox2TMFnGxaO7ba3MkU09Qn66t4UUeZYA=;
        b=QqYsoYkZyijhf6CKHxZfLoRMeSM4BZKwKIAg0/MpNWp6+77ESZthNbvqsPt7UAtrKT
         RvVgQz9mMuw/XfhMfz90NqqxRv3DXrY9+LwBbrKYbcW1ROvYdn6cMS1SOnBmRkd1h7dl
         JvDUfiH81ZNYFXVl3hurTbY3ZAE0Fq6dASXvK/bro2fXL2FOz26HqdMwIfWWhhu7BfVk
         gYmZJC+lIWBSX2cJUnF6jxkGUWFD63eCdS85xu3oT2wPlHOwPalORW4xJygM2szVE28S
         wEKN/5n5QobepStC9DaYAdBkFTPczjR6A1LcUIWCGRHICXBG16M4al+u3kLBvclPilJF
         iM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761153; x=1784365953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=68WsJOLW2BWox2TMFnGxaO7ba3MkU09Qn66t4UUeZYA=;
        b=YVB6J61uif6d6dqkkEgFcdZkPfE6cr6ixiHqnXljOcUHO9tRU7JaAZZ3BT9bjwCfav
         eQHViRuwUmE/TctwolVFrNJRmM3EH6f68lLWK44y+NQ2GNOxRBSyypwy/LvhJV10K/vW
         pn35za2se6I9OmMqX2ldCilvrIeN3cHHUWJa6HeENdzVQf4Y4aeHNKaFBzPUwbMR9ceI
         YYYFSSi895Vzx1OtC+7LSNkkOdXy6j9L1yL2nkNQI45c/bVs8b5gIo1A1UXso7BZja51
         sdFVS5JZPEJFJew3bmkCdxBas6musjtXXtZFzUjskJKV6+xEFGEnm+DATgJCpsodEpFu
         EcZg==
X-Gm-Message-State: AOJu0YyMrtpA3NCdw+HmE8Y7aLLmWYtSRkkyrwSm2VAt3N1d313R4ysf
	ARBmCoji684vwoNTOxDdWVCxuvG8eWzVac3WLqP0g4NnI7AjlG6hRk7jykCZLQ==
X-Gm-Gg: AfdE7clFcMw9Nxf0LYfC1b1H+CgB3XKdi8xJUXxvf8oYSTDi/3mw83ozcHsIpHiiBBC
	4blovJBYQvrSwjuCyRWPNI1UTL2VKX4ljx/j+8lq0LCaCxCZz6+qnBaobH6tz0i4uO+UBl5HEal
	hYJ9wVdQLRaAOCqecZ2uwyOv53uR6AWsYy0WmTB2lz5/mB0TXMriEYyT86RgrscAUauvoe929Wq
	Y1LMkt94pbLR86Luwu+iap6wxwGqwTGQ72XknBOb9CYxJ8dT+I9CuupSpubC3ivfuFQGGtHytNb
	e8xf/uECU1YLh2LPgmkmK0MGHKFezzAU3UoXcQrYWfPAAzuDyW8MQZaI6zr9B64F7D9P7X0pUct
	uGocECVZbaQ/wM/fcO5G8oj+BTkITS/JJPt1v8lpFriE6eIiQ1rUwuRcvCCWDHc57bHrwXmMYs6
	1xcLaxFPrO5slDmY8x1gq9OT7kTGq/oCGaNIlr+0pnjJ2A79jZvkpb6Quhp2NT+Urf9p0TMzSfn
	I7t9Owwu5DWWHFr8W2EQYu3ldKWLdalD+sGXiza4vQ7UHE=
X-Received: by 2002:a05:6402:11cd:b0:699:e496:8711 with SMTP id 4fb4d7f45d1cf-69c5f24e394mr1023788a12.34.1783761153323;
        Sat, 11 Jul 2026 02:12:33 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 09/17] io_uring/zcrx: split dmabuf unmap and release
Date: Sat, 11 Jul 2026 10:11:32 +0100
Message-ID: <81b362f58b0f8489c17f03f2d984f499e8ab74c4.1783616211.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13937-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 10E1374100E

Until now unmapping and destroying dmabuf were the same thing. To keep
it consistent with non-dmabuf, split it into two separate helpers. Unmap
destroys mappings and attachements as it should, and release only
putting down the dmabuf fd reference.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 79099a78f8cd..86e8046e98c4 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -121,21 +121,25 @@ static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 	return 0;
 }
 
-static void io_release_dmabuf(struct io_zcrx_mem *mem)
+static void io_unmap_dmabuf(struct io_zcrx_mem *mem)
 {
 	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
 		return;
-
 	if (mem->sgt)
 		dma_buf_unmap_attachment_unlocked(mem->attach, mem->sgt,
 						  DMA_FROM_DEVICE);
 	if (mem->attach)
 		dma_buf_detach(mem->dmabuf, mem->attach);
-	if (mem->dmabuf)
-		dma_buf_put(mem->dmabuf);
-
 	mem->sgt = NULL;
 	mem->attach = NULL;
+}
+
+static void io_release_dmabuf(struct io_zcrx_mem *mem)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return;
+	if (mem->dmabuf)
+		dma_buf_put(mem->dmabuf);
 	mem->dmabuf = NULL;
 }
 
@@ -190,6 +194,7 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 	mem->size = len;
 	return 0;
 err:
+	io_unmap_dmabuf(mem);
 	io_release_dmabuf(mem);
 	return ret;
 }
@@ -317,7 +322,7 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 	}
 
 	if (area->mem.is_dmabuf) {
-		io_release_dmabuf(&area->mem);
+		io_unmap_dmabuf(&area->mem);
 	} else {
 		dma_unmap_sgtable(ifq->dev, &area->mem.page_sg_table,
 				  DMA_FROM_DEVICE, IO_DMA_ATTR);
-- 
2.54.0


