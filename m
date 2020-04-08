Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F451A254F
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 17:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgDHPgi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 11:36:38 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35887 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgDHPgh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 11:36:37 -0400
Received: by mail-pl1-f195.google.com with SMTP id g2so2639779plo.3
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 08:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4QtBX8zqt0psI5xle1/VeTHTPRLFFHHPE+bjAvQKxGM=;
        b=o5PM0zYpfOX6ezXUacyFtaF/E/5UFUnvhuGmddc+BAJ1vN+pEDEkG8yt1TrGUI2zhF
         VieJTq23vpQw82gtQCt61bvDPUzEg20Uzp1bxCA1ZndWyJOIyLyUr86Qicw423qPbqGo
         jRT8J87jy1jeXOLauzH9itNo5mIuKzMr3eW2Oyd8gM8Wikgba5u/yVwsZgCpTEujlokQ
         a6nT64RcwNCUj6XG+KJgAqmd5MNzhoEDM6UonIS1GroQh6OAjT2A7xc0TEaaWbky6Dtr
         3dYNSfYbRe2W9yIBAzLNhje7PuRNXGtmY9W+wtCxdLa6KBvhiNrNvucZ+NJ56S2SR518
         uP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4QtBX8zqt0psI5xle1/VeTHTPRLFFHHPE+bjAvQKxGM=;
        b=F27xzYQKilvw8nRSrjnYYAnG1/7ch6dABYBT/f/D+vweHRpYFXkwO6lRhd2nB6jUlI
         YvbCynoCnyBL8GpvZSRXf4gFp6bUqSYBa5bstGfqW3M2mue4y8v+EkGi7ZZQApJ4PS0c
         U7suCu1mAj/O28k3fa8LK8E3kLfDv58qlEimNREzjVBYzbsRBUCl7cy54e0Si2vUfpr3
         tkxW1SrA+XXazlPnJX7HDY5zyOktNlBBYKExGfh/ul7r8kJig+F5om/WtS5Jv0BMbYjw
         xHi7NgQNC/AKqKEqlDluEnTbi4D8dD9YlAjR9Zt6yJ7B2B1zv94Hb93XZvjCvRqufY1K
         zPYw==
X-Gm-Message-State: AGi0PuZVgnlWPErT4rSbAiVqIKyqHpBke9RKGAgAMuQGD4BaRCAlSVrj
        2sXRQnNXO1r2CcHf8HGypqRqlrOC70V04A==
X-Google-Smtp-Source: APiQypKJ0rmMTmfPvdslTL21//xSupTC0lEdC+RTFxE7HyEuOpoljcTaeI49M5neect9ifRzH/nnqg==
X-Received: by 2002:a17:90a:3343:: with SMTP id m61mr3415018pjb.112.1586360195397;
        Wed, 08 Apr 2020 08:36:35 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4466:6b33:f85b:7770? ([2605:e000:100e:8c61:4466:6b33:f85b:7770])
        by smtp.gmail.com with ESMTPSA id y22sm16946133pfr.68.2020.04.08.08.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 08:36:34 -0700 (PDT)
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk>
 <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk>
Date:   Wed, 8 Apr 2020 08:36:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 8:30 AM, Dmitry Kadashev wrote:
> On Wed, Apr 8, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
>>> Hi,
>>>
>>> io_uring's openat seems to produce FDs that are incompatible with
>>> large files (>2GB). If a file (smaller than 2GB) is opened using
>>> io_uring's openat then writes -- both using io_uring and just sync
>>> pwrite() -- past that threshold fail with EFBIG. If such a file is
>>> opened with sync openat, then both io_uring's writes and sync writes
>>> succeed. And if the file is larger than 2GB then io_uring's openat
>>> fails right away, while the sync one works.
>>>
>>> Kernel versions: 5.6.0-rc2, 5.6.0.
>>>
>>> A couple of reproducers attached, one demos successful open with
>>> failed writes afterwards, and another failing open (in comparison with
>>> sync  calls).
>>>
>>> The output of the former one for example:
>>>
>>> *** sync openat
>>> openat succeeded
>>> sync write at offset 0
>>> write succeeded
>>> sync write at offset 4294967296
>>> write succeeded
>>>
>>> *** sync openat
>>> openat succeeded
>>> io_uring write at offset 0
>>> write succeeded
>>> io_uring write at offset 4294967296
>>> write succeeded
>>>
>>> *** io_uring openat
>>> openat succeeded
>>> sync write at offset 0
>>> write succeeded
>>> sync write at offset 4294967296
>>> write failed: File too large
>>>
>>> *** io_uring openat
>>> openat succeeded
>>> io_uring write at offset 0
>>> write succeeded
>>> io_uring write at offset 4294967296
>>> write failed: File too large
>>
>> Can you try with this one? Seems like only openat2 gets it set,
>> not openat...
> 
> I've tried specifying O_LARGEFILE explicitly, that did not change the
> behavior. Is this good enough? Much faster for me to check this way
> that rebuilding the kernel. But if necessary I can do that.

Not sure O_LARGEFILE settings is going to do it for x86-64, the patch
should fix it though. Might have worked on 32-bit, though.

> Also, forgot to mention, this is on x86_64, not sure if O_LARGEFILE is
> necessary to do 2G+ files there?

Internally, yes.

-- 
Jens Axboe

