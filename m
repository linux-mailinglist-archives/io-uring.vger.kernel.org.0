Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530956E8162
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 20:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjDSSpN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 14:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDSSpM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 14:45:12 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA404680;
        Wed, 19 Apr 2023 11:45:09 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o29-20020a05600c511d00b003f1739de43cso10525wms.4;
        Wed, 19 Apr 2023 11:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681929908; x=1684521908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xfA92ZDWa3tFrZEqbNbZTNF9MWgNQXkklE0ML2qGCi8=;
        b=bR1dkYt4Ga9qoGYOjrE1JO+w2XRcZejVe/7lGlkWQI19Ddb80Wmyr8oVnJCBh2EJr0
         kPBHPHrumApNAfxu4PjCNlzv2fuKy1Sh1ZrkJWc/cd2mjQN1gStgblOU+zk6erYMDf7/
         5C+iCLszgCC15OQ9vSQI7isnvi51p78CWC54EPuJsV4au/7yOE6d0s6Ehl5bN456mSmZ
         gQLzgoUnjjToQNvCFSGWoL3h1noAIP/5ETYQa+IIApUcHT4uTOsqrvKcM7KTmTC5J6HJ
         LAujbpJDDEbJqtXqw/AbLlLXdzPInzR/HsFpleDe5mwl+2aLNeW9NBqdQdEH1PT+PO5W
         WY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681929908; x=1684521908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xfA92ZDWa3tFrZEqbNbZTNF9MWgNQXkklE0ML2qGCi8=;
        b=k8rVIbeFK6Ms6xsdFLoWFb7YVVmb3aiAxvz6BONv1L3b6BLm853bmNRK6m6qSk3aLR
         EXiIx/BuWT08GwgsVCJiLRrpKn/X7bPONrBgKiGOfxqyWA8DrtStGkscwc/9HlMXlanc
         7swXx3a/B3I27PWn2EZe1J/hem3a9D1i3eHrgT2E1UhPucxO5q84hWTqoM1KPtQpd/1c
         5MCLzkdD73gZtCRkSuKGHYB2sUKJE4jMAilN2Pt3rGc4pOUhaQyH4QtyZmk0zzz5eOTV
         fPRDwCN8EBp5jBFovm9FQ8qBV3BgJX5cdAbRlVxjhQdts8rDFxPtnvA6l3RJOjs19Frp
         jnRg==
X-Gm-Message-State: AAQBX9cZgJuq6EBnEYqW670r6q0SG9/E+bz3MgHxt+gb+G9DBD5ZeV63
        XRAPuplYu7PnMED2bpl1m6U=
X-Google-Smtp-Source: AKy350aoV810DLoDWAD0ai0Hb41gGEXLSlJwB5TdjddxVt+yFuIRAfMXTSpF67oE5LJ4PfVb77lGoA==
X-Received: by 2002:a7b:cbd1:0:b0:3f1:6836:5db5 with SMTP id n17-20020a7bcbd1000000b003f168365db5mr2707956wmi.5.1681929907613;
        Wed, 19 Apr 2023 11:45:07 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600c351000b003eddc6aa5fasm3014514wmq.39.2023.04.19.11.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 11:45:06 -0700 (PDT)
Date:   Wed, 19 Apr 2023 19:45:06 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <8bf0df41-27ef-4305-b424-e43045a6d68d@lucifer.local>
References: <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org>
 <ZEAx90C2lDMJIux1@nvidia.com>
 <ZEA0dbV+qIBSD0mG@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEA0dbV+qIBSD0mG@casper.infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 07:35:33PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 19, 2023 at 03:24:55PM -0300, Jason Gunthorpe wrote:
> > On Wed, Apr 19, 2023 at 07:23:00PM +0100, Matthew Wilcox wrote:
> > > On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:
> > > > So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
> > > > would still need to come along and delete a bunch of your code
> > > > afterwards. And unfortunately Pavel's recent change which insists on not
> > > > having different vm_file's across VMAs for the buffer would have to be
> > > > reverted so I expect it might not be entirely without discussion.
> > >
> > > I don't even understand why Pavel wanted to make this change.  The
> > > commit log really doesn't say.
> > >
> > > commit edd478269640
> > > Author: Pavel Begunkov <asml.silence@gmail.com>
> > > Date:   Wed Feb 22 14:36:48 2023 +0000
> > >
> > >     io_uring/rsrc: disallow multi-source reg buffers
> > >
> > >     If two or more mappings go back to back to each other they can be passed
> > >     into io_uring to be registered as a single registered buffer. That would
> > >     even work if mappings came from different sources, e.g. it's possible to
> > >     mix in this way anon pages and pages from shmem or hugetlb. That is not
> > >     a problem but it'd rather be less prone if we forbid such mixing.
> > >
> > >     Cc: <stable@vger.kernel.org>
> > >     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > >     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > >
> > > It even says "That is not a problem"!  So why was this patch merged
> > > if it's not fixing a problem?
> > >
> > > It's now standing in the way of an actual cleanup.  So why don't we
> > > revert it?  There must be more to it than this ...
> >
> > https://lore.kernel.org/all/61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com/
>
> So um, it's disallowed because Pavel couldn't understand why it
> should be allowed?  This gets less and less convincing.
>
> FWIW, what I was suggesting was that we should have a FOLL_SINGLE_VMA
> flag, which would use our shiny new VMA lock infrastructure to look
> up and lock _one_ VMA instead of having the caller take the mmap_lock.
> Passing that flag would be a tighter restriction that Pavel implemented,
> but would certainly relieve some of his mental load.
>
> By the way, even if all pages are from the same VMA, they may still be a
> mixture of anon and file pages; think a MAP_PRIVATE of a file when
> only some pages have been written to.  Or an anon MAP_SHARED which is
> accessible by a child process.

Indeed, my motive for the series came out of a conversation with you about
vmas being odd (thanks! :), however I did end up feeling FOLL_SINGLE_VMA
would be too restricted and would break the uAPI.

For example, imagine if a user (yes it'd be weird) mlock'd some pages in a
buffer and not others, then we'd break their use case. Also (perhaps?) more
feasibly, a user might mix hugetlb and anon pages. So I think that'd be too
restrictive here.

However the idea of just essentially taking what Jens has had to do
open-coded and putting it into GUP as a whole really feels like the right
thing to do.

I do like the idea of a FOLL_SINGLE_VMA for other use cases though, the
majority of which want one and one page only. Perhaps worth taking the
helper added in this series (get_user_page_vma_remote() from [1]) and
replacing it with an a full GUP function which has an interface explicitly
for this common single page/vma case.

[1]:https://lore.kernel.org/linux-mm/7c6f1ae88320bf11d2f583178a3d9e653e06ac63.1681831798.git.lstoakes@gmail.com/
