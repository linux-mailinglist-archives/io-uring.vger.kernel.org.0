Return-Path: <io-uring+bounces-7418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1F0A7CB29
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 20:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 372FA17493F
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 18:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E8E5C603;
	Sat,  5 Apr 2025 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RTdsS6fa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FFEEAE7
	for <io-uring@vger.kernel.org>; Sat,  5 Apr 2025 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743876616; cv=none; b=HI5BAAY0R0YqsSd0o8hQupaqc54aLKgwQsjEfCANsxe//GZHw5GKgpglH6H421GBrJhLGOr41nJ1Aff3Bfh4K/5KctZaFG9bgC2Xmb/AFN0HAZDuqHY4a1Qr72Tvm/Keridg1RODlSwbm2ciF0s48kh22VnPBhQK4rJA9psdLiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743876616; c=relaxed/simple;
	bh=azJi2ijFmy7xeZsrGtb9OucKtrXS8tQAj5K7/9kxQ6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FGEq3opD5YD7odWOx9dFpN5W6YENtCUsOx0fJq3lc7X0W++/FAEBdbnQB82jJ/SXqVYM8FD6LKSSWrvL2gk/94On7aIXTsWjpy0oO5Uw43H2gvQP8gCJKlK3fUASKbv5Nn3R0nm3CesQG7OetmmsWVPNPcqQrL83awPOX4nOtCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RTdsS6fa; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac298c8fa50so516062166b.1
        for <io-uring@vger.kernel.org>; Sat, 05 Apr 2025 11:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743876612; x=1744481412; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vv3oVGN1Cer4XKX01Ve0Ez+580G3r9MV69zbx8aeCyg=;
        b=RTdsS6fa9pkHcPZDJaTNBpp7NTVx/hHJLn3Pf2Ha1nPmVGAJHBNcJHIDC/w0I1Wj6o
         QDw+7tLTIC4P4akJL55O4CK5AGV1gUYZbwCVdd/scNxadfsnVYpNrE7XAhHt9ag9aO2N
         WXyZ0psoy2fR/WmrO/ItSxxR5EL4vEatSTcyyclQexx/lsSyUiE7VJ/Hflt+kTm05nvw
         IAT9cxgSE46lAAYeT2aMHebgEvcEWQH58jzioCHVjvjMZ3YmFDkqPXkYp4ZQTZ3cM3IW
         Ib2PHlYW3Q51fNRNzMoWGgUTd1xjm1NWBQb0a9KGbUfLxNeybhTeF1dji54egdTlyKVW
         Dqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743876612; x=1744481412;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vv3oVGN1Cer4XKX01Ve0Ez+580G3r9MV69zbx8aeCyg=;
        b=AfsTJrzPIbZrwfn1DtEaqwKOmLwZyY5Q9fbvsBi5QYLVlqKHx9RzKL9u5B/2L4K+Wv
         JCxTXOAdIbkSwS8wzfEVoz/k//AJdphPrEy+e178jJ2JiVow9GxniqVMibrhIcEP4zCx
         IUHqmy+m3qKRRkwkZP4GSaUy9UDTyk0f7cES9utFTlVMFzyRz0eHwH7zMypp1gA+MBqP
         /O+Glp2rbKhrWEOxsDu2mqzSk7garwgdjmbv94yxSutwSI4aVnHBn//TQ2t9EeLIPYK0
         y2967JRmWY0bfE+Qdp9u3rh4FMiqLISbiAxkcg88QXs0Rncs5Y5tzfWeF6PMYPZOycQ2
         2aHA==
X-Forwarded-Encrypted: i=1; AJvYcCVkmL9lyvnwrVeQb60geZqdRiV5fc19dH4rMIMp32AiZQC+YD1BBSdTMpPmcXXqTD+LGCJHn7kUgA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7RkBG4+3sTXvN7JLtWPIOTrFFO5o4WmUMdoENYf+4LXU8Vis5
	C2hYwZOu5GAQT09Nf8X3bL6kLe5fSVSfHOCjEPMVA1Lk/0uZ9hEzEFdh/A==
X-Gm-Gg: ASbGncv6DZlPBAS3iVkKtKKGQnDqgNWw8xz5bbOf+8Vce5NtdjOM6quNtYWEYKW046l
	biaCopcNQQm9E6A94J5Z3SdDJ4j+IoqMf+e6eD1WqL7dAw1ilFCrtfIABxw69fcZOvFoJRx266E
	UKzk0entyMSEl7N2U6Y92gvNg8Yqqa28Lup/MA8Nmp1X8Oa2XQuCd3tizUeXnRym4/j1nJErZ04
	xkJcrSf07USvf1dYnZXU1dq/2AZ7Vbo/DuUItrh91jhUzwxGtOPTy1A8CiT5UtO+TuNtd1Aq3Jw
	VgFhma5O9E8lSZFIKrVXrXNsvQ30EzvaqawkqYDWwBkKtYuuXr6+oo3LtBo+YtXMag==
X-Google-Smtp-Source: AGHT+IGL36euQOMtjsPz6iwxPe7Xs/HdHElv0EPPzUGa/It9D0LMH0sQyjvhbPz0hJEvXu0FG4RDmg==
X-Received: by 2002:a17:906:6a14:b0:ac2:e059:dc03 with SMTP id a640c23a62f3a-ac7d198ff85mr665751266b.38.1743876611945;
        Sat, 05 Apr 2025 11:10:11 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c013f730sm466009366b.92.2025.04.05.11.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Apr 2025 11:10:11 -0700 (PDT)
Message-ID: <5ce812ab-29a6-4132-a067-27ea27895940@gmail.com>
Date: Sat, 5 Apr 2025 19:11:24 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring zero-copy send test results
To: vitalif@yourcmc.ru, io-uring@vger.kernel.org
References: <f1600745ba7b328019558611c1ad7684@yourcmc.ru>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f1600745ba7b328019558611c1ad7684@yourcmc.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/5/25 17:58, vitalif@yourcmc.ru wrote:
> Hi!
> 
> We ran some io_uring send-zerocopy tests with our colleagues by using the `send-zerocopy` utility from liburing examples (https://github.com/axboe/liburing/blob/master/examples/send-zerocopy.c).
> 
> And the results, especially with EPYC, were rather disappointing. :-(
> 
> The tests were run using `./send-zerocopy tcp -4 -R` at the server side and `time ./send-zerocopy tcp (-z 0)? (-b 0)? -4 -s 65435 -D 10.252.4.81` at the client side. 65435 was replaced by different buffer sizes.

fwiw, -z1 -b1 is the default, i.e. zc and fixed buffers

> Conclusion:
> - zerocopy send is beneficial for Xeon with at least 12 kb registered buffers and at least 16 kb normal buffers
> - worst thing is that with EPYCs, zerocopy send is slower than non-zerocopy in every single test... :-(
> 
> Profiling with perf shows that it spends most time in iommu related functions.
> 
> So I have a question: are these results expected? Or do I have to tune something to get better results?

Sounds like another case of iommu being painfully slow. The difference
is that while copying normal sends coalesce data into nice big contig
buffers, but zerocopy has to deal with whatever pages it's given. That's
32KB vs 4KB, and the worst case scenario you get 8x more frags (and skbs)
and 8x iommu mappings for zerocopy.

Try huge pages and see if it helps, it's -l1 in the benchmark. I can
also take a look at adding pre-mapped buffers again.

Perf profiles would also be useful to have if you can grab and post
them.

-- 
Pavel Begunkov


