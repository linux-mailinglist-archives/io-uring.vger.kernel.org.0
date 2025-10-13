Return-Path: <io-uring+bounces-9987-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CD5BD5AD6
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:18:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 078E218A7664
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B99F2D47EB;
	Mon, 13 Oct 2025 18:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cwPO4iMX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4409C2D3725
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 18:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760379402; cv=none; b=bJ+PzAFzAFbwOnGMFzgNI7/M2RYZH4FyNXmpvvdCsUP4jEgSIwxssYnJJpWTQHuA+HGXugpKLNEZFzmknzw/wo+lPr2HzD1eUK+RNw/rXqwbuYwstRmvt5NM1y/k1+zTCqvTqqJD0/Cx86MEwOHSZdgHNFw72EpbEo7zhrQzlN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760379402; c=relaxed/simple;
	bh=WBAhQeHWuSIU6j/Z2ZycNdk4uWkOJHAKuAvrDnr9WO4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=SAWBmorjbQz2OukOrA9+u8z9faLkoz62gMTMpURqC2k6AbZyNlGrxuowZCS4Z8sDYlszg6pNlnkStRbK8JISxO7V4bVhVDBLsx+vcQncSZquU9eFJ4fDBNFFd0GHWelxE/drehN1kc6xWWF6noDJenz1SFaR2jivlAwp7+gzGGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cwPO4iMX; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-424da17e309so45258745ab.2
        for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760379398; x=1760984198; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xwE87urIYqut3xS8Cp7ZUntmglnDzIWo96Qel5yEKk0=;
        b=cwPO4iMXkzuwVRZZKNUQ8KCO+RlL01QGpCkH+NaFZC4xqatbUvqtjU0/qsd4Ft6H0Y
         AcwFoD1StvcQHOyx2mo78Xy9ByzhHnIqEjvAQHFyiLAN7jbixwc4smpteALd7MUfK9m4
         whTy0uUTXtj+1cHB1vOsJWNnH1YL+tVJ+sN/rxh+7wAMlVa3aFuKJE7y/MEpZLMF4KAj
         dGnLO+zzt2a/Feeks0+RAkEeC0Bvy74cK5ynm8TCKgSAWdoBTDnI6QwkWjjKTBW6wZOI
         MS4jY9qdRkpI9yVA52vX1WgPbd8hGLDzBb73e2UMkIacZNi/iqVGKBMuyCaKeXx2tAxE
         KkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760379398; x=1760984198;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xwE87urIYqut3xS8Cp7ZUntmglnDzIWo96Qel5yEKk0=;
        b=AfEmIcmwb1CWTa+KR5U0JZnaZ2o49c9P5Jegd/RX/r5J7gZ08Om1byswolGUQ5F5kR
         VkqTZIQI/5WG6rbk+nPLTajs08NzFu1os1uSgyp0oZTRtKDI9Ytj3wy8mQd8IjY4k9O0
         iWbbsAO7y5UDjWv7ajGZusibiN+Y2i/GVklh0+hPFk4AXvzSLwwD+GlF0a+weyW0RetN
         3YUIb59xoKxhyWYs5U0ITq1AWC95a9VpOL8TBOKdchs28C2HOUsbVSA7fT/Uy1gMsltC
         rdkLGXGy+dyWVxxPpuqT52e/PkaqH5X4iuOmOSC2KX47NWKSE7fZbtlnjdB5V2MFjUOh
         RL9A==
X-Gm-Message-State: AOJu0YyqUJKHMrJ7Zh5TKS9wM6HtgE2CETtXYV38BpLyWZjOU1sPKCv5
	TBhHZiVfbdU75ffLeqlwe/dCP0i2vEstcP5n6RRuVFNoid4E0YFP8yq0TvjWTKVdY6WBSIqldGo
	OoN0CEgw=
X-Gm-Gg: ASbGncvj9/OxLmvJCS0LBSBmhHITBmtrasiowBUqi4Quz6tAbvJOCpekmBKSYxD15qP
	hoSTt27vn9G8OQem9swHokit6bysNuvCJhLPQonSWMQATQyPUB9AmdRBIyce8kjUl9wtuceZHQs
	68WApGJZM18QBKETmZiY8wjyQQtmQw04drvYb4CojSvubncCjWOgqLrnZNuSaoTo/Jcu6kpoHxc
	H4UZUqlT4WRHW4RT1OnE5azWIiioVKhGcPj78EpV2f4nG7p6uV0xN/9knmHVsPhGeQVcYsWSvwK
	mqy7Ke3BH7O6FQtbjlnrA2Qv1VFKGhgty4pzM+8Bgxj8xjZrlA9VAtYjACOuJfQHCCT3d1vDQWe
	PpfPUTkHNeewFoCLKynl/xEvOmJrRgnFIlYPT2gyKMOHHZdB8ZMesXBQ6tc0=
X-Google-Smtp-Source: AGHT+IE7mrL3XYtPorLAxmiBvhd+2iLCUjIg4wjLJ037LWcLp5xUAoUdo4ZowCjYK4kbhHl0u0HtUw==
X-Received: by 2002:a05:6e02:1fc4:b0:427:d82b:1f36 with SMTP id e9e14a558f8ab-42f874010aemr232200265ab.32.1760379397910;
        Mon, 13 Oct 2025 11:16:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f6cd58ed8sm4020501173.19.2025.10.13.11.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 11:16:37 -0700 (PDT)
Message-ID: <b16885da-05e8-4fa9-b5ef-6fe5c3af64c3@kernel.dk>
Date: Mon, 13 Oct 2025 12:16:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>, Kevin Lumik <kevin@xf.ee>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] Revert "io_uring/rw: drop -EOPNOTSUPP check in
 __io_complete_rw_common()"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This reverts commit 90bfb28d5fa8127a113a140c9791ea0b40ab156a.

Kevin reports that this commit causes an issue for him with LVM
snapshots, most likely because of turning off NOWAIT support while a
snapshot is being created. This makes -EOPNOTSUPP bubble back through
the completion handler, where io_uring read/write handling should just
retry it.

Reinstate the previous check removed by the referenced commit.

Cc: stable@vger.kernel.org
Fixes: 90bfb28d5fa8 ("io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()")
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Reported-by: Kevin Lumik <kevin@xf.ee>
Link: https://lore.kernel.org/io-uring/cceb723c-051b-4de2-9a4c-4aa82e1619ee@kernel.dk/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 08882648d569..a0f9d2021e3f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -542,7 +542,7 @@ static void __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (res == req->cqe.res)
 		return;
-	if (res == -EAGAIN && io_rw_should_reissue(req)) {
+	if ((res == -EOPNOTSUPP || res == -EAGAIN) && io_rw_should_reissue(req)) {
 		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
 	} else {
 		req_set_fail(req);

-- 
Jens Axboe


