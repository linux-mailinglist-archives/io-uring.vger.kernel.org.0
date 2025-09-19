Return-Path: <io-uring+bounces-9853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0CEB8AA82
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 18:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CAE118980D0
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 16:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAD9241665;
	Fri, 19 Sep 2025 16:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3fomNiI5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DF223BCF3
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758300982; cv=none; b=NAk2OXOdL4teMkwGXl/pwETcvfDDi6O5ZiqnevgTausxFHXD672pgkrDP9NgYZ8cYpaktoPEP52DVoVSu/IIpzotBg1fUHj4QSLfKpIr9iq9T6jAzay5tsugngKen9WVNst0x/U5WKWtB47hzaBnKL8udM1498NFYYHY6uvV/U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758300982; c=relaxed/simple;
	bh=t1WvHdQIZSdv7ad40StBMYrmh6AiTRbechTDtQLkv5U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=uPra8/1myU63ob6ASjl95AtxLrCHCVQdYhmAbiCcYWvaV8sNL1V9fTc5A3wc1bGUkY0rpcGmSceMWJQNypraaxuqrbX0pxWgFNwNCoD3dhZqmfwwrUbySxz+2RNxygSRHxxbARbuJI7kMhrTQ86u9s6I7ms+fegSpGAL3JhueQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3fomNiI5; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-42487ec747eso4747745ab.2
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 09:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758300979; x=1758905779; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6pIy1gOyk+2PN4WW/gc2M6FQ56REZChRGvuWm/dNtSs=;
        b=3fomNiI581U9XrNFwmnOmOUJLf+fBCc72pIrtJv+Dcejdz9+H7ANmOvIftWVcB75dF
         FpMeQGRRs9jsLxJf4v3YwyOlL3fh7xVWouyNVxg6z4rVgYAW3MC2n08P65Pz3hrY0SWX
         3b7vu+neYOppkE5wTSiYVsryzgMMl0Pa9A8/mY3P+22ofZkl0MoGS4A6615EHgMi3803
         QI3yT4WdUTIEdK3l+nboW8jSZm/sv95vXSJWJ3noOFVx3jta7Ey0KecsFHzrH8lCy/dc
         9AvSQragoPHv3yI9QYBT3eVLalnP2hb8XvbdymKtVpox49mE64x/r5t0lFT7JimxF8L1
         NFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758300979; x=1758905779;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6pIy1gOyk+2PN4WW/gc2M6FQ56REZChRGvuWm/dNtSs=;
        b=j4Q8b8qqzvJPLJKEN7jxAR6Pdy7N0as0kHclTd62OwLk7I4zY+I476/0dMC+ph2iZ8
         3oGaF0pKWzLSucYTul7RDLxIV9dyXrLf55aTBXkheER/BOMVWd9ePlz8+f6OVyGd71jH
         xq5b5QSrQ5abdf3a5dOFtiGxeq41fDTfHbyY4Gs0FT6lzzo/V5A57DRRX+aR1KYgBbbJ
         rSQ192BoXil5qENfcjGDON1Yuk6NrI2Chb7JSX4H5ucJnBzl1GXobVKpWOPPOGJzc1Mp
         4P+C1GzQy5jU85r5hYdZHJSEf0LRFAKh+YogoJpRuCOjC8Mm8pEsYgb7Ktk9muX4DJMf
         CetA==
X-Gm-Message-State: AOJu0YzGcaXfSzVXiijyDbl+WVgoAoW1TWoy1jPbaqpKJw5IyBnwzoZ4
	EdxmIBI4s7/iUU/Wf4YFLq6THRxZAuOlz0ru1Qq5YhrCW6QxtNA3RphDlOzbdQHN4ghHwqoeOMA
	/S2olUXk=
X-Gm-Gg: ASbGncsWzDR8X0I4EM7Y/DYnPaSGURErXlKpv/Bn+ma0q6JyKGnN0F/kpLzY1EldRhY
	nOpUySt4exFwI0uhuvJs4viNCLsjkQvpOG8W09+6QwIvpRwWPSrWy+HFCd2GwlO65xD22b533gR
	2j7NMqXeYGq/w7ZlCQ4U81hyPySJ3vczM9QPd2c8PlmXJJCvFbynv3EM04/EUsWtwk8IOn4H5yJ
	Nb5gHIrcrU/iCg40FaOsv1r5zCvVBJ2Sl6T/BNGxegNIBzz8A6cKuIFwB8SJmX22FprdlUJTs1L
	4LvikVSgU+eLhek+VPLOzF9IGWQqjn4xqvzYQUfIOpMVMPyraOSYXxA89V1L0RPtSZ6q0ip6rwE
	YRu1TKnLG020fbQFpNrs=
X-Google-Smtp-Source: AGHT+IGZMilReBVdwpEX6HdtfZ0i//05aF00lr0qEMUQIMwVg3G7qT7EXs71setCXMwXU7jQOmkA/Q==
X-Received: by 2002:a05:6e02:2167:b0:41a:2b67:2690 with SMTP id e9e14a558f8ab-4248187d2c0mr64475035ab.0.1758300978593;
        Fri, 19 Sep 2025 09:56:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d560d3993sm2322369173.67.2025.09.19.09.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 09:56:18 -0700 (PDT)
Message-ID: <55ffd8a2-feca-427b-90f3-151e3e78ecc5@kernel.dk>
Date: Fri, 19 Sep 2025 10:56:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/6] Add query and mock tests
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1757589613.git.asml.silence@gmail.com>
 <175828771958.850015.18156781064751353661.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <175828771958.850015.18156781064751353661.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/25 7:15 AM, Jens Axboe wrote:
> 
> On Thu, 11 Sep 2025 12:26:25 +0100, Pavel Begunkov wrote:
>> Also introduces a bunch of test/ helper functions.
>>
>> Pavel Begunkov (6):
>>   tests: test the query interface
>>   tests: add t_submit_and_wait_single helper
>>   tests: introduce t_iovec_data_length helper
>>   tests: add t_sqe_prep_cmd helper
>>   tests: add helper for iov data verification
>>   tests: add mock file based tests
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/6] tests: test the query interface
>       commit: 7e565c0116ba6e0cd1bce3a42409b31fd4dd47d3
> [2/6] tests: add t_submit_and_wait_single helper
>       commit: f1fc45cbcdcd35064b2fbe3eab6a2b89fb335ec6
> [3/6] tests: introduce t_iovec_data_length helper
>       commit: 7a936a80be37f50a1851379aa0592eeb3b42a9a1
> [4/6] tests: add t_sqe_prep_cmd helper
>       commit: 7d3773fd9e5352b113b7d425aa5708acdd48d3c0
> [5/6] tests: add helper for iov data verification
>       commit: 9e69daf86de39c9b4e70c2dd23e4046293585f34
> [6/6] tests: add mock file based tests
>       commit: d5673a9b4ad074745e28bf7ddad3692115da01fd

I noticed that there's no man page additions for this. Can
you add something for IORING_REGISTER_QUERY? Might not be a bad idea to
add a helper for this so applications don't have to use
io_uring_register(), and then the documentation for how to use the query
API could just go in there and just get referenced from
io_uring_register.2 rather than put all of it in there.

-- 
Jens Axboe

