Return-Path: <io-uring+bounces-8658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67400B02D7F
	for <lists+io-uring@lfdr.de>; Sun, 13 Jul 2025 01:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 388E64A336B
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 23:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383AB21D3DD;
	Sat, 12 Jul 2025 23:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aph2W0uv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5BE21B1B9
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 23:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752361555; cv=none; b=HZMIu3/SFXyZxz+Zpd3Y2jCVUWj3WfbqKAjPJYSLuzYaK4skaKxsE2zXljTFZharXx6H72lDd6TKkQFmPakW+miboU+/LoRthA7nWGaLfNIVQ2Zt0aoNnyEezrur8M0WLztLzlu6qPYfOxQ6BCxjmmI02Ky4katubw4J1upD5P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752361555; c=relaxed/simple;
	bh=h3NW5a0BAnqi3ZnbW2SJ2TeNvmoD+oJDCn0FwZ02BDU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=kKYOkb0AiYOgHWFbVgvMaw/MOJWbiA9Y6569LaNjrqQzT8yjLPItXCT2MATwYnHSUUofSZuZZ+2QKw3bhAtOB/HBvhkYIB+8rQ0xao//k7LA2RKZLpS4aKD5/n/pXEBlQWY1l9f5OP3JsrNg6wH7vDMpAsZkY7btvAy5qnMF4fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aph2W0uv; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-86d01686196so92089039f.1
        for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 16:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752361550; x=1752966350; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IUUJ6KDavza+kSRhoG3IDz0fbm0VUvQsAlXONvgJzOg=;
        b=aph2W0uvSjelQ1UX9K0x6yXgvQ23u1GpgaSlyuPE16Gtiov9xnLd6RU2ARPF9RvxCt
         5iwJrYsZGC1/jWmG92/W/3EFnrx3OJaDvhrjyhC9UWw8w/k+R1rJRtvUz9z6QVJqQnng
         DxmulKjABXfe+cR4QYiaFnLHK06zs43fIL0KFH4S1PZh7eZlg7G1R8fjwFJ/Tt3fkjtT
         7x2JuJvhty5RZH3zcCevVSy5O8apAloel21Cn8bWG/bcSvCn50l4uZ9Y60HAWSN/YiNf
         WGFnvfT3zBVweF5hT6YuvRMKwcIDYWljYAYVPwRxC6fZST7iGg7i1uMZ4GWwRTw40+rR
         9xww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752361550; x=1752966350;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IUUJ6KDavza+kSRhoG3IDz0fbm0VUvQsAlXONvgJzOg=;
        b=iJ8h7DItzTOAQisV0l+bLHyvaf4aiaUGT1m+12nS9UOyHmG/nWwSu1d+lno1klmOL5
         elN/LEHh/v1SdxusoYJK63Duk6eHfb04iBXGL7AyyjeejbrjTVtUKWFLgWs4CjkX8XFs
         3YPoZEI3omYykk6ZjbK1B7OHVsrn1Vi0+A1rdDuC25LW44OH/K9OGURAYFsC87z0VUo8
         WEtp7NCQ9UmgrKw3ntheEtZ6L199MJJMtkSBDYn5lJ1gV1KnOBzUPW7VyLkjDFaCgYsB
         zti/V4Lk4lToFC3/YttMwZ0m3uHplQuYBFHusRaNhNXRD9CoizsoIGq2kDpUQJF7QHbz
         myXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaa3Q4KEUbTAz7oQjTY/ktiWWJQeu0wyX6LE1O91UNSC6/3ngrQefdGi7dPcq1/BIGwNAdpidmsA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzrhlCu74n2kEpKbI2wl3ID6C4yQ+FjlFZBs+aMsKU9mb27AgZJ
	U+x+2RIOquzlEGGnas+WVWVXSsm9idwhxdhUI/WlAWAVhxFDIiCgLRHR8eg8iA1L3uA=
X-Gm-Gg: ASbGnctdfkLdC9b6ShjHHItnujFMMm9Kk+aXSpw36vaMTFm3l3/o7PalO5pccm1+wk9
	4uycgxvyCG+2ZDlBcUHLUmrxdqCZhdAKovTNEyRr+Uf9AjNzSAVdb0MBsA26zp/sdKvLHwtHuj6
	3IGDtX9NCGIIcBZaQU93ErHpsq+9Q5fDQ3W9zSPd3G0GEmmRTqMNd4hZXigHtMoy9ooRkaHsRzy
	HqrQ9YbuCyPrG3V1nidFxWCxZiBI6jfsKM5ljejPdgImvDKAZvUQ8m+9aulBNm90pbkjWsPliQQ
	jaLMeHNoBG2Em5xP2wzYu/cOQ5t2b8+S02szvcm32Q+faWjGnJKwbh0IHiTTryDBV8gDtfOcAqV
	Bg95Op0qAiUlbrVUNLCc=
X-Google-Smtp-Source: AGHT+IFOifpDIBffwWJKS0/MyPYg7H5rHBd34uGluQk1/c52XDDb4TfMbp2v211zj227xjhyEkq/Mg==
X-Received: by 2002:a05:6602:15c7:b0:876:a8dc:96cc with SMTP id ca18e2360f4ac-87977f8234emr1084771639f.6.1752361550430;
        Sat, 12 Jul 2025 16:05:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796b90594csm180684639f.19.2025.07.12.16.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jul 2025 16:05:49 -0700 (PDT)
Message-ID: <d738c715-dde3-4d02-8e38-5e8543dc91e6@kernel.dk>
Date: Sat, 12 Jul 2025 17:05:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: add IORING_CQE_F_POLLED flag
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-4-axboe@kernel.dk>
 <7541b1b5-9d0d-474a-a7d9-bbfe107fdcf1@gmail.com>
 <1aaef260-08a2-4fd1-9ded-b1b189a2bbe4@gmail.com>
 <ada8bfa0-e6fc-4900-b54b-40d2e18a54f4@kernel.dk>
Content-Language: en-US
In-Reply-To: <ada8bfa0-e6fc-4900-b54b-40d2e18a54f4@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/12/25 3:02 PM, Jens Axboe wrote:
> On 7/12/25 8:49 AM, Pavel Begunkov wrote:
>> On 7/12/25 12:34, Pavel Begunkov wrote:
>>> On 7/12/25 00:59, Jens Axboe wrote:
>>> ...>       /*
>>>>        * If multishot has already posted deferred completions, ensure that
>>>>        * those are flushed first before posting this one. If not, CQEs
>>>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>>>> index dc17162e7af1..d837e02d26b2 100644
>>>> --- a/io_uring/io_uring.h
>>>> +++ b/io_uring/io_uring.h
>>>> @@ -235,6 +235,8 @@ static inline void req_set_fail(struct io_kiocb *req)
>>>>   static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
>>>>   {
>>>> +    if (req->flags & REQ_F_POLL_WAKE)
>>>> +        cflags |= IORING_CQE_F_POLLED;
>>>
>>> Can you avoid introducing this new uapi (and overhead) for requests that
>>> don't care about it please? It's useless for multishots, and the only
>>> real potential use case is send requests.
>>
>> Another thought, I think the userspace can already easily infer
>> information similar to what this flag gives. E.g. peek at CQEs
>> right after submission and mark the inverse of the flag. The
>> actual impl can be made nicer than that.
> 
> As per the previous reply, not sure it makes a ton of sense. The initial
> hack I did was just for sends, and it actually just reused the bit for
> SOCK_NONEMPTY, as it was only for writes. But then the concept seemed
> generic enough that it'd be useful for writes. And then it becomes
> mostly a "did I poll thing", which obviously then makes sense for single
> shot read/recv as well.
> 
> Now it's taking a new bit, which isn't great.
> 
> But I think it's one of those things that need to ruminate a bit. Maybe
> just go back to doing it purely for sends. But then perhaps you'd
> actually want to know if the NEXT send would block, not that your
> current one did.

This is closer to what I originally had:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-send-full

with adding REQ_F_POLL_ARMED and then using that just on the send
side. And reusing the value of SOCK_NONEMPTY, as that one is just
for receives, and this one is just for sends.

-- 
Jens Axboe

