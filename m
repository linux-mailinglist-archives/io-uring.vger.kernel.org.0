Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF58A6922D8
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 17:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjBJQAj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 11:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjBJQAi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 11:00:38 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CEF75F67
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 08:00:14 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id bi9so462891iob.1
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 08:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cKCnbmHogXEmRbO0onTMSj4NA86gqgz0RX9mB07CwWE=;
        b=NRNcgzMs3xVQhy98cuw8J0uyYV74wWmalgd6Ee9nF+MMKeTdWLva7zLEBCou+6wVU2
         x1fB8qTqds8ozhmq9P3Mpqb8tlbyfOr/pFFCEHJaR2JAdpDMpRnTEt6yO68/eCdM5CAf
         hxfPO/Bp5QLmvWiTU6BsO/6AzfiZVHKz+ia7H5qGqiZEIV0V9YfKfymdbT56vXRUvfTo
         7rhkT+49tiTvOxozI7mrXhKqa48uJiirq8gRInDb8WvkTUTtwILnE62fET9MAgVdLAU6
         9rnU9Qo7xMK+A2kbt65qharnTeBB9FUmPA0tP3Iw7KaTwScOKh1jNNQnBtCKTgKRjzMe
         EbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cKCnbmHogXEmRbO0onTMSj4NA86gqgz0RX9mB07CwWE=;
        b=pLdxnQ7wzGML/cFDnSsg6TZZ8XkklR5f4KHSU5dGObioFPEsT4DIgKqdE8lTAeZDnb
         fptgJBYsKTXpPL7RNgtJ5l4vR5EAjO9FkFspfrmGj0dFhBQU3JZPbFzKNWcdCBi0kInm
         sdOEb9F6HmmTbmOLQOBroD1MwYCjFvHvvILyV3GNTzjaZ+HK2EzB6KiDyKO1WOQC3NP6
         HceEW5Vb7SPxqaLffwkEz4Vj+ipd78qH1Tvi4kKfYYgjki/jH3B2aNaypkYMeCmFu/zs
         /xZpshmuSl5mdZh4c67aXXUgrEqvYBUw1d82M0OPffe/zLdsSFS1OTuoMvmKuCNDOUXi
         5rog==
X-Gm-Message-State: AO0yUKV8h9yAoSFuRHVWyYa9eUkCmAIMmwiSuO2f5TsroK1xZnoLhhAS
        qJkrrtKRxqpjjek7eT9GmOINEQ==
X-Google-Smtp-Source: AK7set/SjFI233Hr0PsxihtGJ1Amwm5e4Y73hxHeifCQOI2JIX5bo16OqRZP/ZRIrzu2zanedDEbxQ==
X-Received: by 2002:a5d:9492:0:b0:707:6808:45c0 with SMTP id v18-20020a5d9492000000b00707680845c0mr10394797ioj.1.1676044813908;
        Fri, 10 Feb 2023 08:00:13 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n10-20020a5ed90a000000b0073a312aaae5sm1392629iop.36.2023.02.10.08.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 08:00:13 -0800 (PST)
Message-ID: <56ef99e4-f9de-0634-ce53-3bc2f1fa6665@kernel.dk>
Date:   Fri, 10 Feb 2023 09:00:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca>
 <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
 <13293926.uLZWGnKmhe@x2> <6939adfb-ce2c-1911-19ee-af32f7d9a5ca@kernel.dk>
 <CAHC9VhTGmGJ81M2CZWsTf1kNf8XNz2WsYFAP=5VAVSUfUiu1yQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhTGmGJ81M2CZWsTf1kNf8XNz2WsYFAP=5VAVSUfUiu1yQ@mail.gmail.com>
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

On 2/10/23 8:39?AM, Paul Moore wrote:
> On Thu, Feb 9, 2023 at 7:15 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/9/23 3:54?PM, Steve Grubb wrote:
>>> On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
>>>> On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>>>>> On 2023-02-01 16:18, Paul Moore wrote:
>>>>>> On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com>
>>> wrote:
>>>>>>> fadvise and madvise both provide hints for caching or access pattern
>>>>>>> for file and memory respectively.  Skip them.
>>>>>>
>>>>>> You forgot to update the first sentence in the commit description :/
>>>>>
>>>>> I didn't forget.  I updated that sentence to reflect the fact that the
>>>>> two should be treated similarly rather than differently.
>>>>
>>>> Ooookay.  Can we at least agree that the commit description should be
>>>> rephrased to make it clear that the patch only adjusts madvise?  Right
>>>> now I read the commit description and it sounds like you are adjusting
>>>> the behavior for both fadvise and madvise in this patch, which is not
>>>> true.
>>>>
>>>>>> I'm still looking for some type of statement that you've done some
>>>>>> homework on the IORING_OP_MADVISE case to ensure that it doesn't end
>>>>>> up calling into the LSM, see my previous emails on this.  I need more
>>>>>> than "Steve told me to do this".
>>>>>>
>>>>>> I basically just want to see that some care and thought has gone into
>>>>>> this patch to verify it is correct and good.
>>>>>
>>>>> Steve suggested I look into a number of iouring ops.  I looked at the
>>>>> description code and agreed that it wasn't necessary to audit madvise.
>>>>> The rationale for fadvise was detemined to have been conflated with
>>>>> fallocate and subsequently dropped.  Steve also suggested a number of
>>>>> others and after investigation I decided that their current state was
>>>>> correct.  *getxattr you've advised against, so it was dropped.  It
>>>>> appears fewer modifications were necessary than originally suspected.
>>>>
>>>> My concern is that three of the four changes you initially proposed
>>>> were rejected, which gives me pause about the fourth.  You mention
>>>> that based on your reading of madvise's description you feel auditing
>>>> isn't necessary - and you may be right - but based on our experience
>>>> so far with this patchset I would like to hear that you have properly
>>>> investigated all of the madvise code paths, and I would like that in
>>>> the commit description.
>>>
>>> I think you're being unnecessarily hard on this. Yes, the commit message
>>> might be touched up. But madvise is advisory in nature. It is not security
>>> relevant. And a grep through the security directory doesn't turn up any
>>> hooks.
>>
>> Agree, it's getting a bit anal... FWIW, patch looks fine to me.
> 
> Call it whatever you want, but the details are often important at this
> level of code, and when I see a patch author pushing back on verifying
> that their patch is correct it makes me very skeptical.

Maybe it isn't intended, but the replies have generally had a pretty
condescending tone to them. That's not the best way to engage folks, and
may very well be why people just kind of give up on it. Nobody likes
debating one-liners forever, particularly not if it isn't inviting.

> I really would have preferred that you held off from merging this
> until this was resolved and ACK'd ... oh well.

It's still top of tree. If you want to ack it, let me know and I'll add
it. If you want to nak it, give me something concrete to work off of.

-- 
Jens Axboe

