Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D2C75495C
	for <lists+io-uring@lfdr.de>; Sat, 15 Jul 2023 16:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjGOOfG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Jul 2023 10:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjGOOfF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Jul 2023 10:35:05 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6892729
        for <io-uring@vger.kernel.org>; Sat, 15 Jul 2023 07:34:58 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so378503a12.0
        for <io-uring@vger.kernel.org>; Sat, 15 Jul 2023 07:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689431697; x=1690036497;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9FX8SV9VaQXcPyY+22DvDJg3CIR8jtQiCFfi0aEKoJE=;
        b=heJMETG6CVuiszjwnd0/PWq2IK7DVvt6kek88pc1PXNv7DwAdTcS6ChJk2wfee/qOV
         lDcspMtfFFXFsNLofIZt1K9j0GRH0h+26JsBrbNde3zHKiz5w2Vv3e5rouVOOAMVqCJ1
         du9s90MkKIDwbhxWC+QMIiJoNWgEpQyVk1DVDttNJu8AQFJ5m0nPtGuEGx/9LYMq91/T
         BHegd5wiVHEEhAa0ntY5dmIygvDgCtrFFdQ6CRH+x+qBCI2DhZU1BHpkgc+VgMBptrm8
         EVHE1xUz97SQ6fPBQokLRwam465dHiHPFaxqRpcdRlJ9IabHnf8ixYKOfEuqEgKz/bVq
         wrCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689431697; x=1690036497;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9FX8SV9VaQXcPyY+22DvDJg3CIR8jtQiCFfi0aEKoJE=;
        b=koTi6FgVXyKI6LEiToGfnAcBqehyP0Ntmekv3KltE0TOXlZeNrUJP4OihU7Ubs7Tkn
         t0D20WVZ5r/6vQfQZARq4GCTCuMqTh3EDgSQvyp9VemhOZW0/BXjgqjNQHxDePxD6LSc
         MJDhFJkR+nsLA7KCiC9R2h47FXXq3M6Fp/MUDuqhDIxBsnQEbXY5aSeFEDuvWtVNqQrm
         snX6aqaT59HvTH+iVqJmcN8t82OMjbn3GeIjDpgWhsuNk5LiZKXlfKXacpXpK+5JoiXf
         d1rtZvQcsNvqxP8gSq1jauld/BQz27ZWyhtrl66AZ1/tSyLiTcF+5z18UxV8qeXt9UiW
         aD6g==
X-Gm-Message-State: ABy/qLYWS8G+Br2f6UzSTCShWNeYvSSabz8x/pMyTYNJftDkkmYVgR32
        j4AkMLrJ9tyRREQxBiHwUtOjkg==
X-Google-Smtp-Source: APBJJlFcRJTwrw4dvvCU5WHQNMKufzl7kZMJMiBSMpT/n3G0upgFy6Rzy2WOFNpv/T4P/Bai6S7lIQ==
X-Received: by 2002:a17:903:32cf:b0:1b8:a469:53d8 with SMTP id i15-20020a17090332cf00b001b8a46953d8mr9947451plr.0.1689431697572;
        Sat, 15 Jul 2023 07:34:57 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c1::1028? ([2620:10d:c090:400::5:5cbd])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902748500b001a95f632340sm9560570pll.46.2023.07.15.07.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jul 2023 07:34:56 -0700 (PDT)
Message-ID: <93218e35-62a5-f081-3598-c06f60bd16d5@kernel.dk>
Date:   Sat, 15 Jul 2023 08:34:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
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
 <509f35fc-72dc-8676-4e3a-6bbc8d7eefb4@kernel.dk>
In-Reply-To: <509f35fc-72dc-8676-4e3a-6bbc8d7eefb4@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/23 8:06?AM, Jens Axboe wrote:
> On 7/15/23 1:12?AM, Arnd Bergmann wrote:
>> On Fri, Jul 14, 2023, at 22:14, Jens Axboe wrote:
>>> On 7/14/23 12:33?PM, Arnd Bergmann wrote:
>>>> On Fri, Jul 14, 2023, at 17:47, Christian Brauner wrote:
>>>>> On Tue, Jul 11, 2023 at 04:18:13PM -0600, Jens Axboe wrote:
>>>>>>>> Does this require argument conversion for compat tasks?
>>>>>>>>
>>>>>>>> Even without the rusage argument, I think the siginfo
>>>>>>>> remains incompatible with 32-bit tasks, unfortunately.
>>>>>>>
>>>>>>> Hmm yes good point, if compat_siginfo and siginfo are different, then it
>>>>>>> does need handling for that. Would be a trivial addition, I'll make that
>>>>>>> change. Thanks Arnd!
>>>>>>
>>>>>> Should be fixed in the current version:
>>>>>>
>>>>>> https://git.kernel.dk/cgit/linux/commit/?h=io_uring-waitid&id=08f3dc9b7cedbd20c0f215f25c9a7814c6c601cc
>>>>>
>>>>> In kernel/signal.c in pidfd_send_signal() we have
>>>>> copy_siginfo_from_user_any() it seems that a similar version
>>>>> copy_siginfo_to_user_any() might be something to consider. We do have
>>>>> copy_siginfo_to_user32() and copy_siginfo_to_user(). But I may lack
>>>>> context why this wouldn't work here.
>>>>
>>>> We could add a copy_siginfo_to_user_any(), but I think open-coding
>>>> it is easier here, since the in_compat_syscall() check does not
>>>> work inside of the io_uring kernel thread, it has to be
>>>> "if (req->ctx->compat)" in order to match the wordsize of the task
>>>> that started the request.
>>>
>>> Yeah, unifying this stuff did cross my mind when adding another one.
>>> Which I think could still be done, you'd just need to pass in a 'compat'
>>> parameter similar to how it's done for iovec importing.
>>>
>>> But if it's ok with everybody I'd rather do that as a cleanup post this.
>>
>> Sure, keeping that separate seem best.
>>
>> Looking at what copy_siginfo_from_user_any() actually does, I don't
>> even think it's worth adapting copy_siginfo_to_user_any() for io_uring,
>> since it's already just a trivial wrapper, and adding another
>> argument would add more complexity overall than it saves.
> 
> Yeah, took a look too this morning, and not sure there's much to reduce
> here that would make it cleaner. I'm going to send out a v2 with this
> unchanged, holler if people disagree.

Looking over changes, none have been made so far. So I guess a v2 can
wait a bit. The branch was rebased to add Christian's acked-bys for some
of the patches, and since a branch it was based on (io_uring-futex) got
rebased to accommodate PeterZ's changes.

-- 
Jens Axboe

