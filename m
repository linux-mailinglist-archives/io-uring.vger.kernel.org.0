Return-Path: <io-uring+bounces-6195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D561BA2401E
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:14:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 331E11889160
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 16:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2543C1E9B17;
	Fri, 31 Jan 2025 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JDZNWSoU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497841E3DD6
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 16:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738340043; cv=none; b=X6tu6dcY/bl95tsen67rt9ozp325hL5M2QNIopIc7Pw+cPkED7Ka/GHBRO3PW1VbI6SZkJa59YvM2CVuUO4RZ8leRzxzs5atZnZCHW8oqrbGl7YdFg/RPmJ0TF5viW8+NIiSkWcTZjPVVGAFzjr4rRx6IXHy3v9h2PxBybCNWzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738340043; c=relaxed/simple;
	bh=pdi21uO3zRJzgqqCpfS+ICk+bA75SvnKAH+Wa9hNeoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SVmkfwe8cY7pai5MaaEqnlTSFiTJ6cQjYhx5cp1VJ7kjXpwy5xGg1ynTOxVdecFJAW8V7hbN/FNtgSSNqjBCv8HTB6mqw5Kl+nq/cyQU9QbDg7pFsiofVr5EeoEGPI5gmfRBfTgCmk+TAdemNK6s2O3Ksh0aqug4HHthjDyyZms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JDZNWSoU; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-844ce213af6so57569739f.1
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 08:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738340040; x=1738944840; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Asbuwd4k5QtMGlRZxVM8HwS9gscaYeakFA+0/83jN0=;
        b=JDZNWSoUbCHIEL02fFUlqPMCAZ61F8pfyI6PHAo+liDPKMLkSymtbqAY9v6yZINUa3
         xFdIwqiXBNSV3iA9r1Wtp6R9eOH4N2y9HT9G20sQ4NzAkkeMN7nKMoTPYgQUXsxJHDlx
         3/r8KnF8AHB1ybIXEYcIh/7KeLIa2jwHR27DqLaXbT+pxStsNADcnadcJuBMdmol9vwO
         GvpBglDQwBv5zNW/rzW1vuI7a+PchCuS9jzEv+RxWGUX7THoGP0VZoRmuHgT02T0iCFP
         56OJxQEpVzbIXdgY/e7k+gmsN5ZOuBUwnuRv7i6krNxu+lUMweCvpAzXpSEKTmkGAukg
         BaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738340040; x=1738944840;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Asbuwd4k5QtMGlRZxVM8HwS9gscaYeakFA+0/83jN0=;
        b=L0qKB38p/EQZUcQIVkToplxEWwHPw6GlqJaYhWP5CTK2zcEn/a5NHLyeu4sOH4PoRl
         uBKTSfKwVQHuESc/lpfWGZ67APl+1BdoR4D7QHDwMCYIj3AL3hZoM3aq4Clq2BgePF0S
         S8qR0Zi6rD9P8VvEAsD2LR0ojQNeUX2EPUOLKWOe67O9yNzCkBFxgGpHqROJXHaoKvyW
         K+XUijefpbxzetvRo/cfXZQRVYCImN//BjcCXRE1L/F7LQhK2FtlU+FbAI1EHoJD6fYC
         TYgPvBgMyXfJ3G23c4wQhCQuG9H6mAp0UrjKc5abJjzeSdi7T2nmXKbgNikrnR23Jw7h
         v9IA==
X-Forwarded-Encrypted: i=1; AJvYcCUenadROmN2fLR/fTnWnd8ATYHbRBaAk2gAb9aXqNlN5YnaVoB0BlPNpajtos1Xu4DONrQR0UPheQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8uvFppMMnoS3MB+/dRMzcDhc7a4EZau3lbjEQeez7McIL5OnZ
	8Qe/1fHkXD6Bnxq1fFZpdLSwuZADru4grdiCYWNTGkdF2w9z0vM3GJDE0HVN6Ws=
X-Gm-Gg: ASbGncvoLkSJ1T/ODffu+pkR5ENwr+NUaibG+jIVQ2M4Ov7839/sWsf1n16anhoI7kO
	OT5str1w6ZZOqQTm+RzBZMkhITluUkg3zJtrecQRzfcbxhT++8CR1fTlnbIH+yM9Z1SJD5s3YH+
	QfBkiNkENWDPQT6olUlm7nH5vUOcVBkWoHvpr72vs9ZDK1cwYbsf+CTCjlQ46aamJtZR68P3ct1
	WC8yvd32Zi+RhX6aeRI24JMz4vBaPbiLeWvVB5IPhbDuUL+8OnqPSeOnDhz+ujtsDlbmi2IbhL0
	x2J6zwfnoGg=
X-Google-Smtp-Source: AGHT+IEwbYK++U0hKvw4rfst0z2J6NmHICeOjHy/p2mElDz82sdOeuGm8jf2C20UP2qTKZvpVUGoJw==
X-Received: by 2002:a05:6602:1608:b0:844:e06e:53c6 with SMTP id ca18e2360f4ac-85427df47b9mr1184995339f.11.1738340040352;
        Fri, 31 Jan 2025 08:14:00 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7469f4e1sm882442173.80.2025.01.31.08.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 08:13:59 -0800 (PST)
Message-ID: <daaed11f-02c4-4580-9594-fcaef35a35fd@kernel.dk>
Date: Fri, 31 Jan 2025 09:13:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Various io_uring micro-optimizations (reducing lock
 contention)
To: Max Kellermann <max.kellermann@ionos.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <7f046e6e-bb9d-4e72-9683-2cdfeabf51bc@kernel.dk>
 <CAKPOu+90YT8KSbadN8jsag+3OnwPKWUDABv+RUFdBgj73yzgWQ@mail.gmail.com>
 <f76158fc-7dc2-4701-9a61-246656aa4a61@kernel.dk>
 <CAKPOu+-GgXRj-O9K1vdGezTUGZS64w5vpkZg2MM-96vmwqGEnA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CAKPOu+-GgXRj-O9K1vdGezTUGZS64w5vpkZg2MM-96vmwqGEnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/29/25 11:01 AM, Max Kellermann wrote:
> On Wed, Jan 29, 2025 at 6:45?PM Jens Axboe <axboe@kernel.dk> wrote:
>> Why are you combining it with epoll in the first place? It's a lot more
>> efficient to wait on a/multiple events in io_uring_enter() rather than
>> go back to a serialize one-event-per-notification by using epoll to wait
>> on completions on the io_uring side.
> 
> Yes, I wish I could do that, but that works only if everything is
> io_uring - all or nothing. Most of the code is built around an
> epoll-based loop and will not be ported to io_uring so quickly.
> 
> Maybe what's missing is epoll_wait as io_uring opcode. Then I could
> wrap it the other way. Or am I supposed to use io_uring
> poll_add_multishot for that?

Not a huge fan of adding more epoll logic to io_uring, but you are right
this case may indeed make sense as it allows you to integrate better
that way in existing event loops. I'll take a look.

-- 
Jens Axboe

