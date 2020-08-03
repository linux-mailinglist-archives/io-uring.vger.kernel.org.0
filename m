Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD18C23B034
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 00:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHCWbW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 18:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgHCWbV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 18:31:21 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD7DC06174A
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 15:31:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o13so21005617pgf.0
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 15:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YZuAOxvd8CvrPIFK2B76ShtgQT/FMV6VJxz55NoaVjc=;
        b=1nBIswkFXw3POQvuo2GBKY5/mWrIocXenbsRfbbJfHlv/L9eX4syejTmCw9PU4v8Bd
         q7Jb3ccU1PMXhHpfgoNBDysb8+xNI9yR0ID/Igs2JRGxO4I0eCjcY1+FrZlUglwAJjYR
         keesJCquyDNDtIJBE+4sH0Eil3U7sxtpD1VM3x+/H51AwG2fnddY+R7T/NfjiXWjEYC5
         UTQ2aROhkmyIxYnR0qduC8ebPLxbCKBWZ1A35s751MbiTsnYPxtJZfF/nNEM1uNzS05U
         K4wDnDCGRTfqOVEULisEhff2tUg5N68er4bIUY80LNMoIsF+OMXxNXtSfwy5A0RPOzKv
         r7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YZuAOxvd8CvrPIFK2B76ShtgQT/FMV6VJxz55NoaVjc=;
        b=eybnQdIB+MbrQ+ppBKNTBIy8jeKbUb1iB01uhDESvUwOERQkZDFuiCla0MwXhnI9cW
         4ErIu6ILmTXXdLVlwxugv2GyoPXwUvDeFfpBISr8KSGHg5i7iFRqAWjLiw8IIBrI/rOm
         +2pK486Lp5HWSA5QJyXZBxNHaw+7/toJC1ry0a0C4Z6oFljpMkUfTMUks/0AeoSfe40N
         0tqK4esa7A16Qs8798UCXeqNTNDFyXumS1u1maRAHZG7fLRvdvvZqasSsdc3b1g9tVha
         UmA6VPvt7ZfUrLY5HaeSVhrZGG2WVGzPVVmR5zB0mA6Wi8S1n2gSo1yIZLQWgqnwea7C
         Zziw==
X-Gm-Message-State: AOAM533wlIQWoMQ5+SXHX3G9OCb56cYNUydyk01e5OvJen36/5N8NKze
        7d1W+WsGUMtBpJLyNHm6ql5k++DkYng=
X-Google-Smtp-Source: ABdhPJxHjGYLjQ7Ret4mHAgFqyyy4ZUGlKSQvwhrhIhBXkbED0VHzulug/vaCXaLZyHAI0x9fmgBnQ==
X-Received: by 2002:a62:206:: with SMTP id 6mr14059446pfc.228.1596493881405;
        Mon, 03 Aug 2020 15:31:21 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w70sm20325748pfc.98.2020.08.03.15.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 15:31:20 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring changes for 5.9-rc1
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk>
 <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
 <CAHk-=wjztm0K9e_62KZj9vJXhmid-=euv-pOHg97LUbHyPKwzA@mail.gmail.com>
 <20200803211050.ib2km76lch5abnjb@chatter.i7.local>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <829a70b8-f1fe-a31b-c380-14c7bb1862b6@kernel.dk>
Date:   Mon, 3 Aug 2020 16:31:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803211050.ib2km76lch5abnjb@chatter.i7.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/20 3:10 PM, Konstantin Ryabitsev wrote:
> On Mon, Aug 03, 2020 at 01:53:12PM -0700, Linus Torvalds wrote:
>> On Mon, Aug 3, 2020 at 1:48 PM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> I've pushed out my merge of this thing [..]
>>
>> It seems I'm not the only one unhappy with the pull request.
>>
>> For some reason I also don't see pr-tracker-bot being all happy and
>> excited about it. I wonder why.
> 
> My guess it's because the body consists of two text/plain MIME-parts and 
> Python returned the merge.txt part first, where we didn't find what we 
> were looking for.
> 
> I'll see if I can teach it to walk all text/plain parts looking for 
> magic git pull strings instead of giving up after the first one.

Thanks, I was a bit puzzled on that one too, and this time it definitely
wasn't because the tag wasn't there.

In terms of attachments, I'm usually a fan of inlining, but seemed cleaner
to me to attach the merge resolution as there's already a ton of other
stuff in that email.

-- 
Jens Axboe

