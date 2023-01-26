Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF3867D43D
	for <lists+io-uring@lfdr.de>; Thu, 26 Jan 2023 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjAZSfL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Jan 2023 13:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjAZSfL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Jan 2023 13:35:11 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BB2470B3
        for <io-uring@vger.kernel.org>; Thu, 26 Jan 2023 10:35:08 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id i1so1136277ilu.8
        for <io-uring@vger.kernel.org>; Thu, 26 Jan 2023 10:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NVoChKAkzts7dgGnV/tbJ1qaKX0TQjLm2fB+YU+Y5HU=;
        b=DJG5dahUknQalNvuXmjvquTwRb7+wND9jVEVG3eq/iAS2EZC+uNc3Djr76SbQ+cT42
         VpkHhccHhWE3/IultPYMqq3R6iYGewvUN0+mdveKulV3UfTxE6HPVSR++SuJhNM5WPJx
         jKz9aQufcH2Y0I4UjSk3Bdk8ElzTl+1Dy9C323tvXPydHOB5oQICKQheUDgLIWvD6CTE
         5B6GMSGYlDNAAhcqWnYn/ZhADcXdpQe0Re7G62b+QkmW5FQ/D/pzoOroN+HYvrdGA4UL
         j8i2RbOuxpFIek2HK0IecMjgRH/wuIYeYibvJbWmBwC0Tti/4qLPFZl5BhH/rwJWz/nI
         5teA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVoChKAkzts7dgGnV/tbJ1qaKX0TQjLm2fB+YU+Y5HU=;
        b=ck3sstdUsgU0qYCul+YHSm5Qma5MON2vOn9kE/EnWCCHzfpaDsIdwFB4rOZik3sQ0Y
         ntz+nuj81LDGB13VgoNOkjzJkhra0bwBDcncKi8AtwI+VmSQ0b90mzxu1glPh+T6zcb4
         TMR1DWE6oyIyAA6UYx0p217qmBnWdWBi+41SdSl+GNGXUbqWXyknJGaMIIcfTjxThiQs
         L7QVSt1q9G1oSNAIrROp/ZBOJyGa6THzzG70dJ9Q9iQBdX2VHpXhDJZlMz5VIb44wIqe
         OZAKEvs0GjEweyUadhOIMAph6K9zU0gWXWM6ZkbMccuCVEKx97YvQWlYHeNyL2001+wi
         J7Tg==
X-Gm-Message-State: AO0yUKWrnHHiK6oI/91Z3sfB7N5PqoCugpNQFxmivxirx+MhHY5nh3b8
        EOHJVlAGxbKYwtV9RWf1RGMbbQ==
X-Google-Smtp-Source: AK7set8EIWtRkNu5Auglt1Vk3LjfCsZPbg0U2A954m5RV37qEwGXvA2MeHz/UOzkRxQHkpJta2HZSA==
X-Received: by 2002:a92:6810:0:b0:310:9adc:e1bb with SMTP id d16-20020a926810000000b003109adce1bbmr1367545ilc.0.1674758107631;
        Thu, 26 Jan 2023 10:35:07 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v17-20020a92c811000000b0030258f9670bsm544585iln.13.2023.01.26.10.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 10:35:06 -0800 (PST)
Message-ID: <75e32a84-3a0d-d53f-af1b-b54c1036656c@kernel.dk>
Date:   Thu, 26 Jan 2023 11:35:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Phoronix pts fio io_uring test regression report on upstream v6.1
 and v5.15
Content-Language: en-US
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230119213655.2528828-1-saeed.mirzamohammadi@oracle.com>
 <af6f6d3d-b6ea-be46-d907-73fa4aea7b80@kernel.dk>
 <DM5PR10MB14190335EEB0AEF2B48DF6BAF1CE9@DM5PR10MB1419.namprd10.prod.outlook.com>
 <0f7cd96e-7f89-4833-c0af-f90b2c5cf67d@kernel.dk>
 <BCEB787A-38B7-4301-A3CE-A780F3AAB45D@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <BCEB787A-38B7-4301-A3CE-A780F3AAB45D@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/23 11:04 AM, Saeed Mirzamohammadi wrote:
> Hi Jens,
> 
>> On Jan 25, 2023, at 4:28 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> 
>> On 1/25/23 5:22?PM, Saeed Mirzamohammadi wrote:
>>> Hi Jens,
>>> 
>>> I applied your patch (with a minor conflict in xfs_file_open() since FMODE_BUF_WASYNC isn't in v5.15) and did the same series of tests on the v5.15 kernel. All the io_uring benchmarks regressed 20-45% after it. I haven't tested on v6.1 yet.
>> 
>> It should basically make the behavior the same as before once you apply
>> the patch, so please pass on the patch that you applied for 5.15 so we
>> can take a closer look.
> 
> Attached the patch.

I tested the upstream variant, and it does what it's supposed to and
gets parallel writes on O_DIRECT. Unpatched, any dio write results in:

             fio-566     [000] .....   131.071108: io_uring_queue_async_work: ring 00000000706cb6c0, request 00000000b21691c4, user_data 0xaaab0e8e4c00, opcode WRITE, flags 0xe0040000, hashed queue, work 000000002c5aeb79

and after the patch:

             fio-376     [000] .....    24.590994: io_uring_queue_async_work: ring 000000007bdb650a, request 000000006b5350e0, user_data 0xaaab1b3e3c00, opcode WRITE, flags 0xe0040000, normal queue, work 00000000e3e81955

where the hashed queued is serialized based on the inode, and the normal
queue is not (eg they run in parallel).

As mentioned, the fio job being used isn't representative of anything
that should actually be run, the async flag really only exists for
experimentation. Do you have a real workload that is seeing a regression?
If yes, does that real workload change performance with the patch?

-- 
Jens Axboe


