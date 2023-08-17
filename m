Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA34977EEAD
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 03:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347493AbjHQBYE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 21:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347490AbjHQBXc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 21:23:32 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320742723
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 18:23:31 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-5657659a8a1so895533a12.1
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 18:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692235410; x=1692840210;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KSFMIKhRz8y1LlVzN4JBlWQlvqVf2idLZ8u0F6cnYUU=;
        b=gUoyYERSC36L4OWS0q5oV2c+ccT1RLS0gROqEwlAZPupSl2eFCUV4arQuYIEI12uY/
         +jLZvPdh4KcgWqK1v7DfSF+5XT4PTN3tgfOzxKjtWL8G1MjiRPJblHYsJdptMX2EBXnQ
         k+B3yE6qSkNwqlq9+Q8ulsX+N2w374JxD8NW2qDlQOnWOgefs9hc68pin7cwZXB3OrY9
         4/x5Iwmw7BA81x3V2HEKbyv6/4nHrkjB4WbuWHchdVaQW0Ligb+4C3SaXtdQNdTj/giR
         Vrpexu6pT2+Kn9MGPdmeBnHfes8zxvRVVrw+DRyxGhoZera+u4XqpQ1vUorUu9nhXTr1
         EaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692235410; x=1692840210;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSFMIKhRz8y1LlVzN4JBlWQlvqVf2idLZ8u0F6cnYUU=;
        b=N4ztilNx7ehWlqqsOPCgvUgFNZFD6tW+JKPckc1zzRaRqBT/KsO/5xtg6AKdKd/hwE
         hy0k/tpAVvDsS9WpblDmqy9erLozg2c+xE3bhUyYYSBnMMQjVf8Ha+fDtycMpwXBzcGA
         qAOPrOYYAyfcJWmRLQuvniR4nmg34Otp2e8R/w9vJewgmNRw13Zy2sq4wTneb+u1uYne
         VG4k1mxanHQClg5djRVJzGjEjfF/CJtb44sb/VUCP2tiCYy0dIUEeYv9D0JPsYS4XJw4
         YXGB8u3pRAXyQ9jFaV201UzmfdbsT2m8QEZcWbKIgbcRr8wFk3ucAifjOhfckLnnfsp3
         oOmQ==
X-Gm-Message-State: AOJu0YxtyvLcghuZwZ3vMg3XoPy2q2wxaz0bJ9UtqDnh8UQvIZcQXPHl
        kSW40rN5odTMa1G+G4TBijGyPVKOErBOjtnNQoE=
X-Google-Smtp-Source: AGHT+IGaocOGI4L8ILTJCB0o1yEm6B9ZDaPg0s0JuiYtCAKrJwtnlnMNA9N3EiydHlS3UzO+6QXbGA==
X-Received: by 2002:a17:90a:3d0d:b0:269:60ed:d493 with SMTP id h13-20020a17090a3d0d00b0026960edd493mr3097421pjc.4.1692235410586;
        Wed, 16 Aug 2023 18:23:30 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 9-20020a17090a030900b0026b420ae167sm391727pje.17.2023.08.16.18.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 18:23:30 -0700 (PDT)
Message-ID: <ee0b1a74-67e3-4b71-bccf-8ecc5fa3819a@kernel.dk>
Date:   Wed, 16 Aug 2023 19:23:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Content-Language: en-US
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
 <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
 <db15e7a6-6c65-494f-9069-a5d1a72f9c45@gmx.com>
 <d67e7236-a9e4-421c-b5bf-a4b25748cac2@kernel.dk>
 <2b3d6880-59c7-4483-9e08-3b10ac936d04@gmx.com>
 <d779f1aa-f6ef-43c6-bfcc-35a6870a639a@kernel.dk>
 <e7bcab0b-d894-40e8-b65c-caa846149608@gmx.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e7bcab0b-d894-40e8-b65c-caa846149608@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 7:19 PM, Qu Wenruo wrote:
> On 2023/8/17 09:12, Jens Axboe wrote:
>> On 8/16/23 7:05 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2023/8/17 06:28, Jens Axboe wrote:
>>> [...]
>>>>
>>>>>> 2) What's the .config you are using?
>>>>>
>>>>> Pretty common config, no heavy debug options (KASAN etc).
>>>>
>>>> Please just send the .config, I'd rather not have to guess. Things like
>>>> preempt etc may make a difference in reproducing this.
>>>
>>> Sure, please see the attached config.gz
>>
>> Thanks
>>
>>>> And just to be sure, this is not mixing dio and buffered, right?
>>>
>>> I'd say it's mixing, there are dwrite() and writev() for the same file,
>>> but at least not overlapping using this particular seed, nor they are
>>> concurrent (all inside the same process sequentially).
>>>
>>> But considering if only uring_write is disabled, then no more reproduce,
>>> thus there must be some untested btrfs path triggered by uring_write.
>>
>> That would be one conclusion, another would be that timing is just
>> different and that triggers and issue. Or it could of course be a bug in
>> io_uring, perhaps a short write that gets retried or something like
>> that. I've run the tests for hours here and don't hit anything, I've
>> pulled in the for-next branch for btrfs and see if that'll make a
>> difference. I'll check your .config too.
> 
> Just to mention, the problem itself was pretty hard to hit before if
> using any debug kernel configs.

The kernels I'm testing with don't have any debug options enabled,
outside of the basic cheap stuff. I do notice you have all btrfs debug
stuff enabled, I'll try and do that too.

> Not sure why but later I switched both my CPUs (from a desktop i7-13700K
> but with limited 160W power, to a laptop 7940HS), dropping all heavy
> debug kernel configs, then it's 100% reproducible here.
> 
> So I guess a faster CPU is also one factor?

I've run this on kvm on an apple m1 max, no luck there. Ran it on a
7950X, no luck there. Fiddling config options on the 7950 and booting up
the 7763 two socket box. Both that and the 7950 are using gen4 optane,
should be plenty beefy. But if it's timing related, well...

>> Might not be a bad idea to have the writes contain known data, and when
>> you hit the failure to verify the csum, dump the data where the csum
>> says it's wrong and figure out at what offset, what content, etc it is?
>> If that can get correlated to the log of what happened, that might shed
>> some light on this.
>>
> Thanks for the advice, would definitely try this method, would keep you
> updated when I found something valuable.

If I can't reproduce this, then this seems like the best way forward
indeed.

-- 
Jens Axboe

