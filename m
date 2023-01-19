Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0E1674137
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 19:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjASStJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 13:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjASStI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 13:49:08 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0368455A
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 10:49:06 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id h15so1333098ilh.4
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 10:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wtwBFRkiv3X+2Mf5N6N6dytbuxwHCKEX2M461yzzZ4=;
        b=lMBkz8QDQPnPHUB4vYgP2C+JhfxfjbUPZ3Fr4QrobFtcxonCwGXYQIv+WOOb9XCEZy
         KhDKaf8dD4BVHOo9XTpbEvyj4y7+qdfhqxF2IJdcniC06Q1IWYIvGM3LYh872UF5c5wI
         RaTcO3g2pyey0WFLyj/8o1QrSoqVW+pBA57z7fWqpxc1WuIBTDQVoftwhoy4LDrbsz2X
         jJyfZTlbrwCnyUIPkwzJyqJlPpR09CvvZYLkBGUkpZevGgp3N8+Mo43t4ujg1CVg9uao
         AMhmFjZAv/6ELk8+w+ExsDR2dCIGQB58xVB+yVcqbnsj6e+fGVRxFT4LG4LYGQuQAWVc
         lMfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3wtwBFRkiv3X+2Mf5N6N6dytbuxwHCKEX2M461yzzZ4=;
        b=uppT6/73TqMoQgf952btmRNcK6vUBPdEmSjhJu2zvPWq4viADlFjs5QLwJPaJ4rTwl
         GlxNNM7UkzKCbbHE725uWEDtkC/FRuD56qIf7L5rCoCvy29o1aGff7gFF+swxDpZQ8aQ
         Mk2L4x5RChn0DLCsfTZ4OnRqEYMh1pcJb0NxcVkatKH2s24FvZ2rLqo5q+nwgZ4RavaS
         SFieBCH/ctifu3+e5Rz9trDUSqRcH1crWoUknhgLP9ET2Wi/1pM52808nOoaaNAZN6yM
         lvqls+0HbNJ5x/aW6x+QJRuTkcvcIvK4ONM+b86KvErU2GGFm35/YyrrRAS3NMrgqSfL
         kPAw==
X-Gm-Message-State: AFqh2krvzhRZVcRQaZmbbfk1GSqmwFU9Tp183MqXTAma5C22pi+hrS/u
        g8P4tB4oYAaG1nNUK0yts16Hz92d67QfNriI
X-Google-Smtp-Source: AMrXdXuOIDv/Uc+qYNqeQ8Q8kAd4DMYl/OagR+jmXwMlKcHcWIjFQRndKUZEf8kRrQA9a4OoOFaVEg==
X-Received: by 2002:a92:d342:0:b0:30b:c9ec:fc23 with SMTP id a2-20020a92d342000000b0030bc9ecfc23mr2013949ilh.2.1674154145943;
        Thu, 19 Jan 2023 10:49:05 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a88-20020a029461000000b0039e5786d7b7sm11754955jai.18.2023.01.19.10.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 10:49:05 -0800 (PST)
Message-ID: <4f22f15f-c15f-5fba-1569-3da8c0f37f0e@kernel.dk>
Date:   Thu, 19 Jan 2023 11:49:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: ublk-nbd: ublk-nbd is avaialbe
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@other.debian.org
References: <Y8lSYBU9q5fjs7jS@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y8lSYBU9q5fjs7jS@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/19/23 7:23 AM, Ming Lei wrote:
> Hi,
> 
> ublk-nbd[1] is available now.
> 
> Basically it is one nbd client, but totally implemented in userspace,
> and wrt. current nbd-client in [2], the transmission phase is done
> by linux block nbd driver.
> 
> The handshake implementation is borrowed from nbd project[2], so
> basically ublk-nbd just adds new code for implementing transmission
> phase, and it can be thought as moving linux block nbd driver into
> userspace.
> 
> The added new code is basically in nbd/tgt_nbd.cpp, and io handling
> is based on liburing[3], and implemented by c++20 coroutine, so
> everything is done in single pthread totally lockless, meantime turns
> out it is pretty easy to design & implement, attributed to ublk framework,
> c++20 coroutine and liburing.
> 
> ublk-nbd supports both tcp and unix socket, and allows to enable io_uring
> send zero copy via command line '--send_zc', see details in README[4].
> 
> No regression is found in xfstests by using ublk-nbd as both test device
> and scratch device, and builtin test(make test T=nbd) runs well.
> 
> Fio test("make test T=nbd") shows that ublk-nbd performance is
> basically same with nbd-client/nbd driver when running fio on real
> ethernet link(1g, 10+g), but ublk-nbd IOPS is higher by ~40% than
> nbd-client(nbd driver) with 512K BS, which is because linux nbd
> driver sets max_sectors_kb as 64KB at default.
> 
> But when running fio over local tcp socket, it is observed in my test
> machine that ublk-nbd performs better than nbd-client/nbd driver,
> especially with 2 queue/2 jobs, and the gap could be 10% ~ 30%
> according to different block size.

This is pretty nice! Just curious, have you tried setting up your
ring with

p.flags |= IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN;

and see if that yields any extra performance improvements for you?
Depending on how you do processing, you should not need to do any
further changes there.

A "lighter" version is just setting IORING_SETUP_COOP_TASKRUN.

-- 
Jens Axboe


