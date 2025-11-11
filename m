Return-Path: <io-uring+bounces-10517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 58AB0C4E925
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 15:48:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BFF2B4FA49C
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 14:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC673019A2;
	Tue, 11 Nov 2025 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBtC7a5E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495C3342C8C
	for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762872027; cv=none; b=Mm4XiDr2CXvQ+7KcyHhm7MsNmvWVkbB+GjndgeHuf7LOBjMKyw4hO9Ebk4n6f4YtfHHCAYvi4vKYZdOVXnDDvXGXQfTWebVgpBPwK6ncdOhw4L01igwECSMIAQK5mdrM3ejyDqfgCL+QsKUci0EbEUmTXx7FK90s5H9ekkDfpIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762872027; c=relaxed/simple;
	bh=3lKcBb2INuDvQ8UknWMEMkytQeg7bWlbQiLfS6DWSQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N5cRTT04qm0CS8NFRW6Gp3flCQB9z7OIpIdJH59Dey4f9Gyq8f0JQmZaoX8hH/Z0iLOIB4Tft2Cf3rjKKXbB7brcUM/HHef1N+ieNsahAvBoXfXodx+kJKWfjOwyP5Q74vmPds6jW0/4oRL0xziqjoMpUKriNgFcV8vXM187tXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBtC7a5E; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4775895d69cso22415655e9.0
        for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 06:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762872023; x=1763476823; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=say+4Bg3guIRI8bYhNjhNFm/+M0MpYu+ErgC9JprI7I=;
        b=UBtC7a5E8zFGqfEhxu9CETwhEwOBxglNiXrXGR8uEPqu3MbsDxWjYwXbQO75uvlq00
         7eidVYslL8m7xxQpeDxGzHyIYKaRApWfQDGbL+VkKYXUzp8U/GmrHgazLtueu4Slk4Vk
         sSlip9E5Cd2oS1ruUVQ6vML38wr2Qp4GGZ8jt0N6EOu/RyTaC3iHRShnAVi8/nnjqaGi
         vaIUZ5sPCkmil05kT64DYomzQssiLJuLBsRue2tfR8q+RWVzwmkMUgFZqR0BR+jfzPcC
         YsPLoRozQxLjQP+zMYx3E+HZAqgwBtvQCMKZddcuVVZ3UHhHYeTzOaXf+cDhE/yCYc9Q
         nKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762872023; x=1763476823;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=say+4Bg3guIRI8bYhNjhNFm/+M0MpYu+ErgC9JprI7I=;
        b=b4up16+p1yHtkRnf2YZ7u1JDe2u/Vo1c27q8OOoLFFaF7ADLz5PKYmn8gUdFvPi3bw
         HZmednCiPs2pZcbazSeZotdX8EISb/VqjhlmCjdWz7xwcF2912axbysoNuLxkn10PwuU
         NSSebm3VZxAqRgjSlhrKSeMWCBEOg45q3EmeuztdrOP+sCWHLQ2ULgqZBYfcVviFTXAF
         zTou5xjOdR7herhfyMupYIcS26f7e7dkNW7+WI8iwrzztCGvI2UGuCIHLYHSrup4k2rN
         ff/5sVSUBv+M7EC1o8vvGaUUOG6ZDz8ZGAq2IJ30WmicVX5wfK0zlX8vmOa86g42aaR1
         8m+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWGpeVI2X2GBiP3Mt2O7SZjQTUaDqpXHzT7P/TxE/3+Na1f4ke6tlfPrMXmvC8cwmuQYT/S1uw/+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBGiE0MHlwYOBMILtR7QmN3VjBFiTUBzHRm3qYIsn8i3fsONQu
	Da33ti3elDEPRRmnQwkGyddGmLFcMyo9ldw2nEHW0eWYLtGZEo9wXKVLs/nDGw==
X-Gm-Gg: ASbGncumkhjSv5dp2rL6zZc7ClPsbiCfT1CNmrlsWLbNYfHrxumX0wD9sWzc/ubnw4x
	VDQml24ptlkFbMRn2165Ef2CWzvMWSka46XBjNUox3cl5i1EvKAmjlxPdBHSDF2QKbyhHCmPe+c
	tc2lqVgTlVyRIs2zNjFQvnnJuQaswajra3o5z92Xl79TryM9nu6DgCqhlP6GKj5QpAD0Q5gwzUF
	U5oUREHGvTCSKk6V9PeiSU84fJ6rdKrTSm/shXIJAuQt2FcNch+RnxTrhvL0sP3b30XZk30wKQ7
	c7E+/eJihtlB24uvcfmNcRvthCk8kFi66jwqWercsVmAC2k/0ZtYM5gpQ+NqUgUHiJaBfRIQCtN
	h4Gj38fTa70j5r//COTrSQparv5R/kRr7e4VGroi7YMtZoEbLGBmOHGUpRjP2ghyafRcySS8a+A
	NreP+wieuOJ2QFcgXlMZYFy1hXL0RDn6EUPrxT9v8kmyADnVcRnFPPhl6jK4G9Pw==
X-Google-Smtp-Source: AGHT+IEfw9HLYIOEMhbdAR9FYnb5DZZgb2dIKwi/SsnDv53xIugSc77XL0sGI0T+5+Ob8l/93ZQxCw==
X-Received: by 2002:a05:600c:524a:b0:46f:d682:3c3d with SMTP id 5b1f17b1804b1-4777323eb5fmr111313715e9.13.1762872023491;
        Tue, 11 Nov 2025 06:40:23 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b322d533dsm17680210f8f.0.2025.11.11.06.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 06:40:22 -0800 (PST)
Message-ID: <f933fe15-6bd5-4acc-94ce-d5ce498ecf79@gmail.com>
Date: Tue, 11 Nov 2025 14:40:21 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] io_uring zcrx ifq sharing
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251108181423.3518005-1-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251108181423.3518005-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/25 18:14, David Wei wrote:
> Each ifq is bound to a HW RX queue with no way to share this across
> multiple rings. It is possible that one ring will not be able to fully
> saturate an entire HW RX queue due to userspace work. There are two ways
> to handle more work:
> 
>    1. Move work to other threads, but have to pay context switch overhead
>       and cold caches.
>    2. Add more rings with ifqs, but HW RX queues are a limited resource.
> 
> This patchset add a way for multiple rings to share the same underlying
> src ifq that is bound to a HW RX queue. Rings with shared ifqs can issue
> io_recvzc on zero copy sockets, just like the src ring.
> 
> Userspace are expected to create rings in separate threads and not
> processes, such that all rings share the same address space. This is
> because the sharing and synchronisation of refill rings is purely done
> in userspace with no kernel involvement e.g. dst rings do not mmap the
> refill ring. Also, userspace must distribute zero copy sockets steered
> into the same HW RX queue across rings sharing the ifq.

I agree it's the simplest way to use it, but cross process sharing
is a valid use case. I'm sure you can mmap it by guessing offset
and you can place it into some shared memory otherwise.

The implementation lgtm. I need to give it a run, but let me
queue it up with other dependencies.

-- 
Pavel Begunkov


