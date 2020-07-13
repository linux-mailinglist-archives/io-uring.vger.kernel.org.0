Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177B021E1CF
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 23:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgGMVAh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 17:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgGMVAh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 17:00:37 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32082C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:00:37 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y2so15046623ioy.3
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rUr4GvyNB8aSV8jPovxxmig4JjAndY/rOncXm/y71GM=;
        b=GeIxqbuMZB5zNUZhaP7PEt2sHxWbw/EX624IV/PCpWA+8Fn1JIM8HINX7rFAeX6gGE
         RCQx/4JD3aScS0/qy3S495EUmxUavlxb61czyHYL90xVqh1Rogelcr808bD6mf500bU0
         94aZAhOBPyQu7uPSWc8zJGMCYJiBtVFho1hn6OupPLygJqScwSmhXwPoanhsczax5141
         Q0rDHnS6bZ1wOAIBtYheIwVqXrhf21d6O25PD7YWpsXDrAzxSFk999VXltb2bxq5ue7Z
         DwSnw6bhwJIl967qyXXOCCoXUQOpx98AXXd+Ek3epd06r+LSJmWsCqH+1C6Ew76g5EKE
         7cTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rUr4GvyNB8aSV8jPovxxmig4JjAndY/rOncXm/y71GM=;
        b=YBwXGlARlqLKd3zpW6qg9iQKGNgohoPZBrIKkmPBb78e0Xw8saoA3SyVz98M58fRtZ
         8dvWtY0/t1sHgeMsakw9z0m6+GaAIWM6gfr2TwBs1tXYJ/36dletfQyLq/E0qahIWgag
         DgywfG+6RmqDNicFiOwCcur+QjaM+EFBMwAM80fgkqWbMH1P0iuCnMF7AzVLKQob2sX2
         6xteiBkRESXuEtrqRGpbVAZsP6hqnpLhfhLR7lfBb5PVa2gmtHaZ+d9Uk/ijTd0T4o4V
         ME0rjUYqAZj9J0d3p4wh1xG4v1xjBxZtY9shd5XG1nXG83MJPFH2VIUKg6kA5bsXpjw5
         E42w==
X-Gm-Message-State: AOAM531qmtVHyw9UBZwFXyLREz45YiOMTAwACEcEjziJjpG4KLbmiWi5
        LohpggD3GgRyBv/SpoO90b894EE4OAb9MA==
X-Google-Smtp-Source: ABdhPJzgYC9xY6FnOrTcEDTY7KrSKBARFW9j7qycbv1LhP/2ufs7hP21wtav8Wd4JPRaRiPAdkz2mA==
X-Received: by 2002:a02:cd91:: with SMTP id l17mr2191356jap.88.1594674035629;
        Mon, 13 Jul 2020 14:00:35 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k24sm9133914ilg.66.2020.07.13.14.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:00:35 -0700 (PDT)
Subject: Re: [RFC 0/9] scrap 24 bytes from io_kiocb
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594546078.git.asml.silence@gmail.com>
 <edfa9852-695d-d122-91f8-66a888b482c0@kernel.dk>
 <618bc9a5-420c-b176-df86-260734270f56@gmail.com>
 <3b3ee104-ee6b-7147-0677-bd0eb4efe76e@kernel.dk>
 <7368254d-1f2c-2cc9-1198-8a666f7f8864@gmail.com>
 <e1e53293-c57a-6c65-0e88-eb4414783f05@kernel.dk>
 <8776cf1b-c00d-26c3-7807-f76f8d9843de@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8789b1d2-2949-84be-58e4-fa56db348337@kernel.dk>
Date:   Mon, 13 Jul 2020 15:00:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8776cf1b-c00d-26c3-7807-f76f8d9843de@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 2:45 PM, Pavel Begunkov wrote:
> On 13/07/2020 17:12, Jens Axboe wrote:
>> On 7/13/20 2:17 AM, Pavel Begunkov wrote:
>>> On 12/07/2020 23:32, Jens Axboe wrote:
>>>> On 7/12/20 11:34 AM, Pavel Begunkov wrote:
>>>>> On 12/07/2020 18:59, Jens Axboe wrote:
>>>>>> On 7/12/20 3:41 AM, Pavel Begunkov wrote:
>>>>>>> Make io_kiocb slimmer by 24 bytes mainly by revising lists usage. The
>>>>>>> drawback is adding extra kmalloc in draining path, but that's a slow
>>>>>>> path, so meh. It also frees some space for the deferred completion path
>>>>>>> if would be needed in the future, but the main idea here is to shrink it
>>>>>>> to 3 cachelines in the end.
>>>>>>>
>>>>>>> I'm not happy yet with a few details, so that's not final, but it would
>>>>>>> be lovely to hear some feedback.
>>>>>>
>>>>>> I think it looks pretty good, most of the changes are straight forward.
>>>>>> Adding a completion entry that shares the submit space is a good idea,
>>>>>> and really helps bring it together.
>>>>>>
>>>>>> From a quick look, the only part I'm not super crazy about is patch #3.
>>>>>
>>>>> Thanks!
>>>>>
>>>>>> I'd probably rather use a generic list name and not unionize the tw
>>>>>> lists.
>>>>>
>>>>> I don't care much, but without compiler's help always have troubles
>>>>> finding and distinguishing something as generic as "list".
>>>>
>>>> To me, it's easier to verify that we're doing the right thing when they
>>>> use the same list member. Otherwise you have to cross reference two
>>>> different names, easier to shoot yourself in the foot that way. So I'd
>>>> prefer just retaining it as 'list' or something generic.
>>>
>>> If you don't have objections, I'll just leave it "inflight_entry". This
>>> one is easy to grep.
>>
>> Sure, don't have strong feelings on the actual name.
>>
>>>>> BTW, I thought out how to bring it down to 3 cache lines, but that would
>>>>> require taking io_wq_work out of io_kiocb and kmalloc'ing it on demand.
>>>>> And there should also be a bunch of nice side effects like improving apoll.
>>>>
>>>> How would this work with the current use of io_wq_work as storage for
>>>> whatever bits we're hanging on to? I guess it could work with a prep
>>>> series first more cleanly separating it, though I do feel like we've
>>>> been getting closer to that already.
>>>
>>> It's definitely not a single patch. I'm going to prepare a series for
>>> discussion later, and then we'll see whether it worth it.
>>
>> Definitely not. Let's flesh this one out first, then we can move on.
> 
> But not a lot of work either.

Great

> I've got a bit lost, do you mean to flesh out the idea or this
> "loose 24 bytes" series?

The latter, but I'm already looking over your v2, so I guess that's
taken care of.

-- 
Jens Axboe

