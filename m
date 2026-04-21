Return-Path: <io-uring+bounces-13074-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sJSyOoU552no5QEAu9opvQ
	(envelope-from <io-uring+bounces-13074-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 10:47:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E50543857F
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 10:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2C3373008CBD
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 08:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A61D36680E;
	Tue, 21 Apr 2026 08:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fItJrilt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC58B2DC783
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 08:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761215; cv=none; b=aQV4gDoyOKJGyDAYOGbHZMKGHgQGRvNNk4kSQma8natO7mKP58/TTwpmYdX/dzsD2exxUUbtmZD9NXPrY34j63nLc9cNPzuxMrhSTwm3j5b1TL/3frmN8q0hTEojko0ymEQgXW2K4bz5H3XfF7BZ/COEgLWiZ+SQqMzj9xCdPOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761215; c=relaxed/simple;
	bh=UVKjyWhi4na3bR1TrYbkxo/ZBEsE/cRVNqrrt/ZNYmY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WiWztrEX6VWs0m4YDhjN4pEnPWCDEoSc+PxRAGlkTW4YRQLFwbwoG8FiltcQR4zlr0+3cdyO76rLzDL1b1SLLXTll1MiJvWxpFgSArEJGlMACGFzhPZ7QIQaDBiOvc9KwJ6FE+9REKWlfzNu27v/q1bv5RrgR904lpcL3SfN7Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fItJrilt; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d572f7437so2605144f8f.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 01:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776761212; x=1777366012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLQJdsAZvFdCWNDqX1fkCXL1YPXD9Vh5xaESVcWbY4Q=;
        b=fItJriltH1AAwfyYUlKQpWiV/3UsTlk0iWiwgp9y92HQZ2rzrpqM74npZIof/MVTy9
         lglHN18wLlC7MO6W6AcC0LLOxQXbtzlaoprPbQAb4P5dNbgLGvIdZDTOT/o4oEd1McJV
         1K88MdwjdU/dFjmuM1aV4V5JA5UsmMVpqNGvEaOme4DPwfGtMcX+0B2RIpDwu6izIWsC
         x8ewb1R8k68Tbym03e7LIsHsynUkEZqFa975xW1PwLYiGGCUtw3C0eyWnKrcbL1AihYW
         EEEZgFA3vPEBC/zlUY0Ghrq58aLQHDTxJ2jKLmCpKBgLVZIOmNcerIZxFmXXsoS14+vg
         BfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776761212; x=1777366012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLQJdsAZvFdCWNDqX1fkCXL1YPXD9Vh5xaESVcWbY4Q=;
        b=b9xkY9fVlcvmdHXONkY3nZZoPtQHZfMvS5HqLGGlE2pUTm/XFtWvfk7tggCFVgO+7p
         36A9MoAyTtwe6lWmmru2QWwM0jvHOU74AD9pFcNJFvbwRYlOB8B2iK/TiLuUd19LepOV
         EU6j38zCNOWEzownYGYkMQeFvAS1PnUwe0s5W8jVdtSjeh9uTwNtxK2ngwvk9g+RUvrB
         Sp9VqqcNyk54g00jN22kFpsb2zmYL3RX99ZdTZGVRgpV6VdasiMY67/U698YwIPLSjeu
         8dmgE/o7OpD8KtqIEyDGO/k32dPCjOSu0IP8XFjop0Sq0RHnbm+HWbuw7YkWrsmHtcR5
         qChQ==
X-Gm-Message-State: AOJu0YzjnRP79Pk4AcvXxQHum/T2zULNVpvXk4ATpkAUTnT4m72o0Fil
	M/d+H9soJQwWa0L2Xk86g29WvA587PCjY5of6rgdKa9m85n80SqataOE5K8UIQ==
X-Gm-Gg: AeBDieuKzr2CXxErRqmD87pmieS1iTDvuKSkxDEumYYFAyHd/UW7eFHg9LhZwcfkNmT
	Zw08JXRWx0j36QWBxDMymQ5vHJhQ9nN/xyUTIhmVdUNZuNKVscCfDLAmBNcIbAkKu5EbUlh3Yix
	xlCKC67w2wQV1eP3rdZvI63IY0Ypdcc3TcEhp0PNRWLIr/Mjw9rjxOV5YS55UeW6unCjelWd1qZ
	KxO5BmlEC9WdL7r1IRsDdRgcbsmNB/AIUj7fwt0L+pXTDjhr0PfiEpF52kRT1CFKcDXlcgcw2Py
	pFcEzh0ADdYB/49FrRvT0IP2hqyAKQIIN6bUcqQ/B0SIUtTQvOFFlLP4s5aZuD7Yha1J6BIr2Q0
	z5VV3mtIHPuVE5PWfRUjztX3O0H1syP5BCZ8NaO5AaDmVPn18iiZiHPdzxZNhcTU47ZpX+6EmuE
	JdkKHJqhar4fHuvTWeh0E83U9NDaMAryKypPPTuvnGqsFW6c91O+sDxaF9ixe9INPTaWaRqq46L
	AQ6eLTr/2GRbzyICpP1
X-Received: by 2002:a05:6000:2909:b0:43d:7403:4b65 with SMTP id ffacd0b85a97d-43fe3dbee20mr25711540f8f.6.1776761211757;
        Tue, 21 Apr 2026 01:46:51 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:e3a7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cc07bbsm38374432f8f.11.2026.04.21.01.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 01:46:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: fix user_struct uaf
Date: Tue, 21 Apr 2026 09:47:04 +0100
Message-ID: <e560ae00960d27a810522a7efc0e201c82dff351.1776760917.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13074-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1E50543857F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

io_free_rbuf_ring() usees a struct user_struct, which
io_zcrx_ifq_free() puts it down before destroying the ring.

Cc: stable@vger.kernel.org
Fixes: 5c686456a4e83 ("io_uring/zcrx: add user_struct and mm_struct to io_zcrx_ifq")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 9a83d7eb4210..fab3693ecb0d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -579,13 +579,13 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq, ifq->area);
-	free_uid(ifq->user);
 	if (ifq->mm_account)
 		mmdrop(ifq->mm_account);
 	if (ifq->dev)
 		put_device(ifq->dev);
 
 	io_free_rbuf_ring(ifq);
+	free_uid(ifq->user);
 	mutex_destroy(&ifq->pp_lock);
 	kfree(ifq);
 }
-- 
2.53.0


