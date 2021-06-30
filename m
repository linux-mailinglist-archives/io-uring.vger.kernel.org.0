Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27F63B8A1A
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhF3VZX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhF3VZW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:25:22 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A38C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:22:52 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id g5so1319912iox.11
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iCjgPOwCo7A0wHxXgGL36eU2kMdzj5tjrrUzHkIGkko=;
        b=X7xYMydW7f26AUtV1zXOaC7V8x3bI77XEr+c6nkVociqRaYD6MasfP7uXGVMKRBiS7
         Cb+edRICrPp0EIXh9KZLwyYxc9/R2ocJY3t7i2U9jBuZsE+r6F5jn1w2NGMdr0LV0gsF
         DCHDpCVfW/437nkxLxEso34XlKzxDkcv2zOMMkNYKSTdL+SuPXJc59sMJUww/So4dvYl
         rmr4LUHoY8j6DWye+2+WnMUDUgIhqjETsWDEpyiho4Hc9N8HlBomPb7l6KkVGAhwZpdg
         Gl0a5/U5KUOq2fJAO/CxmReTp/y7czbgmpgbH8xasZhV7ALTYdYKliPjrFlkxjgGLZUP
         ewFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iCjgPOwCo7A0wHxXgGL36eU2kMdzj5tjrrUzHkIGkko=;
        b=QODnZJAWeGUtShwoYJyfA9DAlUnm3vgwsvyVRU3FZkln6ESdKx8Mt1v5tBW25q0J+c
         ZiNiC/+OoOjrLPVdONLYe9rCcDHANB+kgB5x6BzgvW/Pm+exSJnzDzYN5MaArgtr1qFE
         v9Z8FGM2z4++3LHMkQVjCN41vAICNKS+8bCdXSA7w/0A7Q9LxySZxQWDNk/jJ5Cd/99g
         ZxFxANGDqS8cd4hxiAN/ixyxtITS66vUKeyChMox6Eu57nRbBBNh7QTlGpOjo/S40X9Z
         eV+shLYxRHlMLKHy1VXxJ2v+OgpzK8yN5CkgccCnuYVBe9zv+AHfj1ObogilpHaAIe9V
         iDYA==
X-Gm-Message-State: AOAM531lBfJUcjSfPEhFFVgUEadsTKKOklfG0QEhPbZVdqG9PxIfT1BK
        tKRFMqVsmtuCAsx2wKuB0BqgMhF8jdqbjQ==
X-Google-Smtp-Source: ABdhPJzxKLZ6ld+xe+pS/J3i91s/lwMG7F+pHxO+g3+h3tsERKsiu3cW0taKu36x09s4fk4g1dc0UQ==
X-Received: by 2002:a05:6602:2c4a:: with SMTP id x10mr5207497iov.96.1625088172135;
        Wed, 30 Jun 2021 14:22:52 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id g6sm12642184ilj.65.2021.06.30.14.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:22:51 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
 <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
 <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e1b32d88-5801-b280-25ed-9902cfaa5092@kernel.dk>
Date:   Wed, 30 Jun 2021 15:22:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 3:19 PM, Pavel Begunkov wrote:
> On 6/30/21 10:17 PM, Jens Axboe wrote:
>> On 6/30/21 2:54 PM, Pavel Begunkov wrote:
>>> Whenever possible we don't want to fallback a request. task_work_add()
>>> will be fine if the task is exiting, so don't check for PF_EXITING,
>>> there is anyway only a relatively small gap between setting the flag
>>> and doing the final task_work_run().
>>>
>>> Also add likely for the hot path.
>>
>> I'm not a huge fan of likely/unlikely, and in particular constructs like:
>>
>>> -	if (test_bit(0, &tctx->task_state) ||
>>> +	if (likely(test_bit(0, &tctx->task_state)) ||
>>>  	    test_and_set_bit(0, &tctx->task_state))
>>>  		return 0;
>>
>> where the state is combined. In any case, it should be a separate
>> change. If there's an "Also" paragraph in a patch, then that's also
>> usually a good clue that that particular change should've been
>> separate :-)
> 
> Not sure what's wrong with likely above, but how about drop
> this one then?

Yep I did - we can do the exiting change separately, the commit message
just needs to be clarified a bit on why it's ok to do now. And that
last sentence dropped, of course.

-- 
Jens Axboe

