Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488F653002B
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 03:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiEVBH3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 May 2022 21:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbiEVBH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 May 2022 21:07:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8DF46B25
        for <io-uring@vger.kernel.org>; Sat, 21 May 2022 18:07:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l14so11027285pjk.2
        for <io-uring@vger.kernel.org>; Sat, 21 May 2022 18:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/8RA0QPQ8Q04HHD+G5iHOvPXBam8Oz5zBNys4fVAJS0=;
        b=KMh4lGgoJ5BrBhOFc+q4AtxuAd1teSQ59pGFATcKogfUwMavC1Zyig3nosn33ZfUyV
         lRvdkw/ZrOeB62R/r4ZbJZYwm1Wx4hCEFvt4DikCe9+cNA6h2qFn60b8+VHPZ9d7Tmag
         pHIjZciG+h42oFzB0UyaYGeolKAxxjnZRTVEFTR4VtANFAJ6p95MaI7oBpiGWprUpzqK
         p1wQjwXM7mJPnIkJm68/+WzSDKdSs9wM5/o/XpobYmsRFc1XKqYgGguzMqTGsqu2u06X
         ForS0wdgBS74Ug9vjkUWeAy5hiaabSoZBqSqpJEk1iJs35QTXVJyCxPd5a0BDOueGiVc
         LYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/8RA0QPQ8Q04HHD+G5iHOvPXBam8Oz5zBNys4fVAJS0=;
        b=wYjXu4MKDaX6beZrCaNNu2pxvKDOi2aT8w9jwARj0ZWrhPFRKCHEmBXY5dG7G+XJ0i
         FvLK5PCtgXHyUhTuUs4MfnP52RXhJvj+ElO7NiMTQ16oSdb/SYiJ4SdajhukgQbLEk3s
         mvu81/DNTkRScBTGs9pWFug/Q32lLIGX41vLfs04LH26eSb5tSI99B0XX2TGlxDLKonr
         DTJQ8c05OMZscSTh23D5/VQLUoh8IOH/uekm/6n56Xqt5nQPhgOufjUiHZDWokBLDk3d
         wOlLCqGr2WzKb+yusTDl+l5e1MwWhbxwwtJi2TjcDX6VWlIezvcmTcpG2MBKUmmS/+iY
         qzbA==
X-Gm-Message-State: AOAM531e8PRAjoQy91mvthdM75MSk7kwVm4rbYb3QjISXd24TRf8cb32
        xdXr5b2kz/lC27P9mlpZzSV8bg==
X-Google-Smtp-Source: ABdhPJzSY2yrHYYrpH5M63ly9zF8PMYcLYvqVqeaVNG85fOTe86ZNWT7tTqTI2HuYtf07JhJ7lqe+A==
X-Received: by 2002:a17:902:d70e:b0:162:1e73:55ea with SMTP id w14-20020a170902d70e00b001621e7355eamr213808ply.36.1653181642891;
        Sat, 21 May 2022 18:07:22 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bo4-20020a056a000e8400b0050dc76281e2sm4137735pfb.188.2022.05.21.18.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 May 2022 18:07:22 -0700 (PDT)
Message-ID: <f77e867f-ed7d-85f7-f1e4-b9dc10a6d23b@kernel.dk>
Date:   Sat, 21 May 2022 19:07:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 00/13] rename & split tests
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Christian Brauner <brauner@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>, io-uring@vger.kernel.org
References: <20220512165250.450989-1-brauner@kernel.org>
 <20220521231350.GY2306852@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220521231350.GY2306852@dread.disaster.area>
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

On 5/21/22 5:13 PM, Dave Chinner wrote:
> [cc io_uring]
> 
> On Thu, May 12, 2022 at 06:52:37PM +0200, Christian Brauner wrote:
>> From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
>>
>> Hey everyone,
>>
>> Please note that this patch series contains patches that will be
>> rejected by the fstests mailing list because of the amount of changes
>> they contain. So tools like b4 will not be able to find the whole patch
>> series on a mailing list. In case it's helpful I've added the
>> "fstests.vfstest.for-next" tag which can be pulled. Otherwise it's
>> possible to simply use the patch series as it appears in your inbox.
>>
>> All vfstests pass:
> 
> [...]
> 
>> #### xfs ####
>> ubuntu@imp1-vm:~/src/git/xfstests$ sudo ./check -g idmapped
>> FSTYP         -- xfs (debug)
>> PLATFORM      -- Linux/x86_64 imp1-vm 5.18.0-rc4-fs-mnt-hold-writers-8a2e2350494f #107 SMP PREEMPT_DYNAMIC Mon May 9 12:12:34 UTC 2022
>> MKFS_OPTIONS  -- -f /dev/sda4
>> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
>>
>> generic/633 58s ...  58s
>> generic/644 62s ...  60s
>> generic/645 161s ...  161s
>> generic/656 62s ...  63s
>> xfs/152 133s ...  133s
>> xfs/153 94s ...  92s
>> Ran: generic/633 generic/644 generic/645 generic/656 xfs/152 xfs/153
>> Passed all 6 tests
> 
> I'm not sure if it's this series that has introduced a test bug or
> triggered a latent issue in the kernel, but I've started seeing
> generic/633 throw audit subsystem warnings on a single test machine
> as of late Friday:
> 
> [ 7285.015888] WARNING: CPU: 3 PID: 2147118 at kernel/auditsc.c:2035 __audit_syscall_entry+0x113/0x140

Does your kernel have this commit?

commit 69e9cd66ae1392437234a63a3a1d60b6655f92ef
Author: Julian Orth <ju.orth@gmail.com>
Date:   Tue May 17 12:32:53 2022 +0200

    audit,io_uring,io-wq: call __audit_uring_exit for dummy contexts

-- 
Jens Axboe

