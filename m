Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76545341E7C
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 14:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhCSNhi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 09:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhCSNhZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 09:37:25 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2E4C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 06:37:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t20so2970247plr.13
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 06:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Vm9jcS4jwR+xdHswZouaGfZtCZf9HkjUaFOLy9IufkM=;
        b=jzC3Z617KN3K3FqGCa4kwBRqTO+f7Wt+9/H6c8gKRSh3QqfmVsFQL+AWp2OFniUeuw
         YVD331qvSL98RIGY2cqMbtdR8hRef/VPSWMArSqYv0xy7jfS5UfyHFXtidhpJ8pvp+pb
         AB3Y510sg80x0zOlirkUf8ZRN+9Mzcs4ieVcv7+7mX8DAWLbLWx1xSLfAtT8zyUiNtvE
         RXBfwzzMgyWISg45eBmpthmROc46tjoBTwp3V22J0li6rE//K2sYA5GVzjgxh3TvIAe6
         +MBjNwKRuBZhT8JOFNWEsYtxwoqYburKZTCwRVYhIeXpull6OalV107sFY3W4F4Uio5U
         AiWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vm9jcS4jwR+xdHswZouaGfZtCZf9HkjUaFOLy9IufkM=;
        b=IpdN4K4dvD6cyL5e++H+aWvXbxqAZip4tcqdFNX0POBbjWWrrzeU3alc/r7OlbqmG/
         yMqmMuy+E1YvCjtYkbHJhgx6EsB3tQ1MqJcjMtN6kjkg7jUtiJIPgd60kfLA8fVdkOLi
         Mjm4IsqYVgqXTs8+fUNYyJnb8Xg1LIejnTKMDMIIFTLbRGVup2WUjrLTTCJzARs0esKV
         PBQQbYO/ujAjthox4XaG6p+IvEbpnLBqNGJoHmVysWxIP41y44l8VszUg0136IPdlAYa
         Ll/bEWMfgkvwSoselrHuGVJMLSDONVnazkHFDKfb4eq29Xoqfs4VXIm9GmCZ9QkXmf3H
         iJGQ==
X-Gm-Message-State: AOAM531O96uyHKGOHhRfOGkST6ZoXavfIOGVHfvhjlwZzH9KXJj9dsdz
        /Gneiy7k/VzNX9uONXYiubG+nXmvNePadQ==
X-Google-Smtp-Source: ABdhPJxXXV9yGCNzbGssz9BvLD4datws5oX2I4YQBTBoK0+kHY0AVEVkXh44p8gdiCtujPJyACR6DQ==
X-Received: by 2002:a17:90a:e60b:: with SMTP id j11mr9405485pjy.42.1616161044474;
        Fri, 19 Mar 2021 06:37:24 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a70sm5453378pfa.202.2021.03.19.06.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 06:37:24 -0700 (PDT)
Subject: Re: [PATCH 9/9] io_uring: allow events update of running poll
 requests
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
References: <20210317162943.173837-1-axboe@kernel.dk>
 <20210317162943.173837-10-axboe@kernel.dk>
 <5c62f6bf-057c-e4b1-5cbf-102e73f8bfcc@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2fa5663f-dd02-f2ab-dec8-7a0069fa347e@kernel.dk>
Date:   Fri, 19 Mar 2021 07:37:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5c62f6bf-057c-e4b1-5cbf-102e73f8bfcc@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/21 9:31 PM, Hao Xu wrote:
>> @@ -5382,24 +5387,32 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>>   
>>   	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>   		return -EINVAL;
>> -	if (sqe->addr || sqe->ioprio || sqe->off || sqe->buf_index)
>> +	if (sqe->ioprio || sqe->off || sqe->buf_index)
>>   		return -EINVAL;
>>   	flags = READ_ONCE(sqe->len);
>> -	if (flags & ~IORING_POLL_ADD_MULTI)
>> +	if (flags & ~(IORING_POLL_ADD_MULTI | IORING_POLL_UPDATE))
>>   		return -EINVAL;
>>   
>>   	events = READ_ONCE(sqe->poll32_events);
>>   #ifdef __BIG_ENDIAN
>>   	events = swahw32(events);
>>   #endif
>> -	if (!flags)
>> +	if (!(flags & IORING_POLL_ADD_MULTI))
>>   		events |= EPOLLONESHOT;
>> +	if (flags & IORING_POLL_UPDATE) {
>> +		poll->update = true;
>> +		poll->addr = READ_ONCE(sqe->addr);
>> +	} else {
>> +		if (sqe->addr)
>> +			return -EINVAL;
>> +		poll->update = false;
> Hi Jens, is `poll->update = false` redundant?

Don't think so, the one in io_init_poll_iocb() is probably though.
Better safe than sorry... I did rework these bits in the latest, because
it has two separate flags instead of just the one.


-- 
Jens Axboe

