Return-Path: <io-uring+bounces-9890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDB5BB702A
	for <lists+io-uring@lfdr.de>; Fri, 03 Oct 2025 15:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF7A63B28CE
	for <lists+io-uring@lfdr.de>; Fri,  3 Oct 2025 13:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08F81B6D06;
	Fri,  3 Oct 2025 13:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e6edqcn+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CAD2EFDB4
	for <io-uring@vger.kernel.org>; Fri,  3 Oct 2025 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759497858; cv=none; b=lG0ENp+diTcDygRUI1C+PkrAPnFZjzzLvN4l/Cc6k5rA5mIuGs2bH98vSvCo1LT4j9vUctdoeibsAOeBebuW8eqdjoWa4q8h9UvJQDIaYczbVciN6u7OMeA5Y9aeyEwJY/8PD7e3Yqx/6LzWNBURNMGzfyuVsIOZBWj5fnLuFA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759497858; c=relaxed/simple;
	bh=B5rwliRQD//lkT38v2BSUHm5PBsnaLw4Vqu3hR69XVQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=ix+QGEA03SZgzax5Atb5ALU+Zz3YxtZ+AfNfPg0p/VSn3OgzDJhxAM30rHRJebgPDh+RLDTEwuOafInIXQmhlMWqtL8LoZKA8ZDjI5eB0+nLdGTClt+hYbXjVbKIZP1e1e7J9DBnAd1Dl7Fx+yV0rv3GJyOUWDbVldfR987F1CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e6edqcn+; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-42f62c671a3so339585ab.1
        for <io-uring@vger.kernel.org>; Fri, 03 Oct 2025 06:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759497854; x=1760102654; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8fJsTC3GaB/8w8YGWW6cxZ/UHLY0my0e1UeKslGZ+Y=;
        b=e6edqcn+/cJPg3OSbqxFdtaZte2T76t0VenE2D9EvARNNK5ktC01ArI8XA3G4Y7IK/
         tgDQ5Bytd5Y6JvjkbtppDpSzaeLIT7LJXxQsN2O99N28stc9JSyGkfVvOu7SMZ0UFYFk
         IwbPWhVtD1kryY/nfJJAwltGP5jdtrcddCv7FrpZNmtppblzgalqrWX8CB7qb1MyPXKR
         +bk9RH6ea2WdAzYtHGjIVaVCAFM+D4IGJ12UAVQJzrQqanh1Lg4kjACRwX8G2M+JWH6i
         A+8gKQoGgr2oPojZ+uTHblOCH+HGjAXGDwQDzy6uC1DP6v+ZseZ0wMDJlEs6Y1W3X14k
         iF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759497854; x=1760102654;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=a8fJsTC3GaB/8w8YGWW6cxZ/UHLY0my0e1UeKslGZ+Y=;
        b=mayR7jMXR7Z+9Qag9eWX+AyX2dxvnOPTY/d8RItVvWzOgcJMQWAHM1y1Ww4jkOSFu7
         Q8wQJGmExEJEGBXkiuyZjqIJ0EPihtk+2is/HdR37K8vUrW6Ec9R+tLntgqc3EI2BTOf
         wEDQjB2PtGPv9Juw12Q/buMEpirZB2YOM5JnqxkoxLj+qzTCM9bRS3DxakDimJ5ANC5X
         Cdx+xHmkEOtGIuA+X4WyXlxAd181lISWHtdasHr+mRi22wdYY5gEsToHl/etqtBQLpsv
         Ew7l+CtlUjYbMyaBIjbNDkZBAmx3+1QHuc6VEifVJ0/O1F0tLT3I5zJclsBGmZw2oLbs
         tm8g==
X-Gm-Message-State: AOJu0YzVZZ2Ng8jBaoSMdqgNPSfXPWXzEg1k7WYpY1Lz8jVdP+gTAre5
	dtY6i4xeqSx772U1jDDTkH6X5+XyHszS+b/5ILlW1l2Luy7fN+c1mSDX5293JVbHfLjyESUdO4Z
	e2QgpkdM=
X-Gm-Gg: ASbGnct2SBVVm4SgeneipNpO5HPz3FPILahjuf93Nj7ohfxXBH6qc1YoIA+t1sQhr8k
	IRRn7N0JOz2zGn2eSM3BVWP2QK7cilWh8zI03iCbqhTbITscOiMqU2/5RkEosPraw8TGOB12QBn
	L/MiCtUUlJqG/g45jPbbLK5LH5o8YSH/pv7yYXIJAirI0uJWpR0r/wbtpHilBwBgNcOEFdC/KHQ
	XKjmCE7bUO3h0V5I+YCJoFg0TWd0Dc36G+aab/MmyUkWJ1QpQDtFGkZ6Jk/5H+yw4Gv6Sv9CF+J
	sVZCUnqgvFzQDUeprSwak2JW+9BvFSiYTRWP15Rcu2nxmvd9em5SzppHoMt7zSzwqfXdICWU6Dr
	149wlTRpjOZJ/J/1OSbWrljCX77+ZjMuxg078uFQc0U+A
X-Google-Smtp-Source: AGHT+IGc3FYTc2jxTwlVq/5yn5oYvwRBklYoT9fSnuNr6/+Xu+P3LFdVVnw94vJ3GXN8QFGGGig3jA==
X-Received: by 2002:a05:6e02:174c:b0:42e:6e49:ddba with SMTP id e9e14a558f8ab-42e7adab3bemr35357035ab.26.1759497853735;
        Fri, 03 Oct 2025 06:24:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f5f4dff42sm3345365ab.32.2025.10.03.06.24.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 06:24:13 -0700 (PDT)
Message-ID: <40dff87b-2a46-483d-9b73-425df76d8ebc@kernel.dk>
Date: Fri, 3 Oct 2025 07:24:10 -0600
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
Subject: [PATCH] io_uring: update liburing git URL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Change the liburing git URL to point to the git.kernel.org servers,
rather than my private git.kernel.dk server. Due to continued AI
scraping of cgit etc, it's becoming quite the chore to maintain a
private git server.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 49ebdeb5b2d9..820ef0527666 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -29,7 +29,7 @@
  *
  * Also see the examples in the liburing library:
  *
- *	git://git.kernel.dk/liburing
+ *	git://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git
  *
  * io_uring also uses READ/WRITE_ONCE() for _any_ store or load that happens
  * from data shared between the kernel and application. This is done both

-- 
Jens Axboe


