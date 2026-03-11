Return-Path: <io-uring+bounces-12639-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EOLvDqJqsWnsugIAu9opvQ
	(envelope-from <io-uring+bounces-12639-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:14:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F24A12643D1
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:14:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CF4B13023325
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 13:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B26730BF70;
	Wed, 11 Mar 2026 13:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bStZEc5b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EA4306D26
	for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 13:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773234826; cv=none; b=GFAgx2utNhrmms19CFYtaxVG8LjGjfTGKJthdgT4ZmUnRvVB+myV35AdDoqC37FMPWAFNumOQQbBlTernXJpIMp/gdZ2lDxI3+PKltvBhHzLwU56fE/7uPcbK2H5dGBR1e0k4kwLvrR4D7/xCkShUszzlrtZRXBTOJ75zWMszhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773234826; c=relaxed/simple;
	bh=YIo57N2vcHVypstNB2cXBU3r9AT7FE4ZbnUQ6vqutMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWV5Mj/u606ee3zcdKFcDR/jZ+qZgtX3GqfWH7C1STgaeVxVU6hoKKlnBOvQgRdYlP7suo7iDGcsbHgRxAziOqebdaAp2e5YwjlZzctxPoKr1WKHA7iyezQ4GhpX1/r7iTHj4fkDEsr2wL8D+yq45Lw2RiniGku/QiptIhgOq5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bStZEc5b; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4171ff4cb2cso2172232fac.1
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 06:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773234824; x=1773839624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UT/m7GaBXVbUKRMg37ABmfjMs9kKM0kDkv8WvMSyIRg=;
        b=bStZEc5bEbj8+pARWmCwMlaLxfXHJG1mZrbOgdkShRx/cGMKdvzX5F5kKn/TRr02sE
         Ob1ID38c5nd5BtevF9WvKTYlk9FQEs1Qq+14xgXwFFPBdMzxq5njHhH5uRKkQPwCNlqe
         auHQtDJSyrMfo567WcUHJrYaOsiZNB25k+DWQzO5NE//kz0moiMOZit1Eo/V9cYsq9GL
         CNWHZhlU0lIms9P8AnG3hHn9sHBRXJHNmoy4ExKng3VhQP6CJ7FoXX2+H5BjPAJ6e+QQ
         rI6hmgz4+CCobXXRvrbgoFO9kZ6aKjdM/1dv39IWKQsm0tNiXSG9IDUSbZ2MwaNbovrA
         I9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773234824; x=1773839624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UT/m7GaBXVbUKRMg37ABmfjMs9kKM0kDkv8WvMSyIRg=;
        b=qV/jRa9c49GWf+blbjT+Bodw0RKz8bBepAdy8CQWztHDKXaWBUV2glKFZjlhOKfGTb
         xojhHhnaIPpw3joBjkhx9GQiK3jC3k3vNqP5VPaX3AiHonfMEWBk6+4a3cLKBq0HYAhq
         P7cuAwqeZWyPQq03qMPS8xhWOqgFLUQwVX/NEyzIA7IOjruienLN9a+DrFGQDTEUFGmP
         AuWTJjwyZ3KN4+xtsLDffLg/DmrrHh4+Td5cAl1S1OAjFrb15NoHe40A23wqbn1UjktN
         b7VtCekCgo8kusVKQmsECooV7NBZA2VNl4oUAap9D4RGlWqQ4EosK2tb7Y7UV73xM+PZ
         UUvg==
X-Gm-Message-State: AOJu0Yz2axOjcBLu1OkYS+nQHA8vxUrPCu/DmS3IsbrQ+hN+UPfPPa9j
	pptizbT5eCgbYcGBV5jbXFlQ4WcPJUVIE0kSuxC5SMSnWslHkl9cC29vYwZwNMgTVlYb8WL23pQ
	MlvFEVyA=
X-Gm-Gg: ATEYQzymp22bjtSxRaVJdG17xY9bgNRR8+iSo2OMqpoIgAKrcWwBeSLWmZI8CQ6a1BM
	OaxqL4djsouQopsczbguMMZYtnLWoCUcjcnfZ/12pzyxKusMk/AgKCrGL9AVUrp2PdKyS/aDQdl
	D562uiJl244TVe8Eep2GMWjRAF4LWJU+m2XPb1xFyKa5zUYp/o6pNLzjqd6RE2uviLqAPlhH4YJ
	207Q63eebesz1iw7F48ARKTovwI0Ln8xRFQ8EvXLHWbzX2wRuwzxPuGuyCiFoWY57aZFVrxJmOv
	2tLrzfJ9MK150VK7bJlLHDakE/OByEG5YAWZMBG+i2QDg3AgxwZa20YaFgQYjnpIs1cfgx0ufH/
	POsDnTqZeZYEJ5OuagNKOFPhAEEVZ1MylnQr/vFSTGT6niOqbB2nWhZYmWaAoGlf3D+vs+JlKde
	AuIGa+kXDaxA0VIJp+pOBXMvx3afDbZWuCEJ9D7g0rHvazJrAufHNC1CiFyFBub8p1KtDa
X-Received: by 2002:a05:6871:7291:b0:417:4a1a:4376 with SMTP id 586e51a60fabf-4177c8d0c1dmr1527742fac.13.1773234824160;
        Wed, 11 Mar 2026 06:13:44 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e5e8185sm2286127fac.12.2026.03.11.06.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 06:13:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	naup96721@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring/eventfd: use ctx->rings_rcu for flags checking
Date: Wed, 11 Mar 2026 07:11:56 -0600
Message-ID: <20260311131336.197028-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311131336.197028-1-axboe@kernel.dk>
References: <20260311131336.197028-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F24A12643D1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12639-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Action: no action

Similarly to what commit e78f7b70e837 did for local task work additions,
use ->rings_rcu under RCU rather than dereference ->rings directly. See
that commit for more details.

Cc: stable@vger.kernel.org
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/eventfd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 78f8ab7db104..ab789e1ebe91 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -76,11 +76,15 @@ void io_eventfd_signal(struct io_ring_ctx *ctx, bool cqe_event)
 {
 	bool skip = false;
 	struct io_ev_fd *ev_fd;
-
-	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
-		return;
+	struct io_rings *rings;
 
 	guard(rcu)();
+
+	rings = rcu_dereference(ctx->rings_rcu);
+	if (!rings)
+		return;
+	if (READ_ONCE(rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
+		return;
 	ev_fd = rcu_dereference(ctx->io_ev_fd);
 	/*
 	 * Check again if ev_fd exists in case an io_eventfd_unregister call
-- 
2.53.0


