Return-Path: <io-uring+bounces-12175-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNfiEeFBjWkT0gAAu9opvQ
	(envelope-from <io-uring+bounces-12175-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 03:58:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA9F129904
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 03:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A7D98301F175
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 02:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C09821E511;
	Thu, 12 Feb 2026 02:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xpW8Bz89"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2624C223DFF
	for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 02:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865118; cv=none; b=YsTHK3v/xDZJ7EowHej0ACGDTL2yEywXMi06NW25A3D3BE/NZ+uLv/sPVKsl99Em+Mkhkbjufp0eF1bCNNWCNkFL9ch3HJ5RE0/5R7tiFGsl/Oa86dg/ERDyZ3zCB3b8C7RKdVCVfmmjWpWX0OSSDGAvpcZul4KugfqquDR80lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865118; c=relaxed/simple;
	bh=ZjcHhpjr8Jlh/80PSavUMxcnLfZL7ggdzidtpDIwV4Y=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=QwbRET7afAL4jFWqxr7qPR2GJE1mzfv4pS2twT5DOe5xYt4LxhawZvAdfdLs/pyz94uAuLFfhs/U9uUDv7S07YRfHOapWK+cPXxYhj4xt8kZTU/BrQ9iuSPiidG+rPoU7Q3y6hi8/4PDnohl3LAiE9odtQyj0gZa0lpyVoJ7WPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xpW8Bz89; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-662fe3ff6f6so3841906eaf.0
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 18:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770865114; x=1771469914; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqXz1mPTRHCzh4AEKO6cy8gaIEOzQ3Y/zrDZiBvo2hk=;
        b=xpW8Bz89ej+UThW8EbLEqNiqjkjRSS6Bl1KK3YCinK3smi+aVXAr5tjSKoGmVf9DTp
         ZBMJ04jJPNT8OQBer7O4BROkKTTcVPUtplIwK0yWbvCamr4lKlH+bTSs8YMzB0iVvuyX
         mm41getJfW92KcdT4ry4eWEEcVAwO1KRZufSUZl1x+xeLaydkeNMsG7JDzqj0+m1gASJ
         0J7beCv88PaAWBcojyb+cTTCULPKTh+geodRrqVGHwQUpmuUnv6Lzs+zPUCIy3wsEwMr
         upwHhkQGqHiGGLHERWlrr1AhX5LC/1NlrUOO1T7DGzmpgtLNBl4+PCfJyayqM4R2QsjT
         5HHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770865114; x=1771469914;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lqXz1mPTRHCzh4AEKO6cy8gaIEOzQ3Y/zrDZiBvo2hk=;
        b=DiqRBCgtWnBmcPeb1Tmj1bsplzu1yK2+ayA0Oel2zdVDcPr9SAtK+0PyShQ6ccDXqj
         6CDCv92ISGvgxSsWkNaQh5FPJet1eThTJQWbYudj+ogrqLFWUIxxLGP3BKlT3jJXwOPx
         h/a/AgWg9ncEx25FOqe1pZWuZYtJnPjP5pHmuJqn/EVTC98UPOt3t1U8Ryl7A+A7l1PS
         LBoVyuCjqkFduJVh+lMGn9yrRn2O9nmOLWDdrh1krEPkv44fTo0zqETo8WIcIHoDfiuA
         0egKj6FiiYgrmobLIq8MnxVH5IVP5+3ZeIpDSqUQlAeaJTZ5bpVePLkAl7X0aPBXB85R
         oevg==
X-Gm-Message-State: AOJu0Yz/BdgFSbiJfi6PBM8anXPlUxAltpnMdo4DwphQkhZ9DMJtwxiK
	uBVtwK9GMSLiuzwyqXWzo8kKcoqHQVhlLRy0BtpvzOTMjd8occfo+9VT0rUBiWT6hDttmn3hesz
	yjGqvoIU=
X-Gm-Gg: AZuq6aKQZox1Bn40eVUJTMjZNKbwUdMzn841wHLaxDNPdE97h/8Caxeo5Wi/7gzXxoA
	PnJGa1Ou++3VniRK0OjevP0LafdRyQSEwuUbYYPnBmlSRnZA98TP813F6wu7sVG9maW37JICsdk
	x77bGYkSuzQ/as9hCi9f1QdK88ssIE/xCZskCznxJs41UdjlV+fpFxEoTtzclWYbPzZoR9t0ySF
	dDsA3ZnuLq7zzZxF3pLEF/WikBtamybd5I96RYe2OvmDVhzNdccMKyoFwMYZf993dE9WQRUY1xk
	v0xxC6ney9NLND9UiN/GKIgLBf7AOxH2Cx/HFqrdVUzlvHCBojKW5QDKbGymnIUg5eNMi/1Yd/q
	AZIW75LCPwwvZD3TPwyNcNSGiVcnTZQTGFGu2NbOpGe8uEyvQhkQ4BGThylpbXSLmB7hkfvYNJs
	Z9xvUVhuFXQoah5zv1YXwzawsVu5v/DLiyaKpdUyyTEaThfrRfV/LT+W98osKUn6CXpSx9CPusM
	oaIy52MGQ==
X-Received: by 2002:a05:6820:440e:b0:672:c797:d74f with SMTP id 006d021491bc7-6759b2eb840mr534822eaf.61.1770865114546;
        Wed, 11 Feb 2026 18:58:34 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6747540780asm1840596eaf.9.2026.02.11.18.58.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 18:58:33 -0800 (PST)
Message-ID: <befde718-f52f-44ee-9b6d-5cd0b6a06bfc@kernel.dk>
Date: Wed, 11 Feb 2026 19:58:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: use the right type for creds iteration
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12175-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AFA9F129904
X-Rspamd-Action: no action

In io_ring_ctx_wait_and_kill(), struct creds *creds is used to
iterate and prune credentials. But the correct type is struct cred.
This doesn't matter as the variable isn't used at all, only the index
is used. But it's confusing using a type that isn't valid, so fix it
up.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e1dcf101ff70..3a2753f6b444 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2403,7 +2403,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	unsigned long index;
-	struct creds *creds;
+	struct cred *creds;
 
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);

-- 
Jens Axboe


