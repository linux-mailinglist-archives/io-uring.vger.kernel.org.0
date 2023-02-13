Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B28F6952A5
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 22:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjBMVFt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 16:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjBMVFs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 16:05:48 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BB22057F
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 13:05:15 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id k14so1429607ilo.9
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 13:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9xPqODKbeSKpNqbycqKAmanL+979Nz3jHkGsix41R6I=;
        b=8PMTd274dcnAb3TSMr95lCRI9JKG7J/puFn2ZXY5euY4YOYAdTSfF0fyw5OAZepLb2
         /54ljKVbPuTpDDJfDqMcuHjOGdnVXTjjOJDWe5cB6EsQbclHyvx4e6ETPQOOXScrYIbn
         OA5Kze+9hWmIWDDnBJHY7RvwzoDpLvSxKUw+fuWOMrzD+m0A2qAb5Nfc1lBZN8RV8Y68
         3ygyFmzn30A9B8uYiyPANnB6XLPBjleWwa8OJc6qt13zkJoSKCXXei3k3Tyo9fRHXyKl
         WUUsl7RSrJOlz0LKz54oGecNdVWYakYSHxwKWA670q7NCLPWJHJ4Kc06qvnjKHHlAwSa
         uhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9xPqODKbeSKpNqbycqKAmanL+979Nz3jHkGsix41R6I=;
        b=4PZP4oGY4nx9+f1YfM3DingMVDaxNANYOTEdHsJXroP1QhNTjiu9LYYf7wFNQ1hRjZ
         f7ZpFPkLw7fr/7qkiUSkwWDhMIWJggRo5+9sFTW4UWxuBLyIKCqr17TGeWXxMvI27hCL
         oIS7/QVIbqCotFrYYUJGDJv78UHflPD/HPS4e4I2hhw0VF3k2kKgya3l3zsuQHZg40QC
         P4kB1F6KdHNgQUJKXsoC9xIPmnvnvOdKmuQNAT0W2FtATVSSbyfn0w4U6TtV8rpVq1/B
         nyiWTkAQibvSJ+rt74Y3wP6GvNuLqSq70k1qan2vV3+XaVrfymQeh4GnFVOQ412oGJ46
         WVLg==
X-Gm-Message-State: AO0yUKV0EXqX9UqOFqLtoRdvP+urqTTKxDqTtGtVXvUXAFM4fCrrNWws
        ZbbIkUpXoJ78M79jOr4Ws/yaMzwqdT6vWAs1
X-Google-Smtp-Source: AK7set/TKlSm2PYK6u6wnIYoAZkJGvvqimxnSC6KAsilT7SfzDS9zvMJwr97OhqniFQ/9ID+e8Y06Q==
X-Received: by 2002:a92:c685:0:b0:314:1121:dd85 with SMTP id o5-20020a92c685000000b003141121dd85mr114095ilg.1.1676322312746;
        Mon, 13 Feb 2023 13:05:12 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id s8-20020a02cf28000000b003c1e434276fsm4278573jar.63.2023.02.13.13.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 13:05:12 -0800 (PST)
Message-ID: <96a542dc-c3a0-65ec-3bd0-fa1175b9bf87@kernel.dk>
Date:   Mon, 13 Feb 2023 14:05:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc (32-bit userspace and 64-bit kernel)
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <216beccc-8ce7-82a2-80ba-1befa7b3bc91@gmx.de>
 <159bfaee-cba0-7fba-2116-2af1a529603c@kernel.dk>
 <c1581c21-631d-94dd-1c0d-822fb9f19cd1@gmx.de>
 <d7345188-3e58-35e9-2c8f-657f8f813ad5@kernel.dk>
 <4a9a986b-b0f9-8dad-1fc1-a00ea8723914@gmx.de>
 <835f9206-f404-0402-35fe-549d2017ec62@gmx.de>
 <0b1946e4-1678-b442-695e-84443e7f2a86@kernel.dk>
 <ee1e92d5-6117-003a-3313-48d906dafba8@gmx.de>
 <05b6adc3-db63-022e-fdec-6558bdb83972@kernel.dk>
 <c5dcfbf1-bf00-2d2a-dba6-241f316efb92@gmx.de>
 <d37e2b43-f405-fe6f-15c4-7c9b08a093e1@gmx.de>
 <8f21a6bd-c66a-169b-6278-34a66dbcfee7@kernel.dk>
 <721b23a1-91f8-3f98-6448-6b9a70119eba@gmx.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <721b23a1-91f8-3f98-6448-6b9a70119eba@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/13/23 1:59?PM, Helge Deller wrote:
>> Yep sounds like it. What's the caching architecture of parisc?
> 
> parisc is Virtually Indexed, Physically Tagged (VIPT).

That's what I assumed, so virtual aliasing is what we're dealing with
here.

> Thanks for the patch!
> Sadly it doesn't fix the problem, as the kernel still sees
> ctx->rings->sq.tail as being 0.
> Interestingly it worked once (not reproduceable) directly after bootup,
> which indicates that we at least look at the right address from kernel side.
> 
> So, still needs more debugging/testing.

It's not like this is untested stuff, so yeah it'll generally be
correct, it just seems that parisc is a bit odd in that the virtual
aliasing occurs between the kernel and userspace addresses too. At least
that's what it seems like.

But I wonder if what needs flushing is the user side, not the kernel
side? Either that, or my patch is not flushing the right thing on the
kernel side.

Is it possible to flush it from the userspace side? Presumable that's
what we'd need on the sqe side, and then the kernel side for the cqe
filling. So probably the patch is half-way correct :-)

-- 
Jens Axboe

