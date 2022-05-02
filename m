Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8F517548
	for <lists+io-uring@lfdr.de>; Mon,  2 May 2022 19:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbiEBRFm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 May 2022 13:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386647AbiEBREN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 May 2022 13:04:13 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFC110E0
        for <io-uring@vger.kernel.org>; Mon,  2 May 2022 10:00:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k1so4323748pll.4
        for <io-uring@vger.kernel.org>; Mon, 02 May 2022 10:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=eHBpjvV0xsoV/2E/yxAKoD7xjO9zfwPQ1d4jUnUE31Y=;
        b=lvPK8H4vc+BAN657Xx1F3TXqqpbu97mZf4LGDeuVQ7CbIZ119ejBP80HsujmBElg5y
         3OhzGwB5VlmeWNEpAOhWTHzjWyWgdkx3UVnNXF9steLeFtmf/a7us+5RUQWiHvUf1Wuz
         hvkMpVlZ5dxVrU+4mElHsi5xYRNkKYWOnKe7ovwse/i6hZHIDI30x5QwktxDXfJxvb2d
         scRF/cieQHMixK1Tyr/AH6Zw6BRZ5qhpF08qqvFcoonw0cM0ApL/TA5zVXmsuZJQ5JbG
         OogWPxMHngRSfkPBHGOeCooTysASe6w3InrtP+UEMuHam2naL+jmOJlwn7DAhxcwAFUa
         fN4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=eHBpjvV0xsoV/2E/yxAKoD7xjO9zfwPQ1d4jUnUE31Y=;
        b=DOHjjjNLJ++jDOVBtS7VMENZPltT4e2GanQGVXzxqwfI6cn+pMINFhEW3YbnJfNuen
         cEoAe/BRkaglYrELH9ak0fP9nDwBhKwD+29Nzdy46t9anhqNhqBRDd9/IZu3Tdyncqdw
         z+CDQfPZlbnUkLXXWu1hQUIYrr+vlj2Gez7cB8R3v2a6vVDkuRSRdCr1pYqvFl2wQF7y
         y0a5OQskkb5XPo7ZrMYqi/dQXgEVBSaAOYSfq4XlnX9gp/OZO4v4+qKgCmn5LXebWDo3
         17FdSzFcTfP87Hkahn55JpCUemvt+6/BNY17iQxLs1QHqkNEGhBku+QFruqyDhbgyN95
         rRvA==
X-Gm-Message-State: AOAM532ikjoH5ZZIPuMikUN/4HzgTeThUj6pySJ+i70WDxufj2d+htAf
        NtN5szY3CJZhoNWND2PAF4LeeelfGRJrLA==
X-Google-Smtp-Source: ABdhPJz86mhBbGpqIE9j8RYZ8M7M1FBCdLWOj6qLKCtxIG/rlugzA0w1yHfEGRZM801GfYtiy1htYQ==
X-Received: by 2002:a17:902:70c1:b0:156:16c0:dc7b with SMTP id l1-20020a17090270c100b0015616c0dc7bmr12658855plt.85.1651510840897;
        Mon, 02 May 2022 10:00:40 -0700 (PDT)
Received: from [10.10.71.43] ([8.34.116.185])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902f64700b0015e8d4eb1fdsm4908003plg.71.2022.05.02.10.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 10:00:40 -0700 (PDT)
Message-ID: <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
Date:   Mon, 2 May 2022 11:00:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Daniel Harding <dharding@living180.net>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
 <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
In-Reply-To: <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/22 7:59 AM, Jens Axboe wrote:
> On 5/2/22 7:36 AM, Daniel Harding wrote:
>> On 5/2/22 16:26, Jens Axboe wrote:
>>> On 5/2/22 7:17 AM, Daniel Harding wrote:
>>>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>>>> (--enable-liburing), targeting liburing-2.1.  My kernel config is a
>>>> very lightly modified version of Fedora's generic kernel config. After
>>>> moving from the 5.16.x series to the 5.17.x kernel series, I started
>>>> noticed frequent hangs in lxc-stop.  It doesn't happen 100% of the
>>>> time, but definitely more than 50% of the time.  Bisecting narrowed
>>>> down the issue to commit aa43477b040251f451db0d844073ac00a8ab66ee:
>>>> io_uring: poll rework. Testing indicates the problem is still present
>>>> in 5.18-rc5. Unfortunately I do not have the expertise with the
>>>> codebases of either lxc or io-uring to try to debug the problem
>>>> further on my own, but I can easily apply patches to any of the
>>>> involved components (lxc, liburing, kernel) and rebuild for testing or
>>>> validation.  I am also happy to provide any further information that
>>>> would be helpful with reproducing or debugging the problem.
>>> Do you have a recipe to reproduce the hang? That would make it
>>> significantly easier to figure out.
>>
>> I can reproduce it with just the following:
>>
>>     sudo lxc-create --n lxc-test --template download --bdev dir --dir /var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r bionic -a amd64
>>     sudo lxc-start -n lxc-test
>>     sudo lxc-stop -n lxc-test
>>
>> The lxc-stop command never exits and the container continues running.
>> If that isn't sufficient to reproduce, please let me know.
> 
> Thanks, that's useful! I'm at a conference this week and hence have
> limited amount of time to debug, hopefully Pavel has time to take a look
> at this.

Didn't manage to reproduce. Can you try, on both the good and bad
kernel, to do:

# echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable

run lxc-stop

# cp /sys/kernel/debug/tracing/trace ~/iou-trace

so we can see what's going on? Looking at the source, lxc is just using
plain POLL_ADD, so I'm guessing it's not getting a notification when it
expects to, or it's POLL_REMOVE not doing its job. If we have a trace
from both a working and broken kernel, that might shed some light on it.

-- 
Jens Axboe

