Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B881BE8DE
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 22:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD2UnQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 16:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2UnQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 16:43:16 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F403BC03C1AE
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 13:43:15 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p8so1576108pgi.5
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W7cpwTMCZ5s9qLdDVhDgMM5D9nIhte/z+nTmmXnhGpg=;
        b=yJlxzendIOfZTw7diYHP8aJsTPEO8BhSVhvyFoSvV7hwgXFx8HG6L4x4OuygrTLOVq
         46hJL3TvkCEWr1ZSkjOVZDY14ne2kcNLh61DxJgwIOF0UskcyCqkzmdOpVxe//5mVLPq
         L+whk3deAyFMKD8/O4ySI8g50sVvqk1U7XzAeih+zHKtKNnkwMVJFgbIMpVaEqsSVOKT
         5jiAEfucLk2ZtAbjrqk92LrElWdM6v1ZcC4ZOg/DAfUBQuuaVkXNHqdbp/orpUGkLHfD
         B1GRMiO+LBup0/n7Hw7OM77vTXgR8H06AmbhgJxhx90BC/Ypq6S1fRjq13HuWC95k5Sl
         WunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W7cpwTMCZ5s9qLdDVhDgMM5D9nIhte/z+nTmmXnhGpg=;
        b=tI0iDL2Z5oG9pzPH3kcDdNFNfBwi/5tQBi3qj4B3B1f8+sQ49YU8Hx4HeE80kyFeTR
         7m9uH9pKpNvTNAdkUUC34xtoxM36HimLIl4FUp+eOg7UHKgxG338JQgdd/5eXMr1jNVV
         acVcXvQbQF9O8OD9PsNkNOSy1/Z25SRlwFDGAvbgTOh5GwqvFknun0/9qgKqLC1TnEKt
         Z7w1SioXYd0n2tcZXUg6baBKo4xI46gR3BKtJFo58shdSMjrY7KCdaZPMNXS6CqzYV/3
         pLPLB1+A6ugg2laZ8Xw4NShn74yhmA532lUqb/OPb5mv40+Rm0aV8C3Ob4pNToXoFmUN
         FGnA==
X-Gm-Message-State: AGi0PuZk2vhMjjYMSYSmwXaWmababGVQdAz43nc2SgFRCEE3gu54hoqi
        3oXbWoLLbkTwXlkW576b5j3LIyw82UU2vw==
X-Google-Smtp-Source: APiQypIleVgcRwPPBep1quW6p8X24QdzJ/0kBIiXpawBGcngfI6bDhWfnMcVWt2PNcjxm4hQM8PCsg==
X-Received: by 2002:a63:b954:: with SMTP id v20mr39743pgo.100.1588192994956;
        Wed, 29 Apr 2020 13:43:14 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id h8sm1647405pfo.143.2020.04.29.13.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 13:43:14 -0700 (PDT)
Subject: Re: Build 0.6 version fail on musl libc
To:     =?UTF-8?Q?Milan_P=2e_Stani=c4=87?= <mps@arvanta.net>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org
References: <20200428192956.GA32615@arya.arvanta.net>
 <04edfda7-0443-62e1-81af-30aa820cf256@kernel.dk>
 <20200429152646.GA17156@infradead.org>
 <e640dbcc-b25d-d305-ac97-a4724bd958e2@kernel.dk>
 <6528f839-274d-9d46-dea6-b20a90ac8cf8@kernel.dk>
 <20200429193315.GA31807@arya.arvanta.net>
 <4f9df512-75a6-e4ca-4f06-21857ac44afb@kernel.dk>
 <20200429200158.GA3515@arya.arvanta.net>
 <962a1063-7986-fba9-f64e-05f6770763bc@kernel.dk>
 <20200429203844.GA25859@arya.arvanta.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bcfe40db-ebcd-df5c-ca18-4a867c9d1e1e@kernel.dk>
Date:   Wed, 29 Apr 2020 14:43:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429203844.GA25859@arya.arvanta.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/20 2:38 PM, Milan P. Stanić wrote:
> On Wed, 2020-04-29 at 14:08, Jens Axboe wrote:
>> On 4/29/20 2:01 PM, Milan P. Stanić wrote:
>>> On Wed, 2020-04-29 at 13:38, Jens Axboe wrote:
>>>> On 4/29/20 1:33 PM, Milan P. Stanić wrote:
>>>>> On Wed, 2020-04-29 at 10:14, Jens Axboe wrote:
>>>>>> On 4/29/20 9:29 AM, Jens Axboe wrote:
>>>>>>> On 4/29/20 9:26 AM, Christoph Hellwig wrote:
>>>>>>>> On Wed, Apr 29, 2020 at 09:24:40AM -0600, Jens Axboe wrote:
>>>>>>>>>
>>>>>>>>> Not sure what the best fix is there, for 32-bit, your change will truncate
>>>>>>>>> the offset to 32-bit as off_t is only 4 bytes there. At least that's the
>>>>>>>>> case for me, maybe musl is different if it just has a nasty define for
>>>>>>>>> them.
>>>>>>>>>
>>>>>>>>> Maybe best to just make them uint64_t or something like that.
>>>>>>>>
>>>>>>>> The proper LFS type would be off64_t.
>>>>>>>
>>>>>>> Is it available anywhere? Because I don't have it.
>>>>>>
>>>>>> There seems to be better luck with __off64_t, but I don't even know
>>>>>> how widespread that is... Going to give it a go, we'll see.
>>>>>
>>>>> AFAIK, __off64_t is glibc specific, defined in /usr/include/fcntl.h:
>>>>> ------
>>>>> # ifndef __USE_FILE_OFFSET64
>>>>> typedef __off_t off_t;
>>>>> # else
>>>>> typedef __off64_t off_t;
>>>>> # endif
>>>>> ------
>>>>>
>>>>> So, this will not work on musl based Linux system, git commit id
>>>>> b5096098c62adb19dbf4a39b480909766c9026e7 should be reverted. But you
>>>>> know better what to do.
>>>>>
>>>>> I come with another quick and dirty patch attached to this mail but
>>>>> again  I think it is not proper solution, just playing to find (maybe)
>>>>> 'good enough' workaround.
>>>>
>>>> Let's just use uint64_t.
>>>
>>> This works. Thanks.
>>>
>>> Next issue is this:
>>> ----
>>> make[1]: Entering directory '/work/devel/liburing/src'
>>>      CC setup.ol
>>>      CC queue.ol
>>>      CC syscall.ol
>>> In file included from syscall.c:9:
>>> include/liburing/compat.h:6:2: error: unknown type name 'int64_t'
>>>     6 |  int64_t  tv_sec;
>>>       |  ^~~~~~~
>>> make[1]: *** [Makefile:43: syscall.ol] Error 1
>>> make[1]: Leaving directory '/work/devel/liburing/src'
>>> make: *** [Makefile:12: all] Error 2
>>> ----
>>>
>>> I fixed it with this patch:
>>> --
>>> diff --git a/configure b/configure
>>> index 30b0a5a..4b44177 100755
>>> --- a/configure
>>> +++ b/configure
>>> @@ -301,6 +301,7 @@ EOF
>>>  fi
>>>  if test "$__kernel_timespec" != "yes"; then
>>>  cat >> $compat_h << EOF
>>> +#include <stdint.h>
>>>  struct __kernel_timespec {
>>>   int64_t   tv_sec;
>>>   long long tv_nsec;
>>> --
>>>
>>> but not sure will that work on glibc.
>>
>> That should work fine on glibc. Care to send as an actual
>> patch, with commit message and signed-off-by? Then I'll add
>> it to liburing.
> 
> patch is attached.

Great thanks, I added a bit to your commit message. Here it is:

https://git.kernel.dk/cgit/liburing/commit/?id=8171778c835b6be517c314cf23dd1f5ae061a117

-- 
Jens Axboe

