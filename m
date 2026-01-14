Return-Path: <io-uring+bounces-11709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD80D1FDCE
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 16:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86629303B7BD
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6EE5321426;
	Wed, 14 Jan 2026 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NnHAVrLz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f65.google.com (mail-oa1-f65.google.com [209.85.160.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA0624677F
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768404839; cv=none; b=XzdjuRGNynvKOvaSOjUKxBhCoJeg1ATxUDZgOxzKOaV/qnqEywUjSXRaOcEmfeKZltdTZ/VWU/mYp6h55PiaCfPJ5MhT6uuvzYYAifItxG/mYeahoCZI/OCSvkY2Rld4D9U/0hm9Z4MuK0shgL4wMDWwOqdkk951+MbXp1O1Dl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768404839; c=relaxed/simple;
	bh=UmzcuOw4svA924i7fsDuSHYVeTEKkHHhnOwub50N8XI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WGcaGREJGceUR00wIjFswhZObxu0YKxpOonQqOlQVWfYI9cGAlZZsLNBfvyiPtjSSFw54URebiDem9KAiax7wNrn07seW0TUAhlVIcKPj7ZH36RPbR4JZYZCtHu5AFKsUE9FOk0vlnxJD6zshRJklANv2SDaQrz7D4XigQXLm6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NnHAVrLz; arc=none smtp.client-ip=209.85.160.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f65.google.com with SMTP id 586e51a60fabf-3f13043e2fdso3284884fac.1
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 07:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768404837; x=1769009637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SWxzKiispWKI6pLdOpqyNsQyVG5IYLT8Ytj50kICgnQ=;
        b=NnHAVrLzU2FdxLmb2tyUgJnghXsGG3ng3TdXthajhCmE24yeY8jXPACM7lcUol8x97
         bjCVEYRePAKCn8H2Obp5vva26yjZrRIAgop7CZLour3g302ie06vz0ivHZiIIB4AoAqv
         CriWdxYG6giJh/pyz6gwS7r9UCCia7cJYHHOYRCpJPFIeBVMLlZa300ekren+/9NpnqD
         lhuA+xeNDDkeAIxrke2RvclvTyM3wsghyoT82izCdiOyYbUn4pGDxB/EIeqboGzfdXyx
         3nOnh905jMk+5PjK0drMaXEYWTrDcAHOmNubuy4lohZywyGwRg7LfBiHbcu0r9563iMc
         rlzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768404837; x=1769009637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SWxzKiispWKI6pLdOpqyNsQyVG5IYLT8Ytj50kICgnQ=;
        b=hOGY0ehaR5raUj3p0oyi/dVEmQu2y3yH91M1rEZzhiyq57E/keheRSo9eVUcjh8YD0
         i/UKlBYheq4a9DdLbnrfSTcoAiBaOR8wf9M+L0otKDAHfgyocS93r6Nh2F2CcoHq7hIt
         o1nAS15VAMIkkvuUzS6ICinel8fu8FozVDfe7g3nZACGmvxbV1Fm9AO5a16wG0DZUg+x
         Th1H3ZT5P3VKQbZtFEwS30JYWScsoGrUQK18ialkjnCWAOOImTk4jfC8CStj5i43tOKr
         gWEHUVev1XU/AY0Nj8kVTFP5FJVp1lDm28tnPJ6TD/0GYxX/oZHMCjeCWC8eVAHo/R3R
         yl8w==
X-Gm-Message-State: AOJu0YwlbfSDSXfOTyHMxsVC5/c9cGqc5uAHVnyQGJ+n/shyNGbd1R3z
	CSCZnttGqcWd7Lxvv/4gr9/+Y+42CJYjepbLWQxfdbRuXx3T8ac8fI6AOQFrkraaUMk=
X-Gm-Gg: AY/fxX4SqvSI+Tnq7JZCIZ507yPUy3Oeno1B+4bFHTLYn9MnqKSQ1dAvDFXcOqk2VUU
	1tM/HrZSc1oqXcMS3mRzyAoeiR8sLu7RR8RE5cZGfXMY9wEk7jy6Nj8/cx2qkaHXfNSDAuiig4X
	3tjurFzV+d4uIFpFaiYZNecd01arAgB6/vEL8p0IB6vN3KNDZJgTCENcW6yM+qkBNoe2ycD85PA
	SAXCPcODh7N+gzNSEU8rcJFqute9yeJcUogS/p3Of2uV1DIvJ3O3JEGXxCte0joSlfF3fAjUkak
	vfSfcVAOUmEvfTR/sPrL9TkJbd71Ud5h3HOfqOKgJ/qgmxiXcyMAdyfrI2kw2D2xZ/1SYUv9kva
	zD2ogaonOzr+Co8ygGXV8w2C/EBK7lorBpD64zL+SIDAMHZG4aUatUY8Re/Hs5yC0snfIqOcefW
	2legvd/NM=
X-Received: by 2002:a05:6870:e40f:b0:3fd:a8e1:8f44 with SMTP id 586e51a60fabf-4040c0c6f85mr1842241fac.53.1768404835441;
        Wed, 14 Jan 2026 07:33:55 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffb279e939sm15603826fac.16.2026.01.14.07.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 07:33:55 -0800 (PST)
Message-ID: <af727108-b20a-45b0-b46c-07244be4cacb@kernel.dk>
Date: Wed, 14 Jan 2026 08:33:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix IOPOLL with passthrough I/O
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring <io-uring@vger.kernel.org>, Yi Zhang <yi.zhang@redhat.com>
References: <b60cab06-92ad-467b-b512-1e76ec5e970e@kernel.dk>
 <aWe2-iz6eaIyuIZl@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aWe2-iz6eaIyuIZl@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 8:32 AM, Ming Lei wrote:
> On Wed, Jan 14, 2026 at 08:12:15AM -0700, Jens Axboe wrote:
>> A previous commit improving IOPOLL made an incorrect assumption that
>> task_work isn't used with IOPOLL. This can cause crashes when doing
>> passthrough I/O on nvme, where queueing the completion task_work will
>> trample on the same memory that holds the completed list of requests.
>>
>> Fix it up by shuffling the members around, so we're not sharing any
>> parts that end up getting used in this path.
>>
>> Fixes: 3c7d76d6128a ("io_uring: IOPOLL polling improvements")
>> Reported-by: Yi Zhang <yi.zhang@redhat.com>
>> Link: https://lore.kernel.org/linux-block/CAHj4cs_SLPj9v9w5MgfzHKy+983enPx3ZQY2kMuMJ1202DBefw@mail.gmail.com/
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index e4c804f99c30..211686ad89fd 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -713,13 +713,10 @@ struct io_kiocb {
>>  	atomic_t			refs;
>>  	bool				cancel_seq_set;
>>  
>> -	/*
>> -	 * IOPOLL doesn't use task_work, so use the ->iopoll_node list
>> -	 * entry to manage pending iopoll requests.
>> -	 */
>>  	union {
>>  		struct io_task_work	io_task_work;
>> -		struct list_head	iopoll_node;
>> +		/* For IOPOLL setup queues, with hybrid polling */
>> +		u64                     iopoll_start;
>>  	};
>>  
>>  	union {
>> @@ -728,8 +725,8 @@ struct io_kiocb {
>>  		 * poll
>>  		 */
>>  		struct hlist_node	hash_node;
>> -		/* For IOPOLL setup queues, with hybrid polling */
>> -		u64                     iopoll_start;
>> +		/* IOPOLL completion handling */
>> +		struct list_head	iopoll_node;
>>  		/* for private io_kiocb freeing */
>>  		struct rcu_head		rcu_head;
> 
> ->hash_node is used by uring_cmd in
> io_uring_cmd_mark_cancelable()/io_uring_cmd_del_cancelable(), so this
> way may break uring_cmd if supporting iopoll and cancelable in future.

We don't support cancelation on requests that go via the block stack,
never have and probably never will. But I should make a comment about
that, just in case...

-- 
Jens Axboe

