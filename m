Return-Path: <io-uring+bounces-11364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 371F1CF4EF3
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 18:12:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 658DB318C8D3
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 16:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332D92264CF;
	Mon,  5 Jan 2026 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0mJGPaBd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB371D5CC6
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767632272; cv=none; b=ucW1cvsB1//FvZLESRr9CHgjptay0bQbvn9pjlOicmVAMZx65FmZuH7j/sVvINeA8zhZuMmYUnHK78ubMkBS5LOO0n/WmgkMsFl+pbEhhMETHxag/A4RuV7T8z3iiAK04lFn67XPzoX16/JPWNzKnnmTsSqUJkBOTAf7k9MJA5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767632272; c=relaxed/simple;
	bh=WcqhJmk5dcryVT4NVAaRgbNl3QhZOJIpFsmhNwpJE0w=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Qunm875/FHtEAOCAB2HprGFFjOzuZ/Lfx0dUwvjKBvvNe7aO3voWsrZjvy9Y8qva4C3zjJTUhTByHnjMb5lm3+4/ZQWiNSYTcLMwR7ECGJnhkAJeWRNohvlcOpNUhdMBLPxT881dnm85tckk0pu3LDqkEeKOgGfyLphqIwjbYJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0mJGPaBd; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-459993ff4fcso73500b6e.1
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 08:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767632264; x=1768237064; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkgHcUj9sgXC8B5Na7/mhKS6X4Mr8BaP+OBBgFO6eyY=;
        b=0mJGPaBdnMEaEyAZ8UPm6qTVhjkyBLejy9zkpQ3r1Q1OSKEoXE0weVSBM9Xx5yM3T0
         c09OY/NuAcTvSMe/AWEsRNBObfmYq++CeAmJqspCBCMBbRf7fHlvRENufZmgetBn++Jg
         VDvApEOJi0cmvtjC24PmdAK50a18tsTYNEsEDBW1bSEmlVhPQYy2Sqa6Jh1fRg+ziUUs
         mcATS+9jdasrxaZGBXG/3IbDAKGIz4RbOnFFZS+ta0wltLWReGKxrgKyMdocJVdb7ibh
         Y+YAZnUYF+8lLuEB/2spgj9BYu5BUJmouabsPWzpl9iHtFHnnYpOIgHSosOznY5eazaR
         aIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767632264; x=1768237064;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rkgHcUj9sgXC8B5Na7/mhKS6X4Mr8BaP+OBBgFO6eyY=;
        b=i8Gdxnu2twQ4kYf2rP/fTkl+SDtY8E3nQTin46hYxZTvU0YKws8SybR5Q2YuFCxSMc
         AfIJmhVeRez3x8Kf8QGVwo1a0gSN88s+Zf08awSFUcIL+jjSgRaiuZXejbZcGSuGjG57
         9ZtRyK0wgVBVSWxf06wDX3h0vkz/6jSLYt1ECU5nJ+k1swa/agh7fDt78TH1/GbiRXMq
         hpjYxV0cpJoBRSKcgfqPlYFxqhBcLRzZQrHDLa9MoKVGgqqM2ya24ZK3H1ZwNNx95Lwj
         05IZ6B1QEQ20RWhvMJAkDW+zyKm+udL2C4VeUBfI8UFma9NJ1PZCKAh0B/GkCf5Sgbn9
         Urig==
X-Gm-Message-State: AOJu0Yy0ndNoBFquupMzn/TP7QRtGmFqu3I02SzVJhXJo/kUHM+al3de
	fX5XQ7Ct6rcuSzV6oxdiu/xyDoGIIMujVaowxcpex7XEvDije/KTl9nMPKF9IBZVV0+dtLvktNu
	ZQuwo
X-Gm-Gg: AY/fxX5NeGeLmK+PU22eKW+eyJiKHvIWUIFg9kAY0dpFPdc5D8rkI8lvPyIJSgq/yZ2
	L4N2mU5pKzIXi0ck4j+WUn42KvWSca/QOcnxwVCQohYmxBrKpHb3W2FMr+sQEjGtQUMqcx4Pf51
	rPZl2YyJGhyaDLmf/DgWOTz1ANZtIMgNff+c5HBS6fQd+y3tMDx5YHToE7gUEANO1kn7O1VHjqF
	xL7ST05p2UX42oLMOXymS2H+LZOaVKIo7v4k1eQxBL2Az8PHOqXkzDJmCMG5HDdg7o99BwIUPkp
	udVtnR0zWBiZ4fQE0+bDyba2WIGcqxf4ewiTC8PEIb2/sLG8KN44yGmXmZAVy9Eex4nkae5PuTe
	AzFewUzvO8pbgb6jZeeuMiMiq6GN0FRJ1adhanG+tMgb2gEGJPMgz1kMKnn/XuHLnGUX00hI+hH
	TE0iSfbJnOMuOqQCpCtMo=
X-Google-Smtp-Source: AGHT+IEaCftNluCUmXstG2MKAuxrrFHUGOVe5wyaSmkTGhXQgr0Kl+QZfoQfxtTxKUmYcGaPMAH19A==
X-Received: by 2002:a05:6808:1b07:b0:44d:8e2c:41c0 with SMTP id 5614622812f47-45a5b1260cfmr190641b6e.35.1767632264409;
        Mon, 05 Jan 2026 08:57:44 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5bcec2a5sm30615b6e.21.2026.01.05.08.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 08:57:43 -0800 (PST)
Message-ID: <f98f318f-0c3b-4b01-afb2-2b276f3fe6cd@kernel.dk>
Date: Mon, 5 Jan 2026 09:57:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Max Kellermann <max.kellermann@ionos.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/io-wq: fix incorrect io_wq_for_each_worker()
 termination logic
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit added this helper, and had it terminate if false is
returned from the handler. However, that is completely opposite, it
should abort the loop if true is returned.

Fix this up by having io_wq_for_each_worker() keep iterating as long
as false is returned, and only abort if true is returned.

Cc: stable@vger.kernel.org
Fixes: 751eedc4b4b7 ("io_uring/io-wq: move worker lists to struct io_wq_acct")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: fix the actual bug, rather than work-around it for the exit
    condition only.

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index cd13d8aac3d2..6c5ef629e59a 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -952,11 +952,11 @@ static bool io_wq_for_each_worker(struct io_wq *wq,
 				  void *data)
 {
 	for (int i = 0; i < IO_WQ_ACCT_NR; i++) {
-		if (!io_acct_for_each_worker(&wq->acct[i], func, data))
-			return false;
+		if (io_acct_for_each_worker(&wq->acct[i], func, data))
+			return true;
 	}
 
-	return true;
+	return false;
 }
 
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)

-- 
Jens Axboe


