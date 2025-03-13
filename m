Return-Path: <io-uring+bounces-7075-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AEE7A5F728
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 15:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E2B919C2465
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 14:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72032676EF;
	Thu, 13 Mar 2025 14:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="p+TXWiZM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B195E11CA9
	for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 14:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741874480; cv=none; b=BeAoRiHgu0Nf6kFTMPWhN2WDPCW9pM3RhzoCX5P1KIIBPxTcCvh1iOBEDbUQjjwnbuAbhZz4g6HS7T5Eus4EceZ1CdtddECG495Oq5hWPRlX/1FwYP/lVy4oYfu45ChOpxfI/f6gZ3xurdmHaGC/yBp5QtfRJic65LwMo3lwddE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741874480; c=relaxed/simple;
	bh=oKH7Elamr+t/LNBhDFaCjq8k3Yhh1qOu2+6iErHVUsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sV9H2w+oV0wiKA8sURtQBuFGv/dkbTLctl1uxWmeBE2Q4khFK5z4rNnXN4DTqYA26ZSnMZLFlwI+6bC0tlLdz3EUg5bOjmfur3fhUZvBC6PWePoUG+1Fq7ipyo+9SVroe1tKAFB+0mW2QTUIEHDxFG+8VsCCHv7CqsWyUwcJSQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=p+TXWiZM; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-85ae131983eso87074939f.0
        for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 07:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741874477; x=1742479277; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qDdThx9JUgAoiyQ7U+14OO8Q3xFSMds/LhAjusQXTgE=;
        b=p+TXWiZMTo1ccrCIfpXiRSLOKVeuqEjQzc2yy5y3GKljD2dbKVZHiLRVJE94abI9XX
         rjMnCmu6TXd1LRA+2jlnyDzkLvj8vric9AL9a9RhVMHE5lL9i6T3ZJt/HupHFdz6P2qE
         MyOFszdLRy2wilPtY7rBgJjGdvZv13VOQK45YML8Tcqu8H1ByIttR3mSY5lF0HQRbXoc
         Qscc5STMQP7Yz7E+VJKc7XGOXa8zOJva29dBjIrWD8KKMAO/z5u7GU39uSw06vSFhKc7
         yOXZuq+yh2ICuptKYK0CnRKtWAHqz/WqZZ4Uei+qEDHGlZg6NnfxXaT25qTK+07ACvyw
         YN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741874477; x=1742479277;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qDdThx9JUgAoiyQ7U+14OO8Q3xFSMds/LhAjusQXTgE=;
        b=wIHxzE2kODwN8ROH/3TJBbQfUGt/HwCd2nH3zCq0PfnUxpvxtIv/0vJ//pTaOPK2CI
         eKuwNn/qNn5iiR2GZvtL8xONcH0eqhMKAlIqJTGwKMdccL2NRLt4x66lR8huyMCsxNV3
         sKLQhCDNBbrN8B8rXe3hsK6dij3Lp7wOPx6YnlGelM5tmxyXECv4OFyruPtqAvBIB/vY
         RtzInbfJ2b4Bk3QCK/+Qe42ks09SyP568aGS3m41gLhZKqDfwvo5yjdrxx4g4nPhun9u
         p4B1sDYIr8WlsVUNXq9TjrkCvpMEiNY/btljCghQu7xCn2ccr5rIsnG3Tv3S/ggj9f6Q
         Ydnw==
X-Forwarded-Encrypted: i=1; AJvYcCU1d2Qr6Rmf5NTIm++pSQfdCXxGzgec/8p9rQS2VuuxPqXHrhnTCVpT9q+a3xTo/eEggjH5uq9nCw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yye9S/KI7/YlK0wRLnRmcaj97txsZ+qHWDVkfYQK8vKrg7ehI2e
	WH80AvtP+RflFpY6KALj4B7PAkKG/H+30vgzF0zPgpX+ffgnJDEap8N5BHhTa2w=
X-Gm-Gg: ASbGnctkaFStrWMObLXUWP0YXJeSS55IvDUJ47K9QbH1uhpEaWTrCmko7+fjHTtBVVB
	RVZsdJGM0r8JOxDMRaMM2cSO+YxLHdo7z/1+GmFLeN24wZJmfMs+yde1QEh4qh1gEcKzeISYJ6y
	PkplQ11NcKYA61eKI5zaeH3ujsswkC+2ohof9peRS7ZW3BnhUf8afwf3XrA90d/Y5gb+SmyCxxz
	gWBRKTME6H7zWKrZSRXFEHfHdkHmq6DJyVBvnG6Mn8Wl3vygXAq4e3uiNNUc/Qk509L5LuIdHxN
	PKjGJwLOeb+dHULDWSu4nVUpTzcPORO4KWi+OB4G
X-Google-Smtp-Source: AGHT+IH8vt8kGcYmo8u1W+6aiVlKe9rMFhsAav1CA7QhsLQdsuy10Ep5nNiDNFdUkL+dAak9/7QM2A==
X-Received: by 2002:a05:6e02:1a24:b0:3d2:b72d:a507 with SMTP id e9e14a558f8ab-3d46899ef10mr119104955ab.19.1741874476689;
        Thu, 13 Mar 2025 07:01:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d47a67f5d5sm4164385ab.41.2025.03.13.07.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 07:01:15 -0700 (PDT)
Message-ID: <ab277f0b-fdf6-4f20-9fe0-0e0a1ebcc906@kernel.dk>
Date: Thu, 13 Mar 2025 08:01:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/2] introduce io_uring_cmd_import_fixed_vec
To: Sidong Yang <sidong.yang@furiosa.ai>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250312142326.11660-1-sidong.yang@furiosa.ai>
 <7a4217ce-1251-452c-8570-fb36e811b234@gmail.com>
 <Z9K2-mU3lrlRiV6s@sidongui-MacBookPro.local>
 <95529e8f-ac4d-4530-94fa-488372489100@gmail.com>
 <fd3264c8-02be-4634-bab2-2ad00a40a1b7@gmail.com>
 <Z9Lj8s-pTTEJhMOn@sidongui-MacBookPro.local>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <Z9Lj8s-pTTEJhMOn@sidongui-MacBookPro.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/25 7:56 AM, Sidong Yang wrote:
> On Thu, Mar 13, 2025 at 01:17:44PM +0000, Pavel Begunkov wrote:
>> On 3/13/25 13:15, Pavel Begunkov wrote:
>>> On 3/13/25 10:44, Sidong Yang wrote:
>>>> On Thu, Mar 13, 2025 at 08:57:45AM +0000, Pavel Begunkov wrote:
>>>>> On 3/12/25 14:23, Sidong Yang wrote:
>>>>>> This patche series introduce io_uring_cmd_import_vec. With this function,
>>>>>> Multiple fixed buffer could be used in uring cmd. It's vectored version
>>>>>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
>>>>>> for new api for encoded read in btrfs by using uring cmd.
>>>>>
>>>>> Pretty much same thing, we're still left with 2 allocations in the
>>>>> hot path. What I think we can do here is to add caching on the
>>>>> io_uring side as we do with rw / net, but that would be invisible
>>>>> for cmd drivers. And that cache can be reused for normal iovec imports.
>>>>>
>>>>> https://github.com/isilence/linux.git regvec-import-cmd
>>>>> (link for convenience)
>>>>> https://github.com/isilence/linux/tree/regvec-import-cmd
>>>>>
>>>>> Not really target tested, no btrfs, not any other user, just an idea.
>>>>> There are 4 patches, but the top 3 are of interest.
>>>>
>>>> Thanks, I justed checked the commits now. I think cache is good to resolve
>>>> this without allocation if cache hit. Let me reimpl this idea and test it
>>>> for btrfs.
>>>
>>> Sure, you can just base on top of that branch, hashes might be
>>> different but it's identical to the base it should be on. Your
>>> v2 didn't have some more recent merged patches.
>>
>> Jens' for-6.15/io_uring-reg-vec specifically, but for-next likely
>> has it merged.
> 
> Yes, there is commits about io_uring-reg-vec in Jens' for-next. I'll
> make v3 based on the branch.

Basing patches on that is fine, just never base branches on it. My
for-next branch is just a merge point for _everything_ that's queued for
the next release, io_uring and block related. The right branch to base
on for this case would be for-6.15/io_uring-reg-vec, which is also in my
for-next branch.

This is more of a FYI than anything, as you're not doing a pull request.
Using for-next for patches is fine.

-- 
Jens Axboe

