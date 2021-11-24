Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE6D45D0E0
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 00:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344001AbhKXXOq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 18:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343934AbhKXXOp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 18:14:45 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70701C061746
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 15:11:35 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id s9so2773196qvk.12
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 15:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j4DAkTLRTUTn6M8l4sKe/Kwq0t663JKEGap3Rg8k/6A=;
        b=B31+pIz/iV9fCE8l7Mvr9RRg9S4GUC7soBlMgxNXXxYvURePVUwIyJnxpLiDKb+oSb
         lxlp+J2bLfG9s1gnIxtjhMUCf6Z0GNSTICrpKZtYBPyqKr1C3Fdal6kb3iwUpamRHoXz
         GHdq2YmqycyjDdWUZ3sgUCUF3z61+VhXkTVkgAnSAgH++MCGjQmFosRbOO0chlfKkNH8
         fOMrZeKC/XlkO+GqjornkApRcW0V06/KYahFW7EXF8FlPGhtYBvFK1DWUzB13Zb4GnZ0
         3cvkhAbivwMRA64jWd1z0AsMlmzGUlP8vg/iH+Epq+3Mfx06gIbCZDEQ09cPjjvpKWOb
         dhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j4DAkTLRTUTn6M8l4sKe/Kwq0t663JKEGap3Rg8k/6A=;
        b=xGDDJLlT0s2eV1CmYYet3J71xDY1mDNlJQO534/s5puMw6jwFJj+5sAkhSmlXXi7OS
         G8LyU9UPyrFIgnFVn6ixsBbBP+lgHpVuLXfpHT8ssyArqpop3ZtUbwMu9cBxh/aGLnh3
         aCdyuU5HN88d/aFlSdwAC5/l8TzvEV+yr3p1i6tPRGfWDhAmHZtJf3j9AUKScEWjN3k4
         4AgjW6c5GVuj9fra4vERwckd+vwjSpZ92pHt5w5n1ynJ6z1EfR6s9rIL1yI3BjUEV/Yt
         03cCKU0Y+sCXPt2QVbLvALYOW5kfXoBh/hfWhPhZm2twEoDWefrJ5VBlcliW6oRM4hfr
         hweA==
X-Gm-Message-State: AOAM530WvQjmX/jdeVur6zh3a8csReG5OBvqlh1Thscf69Oz81jw/mT1
        hwC36RFebINtyR+D5cHr3fLtKyHsIhS4Lw==
X-Google-Smtp-Source: ABdhPJyJEaleOzcdEx/cNWyWjJvi7icetXaIFP/UFdi2V0cpZc8qe2bqd+h8H9Mz/Yok6T+eDloKYQ==
X-Received: by 2002:a0c:8031:: with SMTP id 46mr99661qva.126.1637795494565;
        Wed, 24 Nov 2021 15:11:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id h2sm606488qkn.136.2021.11.24.15.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 15:11:33 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mq1QL-001RrF-AF; Wed, 24 Nov 2021 19:11:33 -0400
Date:   Wed, 24 Nov 2021 19:11:33 -0400
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
Message-ID: <20211124231133.GM5112@ziepe.ca>
References: <20211124132353.GG5112@ziepe.ca>
 <cca0229e-e53e-bceb-e215-327b6401f256@redhat.com>
 <20211124132842.GH5112@ziepe.ca>
 <eab5aeba-e064-9f3e-fbc3-f73cd299de83@redhat.com>
 <20211124134812.GI5112@ziepe.ca>
 <2cdbebb9-4c57-7839-71ab-166cae168c74@redhat.com>
 <20211124153405.GJ5112@ziepe.ca>
 <63294e63-cf82-1f59-5ea8-e996662e6393@redhat.com>
 <20211124183544.GL5112@ziepe.ca>
 <cc9d3f3e-2fe1-0df0-06b2-c54e020161da@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc9d3f3e-2fe1-0df0-06b2-c54e020161da@redhat.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Nov 24, 2021 at 08:09:42PM +0100, David Hildenbrand wrote:

> That would be giving up on compound pages (hugetlbfs, THP, ...) on any
> current Linux system that does not use ZONE_MOVABLE -- which is not
> something I am not willing to buy into, just like our customers ;)

So we have ZONE_MOVABLE but users won't use it?

Then why is the solution to push the same kinds of restrictions as
ZONE_MOVABLE on to ZONE_NORMAL?
 
> See my other mail, the upstream version of my reproducer essentially
> shows what FOLL_LONGTERM is currently doing wrong with pageblocks. And
> at least to me that's an interesting insight :)

Hmm. To your reproducer it would be nice if we could cgroup control
the # of page blocks a cgroup has pinned. Focusing on # pages pinned
is clearly the wrong metric, I suggested the whole compound earlier,
but your point about the entire page block being ruined makes sense
too.

It means pinned pages will have be migrated to already ruined page
blocks the cgroup owns, which is a more controlled version of the
FOLL_LONGTERM migration you have been thinking about.

This would effectively limit the fragmentation a hostile process group
can create. If we further treated unmovable cgroup charged kernel
allocations as 'pinned' and routed them to the pinned page blocks it
start to look really interesting. Kill the cgroup, get all your THPs
back? Fragmentation cannot extend past the cgroup?

ie there are lots of batch workloads that could be interesting there -
wrap the batch in a cgroup, run it, then kill everything and since the
cgroup gives some lifetime clustering to the allocator you get a lot
less fragmentation when the batch is finished, so the next batch gets
more THPs, etc.

There is also sort of an interesting optimization opportunity - many
FOLL_LONGTERM users would be happy to spend more time pinning to get
nice contiguous memory ranges. Might help convince people that the
extra pin time for migrations is worthwhile.

> > Something like io_ring is registering a bulk amount of memory and then
> > doing some potentially long operations against it.
> 
> The individual operations it performs are comparable to O_DIRECT I think

Yes, and O_DIRECT can take 10s's of seconds in troubled cases with IO
timeouts and things.

Plus io_uring is worse as the buffer is potentially shared by many in
fight ops and you'd have to block new ops of the buffer and flush all
running ops before any mapping change can happen, all while holding up
a mmu notifier.

Not only is it bad for mm subsystem operations, but would
significantly harm io_uring performance if a migration hits.

So, I really don't like abusing mmu notifiers for stuff like this. I
didn't like it in virtio either :)

Jason
