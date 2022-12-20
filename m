Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A350C6526E2
	for <lists+io-uring@lfdr.de>; Tue, 20 Dec 2022 20:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiLTTWq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 14:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLTTWp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 14:22:45 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EFD12744
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 11:22:43 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id o13so6813549ilc.7
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 11:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wSVfXhpEcfDJFMsL9Y6D1ZAd5WVNRchCY82w5gO9odE=;
        b=0eMxSOja/Px2L47g5cF0HSHAuMXqcP3c9aJSXZR1h6fm/a0fF8VdfZt1b7GBqycuZs
         qwcmKUXKw8HrLyX1RRCEJEdDONqOCOM4V4ojjcfj4T63tHSLkKVYsczKzYiZtbzPyGCs
         +7MYu+tnf1y0AYwM0Lt1199y3ZCnibwk4F3isjSAGkq1UYtBNQOy/dZdYY1zp636tV+y
         ocbxXcEqqvW/EjqWEuerMdIyyOi9f8fApoDRY/lO/hTNTi1N7/4Hzi3FV3rAgTaGF5TV
         kW3gwkbergZ2c841dGljR5UHpzAUYXqhbVS5gz1BOnNXDqRZZ3sH/lW0nHcfw0VRsUMR
         Vrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wSVfXhpEcfDJFMsL9Y6D1ZAd5WVNRchCY82w5gO9odE=;
        b=d/sd87Hyge7diDDTOXeIMHfQZZiL9OOtz6/fn5uYDoJJxJG5PitAJYH3gJq81c2udR
         nvpeTdb3OsshGNQIcbf30CQAZE4KMbqNL9shaoFJRYiZ94nH2LiRcplC8kLo4UVSiTAm
         SPGqDyGjh6s6m1iCTLDWt/M9T/kb6VTZ+fXIJdPNnRsSo7lEEuEajtTHgJ7YJ/9UTKXS
         xmBPJDGqBn+1MWyu6A61uBWuS9K7CtYsch2K0taKlAqno2k6UFyOeoBvMzSpECXY/92W
         NUiZyMXIR819D6nOHWaiXrD5CmaHZKfBLJRib1F/O4yTGy9VxNRt7iI+oxYLFXCh0MS5
         8AyA==
X-Gm-Message-State: ANoB5plkAZPP4Sm7vLfH+3AK2v5twViyFP4uh4+p8S/GFEEQE0jB8nSt
        gt3MknltdZG9oqRJGy9oAyrQjnOGm7/tWtrP
X-Google-Smtp-Source: AA0mqf506FyUVPTkcPmE9f2kJRUn3uDw0u526BjeoGjXpOgZ/9Zrh660E0bmUx6jpC8pW0jOAUcTpg==
X-Received: by 2002:a92:d3ce:0:b0:303:d8:f309 with SMTP id c14-20020a92d3ce000000b0030300d8f309mr4430317ilh.2.1671564163027;
        Tue, 20 Dec 2022 11:22:43 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u10-20020a056e02080a00b0030258f9670bsm4666980ilm.13.2022.12.20.11.22.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 11:22:42 -0800 (PST)
Message-ID: <917c353d-f356-188a-fc7e-cdd126b35015@kernel.dk>
Date:   Tue, 20 Dec 2022 12:22:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC] io_uring: wake up optimisations
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <81104db1a04efbfcec90f5819081b4299542671a.1671559005.git.asml.silence@gmail.com>
 <7e983688-5fcf-a1fd-3422-4baed6a0cb89@gmail.com>
 <626cbdac-78a0-d8d9-b574-8617792542ac@kernel.dk>
 <a65ff942-1a67-d761-d3d6-4321107808fd@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a65ff942-1a67-d761-d3d6-4321107808fd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/22 12:12?PM, Pavel Begunkov wrote:
> On 12/20/22 18:10, Jens Axboe wrote:
>> On 12/20/22 11:06?AM, Pavel Begunkov wrote:
>>> On 12/20/22 17:58, Pavel Begunkov wrote:
>>>> NOT FOR INCLUSION, needs some ring poll workarounds
>>>>
>>>> Flush completions is done either from the submit syscall or by the
>>>> task_work, both are in the context of the submitter task, and when it
>>>> goes for a single threaded rings like implied by ->task_complete, there
>>>> won't be any waiters on ->cq_wait but the master task. That means that
>>>> there can be no tasks sleeping on cq_wait while we run
>>>> __io_submit_flush_completions() and so waking up can be skipped.
>>>
>>> Not trivial to benchmark as we need something to emulate a task_work
>>> coming in the middle of waiting. I used the diff below to complete nops
>>> in tw and removed preliminary tw runs for the "in the middle of waiting"
>>> part. IORING_SETUP_SKIP_CQWAKE controls whether we use optimisation or
>>> not.
>>>
>>> It gets around 15% more IOPS (6769526 -> 7803304), which correlates
>>> to 10% of wakeup cost in profiles. Another interesting part is that
>>> waitqueues are excessive for our purposes and we can replace cq_wait
>>> with something less heavier, e.g. atomic bit set
>>
>> I was thinking something like that the other day, for most purposes
>> the wait infra is too heavy handed for our case. If we exclude poll
>> for a second, everything else is internal and eg doesn't need IRQ
>> safe locking at all. That's just one part of it. But I didn't have
> 
> Ring polling? We can move it to a separate waitqueue, probably with
> some tricks to remove extra ifs from the hot path, which I'm
> planning to add in v2.

Yes, polling on the ring itself. And that was my thinking too, leave
cq_wait just for that and then hide it behind <something something> to
make it hopefully almost free for when the ring isn't polled. I just
hadn't put any thought into what exactly that'd look like just yet.

>> a good idea for the poll() side of things, which would be required
>> to make some progress there.
> 
> I'll play with replacing waitqueues with a bitops, should save some
> extra ~5% with the benchmark I used.

Excellent, looking forward to seeing that.

-- 
Jens Axboe

