Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA0723DE33
	for <lists+io-uring@lfdr.de>; Thu,  6 Aug 2020 19:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgHFRX3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Aug 2020 13:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbgHFRFI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Aug 2020 13:05:08 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53F8C034617
        for <io-uring@vger.kernel.org>; Thu,  6 Aug 2020 06:20:32 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c6so6665975pje.1
        for <io-uring@vger.kernel.org>; Thu, 06 Aug 2020 06:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bx2+PmwZa1OtGv3itEqCRg9j5lI+TVeLmlYRsYMctuY=;
        b=vgYFrfKU6hefukTGaE/nrWZCZcNEl0bRMcHS6opgOxqKZFMdoZnkDGfTd4P6UHsTZf
         kqycsru2ehwIzpLH/aUxogiVUvPx97ahCiJFdAFoVJxnKvk09S2iUC9vkftVsYEGV4+u
         Jv/XpLrTaIAUcQaEjVtsaS2j0BACQGg0D1vlvt21T/SjPNq42P89ofypB/U2nTp+agtQ
         nAOuMdVTZ997pYRPJckHz2CtR5byLDLmONWv50aya2G4iWA62ksHZ9IDihvaIYPxEJYo
         OqUdfrtsMKQJFVAFTBkHkgCHL8eML/LaXgdbrpFbrSiirhG/9ecWoRS0KAnqTC39T2pJ
         rJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bx2+PmwZa1OtGv3itEqCRg9j5lI+TVeLmlYRsYMctuY=;
        b=hYYU9nBZRj1sUbMhl5JOqHhDx1GsVy0lQGiVozsY08mlBd6QMG1YV0gB3Y3rQfLm26
         OYi9Hv2zqXOR8jteXB2RzX+WEcH0qViGQFP1FK8z0brLrInA3PkGAHuQwr60J5uoyOkK
         tnkoOdnKo+MB42H/I0sd3BpSUH/4Aa1m/uKCD0tpRubUSym8EWIBlBAeCCUQ16i0gaDo
         nUcbrZMO/T8+5gH3BkFLB6+NTU5vX3o8sJcJuNb8/A391atMfhXipZhNX75v/VHxQy7R
         uvXEtXPeFTP2ZkXtTb6Ondz67CeGexeUogjZtxC5OsEeuocvUa3Nd2HyTztF/60ak8Yt
         dOYw==
X-Gm-Message-State: AOAM533W+4OGOcLKPKI4bw38+wuoQAgQQuOT3Hlaiz+iZJAJO/75VTDb
        kznC3Ci7ZYYapBL6nkcbqJWlMg==
X-Google-Smtp-Source: ABdhPJyouGBPqU8zyXa83rQM3O8SKSIiLRlfUaA3UuuXpjLZg6BDDNO+r2qzqMWtxGqjYiSTn2N0dA==
X-Received: by 2002:a17:902:8d95:: with SMTP id v21mr7843652plo.108.1596720031923;
        Thu, 06 Aug 2020 06:20:31 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x8sm8817351pfp.101.2020.08.06.06.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 06:20:30 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: set ctx sq/cq entry count earlier
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20200805190224.401962-1-axboe@kernel.dk>
 <20200805190224.401962-2-axboe@kernel.dk>
 <20200806073933.khoasyujngaxbcq4@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8277cc52-b591-e577-6a99-dd9c8a8146ab@kernel.dk>
Date:   Thu, 6 Aug 2020 07:20:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806073933.khoasyujngaxbcq4@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/6/20 1:39 AM, Stefano Garzarella wrote:
> On Wed, Aug 05, 2020 at 01:02:23PM -0600, Jens Axboe wrote:
>> If we hit an earlier error path in io_uring_create(), then we will have
>> accounted memory, but not set ctx->{sq,cq}_entries yet. Then when the
>> ring is torn down in error, we use those values to unaccount the memory.
>>
>> Ensure we set the ctx entries before we're able to hit a potential error
>> path.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8f96566603f3..0d857f7ca507 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8193,6 +8193,10 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>>  	struct io_rings *rings;
>>  	size_t size, sq_array_offset;
>>  
>> +	/* make sure these are sane, as we already accounted them */
>> +	ctx->sq_entries = p->sq_entries;
>> +	ctx->cq_entries = p->cq_entries;
>> +
>>  	size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
>>  	if (size == SIZE_MAX)
>>  		return -EOVERFLOW;
>> @@ -8209,8 +8213,6 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>>  	rings->cq_ring_entries = p->cq_entries;
>>  	ctx->sq_mask = rings->sq_ring_mask;
>>  	ctx->cq_mask = rings->cq_ring_mask;
>> -	ctx->sq_entries = rings->sq_ring_entries;
>> -	ctx->cq_entries = rings->cq_ring_entries;
>>  
>>  	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
>>  	if (size == SIZE_MAX) {
>> -- 
>> 2.28.0
>>
> 
> While reviewing I was asking if we should move io_account_mem() before
> io_allocate_scq_urings(), then I saw the second patch :-)

Indeed, just split it in two to avoid any extra issues around backporting.

> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks, added.

-- 
Jens Axboe

