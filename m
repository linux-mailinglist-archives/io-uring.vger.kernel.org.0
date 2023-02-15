Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6809F698441
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 20:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBOTQV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 14:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBOTQU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 14:16:20 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD263AB2
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 11:16:19 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id v13so6342851iln.4
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 11:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BXqQ5uSuPxrQSVsfWx2aystLFZy3e+D6LxBOCtS44+M=;
        b=h6sAumapT3qiSPb20EVAjSi4T1PWGOl3u3iKPgdV4TCH/KPTwCDW/mfEy/xE9iJCQW
         X3XfoksWa8gWjoGw2v3rqKUNinPrT7HVOXpvCCsijwRQkFyF82pq5brwsx16yWBFWxCu
         huGwdk420BdrNYg2tiGBz2Eylbv7g1hs/+/GUZbARr0vkuQmg0MIiZgIh8bZ3CPne4Kt
         MJ/1eGGugTv/4Cbbz++6OU5KRaPQ/hZZhbDmO7cS3BOfcfkfEcgVxWmrAjoBdGFRqKoQ
         6x2qipcyk+rX5jitYyNoFVs02HsaBt39oXvBSHZCf13YHNKu1KWAmzG59dSxCL00II4u
         4cjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BXqQ5uSuPxrQSVsfWx2aystLFZy3e+D6LxBOCtS44+M=;
        b=Ao48pIiIPb20wI1c/uP85enQs6+adUAml3+VjGUW3f0N7o3JjC6gf1gPKUkPrGo0x/
         1ajVCOQW4hUlremM9cxbInIXINKRJiw8GuAgB8/GwRxqWlMuCzTudyAjQba9NZx1NSlG
         RNptF6wC4mvysBZrRHPXI/FeG6tyH7LMohphIkiqMgBTUdS2Gg9z2lQLyyQnT3CM9hAh
         bJyLDyAUuE8+UPqgJGUnGK3C8DbWu4tiBmp6Wjj96VDkkAe0/h0r9IBWh1dkLWMmvCzX
         ShVtcutr8kFPu5kzINIhevmaSGBgEkkLgIppDCT05tPBYBWkFqpFkuI5NQINzHcNTQ6P
         EFQQ==
X-Gm-Message-State: AO0yUKUZfeNwZffqxVu4x2I70L2Yom8DuT682IwKjuoecocpoag70Asy
        efs3O+ypg97Xv2scm9TlQEv96A==
X-Google-Smtp-Source: AK7set98GsicfSdCYp8aW36dZRptzy+YTp7GBn76FBByUl3HrnJSsaxLWWSOlkYhnV0lVg0d4HGXcQ==
X-Received: by 2002:a05:6e02:1aa7:b0:315:39ce:abd2 with SMTP id l7-20020a056e021aa700b0031539ceabd2mr2669081ilv.3.1676488578428;
        Wed, 15 Feb 2023 11:16:18 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q13-20020a92c00d000000b003157696c04esm490765ild.46.2023.02.15.11.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 11:16:17 -0800 (PST)
Message-ID: <4f4f9048-b382-fa0e-8b51-5a0f0bb08402@kernel.dk>
Date:   Wed, 15 Feb 2023 12:16:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
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
 <a03d75b9-a9b8-b950-c53d-6df85fe8adc4@kernel.dk>
 <07810314-94f6-0e9a-984b-0a286cbb59d3@kernel.dk>
In-Reply-To: <07810314-94f6-0e9a-984b-0a286cbb59d3@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/15/23 12:00?PM, Jens Axboe wrote:
> accept.t: setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
> fails here, no idea why.

I'm wrong on this one, it's actually opening a socket with O_NONBLOCK
that fails with EINVAL, and then we pass -1 to the above. I saw
something on boot on O_NONBLOCK being the wrong value (I think from
systemd), so maybe another case of userspace and the kernel not agreeing
on what values flags/errno has?

In any case, with the silly syzbot mmap stuff fixed up, I'm not seeing
anything odd. A few tests will time out as they simply run too slowly
emulated for me, but apart from that, seems fine. This is running with
Helge's patch, though not sure if that is required running emulated.

-- 
Jens Axboe

