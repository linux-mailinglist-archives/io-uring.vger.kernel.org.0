Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3780940B384
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 17:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhINPur (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 11:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234896AbhINPua (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 11:50:30 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33E5C061766
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:49:12 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id x11so30055901ejv.0
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DtoHB6rYiwzt48UOnRsxhxvEhqmEa37H+T2lVyw+oTk=;
        b=HUG+eUwdqVS6MZlTqjpn8VcHoeXHfgPUPJu7VSD65U/6E2UdE/Avn2uecgjZw8E0M0
         J2Br00hBjLPbay7gw58jWH9Ol7bay9qzkFIazxaGcAVhfAzyI1Pjoxgk5jSvxHCjcM5V
         r57Tau5cOa09vBlQxOOOz9QcCJV7Fd1xTKQZ30dpn+YJO5cSsiNs4FxhmMMViN+sFEyQ
         u9UL4xngEcPoNfiPPI+V2yrzqh3l5qz8zv+y0igZ98l+ome9InSUx50N19uo1SMv7Ppb
         noKTJp9sN6mpJVHGCBvDfv8Qxkgoj8PFMwyEzbSxVowFm54w1lL/sJA/brCL0ESO+msL
         0w1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DtoHB6rYiwzt48UOnRsxhxvEhqmEa37H+T2lVyw+oTk=;
        b=ichTihPOjj8YpPSKQ4Ajk13EmYM+4Ny4gxB4U/DrT2iNUabZYDUzNSqBDNy/aP2jPh
         JxxN6ej2LXoK2Ec5E8EISFWZab+KUjpfiXNW5iTVWzWAImWZuBG4/G50M3XrxlZewwk/
         Ysx+67VZ9oq+gMcSsGMDobfYNOzCgCuEOtP6NORrOf+SdF8mM+0xkL/AtH2HoNjIdMa/
         UvNVEljEbftzNVolbb6zY1ihrNlscrSAym4v60XtL3MhzoBqTeTYLf7q+9siTQH7/Luv
         p3LFBv4LSXtaBAuflrcol5ngmqSrucKclplGEOGlQXvFXJNQFun2Vr3Ic24ojz8Z6E9n
         3d9Q==
X-Gm-Message-State: AOAM531SnHCwG07ZAULYbFKvrLd42AI7CHqRB9uT/GjRNfxVekHo8+c3
        OpyG39GvJu5LDWJRp6dQ7LKSdSsVdms=
X-Google-Smtp-Source: ABdhPJz+B4QgJty3+AtayDj+tEhK0I64NkM6kmiTz+KeJ2wRmOOfTDPXb3nBBzG2PIYu/92N34cdLA==
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr19317794ejc.69.1631634551594;
        Tue, 14 Sep 2021 08:49:11 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id s9sm5871407edc.82.2021.09.14.08.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 08:49:11 -0700 (PDT)
Subject: Re: [PATCH v2 5.15] io_uring: auto-removal for direct open/accept
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
References: <c896f14ea46b0eaa6c09d93149e665c2c37979b4.1631632300.git.asml.silence@gmail.com>
 <997aadc0-0b8d-e42b-242d-670cccd0b59c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <7581ec11-315d-f459-2ee4-652426192807@gmail.com>
Date:   Tue, 14 Sep 2021 16:48:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <997aadc0-0b8d-e42b-242d-670cccd0b59c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 4:36 PM, Jens Axboe wrote:
> On 9/14/21 9:12 AM, Pavel Begunkov wrote:
>> It might be inconvenient that direct open/accept deviates from the
>> update semantics and fails if the slot is taken instead of removing a
>> file sitting there. Implement this auto-removal.
>>
>> Note that removal might need to allocate and so may fail. However, if an
>> empty slot is specified, it's guaraneed to not fail on the fd
>> installation side for valid userspace programs. It's needed for users
>> who can't tolerate such failures, e.g. accept where the other end
>> never retries.
>>
>> Suggested-by: Franz-B. Tuneke <franz-bernhard.tuneke@tu-dortmund.de>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> v2: simplify io_rsrc_node_switch_start() handling
>>
>>  fs/io_uring.c | 52 +++++++++++++++++++++++++++++++++------------------
>>  1 file changed, 34 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index a864a94364c6..58c0cbfdd128 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8287,11 +8287,27 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
>>  #endif
>>  }
>>  
>> +static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
>> +				 struct io_rsrc_node *node, void *rsrc)
>> +{
>> +	struct io_rsrc_put *prsrc;
>> +
>> +	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
>> +	if (!prsrc)
>> +		return -ENOMEM;
>> +
>> +	prsrc->tag = *io_get_tag_slot(data, idx);
>> +	prsrc->rsrc = rsrc;
>> +	list_add(&prsrc->list, &node->rsrc_list);
>> +	return 0;
>> +}
> 
> I know this code is just being moved, but I tend to like making the
> expected/fast path inline:

I think it's more natural as now, as we always have

ret = do_something();
if (ret)
    return ret;
ret = do_something2();
if (ret)
    goto err;


And I remember you telling once "... I tend to like to do the error
path like that unless it's a hot path ...". So maybe just add
unlikely()?


> prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
> if (prsrc) {
> 	prsrc->tag = *io_get_tag_slot(data, idx);
> 	prsrc->rsrc = rsrc;
> 	list_add(&prsrc->list, &node->rsrc_list);
> 	return 0;
> }
> return -ENOMEM;
> 

-- 
Pavel Begunkov
