Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C009675491D
	for <lists+io-uring@lfdr.de>; Sat, 15 Jul 2023 16:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjGOOG3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Jul 2023 10:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjGOOG2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Jul 2023 10:06:28 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DCA1FDB
        for <io-uring@vger.kernel.org>; Sat, 15 Jul 2023 07:06:27 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b9d9cbcc70so3999225ad.0
        for <io-uring@vger.kernel.org>; Sat, 15 Jul 2023 07:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689429987; x=1690034787;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NgkcBe+eB7Csc+Gi/e5UdYxcks5oWoeS5M2PXyiSPV4=;
        b=gp6+jueB2lVhLbMiQMzs9xH/n17AiwvDryMVEdZMXMjZ1g/x8P03LSRxqWZepQ+GN9
         AMxmFRQ/pgjlI5lTXHi14zhgU/tzUks6AzU9WWVXUbpCCzq6755r5Yev08oaVVNGKsrs
         dmuzbz1KOzSGPMd936eDyeLB19mWm8ROOvX2krl+GZK0yJHIne56lkOVf6eYqRExVBz+
         zCWpy5I/7PYqnsfCxdq+hPi2hKRav6AF7/iO8rDdQnpPIFrTzqU+tvM9L5TQyqF433ef
         tzhm2Ew05gnmofai7TuPYlaRuL8RqFY34IHbgkGAgoqEap2jk6FxV2PflrwdkUPnpU+I
         SKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689429987; x=1690034787;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NgkcBe+eB7Csc+Gi/e5UdYxcks5oWoeS5M2PXyiSPV4=;
        b=lQLqYuHiLwa8yRoNM3mGdYWwnVYYx8zedC86CDhkGM0aM0Ltnzi4XTg7m391gIPJg4
         pGFHCdTKornFKd/jcMmlnWn/PwdDJgda92w/6WmHfdkQuhg5WiEFzc8wyL5wF0r9ErUq
         zkVJ9Rt5sxk7tlsO9yV0IlIikzFSgZalfBOQIbpToXcD18FMBCsv9SdCPJByIfN45VtG
         oFfd1tFysGKmrT2vLwYabAKHiC9bZ2e+XcNLxX+fvBM9b7dFN5E2xkiObl6nAqzmELf+
         682N178BvTMWSK7BM3yhc7I3QAA2Gp5c1kZU8D1WqmA5DKEtb3h4GbxRTEgSn5rSMmY2
         8iEA==
X-Gm-Message-State: ABy/qLY0hlDzUbhG3jzBCH+8nlXkrYoU7gabYgVdxblHqX8Rla2qGWmd
        k8C2sCZlHo6hMN/lqQ1d3MtN3A==
X-Google-Smtp-Source: APBJJlEZRufq+8Gb5ptLTTr1Lhc6Tb3zHiF+nQYCYATu2/FAlgSyhD/d+cLHmvC4F8bTUoSVfwxDnw==
X-Received: by 2002:a17:902:e84d:b0:1b3:d4bb:3515 with SMTP id t13-20020a170902e84d00b001b3d4bb3515mr2592580plg.0.1689429986748;
        Sat, 15 Jul 2023 07:06:26 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902788100b001b80760fd04sm9522484pll.112.2023.07.15.07.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jul 2023 07:06:25 -0700 (PDT)
Message-ID: <509f35fc-72dc-8676-4e3a-6bbc8d7eefb4@kernel.dk>
Date:   Sat, 15 Jul 2023 08:06:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-6-axboe@kernel.dk>
 <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
 <048cfbce-5238-2580-2d53-2ca740e72d79@kernel.dk>
 <bbc5f3cf-99f8-0695-1367-979301c64ecb@kernel.dk>
 <20230714-grummeln-sitzgelegenheit-1157c2feac71@brauner>
 <d53ed71a-3f57-4c5e-9117-82535aae7855@app.fastmail.com>
 <ca82bd8b-5868-8fbb-6701-061220a1ff97@kernel.dk>
 <57926544-3936-410f-ae0e-6eff266ea59c@app.fastmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <57926544-3936-410f-ae0e-6eff266ea59c@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/23 1:12 AM, Arnd Bergmann wrote:
> On Fri, Jul 14, 2023, at 22:14, Jens Axboe wrote:
>> On 7/14/23 12:33?PM, Arnd Bergmann wrote:
>>> On Fri, Jul 14, 2023, at 17:47, Christian Brauner wrote:
>>>> On Tue, Jul 11, 2023 at 04:18:13PM -0600, Jens Axboe wrote:
>>>>>>> Does this require argument conversion for compat tasks?
>>>>>>>
>>>>>>> Even without the rusage argument, I think the siginfo
>>>>>>> remains incompatible with 32-bit tasks, unfortunately.
>>>>>>
>>>>>> Hmm yes good point, if compat_siginfo and siginfo are different, then it
>>>>>> does need handling for that. Would be a trivial addition, I'll make that
>>>>>> change. Thanks Arnd!
>>>>>
>>>>> Should be fixed in the current version:
>>>>>
>>>>> https://git.kernel.dk/cgit/linux/commit/?h=io_uring-waitid&id=08f3dc9b7cedbd20c0f215f25c9a7814c6c601cc
>>>>
>>>> In kernel/signal.c in pidfd_send_signal() we have
>>>> copy_siginfo_from_user_any() it seems that a similar version
>>>> copy_siginfo_to_user_any() might be something to consider. We do have
>>>> copy_siginfo_to_user32() and copy_siginfo_to_user(). But I may lack
>>>> context why this wouldn't work here.
>>>
>>> We could add a copy_siginfo_to_user_any(), but I think open-coding
>>> it is easier here, since the in_compat_syscall() check does not
>>> work inside of the io_uring kernel thread, it has to be
>>> "if (req->ctx->compat)" in order to match the wordsize of the task
>>> that started the request.
>>
>> Yeah, unifying this stuff did cross my mind when adding another one.
>> Which I think could still be done, you'd just need to pass in a 'compat'
>> parameter similar to how it's done for iovec importing.
>>
>> But if it's ok with everybody I'd rather do that as a cleanup post this.
> 
> Sure, keeping that separate seem best.
> 
> Looking at what copy_siginfo_from_user_any() actually does, I don't
> even think it's worth adapting copy_siginfo_to_user_any() for io_uring,
> since it's already just a trivial wrapper, and adding another
> argument would add more complexity overall than it saves.

Yeah, took a look too this morning, and not sure there's much to reduce
here that would make it cleaner. I'm going to send out a v2 with this
unchanged, holler if people disagree.

-- 
Jens Axboe


