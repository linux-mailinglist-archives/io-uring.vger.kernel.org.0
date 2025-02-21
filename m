Return-Path: <io-uring+bounces-6611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DBDA3FCD0
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:06:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50A161764E1
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BE32475C8;
	Fri, 21 Feb 2025 17:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P/o2s9nf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABD02475E9;
	Fri, 21 Feb 2025 17:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740157513; cv=none; b=uRT82PgZ4D37PzMt/eHGeG5Jbblz8Bm/rhPd6ia/Wvc2aRFUctnhZa+TYJariMLbAOsWFevN2b7NVjFmAaXnYGI49L1eeiqHhnQ/IVs9dN242fUSm5a2rfyT4Zf3o8ZdV0275UX+Gm1PYPb2p+YQ8Q6mTvTxO2CQ3WPDg5Nl64A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740157513; c=relaxed/simple;
	bh=fApzqprR+kBcAG0IK+keq7VmTz0rdzUDdm/bBzx1Ydg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F1en+BF7irakdsjAU3A5c35CpbOYAckK8VlE30BBVBv5YHQPzSHtpBOw3LVRWA15YiMKfNor8kOKIwp+Cq4n6LISZ+1wHVkE7nblDbv3y+MYxJW0jxiS6dSfDPqTvKA5AR1zaTCjSOKjgJeTn8I6pYLYfswkczmrhKh3o7GrIqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P/o2s9nf; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-38f29a1a93bso1948844f8f.1;
        Fri, 21 Feb 2025 09:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740157509; x=1740762309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KRX3VkuTpvxQnJlyqWWAKHuLSqRVn8HPKCGBcwwEsXw=;
        b=P/o2s9nfIFdaLVEhrOuaft9gJpm08Wl+KWXRki4VMM4YhjWJ1ni1zEo9i/XfROY9iC
         VWedzgVqUhvi5kxg07YS58c8OM6noKuZ1UPLeutILcQKmaChFhmJI/Wwb9aCrSP0Lzlh
         k/5mZqY+4pEII9v9VF+GQRN8m6s8BzgQdfC5GtbT8Yk9OazADoObvms3TMJMztUpXvOp
         6+YTodxLyzgL8DU03efUw69nEai9iyGFZ6XEHDDyTXkX+myyey1VP9fDi3maIIlR01O1
         1SELCp9NLr9LFv2GSBOCdr76ZL9tWwHBU19T6FJB8iXAmPrwQZu+OqDSXYBfF869Juj9
         L2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740157509; x=1740762309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KRX3VkuTpvxQnJlyqWWAKHuLSqRVn8HPKCGBcwwEsXw=;
        b=kZ5DKdmX/GTT3gZkwWPy3MHjva0HWmLAqgjWw1/4pk5QZ/n+EkGVyiiRV96fh2lpDr
         tkyRPbh5pVKoFMciltEpWZVOLEl2dd8Ha0D6/VyCejf1Kh7RNC135Y82nVPuex7ujBpm
         aGXIvDzIgxZnRGKYgJC6oXn4Pd98OUIyCz9lw59hR3dm0v53jSv3qSdjZrjZU6sjqABl
         ThDCKayTKy5QmnUXYhX1vViV5eS2k9OpibEdTOGa1Frn61tsdqBevEi8b8DhYPAJN68p
         ti5yXcIglJKLR/gc+379e6/vY3LcdYUvk6NBZbgrpDYWY/N2CWHD5uyhEXj8XoDVLo5x
         BcFw==
X-Forwarded-Encrypted: i=1; AJvYcCXXadua7Oa2/ImINrp3lJEHRDvyoskD57YCLUxkG1ZxM2hHcWxNWh4EVju5zVv3hRk04b4Z2BSNDL1+mXTg@vger.kernel.org, AJvYcCXjnkDAnl0wq5qsB0/zePc2FHKFoqE6G4mBgZfL20vrEtLVCcscSOStxGHCw1uYOS/8KrCPxWUN8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxImLv1LSwneU7yaWD6E93DEENbZXM5ExgRHK1s0tV5bfHpfzxv
	RfspWd/y1tIr0ornkSM2PIExvw2eblTwnJD+vkgNrK7zsTOxNy+/
X-Gm-Gg: ASbGncutmA3Ur/ZY9JCaLXN63YGPb8rbtJy7+NOlkTXa8pyJ3mCt6jTxTzmMM4DXveh
	l2U+NwVG4nEfDgv3lyTk5wmDXrBFwPJT6PmMpGRXpNMGf7TuXkpCISr2KKl6tNjZnhYPpX1EE4z
	4bBfct2tb3iZtelaCu5I/XoZDDQ+Jwx80cvOXpfj1NEohu0E/QZ4tdVhbA6xybGGcoPFKEH81HA
	YGv+qdlS6hKY2ON8+3FU6dosycpv/ZIWNwUZsEEE5CrC8WEoNto3xmw7E0aF/n/dT+a6KaqyGYQ
	reF0EOCwbPgw/8DoAiEPqA84V+gkoxSLGXY2
X-Google-Smtp-Source: AGHT+IEMlVnkqCxUzksHUs5LQ2R7/mAK+ghtouNkT9cEa99kYGtaZy3dL4QaNKlQYSqzVdLX0zWXFg==
X-Received: by 2002:a5d:6c6f:0:b0:38f:2173:b7b7 with SMTP id ffacd0b85a97d-38f6e95c4a3mr3830573f8f.18.1740157508501;
        Fri, 21 Feb 2025 09:05:08 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.194])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d5e9esm24271471f8f.61.2025.02.21.09.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 09:05:07 -0800 (PST)
Message-ID: <d510f0c5-d25d-44cb-9974-46026964beca@gmail.com>
Date: Fri, 21 Feb 2025 17:06:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
 io_uring_mmap
To: Jens Axboe <axboe@kernel.dk>, lizetao <lizetao1@huawei.com>,
 Bui Quang Minh <minhquangbui99@gmail.com>
Cc: David Wei <dw@davidwei.uk>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20250221085933.26034-1-minhquangbui99@gmail.com>
 <590cff7ccda34b028706b9288f8928d3@huawei.com>
 <79189960-b645-4b51-a3d7-609708dc3ee2@gmail.com>
 <0c1faa58-b658-4a64-9d42-eaf603fdc69d@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0c1faa58-b658-4a64-9d42-eaf603fdc69d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/25 16:39, Jens Axboe wrote:
> On 2/21/25 5:20 AM, Pavel Begunkov wrote:
>> On 2/21/25 09:10, lizetao wrote:
>>> Hi,
>>>
>>>> -----Original Message-----
>>>> From: Bui Quang Minh <minhquangbui99@gmail.com>
>>>> Sent: Friday, February 21, 2025 5:00 PM
>>>> To: io-uring@vger.kernel.org
>>>> Cc: Jens Axboe <axboe@kernel.dk>; Pavel Begunkov
>>>> <asml.silence@gmail.com>; David Wei <dw@davidwei.uk>; linux-
>>>> kernel@vger.kernel.org; Bui Quang Minh <minhquangbui99@gmail.com>
>>>> Subject: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
>>>> io_uring_mmap
>>>>
>>>> Allow user to mmap the kernel allocated zerocopy-rx refill queue.
>>>>
>>>
>>> Maybe fixed-tag should be added here.
>>
>> No need, it's not strictly a fix, and whlist it's not yet sent to
>> linus, the tags only cause confusion when hashes change, e.g. on rebase.
> 
> I do like using fixes still, if only to provide a link to the original
> commit without needing to dig for it. And yeah there's the occasional
> rebase where I forget to update the sha, but those get discovered pretty
> quick.

Maybe a "Link" tag would be better or some more inconsequential
"Refers-to", but otherwise you can call it a feature and avoid the
hassle of fixing it up, and people getting spammed by tooling,
and Stephen having to write about broken hashes.

-- 
Pavel Begunkov


