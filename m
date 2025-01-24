Return-Path: <io-uring+bounces-6112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F23A1B6E4
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 14:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5330716D000
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 13:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC53481D1;
	Fri, 24 Jan 2025 13:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uI4JidEv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4BC6EB7C
	for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 13:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725838; cv=none; b=UM6UuUiw23+juuxA2YbpO4TtMrOUiwkG0OHMK12whqiyhCu59rbI9t8FdB23dtx39eRSr0jScVL3TA8G5jck86vUY19X6jeR7zSbVecbsryzhk7efYJjM7LKuuUmEpHsytCJ0IRe0n+pMdkYbrEJNsn5ciOH5CvAdXE8MoLz9yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725838; c=relaxed/simple;
	bh=Qaxc7Aq2vbeKmueGFnZyik1RAK/DpTeNvPuCoVgZNwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OcfwdSsohovP8Yi9GKa5dUivbykBvKpUl0a/ll17xZ1AZlwX1oOezOjXd/69FfZ2S5WMna4p2rSh/zCSi16wAAD+hYktgDInaKPsV5DdHCAuK/i/6slqB15A21xwLXfy/ZXLGZESFGic7GjxnhVsiZ6hI2TXKw3shQ1NP+/HwKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uI4JidEv; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-844dfe4b136so50989239f.3
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 05:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737725835; x=1738330635; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yrGYr6eVwHPpCt167JHw2EBDaiMMaOHcFHwHRNK7KgE=;
        b=uI4JidEv1dHxBrNT6BO8H4RPUyLp7q2MexY1EhXpKHN0S8VEGqolKH4py2Ky8zK5jn
         5ZYCAGRyxiB+5Cu2/G1KNMS91ekrsAuhaD7pVo1t+PSvyuDx3QimNfJ+NoPJMeq69GCJ
         ZljVXFHjkU7Q/IpinDT+q54/5hxNeraRbIPgI1M5Y/ZU/9wWDqtZYjKEkFjGcfWRK82+
         BIzgJoBarjJNCD24U6GlRbjjqIyNvSNQeLZhh+G3ye0QjREIxBBSfIlUPxjQB+Y/+lf4
         Zw9ELFzZFO6ADkLPwsyrKjKIxn0aphdxd0mz13/UYS+t2LyurMoL34slRU1DHq6aK45m
         sn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737725835; x=1738330635;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yrGYr6eVwHPpCt167JHw2EBDaiMMaOHcFHwHRNK7KgE=;
        b=pz8cY6ysyZDdXuqpWGcB1HUnJCeVPtHjpVYbpx9O9l2MdaHB+rkKWleeyTjykODvB1
         U/YhGn8d3Pb4dFAYWamkbcRtHis25mwWlJbdSU3rB0rnELmhEtu78oOhdTRNwCMW/Gwj
         YiQhAYx7CQMd1wcPtJXMt4lUp/2iHBL2xpA0tPyl3nG2OMCYBvWOUuaxaOzP+4ROHgVg
         i1RinibsTmmjD5HGwsw71pN3hhcXsQ+PPSu0k+i+iTly3QE6RpmujO9KHNz5jgNgASZa
         OkPIsM8eGYI6SMfKp/ijm7DVJ5rSYQeuGdGXVl6yQd9ZlipUcuKmljS4/5HzKWDM1dL5
         0g8A==
X-Gm-Message-State: AOJu0YwmANfYiSJ8iGcb30fVC8Yh/691NmDSrZ+u5MGbf6oXbQZdnxnw
	BLa9DDpG9NwpIPuTZJOjuScaRS33+EqXS2GWoROnnfuozNkGE+ijYqPtoQbXWWky6U6K66zCG6A
	0
X-Gm-Gg: ASbGnct73+0q5Nai9wQl5C6sO6FG+daPirCR+1FEm59J9HuD+VpTN5z0uu5l74av56O
	Iutrfcgbk9QMot0rnUTsZzX5eq74Zu3LBbsBlBkf6PfwlYfR3n/9Baf3tcM4wz4vxHMs/guH/eM
	6BIY3fyK9g/Y5iQ3VvlIXywsmg8v60WQKxEbaqQMlYAVhg2UyaJu0+4OKVO3gIIR9AxKltI0xMh
	wZsKz5v+Poq8uymldNshBlf3zwSetUxjctvhoUJUof1tFaRnaQbmIa9UnP0VcKuFnN4CPFwOajz
	CA==
X-Google-Smtp-Source: AGHT+IGfPztoFDWaWDgaNgKDxOdbiT9/J7fj88v5ljBhkqESoOy2xn5Un8tFZJ/wjf2EVNBlO7BhfA==
X-Received: by 2002:a05:6602:4747:b0:84f:44de:9ca7 with SMTP id ca18e2360f4ac-851b619f673mr2367032839f.3.1737725834761;
        Fri, 24 Jan 2025 05:37:14 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1db6c48dsm595646173.90.2025.01.24.05.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 05:37:14 -0800 (PST)
Message-ID: <5bc2877a-7125-48e1-9dd7-6497c3bd5d5d@kernel.dk>
Date: Fri, 24 Jan 2025 06:37:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io-uring: futex: cache io_futex_data than kfree
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: io-uring <io-uring@vger.kernel.org>
References: <20250123105008.212752-1-sidong.yang@furiosa.ai>
 <a366bb4b-dd8c-486e-91b5-46dad940e603@kernel.dk>
 <Z5LppkEQ9tGdfwrX@sidongui-MacBookPro.local>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <Z5LppkEQ9tGdfwrX@sidongui-MacBookPro.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 6:15 PM, Sidong Yang wrote:
> On Thu, Jan 23, 2025 at 06:36:06AM -0700, Jens Axboe wrote:
> 
> Hi, Jens.
> Thanks for review!
> 
>> On 1/23/25 3:50 AM, Sidong Yang wrote:
>>> If futex_wait_setup() fails in io_futex_wait(), Old code just releases
>>> io_futex_data. This patch tries to cache io_futex_data before kfree.
>>
>> It's not that the patch is incorrect, but:
>>
>> 1) This is an error path, surely we do not care about caching in
>>    that case. If it's often hit, then the application would be buggy.
>>
>> 2) If you're going to add an io_free_ifd() helper, then at least use it
>>    for the normal case too that still open-codes it.
> 
> Agreed, So this patch could be make it buggy. You can drop this patch. I'll
> find another task to work on. 

It won't make it buggy, it's just a bit questionnable if it's worth
doing. And if it is, then it should have io_free_ifd() being used in the
other place that puts to the cache as well, to make it complete.

-- 
Jens Axboe

