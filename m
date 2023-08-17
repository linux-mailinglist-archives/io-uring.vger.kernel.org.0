Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5122977EEC0
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 03:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347539AbjHQBdM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 21:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347535AbjHQBcr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 21:32:47 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4602723
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 18:32:45 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so896855a12.0
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 18:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692235965; x=1692840765;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0gAl9P1o/DTp5TCTEJqglwJxlkIKx/FiX401CNiZbSQ=;
        b=D598J2a9kdQy6Eqy1UKf+cahKI9U9UAufvU5O7VDBRi29nZyn+9fbSoml8/Qnh/qCw
         bZ08gBpeX1aa9YsRHjOQPdVuXGtRvvkRha62+dIDwKyE3QwjNgIXMHFcpCBkJd/vsSe1
         RE4pDVXj3eOIdjlvCmfs2RbCw9glZ9lTxlVgoLIZra04/ArglS0BErfIroUFz7vlkA1t
         TQK3hSCVLg+ZdEBF8jztrWbGdbajq4mn/pC6P5/bMwzyC0oQl6ic+tYTqA7TAVn/Zt6J
         PMwEt4Bmeq1YTvbwht6X+icX4+Ht0b9Pq92pukAyRxORRRfK+q1OFilnTWJhjynojI+T
         XdJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692235965; x=1692840765;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0gAl9P1o/DTp5TCTEJqglwJxlkIKx/FiX401CNiZbSQ=;
        b=dD0DR23ZErq0XaAMbjU9X5F51wlcq50Ru/HvL6pnLx/vUtxpnCG3qDprUiMB/87kRG
         Nt/6s8dQMzPvdEBF/Y94OPAZD2AN1HHY0A2Mv8Dr+xRfKjTZgKxITInf3GC2A9OJScfo
         FMJdCLW/3DdtMHIi4zVXl1F9U3PJ0sRRMimlnRXDUEdgmcCn+1wQdViQx5ufYftSulTp
         S5VcHbN1uANMuRRV+0ci/e8n/PefU5nI01kYaxXNTsoQr/t/CuS9QepoJRrr0js99kUw
         BkfmC3EGAEv28aNbhj52vM+g0rRk2XI1wNbb6qilaKfeYpV026f+W3n9NQ+73e0vEY1M
         3X9A==
X-Gm-Message-State: AOJu0YyW0JZuDT1pQ1nqYJaYAOmharJnpBXTlJM9ovj4qdit5GqVssyA
        95ST2/RB89AGCUn4lvGLHDjm7XNosBoQ21bcehk=
X-Google-Smtp-Source: AGHT+IFI8gDgBQNOMuGQHfTeVER1lHnPZaQPhJ6wU0jgLYyxcmethRjhabXoHW9Pj4mJQ8d1bwtRWw==
X-Received: by 2002:a17:902:c411:b0:1b8:35fa:cdcc with SMTP id k17-20020a170902c41100b001b835facdccmr4133171plk.5.1692235965443;
        Wed, 16 Aug 2023 18:32:45 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902eb0400b001bb8be10a84sm7848442plb.304.2023.08.16.18.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 18:32:44 -0700 (PDT)
Message-ID: <b60cf9c7-b26d-4871-a3c9-08e030b68df4@kernel.dk>
Date:   Wed, 16 Aug 2023 19:32:43 -0600
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
 <ee0b1a74-67e3-4b71-bccf-8ecc5fa3819a@kernel.dk>
 <34e2030c-5247-4c1f-bd18-a0008a660746@gmx.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <34e2030c-5247-4c1f-bd18-a0008a660746@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 7:31 PM, Qu Wenruo wrote:
> 
> 
> On 2023/8/17 09:23, Jens Axboe wrote:
>> On 8/16/23 7:19 PM, Qu Wenruo wrote:
>>> On 2023/8/17 09:12, Jens Axboe wrote:
>>>> On 8/16/23 7:05 PM, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2023/8/17 06:28, Jens Axboe wrote:
>>>>> [...]
>>>>>>
>>>>>>>> 2) What's the .config you are using?
>>>>>>>
>>>>>>> Pretty common config, no heavy debug options (KASAN etc).
>>>>>>
>>>>>> Please just send the .config, I'd rather not have to guess. Things like
>>>>>> preempt etc may make a difference in reproducing this.
>>>>>
>>>>> Sure, please see the attached config.gz
>>>>
>>>> Thanks
>>>>
>>>>>> And just to be sure, this is not mixing dio and buffered, right?
>>>>>
>>>>> I'd say it's mixing, there are dwrite() and writev() for the same file,
>>>>> but at least not overlapping using this particular seed, nor they are
>>>>> concurrent (all inside the same process sequentially).
>>>>>
>>>>> But considering if only uring_write is disabled, then no more reproduce,
>>>>> thus there must be some untested btrfs path triggered by uring_write.
>>>>
>>>> That would be one conclusion, another would be that timing is just
>>>> different and that triggers and issue. Or it could of course be a bug in
>>>> io_uring, perhaps a short write that gets retried or something like
>>>> that. I've run the tests for hours here and don't hit anything, I've
>>>> pulled in the for-next branch for btrfs and see if that'll make a
>>>> difference. I'll check your .config too.
>>>
>>> Just to mention, the problem itself was pretty hard to hit before if
>>> using any debug kernel configs.
>>
>> The kernels I'm testing with don't have any debug options enabled,
>> outside of the basic cheap stuff. I do notice you have all btrfs debug
>> stuff enabled, I'll try and do that too.
>>
>>> Not sure why but later I switched both my CPUs (from a desktop i7-13700K
>>> but with limited 160W power, to a laptop 7940HS), dropping all heavy
>>> debug kernel configs, then it's 100% reproducible here.
>>>
>>> So I guess a faster CPU is also one factor?
>>
>> I've run this on kvm on an apple m1 max, no luck there. Ran it on a
>> 7950X, no luck there. Fiddling config options on the 7950 and booting up
>> the 7763 two socket box. Both that and the 7950 are using gen4 optane,
>> should be plenty beefy. But if it's timing related, well...
> 
> Just to mention, the following progs are involved:
> 
> - btrfs-progs v6.3.3
>   In theory anything newer than 5.15 should be fine, it's some default
>   settings change.

axboe@r7525 ~> apt show btrfs-progs
Package: btrfs-progs
Version: 6.3.2-1

is what I have.

> - fsstress from xfstests project
>   Thus it's not the one directly from LTP

That's what I'm using too.

> Hopes this could help you to reproduce the bug.

So far, not really :-)

-- 
Jens Axboe

