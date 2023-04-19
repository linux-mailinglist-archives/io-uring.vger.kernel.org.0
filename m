Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E696E809A
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 19:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjDSRrg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 13:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjDSRrb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 13:47:31 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BFBF1;
        Wed, 19 Apr 2023 10:47:22 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f1763ee8f8so365445e9.1;
        Wed, 19 Apr 2023 10:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681926441; x=1684518441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=foa53WKZC60JspXp1EgnvL6+H+mX7HMNrIjNztz1zm0=;
        b=kkzmwfcz+S/rE6WazwmwiRT0Pyl8gJRjiGcIS6xLzTnBDByiDpe7AfzETde8Rkflxu
         6grjRNkaJ0ZjOjUj8qFopQxWw2zXXdO3Wxt0zhGJlBSAkMbIrlvZ9P2ssBx+grOnkDSG
         TtBw+oxdy9utVeiD1TzxtedKHV/eNExAywSngFQPgCSnMb1KW5atp5nPQ71x6FFEiHA7
         UFDtP6PH99QI/oy1SyO7dGW6G+KUAgWSHpJvmR0NF2APY/h7PvpPJiAZEYaVy0jahvSE
         FBpbc5GxD4XD2gnl5S8/SFLYK/P0ZSJy4At0ycSTOsUWO2EwQqW0QpbzS2ExOlsKd8Zd
         SlHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681926441; x=1684518441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=foa53WKZC60JspXp1EgnvL6+H+mX7HMNrIjNztz1zm0=;
        b=awgac+ZqZaUPmhM34pUXCRyecLkpJIIzZNemFo/Cntkw7Edqttrj1yt4WyDjMU2Ke0
         h7FsqVfQUUppAzBLIBNQS7SIpQvBSwf44XQlVS9Lx/Jzu3+BDvuYqPZs76iTAmjZKGFp
         Zrw8UShoe24lFxZEbar2+3oKU9axEyvoj7RyVcYIsw1Q3QcXrib7BSy4zUlrkvUHslt6
         8qX5mUpvHdwafK3EAMaWszR8vv/sYo3iPLpevTT42uOwTNkttkM2KMQsxgzz1NKsd32V
         ZzDlz0isyN1EYLfE83z/ONCXtsWBDa64rjcRO+d4XIbyeLS7sKmCHDXpxjeu8XJlDDjs
         xrOQ==
X-Gm-Message-State: AAQBX9fH2Ql/QWwSoUpDO7h8uFw+l5QLmeIGU/hR5bBUghlaljYC3Tub
        ALW535dIMm2oOX2yX99Arlg=
X-Google-Smtp-Source: AKy350YXGjQs5LfN7GPboqOO260zQNSJ7enU8x2xyAqdAF7LVSt1PBKM4vvwSrK2nEECIruNreMzNg==
X-Received: by 2002:adf:e84d:0:b0:2f2:542a:6f50 with SMTP id d13-20020adfe84d000000b002f2542a6f50mr5629437wrn.56.1681926440598;
        Wed, 19 Apr 2023 10:47:20 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id b2-20020adfe302000000b002fae2a08089sm7732368wrj.70.2023.04.19.10.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 10:47:19 -0700 (PDT)
Date:   Wed, 19 Apr 2023 18:47:18 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 11:35:58AM -0600, Jens Axboe wrote:
> On 4/19/23 11:23?AM, Lorenzo Stoakes wrote:
> > On Wed, Apr 19, 2023 at 10:59:27AM -0600, Jens Axboe wrote:
> >> On 4/19/23 10:35?AM, Jens Axboe wrote:
> >>> On 4/18/23 9:49?AM, Lorenzo Stoakes wrote:
> >>>> We are shortly to remove pin_user_pages(), and instead perform the required
> >>>> VMA checks ourselves. In most cases there will be a single VMA so this
> >>>> should caues no undue impact on an already slow path.
> >>>>
> >>>> Doing this eliminates the one instance of vmas being used by
> >>>> pin_user_pages().
> >>>
> >>> First up, please don't just send single patches from a series. It's
> >>> really annoying when you are trying to get the full picture. Just CC the
> >>> whole series, so reviews don't have to look it up separately.
> >>>
> >>> So when you're doing a respin for what I'll mention below and the issue
> >>> that David found, please don't just show us patch 4+5 of the series.
> >>
> >> I'll reply here too rather than keep some of this conversaion
> >> out-of-band.
> >>
> >> I don't necessarily think that making io buffer registration dumber and
> >> less efficient by needing a separate vma lookup after the fact is a huge
> >> deal, as I would imagine most workloads register buffers at setup time
> >> and then don't change them. But if people do switch sets at runtime,
> >> it's not necessarily a slow path. That said, I suspect the other bits
> >> that we do in here, like the GUP, is going to dominate the overhead
> >> anyway.
> >
> > Thanks, and indeed I expect the GUP will dominate.
>
> Unless you have a lot of vmas... Point is, it's _probably_ not a
> problem, but it might and it's making things worse for no real gain as
> far as I can tell outside of some notion of "cleaning up the code".
>
> >> My main question is, why don't we just have a __pin_user_pages or
> >> something helper that still takes the vmas argument, and drop it from
> >> pin_user_pages() only? That'd still allow the cleanup of the other users
> >> that don't care about the vma at all, while retaining the bundled
> >> functionality for the case/cases that do? That would avoid needing
> >> explicit vma iteration in io_uring.
> >>
> >
> > The desire here is to completely eliminate vmas as an externally available
> > parameter from GUP. While we do have a newly introduced helper that returns
> > a VMA, doing the lookup manually for all other vma cases (which look up a
> > single page and vma), that is more so a helper that sits outside of GUP.
> >
> > Having a separate function that still bundled the vmas would essentially
> > undermine the purpose of the series altogether which is not just to clean
> > up some NULL's but rather to eliminate vmas as part of the GUP interface
> > altogether.
> >
> > The reason for this is that by doing so we simplify the GUP interface,
> > eliminate a whole class of possible future bugs with people holding onto
> > pointers to vmas which may dangle and lead the way to future changes in GUP
> > which might be more impactful, such as trying to find means to use the fast
> > paths in more areas with an eye to gradual eradication of the use of
> > mmap_lock.
> >
> > While we return VMAs, none of this is possible and it also makes the
> > interface more confusing - without vmas GUP takes flags which define its
> > behaviour and in most cases returns page objects. The odd rules about what
> > can and cannot return vmas under what circumstances are not helpful for new
> > users.
> >
> > Another point here is that Jason suggested adding a new
> > FOLL_ALLOW_BROKEN_FILE_MAPPINGS flag which would, by default, not be
> > set. This could assert that only shmem/hugetlb file mappings are permitted
> > which would eliminate the need for you to perform this check at all.
> >
> > This leads into the larger point that GUP-writing file mappings is
> > fundamentally broken due to e.g. GUP not honouring write notify so this
> > check should at least in theory not be necessary.
> >
> > So it may be the case that should such a flag be added this code will
> > simply be deleted at a future point :)
>
> Why don't we do that first then? There's nothing more permanent than a
> temporary workaround/fix. Once it's in there, motivation to get rid of
> it for most people is zero because they just never see it. Seems like
> that'd be a much saner approach rather than the other way around, and
> make this patchset simpler/cleaner too as it'd only be removing code in
> all of the callers.
>

Because I'd then need to audit all GUP callers to see whether they in some
way brokenly access files in order to know which should and should not use
this new flag. It'd change this series from 'remove the vmas parameter' to
something a lot more involved.

I think it's much safer to do the two separately, as I feel that change
would need quite a bit of scrutiny too.

As for temporary, I can assure you I will be looking at introducing this
flag, for what it's worth :) and Jason is certainly minded to do work in
this area also.

> --
> Jens Axboe
>
