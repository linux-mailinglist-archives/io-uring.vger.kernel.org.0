Return-Path: <io-uring+bounces-2760-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F7695111E
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 02:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5930D1C21DA1
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 00:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB3D63A;
	Wed, 14 Aug 2024 00:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YLAwnUSd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA9E469D
	for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 00:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723596219; cv=none; b=jbgWh8ymkfJIdLUzCtfRatet4u8gOL8uIAlCW+NPpmFY6nPYWojFIQ0NY66Wqh0IWlOaeuUnW/D/wYl7spVU8yHWhFtspVYVbVuoMAUOJud+RQMy2TqBLIoaAPlhz1OJq3DaJ5zq81ySfIw3NsZkQkILbLHlY2YwzXKSByHXaqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723596219; c=relaxed/simple;
	bh=QrqBvh1sflAALKepSGFgh1RhVdzaE28UnClrKiKRI6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uemzvQPxT2JLbQH+A7JG/VN7mGG3bPskrqG4C5617xMzNwIeK5yTILV/wvUZghCQJpcDLggUB9txzfbb2klx384aZvM6jmvqX7HuI2UAlLC9QWTTcfTSbGm7e2i+qvzVutI/pvfmVwfpFdrwhBStM+Z9QBisFK045sJMPedDxUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YLAwnUSd; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7aada2358fso63070966b.0
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 17:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723596216; x=1724201016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CqOyvXFib6EMxaKg14UstEhQYLMJUzTyHq4svwPHBuQ=;
        b=YLAwnUSdtfo/joi+dkHDohQmutuS54d+992bNlsyhg4R2cObHI/InNdORhKalhlzUu
         vRI0HqUjRaVj/AHymKqp5o/k0a/STXxmpliNTLEIZT/Yc7sNJf5sBEgUEtXwSfcchSOX
         bc0y987mQ3K5jEteCNlKr5XtY82jMKwQZ2URxw5geQqK5mzyhxg5KPKsD0Xlx1OXRMXu
         1UFjtJ4uHcyAXGShyumhbRPqk/2RZEyPw+PmATF7pCIhy7r7Cm2j2Jwx3+982sJeJKhx
         vA72UaC0gAg99OY6QTA+UBe0DoltOZF0pNJ0YVNivbmoh4WCseH3O6RTkLRXJ+8aIICe
         GcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723596216; x=1724201016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CqOyvXFib6EMxaKg14UstEhQYLMJUzTyHq4svwPHBuQ=;
        b=GiwMOCG1dDAPkvJ+OlOsMhLN3tzQ8pgBURWZq6keUB3NULMhL3jWyVR8I7vOYZf5SX
         SXM1FaZtZiAtd9e/j3AnZaPlGnNgdR7hYhHYjG9OLcVbQf4KnL1uuDga5DygDkPJYvEi
         BFSjknsirIeAy/QlCdlzAqhVEiYozo0SZ3pU9CxDdelwdwMXU9xt8kkrakn0e5fGIYMg
         CkZHpyWddKIOUL0ZNNevwmi4Gq5csDQqOPVVi3NcSUBjgPbBzmKVA5q8sQdhONCVaeml
         F9hJFoZxgE2D5FDVB7e5oXCtlYmsCnAOa7imbgRllwm6EJcth2Xyx8gyMeao+W/YN1CU
         gpcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVo9d4fBKsQooPVGNRg69bnNMx88LWcw6IwVYlQ/pCEltdtpjV4PbmzKb2CG97FkyWRCRKX7owggR5xClH07goJM5OOSpi1XmM=
X-Gm-Message-State: AOJu0Yw19IBUM4Z8/5sSGxXCrVZCIMnTIUJuQfmMWor7VLgn9jF80+qK
	2AM3Cx+KFB7kUFWiFLAK/hHDOXr/luL/G9NMkEhIZzdvbts9Z5Uy0DuprsrG
X-Google-Smtp-Source: AGHT+IGkYNUfznYIQhVjzKkvsS4UdWH0YXRMBGEkNn511LKCYfH65FTcJve4DdTTry9ieY18i8WqOA==
X-Received: by 2002:a17:907:3daa:b0:a72:64f0:552e with SMTP id a640c23a62f3a-a836ac120c8mr28998166b.19.1723596215359;
        Tue, 13 Aug 2024 17:43:35 -0700 (PDT)
Received: from [192.168.42.69] ([148.252.132.251])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f414eb8dsm110524166b.162.2024.08.13.17.43.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 17:43:35 -0700 (PDT)
Message-ID: <0575d23b-bf1b-4ffd-9edf-b12c3a8ebe2c@gmail.com>
Date: Wed, 14 Aug 2024 01:44:10 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
 <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
 <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
 <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
 <e7e8a80ffcca7b3527b74be5741c927937517291.camel@trillion01.com>
 <bea51c28-17e0-4693-96bf-502ffa75f01a@kernel.dk>
 <a01899e4b4e6f83f5d191a1a26615655d97a4718.camel@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a01899e4b4e6f83f5d191a1a26615655d97a4718.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/24 01:09, Olivier Langlois wrote:
> On Tue, 2024-08-13 at 12:35 -0600, Jens Axboe wrote:
>> On 8/13/24 11:22 AM, Olivier Langlois wrote:
>>> On Mon, 2024-08-12 at 14:40 -0600, Jens Axboe wrote:
>>>>
>>>>
>>>>> 3. I am surprised to notice that in __io_napi_do_busy_loop(),
>>>>> list_for_each_entry_rcu() is called to traverse the list but
>>>>> the
>>>>> regular methods list_del() and list_add_tail() are called to
>>>>> update
>>>>> the
>>>>> list instead of their RCU variant.
>>>>
>>>> Should all just use rcu variants.
>>>>
>>>> Here's a mashup of the changes. Would be great if you can test -
>>>> I'll
>>>> do
>>>> some too, but always good with more than one person testing as it
>>>> tends
>>>> to hit more cases.
>>>>
>>> Jens,
>>>
>>> I have integrated our RCU corrections into
>>> https://lore.kernel.org/io-uring/5fc9dd07e48a7178f547ed1b2aaa0814607fa246.1723567469.git.olivier@trillion01.com/T/#u
>>>
>>> and my testing so far is not showing any problems...
>>> but I have a very static setup...
>>> I had no issues too without the corrections...
>>
>> Thanks for testing, but regardless of whether that series would go in
>> or
>> not, I think those rcu changes should be done separately and upfront
>> rather than be integrated with other changes.
>>
> sorry about that...
> 
> I am going to share a little bit how I currently feel. I feel
> disappointed because when I reread your initial reply, I have not been
> able to spot a single positive thing said about my proposal despite
> that I have prealably tested the water concerning my idea and the big
> lines about how I was planning to design it. All, I have been told from
> Pavel that the idea was so great that he was even currently playing
> with a prototype around the same concept:
> https://lore.kernel.org/io-uring/1be64672f22be44fbe1540053427d978c0224dfc.camel@trillion01.com/T/#mc7271764641f9c810ea5438ed3dc0662fbc08cb6

I've been playing with it but more of as a mean to some
other ideas. I had hard time to justify to myself to send
anything just to change the scheme, but it doesn't mean it's
a bad idea to get something like that merged. It just needs
some brushing mostly around excessive complexity, and it's
a part of normal dev process.

> you also have to understand that all the small napi issues that I have
> fixed this week are no stranger from me working on this new idea. The
> RCU issues that I have reported back have been spotted when I was doing
> my final code review before testing my patch before submitting it.
> 
> keep in mind that I am by far a git magician. I am a very casual
> user... Anything that is outside the usual beaten trails such as
> reordoring commits or breaking them down feels perilious to me...
> 
> I had 230+ lines changes committed when you confirmed that few lines
> should be changed to address this new RCU issue. I did figure that it
> would not that big a deal to include them with the rest of my change.

The main reason to have fixes in separate commits from new
features is because we're backporting fixes to older kernels.
It's usually just a cherry-pick, but being a part of a larger
commit complicates things a lot. There are also other usual
reasons like patch readability, keeping git history, not
mixing unrelated things together and so on.

-- 
Pavel Begunkov

