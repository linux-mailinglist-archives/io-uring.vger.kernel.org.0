Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23692253025
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 15:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgHZNod (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 09:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730343AbgHZNoZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 09:44:25 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C3DC061574
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 06:44:23 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id p18so1775211ilm.7
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 06:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8NZJ0tWpVVwQWOQP+IkR38P3PYN2XAuCciULon8NyLo=;
        b=e8o2x49tRGCZC6L0X0XK3rhT+5eQVheHrcl7F4IVlCNfctEJuCwf0oyNUcBrGKVMLC
         pgtd4ie9n7TfD8gDpGAItdKCu5+FBop5NIsf1OAc9lsu1XqPSj+LeTZsEKXAX2pnrJJ5
         vZnNY97tY7niUilAkWrPdlD/fk5UpTHZdZ6X28MbbVZu+WWKypXHIm8hT9B4RqAPkd35
         l8HHJN6cZvlMXakS0ZUGsZlTNCgKaOou1hpu8Kps5A+rDLGhZ5FOT/YPuaQJZWEkBsiP
         5HycTUBM2Gc2oPvhP7/j4odWEaxC752XMKumPBCsEz/I/+/mdX9LotixFOqD/a9b8w3K
         Encg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8NZJ0tWpVVwQWOQP+IkR38P3PYN2XAuCciULon8NyLo=;
        b=e+Lu1egySJ1iP633eKhejmVxywxJcVmD44OkUoZGoKooaQ0ENccTZE5onfVWmX6bOt
         Oi8UcKEpDXhfw6vV+5UXXhf+C3RHy4Al6Ln/28swxw7rqhQkPm+Mk1VJBp5nWj95OThK
         h0FkgGcwQX2nmZxhq2TzsG5mdOruB+L8XfJ8IM7f7THG51QX4BnC4ZBIPQh8rjig73eU
         MUt8Ddr64g+D20Dz9WNJx7gM+1Z0PusdzzIAsaLStaSwNZly32/r2xXrCJd77OLqkAzQ
         SBzByUxMtsln+0uXPoEfZ3n/OZczDCEy9DBQldAIEBbwvD1S/qt0X/rFtfniKBaS3qOW
         rvvg==
X-Gm-Message-State: AOAM532niZ01hOqvC6ha9Z2cSkJOECItXDgS6hy8kMF5COVBEHq8TtMc
        SrP5S9jz7DNRwH2PLQ6CY+hX+w==
X-Google-Smtp-Source: ABdhPJzFeEwOe7UrNKZQyg7JpWDBifLppOUoW/1B6BMv4yopMQoSB1eijdVCkYE7uz9b96U8OOeG2w==
X-Received: by 2002:a92:6c09:: with SMTP id h9mr13864150ilc.46.1598449462991;
        Wed, 26 Aug 2020 06:44:22 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c12sm1374045ilq.79.2020.08.26.06.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 06:44:22 -0700 (PDT)
Subject: Re: io_uring file descriptor address already in use error
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
 <639db33b-08f2-4e10-8f06-b6d345677df8@kernel.dk>
 <308222a7-8bd2-44a6-c46c-43adf5469fa3@kernel.dk>
 <c07b29d1-fff4-3019-4cba-0566c8a75fd0@kernel.dk>
 <CAAss7+rKt6Eh7ozCz5syJSOjVVaZnrVSXi8zS8MxuPJ=kcUwCQ@mail.gmail.com>
 <ab3ddb12-c3ca-5ebb-32ff-d041f8eb20d1@kernel.dk>
 <CAAss7+o5_74C3tG09Yw2KaL4B7vVg68aNf=UF-YmTaNGokSOfQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <432c76f2-9893-83b0-5cee-b001070f886d@kernel.dk>
Date:   Wed, 26 Aug 2020 07:44:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+o5_74C3tG09Yw2KaL4B7vVg68aNf=UF-YmTaNGokSOfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/20 9:01 PM, Josef wrote:
>> In order for the patch to be able to move ahead, we'd need to be able
>> to control this behavior. Right now we rely on the file being there if
>> we need to repoll, see:
>>
>> commit a6ba632d2c249a4390289727c07b8b55eb02a41d
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Fri Apr 3 11:10:14 2020 -0600
>>
>>     io_uring: retry poll if we got woken with non-matching mask
>>
>> If this never happened, we would not need the file at all and we could
>> make it the default behavior. But don't think that's solvable.
>>
>>> is there no other way around to close the file descriptor? Even if I
>>> remove the poll, it doesn't work
>>
>> If you remove the poll it should definitely work, as nobody is holding a
>> reference to it as you have nothing else in flight. Can you clarify what
>> you mean here?
>>
>> I don't think there's another way, outside of having a poll (io_uring
>> or poll(2), doesn't matter, the behavior is the same) being triggered in
>> error. That doesn't happen, as mentioned if you do epoll/poll on a file
>> and you close it, it won't trigger an event.
>>
>>> btw if understood correctly poll remove operation refers to all file
>>> descriptors which arming a poll in the ring buffer right?
>>> Is there a way to cancel a specific file descriptor poll?
>>
>> You can cancel specific requests by identifying them with their
>> ->user_data. You can cancel a poll either with POLL_REMOVE or
>> ASYNC_CANCEL, either one will find it. So as long as you have that, and
>> it's unique, it'll only cancel that one specific request.
> 
> thanks it works, my bad, I was not aware that user_data is associated
> with the poll request user_data...just need to remove my server socket
> poll which binds to an address so I think this patch is not really
> necessary
> 
> btw IORING_FEAT_FAST_POLL feature which arming poll for read events,
> how does it work when the file descriptor(not readable yet) wants to
> read(non blocking) something and I close(2) the file descriptor? I'm
> guessing io_uring doesn't hold any reference to it anymore right?

Most file types will *not* notify you through poll if they get closed,
so it'll just sit there until canceled. This is the same with poll(2) or
epoll(2). io_uring will continue to hold a reference to the file, it
does that over request completion for any request that uses a file.

-- 
Jens Axboe

