Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B7517994E
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 20:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgCDTu7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 14:50:59 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45879 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgCDTu7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 14:50:59 -0500
Received: by mail-il1-f195.google.com with SMTP id s201so2151046ilc.12
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 11:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6+dZ8mka3m/YUuzPaWXwaycBYWlcCeI00o5WArPjgOc=;
        b=icAIPeGSFlyH0DzKHSQZZaXpTJj3HbUgeo9My55RtrRBJtG+Z6+/KwVWkVvkHCWnhA
         Vas0N1zEWsQa1PdCA/eHATVwx0efbm4tlQKVxTdUUkJljbsxc9KSEtBAzD7lK35oBKZO
         xePyev/HJuU1N4z9r9d7u5l3cfzQn0B/+sFrMOIe3gnr2jE9ulm3thDQQx4Tdd8kKYRo
         7HxjxrmZkuQK/OFKLCfRmsUjq2E6QczO/URPMiDhjbZsdkVyVOG2e5PRK2TNti/8Iyw7
         0yRfOa8QoU1r4tRf/ZmXFuwB1iZXFGxtmyDvsPBdEu+TKNEiPzBuMlPRAqAJMB2dUNdK
         jqoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6+dZ8mka3m/YUuzPaWXwaycBYWlcCeI00o5WArPjgOc=;
        b=HGw8Yqzx5OdN8ja7fvZEch12yNWeZdaV5/HJrNd3GLrypk/p8LAzGRDk+o0rAaO6UT
         r4lJmVK6NWcMwn+wmxibOZqNQ08COBA+AEMN+8ogEI+d4a/xUOkjUIIR53K+RZVGw6bP
         FHkfkEz1uHrJk/JKZwHs/Xb237KzAqaU3o5RACqFK4W2joaN9Y6hSe/L5VJnNlFtC98U
         R1NK2npdyQK++FOzIPMhAWwviSxT0P+9glC6VKVb8kS0Oei7hWZLmagh7ecS0V3KgEPu
         Lt8JcJk1e8QmAIVjYiL2TljMx/qaIn0s3c2a+5+lFPCNN+AIb4OanqFHjngnlmfysmrt
         boaQ==
X-Gm-Message-State: ANhLgQ0LoxDR0HRKdtK+ZPrIMYDmto8PLmGnXX/umcykeoK8DtTKS+wP
        hTNdF3e67lbe7f6tWFb7SUoJV6K4Rho=
X-Google-Smtp-Source: ADFU+vsylS5NjPuU7aNoxo6ywGsj58eXKh64aBxiUeRFMo7zXKmK0bhjfS/AX6z1s54RsvOlX8v5Wg==
X-Received: by 2002:a05:6e02:686:: with SMTP id o6mr4207168ils.181.1583351456912;
        Wed, 04 Mar 2020 11:50:56 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d18sm6738920iom.39.2020.03.04.11.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 11:50:56 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] Support selectable file descriptors
To:     Jeff Layton <jlayton@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org
References: <20200304180016.28212-1-axboe@kernel.dk>
 <20200304190341.GB16251@localhost>
 <121d15a7-4b21-368c-e805-a0660b1c851a@kernel.dk>
 <50d459bb4c894b99532d9f56fadceb0c317ab7f0.camel@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <23facb58-294c-546e-576c-9edbe40af750@kernel.dk>
Date:   Wed, 4 Mar 2020 12:50:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <50d459bb4c894b99532d9f56fadceb0c317ab7f0.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 12:28 PM, Jeff Layton wrote:
> On Wed, 2020-03-04 at 12:10 -0700, Jens Axboe wrote:
>> On 3/4/20 12:03 PM, Josh Triplett wrote:
>>> On Wed, Mar 04, 2020 at 11:00:10AM -0700, Jens Axboe wrote:
>>>> One of the fabled features with chains has long been the desire to
>>>> support things like:
>>>>
>>>> <open fileX><read from fileX><close fileX>
>>>>
>>>> in a single chain. This currently doesn't work, since the read/close
>>>> depends on what file descriptor we get on open.
>>>>
>>>> The original attempt at solving this provided a means to pass
>>>> descriptors between chains in a link, this version takes a different
>>>> route. Based on Josh's support for O_SPECIFIC_FD, we can instead control
>>>> what fd value we're going to get out of open (or accept). With that in
>>>> place, we don't need to do any magic to make this work. The above chain
>>>> then becomes:
>>>>
>>>> <open fileX with fd Y><read from fd Y><close fd Y>
>>>>
>>>> which is a lot more useful, and allows any sort of weird chains without
>>>> needing to nest "last open" file descriptors.
>>>>
>>>> Updated the test program to use this approach:
>>>>
>>>> https://git.kernel.dk/cgit/liburing/plain/test/orc.c?h=fd-select
>>>>
>>>> which forces the use of fd==89 for the open, and then uses that for the
>>>> read and close.
>>>>
>>>> Outside of this adaptation, fixed a few bugs and cleaned things up.
>>>
>>> I posted one comment about an issue in patch 6.
>>>
>>> Patches 2-5 look great; for those:
>>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>>>
>>> Thanks for picking this up and running with it!
>>
>> Thanks for doing the prep work! I think it turned out that much better
>> for it.
>>
>> Are you going to post your series for general review? I just stole
>> your 1 patch that was needed for me.
>>
> 
> This does seem like a better approach overall.
> 
> How should userland programs pick fds to use for this though? Should you
> just start with some reasonably high number that you don't expect to
> have been used by the current process or is there some more reliable way
> to do it?

If you look at Josh's separate posting, he has a patch that sets the
min_fd for the normal dynamic allocations. With that, you could set that
to eg 1000, and then know that anything below that would be fair game to
use for the selectable fd values.

-- 
Jens Axboe

