Return-Path: <io-uring+bounces-12794-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHV2GrI3wWm7RQQAu9opvQ
	(envelope-from <io-uring+bounces-12794-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:53:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE3E2F23FF
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E20530B13E8
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70BF93A963B;
	Mon, 23 Mar 2026 12:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j5n7BmjV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346683AA4F6
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269858; cv=none; b=Pj5ogvtRYpeORvVYN3NsqLEnpoQPPMJpDS40yAgx9ZtGOx2GxGrbamRg3m2NYyIZ/CrNQago9wc4FvIdL0/P30MQsewXPDu8MoMJaEX5yGYb1YT4Ky0tlP92Rn1KuArdQhX2+JSB7yrEQjot6xI48qoea6k/Vtb96fEg6fZtBKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269858; c=relaxed/simple;
	bh=nyXujVSAemKVxOwc/hOhlsm7BVV+CghXkk7bTjUaOtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZa+5xzTodGKG/D+W/VlZ9/pkdsC0W1QFPVsqg29h24s73RsPitMQltPAbl/RNCYlGmC4a9R2Tc+Z5StZ7So31Dy5nMR9+zI/xLZPVLxHmfTgkyL1FW8B/9s6fydnweQ6UGts5HOpcXRflg0NYz2davmkq2qITgGPj794kV7k8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j5n7BmjV; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439bc14dcf4so3516628f8f.1
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269855; x=1774874655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhAZLUfx73ma5vDDrIJbD3hLCOk/0Ar3kV4twmTvWvc=;
        b=j5n7BmjVrFq1ophIpLLZsjq2gibL4XxCDO1BjJKsZGprxB4RL7OP6MhqED0MYE5QXe
         gbm1Bw4bfoRH79NLHV2EQvbEqvfY70/GWZb61GMinqQJR2hkCkgHj2y2rjWgfLSG7KAI
         Nf1rvEjbAwhNf5FC4Nzi3qRF87bW7mtJQ1PQu0Gi2nKLaFSOgxjlvZRNCrYrmtpHO4ax
         jFua1rmlGq97x5955a133W5spsqBOFJWWnJ6exsT6rOM6lxFLKdmpPr6M+p6nG/1WP2U
         7G+KPXbx4LDZSo9f5Ne9NW2FMJPOx952rXBDkPUk6yndFYdReyhV0i/RrUDXUKKp+MrD
         0obQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269855; x=1774874655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QhAZLUfx73ma5vDDrIJbD3hLCOk/0Ar3kV4twmTvWvc=;
        b=lKLcbrv9TiOr0VE6He6srywnr6dW+H2FLETKR2sB4mupS4qPs3yYYylF2sUcVYVlxd
         97cZfiC1EVaA+fwNwFIGlDK7yaVaPgRLK3PvFc4JngWz+y7FPehwEztIXUxzuw7pEzCg
         VJCJm62meLF2xd4z4nZq+5lI3uZyJnl67HuSpcBzQbaLb7F8Oy8+h2+PrIrjEKMdVMlN
         /OkKi9ugQbx7nV3DzjCdRI2cYQFHqxJjHYK+2464IA+g28Kd9qT5sns7HeQ5fhE9P5Nr
         MKU6SbRHISsa8I2rNb1eJb/o65y5I9RZRataIth5yalfKJYUMYlVCW1VygoeRruDZEpw
         XWGg==
X-Gm-Message-State: AOJu0YzGsLeX74FwjpY9r9rIYnxRWBfjY6+2u5p7spCNEON95a9+S1to
	4sxbDXFuohGT9ovLnFJPytm8fE7PtbDjGXmWHEgoydwPPmLP4bBRKRQ2p1zjaw==
X-Gm-Gg: ATEYQzxa0McFgbVKFNHj2GKxOUGKD1asmpx25cSKr6/Fr3LGrtllR9dNa6F0jk9uKtN
	OpwdTFAbPVYmItvCLIahPlwzOHF8orusksWJyH/4KHatGKiE049cpmoxrCgdUAPx7rzqeACh2AQ
	CcqlM2QAhcskoJ3SQYROXGVCUq1CDKf603lhiNSo90UITai21ygIfe0nsHX3KGv4AX11dXO20xd
	QNygAlbW5iRmJ+EDo58fwy5REvzsdbRJf2jMlE5UtW1kDJmVKDAq7vTCla0pGGpDUZ5jvtcS7OD
	tLXx6U5dwt5RAOqARi6fte0PkIp5nTSrOwCB+y2ihHp+Xv9OC/QFchOvxO1qlI+XxDwE0r/zVR+
	zmBcJQ9ZP9X9wuAE9IcgOuih8lJO7x+gA1cmBfaFCaicgkP6a16DyzzjA4vY6gnQQL8zD9pGWVh
	ymthfeSkPs8eBi8D8OKCLYkia4GE4OjSIybNyEJWRSTqIYWSRySTSFGfxcWy0SwLwZUn+Q5zGBn
	jn3a2utYw==
X-Received: by 2002:a05:6000:471b:b0:43b:46b0:fc3d with SMTP id ffacd0b85a97d-43b576e6f50mr24969923f8f.5.1774269854978;
        Mon, 23 Mar 2026 05:44:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 10/16] io_uring/zcrx: warn on alloc with non-empty pp cache
Date: Mon, 23 Mar 2026 12:43:59 +0000
Message-ID: <9c9792d6e65f3780d57ff83b6334d341ed9a5f29.1774261953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774261953.git.asml.silence@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12794-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BFE3E2F23FF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Page pool ensures the cache is empty before asking to refill it. Warn if
the assumption is violated.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b4352c7b2d84..04718a3f2831 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1073,8 +1073,8 @@ static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
 
 	/* pp should already be ensuring that */
-	if (unlikely(pp->alloc.count))
-		goto out_return;
+	if (WARN_ON_ONCE(pp->alloc.count))
+		return 0;
 
 	io_zcrx_ring_refill(pp, ifq);
 	if (likely(pp->alloc.count))
-- 
2.53.0


