Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCA55BFFF2
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 16:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIUOd4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 10:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiIUOdy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 10:33:54 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97D12714
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 07:33:52 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id 138so5145359iou.9
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 07:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Se7+Ff9WqHH52xKsfLImB0VpB3sBEPrrxWsAQKpiM7Q=;
        b=zMYIeUYAmpy9CQkl6DYYYJYMJOwDHE9+wqGm3WvDWZ6swFZk736je/N9cbvAunXyDx
         J768hnLHjZichCzKv2+FvJq+C4jrHpf32tpVxqO6A3Ldm9cp5OYPjD5mqJlEqqnqU8dn
         xv55mdmIz+l9M8Sxj8hsqO8y9uUudOZmF4t35BGgIdq67gkJBQYmsoZfKzc/FctMe2JV
         iG47vzl25ynwmqDYv5WHPdjDP5l7H5HR1/UsBprBQJK3y/GUAW4OBCieYjEEPB4QSJpZ
         dOfd47Y+Pui4J/rJ70Hzg+3N0X3i4VpKVd+dOjjzWA38cDs/T97/jEKUG0mxKicSn1Ww
         CJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Se7+Ff9WqHH52xKsfLImB0VpB3sBEPrrxWsAQKpiM7Q=;
        b=WrBquslkTxSiIdTI7AyYI4ntnTv7qylxLZtW9N0X5O3K5bTST/couyiM/Dg4Q85V1l
         oQT/mWCX1w9JkSSW3hZiLsxZ4rowU/0Me6oQPxB3eAxWvkYA8Ql4G+SSWlllK2OGWa+Q
         EpMVp4gc46Y6ufVjMlwZTu0cGw+354820jgPMI6cJTWkDtMsch6VHa3JccAIaVRan397
         960Dct6WFgDoNAMlO+eg7kJIVQpKady0ySkG5jnxSoqgPKcrJGz4IZwHLUT61QA2nH98
         6UlJwA1sOtKSVN/RPZ4Vpw0+ukUxYTndx0mVVXcVPpZNijc7dheGHGc4ybx2u9X8wRiw
         dfwQ==
X-Gm-Message-State: ACrzQf0z0x+chDQJuDZeeBM2OjFLY+m6dKb5kBMSp8yUx+06mp0nxh0H
        ucgNPfQntoPGKXkAt0BDTDZMRw==
X-Google-Smtp-Source: AMsMyM5e5I6RLwQQqcEkJmrEaPHZSQm/6+4OA2wGKKHZgF+jyLo0T3aKmA8VuPbC3E2F2Ttm2YLx+A==
X-Received: by 2002:a6b:c6:0:b0:6a2:5f1f:aee5 with SMTP id 189-20020a6b00c6000000b006a25f1faee5mr11569710ioa.150.1663770831808;
        Wed, 21 Sep 2022 07:33:51 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k13-20020a02334d000000b0035672327fe5sm1098824jak.149.2022.09.21.07.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 07:33:51 -0700 (PDT)
Message-ID: <5ca12932-1452-1bcf-2a41-0f23c05a9930@kernel.dk>
Date:   Wed, 21 Sep 2022 08:33:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3 00/12] io-uring/btrfs: support async buffered writes
To:     dsterba@suse.cz
Cc:     Stefan Roesch <shr@fb.com>, kernel-team@fb.com,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org, josef@toxicpanda.com, fdmanana@gmail.com
References: <20220912192752.3785061-1-shr@fb.com>
 <20220920122540.GY32411@twin.jikos.cz> <20220921101958.GE32411@twin.jikos.cz>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220921101958.GE32411@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/21/22 4:19 AM, David Sterba wrote:
> On Tue, Sep 20, 2022 at 02:25:40PM +0200, David Sterba wrote:
>> On Mon, Sep 12, 2022 at 12:27:40PM -0700, Stefan Roesch wrote:
>>> This patch series adds support for async buffered writes when using both
>>> btrfs and io-uring. Currently io-uring only supports buffered writes (for btrfs)
>>> in the slow path, by processing them in the io workers. With this patch series
>>> it is now possible to support buffered writes in the fast path. To be able to use
>>> the fast path, the required pages must be in the page cache, the required locks
>>> in btrfs can be granted immediately and no additional blocks need to be read
>>> form disk.
>>>
>>> This patch series makes use of the changes that have been introduced by a
>>> previous patch series: "io-uring/xfs: support async buffered writes"
>>>
>>> Performance results:
>>>
>>> The new patch improves throughput by over two times (compared to the exiting
>>> behavior, where buffered writes are processed by an io-worker process) and also
>>> the latency is considerably reduced. Detailled results are part of the changelog
>>> of the first commit.
>>
>> Thanks. It's late for including this patches to 6.1 queue but it's now
>> in for-next and will be added to misc-next after rc1, targeting merge to
>> 6.2. I did some minor fixups, so please don't resend full series unless
>> there's a significant change. Incremental changes are fine if needed.
> 
> I'm revisiting the merge target, the potential risk seems to be low
> here, straightforward changes for a separate feature, so it's now in the
> 6.1 queue. We still don't have ack for the function export so that would
> be good to have.

I don't think the ack there is a big deal, iomap already uses it but
can't be modular. So it's just adding a modular user of the same thing,
really.

6.1 sounds good to me!

-- 
Jens Axboe


