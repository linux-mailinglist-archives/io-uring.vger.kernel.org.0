Return-Path: <io-uring+bounces-12207-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHrlDlP1kGkCeAEAu9opvQ
	(envelope-from <io-uring+bounces-12207-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Feb 2026 23:21:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA52E13DB3D
	for <lists+io-uring@lfdr.de>; Sat, 14 Feb 2026 23:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A2773014544
	for <lists+io-uring@lfdr.de>; Sat, 14 Feb 2026 22:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9B331282E;
	Sat, 14 Feb 2026 22:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/wMUkSn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BEA26E6F8
	for <io-uring@vger.kernel.org>; Sat, 14 Feb 2026 22:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771107660; cv=none; b=CVhiSihpWQe5Fp+P8ZzHCXFupl0ecE7xtCs3OWiGiXaaAp3Uwv9kEUB4YqRRTdMOpDSRUNkdFNRbqoG/mhubHBT/TPUXvhdZKlXiP2e6lubwJvp/k1A80mTKUaasqSXTut/iqFYTks1JR2Q50HFsqtYzbUmjAPvAaflRoB6ZJy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771107660; c=relaxed/simple;
	bh=frTtZD09f8Bf8Zgam8XeXKfFPpeUui99DGoCniHzJ5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iZz4cN5ZrEFjNjWBxyqkfmT+cDkQc4GLUlIdROehYML6Wq4tVIAGZC443AZ5L/7S+LbPmWKinqPi7E2E1UR9tOB1qTBi0uuk9CknyyzddBB3xzA63KsSg5BwoE+u3c37p0XIFSSzQiZ6aWlqEYOBykTVSFACUi1rzUiEgWGGUTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/wMUkSn; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43770c94dfaso2416333f8f.2
        for <io-uring@vger.kernel.org>; Sat, 14 Feb 2026 14:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771107657; x=1771712457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tdYzr1MdBQ+TSUvklAXfAzoZEsF9B2NkCtirq2Cu9Bg=;
        b=X/wMUkSnC2FZrPH9FGQFcQXiqsHWe53NgwSGGUl8OdYTzSp6D8Byv8SX8NuL9KyQFy
         bkqfJF55I8ccEpi/R8cQBlY+1V12FGnunfARN+FhNOAtZd3k7OD74mDxTFD/JcPz0cg4
         EePJFxe97hGjH20lmCqD8nUz6z0m4QZyg9K41AZZPmfSs3donTWIKkQk9UdAr+AivSwi
         fR7U24fnY0tsEa1tstYZXzL+StSsr7HgIha8o29Ddt1ZQXrevwwsYgEHA4YTyr2NA0uk
         DsMHeT9/ekO//m1Df48pfoSGrih7s1ekWMVhKmNsZsiy0aaz4YkIKC9b3ANcYZ9st8LY
         Dqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771107657; x=1771712457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdYzr1MdBQ+TSUvklAXfAzoZEsF9B2NkCtirq2Cu9Bg=;
        b=laP/xAc5aO0R6K9KTO+UuyaSa/f9DPJspBFbloOB9hlsGXMF+mqIV0nO0YwhK7bFI0
         YvR+GqmI+jHASe/NBYKhgDIaw1eAWnOp2gqkEE9qhJHUDQfsqbEK3sEmr6obE7BdFAg0
         pzVyWkaxJ4hROyaE/66jflHTyyRWKQpn/L3jXa3AzY+4T/oGOIToyPcEgixw7UZ3CFJQ
         gY75KpVE1MQPIhpu9cqRN1FWJpI8X9vVPDVZa5ZYJbGhPHdJ/9XFgijodxOSkSgmOFDE
         710hAWX/Kyj3Ljmn8Pd2/G/Qw37Pkg8ue31eMTwS42go48gnAGdRnIzA38PmWHbac9MM
         l2Xg==
X-Gm-Message-State: AOJu0YxpfTQvXjzIkoZBvNQO50rBFOm8Bz3vdUfg7CaiJRNFoLJ29Xje
	29qHoKlPzAwXcoRIOxlWC0HwULho6VwA68Y7aCvsjejqFNVUXBhYGJl7DWroQA==
X-Gm-Gg: AZuq6aJPCHc8ICVk6BgI2fX3kg04tCxPjQwjfs70ca6Gg/q+iE0vX9ECxugoNHKiG1U
	FEilwZUT2sX6owHV1w52vHL2HUAnrvBugu7OiDIMuY2UHwpPeYyL1nZOBDapBlB4MwYEpqRHED/
	heF3sgnH8QdOcUAb98Vw/N6tDq/KsCnfrKZ93qxxGhgSjnBPgvvfym6Bbik/xmrsD/WTP2Qk3MS
	xicBqyNNznDiNluOGgPmBe89ds+9mzTAyWvBIRJkTnmIfyHnziRIaoR+uDSxCqydgxjmV7UZvop
	N+yibzRACKaYtDhrUeYDTc5ME8ttog8w9uKeZy+78QEshjka0SpaKEVa2xr3IBKvbDifP/aDr37
	OCAeMjOEnOXP0pRrb9nPqYQA6TdxGg1T7CcmNQ2tbpDUi9ob/2UCS2hjEwQIX/XA/DuqTPL6MRD
	HSNrP4W1Vjuy6w5A7yqda57HO1TQnLzvSEC8zKczlBWLjdMaofk6ivnskMJ2MX6tdU7mkWDk91i
	lF6SBkprs0lT8Tu/T5KcEGd65NFPQ==
X-Received: by 2002:a05:600c:1d0a:b0:483:3380:ca12 with SMTP id 5b1f17b1804b1-48373a74357mr93484705e9.29.1771107656914;
        Sat, 14 Feb 2026 14:20:56 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483801ff9b3sm38743745e9.13.2026.02.14.14.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 14:20:55 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: fix post open error handling
Date: Sat, 14 Feb 2026 22:20:47 +0000
Message-ID: <9d9cdc9ae6c6d59154e68f65054d75893a749d14.1771091720.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12207-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
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
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DA52E13DB3D
X-Rspamd-Action: no action

Closing a queue doesn't guarantee that all associated page pools are
terminated right away, let the refcounting do the work instead of
releasing the zcrx ctx directly.

Cc: stable@vger.kernel.org
Fixes: e0793de24a9f6 ("io_uring/zcrx: set pp memory provider for an rx queue")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 006e1bfefa5f..b24d1da2e1ca 100644
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
2.52.0


