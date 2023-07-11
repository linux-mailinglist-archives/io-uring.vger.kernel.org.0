Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6F174F9AE
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 23:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjGKVW2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 17:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjGKVWX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 17:22:23 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BE3173D
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 14:22:10 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-682ae5d4184so1341864b3a.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 14:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689110530; x=1691702530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gA3l1yhuKOFSCNrc4pLJH2sIkbUZixeTWwlssXNtbNw=;
        b=a51Yb+l2+T+BEYpdjBPQAGmZ4P1Os4bcoMbvwS1VflIi9CZ+pw9FXCG+hhUUui8yYr
         rE7BGgLFALSet+fLPFVwOeuLXGOg0qW5Jl1cwQUwBcyCtk8qb1teTuP9ebjgonBl7zvV
         +XRxxunDFNk/GMI5ry1KGp3srr+8TvTvTHLcpSHRN8Jf7gKUougtGZe8Kdel982ymZ1k
         F/2Yw4To9rP+1CwK1ouNjPsNyGrNhZloSyj0p6w3F17Y/cCTSQzLUzzEzE5oVfdEQc3l
         cNAN+zk08fFQBEm+MW361Nn6ydH4TGYb2R7a1EmGvxwdJ1XDnIJEAthXjpBj7yC3llc+
         1daQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689110530; x=1691702530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gA3l1yhuKOFSCNrc4pLJH2sIkbUZixeTWwlssXNtbNw=;
        b=Yl1auC4yj0rxwh9zBJ66mV6Y5r8T7Ikf+9AQBM6+cFywd/VHLDypKzknIfVsFD0crA
         WwbMPb6n/5tzRawIILh3v5GJ2w0WTHGvsGjQA2ZsUXQ9ZpqKP7mZ/p3XMSYJAPk0dR3q
         nxUnVd0eohbndudnZSbxlv7jae30AsXb4cHjfF4lHzGkjlJEh6nOKwEWVaeTJs0Ht1Eu
         Ab3uoXn3cGYdS652qMhbKp92+NfHSgjOY0rbFntSPtsqx+3J27MOtG2LyhUaJbgd3RHv
         49kpZqqTSyy9gTM2Du1CxLqIpPZNJQIpGEXz466psrZGU1AAW+K6IlfulWQQuP0I+pNo
         kAAQ==
X-Gm-Message-State: ABy/qLZAETtJYDdvoampNLnDKs1isN5PH1Imyq8OyMSrgJ2etaHZRJ6R
        h+ieQbENFiHZIcjHVscyNT/blg==
X-Google-Smtp-Source: APBJJlFVfxfkuXNd5u2rO+Y6efYLXZMTgIkaHOTtf3/LXtk9M0ngHOLb+o3MMkbyvcpHedshSbiJOw==
X-Received: by 2002:a05:6a21:32a3:b0:132:4913:b651 with SMTP id yt35-20020a056a2132a300b001324913b651mr4312798pzb.3.1689110530093;
        Tue, 11 Jul 2023 14:22:10 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n18-20020a638f12000000b00548d361c137sm2015321pgd.61.2023.07.11.14.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 14:22:09 -0700 (PDT)
Message-ID: <048cfbce-5238-2580-2d53-2ca740e72d79@kernel.dk>
Date:   Tue, 11 Jul 2023 15:22:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christian Brauner <brauner@kernel.org>
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-6-axboe@kernel.dk>
 <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/23 3:11?PM, Arnd Bergmann wrote:
> On Tue, Jul 11, 2023, at 22:43, Jens Axboe wrote:
>> This adds support for an async version of waitid(2), in a fully async
>> version. If an event isn't immediately available, wait for a callback
>> to trigger a retry.
>>
>> The format of the sqe is as follows:
>>
>> sqe->len		The 'which', the idtype being queried/waited for.
>> sqe->fd			The 'pid' (or id) being waited for.
>> sqe->file_index		The 'options' being set.
>> sqe->addr2		A pointer to siginfo_t, if any, being filled in.
>>
>> buf_index, add3, and waitid_flags are reserved/unused for now.
>> waitid_flags will be used for options for this request type. One
>> interesting use case may be to add multi-shot support, so that the
>> request stays armed and posts a notification every time a monitored
>> process state change occurs.
>>
>> Note that this does not support rusage, on Arnd's recommendation.
>>
>> See the waitid(2) man page for details on the arguments.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Does this require argument conversion for compat tasks?
> 
> Even without the rusage argument, I think the siginfo
> remains incompatible with 32-bit tasks, unfortunately.

Hmm yes good point, if compat_siginfo and siginfo are different, then it
does need handling for that. Would be a trivial addition, I'll make that
change. Thanks Arnd!

-- 
Jens Axboe

