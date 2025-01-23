Return-Path: <io-uring+bounces-6067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1679A1A60F
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 921953A3EC3
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F6738B;
	Thu, 23 Jan 2025 14:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kIsu5SiX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B9320FAB7
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643633; cv=none; b=oMnY9LsiUiZH4w2ryEBkxqKFrHl7P+MebrBF0KrRsX/dkwaqhYZmuAIYpOJmz72/CvzEngu3G1znJe0wCQWZMttQe6c/r51WITpiu6YwRN0DAHIYNzmrcHI0OcjA/pTmWPSGpK3dSVRdEIMwXcJ8MpBd3Eij6eGhpIvOLGAfCB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643633; c=relaxed/simple;
	bh=gYEADRnWqZnMc1q8QtDKwGpNdfJF69Yn0nXf/hEAnCo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jy5nx2hJKLqKvLHXz6CY7g0G7xLayDs5n+SVL/jnXNkXmz6veHXK7JeEVNjI5CLz7d1IjqYEv0xBLJR/5SF/0tONfrmK+dB7pScvq2UTndcFjGjqpPjkgNUHxs4B1yRFYN7PGnHrlZYrPxrQJYAsTlN7aYVWIcdiZC+9HRO8PHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kIsu5SiX; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aaec61d0f65so225218766b.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737643630; x=1738248430; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZkv/3Ifulh1W8Lib+4x/0P6Wl4MiBIUjyX09vtvUGQ=;
        b=kIsu5SiXAEOmN6QBRojViBgL7ZIkKpkf36GblR9iOCt7lkQSxgwxWrWKxXp8XKIAJY
         8XUD3Y1DM0NmKcIa7tcFWj72IMn0eyWqP9jixwrlxWUrZUC0CpbSab+fzUqB2vwC55SE
         Jw1c2GzFGKIYXFhKo8TbSKXRijJdM+L0t9Jea96AYdjHvTVEhti1o7G5liREsbfx2D6R
         0RIeq9xMCim4FfF4eZGrp4zC2zKr5pWHriEbj/eA3C8BUoIDyoNgJHGCZJnyh8kW0pJ3
         NLe/snWpPt4rGmd8shlly63QofxJ3ClVwgCyHlI07hs2KCIE6Iv5r3jjbl7enLeZE8n4
         ekVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737643630; x=1738248430;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZkv/3Ifulh1W8Lib+4x/0P6Wl4MiBIUjyX09vtvUGQ=;
        b=wjW9FdVjCw2J7iKnYECajRBUnevvoIhurvN3vXjS69g7cmMtLNwm63aIEuOX+Z06tV
         XIgtFK9lRqIorhrTa0q06HjgMBP+R+forRqFXNBZl4JRJ0h9evd5l/eS+vA6Lm1CqW0r
         AVVlPEPH3Qd8UuRUy5ic7rjvb9UMoOOVE0xIAHaLnCeAM2rOjAk5ud5lyiLewVZJE2Dy
         RCoQ0RZmHBWeOhm39TVtjbdz0hm/fKWIJ/qbkQo/CmOT0mEy1Nhsmi92/6ccMaDVfm14
         f9tcmP1soJ2NyA0gOT5dnfz2SNcIjjMWLTeZDMMj8fdXMvGUbeO923naup2bS6OVj3eW
         QDaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjvyFGKb4yniIlSJeNR/y5C3SA+7cuPMiHULIqLr/OIADR3GRKv+CDAKwEGc3vsMBk06NyN5gaHg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfdB3M60nRqkLw02V0dL3qlrulQZf6NZS8Nn+4OFiV7fT1Eol2
	T7+skuRjUnbKPPaZPIURgtnQDYjxgRr6c43sEN8ZoPjnzW+duCY7
X-Gm-Gg: ASbGnct5b4KpiHQ8i9oKde/DO1paI60Vhcje5ohMktqQmqmPkabzWWjfH/zMYn2tco4
	24cXoGouUtlp/jySWzjbCym8B8XlgfBheZqVB8Q3CC077D2gPlyl5tGTmRyp7ULte39AgRdqcJN
	PeXCWCO/TK2j6/zlEpjuLjt0EV2UGEtH6db1mnDxJg70Oak9ePbnwIPsk8zCAMbXjUUmY7Ajcsw
	cfWjS8NhooMxTLZCxZIy/zPUTTpjmLkLiFTWX8OBCGI9QkqY349knAaC9n3k0mDZMmT4DhlUygD
	0JJBqDeYyNbkG8mRJsSozCL5wzMIb3OnTLfWwQ==
X-Google-Smtp-Source: AGHT+IFVXuOVDNJbALKzho5HXIbsAH60aDFJB995mymwY4Y16lnrOF8yzPom8CHi7uapz3X3uhcX1Q==
X-Received: by 2002:a17:907:7ea1:b0:aaf:74d6:6467 with SMTP id a640c23a62f3a-ab38b3771e2mr2413540066b.42.1737643629577;
        Thu, 23 Jan 2025 06:47:09 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7d36])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f223fesm1085064066b.105.2025.01.23.06.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 06:47:09 -0800 (PST)
Message-ID: <f3c9c1bf-4356-4cb7-9fd1-980444db83a6@gmail.com>
Date: Thu, 23 Jan 2025 14:47:42 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: get rid of alloc cache init_once handling
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20250123142301.409846-1-axboe@kernel.dk>
 <20250123142301.409846-3-axboe@kernel.dk>
 <cebeb4b6-0604-43cb-b916-e03ee79cf713@gmail.com>
Content-Language: en-US
In-Reply-To: <cebeb4b6-0604-43cb-b916-e03ee79cf713@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 14:27, Pavel Begunkov wrote:
> On 1/23/25 14:21, Jens Axboe wrote:
>> init_once is called when an object doesn't come from the cache, and
>> hence needs initial clearing of certain members. While the whole
>> struct could get cleared by memset() in that case, a few of the cache
>> members are large enough that this may cause unnecessary overhead if
>> the caches used aren't large enough to satisfy the workload. For those
>> cases, some churn of kmalloc+kfree is to be expected.
>>
>> Ensure that the 3 users that need clearing put the members they need
>> cleared at the start of the struct, and place an empty placeholder
>> 'init' member so that the cache initialization knows how much to
>> clear.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   include/linux/io_uring/cmd.h   |  3 ++-
>>   include/linux/io_uring_types.h |  3 ++-
>>   io_uring/alloc_cache.h         | 30 +++++++++++++++++++++---------
>>   io_uring/futex.c               |  4 ++--
>>   io_uring/io_uring.c            | 13 ++++++++-----
>>   io_uring/io_uring.h            |  5 ++---
>>   io_uring/net.c                 | 11 +----------
>>   io_uring/net.h                 |  7 +++++--
>>   io_uring/poll.c                |  2 +-
>>   io_uring/rw.c                  | 10 +---------
>>   io_uring/rw.h                  |  5 ++++-
>>   io_uring/uring_cmd.c           | 10 +---------
>>   12 files changed, 50 insertions(+), 53 deletions(-)
>>
>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>> index a3ce553413de..8d7746d9fd23 100644
>> --- a/include/linux/io_uring/cmd.h
>> +++ b/include/linux/io_uring/cmd.h
>> @@ -19,8 +19,9 @@ struct io_uring_cmd {
>>   };
>>   struct io_uring_cmd_data {
>> -    struct io_uring_sqe    sqes[2];
>>       void            *op_data;
>> +    int            init[0];
> 
> What do you think about using struct_group instead?

And why do we care not clearing it all on initial alloc? If that's
because of kasan, we can disable it until ("kasan, mempool: don't
store free stacktrace in io_alloc_cache objects") lands.

-- 
Pavel Begunkov


