Return-Path: <io-uring+bounces-6177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C7A9A2234B
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 18:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2DBD168215
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 17:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84691DF744;
	Wed, 29 Jan 2025 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZrBpWfyv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0959418C34B
	for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738172749; cv=none; b=mb8fwwUy7/khPM6Gr8jvEhqZNcmDMcotn6qrhAMHZexc5I1KWqCP5FM+nvv5iFYQZR4Ocztj2OlX+ulrpZRYViW47ztaJqfukp4C2cC0ZwqwqjapsNyhKc8Y85pQFKXtwg71SvmDlHSwSnUGZTehjt/jNyKCgMACMlD15+1BBrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738172749; c=relaxed/simple;
	bh=SLeqwYno/5jSjNKjpjCOzjY6UT7jbbPK5g022EczFGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gHwSAJZaRkeewAyAXW6NhQvxI4zDB6xe+MwyvqkB84jMytlhJVZ7T0hO2imKASpuMIkYhQ0D6kk2WF2/UJ4yIIGywVpNWW9Vxsl7VNU1nlwj5rbljWIIE5HzPxCOf12QNW8YdgjGdsok4xCAtqgtQa33TFHvWAzZN8yxEE4TokA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZrBpWfyv; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-844e55a981dso192504639f.3
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 09:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738172746; x=1738777546; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0cX5eV5zH8zQT7dGq+IpzEAUG7LZB8+/TXgDA2I5kwM=;
        b=ZrBpWfyvWItSWlvwfEinU+ho/SwOkatYvWBr9prnR6hJmb1/otStA3t8GG5cw4INwn
         t786hiCMsqip+PKTZNEwg+A2B86cY2sAkpcvPM7yn/HCfr1vBEKXcsDxxO45lCrdw+B6
         jq/GJt8m/PP1u++lTtkLWrE3PcFC3pEQlZn47JeLm+BvWcYeuWMfNi1Z1FY1oxQHEGI+
         g76uLDg4deRcXUaEIHYarm2j85wwcThS9PUTzfRNYN5cZao2OY47Ufg3XXhSD5fwZLev
         IdrPPYwNb3babwHLNfXcaS4qFHtVClfGWp3kUHI5BA/tmu2rejfjtwYl0JmmwVxxvgkM
         mgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738172746; x=1738777546;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0cX5eV5zH8zQT7dGq+IpzEAUG7LZB8+/TXgDA2I5kwM=;
        b=j6qCrXlMyB2OoLHFdu4UwtBy7bWUmUZcJahROVos2bSz3wjnIuU9cI5ot3jRLo/Zkd
         mKiqar6R1b3QBzvQ8A+SOo/LD0fwaC3KylZTBxmrEErLaH24bjCL34xAeSGpepBVMG0u
         FWfqtpIJ35JFpIYpYRudwyztnjUZAuPvDYow5RZGde0RWWVsF25drAqk+8aWPTce5rvl
         QBBdaE+eLE3Yx0FLRny+ANWhWMpGe7Oq45E8h8DdY75sRR+PzmzKiaesDMqeanfSinEo
         GaF7SjMnaYT+2xcYuy3004nNdVb8pgPqnK4EwxeaDE3NQq51Ff9r6O4JE0jOed3QR+eb
         974w==
X-Forwarded-Encrypted: i=1; AJvYcCVkd8+zhXHCkITl4c2FLu1nXsoxnY+AirLKlqjdWP+gHfjPc6CP+0Vu0t5dcW4Kgy4DlffC5ABFQw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6vF7Y13lRG4lM31tyuAqzZj1I9oDK5sEHa9tPEDuyYngRvDkX
	c1WRyMMyQM3vRmbOquf0ahB/mOYDNqamjSmh+E5KYKMazYAyl7lY6YcU9JMOOVA=
X-Gm-Gg: ASbGnctklTQf27kepl83hiBAYTQn/LkgY2mElMpPrY9IrQPvqorMERlnrssISjrndRP
	V77ZIog5M2jouARGJv6O76rjiU2LOHnaS6DYtIqSnAmJmI0GJYG6QkJB3LvdeuIEb6kWfGCwmR+
	W61ql0sRiPSHy2OEy9ENVK7PENjlTjzZzYKgsk4133qjp3jAHzZCY1Svz2fA8GSGO7GWShzvtsS
	hMq2DafmtIxg8iwFIL+iCtoPTLTBoTpGFecnBMel+lDlUXNRk/793xbYO7Ls3LYpDjLEl715oNW
	ShdJh8IeSV8=
X-Google-Smtp-Source: AGHT+IE5mR4efwEP14GeO5jDtJc2e5N4jJYuXLCM4aHVGobgckQ8tei4eb6isuAKg48a2RKhuQJGVg==
X-Received: by 2002:a05:6e02:1fe4:b0:3cf:fa94:cad with SMTP id e9e14a558f8ab-3cffe3a6a12mr34535845ab.8.1738172746065;
        Wed, 29 Jan 2025 09:45:46 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1da31b81sm3892197173.52.2025.01.29.09.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 09:45:45 -0800 (PST)
Message-ID: <f76158fc-7dc2-4701-9a61-246656aa4a61@kernel.dk>
Date: Wed, 29 Jan 2025 10:45:43 -0700
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAKPOu+90YT8KSbadN8jsag+3OnwPKWUDABv+RUFdBgj73yzgWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/29/25 10:39 AM, Max Kellermann wrote:
> On Wed, Jan 29, 2025 at 6:19?PM Jens Axboe <axboe@kernel.dk> wrote:
>> The other patches look pretty straight forward to me. Only thing that
>> has me puzzled a bit is why you have so much io-wq activity with your
>> application, in general I'd expect 0 activity there. But Then I saw the
>> forced ASYNC flag, and it makes sense. In general, forcing that isn't a
>> great idea, but for a benchmark for io-wq it certainly makes sense.
> 
> I was experimenting with io_uring and wanted to see how much
> performance I can squeeze out of my web server running
> single-threaded. The overhead of io_uring_submit() grew very large,
> because the "send" operation would do a lot of synchronous work in the
> kernel. I tried SQPOLL but it was actually a big performance
> regression; this just shifted my CPU usage to epoll_wait(). Forcing
> ASYNC gave me large throughput improvements (moving the submission
> overhead to iowq), but then the iowq lock contention was the next
> limit, thus this patch series.
> 
> I'm still experimenting, and I will certainly revisit SQPOLL to learn
> more about why it didn't help and how to fix it.

Why are you combining it with epoll in the first place? It's a lot more
efficient to wait on a/multiple events in io_uring_enter() rather than
go back to a serialize one-event-per-notification by using epoll to wait
on completions on the io_uring side.

-- 
Jens Axboe

