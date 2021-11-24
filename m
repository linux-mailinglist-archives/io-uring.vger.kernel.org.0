Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936DA45CC35
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 19:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350695AbhKXSky (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 13:40:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239871AbhKXSky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 13:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637779063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QTMdcW1a7aBYkK74A5mXp+DK4hRD6WGOPvz9bMgTtaM=;
        b=XWJ9KYgn4ImrNJVwt46bj/IXhgzRbI/UnW2eSQKITxuSpqPwxzgoY4xDaqCfH0jFOL601a
        RsQsNVTJbHIkmDH8J+Nd/l1rmyZzEae8ANc0BanO/0lVzLeUGOgE0UUoYmU+n82Q+32mvS
        IJJRqJXj6JOb8UTys4dOSiVus6+ow5U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-oIze_1BkO-ipIDJ3GsHrVw-1; Wed, 24 Nov 2021 13:37:42 -0500
X-MC-Unique: oIze_1BkO-ipIDJ3GsHrVw-1
Received: by mail-wr1-f72.google.com with SMTP id k8-20020a5d5248000000b001763e7c9ce5so699882wrc.22
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 10:37:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:references:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=QTMdcW1a7aBYkK74A5mXp+DK4hRD6WGOPvz9bMgTtaM=;
        b=pvxQFqrKZY2lytOPs+j2u1hahoY6ab9B9Y/AuadA3rNjeWPna2PlJZDNxpiWuOGQSt
         /9G9t96xyQ6t+AjUek3Jc6LXr7bLwz90qPeoErwH8sh1C8mX9GTfXLFs0CeZ0GLNfhtk
         ePednKIMJh2iBCMHLE45v4/iMmZ/PKmOzaVUOwqf1OYzwJSa/cNmfG9Qd/+DVLJGoy2O
         uh3nQEZYeqaBlpFBasqSwWHAIQ9IBp4iDQoCKWeVUZTpUUspW0dUS4hg9bensqKgsRPX
         4byFNXECUJpFNZ5DTxGLhuyLiq/Z0UplJsQ+cnpZIHxTkJYMjzqcdsRfzuqgwR1sVyBa
         MwbQ==
X-Gm-Message-State: AOAM5300wa/xfEppNrPkUboUrG+ZhrBLd9YsVhxdfmwHWBJl9ck6ajXO
        SsUr9iuUZAoHjCr6TTuFfNpYq5itmug6hSLJn5VmIlFDGfBB9D/OXzOnE26JyGHneR6lvqXJ0Fj
        H5Pj6/t3XuWIccEmYq9s=
X-Received: by 2002:a7b:c756:: with SMTP id w22mr19007346wmk.34.1637779061251;
        Wed, 24 Nov 2021 10:37:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPfk+fsLN8K+xdj8SERvvVpc0WOg6m5kcwbgehMC+IkBzsdo2LCn2vzI6rrNZ+Xv41RL+TeA==
X-Received: by 2002:a7b:c756:: with SMTP id w22mr19007286wmk.34.1637779060908;
        Wed, 24 Nov 2021 10:37:40 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6380.dip0.t-ipconnect.de. [91.12.99.128])
        by smtp.gmail.com with ESMTPSA id a12sm539861wrm.62.2021.11.24.10.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 10:37:40 -0800 (PST)
Message-ID: <8824a964-95c0-4852-9207-e981c5090593@redhat.com>
Date:   Wed, 24 Nov 2021 19:37:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org,
        Mike Rapoport <rppt@linux.ibm.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@kernel.org>
References: <20211123170056.GC5112@ziepe.ca>
 <dd92a69a-6d09-93a1-4f50-5020f5cc59d0@suse.cz>
 <20211123235953.GF5112@ziepe.ca>
 <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
 <20211124132353.GG5112@ziepe.ca>
 <cca0229e-e53e-bceb-e215-327b6401f256@redhat.com>
 <20211124132842.GH5112@ziepe.ca>
 <eab5aeba-e064-9f3e-fbc3-f73cd299de83@redhat.com>
 <20211124134812.GI5112@ziepe.ca>
 <2cdbebb9-4c57-7839-71ab-166cae168c74@redhat.com>
 <20211124153405.GJ5112@ziepe.ca>
 <63294e63-cf82-1f59-5ea8-e996662e6393@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
In-Reply-To: <63294e63-cf82-1f59-5ea8-e996662e6393@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24.11.21 17:43, David Hildenbrand wrote:
> On 24.11.21 16:34, Jason Gunthorpe wrote:
>> On Wed, Nov 24, 2021 at 03:14:00PM +0100, David Hildenbrand wrote:
>>
>>> I'm not aware of any where you can fragment 50% of all pageblocks in the
>>> system as an unprivileged user essentially consuming almost no memory
>>> and essentially staying inside well-defined memlock limits. But sure if
>>> there are "many" people will be able to come up with at least one
>>> comparable thing. I'll be happy to learn.
>>
>> If the concern is that THP's can be DOS'd then any avenue that renders
>> the system out of THPs is a DOS attack vector. Including all the
>> normal workloads that people run and already complain that THPs get
>> exhausted.
>>
>> A hostile userspace can only quicken this process.
> 
> We can not only fragment THP but also easily smaller compound pages,
> with less impact though (well, as long as people want more than 0.1% per
> user ...).
> 
> We want to make more excessive use of THP; the whole folio work is about
> using THP. Some people are even working on increasing the MAX_ORDER and
> introduce gigantic THP.
> 
> And here we are having mechanisms available to unprivileged users to
> just sabotage the very thing at its core extremely easily. Personally, I
> think this is very bad, but that's just my humble opinion.
> 
>>
>>> My position that FOLL_LONGTERM for unprivileged users is a strong no-go
>>> stands as it is.
>>
>> As this basically excludes long standing pre-existing things like
>> RDMA, XDP, io_uring, and more I don't think this can be the general
>> answer for mm, sorry.
> 
> Let's think about options to restrict FOLL_LONGTERM usage:
> 
> One option would be to add toggle(s) (e.g., kernel cmdline options) to
> make relevant mechanisms (or even FOLL_LONGTERM itself) privileged. The
> admin can opt in if unprivileged users should have that capability. A
> distro might overwrite the default and set it to "on". I'm not
> completely happy about that.
> 
> Another option would be not accounting FOLL_LONGTERM as RLIMIT_MEMLOCK,
> but instead as something that explicitly matches the differing
> semantics. We could have a limit for privileged and one for unprivileged
> users. The default in the kernel could be 0 but an admin/system can
> overwrite it to opt in and a distro might apply different rules. Yes,
> we're back to the original question about limits, but now with the
> thought that FOLL_LONGTERM really is different than mlock and
> potentially more dangerous.
> 
> At the same time, eventually work on proper alternatives with mmu
> notifiers (and possibly without the any such limits) where possible and
> required. (I assume it's hardly possible for RDMA because of the way the
> hardware works)
> 
> Just some ideas, open for alternatives. I know that for the cases where
> we want it to "just work" for unprivileged users but cannot even have
> alternative implementations, this is bad.
> 
>>
>> Sure, lets stop now since I don't think we can agree.
> 
> Don't get me wrong, I really should be working on other stuff, so I have
> limited brain capacity and time :) OTOH I'm willing to help at least
> discuss alternatives.
> 
> 
> Let's think about realistic alternatives to keep FOLL_LONGTERM for any
> user working (that would tackle the extreme fragmentation issue at
> least, ignoring e.g., other fragmentation we can trigger with
> FOLL_LONGTERM or ZONE_MOVABLE/MIGRATE_CMA):
> 
> The nasty thing really is splitting a compound page and then pinning
> some pages, even if it's pinning the complete compound range. Ideally,
> we'd defer any action to the time we actually FOLL_LONGTERM pin a page.
> 
> 
> a) I think we cannot migrate pages when splitting the PMD (e.g., unmap,
> MADV_DONTNEED, swap?, page compaction?). User space can just pin the
> compound page to block migration.
> 
> b) We might migrate pages when splitting the compound page. In
> split_huge_page_to_list() we know that we have nobody pinning the page.
> I did not check if it's possible. There might be cases where it's not
> immediately clear if it's possible (e.g., inside shrink_page_list())
> 
> It would mean that we would migrate pages essentially any time we split
> a compound page because there could be someone FOLL_LONGTERM pinning the
> page later. Usually we'd expect page compaction to fix this up on actual
> demand. I'd call this sub-optimal.
> 
> c) We migrate any time someone FOLL_LONGTERM pins a page and the page is
> not pinned yet -- because it might have been a split compound page. I
> think we can agree that that's not an option :)
> 
> d) We remember if a page was part of a compound page and was not freed
> yet. If we FOLL_LONGTERM such a page, we migrate it. Unfortunately,
> we're short on pageflags for anon pages I think.
> 
> Hm, alternatives?
> 

And while thinking about the other "non malicious" fragmentation issues
-- especially triggering what my reproducer triggered by pure luck
simply because our pages we're pinning are scattered all over pageblocks
--  and remembering what Vlastimil said regarding grouping, I finally
understood why FOLL_LONGTERM is slightly wrong as is.

We allocate user pages with GFP_HIGHUSER_MOVABLE:
  "``GFP_HIGHUSER_MOVABLE`` does not require that allocated memory will
   be directly accessible by the kernel and implies that the data is
   movable."

This holds true for mlock (except when migration is disabled for RT
systems, which is a special case already).

This does not hold true once FOLL_LONGTERM turns the pages essentially
unmovable. We tried to fix some of that fallout by migrating such pages
when they are residing on MIGRATE_CMA and ZONE_MOVABLE before
FOLL_LONGTERM. It's only part of the story, because we're fragmenting
each and ever !MIGRATE_UNMOVABLE pageblock with unmovable data. If we're
unlucky 50% (with the 0.1% RAM rule) of all MIGRATE_MOVABLE pageblocks
in the system.

I had the exact same discussion ("allocating unmovable data for user
space") with Mike regarding "secretmem", resulting in us using
GFP_HIGHUSER for allocation instead, and with Intel folks just now
regarding unmovable fd-based guest mappings.

a) "unmovable memory for user space" really is different from mlock
   (RLIMIT_MEMLOCK). I think we should have much better control over the
   amount of unmovable memory we directly let user space allocate for
   mapping into the process page tables. A separate RLIMIT sounds
   reasonable, and I think I discussed that with Mike already briefly
   during secretmem discussions, and we decided to defer introducing
   something like that.
b) To avoid fragmenting !MIGRATE_UNMOVABLE pageblock, we would have to
   migrate pages into MIGRATE_UNMOVABLE pageblocks before FOLL_LONGTERM.
   If we're pinning a  complete pageblock, we're essentially converting
   that pageblock to MIGRATE_UNMOVABLE.
c) When unpinning, theoretically we would want to migrate the now again
   movable page out of a MIGRATE_UNMOVABLE pageblock if there is
   sufficient memory.


We have right now the following, which highlights the issue:

/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin pages */
static inline bool is_pinnable_page(struct page *page)
{
	return !(is_zone_movable_page(page) ||
                 is_migrate_cma_page(page)) ||
		 is_zero_pfn(page_to_pfn(page))
}


These things would at least make FOLL_LONGTERM do something reasonable
in respect to pageblocks in most cases and would let an admin have
control over how much "unmovable allocations" user space can allocate.
It sure comes with a price when FOLL_LONGTERM pinning a page.

Further, it would let an admin have better control how much unmovable
data user space can allocate directly for mapping into user space
(excluding other unmovable allocations user space can trigger, of course
-- but to me there is a difference between "I am malicious and want to
hurt the kernel by allocating a lot of unmovable memory" and "I am a
sane user and want to make use of features that are a performance
improvement").

It wouldn't cover extended malicious case I presented (first pin the
whole pageblock, then pin a single page, then unpin the whole
pageblock), they would simply turn 50% of all pageblocks
MIGRATE_UNMOVABLE and only have a single page pinned in there.

And it wouldn't solve the issue of "how much unmovable memory to be
mapped into processes do we as a kernel think is reasonable for a single
user on the system".


With something along above lines (and the malicious cases fixed) I think
I could sleep better at night with FOLL_LONGTERM being allowed for
unprivileged users.

-- 
Thanks,

David / dhildenb

