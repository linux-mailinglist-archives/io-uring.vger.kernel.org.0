Return-Path: <io-uring+bounces-12487-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eFdVHGGUo2l7HQUAu9opvQ
	(envelope-from <io-uring+bounces-12487-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 02:20:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C449B1CA398
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 02:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D3473037E7A
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 01:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F131E2606;
	Sun,  1 Mar 2026 01:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMzVsyew"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C183FC8F0;
	Sun,  1 Mar 2026 01:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772327868; cv=none; b=Vt7xgyjyrEn3ut20nEUtkBBFBmrBHlpsMzp8fLbmeaCupgRgN1BI0svgXriTIvPWM9u9O0GkvWBkbwOGYSdjJTXYjvL0iuAuvjqvk2FGZuw8MccXINFXA0E23XoHYpXYXl41LFGWuzDS9Bqp4rx82BG5Wd+Rwn9MnX0nGV6ZmWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772327868; c=relaxed/simple;
	bh=KUiwBsCvnldM4Mf66cLudWCkM/yFgxTv4Tb3P9AfQDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ayw29fFN9xVMEcys4tky4Ez0HwIiC+bcp60kOCWtVddaB7LgGknnZr8aMmvAJN+G66RGpKHkK3O15OHDdpU4shESEwxwBQh9fY2II/OvulF9vySKDNdm/CNEDcktrwLkAa6Ave5iV0MVrrbabjC3ye34OznF3pSUdXoNdV8kTf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMzVsyew; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AC7C19424;
	Sun,  1 Mar 2026 01:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772327868;
	bh=KUiwBsCvnldM4Mf66cLudWCkM/yFgxTv4Tb3P9AfQDA=;
	h=From:To:Cc:Subject:Date:From;
	b=FMzVsyewIzNaAKi9Apmj8Akvet6fxBDGfhKfVzfmRB89WAvskXBWJzQ5ggQRDWYTX
	 0i78UGoFETVTYFVELjI2G3Ph5tRww+o8OfzOhGrCeXz+dmQijkmYG8QRkKBBieGYM2
	 jKwaJkM46damdolJmjdI77GCCaEOYR4WrHwnRYKa4BmLxZ9Dotap8k/eClWHYZob0B
	 yBLHmD8/8LgQgN0+b0u1ha3VFE+kdDCKG9a+p+mTWZnfni3Rqg/TZm37Bemzlbv1TT
	 7V9IrQ0383me4vcjtj00y30jHllqaqiuQ5A3P/S4oGVSSF7LEyDePB0wR+dqYQZKc9
	 C7uRs4cDz+zaA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	asml.silence@gmail.com
Cc: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Subject: FAILED: Patch "io_uring/zcrx: fix post open error handling" failed to apply to 6.18-stable tree
Date: Sat, 28 Feb 2026 20:17:46 -0500
Message-ID: <20260301011746.1671806-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12487-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Queue-Id: C449B1CA398
X-Rspamd-Action: no action

The patch below does not apply to the 6.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 5d540e4508950c674d6feef1d95463d039bbf4f5 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sat, 14 Feb 2026 22:20:47 +0000
Subject: [PATCH] io_uring/zcrx: fix post open error handling

Closing a queue doesn't guarantee that all associated page pools are
terminated right away, let the refcounting do the work instead of
releasing the zcrx ctx directly.

Cc: stable@vger.kernel.org
Fixes: e0793de24a9f6 ("io_uring/zcrx: set pp memory provider for an rx queue")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/zcrx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 006e1bfefa5f2..b24d1da2e1ca4 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -515,9 +515,6 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 		.mp_priv = ifq,
 	};
 
-	if (ifq->if_rxq == -1)
-		return;
-
 	scoped_guard(mutex, &ifq->pp_lock) {
 		netdev = ifq->netdev;
 		netdev_tracker = ifq->netdev_tracker;
@@ -525,7 +522,8 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 	}
 
 	if (netdev) {
-		net_mp_close_rxq(netdev, ifq->if_rxq, &p);
+		if (ifq->if_rxq != -1)
+			net_mp_close_rxq(netdev, ifq->if_rxq, &p);
 		netdev_put(netdev, &netdev_tracker);
 	}
 	ifq->if_rxq = -1;
@@ -833,13 +831,12 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	}
 	return 0;
 netdev_put_unlock:
-	netdev_put(ifq->netdev, &ifq->netdev_tracker);
 	netdev_unlock(ifq->netdev);
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
 ifq_free:
-	io_zcrx_ifq_free(ifq);
+	zcrx_unregister(ifq);
 	return ret;
 }
 
-- 
2.51.0





