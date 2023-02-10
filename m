Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D2C692AEF
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 00:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBJXBo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 18:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBJXBn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 18:01:43 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B793A096
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 15:01:42 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 7so4782770pga.1
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 15:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i3KHKGNmoAF2bqTb11iNWeUC9IAHUCEfIctCRULpCXI=;
        b=Kx1p2INpJ/mf5b/P0E2ReN43EOVHkyxLY0Cc0BnOp+aAHmIlvNZYx8M+5P+oeUHe9r
         8gP9C2FGDGz8i+F+DMTTASLgs6DAzIIpEAkyCmfPB0MxZZHeq/pllV1cjbrTiq1J4xLf
         +uNNmwAL1ll3KpApw3ED7Fj1ssQ1cBYbHnwRQ7NqYQBEfb+W3kdY8Pe6OfM+w0hyqvJd
         ppt2D1z5VQnp3+MWIwpAWGDhKdUUt9qSQqEwyALN7vVj7IVu15JZwh6cBTwdoVh4Q8Fe
         Ba4J2AVrjuI7isuQs24OWSDTy+w3MzauCan20or/QWyGGMNsmHbIMgUSXtQi4tByltSR
         rQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i3KHKGNmoAF2bqTb11iNWeUC9IAHUCEfIctCRULpCXI=;
        b=vcqw36CLWKHVNRYLKqPnhXocJgyW/ROGrGI3EEcF69V259AHwvaC0/y2IWTnQzzU4w
         iiS4/7tFcK9Km+Si0dh9G9xoMqmYDj0X8cRUErctj/LWLL/olFgzr6OQ1ZztGcS7K67b
         3S5R3LLOyi7f6YXnOR/szYP+zDh6tyVFi95p3lM5AKNC497Twp3WpQ0yuAtcVWoFcLjr
         1SozgJKuRBExRrGLrOsjKKkydwCIRGHs/oYCOYH0+lZEE25qPD/NN86g7HSJ0sZpcgSk
         7T1fWXTyfbfkJvVXWHjsxROAt1IuMFk8fUGQbeMgjr7b0RaRcuNOpzcJeU0/X36+xU1o
         GBog==
X-Gm-Message-State: AO0yUKXSArkcBUHLJiURxSRWMFExbjNXp1lQam1toP5mYZ+C8g0/mpPH
        vAU2ukhxwoXKXoW2ITPFZvUkaA==
X-Google-Smtp-Source: AK7set+VC5dIE9BcKd80X28nbm2g26QZs7SMW1YyLWTfHoWAqjDe34WLhUNqeFaWsPdaW9PR4bFyQQ==
X-Received: by 2002:a62:cdc3:0:b0:5a8:5f10:225b with SMTP id o186-20020a62cdc3000000b005a85f10225bmr5242028pfg.1.1676070101400;
        Fri, 10 Feb 2023 15:01:41 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n17-20020a62e511000000b005a54a978c1bsm3741435pff.7.2023.02.10.15.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 15:01:40 -0800 (PST)
Message-ID: <e6e8d984-2518-4790-cf0e-e39849607c49@kernel.dk>
Date:   Fri, 10 Feb 2023 16:01:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Cc:     Steve Grubb <sgrubb@redhat.com>,
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
 <Y+a+hBtDwAXBgjsg@madcap2.tricolour.ca>
 <CAHC9VhTdJvUQNNcNRFdrx7FAvw__r5jZMzpcO4uzRKS1VqBt_g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhTdJvUQNNcNRFdrx7FAvw__r5jZMzpcO4uzRKS1VqBt_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 3:59 PM, Paul Moore wrote:
> On Fri, Feb 10, 2023 at 5:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> On 2023-02-10 11:52, Paul Moore wrote:
>>> On Fri, Feb 10, 2023 at 11:00 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2/10/23 8:39?AM, Paul Moore wrote:
>>>>> On Thu, Feb 9, 2023 at 7:15 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 2/9/23 3:54?PM, Steve Grubb wrote:
>>>>>>> On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
>>>>>>>> On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>>>>>>>>> On 2023-02-01 16:18, Paul Moore wrote:
>>>>>>>>>> On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com>
>>>>>>> wrote:
>>>>>>>>>>> fadvise and madvise both provide hints for caching or access pattern
>>>>>>>>>>> for file and memory respectively.  Skip them.
>>>>>>>>>>
>>>>>>>>>> You forgot to update the first sentence in the commit description :/
>>>>>>>>>
>>>>>>>>> I didn't forget.  I updated that sentence to reflect the fact that the
>>>>>>>>> two should be treated similarly rather than differently.
>>>>>>>>
>>>>>>>> Ooookay.  Can we at least agree that the commit description should be
>>>>>>>> rephrased to make it clear that the patch only adjusts madvise?  Right
>>>>>>>> now I read the commit description and it sounds like you are adjusting
>>>>>>>> the behavior for both fadvise and madvise in this patch, which is not
>>>>>>>> true.
>>>>>>>>
>>>>>>>>>> I'm still looking for some type of statement that you've done some
>>>>>>>>>> homework on the IORING_OP_MADVISE case to ensure that it doesn't end
>>>>>>>>>> up calling into the LSM, see my previous emails on this.  I need more
>>>>>>>>>> than "Steve told me to do this".
>>>>>>>>>>
>>>>>>>>>> I basically just want to see that some care and thought has gone into
>>>>>>>>>> this patch to verify it is correct and good.
>>>>>>>>>
>>>>>>>>> Steve suggested I look into a number of iouring ops.  I looked at the
>>>>>>>>> description code and agreed that it wasn't necessary to audit madvise.
>>>>>>>>> The rationale for fadvise was detemined to have been conflated with
>>>>>>>>> fallocate and subsequently dropped.  Steve also suggested a number of
>>>>>>>>> others and after investigation I decided that their current state was
>>>>>>>>> correct.  *getxattr you've advised against, so it was dropped.  It
>>>>>>>>> appears fewer modifications were necessary than originally suspected.
>>>>>>>>
>>>>>>>> My concern is that three of the four changes you initially proposed
>>>>>>>> were rejected, which gives me pause about the fourth.  You mention
>>>>>>>> that based on your reading of madvise's description you feel auditing
>>>>>>>> isn't necessary - and you may be right - but based on our experience
>>>>>>>> so far with this patchset I would like to hear that you have properly
>>>>>>>> investigated all of the madvise code paths, and I would like that in
>>>>>>>> the commit description.
>>>>>>>
>>>>>>> I think you're being unnecessarily hard on this. Yes, the commit message
>>>>>>> might be touched up. But madvise is advisory in nature. It is not security
>>>>>>> relevant. And a grep through the security directory doesn't turn up any
>>>>>>> hooks.
>>>>>>
>>>>>> Agree, it's getting a bit anal... FWIW, patch looks fine to me.
>>>>>
>>>>> Call it whatever you want, but the details are often important at this
>>>>> level of code, and when I see a patch author pushing back on verifying
>>>>> that their patch is correct it makes me very skeptical.
>>>>
>>>> Maybe it isn't intended, but the replies have generally had a pretty
>>>> condescending tone to them. That's not the best way to engage folks, and
>>>> may very well be why people just kind of give up on it. Nobody likes
>>>> debating one-liners forever, particularly not if it isn't inviting.
>>>
>>> I appreciate that you are coming from a different space, but I stand
>>> by my comments.  Of course you are welcome to your own opinion, but I
>>> would encourage you to spend some time reading the audit mail archives
>>> going back a few years before you make comments like the above ... or
>>> not, that's your call; I recognize it is usually easier to criticize.
>>>
>>> On a quasi related note to the list/archives: unfortunately there was
>>> continued resistance to opening up the linux-audit list so I've setup
>>> audit@vger for upstream audit kernel work moving forward.  The list
>>> address in MAINTAINERS will get updated during the next merge window
>>> so hopefully some of the problems you had in the beginning of this
>>> discussion will be better in the future.
>>>
>>>>> I really would have preferred that you held off from merging this
>>>>> until this was resolved and ACK'd ... oh well.
>>>>
>>>> It's still top of tree. If you want to ack it, let me know and I'll add
>>>> it. If you want to nak it, give me something concrete to work off of.
>>>
>>> I can't in good conscience ACK it without some comment from Richard
>>> that he has traced the code paths; this shouldn't be surprising at
>>> this point.  I'm not going to NACK it or post a revert, I would have
>>> done that already if I felt that was appropriate.  Right now this
>>> patch is in a gray area for me in that I suspect it is good, but I
>>> can't ACK it without some comment that it has been properly
>>> researched.
>>
>> I feel a bit silly replying in this thread.  My dad claims that I need
>> to have the last word in any argument, so that way he gets it instead...
>>
>> I appear to have accidentally omitted the connector word "and" between
>> "description" and "code" above, which may have led you to doubt I had
>> gone back and re-looked at the code.
> 
> Okay, as long as you've done the homework on this I'm good.  If it's
> still on the top of Jen's tree, here's my ACK:
> 
> Acked-by: Paul Moore <paul@paul-moore.com>
> 
> ... if it's not on top of the tree, it's not worth popping patches to
> add the ACK IMHO.

Thanks - and it is, so I added the acked-by.

> Feel free to reply to this Richard if you want to have the last word
> in this thread, I think I'm done ;)
Let's close it up :-)

-- 
Jens Axboe


