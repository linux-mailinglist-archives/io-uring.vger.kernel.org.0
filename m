Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00A3216ECD
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 16:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGGOcC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 10:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgGGOcC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 10:32:02 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E4FC08C5E2
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 07:32:02 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id l1so1424395ioh.5
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 07:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K9wtGrRmm/8ioPgsuW/ScKzBbF1VAv0JgQlxPuaeZjA=;
        b=JGTzfnCq2nLpWgT0i7AllodECtqIXc0lJai/AdmQNrYkIOD+LRzHS62If436OjZZ3y
         gz7dHtnAhIElDndYwbPYyOpuDSH5GBd1lLBu+mL2tIY6ACa6KkahSdPTT3meGSRzwu3m
         8QUYEGRFeuLy2VcuM6yGDL7mJsQqncBHsTwuuWbTXerN0cEGb0mJz72UJItyM9bOwI8j
         ikQNiuc6d5gMEHhSVqb7alcfRt+DtPS++HhgDfhX/VUmJGPByXmQ08e8+M7nV19M425K
         xU7PDUIhdH/MJn7F07/L4BHgx/xR9sC46PGo26+B4ZYGbMw7rFzNXV/zrK3oGsXJ9wNy
         W+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K9wtGrRmm/8ioPgsuW/ScKzBbF1VAv0JgQlxPuaeZjA=;
        b=QzFztpQlNMXajeriqnxtbJtEW7D1EvNsy89dhBcmMmfuHHpCN09IESqzI8hjGSIpJ7
         ecCbIrSfGrSn2ZY1B8tkZL9ctl5EE8GitvURL8cDTN0t8oJ4XKTE+9lwfRmVevAcHkft
         Nn1tDNrqO/FzED4q1hotERu7zmciX3Fe9pI6GNgfkaVlu2icCj//sx+vrbcVnlqISYid
         NhfInj9g4ZhvGUkLNhosgJAnbw+n7YCtjq2frz/0uaox0DsqIFSU+DoqnN0gFAQDar54
         sCxNwdFxdriz3DRuLNJzG4R7iRo35vaaQOBH/fsx0svd8XewCssCC9f/KBx6Cs7ZE8qa
         Q6cg==
X-Gm-Message-State: AOAM533R4jdMc3Vvcbz5vST0+ewzoX0XKA15e7YktOJrZ2DhF+F5CB1Q
        8AV9zfDlYzJjqWwZpE+goqjMYg==
X-Google-Smtp-Source: ABdhPJxwqxcaRrvKoFd0HyQLe2vIc0kunz65FpiBhfVS0IaAWWJE8PhV/N97KGvKH2kLRP5T0Bk2Ag==
X-Received: by 2002:a05:6602:5db:: with SMTP id w27mr31920956iox.58.1594132320139;
        Tue, 07 Jul 2020 07:32:00 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l10sm12956943ilc.52.2020.07.07.07.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 07:31:59 -0700 (PDT)
Subject: Re: [PATCH 05/15] mm: allow read-ahead with IOCB_NOWAIT set
To:     =?UTF-8?Q?Andreas_Gr=c3=bcnbacher?= <andreas.gruenbacher@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-6-axboe@kernel.dk>
 <20200624010253.GB5369@dread.disaster.area>
 <20200624014645.GJ21350@casper.infradead.org>
 <bad52be9-ae44-171b-8dbf-0d98eedcadc0@kernel.dk>
 <70b0427c-7303-8f45-48bd-caa0562a2951@kernel.dk>
 <20200624164127.GP21350@casper.infradead.org>
 <8835b6f2-b3c5-c9a0-2119-1fb161cf87dd@kernel.dk>
 <CAHpGcMJsrQXX4OQe6MqjyTt8BOLZw-y1ixdk76p_DsZONyEJcQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b147aa47-940c-c641-3dac-8d99f8789a47@kernel.dk>
Date:   Tue, 7 Jul 2020 08:31:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAHpGcMJsrQXX4OQe6MqjyTt8BOLZw-y1ixdk76p_DsZONyEJcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 5:38 AM, Andreas Grünbacher wrote:
> Am Mi., 24. Juni 2020 um 18:48 Uhr schrieb Jens Axboe <axboe@kernel.dk>:
>>
>> On 6/24/20 10:41 AM, Matthew Wilcox wrote:
>>> On Wed, Jun 24, 2020 at 09:35:19AM -0600, Jens Axboe wrote:
>>>> On 6/24/20 9:00 AM, Jens Axboe wrote:
>>>>> On 6/23/20 7:46 PM, Matthew Wilcox wrote:
>>>>>> I'd be quite happy to add a gfp_t to struct readahead_control.
>>>>>> The other thing I've been looking into for other reasons is adding
>>>>>> a memalloc_nowait_{save,restore}, which would avoid passing down
>>>>>> the gfp_t.
>>>>>
>>>>> That was my first thought, having the memalloc_foo_save/restore for
>>>>> this. I don't think adding a gfp_t to readahead_control is going
>>>>> to be super useful, seems like the kind of thing that should be
>>>>> non-blocking by default.
>>>>
>>>> We're already doing memalloc_nofs_save/restore in
>>>> page_cache_readahead_unbounded(), so I think all we need is to just do a
>>>> noio dance in generic_file_buffered_read() and that should be enough.
>>>
>>> I think we can still sleep though, right?  I was thinking more
>>> like this:
>>>
>>> http://git.infradead.org/users/willy/linux.git/shortlog/refs/heads/memalloc
>>
>> Yeah, that's probably better. How do we want to handle this? I've already
>> got the other bits queued up. I can either add them to the series, or
>> pull a branch that'll go into Linus as well.
> 
> Also note my conflicting patch that introduces a IOCB_NOIO flag for
> fixing a gfs2 regression:
> 
> https://lore.kernel.org/linux-fsdevel/20200703095325.1491832-2-agruenba@redhat.com/

Yeah I noticed, pretty easy to resolve though.

-- 
Jens Axboe

