Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8D692A8E
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBJWvy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBJWvx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:51:53 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7CB12585
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:51:51 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m2-20020a17090a414200b00231173c006fso10851962pjg.5
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R4N26B9VGGTnqC3xqOaxRLSDi0f2Dt0eKjIQvb/X62o=;
        b=u5HRO63gAcA4nfusNIOQSq65f86ZTJ3MqNvxRzAX5W+R22e0AtrfGMumqSuVrq1lF9
         NsFXM7VxYdTkvyXmirDO3xIUpW+ewcW65e2UkdwGOQJ9YYAwpFCJYyHSbkZWApVHEZGE
         trnv6AWqvv6dHFaEgCi4hVQIt+kM56QLFx8gqLW0NWJFYOuOwB8G583A//zD1Sai/c7C
         Yv8iBj0gA1lfIgrL3ID5Im4XMbfR6eu3isQI3hqYm8g51dYY/9UgnTVjXvGyKAjaFsRq
         qoIJ6191tOa8qIoM1uzUoaYGc2WROgSeZ+8ShxrfdZMyZQIyFSeReusVE5uiSq1tUukg
         zUbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R4N26B9VGGTnqC3xqOaxRLSDi0f2Dt0eKjIQvb/X62o=;
        b=wjRnBJ/rgmXzpsTsx24BhxvrxhCBcYL0ghZ3I/xIBOHq3v+DOGXJrO3ead8B+IxNzV
         8/WejuTyG7fhVNjVOmWdN1pSt2GcemfUEKAs204PL2tMYBVsiTfvhhBgCVh76zkjpA8b
         5VLDLRJfMYHJFWKRAwk+fE53dpcXx6FuGwz+V1+mhFx9KHW5Y4bNKxtsRKBhlQtAagOa
         n9jHkpJEqQcWE+supilWnXgFAyRvJbJ8rqjIixqx8gsVrpPBYv2rYFpbgxvuxjjDeWn7
         jhfvthoBeoH1pON7GFkxzoggrBmWNfwndAA9LFZj5bgPl6UlKeoI+FLSgyQQ2Wid9LJY
         iqmA==
X-Gm-Message-State: AO0yUKVkHhP+qcPi6gbaSj41HaKi39/aNbK51FinurOEGGCNsCaI3eAG
        /gctspLf2Qj30yPLdn3vVwHpbtcti5cqiB+S
X-Google-Smtp-Source: AK7set/0HEQG/FQ9H218VpRyJjXTjhHzpcw6zsWsYqjqsJHruBzZv/lO8Nfnn1XVxrZ0jfTCujLcLQ==
X-Received: by 2002:a05:6a20:7f8e:b0:be:cd93:66cd with SMTP id d14-20020a056a207f8e00b000becd9366cdmr18769759pzj.2.1676069510837;
        Fri, 10 Feb 2023 14:51:50 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z29-20020a63b91d000000b0047899d0d62csm3439655pge.52.2023.02.10.14.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 14:51:50 -0800 (PST)
Message-ID: <c395bf68-108e-1674-1a1c-4cb26178d87c@kernel.dk>
Date:   Fri, 10 Feb 2023 15:51:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        'Linus Torvalds' <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area>
 <20230210040626.GB2825702@dread.disaster.area>
 <CAHk-=wip9xx367bfCV8xaF9Oaw4DZ6edF9Ojv10XoxJ-iUBwhA@mail.gmail.com>
 <20230210061953.GC2825702@dread.disaster.area>
 <CAHk-=wj6jd0JWtxO0JvjYUgKfnGEj4BzPVOfY+4_=-0iiGh0tw@mail.gmail.com>
 <304d5286b6364da48a2bb1125155b7e5@AcuMS.aculab.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <304d5286b6364da48a2bb1125155b7e5@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 3:41?PM, David Laight wrote:
> From: Linus Torvalds
>> Sent: 10 February 2023 17:24
> ...
>> And when it comes to networking, in general things like TCP checksums
>> etc should be ok even with data that isn't stable.  When doing things
>> by hand, networking should always use the "copy-and-checksum"
>> functions that do the checksum while copying (so even if the source
>> data changes, the checksum is going to be the checksum for the data
>> that was copied).
>>
>> And in many (most?) smarter network cards, the card itself does the
>> checksum, again on the data as it is transferred from memory.
>>
>> So it's not like "networking needs a stable source" is some really
>> _fundamental_ requirement for things like that to work.
> 
> It is also worth remembering that TCP needs to be able
> to retransmit the data and a much later time.
> So the application must not change the data until it has
> been acked by the remote system.

This has been covered, and:

> I don't think io_uring has any way to indicate anything
> other than 'the data has been accepted by the socket'.

This is wrong and has also been covered.

-- 
Jens Axboe

