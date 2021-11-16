Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E97E453A4F
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 20:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239960AbhKPToB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 14:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbhKPToA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 14:44:00 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC93C061570
        for <io-uring@vger.kernel.org>; Tue, 16 Nov 2021 11:41:03 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id i11so271772ilv.13
        for <io-uring@vger.kernel.org>; Tue, 16 Nov 2021 11:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gCwZVwpoJeaJCb5/6fK67L0swcN4dpoDE8WnNZs2ToY=;
        b=dTtYPdHq5lvt9GBufnyfjUA/x2lqL9wHfQevWzCSzSBHK0OulY8nG8v5nfFWRzVnGH
         aPbfowVmkDoZMckvahvJbWqMciMQOGHOJ75j8QZlrefV4Rvycr+E6PulYSc65Jyztnok
         Sl+0tn99H+TH4uAoyFYX+9VbFsxZQ76kIqu2WrlopgrRUz4028WjbtS5stw9L1LWPfLk
         FVMi0xLpa7hbv2Wsj4OvfdTPSPKHCNtHA1h+j/x0i6xNMtajKs32mG1O4LW+JoBj0chN
         +64qE7wgNv7zZf86tSkEjcPfWVGcGgwZO5GuIVrQDk7Mq2XIVk43/+EaKlkdNyfi1Ie4
         BVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gCwZVwpoJeaJCb5/6fK67L0swcN4dpoDE8WnNZs2ToY=;
        b=Ov+WTEYyMbB9SigzxMzjsuh4PsWxWxqPbA9lpDnBhq1mUCLzj/vSONUSFd48eYG22N
         W+ChylKT/WshkdU3+Hb1Da11BPDnELYCuH73LOZKdoeYx4iVqcoxkuN27PMeuY5nO2QR
         LVWsdoOtA7iE56uSAc/iqg7jNj9Nh7OPpbK/xbQ6xhsTB+uRbV+h4ZX5cHQST2jqKOs5
         Pj2NRkYXmzHE481W7WUwTPn8j2enfUNlnOo0AhoCQ67pK0EpAO3etgVV//fFsoE8DkxR
         SoI4/2ZOgFAgjvWxXLejcmj0yNwMYShble+aI9bSTJLTY7gvpOFElx9fFftd2F0xQtIb
         Yktg==
X-Gm-Message-State: AOAM532EvvH0L/+FWvEOx/9RvKE5SqSl0SjYRANwdacDKVuYsPgDrRRL
        PSH1eKbPDY51of3HVoVbMSXvQg==
X-Google-Smtp-Source: ABdhPJyQ4KzDMpmAsfIa7lC2q8hhzfJvbCXYbia8UvBuaOpKyggSYTKPQmq2wc1YWqZv61rvd9Ik2w==
X-Received: by 2002:a05:6e02:19cd:: with SMTP id r13mr6423937ill.119.1637091662675;
        Tue, 16 Nov 2021 11:41:02 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y12sm13482221ill.71.2021.11.16.11.41.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 11:41:02 -0800 (PST)
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
To:     Vito Caputo <vcaputo@pengaru.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <YZP6JSd4h45cyvsy@casper.infradead.org>
 <b97f1b15-fbcc-92a4-96ca-e918c2f6c7a3@kernel.dk>
 <20211116192148.vjdlng7pesbgjs6b@shells.gnugeneration.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <475f4f4d-47cc-19b7-fb02-6227fd5a1362@kernel.dk>
Date:   Tue, 16 Nov 2021 12:41:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211116192148.vjdlng7pesbgjs6b@shells.gnugeneration.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/16/21 12:21 PM, Vito Caputo wrote:
> On Tue, Nov 16, 2021 at 11:55:41AM -0700, Jens Axboe wrote:
>> On 11/16/21 11:36 AM, Matthew Wilcox wrote:
>>> On Mon, Nov 15, 2021 at 08:35:30PM -0800, Andrew Morton wrote:
>>>> I'd also be interested in seeing feedback from the MM developers.
>>> [...]
>>>> Subject: Increase default MLOCK_LIMIT to 8 MiB
>>>
>>> On the one hand, processes can already allocate at least this much
>>> memory that is non-swappable, just by doing things like opening a lot of
>>> files (allocating struct file & fdtable), using a lot of address space
>>> (allocating page tables), so I don't have a problem with it per se.
>>>
>>> On the other hand, 64kB is available on anything larger than an IBM XT.
>>> Linux will still boot on machines with 4MB of RAM (eg routers).  For
>>> someone with a machine with only, say, 32MB of memory, this allows a
>>> process to make a quarter of the memory unswappable, and maybe that's
>>> not a good idea.  So perhaps this should scale over a certain range?
>>>
>>> Is 8MB a generally useful amount of memory for an iouring user anyway?
>>> If you're just playing with it, sure, but if you have, oh i don't know,
>>> a database, don't you want to pin the entire cache and allow IO to the
>>> whole thing?
>>
>> 8MB is plenty for most casual use cases, which is exactly the ones that
>> we want to "just work" without requiring weird system level
>> modifications to increase the memlock limit.
>>
> 
> Considering a single fullscreen 32bpp 4K-resolution framebuffer is
> ~32MiB, I'm not convinced this is really correct in nearly 2022.

You don't need to register any buffers, and I don't expect any basic
uses cases to do so. Which means that the 8MB just need to cover the
ring itself, and you can fit a _lot_ of rings into 8MB. The memlock
limit only applies to buffers if you register them, not for any "normal"
use cases where you just pass buffers for read/write or O_DIRECT
read/write.

> If we're going to bump the default at the kernel, I'm with Matthew on
> making it autoscale within a sane range, depending on available
> memory.

I just don't want to turn this into a bikeshedding conversation. I'm
fine with making it autoscale obviously, but who's going to do the work?

> As an upper bound I'd probably look at the highest anticipated
> consumer resolutions, and handle a couple fullscreen 32bpp instances
> being pinned.

Not sure I see the relevance here.

-- 
Jens Axboe

