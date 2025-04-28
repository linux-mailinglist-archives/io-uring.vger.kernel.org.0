Return-Path: <io-uring+bounces-7762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73061A9F7BC
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 19:51:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88E093BE786
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 17:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3796D25E462;
	Mon, 28 Apr 2025 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h/BHLcNG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E03F26A0E3
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745862670; cv=none; b=eGOX/d8JKDjBB565HGNOtjHmQ268ltweRsNb7FjGkMze8r5VwNH4bCFWnt8RUWqQ+naTuqCrMv8eVUWvD4tuKtA/puZjHGsqgU7yyuSlP4nQ9TP2kbmO6Y0gMiUGUVCT3Up6Tmg5tLvfKYSj3HyO/MSsLKVCZ1adqvqlxIHhKYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745862670; c=relaxed/simple;
	bh=/t0NtFMXvimhMn9+qylrBPaNASSBQar0XVauRpOTeJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UJRKq5B6pOCzePHjqfiKDf+2Oeb4p7T6+z2xF3oT3676808+sJUWhIpK7lEpGxuiZhzqP2iGjym5Oi9ZY5hY45i0i6mGfZgpzxaTZSOzplsJWJm2y2V1HlTeGt0PHr2gLeLuZNciZzkaI4CWbI88/4UFBSSGM+ahWQMF2BNfKbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h/BHLcNG; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-8616987c261so169713439f.3
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 10:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745862665; x=1746467465; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h4wyA4meYu/jGC2JOtjrK8EL7T0Nz2LNZVXKvpx9L58=;
        b=h/BHLcNG5HItLkfoHc9b3QIZZ0xLk25kT7I/P+vd5iMAEmAVmm7AnOeEjB5TLgIIXh
         ZBKX6Alh7/vf4DxeW7fm5mybJAKKWzrNags/S83x36bfD0yb7ZL5FM20Kuj2oe7I/hGo
         lgb23CJxxicgs3iv8Y1vlLnETpWuBpwzYNpIuhywvWAiEaVgc48NEBAe9YDpo1uyKscJ
         2YcTlma0chO22OtO8vhcPj7i4SUmFCHbNOODwKEvTM/wgLIrHmJyGXkau4DSypW8MlrX
         yzKudeM4kQ1MSW6ppcQa4yoCCFe+qs/aX1+P2T/I4DoSaGkTZBoz1xtewX6UjRdMFARD
         U2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745862665; x=1746467465;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h4wyA4meYu/jGC2JOtjrK8EL7T0Nz2LNZVXKvpx9L58=;
        b=go6mgcXGxba5W5KDkLe72s0b/bBitgPlqQIAA0DbV+aZLsolw5tHdHaFyq4AFVNw9e
         7hUX6wuwxpdMIXhLKBLh2Z6B+SoRwAjgmhUYtlOLTizAcEvj3Oz8UZM1O+HM8jqpjuv7
         sd5j3l7FUZR0+Q2FaYHwmM3maxK+kI/Y+/jxORi639hiNqQqaPyBXicHQhKqS/dIYF3t
         vpvW9RsZ2p7j0wEKc5L0dBpZNunBsglRoRb9VIYbr27oxyJ7glJTNNNxdXOK8KW2cRaQ
         mozwK2pvCjgWSjdNPJy2NG6eLw2VibRn0tcAJsSQhpV8+yvpOuGyE85cZwc2/D/QjTka
         LaGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUYZRexYOioYBNRvu7hpffUme8m4OZ/14eFqmL3ndRLuKQoMhzBziOddRGQM+wCGUzmoxKXRSmZg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5fRb9a5kU3cnOEW6dMi1kpV0UxQxAHfEqWr+nJjrU2GxaPdl1
	yClxY/1bZnhA5DXf9935PpHPtB7m2NRxGyLAlcnsydTg0dOsfG/1U9SDHYjwJEgwKVMcgEGx8oQ
	y
X-Gm-Gg: ASbGncu2PO8d+mYTW/oVgmo3D8ezXzkcOKYC6TTSFOV0T0HocNfgWvgIRun/Iq/gVO5
	yiyLOzK4uikcyqATS2xrJxuGPZ3SVyE5TvNbEsUikHDWMh5cobZU1XCNIgXDYCQT8NDOBdiaiZ0
	kxR+pvC9ezN0ESXfUWvdm1Z+/+sd0H+581ccJPbR+wepK9oeRMKffraZZEnj6E9nx6lRkbHEQ7s
	tEbYBZIiD/WywzpzgvLFSQbp+Txqkbs8Ue08vG2A3r+ef4+k6kogS5mYoQzYo3FZFC+vcVm1xJB
	2ImuwR5GWPmk2h93qEI3mbM4a1YAmxkbXwMb
X-Google-Smtp-Source: AGHT+IHoelBKLB3nVFdyMYqp/t44lbX4GPWzngTAnmCnA+yGBY80X2S0xHatnLd32WDYzruryj8Wqg==
X-Received: by 2002:a05:6602:4c84:b0:864:4a86:5be1 with SMTP id ca18e2360f4ac-864886b941fmr110415739f.8.1745862665536;
        Mon, 28 Apr 2025 10:51:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f824b81d12sm2362461173.91.2025.04.28.10.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 10:51:05 -0700 (PDT)
Message-ID: <00316c59-8d27-42ef-b78f-c4c69334549c@kernel.dk>
Date: Mon, 28 Apr 2025 11:51:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/7] tx timestamp io_uring commands
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>
References: <cover.1745843119.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/28/25 6:52 AM, Pavel Begunkov wrote:
> Vadim expressed interest in having an io_uring API for tx timestamping,
> and the series implements a rough prototype to support that. It
> introduces a new socket command, which works in a multishot polling
> mode, i.e. it polls the socket and posts CQEs when a timestamp arrives.
> It reuses most of the bits on the networking side by grabbing timestamp
> skbs from the socket's error queue.
> 
> The ABI and net bits like skb parsing will need to be discussed and
> ironed before posting a non-RFC version.

Implementation looks nice and clean and straight forward, don't see why
this can't be a non-RFC posting. At least in my opinion!

I'll queue up the first 2 patches.

-- 
Jens Axboe

