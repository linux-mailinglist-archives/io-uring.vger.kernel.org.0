Return-Path: <io-uring+bounces-4738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8FD9CF479
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 20:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ADFC280BE2
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 19:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075AF1D5173;
	Fri, 15 Nov 2024 19:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RnXL55pb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FACC1D435C;
	Fri, 15 Nov 2024 19:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731697364; cv=none; b=ekRWIzxIRPXlHyDhbehgUuGjEgzw5tCbf3ih8czl8m3ddsw0+qG6146OeotsJFOi7lXWU4wtgf1FfChyGoXIE9v71KCs0/sYqp8lf01yPBu89PhAQmz4tO+qmjrgWDaoxcxRWt6o79LY7hqNs625GR004Vuu5nj6gnFNU0bIPjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731697364; c=relaxed/simple;
	bh=9vjLfiWYMSCyvWqNdv1hJFPdv5/hvv1FrIS5q3W2qeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sVQvCCNMS7oidg2Ujqq3NSq0i22gnM00C/4Dv5GBw+9ndrD0dgsZsxjGpSuOxZksBRf+w7Pe1+GAqYppe8E5TzB7vvmekIzk0GQeI3ZVedsx74bwkFC9NNT5nMNbXEZxFl/VK3JSdTvc469nCMajl1PA5ieVZ3sfPvqUty98WCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RnXL55pb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4314b316495so8525685e9.2;
        Fri, 15 Nov 2024 11:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731697361; x=1732302161; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OJeoXJwB9bUfd+K442tubIgDjv2gaR4dr6OV0PklIw8=;
        b=RnXL55pbflDHLC5ICsWa8IiTE+Xo1XOc0q1WWBu3/EPsr93Zh0mlmOvtZzvGwxOqBG
         +0e2ueisLkRuyd8z2YN6BCxLENBxTpNv6elEU5OWbQECHNBwGhDPvNVcRDksLPnw58nQ
         xtKten84PhRqYZtGLpZfNlBqFTPe28yXNHvioRcooj+1wjAumSqOUqqcXyWLhD90u5f2
         7TT5ABjP3h4x2rn4pXnt79ABHcKbZtpLgjkr22zKgzAms1V6bGgKlmuZz9ZeGQ3YzDfK
         zZqYNCxxyrqCKZs0CP2xaS0Dyy5mOeWvDPbhCKYORZWHOvo4M4SbZlUJgnij/v6kir6a
         NNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731697361; x=1732302161;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OJeoXJwB9bUfd+K442tubIgDjv2gaR4dr6OV0PklIw8=;
        b=EvabLHoaOZIPijhWFoPX1AISr9JFx0QPQHk/TAdWnOLJOEgBBzk14ZESkKPhwRU824
         TrZq7rkpUmR9EzReCa35PN2f/7c0QlkCq/B0H+rqdtQ2y4h3WYIWeKyemrF2NBbu8Z9p
         P2UVb+US0ZDNx2MuBQjpOkpwNI1Uu5IxXW0vIOf8fIbRUuwmWvn6Uv002bDt13FGNdzW
         MTOFHtsuQWLxdOQ5IsnRm0EUkrNZX0hlztikcRHgLKenjdUksUmGerzI/X3miftLZ3MR
         SQEmaeOJVUkpbl70FaDpkVFRfMx1PJntr2nJONs4lS+FNtCwAei9bh8Caqhq6N4JEvWg
         yGyw==
X-Forwarded-Encrypted: i=1; AJvYcCU8elI//Esjz7nlcHiFNS38mt8ygsV08ohuxg9wyxDT2yw9Jz7atIvVnDBDvcRQ+RzhmclF2OLAwA==@vger.kernel.org, AJvYcCUqWW6EcnHLCow3J11dAwDgmL+QObag4FwIKROxzn/d81kvdcpSSJZvy1CzaKfTEc8h2UVP7rxeImkO/RQ=@vger.kernel.org, AJvYcCWVoRiqdpRwrf9V+7xkbMsIqAdYFc+qL4aWf9swyQFYgthtzZRnK03B8Wigqc35iW7h2srMsxKb3kwtkg==@vger.kernel.org, AJvYcCWcslVwfHXxhoxTPIWh2NUfVSevMDpuuQ6yGk5i6Q4qxKIDsI5iXVIFA8wy3nIfJpiivxW2tLD7Ir4GMS43Bg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIXKpTLMqp+wSiz1bJNXUbUtwb4Cz3FM3scol7iLvIg4A4C/x8
	S/e/ZGkOkRid0ZKCadys2f6T4z0SFRmWVRBMK75JTTzLKqn5C4Wd
X-Google-Smtp-Source: AGHT+IFoafFKHLVT0DJoHOrqKEmggso2/mCTHNRA/BSnSr63wSqW4R2fLvclLi+NGyR0Zkzfqsw8DA==
X-Received: by 2002:a05:600c:1d9e:b0:431:5ce4:bcf0 with SMTP id 5b1f17b1804b1-432df74d88bmr35454675e9.15.1731697361154;
        Fri, 15 Nov 2024 11:02:41 -0800 (PST)
Received: from [192.168.42.191] ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0ae04sm61614265e9.33.2024.11.15.11.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 11:02:40 -0800 (PST)
Message-ID: <397bc8b7-b569-4726-984a-46054d6b5950@gmail.com>
Date: Fri, 15 Nov 2024 19:03:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de>
 <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>
 <20241114151921.GA28206@lst.de>
 <f945c1fc-2206-45fe-8e83-ebe332a84cb5@gmail.com>
 <20241115171205.GA23990@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241115171205.GA23990@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/24 17:12, Christoph Hellwig wrote:
> On Fri, Nov 15, 2024 at 04:40:58PM +0000, Pavel Begunkov wrote:
>>> So?  If we have a strong enough requirement for something else we
>>> can triviall add another opcode.  Maybe we should just add different
>>> opcodes for read/write with metadata so that folks don't freak out
>>> about this?
>>
>> IMHO, PI is not so special to have a special opcode for it unlike
>> some more generic read/write with meta / attributes, but that one
>> would have same questions.
> 
> Well, apparently is one the hand hand not general enough that you
> don't want to give it SQE128 space, but you also don't want to give
> it an opcode.

Not like there are no other options. It can be user pointers,
and now we have infra to optimise it if copy_from_user is
expensive.

One thing that doesn't feel right is double indirection, i.e.
a uptr into an array of pointers, at least if IIUC from a quick
glance. I'll follow up on that.

> Maybe we just need make it uring_cmd to get out of these conflicting
> requirements.
> 
> Just to make it clear: I'm not a huge fan of a separate opcode or
> uring_cmd, but compared to the version in this patch it is much better.
> 
>> PI as a special case. And that's more of a problem of the static
>> placing from previous version, e.g. it wouldn't be a problem if in the
>> long run it becomes sth like:
>>
>> struct attr attr, *p;
>>
>> if (flags & META_IN_USE_SQE128)
>> 	p = sqe + 1;
>> else {
>> 	copy_from_user(&attr);
>> 	p = &attr;
>> }
>>
>> but that shouldn't be PI specific.
> 
> Why would anyone not use the SQE128 version?

!SQE128 with user pointer can easily be faster depending on the
ratio of requests that use SQE128 and don't. E.g. one PI read
following with a 100 of send/recv on average. copy_from_user
is not _that_ expensive and we're talking about zeroing an
extra never used afterwards cache line.

Though the main reason would be when you pass 2+ different
attributes and there is no space to put them in SQEs.

-- 
Pavel Begunkov

