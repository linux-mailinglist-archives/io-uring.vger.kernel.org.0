Return-Path: <io-uring+bounces-7354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF12AA7829F
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 21:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F9A81888C72
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 19:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5FD20E6F9;
	Tue,  1 Apr 2025 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Iw1PCjOy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54DF1A7253
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 19:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743534748; cv=none; b=WJ/cC8lE3nUP+S5eJ8Aq+vu9XCV+wr+GqILasjKMyzm4P7S+5bTjFfzP3/LVPvpG047T0zwr7jdEOJrGjIoPQe7hutrT6QZcoQCkEp8K77VLkC5Een1izcGOsWIWyCnxcKRx5jmuZ/GQ6gx7poCcQAp/pPA3ktcA+WLXJtzNKyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743534748; c=relaxed/simple;
	bh=eAQVZUQs+EmMrKpIZPMeHucISBrVQJw3Vs0Szl2gbi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uk7/+UeVWaha8/y3HjqxOFvK2ddhkfzAg6nRtCV2XbRfAJC3Fy1oG/i8CGlsKMX5/4XcUwqJ2fKGGW0TXHyPMWcOlQTwqREtVrL6aB3aBjmVVa4KY2nZOrh5t1LU+5Zcjyl7tKLOejL7DGZGzSBJcDd8QiYgy484roUUTSduTJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Iw1PCjOy; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3cf8e017abcso24275975ab.1
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 12:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743534744; x=1744139544; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mNOpdjfSxsaQ6kxQg3VPtD5H95PG7oR89VrL16uDA2k=;
        b=Iw1PCjOy7DRehbRm1ACVIvIYwaFwgCGKeLBTCtvA/dnAhrzAOMX14Sm+S9ORPunyMD
         4HCblyyTDsxnH5ID54BIf8hxtdFk4ZfKNbEaHt4zZTKncc8+qa5Nt0/VrmtknwLUMOIV
         8Dhpw44D2MCZNJneuqnotTqgcsivWPXsTsWfIAzVdrqB1zcIu5oNKFWgOsqAsKsv/rPY
         L3kRuw4/4IjjBIGL91nYnD783h7B1RQBJ+XqtIwKOYf62mT77tkkkatcyM9Wc6vXvra1
         7PhNy3OUs8XMYNzJ0UsEGrrLWai5kZESQjce3oyavLcSzqnHAzdFM6VseFCcMNbrLXxL
         Hihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743534744; x=1744139544;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mNOpdjfSxsaQ6kxQg3VPtD5H95PG7oR89VrL16uDA2k=;
        b=t/Bsv09sB/IgoI8D/RWuHKr+AX65RH/MjpkDtDHg0p+CDFM2BYvvMZIsPShcOrJZ6I
         86K7GkVdt+9ri7ok+gazwgxgSIJC3UQP98S6EYw9n5SmjC/Gtm6+iigyvphWIjBlehUv
         H0WZH4y4+3+bpAp6kdlnpvmS7usM5GdYtaeDAH9WblwFGp7jXy4wDPIFolOSorEPMT9k
         LHe/wof+bkCEZOJOGBbeuHDr2wnMoeJ8zrxLexERqBAzVdqFGFM1UKqOE2O7j9puIaNu
         P80QXGyOFc6R0W25zeXJKXUc+2lIMghMgMddCsMl8MQ5zLJgmoreBSFVt/34a25tzvda
         HQxQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6giKsgIRVVnymFGcSqM4dBdJVYzZ1+FtKY2whnCQ+oviJIyPJ7ecBSZCBsud3K79yO4W55q4sQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPr2fjiLB49HL6ST4obhwNSMrry/mVajuKYhb1dyeFA5HAeh4g
	2jvSKN+65jAdQHkiiRbjRDVawnUOO9Ipo49/lAXCg5nDy9LcKfGu61UPmZW4DdA=
X-Gm-Gg: ASbGncujCE0ZdckSIWe12HZpC1Lj8tPlqtSwidQ2V+i8MlX7IrJOKG5ZqKE8LeMPuOR
	bQcb4vhI5x6J3dcfMnyvSeCIcORQvTkEVBfAo6zB2Os9rfc+uuSKNcpZdZjYXZmjPBa8SuoVNqc
	gQldC47e1B5QOeO5nNdpU485WzfsN/cVJnVnS1ZIi0UwXaKrg3WQX3CdHRByWKSjddwcfe8yGJF
	d6cGlXmdy/DoLS3KRRhSCjmyyfXU0eo5p4c4hdViVsDxSczhc9mBNO2+8jW7S1yhFtmsi2KJL8T
	O7wUOTWkx7KZiAWxb8XgB7YJgkAM83SQsZuzX3QWLbvIRpHvbiBB
X-Google-Smtp-Source: AGHT+IFf1iWU+UL97ExpA+SqHCgxDOQNpbFNj00K5tdoP0qec11ojyhUjHhnCPX5aRmUioQIL467IA==
X-Received: by 2002:a05:6e02:17c5:b0:3d4:6f9d:c0d0 with SMTP id e9e14a558f8ab-3d5e0909503mr159231755ab.8.1743534743719;
        Tue, 01 Apr 2025 12:12:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4647186desm2580540173.10.2025.04.01.12.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 12:12:23 -0700 (PDT)
Message-ID: <3c1a39f0-a6d7-41af-8235-af299f164633@kernel.dk>
Date: Tue, 1 Apr 2025 13:12:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/zcrx: return early from io_zcrx_recv_skb if
 readlen is 0
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250401182813.1115909-1-dw@davidwei.uk>
 <e89aef50-7364-4ab9-9582-aef6aec8cffb@kernel.dk>
 <20e4d11f-688f-46de-9094-765073f0dc41@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20e4d11f-688f-46de-9094-765073f0dc41@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/25 1:10 PM, David Wei wrote:
> On 2025-04-01 11:56, Jens Axboe wrote:
>> On 4/1/25 12:28 PM, David Wei wrote:
>>> When readlen is set for a recvzc request, tcp_read_sock() will call
>>> io_zcrx_recv_skb() one final time with len == desc->count == 0. This is
>>> caused by the !desc->count check happening too late. The offset + 1 !=
>>> skb->len happens earlier and causes the while loop to continue.
>>>
>>> Fix this in io_zcrx_recv_skb() instead of tcp_read_sock(). Return early
>>> if len is 0 i.e. the read is done.
>>
>> Needs a Fixes tag, which looks like it should be:
>>
>> Fixes: 6699ec9a23f8 ("io_uring/zcrx: add a read limit to recvzc requests")
>>
>> ?
> 
> Sorry I missed that, will add the tag.
> 
>>
>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>> ---
>>>  io_uring/zcrx.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>>> index 9c95b5b6ec4e..d1dd25e7cf4a 100644
>>> --- a/io_uring/zcrx.c
>>> +++ b/io_uring/zcrx.c
>>> @@ -818,6 +818,8 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>>>  	int ret = 0;
>>>  
>>>  	len = min_t(size_t, len, desc->count);
>>> +	if (!len)
>>> +		goto out;
>>
>> just return 0 here? Jumping to out would make more sense if there
>> are things to fixup/account at this point, but it's just going
>> to find offset == start_off and return 'ret', which is 0 anyway.
>>
> 
> Makes sense, yeah. I'll return 0 here early.

Probably augment that with an unlikely() as well for v2, it's definitely
an error/unexpected case.

-- 
Jens Axboe

