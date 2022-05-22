Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E5A530045
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 04:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiEVCT5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 May 2022 22:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiEVCT4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 May 2022 22:19:56 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298EB43EC0
        for <io-uring@vger.kernel.org>; Sat, 21 May 2022 19:19:55 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o13-20020a17090a9f8d00b001df3fc52ea7so14553027pjp.3
        for <io-uring@vger.kernel.org>; Sat, 21 May 2022 19:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=yNGECf7cpPXgM31FBYi/Q+Mk5ajHugGFdMlr8H02ns4=;
        b=wEL7dYw2G/uVEpR1E1YAzkeLX/nV1AlB6vBxQCYEQmHrY4Zh19I62063M5Q3dn8qZi
         rJMmff+Nbt0/AouoCgRxuXp+xenG1W7NPXj6M9S3MyP/6xoq6O3PudHT/eSyG/zbIAyg
         NKQ+JDjC2a/Gf6ejY9R7WPj7KdsOHpPC50PE099iGDNnTaBibb0T10b833Li1e3xvj7a
         Cnfg3DNQpehKBr77FjGZ8dlMgP+DCkt1RWgXqolXdAt2+0E9pUASJxETVDEUth38CuME
         nL9L3E4WlR4viLMp8koS6ksaZWXzB2jw9QJQCJOPIrX6JEJj2Oir632qGsMCgfJvw0bL
         fi3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=yNGECf7cpPXgM31FBYi/Q+Mk5ajHugGFdMlr8H02ns4=;
        b=NR13bQqOhMS8cNhD2GOnn5ezEQoANvHWUJjanHhH2iZT5FF3gdzyj7c9y8JOCNCa4j
         ShBY5F8qt4HUjYucrWI9cZq3qonY8N5UlCVfXw74aeYXLvTNHpvN8Yu/rf8udI88uO9m
         guBv+k98gXvkDMQhi++nTJaMlUkgO1ZAbb87QHKggKtw3q8nP/XkVEw5lE4+qzr49ydc
         GPIhLkdRP2Iy6lH56NWu4SdPuySj+r7TKPhcl+2a7u3P4SHtR5nrOj79gRuyvFtp5YwV
         0Ay2+SCptDuZvO+6mWL9IhfbnMKqrmoDfBCoafLua/ONbkdRIyP0sDsi+Rbmi4PaluJ0
         GLuQ==
X-Gm-Message-State: AOAM532+eByqerXlmerkCP+f8ZpD6HUgajXhgbKywPw8uzECdNq3ihVo
        xV1LNo/FBeMQDlJqJWLD7gxjPQ==
X-Google-Smtp-Source: ABdhPJyDQosH8GbPek/KjZJkAztrhBfNRKXvvkrZD8Pw0C4cTc8LAhET3Idv/O9c4p/dpPqCg/Y0MQ==
X-Received: by 2002:a17:903:246:b0:153:87f0:a93e with SMTP id j6-20020a170903024600b0015387f0a93emr16668356plh.171.1653185994006;
        Sat, 21 May 2022 19:19:54 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x24-20020a637c18000000b003f9e80538d0sm2075611pgc.17.2022.05.21.19.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 May 2022 19:19:53 -0700 (PDT)
Message-ID: <84e5e231-7c33-ad0f-fdd5-2d8c1052aa00@kernel.dk>
Date:   Sat, 21 May 2022 20:19:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 00/13] rename & split tests
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Dave Chinner <david@fromorbit.com>,
        Christian Brauner <brauner@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>, io-uring@vger.kernel.org
References: <20220512165250.450989-1-brauner@kernel.org>
 <20220521231350.GY2306852@dread.disaster.area>
 <f77e867f-ed7d-85f7-f1e4-b9dc10a6d23b@kernel.dk>
In-Reply-To: <f77e867f-ed7d-85f7-f1e4-b9dc10a6d23b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/21/22 7:07 PM, Jens Axboe wrote:
> On 5/21/22 5:13 PM, Dave Chinner wrote:
>> [cc io_uring]
>>
>> On Thu, May 12, 2022 at 06:52:37PM +0200, Christian Brauner wrote:
>>> From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
>>>
>>> Hey everyone,
>>>
>>> Please note that this patch series contains patches that will be
>>> rejected by the fstests mailing list because of the amount of changes
>>> they contain. So tools like b4 will not be able to find the whole patch
>>> series on a mailing list. In case it's helpful I've added the
>>> "fstests.vfstest.for-next" tag which can be pulled. Otherwise it's
>>> possible to simply use the patch series as it appears in your inbox.
>>>
>>> All vfstests pass:
>>
>> [...]
>>
>>> #### xfs ####
>>> ubuntu@imp1-vm:~/src/git/xfstests$ sudo ./check -g idmapped
>>> FSTYP         -- xfs (debug)
>>> PLATFORM      -- Linux/x86_64 imp1-vm 5.18.0-rc4-fs-mnt-hold-writers-8a2e2350494f #107 SMP PREEMPT_DYNAMIC Mon May 9 12:12:34 UTC 2022
>>> MKFS_OPTIONS  -- -f /dev/sda4
>>> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
>>>
>>> generic/633 58s ...  58s
>>> generic/644 62s ...  60s
>>> generic/645 161s ...  161s
>>> generic/656 62s ...  63s
>>> xfs/152 133s ...  133s
>>> xfs/153 94s ...  92s
>>> Ran: generic/633 generic/644 generic/645 generic/656 xfs/152 xfs/153
>>> Passed all 6 tests
>>
>> I'm not sure if it's this series that has introduced a test bug or
>> triggered a latent issue in the kernel, but I've started seeing
>> generic/633 throw audit subsystem warnings on a single test machine
>> as of late Friday:
>>
>> [ 7285.015888] WARNING: CPU: 3 PID: 2147118 at kernel/auditsc.c:2035 __audit_syscall_entry+0x113/0x140
> 
> Does your kernel have this commit?
> 
> commit 69e9cd66ae1392437234a63a3a1d60b6655f92ef
> Author: Julian Orth <ju.orth@gmail.com>
> Date:   Tue May 17 12:32:53 2022 +0200
> 
>     audit,io_uring,io-wq: call __audit_uring_exit for dummy contexts

I could not reproduce either with or without your patch when I finally
got that test going and figure out how to turn on audit and get it
enabled. I don't run with that.

But looking at your line numbers, I think you're missing the above
commit. The WARN_ON_ONCE() matches up with it NOT being applied, which
is most likely why it triggers for you. It's in Linus's tree, but not in
-rc7.

-- 
Jens Axboe

