Return-Path: <io-uring+bounces-10047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BECEBE8981
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 14:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEE74428626
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 12:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DC728EA72;
	Fri, 17 Oct 2025 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUnwyVqp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F9319DF66
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 12:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760704345; cv=none; b=TeUEkPc/HncslCNika2w9nGgbU0MG5L5bYXnX/Gdew8nhPzdXip34qblozE2iF8/gPezYDHjC/9rFWtXSzu+2PT/5czUOg+jo7N7Qkn9jCmQkOUSwjpeWDPS3fAKOIBaEX9pM/suFqhMpvPj+JnGMDCGFVHdCANFc3L6GHSv0UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760704345; c=relaxed/simple;
	bh=MuzctqLB4ussUEoSxRDdq5u4z3jbIFXqqjT7Pzx57TM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=juq1jEkiGnB+q4ZHoBGUBQMPmWf3HUQY1OrCMJP215D66ZDHi1B7l2289slQ8ogec0RVH8ed2NJH1Zh1gUaHljWOwpWM2PmMRPZTmzGuFbBYVQKWldJ0XYPrHmXW/6/zX0aBhYbTdYR7DSkg5J9GxkaKelzAuRq7/tl1oB3MzYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TUnwyVqp; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e6ba26c50so13825325e9.2
        for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 05:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760704342; x=1761309142; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nqU9csQsucjcl0I01knrUCDVWcsBEKstqIxuhCVvTsY=;
        b=TUnwyVqpCi9dlqFCYjLUqMYsIeDTWcQf3wZ14IckvRtkGRZK9TLavTL8geBU/9nzGD
         IXdGyqqcGtG2/IyE/Iu2IK70jyOv8nOZo3zYYxv/22WFDnp9Vsacg8Uvrgj9/dHXihBu
         fj9n7eanxQo/6Hfwhm/7tPnVgBujflTTRfbQ8qMq7hDatdkQyQUCwnV+6iYvZAFRYYEz
         wanzKb+oy2oRknkXPkyqRBrS/rAoNQRIIXnOwYmCisbhNktCNdURuheMXxzarR32jE4q
         W6ztoVcoWppq9Sh+VaMVGJ/npBeqnxRo79DbjxI4nf1oic8mCTZECyNTO/DaqDVChZvP
         B61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760704342; x=1761309142;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nqU9csQsucjcl0I01knrUCDVWcsBEKstqIxuhCVvTsY=;
        b=LvNI1NQaN9XKLoTEI2acL8Yxq+bmnB8KuKqwXW62gQ9F619J8AFcoJ57RSDly6XMdU
         j0EqzudLboa7NHT9I9QzGOqd1oWl14fok0ICIasvIsQ0/WpU6Gt9cwimk5NLo9Cv48ej
         qYp0Tdm6D+qCdue6zkLu8nFWgnmEbA3ZCNNtCtVpC6yeCDiEKdLq9OwBhmgW/kucthyQ
         ZSJxr83uc4EkghNi1s17OP7RpLirxZQjrKiVOwbdr5thYaiiWSuyIVsXS6oIPTg9OS2B
         CPIe4EaGxkEZZF7XZ+uiasUjzah4fx6QlP3DxmVj2uDzqzsUlzigzQEpPPZAFTJVG5yC
         wYfg==
X-Forwarded-Encrypted: i=1; AJvYcCXi5RBDM2MPAVro0XXn8XMH80Kj70m3bifJg6ww3/wKFFvzGxh2WRC8ilecYpJWkSDrgbu7ozfEcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrWRymS8Jo6ESYeahJqua0Z+zwxZRlJBH8eayTScVrohFdhUGg
	Q3HaarZSxXDJatPsFGf3374M9o2fmhq/DvJxDRSYslTp6mcuXhUyOq5L
X-Gm-Gg: ASbGncstAxl89eoDqSDOi1UgoL0zyo0E41Y+lCKIZgS9k0WXH70XPBMn9zGnOVgtx4t
	LXY6GQ9RJkJ6/G6NWKUJ2q82BQVu7dJ+1g5lCTJ055I8SHFiOH4W7B7HBAJKhEaxHP5tb25770h
	HPmKJrZrU1H06p1oc6vvEUqKJhHQUmgaQaCKWy03QFB0ClZCzxgho9zVyWe1m1nUWRScgQxFnvJ
	P+oOsCjLaKlwLYvG7dsjhd2+Ay+XokHRIL9a6f6tn0CHklF4s9g1vfWeXgV6yRaweVhgycJ0d/i
	F1YSDIUTbXNNeK77Zj/lxayKZulrFQxdJciK9V5eBzSYOuSf51abpRbnDH0jCEQMNo/EMro4YBe
	Unkx7TNDiOvT6CWI/W+ibBiZpEmzG48kvgTqFN+PsVV3vCBvjbNqXq/M3iFIgSBOhPtQ951xBDZ
	E4YIR7DKiWE5MggZpbYScgI5tbT6VkrY05A5DspGFPUmc=
X-Google-Smtp-Source: AGHT+IFvBoV+j+/2ZLgfgQrNR3bEA+fM+cjkWWRqcph6qCN2EXtdRDP7AmiiPcjQg94cN2mUkbMh+A==
X-Received: by 2002:a05:6000:4285:b0:426:d57a:da9d with SMTP id ffacd0b85a97d-42704e0ef3emr2238205f8f.59.1760704341764;
        Fri, 17 Oct 2025 05:32:21 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:e18a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e1024sm40163955f8f.42.2025.10.17.05.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 05:32:20 -0700 (PDT)
Message-ID: <8d833a3f-ae18-4ea6-9092-ddaa48290a63@gmail.com>
Date: Fri, 17 Oct 2025 13:33:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
To: Byungchul Park <byungchul@sk.com>, axboe@kernel.dk, kuba@kernel.org,
 pabeni@redhat.com, almasrymina@google.com
Cc: davem@davemloft.net, edumazet@google.com, horms@kernel.org,
 hawk@kernel.org, ilias.apalodimas@linaro.org, sdf@fomichev.me,
 dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com, toke@redhat.com,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kernel_team@skhynix.com, max.byungchul.park@gmail.com
References: <20251016063657.81064-1-byungchul@sk.com>
 <20251016072132.GA19434@system.software.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251016072132.GA19434@system.software.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 08:21, Byungchul Park wrote:
> On Thu, Oct 16, 2025 at 03:36:57PM +0900, Byungchul Park wrote:
>> ->pp_magic field in struct page is current used to identify if a page
>> belongs to a page pool.  However, ->pp_magic will be removed and page
>> type bit in struct page e.g. PGTY_netpp should be used for that purpose.
>>
>> As a preparation, the check for net_iov, that is not page-backed, should
>> avoid using ->pp_magic since net_iov doens't have to do with page type.
>> Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
>> page pool, by making sure nmdesc->pp is NULL otherwise.
>>
>> For page-backed netmem, just leave unchanged as is, while for net_iov,
>> make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for the
>> check.
> 
> IIRC,
> 
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>

Pointing out a problem in a patch with a fix doesn't qualify to
me as "suggested-by", you don't need to worry about that.

Did you get the PGTY bits merged? There is some uneasiness about
this patch as it does nothing good by itself, it'd be much better
to have it in a series finalising the page_pool conversion. And
I don't think it simplify merging anyhow, hmm?

...>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index 723e4266b91f..cf78227c0ca6 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -450,6 +450,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
>>   		area->freelist[i] = i;
>>   		atomic_set(&area->user_refs[i], 0);
>>   		niov->type = NET_IOV_IOURING;
>> +
>> +		/* niov->desc.pp is already initialized to NULL by
>> +		 * kvmalloc_array(__GFP_ZERO).
>> +		 */

Please drop this hunk if you'll be resubmitting, it's not
needed.

-- 
Pavel Begunkov


