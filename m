Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB0D75D00B
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjGUQwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjGUQwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:52:40 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B95C1FD7
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:52:39 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-346317895e7so2614855ab.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689958358; x=1690563158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OnupsbExh4NM9Tn6/gpUNLLTgNhKms1bpTeWjm068wg=;
        b=inoaNIPOECQy4pA3qZTlkqjBrWntS+Q8OSQVxMLo0NjeWorYEEyD70BXwKDfyp8JJ4
         kZdBXWNvJwc/nMyXNpNeGHoXaeLxWzIpjY/BEUfXPJzj088Xq1OiD+XWuOKZlnKvqrLg
         4bjEmGagmAtA0wmlfV3E0QTdFbatKXymkReTMzS+Dh2ZOjsIhRpswgmfxuYdL1tUDogJ
         Tph5b4Kw7gmK8BbOjQkVU9bZaFxCIiPTiVt6wd9jQzqLLJ+VKXFnmHqZIqqy7YubcqVG
         by768eJF/4jyKw6tDWDOvy9yU82azp8O9P0Ak027xqipgoLRzcRRMF28w2WoKhqbyVEH
         O/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689958358; x=1690563158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OnupsbExh4NM9Tn6/gpUNLLTgNhKms1bpTeWjm068wg=;
        b=CyrRIf5uhx7e3uayuyYGlTTrvrLuRAsJTysjRNZt++H7/2yBP4Q2OjoIzJ9jl7ik3o
         NPIy796TYbV98zQUvSIYoxpVV+sZMeY87QHALfFUmfABlKzrNxgDQaQ2XM8oUyXV68JY
         hXGnVofRZKrnSpWZ+gFbtE/KKYkDjpQs1VXXUjNeRV0AjCgFeWD1UQvH4gOJHJvS5Pwd
         mhSBu5c6HRUl5rfMz+4b5IQdAct7cUFEF8wvMJYspZ63xIxbbRuYo0LSH++01YjYGbOT
         qUJPAD3SKLUSPyWfYXHMf8RHMJ/HwXTCQ5Mt3vGRk9mhgpUqi2UKQjzBT/1dtj9/9Npa
         +ebg==
X-Gm-Message-State: ABy/qLYMofoCbFEicfGUU89RgxIrbztFDLa0A9bi79ilNu5NZnPWkJDi
        UadPruzGlTzzCg63aetW629//w==
X-Google-Smtp-Source: APBJJlGiswFLAOQvljGsoE8hQKUkJW9EMS21QiLhqeQWKvrNgerOvL3EbZw73YgWKOecj9z49gL04w==
X-Received: by 2002:a92:ad0f:0:b0:346:10c5:2949 with SMTP id w15-20020a92ad0f000000b0034610c52949mr2092903ilh.1.1689958358423;
        Fri, 21 Jul 2023 09:52:38 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b13-20020a92c14d000000b00348730b48a1sm1069686ilh.43.2023.07.21.09.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 09:52:37 -0700 (PDT)
Message-ID: <7c980a66-0e74-06df-dae5-6d7887dd3544@kernel.dk>
Date:   Fri, 21 Jul 2023 10:52:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/9] iomap: treat a write through cache the same as FUA
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230721161650.319414-1-axboe@kernel.dk>
 <20230721161650.319414-4-axboe@kernel.dk>
 <20230721162553.GS11352@frogsfrogsfrogs>
 <4fcc44be-f2da-9a7c-03ca-f7e38ac147cb@kernel.dk>
 <20230721164744.GW11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721164744.GW11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 10:47 AM, Darrick J. Wong wrote:
> On Fri, Jul 21, 2023 at 10:27:16AM -0600, Jens Axboe wrote:
>> On 7/21/23 10:25?AM, Darrick J. Wong wrote:
>>>> @@ -560,12 +562,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>>>  
>>>>  		       /*
>>>>  			* For datasync only writes, we optimistically try
>>>> -			* using FUA for this IO.  Any non-FUA write that
>>>> -			* occurs will clear this flag, hence we know before
>>>> -			* completion whether a cache flush is necessary.
>>>> +			* using WRITE_THROUGH for this IO. Stable writes are
>>>
>>> "...using WRITE_THROUGH for this IO.  This flag requires either FUA
>>> writes through the device's write cache, or a normal write..."
>>>
>>>> @@ -627,10 +632,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>>>  		iomap_dio_set_error(dio, ret);
>>>>  
>>>>  	/*
>>>> -	 * If all the writes we issued were FUA, we don't need to flush the
>>>> +	 * If all the writes we issued were stable, we don't need to flush the
>>>
>>> "If all the writes we issued were already written through to the media,
>>> we don't need to flush..."
>>>
>>> With those fixes,
>>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>
>> If you're queueing up this series, could you just make those two edits
>> while applying? I don't want to spam resend with just a comment change,
>> at least if I can avoid it...
> 
> How about pushing the updated branch, tagging it with the cover letter
> as the message, and sending me a pull request?  Linus has been very
> receptive to preserving cover letters this way.

OK, will do.

-- 
Jens Axboe


