Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9BF6BEE75
	for <lists+io-uring@lfdr.de>; Fri, 17 Mar 2023 17:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjCQQhL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Mar 2023 12:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjCQQhJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Mar 2023 12:37:09 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9FBC8322
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 09:37:04 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id j6so3034988ilr.7
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 09:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679071023;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ck4UkbcbSKRT/h9bH3q7bC2hDj8qbJmCL92Ho9zXzgI=;
        b=vA2YAfZu+fw8yEhjwC2mRTWT49y/GEBnGHBPu9EF9VF35eBGg8+FXqSsedGkh9DkVK
         OHR4Y+mmh3Q09IafvyedBCwVuoG5qdMlhL1S6//NtxOVjFTTyfZlP/LTCmxMNSYzwcce
         6XJ3vutzpvIIoKu9JbMMHXpeB6zluxGTuZsOj+4ewP9enr6lzxGOKTIxB2+VQ/bkT5XQ
         +AMN3jt6rj9l7NT13BeNUX76gaM7108Lk0tDk4XoEjv04/M62Lx5k836id3dinVnkckK
         Mjdf1LPex0AQ0SwAqGF3nnXwLqGObSoIU+rGm/vrRUiHhHLUpwR2Fj6HBKYekwcIVLuT
         jUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679071023;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ck4UkbcbSKRT/h9bH3q7bC2hDj8qbJmCL92Ho9zXzgI=;
        b=paaqOYvyyyOkwUdENFBAiCPvkjIaB965S+YKOQF0a0GLKX+3/tcJV/nKA/L3VbXPIH
         YNFuNqpevhJ9VjnT/pSkTGkQ72EsUSC8Kpdbdx9+4+hEi/bImO3wiLrFteMIesVIr/ce
         LcmYO1zOQzgnbCKrrHqalZJL2rKHluQo/IFV0TOl3nx2qhv2UMG3bPko5KrZzIGxO3/e
         lR4YGiP8kjs+VgeOEuIGPQEc5tVS9na2fjTY+f5YoAEHp9g+/+L85mNoHPQHR+1BTcip
         d+t4e1jnSAqJM1s0Dsj5xhI/Pt2Y7mY+dlOr0u4JV73pSiOfE8uSDloLzXdOxrLKEgW/
         oXNw==
X-Gm-Message-State: AO0yUKVQOThI+0Pa9CUYkptobzkOHRyUMwSsnIWH7AoerW/OyD/W0/Wh
        8S/u9Yg37qmdL+3MCvHqK3OXaw==
X-Google-Smtp-Source: AK7set98Q+Kzn7LR1/ozMKj14f5trLGOGsFmA3+iOCpLbf7y0RYz973o+QikmtV+p4tb9ktmec1NoQ==
X-Received: by 2002:a05:6e02:1190:b0:323:504:cff6 with SMTP id y16-20020a056e02119000b003230504cff6mr3372592ili.3.1679071023033;
        Fri, 17 Mar 2023 09:37:03 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r17-20020a92ac11000000b00312f2936087sm688257ilh.63.2023.03.17.09.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 09:37:02 -0700 (PDT)
Message-ID: <869f0bb9-dea2-a739-e1ea-213955eb638a@kernel.dk>
Date:   Fri, 17 Mar 2023 10:37:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
To:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
 <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
 <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
 <babf3f8e-7945-a455-5835-0343a0012161@bell.net>
 <29ef8d4d-6867-5987-1d2e-dd786d6c9cb7@kernel.dk>
 <42af7eb1-b44d-4836-bf72-a2b377c5cede@kernel.dk>
 <827b725a-c142-03b9-bbb3-f59ed41b3fba@kernel.dk>
 <31e9595d-691b-c87c-e38a-b369143fc946@bell.net>
 <f4da7453-49ef-73fb-7feb-fcca543bd37e@kernel.dk>
 <e8c78c0f-b94a-2ac8-b827-e7938182347f@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e8c78c0f-b94a-2ac8-b827-e7938182347f@bell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/23 10:15?AM, John David Anglin wrote:
> On 2023-03-17 11:57 a.m., Jens Axboe wrote:
>>> Running test buf-ring.t register buf ring failed -22
>>> test_full_page_reg failed
>>> Test buf-ring.t failed with ret 1
>> The buf-ring failure with the patch from my previous message is because
>> it manually tries to set up a ring with an address that won't work. The
>> test case itself never uses the ring, it's just a basic
>> register/unregister test. So would just need updating if that patch goes
>> in to pass on hppa, there's nothing inherently wrong here.
>>
> I would suggest it.  From page F-7 of the PA-RISC 2.0 Architecture:
> 
>    All other uses of non-equivalent aliasing (including simultaneously
>    enabling multiple non-equivalently aliased translations where one
>    or more allow for write access) are prohibited, and can cause
>    machine checks or silent data corruption, including data corruption
>    of unrelated memory on unrelated pages.

I did add a patch to skip that sub-test on hppa, as there's just no way
to make that one work as it relies on manually aligning memory to
trigger an issue in an older kernel. So the test should pass now in the
liburing master branch.

I'll send out the alignment check patch and we can queue that up for
6.4.

-- 
Jens Axboe

