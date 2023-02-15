Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8AE6985B3
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 21:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjBOUiE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 15:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjBOUhx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 15:37:53 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9DE42DC8
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 12:37:46 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id d16so7608288ioz.12
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 12:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676493466;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PrkDG495JT5jJxasz0lULim4hK80dGGHdBfRwWvEZkQ=;
        b=RPv+mkthx4oE9y+OK8bv40r5XjJ3pWctpZu9h4j+VGIS6YWNelk6cvKYAGUpSgmiV4
         mnz2XwN43t+KlCo13toN1LeeQ7geHDXd06ZHEbn/2CQl+z09XJRRW4ZEYycpQ4v+J139
         J/4DaYgbhtSqW0yKzT6gthOQiIzZkML9kOqnggxoIW1grVSsuFytwXzeZPKB91S4KapM
         IZcoN5vWByTn9QCHMK6FDOcQL9TnF4g7WVO/TXWFFimYs4QxO8++ZFutAwThePq06aMG
         Tdl6cdP9JiV3ehevE5U5uQs7IJsuxQQxmzRQecbyPDYJnqWQQJBbOTghxER0f114BQHg
         ZUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676493466;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PrkDG495JT5jJxasz0lULim4hK80dGGHdBfRwWvEZkQ=;
        b=DMSwdTo0rNjPJpNm0U83CX7kR9FnwCzAFEwyE+XW2t61Vaf7rki+1VYduGCgBpG3FS
         tEUXNl+ihsv0wWHKZ4/OADBGk68Kuha4kwoktwCRYlIYuViFU8kT0HbGnk4Hw/Ub2C4I
         luKaNGtJhfYwfScyE9XmSN525uO258HZZvIq/w/yxmvM7CCLFLnn87F6N/JQZ025JPLB
         l2ePgeA10pRN2MlOPNaIAH8EbIUjuLnVOnsBScxh0I+GdkZ/M251BUv5JRlAU/nDn4Oz
         c2QbtsyuLjeJVrCeWIJuF1wXOBHfvnv17gQoZOzlxa4rHGAiGyD7+7iafv7i+O9/b82e
         ZwlA==
X-Gm-Message-State: AO0yUKVzv/qiUiUJ5aRWJ38iNgN2pzg7229nwnZ02lrWd5+4YYyeLzgY
        coOya7uiW3WrOwe13qABQbICwA==
X-Google-Smtp-Source: AK7set93Ycv5nwSwt0hsbOsta66VZCWNHJAPIfBhb15oX8ppTbO40FavEVYNNNyYblG5/xcnSOY0RQ==
X-Received: by 2002:a6b:b493:0:b0:718:2903:780f with SMTP id d141-20020a6bb493000000b007182903780fmr2447928iof.2.1676493465814;
        Wed, 15 Feb 2023 12:37:45 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y3-20020a02bb03000000b003b331f0bbdfsm5930302jan.97.2023.02.15.12.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 12:37:45 -0800 (PST)
Message-ID: <d8dc9156-c001-8181-a946-e9fdfe13f165@kernel.dk>
Date:   Wed, 15 Feb 2023 13:37:44 -0700
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
 <a03d75b9-a9b8-b950-c53d-6df85fe8adc4@kernel.dk>
 <07810314-94f6-0e9a-984b-0a286cbb59d3@kernel.dk>
 <4f4f9048-b382-fa0e-8b51-5a0f0bb08402@kernel.dk>
 <99a41070-f334-f3cb-47cd-8855c938d71f@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <99a41070-f334-f3cb-47cd-8855c938d71f@bell.net>
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

On 2/15/23 1:27?PM, John David Anglin wrote:
> On 2023-02-15 2:16 p.m., Jens Axboe wrote:
>> In any case, with the silly syzbot mmap stuff fixed up, I'm not seeing
>> anything odd. A few tests will time out as they simply run too slowly
>> emulated for me, but apart from that, seems fine. This is running with
>> Helge's patch, though not sure if that is required running emulated.
> I'm seeing two problematic tests:
> 
> test buf-ring.t generates on console:
> TCP: request_sock_TCP: Possible SYN flooding on port 8495. Sending
> cookies.  Check SNMP counters.

Pretty sure that's from connect.t, not from buf-ring.t. But yes, this
happens on all platforms, haven't looked into it. The test works, but
would be nice to clean that up.

> System crashes running test buf-ring.t.

Huh, what's the crash?

> Running test buf-ring.t bad run 0/0 = -233

THis one, and the similar -223 ones, you need to try and dig into that.
It doesn't reproduce for me, and it very much seems like the test case
having a different view of what -ENOBUFS looks like and hence it fails
when the kernel passes down something that is -ENOBUFS internally, but
doesn't match the app -ENOBUFS value. Are you running a 64-bit kernel?
Would that cause any differences?

I don't see this on qemu with the 32-bit kernel, nor does it happen on
other platforms.

-- 
Jens Axboe

