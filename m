Return-Path: <io-uring+bounces-13966-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id b8b1Ex0eUmqmMAMAu9opvQ
	(envelope-from <io-uring+bounces-13966-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:42:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F17741455
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:42:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ku8UA5dV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13966-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13966-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1FA3D3028474
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4765C3BADA7;
	Sat, 11 Jul 2026 10:40:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ED03BBFA5
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:40:56 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766458; cv=none; b=rD2io+rZ2h5nfA2MsDc08a1rC+RFuYk9as1JLdiMs0YRv5GMihrJ1rt7pX4Uf6pHX0yhdtIllyL+4vWT5y0nhH86Evxuooi0jQVgwkg1YWOAzycmP7bDJZAYwmXLZYnymFumjNnkhxf5r9XZlA87Ek8APsBfSzn8586DinYZH34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766458; c=relaxed/simple;
	bh=iblavB93AxCL3yvmozWyZOBWp012W9mfxgmu0H2OZkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irSY9hK2dtLgt9cCipU6fogBMZ6apniwlpknUmEb86nqlZpfgtzdGepQ/olWQ/VISA6jenTvPfEvVxZ63sE6Edr22pVvqYMRddfMJTzmIForuxcGTGOuKBxE6A2rgJIlruU+SVexUiGKo5E6IugPBqWFFxHx5eM3bXzDY6EK2gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ku8UA5dV; arc=none smtp.client-ip=209.85.218.44
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15f020a223so245231566b.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766455; x=1784371255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=68WsJOLW2BWox2TMFnGxaO7ba3MkU09Qn66t4UUeZYA=;
        b=Ku8UA5dV2oOHxFdO6/DrzXb8YYVLDzHtwazH+YJTejjqZMjtHAZWagArfDgTNbr5/n
         Z4vELg7hiOEprdQNUu6xJVecOJbrjvro5URW0TCTYLFdlOykSSlglZf7TAJaWCp1D99p
         1CqSRmK4DWt7xqQZn+2McwaP1pRHnfjYDyPhUzEQ9ExV1rG+FQwmAq9nIjTXQx8fmc9c
         cwE5dl21vII64t22s0tuh0yNpJ+BlPteg0KhR91CNsgoLLTkec5OrfR5c2c1qBnKiRpB
         2M8HYGrsEFcXRvpXzKcfz8Ic/i+Q6gqmxdPkNrYmokhoAdyiGzV6eLna5phbyU+4KFLk
         CBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766455; x=1784371255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=68WsJOLW2BWox2TMFnGxaO7ba3MkU09Qn66t4UUeZYA=;
        b=V1qYq5HXHr9MVesTOJsS9RkYaiL59Q9S+3PzqCsWMsO8CwaS96YTjFJsc3743zKIJ3
         ywig2TpIRDJrff5QrqzRbq9NbxSUSeBjCMJS9qHY6M9B4JhtFYD+1lUGZEqxBoBgGGps
         lNR0zulzaTsQnop1kN26NShMVKlHMzUqQPDBzcryfbIPmOtMYGqYcifuShDxbR3PIOyz
         1Gb9iHqg8uaQnGo3fjK7D7+yFzFKYs7UHM+NvpR8rIxXpjznwwEKW4uKbxDcDHNAjEXj
         6zhjHc3vHFEcCRu/pN1IUObih0f5jf5tB4MtH9yHNkT5uQM9oPyS87S1m5xa+OmS+kbG
         C/Uw==
X-Gm-Message-State: AOJu0YyOGbs7wS5vmYSNVJUMap6pq2qYDiNBHxdnslfDwuWbeiLTkITD
	t0j35e4cHW6V5V44SuEahweNyLwBeMNnDSSZwGCXbxwqKXn+N2Np2qcNs5K49g==
X-Gm-Gg: AfdE7cmiot46VPkB8biYgrnNOvd7xENZaN4TmD43N+EFUPGZHdJQQ7Y0KICmeF38r++
	Aeia8qCiSTlUlUfzvYV4k+Q8MxGp7zfaFJQHiQ8QtLvY8T0r7CsYdM2jRvdoYlv6wJR1+nqPsl1
	q4URJxgSH+CwvRPdtq9FNgLTGXh/N11A8joq7dL8VM5PGAqZmexpI7awRTO3dXOr1en8bOit2I4
	i8DDC4ArRwNTiNIlFRfljT7o0jj9CiNiypS08JJe93rAsAJij+nT4zCMMBCtA8xX4ROdsOxieOK
	NF3xfcsE5SuBj2Odg6SWmRH6QdoRVGiatHzXeQbwxjw0uKF2TicFoyYMlZUlSO/YhJAhu64fBMX
	+0DC2LNM6/tgI10tVmGFJQgnB1hXEp0D+qQs+CoEG2XGS1pF8EU/cfLzihJURO4jlwipg042+is
	cGaQU89Kf+r87WzXpEU24Jgdmm6WXV6pONd3JyOyLHi218ZHvtUozdNNypLytwpldKlZmyQDVqZ
	sSjOFW2Esf2sDahtVxrjXfi459/VSgRyPKqpLK/1ekuzJSnDw==
X-Received: by 2002:a17:907:3f20:b0:c16:13c3:b1ef with SMTP id a640c23a62f3a-c161e97ef9emr83665666b.24.1783766455259;
        Sat, 11 Jul 2026 03:40:55 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:40:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 09/17] io_uring/zcrx: split dmabuf unmap and release
Date: Sat, 11 Jul 2026 11:40:02 +0100
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13966-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
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
X-Rspamd-Queue-Id: D6F17741455

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


