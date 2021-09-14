Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CDC40B073
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhINOUT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbhINOUS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:20:18 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723A8C061762
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:19:01 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a15so17235567iot.2
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=23fJrLkXIRy0k1ES6TmxPWsPhWChV9LSwJfEbMacEhU=;
        b=IuYYBHrmV/BoCUFpXwEewiXm4B/hXgUw4Hx6AA7pQ1x3dRXXuMtkFPwNQsUMm+X/Fn
         4X2PcBq2sUO055cFQVZWECvFRxd7H5n8eVgfHEjYdh7ZdoXoGmswDzp2y92oCwZBJFgq
         OLZP9cybLQuq6VhFWz7nttktCfgVuJ+HcTI4iprNtx0g89V6JSDQkCA6hvtPxi6iGZ2j
         k296g1o3PGz1Lt5l57K3POfhCIangcQUI9PydUEvMeqmhf9HonQAwnQHtzMNmzi3c4RF
         rVgCwg9hADEDusMldaASjCVcPaBfsMCjqnHp0ql6w5uF5N1hyrYj+cyNDP/PCp1a2tAy
         gt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=23fJrLkXIRy0k1ES6TmxPWsPhWChV9LSwJfEbMacEhU=;
        b=QvMT9n3o5zsEtY6P9vYqg+ot/jPirOdysS5hDCe8tbDKbBgyUHUIQ62LAxhJ7gJgI0
         gGxKcYDqy3G2DrFj7l2X25NuhP92xUvs+6QoanAo5iA9MMbnNi1cieosY7XmcGT8Ijj1
         2EOYxRIiwy/fKF9ADy2wy8KHNWlHU+j4GYVZLgZuyk9xEWN2eoJ4rtSzxoMUYhyipIBJ
         9Ip0mVtqj5fb80TfuOlDtkf35C2az7csZWN1THEzKhFG8XZURg8XMqQvd9jMNJzkfCTC
         Xu6Wh/cdvQ7YezUb3Wkb2HrHM8FCFtxhgfkNju2hHC2BfvWwFnrD5AH/zHYZlWMA+IaL
         2f/Q==
X-Gm-Message-State: AOAM533rhNA3JKCmdmdpbi9shqvfg7MUF18vqu5oxSzO7dUaRDfnWirW
        fPhxxmqlIjmQDGZHZO9rY7pbjRelOGdi8yLi00E=
X-Google-Smtp-Source: ABdhPJyh7JgtSwu9SxwHZ4DTmxTfWNuvZY+/ul1p2HkPDDiZMhi9vv+UWLNtIWyeFA5oSbDxsDygIg==
X-Received: by 2002:a05:6638:2385:: with SMTP id q5mr6266296jat.5.1631629140255;
        Tue, 14 Sep 2021 07:19:00 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c11sm6601090ioh.50.2021.09.14.07.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 07:18:59 -0700 (PDT)
Subject: Re: [PATCH 5.15] io_uring: auto-removal for direct open/accept
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0ef71a006879b9168f0d1bd6a5b5511ac87e7c40.1631626476.git.asml.silence@gmail.com>
 <27718f96-30af-2ebc-3a53-8fb6bb7155ec@kernel.dk>
 <450eb78a-a714-c6d1-c844-dbe8424a1c1c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a4a3a3fc-707b-77d5-e8a7-a07dc403f96b@kernel.dk>
Date:   Tue, 14 Sep 2021 08:18:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <450eb78a-a714-c6d1-c844-dbe8424a1c1c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 8:10 AM, Pavel Begunkov wrote:
> On 9/14/21 3:02 PM, Jens Axboe wrote:
>> On 9/14/21 7:37 AM, Pavel Begunkov wrote:
>>> It might be inconvenient that direct open/accept deviates from the
>>> update semantics and fails if the slot is taken instead of removing a
>>> file sitting there. Implement the auto-removal.
>>>
>>> Note that removal might need to allocate and so may fail. However, if an
>>> empty slot is specified, it's guaraneed to not fail on the fd
>>> installation side. It's needed for users that can't tolerate spuriously
>>> closed files, e.g. accepts where the other end doesn't expect it.
>>
>> I think this makes sense, just curious if this was driven by feedback
>> from a user, or if it's something that came about thinking about the use
>> cases? This is certainly more flexible and allows an application to open
>> a new file in an existing slot, rather than needing to explicitly close
>> it first.
> 
> Franz noticed that it would've been more convenient this way. Good idea
> to add his suggested-by. I had been thinking to make it this way before
> that, but without particular use cases, it just felt better.

OK good, and as mentioned, I do like it and think this is how it should
work. Just add his suggested-by for the v2.

-- 
Jens Axboe

