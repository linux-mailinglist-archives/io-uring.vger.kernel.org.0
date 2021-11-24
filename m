Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C674F45CA47
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 17:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbhKXQrO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 11:47:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238476AbhKXQrO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 11:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637772243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QsMXLEsfUpg3nTh4LVta/33dXBWrEFr08t86tyNbxD8=;
        b=A76AX7zxVEKnJpDetWPWG8JEy5XR2PQvlnqqogVIejfZLJSVDPcJIKXODQ1ZGhorKyQrKq
        uloOCQfy70d6x3fmwl39qf1E0TRBhdU1cdtsbYgWXzW0WL0k94MquHG85tWIJif+WVgKca
        yjEISlBIJ5AGySBqhJSCN5kl9+VP3EA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-243-XQqKyLyxNnizD8sjiti73w-1; Wed, 24 Nov 2021 11:44:02 -0500
X-MC-Unique: XQqKyLyxNnizD8sjiti73w-1
Received: by mail-wm1-f69.google.com with SMTP id l4-20020a05600c1d0400b00332f47a0fa3so1738931wms.8
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 08:44:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=QsMXLEsfUpg3nTh4LVta/33dXBWrEFr08t86tyNbxD8=;
        b=vh6QGB4nzVI1A23FPLZ6vsXtvT+7B7whI6TofTiG0ZEAb5au4WWLg0cDT8PhjZTpaM
         VOEy9kUcMd9mMYlntQjPvup+fgu2plpvE/vcB3CbWy5H9qltj89bHZ+DmCRyz1IHDA0b
         DFmmftnXX/s0kOBFs37sdUI6IO0k8JmjPrkorCI0PRRQkyzfi+iQmUpGWBk/YDVddcS1
         QFqt+sx6XixvlDY+Sq6dnUkCxJ3kVDPXUlyck7Tx9mVdpGe2q7co7EhUxjfm83rHAMTB
         zyQk1Fu8pVdi8fI1zdVlX2KKsZ7FzHIemmd3rJs7BgjM424MXP9rHMABu5YfOEuv49vL
         J1Uw==
X-Gm-Message-State: AOAM531zhhKSB5vd00MafyHGU3HhxgdJvNhMq24GiyASsB0Qp0x7ArsS
        grZpl6CGwRMCuilUVDtlJn7o60adk/D/JBBvDcEcFtRLfIs50XGUOyVCOclJxe1MdHErP2ai3Q1
        RWBUhdNMnGUlpuvFS3vY=
X-Received: by 2002:a7b:cd02:: with SMTP id f2mr16953543wmj.115.1637772241076;
        Wed, 24 Nov 2021 08:44:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/aTWG+EhXz/LEDFYbuIzrNXajT2pjFwM6ekqvEq0ltZvjf/SVX2f84TgWFEY087L2XnaMJQ==
X-Received: by 2002:a7b:cd02:: with SMTP id f2mr16953496wmj.115.1637772240810;
        Wed, 24 Nov 2021 08:44:00 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6380.dip0.t-ipconnect.de. [91.12.99.128])
        by smtp.gmail.com with ESMTPSA id f15sm307434wmg.30.2021.11.24.08.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 08:43:59 -0800 (PST)
Message-ID: <63294e63-cf82-1f59-5ea8-e996662e6393@redhat.com>
Date:   Wed, 24 Nov 2021 17:43:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
In-Reply-To: <20211124153405.GJ5112@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24.11.21 16:34, Jason Gunthorpe wrote:
> On Wed, Nov 24, 2021 at 03:14:00PM +0100, David Hildenbrand wrote:
> 
>> I'm not aware of any where you can fragment 50% of all pageblocks in the
>> system as an unprivileged user essentially consuming almost no memory
>> and essentially staying inside well-defined memlock limits. But sure if
>> there are "many" people will be able to come up with at least one
>> comparable thing. I'll be happy to learn.
> 
> If the concern is that THP's can be DOS'd then any avenue that renders
> the system out of THPs is a DOS attack vector. Including all the
> normal workloads that people run and already complain that THPs get
> exhausted.
> 
> A hostile userspace can only quicken this process.

We can not only fragment THP but also easily smaller compound pages,
with less impact though (well, as long as people want more than 0.1% per
user ...).

We want to make more excessive use of THP; the whole folio work is about
using THP. Some people are even working on increasing the MAX_ORDER and
introduce gigantic THP.

And here we are having mechanisms available to unprivileged users to
just sabotage the very thing at its core extremely easily. Personally, I
think this is very bad, but that's just my humble opinion.

> 
>> My position that FOLL_LONGTERM for unprivileged users is a strong no-go
>> stands as it is.
> 
> As this basically excludes long standing pre-existing things like
> RDMA, XDP, io_uring, and more I don't think this can be the general
> answer for mm, sorry.

Let's think about options to restrict FOLL_LONGTERM usage:

One option would be to add toggle(s) (e.g., kernel cmdline options) to
make relevant mechanisms (or even FOLL_LONGTERM itself) privileged. The
admin can opt in if unprivileged users should have that capability. A
distro might overwrite the default and set it to "on". I'm not
completely happy about that.

Another option would be not accounting FOLL_LONGTERM as RLIMIT_MEMLOCK,
but instead as something that explicitly matches the differing
semantics. We could have a limit for privileged and one for unprivileged
users. The default in the kernel could be 0 but an admin/system can
overwrite it to opt in and a distro might apply different rules. Yes,
we're back to the original question about limits, but now with the
thought that FOLL_LONGTERM really is different than mlock and
potentially more dangerous.

At the same time, eventually work on proper alternatives with mmu
notifiers (and possibly without the any such limits) where possible and
required. (I assume it's hardly possible for RDMA because of the way the
hardware works)

Just some ideas, open for alternatives. I know that for the cases where
we want it to "just work" for unprivileged users but cannot even have
alternative implementations, this is bad.

> 
> Sure, lets stop now since I don't think we can agree.

Don't get me wrong, I really should be working on other stuff, so I have
limited brain capacity and time :) OTOH I'm willing to help at least
discuss alternatives.


Let's think about realistic alternatives to keep FOLL_LONGTERM for any
user working (that would tackle the extreme fragmentation issue at
least, ignoring e.g., other fragmentation we can trigger with
FOLL_LONGTERM or ZONE_MOVABLE/MIGRATE_CMA):

The nasty thing really is splitting a compound page and then pinning
some pages, even if it's pinning the complete compound range. Ideally,
we'd defer any action to the time we actually FOLL_LONGTERM pin a page.


a) I think we cannot migrate pages when splitting the PMD (e.g., unmap,
MADV_DONTNEED, swap?, page compaction?). User space can just pin the
compound page to block migration.

b) We might migrate pages when splitting the compound page. In
split_huge_page_to_list() we know that we have nobody pinning the page.
I did not check if it's possible. There might be cases where it's not
immediately clear if it's possible (e.g., inside shrink_page_list())

It would mean that we would migrate pages essentially any time we split
a compound page because there could be someone FOLL_LONGTERM pinning the
page later. Usually we'd expect page compaction to fix this up on actual
demand. I'd call this sub-optimal.

c) We migrate any time someone FOLL_LONGTERM pins a page and the page is
not pinned yet -- because it might have been a split compound page. I
think we can agree that that's not an option :)

d) We remember if a page was part of a compound page and was not freed
yet. If we FOLL_LONGTERM such a page, we migrate it. Unfortunately,
we're short on pageflags for anon pages I think.

Hm, alternatives?

-- 
Thanks,

David / dhildenb

