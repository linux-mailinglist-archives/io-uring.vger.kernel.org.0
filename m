Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB234AA6C
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 15:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhCZOuT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 10:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhCZOuG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 10:50:06 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25252C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 07:50:06 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r193so5627603ior.9
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 07:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NCrS9iSkYyQTH7Kgs8zwkcq/baRWu0lLKcFuH4cqgFg=;
        b=iGK/gRZfeC3cbbqAjOASxYWKK53wUvLo9OenDtjIhCKQlvUE1avGlEYpUsj6gV4ydp
         JQeU50n/4XtXc+5HtNCg139qbO58VXQjcBPvcgQLH9fCnxO/feZnCurbksMS2hEM+vdU
         fMwzgs2BCfQVKDCPqppp6c9hGyuwMwoP4wstuVVZ+UEO2gIjG5JQgIFcTbOy5E7y6vAW
         +xtKKVseu+9UBTxumxF8gKiXJzdqHh7lzn4Fe7UfPaTwHXaD+FkVM+yf8vsevGDoofAU
         jkuQV96v/kw2VzDMBNAJJdJwiSJDQ0kTJkMhxyvvzHllwFhv95N/MZE6NZRTXpiD6dqV
         NCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NCrS9iSkYyQTH7Kgs8zwkcq/baRWu0lLKcFuH4cqgFg=;
        b=D0q0umj+qpxriV+t9tuiOiyCiJdR5er7jqHo6zzctQ9FMSTYeVmY8bVK3IFRFayABy
         NGtXhjH9ycsgFFGV3NdryJVoPx6lw4FkxjSrcsH8YwPZlbvrou+Fo2wXv34I8z15AMYN
         fmOQo3ffHrlzIzo+bZ7VrNXwI2KHsPFc53FC/49LTYnJ2MtiLiUe6WcU1nhdplwJy9Sq
         2YTiteF0tsEUk+jfYNmsJoqAZtbBDetPQhT3AdxVoznwvl2H5s64h8/OfNwm5ppNFTVv
         A7HRaWMQOTkPoC0TLabGWy9IFUIlNxCcBXqfYvC5yWC8wp11Eax+QInFPbEGb4oN03M9
         IGBQ==
X-Gm-Message-State: AOAM531V132Eo0gxTmVmY4UuWVVjsmQbPynvAv4RieeztmewXmXKBhga
        OMi+QFJPo6r274Vecx13katyUQ==
X-Google-Smtp-Source: ABdhPJxQJtEQI5UCABz+W+UvbPcm+d2yBOgPoJQMIVxMaqQBXBW4iwT+7Y5WPc1z92XE8UEbGdOMAA==
X-Received: by 2002:a02:7f8c:: with SMTP id r134mr12274121jac.95.1616770205481;
        Fri, 26 Mar 2021 07:50:05 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t9sm4339079ioi.27.2021.03.26.07.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 07:50:04 -0700 (PDT)
Subject: Re: [PATCH 0/6] Allow signals for IO threads
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <0c91d9e7-82cd-bec2-19ae-cc592ec757c6@kernel.dk>
 <bfaae5fd-5de9-bae4-89b6-2d67bbfb86c6@kernel.dk>
 <66fa3cfc-4161-76fe-272e-160097f32a53@kernel.dk>
 <67a83ad5-1a94-39e5-34c7-6b2192eb7edb@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a6f5f10b-b4f7-6674-79f0-31b14cfe3533@kernel.dk>
Date:   Fri, 26 Mar 2021 08:50:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <67a83ad5-1a94-39e5-34c7-6b2192eb7edb@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 8:43 AM, Stefan Metzmacher wrote:
> Am 26.03.21 um 15:38 schrieb Jens Axboe:
>> On 3/26/21 7:59 AM, Jens Axboe wrote:
>>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>>> The KILL after STOP deadlock still exists.
>>>>
>>>> In which tree? Sounds like you're still on the old one with that
>>>> incremental you sent, which wasn't complete.
>>>>
>>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>>
>>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>>> tested both of them separately and didn't observe anything. I also ran
>>>> your io_uring-cp example (and found a bug in the example, fixed and
>>>> pushed), fwiw.
>>>
>>> I can reproduce this one! I'll take a closer look.
>>
>> OK, that one is actually pretty straight forward - we rely on cleaning
>> up on exit, but for fatal cases, get_signal() will call do_exit() for us
>> and never return. So we might need a special case in there to deal with
>> that, or some other way of ensuring that fatal signal gets processed
>> correctly for IO threads.
> 
> And if (fatal_signal_pending(current)) doesn't prevent get_signal()
> from being called?

Usually yes, but this case is first doing SIGSTOP, so we're waiting in
get_signal() -> do_signal_stop() when the SIGKILL arrives. Hence there's
no way to catch it in the worker themselves.

-- 
Jens Axboe

