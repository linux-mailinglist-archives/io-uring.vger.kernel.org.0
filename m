Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C6F6923D4
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 17:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjBJQ7K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 11:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjBJQ7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 11:59:00 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8E51A674
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 08:58:57 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id 65so2169903iou.3
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 08:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676048337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rrh0NDaHMY9O1FS98P5dAqfFDyWSfS3HhhQqFVWgZOE=;
        b=DVL3MPv9sMruszS7zHhzndY8WHnB6AgksAFy5dqTvW8M30CClTuuVf7NpuIbfmxU5w
         pN7Fts0Q/8DEk6TyOdtTCW4+EpLxQaOevBd6wEBwPAZ6TPnO9UJRRzOccQdfWsKsbpGf
         +Uehyf0N1dlc4Blds753OkcWDZ3c/iD+XNlkfleSsbRxKHHW2C9QuU2aNlX/ONLmJw8D
         JZrd0x3iPYjK8QVCTdAG0sD90OVMnT7o0c+goUq2LBJFyZb0zCbZObrmtPI5cxs8bWch
         S8uWwqv20BE9dH94mf/tMTQ2rWldZ5CguUhUvlW8l5FYXszzB7P0+zRz/qOcaKsIz8AG
         1BIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676048337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rrh0NDaHMY9O1FS98P5dAqfFDyWSfS3HhhQqFVWgZOE=;
        b=wsXjC2+hCdwzYntiCkI4FmmWib/KUAhuMIrT7kkBmo0HST7QSh8FUBxNSR401T8S7J
         bkDHMSBA2nk7zABx615W9A6GN+yRteCShTFYLijfVXdBWtU8s7rPDJCMQRiQfnMUKafD
         hAIBySRjCghs3ivwxOsOqKq6plZwJVFNE+v2J19UIsW8FbFEK1N0rsVQzsSnyGafrDIu
         kzmUWlX6jnBcW31ngeqB8Fr1visUNhu9wcthuDjoOdzIQBtwgPdgXe+9y/2yp5c3JhRp
         LRXyKRkYEYGzUEZB50Dh2AqgN4Wl1NXx9NB2iaCCZSl/1Z4EG+mttQ/JB8AiqeJzYbH0
         q6uA==
X-Gm-Message-State: AO0yUKXG2+tn7NK3dy6/l5yc39ecOXjPm5QuUiQIaVJThsEAZU33HRsW
        rCWb61fmo1je+6d5qg9JF8CJUA==
X-Google-Smtp-Source: AK7set/CyHbofIp/G2RL2FgjvDqyudxHU+KGsBOzNuN7iKexvugyLUIJFiToFdDTBQJyRSyu93edbg==
X-Received: by 2002:a6b:7019:0:b0:72c:f57a:a37b with SMTP id l25-20020a6b7019000000b0072cf57aa37bmr10159969ioc.2.1676048336820;
        Fri, 10 Feb 2023 08:58:56 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f4-20020a02a804000000b003aabed37b1bsm1499059jaj.175.2023.02.10.08.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 08:58:56 -0800 (PST)
Message-ID: <6340bd43-c96e-9702-e00a-b426f05b0271@kernel.dk>
Date:   Fri, 10 Feb 2023 09:58:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca>
 <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
 <13293926.uLZWGnKmhe@x2> <6939adfb-ce2c-1911-19ee-af32f7d9a5ca@kernel.dk>
 <CAHC9VhTGmGJ81M2CZWsTf1kNf8XNz2WsYFAP=5VAVSUfUiu1yQ@mail.gmail.com>
 <56ef99e4-f9de-0634-ce53-3bc2f1fa6665@kernel.dk>
 <CAHC9VhSgSREUDzJfDq9H_VAbyCZBYakhE19OiUB19QCeEM3q2A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhSgSREUDzJfDq9H_VAbyCZBYakhE19OiUB19QCeEM3q2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 9:52?AM, Paul Moore wrote:
> On Fri, Feb 10, 2023 at 11:00 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/10/23 8:39?AM, Paul Moore wrote:
>>> On Thu, Feb 9, 2023 at 7:15 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2/9/23 3:54?PM, Steve Grubb wrote:
>>>>> On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
>>>>>> On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>>>>>>> On 2023-02-01 16:18, Paul Moore wrote:
>>>>>>>> On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com>
>>>>> wrote:
>>>>>>>>> fadvise and madvise both provide hints for caching or access pattern
>>>>>>>>> for file and memory respectively.  Skip them.
>>>>>>>>
>>>>>>>> You forgot to update the first sentence in the commit description :/
>>>>>>>
>>>>>>> I didn't forget.  I updated that sentence to reflect the fact that the
>>>>>>> two should be treated similarly rather than differently.
>>>>>>
>>>>>> Ooookay.  Can we at least agree that the commit description should be
>>>>>> rephrased to make it clear that the patch only adjusts madvise?  Right
>>>>>> now I read the commit description and it sounds like you are adjusting
>>>>>> the behavior for both fadvise and madvise in this patch, which is not
>>>>>> true.
>>>>>>
>>>>>>>> I'm still looking for some type of statement that you've done some
>>>>>>>> homework on the IORING_OP_MADVISE case to ensure that it doesn't end
>>>>>>>> up calling into the LSM, see my previous emails on this.  I need more
>>>>>>>> than "Steve told me to do this".
>>>>>>>>
>>>>>>>> I basically just want to see that some care and thought has gone into
>>>>>>>> this patch to verify it is correct and good.
>>>>>>>
>>>>>>> Steve suggested I look into a number of iouring ops.  I looked at the
>>>>>>> description code and agreed that it wasn't necessary to audit madvise.
>>>>>>> The rationale for fadvise was detemined to have been conflated with
>>>>>>> fallocate and subsequently dropped.  Steve also suggested a number of
>>>>>>> others and after investigation I decided that their current state was
>>>>>>> correct.  *getxattr you've advised against, so it was dropped.  It
>>>>>>> appears fewer modifications were necessary than originally suspected.
>>>>>>
>>>>>> My concern is that three of the four changes you initially proposed
>>>>>> were rejected, which gives me pause about the fourth.  You mention
>>>>>> that based on your reading of madvise's description you feel auditing
>>>>>> isn't necessary - and you may be right - but based on our experience
>>>>>> so far with this patchset I would like to hear that you have properly
>>>>>> investigated all of the madvise code paths, and I would like that in
>>>>>> the commit description.
>>>>>
>>>>> I think you're being unnecessarily hard on this. Yes, the commit message
>>>>> might be touched up. But madvise is advisory in nature. It is not security
>>>>> relevant. And a grep through the security directory doesn't turn up any
>>>>> hooks.
>>>>
>>>> Agree, it's getting a bit anal... FWIW, patch looks fine to me.
>>>
>>> Call it whatever you want, but the details are often important at this
>>> level of code, and when I see a patch author pushing back on verifying
>>> that their patch is correct it makes me very skeptical.
>>
>> Maybe it isn't intended, but the replies have generally had a pretty
>> condescending tone to them. That's not the best way to engage folks, and
>> may very well be why people just kind of give up on it. Nobody likes
>> debating one-liners forever, particularly not if it isn't inviting.
> 
> I appreciate that you are coming from a different space, but I stand
> by my comments.  Of course you are welcome to your own opinion, but I
> would encourage you to spend some time reading the audit mail archives
> going back a few years before you make comments like the above ... or
> not, that's your call; I recognize it is usually easier to criticize.

I'm just saying how it was received on my end, you can take that as
constructive feedback or ignore it. I don't need to read the archives
for that as it is not related to anything but this thread, it was not
meant to reflect a general concern outside of this thread.

> On a quasi related note to the list/archives: unfortunately there was
> continued resistance to opening up the linux-audit list so I've setup
> audit@vger for upstream audit kernel work moving forward.  The list
> address in MAINTAINERS will get updated during the next merge window
> so hopefully some of the problems you had in the beginning of this
> discussion will be better in the future.

OK good, I keep forgetting to delete it from the replies and get annoyed
at the spam I get back... Thanks for fixing that going forward.

>>> I really would have preferred that you held off from merging this
>>> until this was resolved and ACK'd ... oh well.
>>
>> It's still top of tree. If you want to ack it, let me know and I'll add
>> it. If you want to nak it, give me something concrete to work off of.
> 
> I can't in good conscience ACK it without some comment from Richard
> that he has traced the code paths; this shouldn't be surprising at
> this point.  I'm not going to NACK it or post a revert, I would have
> done that already if I felt that was appropriate.  Right now this
> patch is in a gray area for me in that I suspect it is good, but I
> can't ACK it without some comment that it has been properly
> researched.

Richard, can you do the due diligence here? Steve did say:

"But madvise is advisory in nature. It is not security relevant. And a
grep through the security directory doesn't turn up any hooks."

Seems to me if we're not currently auditing madvise outside of io_uring,
then why would we do it here?

-- 
Jens Axboe

