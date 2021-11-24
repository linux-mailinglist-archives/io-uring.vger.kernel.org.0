Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0AA45CC28
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 19:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244619AbhKXSi5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 13:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239620AbhKXSi5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 13:38:57 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B340C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 10:35:47 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id 8so3633244qtx.5
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 10:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=in/DjmJsre7pZyqPLOE83SpCPGvaY4gyM0Go0TFST48=;
        b=ZJk1hn0TiTzgrW0oCVvnxHvUxUqepWkj4oQosBQDtyqCJ+i0CnZt1Hoouaohjvn42z
         af0h57GBiTyB6s5gN5vRpkHZfkdnid+LSE4pkZD06IGyPV+/EqMV4neaZw62JBzXoTwT
         eF/cgrracdsnMvrximIZT2KxhMI7J5yA06rXDQ7Kcn8gyV/nbLAp5d3nJuuGbTu2j7E6
         +8XjjgEYS1ylvwmrB13ZS/ZBfHcbn/v9UGLpQgmMDQpfTQQBEw5nlefq1kn1gGSR2R1b
         HPk+c6n87wUSW9pcj7NHouTqRKapZ/JMY9kkxtdOUivE+HSmbjijQL4VzTfCyaNwPYjm
         K4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=in/DjmJsre7pZyqPLOE83SpCPGvaY4gyM0Go0TFST48=;
        b=6wBu8Ul8/XiRA9vT2pr4ydzyKE6k9DddEL2fbj7XJSWnM8GW1MEFU7toQElarOmkH1
         i9GbDXJTU0I6uHc6bGxO72rf0kTqpaijHWNbwPbuPM6pDXnEVO2IVGH64d509J0ih3HL
         ai4BKIkjF+/dXhiYIHYLoXsRSJly1j96GXz3wP2px1m7KlCRYhHw71xtcWTi6Gz7EWu2
         trYrMx9JAOKIdnfmnqnWFPT9dXwrkIPfVygnMVoeAcyceYy1LEGrR++KlC2ADFdX8Szv
         b5gjv+Hpun9DNrKvhAIb1k268CfsV5Mz4I0GcsuQe8Njfk6V2GvXE114x+YjAWjLYf//
         qs+A==
X-Gm-Message-State: AOAM531MyIOti4dF2OhrLxGBwPfZZgYErb1arUbzBMIflZJOgiiUXPqn
        xgJvnslT6Pv5e0RQRUh6zOmXJM5xqEIbUQ==
X-Google-Smtp-Source: ABdhPJxMtwGVMMEdlpVrmIIAbhGenBFljfqHsGqDIvds+y9qgA6BJreGhRTg9VgHV56aoXmE8yqtDg==
X-Received: by 2002:a05:622a:14:: with SMTP id x20mr9786392qtw.1.1637778946611;
        Wed, 24 Nov 2021 10:35:46 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id g5sm251023qko.12.2021.11.24.10.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 10:35:45 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mpx7Q-0016Qq-NT; Wed, 24 Nov 2021 14:35:44 -0400
Date:   Wed, 24 Nov 2021 14:35:44 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     David Hildenbrand <david@redhat.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <20211124183544.GL5112@ziepe.ca>
References: <20211123235953.GF5112@ziepe.ca>
 <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
 <20211124132353.GG5112@ziepe.ca>
 <cca0229e-e53e-bceb-e215-327b6401f256@redhat.com>
 <20211124132842.GH5112@ziepe.ca>
 <eab5aeba-e064-9f3e-fbc3-f73cd299de83@redhat.com>
 <20211124134812.GI5112@ziepe.ca>
 <2cdbebb9-4c57-7839-71ab-166cae168c74@redhat.com>
 <20211124153405.GJ5112@ziepe.ca>
 <63294e63-cf82-1f59-5ea8-e996662e6393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63294e63-cf82-1f59-5ea8-e996662e6393@redhat.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Nov 24, 2021 at 05:43:58PM +0100, David Hildenbrand wrote:
> On 24.11.21 16:34, Jason Gunthorpe wrote:
> > On Wed, Nov 24, 2021 at 03:14:00PM +0100, David Hildenbrand wrote:
> > 
> >> I'm not aware of any where you can fragment 50% of all pageblocks in the
> >> system as an unprivileged user essentially consuming almost no memory
> >> and essentially staying inside well-defined memlock limits. But sure if
> >> there are "many" people will be able to come up with at least one
> >> comparable thing. I'll be happy to learn.
> > 
> > If the concern is that THP's can be DOS'd then any avenue that renders
> > the system out of THPs is a DOS attack vector. Including all the
> > normal workloads that people run and already complain that THPs get
> > exhausted.
> > 
> > A hostile userspace can only quicken this process.
> 
> We can not only fragment THP but also easily smaller compound pages,
> with less impact though (well, as long as people want more than 0.1% per
> user ...).

My point is as long as userspace can drive this fragmentation, by any
means, we can never have DOS proof higher order pages, so lets not
worry so much about one of many ways to create fragmentation.

> >> My position that FOLL_LONGTERM for unprivileged users is a strong no-go
> >> stands as it is.
> > 
> > As this basically excludes long standing pre-existing things like
> > RDMA, XDP, io_uring, and more I don't think this can be the general
> > answer for mm, sorry.
> 
> Let's think about options to restrict FOLL_LONGTERM usage:

Which gives me the view that we should be talking about how to make
high order pages completely DOS proof, not about FOLL_LONGTERM.

To me that is exactly what ZONE_MOVABLE strives to achieve, and I
think anyone who cares about QOS around THP must include ZONE_MOVABLE
in their solution.

In all of this I am thinking back to the discussion about the 1GB THP
proposal which was resoundly shot down on the grounds that 2MB THP
*doesn't work* today due to the existing fragmentation problems.

> Another option would be not accounting FOLL_LONGTERM as RLIMIT_MEMLOCK,
> but instead as something that explicitly matches the differing
> semantics. 

Also a good idea, someone who cares about this should really put
pinned pages into the cgroup machinery (with correct accounting!)

> At the same time, eventually work on proper alternatives with mmu
> notifiers (and possibly without the any such limits) where possible
> and required.

mmu_notifiers is also bad, it just offends a different group of MM
concerns :)

Something like io_ring is registering a bulk amount of memory and then
doing some potentially long operations against it.

So to use a mmu_notifier scheme you'd have to block the mmu_notifier
invalidate_range_start until all the operations touching the memory
finish (and suspend new operations at the same time!).

Blocking the notifier like this locks up the migration/etc threads
completely, and is destructive to the OOM reclaim.

At least with a pinned page those threads don't even try to touch it
instead of getting stuck up.

> Don't get me wrong, I really should be working on other stuff, so I have
> limited brain capacity and time :) OTOH I'm willing to help at least
> discuss alternatives.

Haha, me too..

Jason
