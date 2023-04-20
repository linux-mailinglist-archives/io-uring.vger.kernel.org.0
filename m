Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024716E96E3
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 16:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjDTOTu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 10:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjDTOTb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 10:19:31 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7640C61B4;
        Thu, 20 Apr 2023 07:19:05 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id bi21-20020a05600c3d9500b003f17a8eaedbso3155696wmb.1;
        Thu, 20 Apr 2023 07:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682000343; x=1684592343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5bvHlG0/JTB7HrnkZNbj8ncjZGNIrjux5UiB5tAycP8=;
        b=Npay1TVhojwYB+yz7Ysjw6StA9B11tmjVHgRd0PstSs12o90dEemEl7STZn4axgCAZ
         OM0zb6TDhk4+v+TPBRFM/72qZ2pHWuV8TdrVyRVeArba9e2ZakVBE9YbrBLowET/mVkn
         y9CfDStdJ/jAQ5UoJOgJyVl3DFq67AXzIVS5CfCyC6vA1d6xYGzIsV3OmETy/1MFXxVg
         33rX0L2U/nL3XGXk7cTu/AfGaxVfRVwJR5zfHhLZ99DxjiSIX9Y5Lqxw0pyz9LzxX60h
         jXpOcFDei0fF6puh5ZTK6rvSWrdUJyKyqZT3GNjyXdq2yC6PQ5e0rOr4X94x0HmeunRP
         H/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682000343; x=1684592343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bvHlG0/JTB7HrnkZNbj8ncjZGNIrjux5UiB5tAycP8=;
        b=ielwcZWQstvXcxNGnDpPCvGcOrnMe/MeYzLNzvpDOESE3tuVgSV8YoKVBEafklCqux
         Fhb7c319joV8TU2NOurjSQMQK2n5ZtQzG/SvQ6t8dZfEnkLgVy1kUU+6cG0NsIxYc46o
         JX87+Tw5aT9a1Hv+N/ldeuc5vWkUAeRIy0W6hDfP4CYN7VlV09HpcRbE/FCt4c+slCGs
         HUQCSiYX3QbWkbzd7J+aaO6XcDTiY9g/63R87Dwcc9imb9RECoxz9Ou9+L4fE4FTe3SF
         KkJeb9mBL3pEGuNW2NAaNHlfq/ztcqtA44s636x2ISgEQXuh3WV8TV8sdUiiraU0Xy8n
         UBvw==
X-Gm-Message-State: AAQBX9c9o7vDTpf3jenvW3DACC+RzYSr7N22MCe5dl5lKN8iFVXkzCA1
        e6x76VMVMCZJk613gKEzR8w=
X-Google-Smtp-Source: AKy350a9I8vSVf0bPmAuaDryi74y07aPweSrcw0b9L3gmiZiUJgQxGlmGkegkYK2Hc2E/A22ecBXQg==
X-Received: by 2002:a7b:cd10:0:b0:3f0:a785:f0e0 with SMTP id f16-20020a7bcd10000000b003f0a785f0e0mr1430470wmj.40.1682000342479;
        Thu, 20 Apr 2023 07:19:02 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003f092f0e0a0sm8082757wmo.3.2023.04.20.07.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 07:19:01 -0700 (PDT)
Date:   Thu, 20 Apr 2023 15:19:01 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <5e4a23f1-c99e-45d6-8402-6c2df8fa06e0@lucifer.local>
References: <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org>
 <ZEAx90C2lDMJIux1@nvidia.com>
 <ZEA0dbV+qIBSD0mG@casper.infradead.org>
 <c94afa59-e1b9-d7b0-a83e-6c722324e7ef@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c94afa59-e1b9-d7b0-a83e-6c722324e7ef@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 20, 2023 at 02:36:47PM +0100, Pavel Begunkov wrote:
> On 4/19/23 19:35, Matthew Wilcox wrote:
> > On Wed, Apr 19, 2023 at 03:24:55PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Apr 19, 2023 at 07:23:00PM +0100, Matthew Wilcox wrote:
> > > > On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:
> > > > > So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
> > > > > would still need to come along and delete a bunch of your code
> > > > > afterwards. And unfortunately Pavel's recent change which insists on not
> > > > > having different vm_file's across VMAs for the buffer would have to be
> > > > > reverted so I expect it might not be entirely without discussion.
> > > >
> > > > I don't even understand why Pavel wanted to make this change.  The
> > > > commit log really doesn't say.
> > > >
> > > > commit edd478269640
> > > > Author: Pavel Begunkov <asml.silence@gmail.com>
> > > > Date:   Wed Feb 22 14:36:48 2023 +0000
> > > >
> > > >      io_uring/rsrc: disallow multi-source reg buffers
> > > >
> > > >      If two or more mappings go back to back to each other they can be passed
> > > >      into io_uring to be registered as a single registered buffer. That would
> > > >      even work if mappings came from different sources, e.g. it's possible to
> > > >      mix in this way anon pages and pages from shmem or hugetlb. That is not
> > > >      a problem but it'd rather be less prone if we forbid such mixing.
> > > >
> > > >      Cc: <stable@vger.kernel.org>
> > > >      Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > >      Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > >
> > > > It even says "That is not a problem"!  So why was this patch merged
> > > > if it's not fixing a problem?
> > > >
> > > > It's now standing in the way of an actual cleanup.  So why don't we
> > > > revert it?  There must be more to it than this ...
> > >
> > > https://lore.kernel.org/all/61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com/
> >
> > So um, it's disallowed because Pavel couldn't understand why it
> > should be allowed?  This gets less and less convincing.
>
> Excuse me? I'm really sorry you "couldn't understand" the explanation
> as it has probably been too much of a "mental load", but let me try to
> elaborate.
>
> Because it's currently limited what can be registered, it's indeed not
> a big deal, but that will most certainly change, and I usually and
> apparently nonsensically prefer to tighten things up _before_ it becomes
> a problem. And again, taking a random set of buffers created for
> different purposes and registering it as a single entity is IMHO not a
> sane approach.
>
> Take p2pdma for instance, if would have been passed without intermixing
> there might not have been is_pci_p2pdma_page()/etc. for every single page
> in a bvec. That's why in general, it won't change for p2pdma but there
> might be other cases in the future.
>

The proposed changes for GUP are equally intended to tighten things up both
in advance of issues (e.g. misuse of vmas parameter), for the purposes of
future improvements to GUP (optimising how we perform these operations) and
most pertinently here - ensuring broken uses of GUP do not occur.

So both are 'cleanups' in some sense :) I think it's important to point out
that this change is not simply a desire to improve an interface but has
practical implications going forward (which maybe aren't obvious at this
point yet).

The new approach to this changes goes further in that we essentially
perform the existing check here (anon/shmem/hugetlb) but for _all_
FOLL_WRITE operations in GUP to avoid broken writes to file mappings, at
which point we can just remove the check here altogether (I will post a
series for this soon).

I think that you guys should not have to be performing sanity checks here
but rather we should handle it in GUP so you don't need to think about it
at all. It feels like an mm failing that you have had to do so at all.

So I guess the question is, do you feel the requirement for vm_file being
the same should apply across _any_ GUP operation over a range or is it
io_uring-specific?

If the former then we should do it in GUP alongside the other checks (and
you can comment accordingly on that patch series when it comes), if the
latter then I would restate my opinion that we shouldn't be prevented from
making improvements to GUP in for one caller that wants to iterate
over these VMAs for custom checks + that should be done separately.

>
> > FWIW, what I was suggesting was that we should have a FOLL_SINGLE_VMA
> > flag, which would use our shiny new VMA lock infrastructure to look
> > up and lock _one_ VMA instead of having the caller take the mmap_lock.
> > Passing that flag would be a tighter restriction that Pavel implemented,
> > but would certainly relieve some of his mental load.
> >
> > By the way, even if all pages are from the same VMA, they may still be a
> > mixture of anon and file pages; think a MAP_PRIVATE of a file when
> > only some pages have been written to.  Or an anon MAP_SHARED which is
> > accessible by a child process.
>
> --
> Pavel Begunkov
