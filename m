Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52845306EC
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 02:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiEWA5J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 20:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiEWA5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 20:57:08 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159432EA34
        for <io-uring@vger.kernel.org>; Sun, 22 May 2022 17:57:07 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w200so12301177pfc.10
        for <io-uring@vger.kernel.org>; Sun, 22 May 2022 17:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vDCEsJ/WqthTybWOI/qPzCzf+m8Hs9NW8GCyLPvsqlA=;
        b=sL4YsPCS622CbXMUX2MZhnEMA2P3NvsaDiqoMBRdugV7rr6OC8BIibf4Q6osNJvs9Y
         /Xv9ErmckKPILz5GPectKN2VGZEQ6gtn3dsYxLwq1K5dNLRFrkj5HfSboFzYLfyx4SIX
         2zqO/VqLOUdkjCd8VBnXuBuScWV6/8Bs2FBwcxwUJgrnN3tVkmBVP81sWQ+4Q+XCXP2R
         WdYZtWQhamQ5v4DihS4w7VXAGujcTnFtIzYRogjWyFS/R70tsDUbGY+V2omWt1rnZjcI
         zBdZZvVTzEh6D+E5LfwzqELJddlXLD7b7Mg9aG5QU73JndkfVZmNIBSgjDOm3k0oeDv4
         ctuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vDCEsJ/WqthTybWOI/qPzCzf+m8Hs9NW8GCyLPvsqlA=;
        b=byl03DFXw75NJ0zp4KC8b4TE2MBP7mReqXWYJ2N0dArIYCiLbqOvwNeha42BSiT3+r
         uT+gVBJ1pcww0d+9JieqodXRWNmqDk3uQrHnc0mUUIMrkZlvKw8ao7qRrjS9gkbiwouw
         aXitGHOKTWSQdluCKK1jPHC9I/efoU6xnpdrlGYZHtg41AxHJiqu33ZwSGFCadneIdHl
         cPLIf35tCG/kZDvStRRHBvU6WuJ7OwIULiZdykheWZMQIY65vtzWq6AhVk3itqiztefl
         LyJ9KYdwzldlrNgrWzh3vJnA5QHGzU9M+uBsn+5IHrnwUwqHSgJ01pnTSq87dCHVSzLr
         O1bQ==
X-Gm-Message-State: AOAM530nHDqihLdmm7vr6umeVhsfVHpjTs33Qt5Sj6mmkkpdP7GjIY/4
        TQ/nAaUhJ6EawjxCnWKr4p0nOA==
X-Google-Smtp-Source: ABdhPJxPb5y6749opIKhYoUHq1Gxb60o9WsLxTWe+nDqBTMLFG9jJL2V0wDnXLdDOWJ5pTPYcl6cmw==
X-Received: by 2002:aa7:8895:0:b0:518:9fa0:7da with SMTP id z21-20020aa78895000000b005189fa007damr2948256pfe.48.1653267426326;
        Sun, 22 May 2022 17:57:06 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f11-20020a17090274cb00b0015e8d4eb26esm3687362plt.184.2022.05.22.17.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 17:57:05 -0700 (PDT)
Message-ID: <767778c5-ac0e-e798-38e0-199f54853cc6@kernel.dk>
Date:   Sun, 22 May 2022 18:57:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 00/13] rename & split tests
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>, io-uring@vger.kernel.org
References: <20220512165250.450989-1-brauner@kernel.org>
 <20220521231350.GY2306852@dread.disaster.area>
 <f77e867f-ed7d-85f7-f1e4-b9dc10a6d23b@kernel.dk>
 <84e5e231-7c33-ad0f-fdd5-2d8c1052aa00@kernel.dk>
 <20220523001350.GB2306852@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220523001350.GB2306852@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/22/22 6:13 PM, Dave Chinner wrote:
> On Sat, May 21, 2022 at 08:19:51PM -0600, Jens Axboe wrote:
>> On 5/21/22 7:07 PM, Jens Axboe wrote:
>>> On 5/21/22 5:13 PM, Dave Chinner wrote:
>>>> [cc io_uring]
>>>>
>>>> On Thu, May 12, 2022 at 06:52:37PM +0200, Christian Brauner wrote:
>>>>> From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
>>>>>
>>>>> Hey everyone,
>>>>>
>>>>> Please note that this patch series contains patches that will be
>>>>> rejected by the fstests mailing list because of the amount of changes
>>>>> they contain. So tools like b4 will not be able to find the whole patch
>>>>> series on a mailing list. In case it's helpful I've added the
>>>>> "fstests.vfstest.for-next" tag which can be pulled. Otherwise it's
>>>>> possible to simply use the patch series as it appears in your inbox.
>>>>>
>>>>> All vfstests pass:
>>>>
>>>> [...]
>>>>
>>>>> #### xfs ####
>>>>> ubuntu@imp1-vm:~/src/git/xfstests$ sudo ./check -g idmapped
>>>>> FSTYP         -- xfs (debug)
>>>>> PLATFORM      -- Linux/x86_64 imp1-vm 5.18.0-rc4-fs-mnt-hold-writers-8a2e2350494f #107 SMP PREEMPT_DYNAMIC Mon May 9 12:12:34 UTC 2022
>>>>> MKFS_OPTIONS  -- -f /dev/sda4
>>>>> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
>>>>>
>>>>> generic/633 58s ...  58s
>>>>> generic/644 62s ...  60s
>>>>> generic/645 161s ...  161s
>>>>> generic/656 62s ...  63s
>>>>> xfs/152 133s ...  133s
>>>>> xfs/153 94s ...  92s
>>>>> Ran: generic/633 generic/644 generic/645 generic/656 xfs/152 xfs/153
>>>>> Passed all 6 tests
>>>>
>>>> I'm not sure if it's this series that has introduced a test bug or
>>>> triggered a latent issue in the kernel, but I've started seeing
>>>> generic/633 throw audit subsystem warnings on a single test machine
>>>> as of late Friday:
>>>>
>>>> [ 7285.015888] WARNING: CPU: 3 PID: 2147118 at kernel/auditsc.c:2035 __audit_syscall_entry+0x113/0x140
>>>
>>> Does your kernel have this commit?
>>>
>>> commit 69e9cd66ae1392437234a63a3a1d60b6655f92ef
>>> Author: Julian Orth <ju.orth@gmail.com>
>>> Date:   Tue May 17 12:32:53 2022 +0200
>>>
>>>     audit,io_uring,io-wq: call __audit_uring_exit for dummy contexts
> 
> No, that wasn't in -rc7.
> 
>> I could not reproduce either with or without your patch when I finally
>> got that test going and figure out how to turn on audit and get it
>> enabled. I don't run with that.
> 
> Ok. Given that this has been broken for over a year and nobody
> has noticed until late .18-rcX, it might be worth adding an audit
> enabled VM to your io-uring test farm....

It was in the 5.16 release, so it's ~4 months ago. Don't disagree on the
testing, though I do think that's mostly on the audit side. I had no
hand in any of that code.

From my experience trying to reproduce it yesterday, my test distros
don't even enable it and you have to both fiddle the config and add a
boot parameter to even turn it on. And then it still didn't trigger for
me.

I'll see if I can add something to the testing mix for this.

-- 
Jens Axboe

