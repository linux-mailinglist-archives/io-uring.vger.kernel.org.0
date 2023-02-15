Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389E5698184
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 18:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjBORBQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 12:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBORBO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 12:01:14 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7E238B40
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 09:01:12 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id k14so3454461ilo.9
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 09:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yiqWM6HH7+wfgiaknMVF3VR6f19OKxKeSu0RZUiYVGk=;
        b=45gjb4i/0MTIDwkfJ6dZE5Jz0dcdhUOFOUM8bTz1+6A0nxO0O7brl+nnhETurQdpMQ
         7R1gNMFrOxY7Di9zWBpYCwqLF7fIfpcmoE/qWv9uFZrj+zZnt3dhmqxOLf5Kjv7Z88Yp
         MFKYbcz7kqMA6myTQyzM6gP1c2tc4HoaUrJY6kRZzx7vLjofwIrJCz1VWW5VY1k6xBtR
         AxaMfsAAfp1n/b34MW8CFk++YDGbjZgrJ2t9VxSwmlejIMjwL+jNptz0AFfnDPmyTG6Z
         tf9UCofiICm2R4u9OnQPg4ap+yip5dtXsgvttv+lhSKN+P/BqLM4BITsbH99gyxrZ0D8
         m7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yiqWM6HH7+wfgiaknMVF3VR6f19OKxKeSu0RZUiYVGk=;
        b=yr2pbmrpNyD4sh3jWCeyzUu5fO69wFAr9H0FJiRpCeQt3PlTGXOEwHReMPm0tn7jUd
         JmlFil5y3+n5b50iGMf5RztDoPudw72Te0LuteNm7ZiuIo0/vFw3KW2LyzEe+DeIZFx4
         NIJN42BbxTyo2PlNG/9hWotFdCfMvoJ/3ngzKDCdzZz+ZxGE71u+ikLjSARc1jQYWFbZ
         2/O8RKJY9h3NzPoQYpkHHTXEahVi8SiZmVD2tppFwjF/gs1tGzWTqvakOvPljUWSxle4
         DRIL6jLOmSFKDLY/uQlOwZ0MkB9VVXbY7NZo0XKxtPvdo1IEXYu5T+42jES3R5Dv5Qos
         +IMw==
X-Gm-Message-State: AO0yUKUkwj52OgLtCx6XQxRv3tTpOuF9rx+RhvLrhtj7MmED6C6SjOzd
        QefztIZdZTI1ue51u1YzBV98bA==
X-Google-Smtp-Source: AK7set+0PdSdOe8ctFCIoMj4TlvlgMGDvtl7A9O50LRmfdUTJpDe4Bq3X8eQwS7Ih3eJ1ELd9JbAOg==
X-Received: by 2002:a05:6e02:ece:b0:315:2b2a:f458 with SMTP id i14-20020a056e020ece00b003152b2af458mr1857881ilk.3.1676480471640;
        Wed, 15 Feb 2023 09:01:11 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c11-20020a02a40b000000b003bf39936d1esm5547415jal.131.2023.02.15.09.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 09:01:11 -0800 (PST)
Message-ID: <a03d75b9-a9b8-b950-c53d-6df85fe8adc4@kernel.dk>
Date:   Wed, 15 Feb 2023 10:01:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
 <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
 <0bfe6cdb-2749-c08d-a1b2-ef46fed1ded3@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0bfe6cdb-2749-c08d-a1b2-ef46fed1ded3@bell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/15/23 9:38 AM, John David Anglin wrote:
> On 2023-02-15 10:56 a.m., Jens Axboe wrote:
>>> Is there maybe somewhere a more detailled testcase which I could try too?
>> Just git clone liburing:
>>
>> git clone git://git.kernel.dk/liburing
>>
>> and run make && make runtests in there, that'll go through the whole
>> regression suite.
> Here are test results for Debian liburing 2.3-3 (hppa) with Helge's original patch:
> https://buildd.debian.org/status/fetch.php?pkg=liburing&arch=hppa&ver=2.3-3&stamp=1676478898&raw=0

Most of the test failures seem to be related to O_DIRECT opens, which
I'm guessing is because it's run on an fs without O_DIRECT support?
Outside of that, I think some of the syzbot cases are just generally
broken on various archs.

Lastly, there's a few of these:

Running test buf-ring.t                                             bad run 0/0 = -233

and similar (like -223) which I really don't know what is, where do
these values come from? Ah hang on, they are in the parisc errno,
so that'd be -ENOBUFS and -EOPNOTSUPP. I wonder if there's some
discrepancy between the kernel and user side errno values here?

-- 
Jens Axboe


