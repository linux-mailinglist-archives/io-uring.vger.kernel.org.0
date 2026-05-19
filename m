Return-Path: <io-uring+bounces-13426-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKxTORxODGqxeQUAu9opvQ
	(envelope-from <io-uring+bounces-13426-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:48:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB6457DFDA
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 939DB30A626B
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 11:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A504921BB;
	Tue, 19 May 2026 11:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbRIPxJu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8FB4A33F2
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191088; cv=none; b=sU4L2JbB5/5Kr3GicjvOLnGnHlKhK7HXCskfB1ojuHHkRE4F/nVLIms2vv2PTmIr218A/UlHIjWN9Pd6q4pB6qjA8heSUtiR4WsHgFQQKxW54chhVHcTyyJ07QwPMra0waHJplqMPXUwv3JTPqclJ69wcb0XnHDQD4Uqbgy7hQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191088; c=relaxed/simple;
	bh=scNV3aEvCZFYfojrGqLJLUQ/q1KagJoWXmGvYlmuK5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=me7SwLsvxWjF/CsqnLi+zFMSUlGjpn6hftSXFXUKiFD8Ovz95RYicVLy9XpXJUGBmS4UvGv4+ItAdEiXFMaGyx2UUKVNqGZ7DjqIbYuN584K9xvKu/PogjaTMbOXJdjUiF/D3DRuAJtkvlcVYd4PMPH4lWmmF+GLE5Q+glJQlZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fbRIPxJu; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so20115965e9.3
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 04:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779191084; x=1779795884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vekxEVR9cjEWvd+yklsfG4U9y8wEBqzdg9c23yI98co=;
        b=fbRIPxJuOd5fZK8lNeSqSUSPkOPSPOxwCgimahZ/drxvXVUrS/U0YVjCaLpawVVwv1
         qxrWl5gPWJ8UznG99uhzwJ9GyQ9HrTZN46DSuFm7n0Vm2DUj9ZWZ3IxkVw0uNcaM07OR
         ae0fC0VdMpWiOpi7D4Sj78ikK3NYGeqfz4rCiZDslEYXtIS8Q14nF3pP0PJZzAlj+YxS
         m9EMYtfqlGtPIs0Keu1O88GkMlWE+jAIvwnzBCplG3EeBAt97lGpadyP7N8kVH7J3VPs
         bsfEGEvn8JWSJP/nUbLsA/H1GElw+3bz3WsRWjwL6TmBq3mB0o9yc+dD9hdO/coLKt1N
         748w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191084; x=1779795884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vekxEVR9cjEWvd+yklsfG4U9y8wEBqzdg9c23yI98co=;
        b=fUnaSoMWqPP/c4gDuue/HwzicKX+ZmXgRl4Bbef59+0q0bldQf/x9b3KzUOrwWUMw5
         OQ93qB3JJhwqcACCrqHV6FyhIbCKmYgMzMOezOYdF1gtsNUWjWp7fs1VNtTkEwrb1Rww
         JAn9eRv7h3boFOXfopIQykwnowwrCq4f+6lkGOpkpJpgeVz4OleUcfAITuepYN98jZXa
         mP1forkCpw0m7eyIBsdN4xdXPQrZkFfTg5tG7/FDVdnJHSmAH4ZwzQ9r6D45zgTvhspJ
         cj/qb58V2N3Rta5rDWgh2uYTY6+TJXe3OI943pjJ8e60mZIksF+fPZi08gIlVs/5zYep
         roNA==
X-Gm-Message-State: AOJu0YzzszDPcEcxROzckn9hgTCmhzC9oD6JmQKOHJkzv3S9JWMflecY
	/QED8CzZZJt+WtKRxdMObwXnhadCcStVeF7RA5rC2SWTrtZVar8eMHe0R3XZiQ==
X-Gm-Gg: Acq92OEzaVIZCeCC5gpVIsNmMxT3U590+QYBSHp3vvprCLXHLAd2awiJyMD/RnbUCTj
	g3dr1lsUc4ufaHqMA6R13JtvmZc1ysWoNMns6o9m7wNwhee09hjNCy9ZHrJNliLhoBHkFRBXFzS
	MgymVOHpKof+l5SzfC1AVeWWWQv8QMDxqx6RbgX/6Pu5tpTcYuKLjnCQs8N85gjiSu88MUKLRjY
	s1L6x6aSz0W5xQUA0LlHEGRmrGRC/9aepPGiNRUMbLtE8987ku6mlybDyE65jjXe4YkZXTWKLb+
	csPei5B31ogYzCd6jmfaWwi9G8QRN7dmF+OjpeaacXclVCKNY3zZ2q9HF8+OhHjNPubs34wR7s9
	+mq86FBnVg/taSw2d1VP5Z1FOV1GO5o5IHmhMZNhD/NSSI14vfA2vJDRFpiNtwwIc51eWXiTUfg
	LxxzEzEjvFJzxUs4jYG18exIz4j4/rUe1ccBUm6WGsgmt8iC4crIKxUFW3nO9BMOvLoHZ3LVug1
	9taItV1mCWF7+l5g/r3U0jG7uK0kRyQb0/1vnAs
X-Received: by 2002:a05:600c:630a:b0:48f:e249:4094 with SMTP id 5b1f17b1804b1-48fe632663emr355999715e9.18.1779191084222;
        Tue, 19 May 2026 04:44:44 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5694f2csm323392445e9.4.2026.05.19.04.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:44:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH 2/8] io_uring/zcrx: poison pointers on unregistration
Date: Tue, 19 May 2026 12:44:28 +0100
Message-ID: <19112d1412539dcfc04a0317b5812e968623bc51.1779189667.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779189667.git.asml.silence@gmail.com>
References: <cover.1779189667.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13426-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 4FB6457DFDA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Nobody should be touching area and other pointers after zcrx
destruction, poison them instead of zeroing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 60cef10dc491..4bf6635c222f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -245,14 +245,13 @@ static void io_release_area_mem(struct io_zcrx_mem *mem)
 {
 	if (mem->is_dmabuf) {
 		io_release_dmabuf(mem);
-		return;
-	}
-	if (mem->pages) {
+	} else if (mem->pages) {
 		unpin_user_pages(mem->pages, mem->nr_folios);
 		sg_free_table(mem->sgt);
-		mem->sgt = NULL;
 		kvfree(mem->pages);
 	}
+	mem->pages = IO_URING_PTR_POISON;
+	mem->sgt = IO_URING_PTR_POISON;
 }
 
 static int io_import_area(struct io_zcrx_ifq *ifq,
@@ -403,8 +402,8 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 {
 	io_free_region(ifq->user, &ifq->rq_region);
-	ifq->rq.ring = NULL;
-	ifq->rq.rqes = NULL;
+	ifq->rq.ring = IO_URING_PTR_POISON;
+	ifq->rq.rqes = IO_URING_PTR_POISON;
 }
 
 static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
-- 
2.54.0


