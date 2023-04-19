Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7986E8120
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 20:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjDSSSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 14:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbjDSSSb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 14:18:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94E255A8;
        Wed, 19 Apr 2023 11:18:29 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id gw13so116954wmb.3;
        Wed, 19 Apr 2023 11:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681928308; x=1684520308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K7rB9pjN1wb6usUEPT4bG0wgaqNPIKNHJ/yW9CqDAlY=;
        b=SVUAE2OFK6nbvtv127m2tipnyzEc6Y7S0RzT9pE4OJFptCBJ5Y6A7hiEIt+1leBvIc
         32AFdahPhGxxNC50W7v+veOqDUFZHlKLJQavNiUqTR2BVdaJbbKYebmQ9OO3YuY9m1jy
         j7l8f9U/MX9+uxAJV7tEGFAmxwF2CEQZIHtNQftg6jjw7SgP15mrHDD6CvcTvuvyrSav
         OkW3DOHFllcoQ/6RhSju5tsc4QfNDBru18pPbUu3/TR1Z2cgSdd2XCaBkOlTPqDspXWq
         KqdbpP5h00i084a5+6t8+o5xkM8RM5qqmPuql6o0T9lQlldd0o5PlUNqhDEIphAjulA7
         7+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681928308; x=1684520308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7rB9pjN1wb6usUEPT4bG0wgaqNPIKNHJ/yW9CqDAlY=;
        b=A7QecxpFBUFMPI5R8+DUCGeUOKhg5gki9KbGoqh9R1Z8meFq+yor4A4YvSQrW1FwYX
         Tdv+W+1zI/ES1lqqspkpbXifrpmhtsQ4jPN5tXvHHS865qHf4ittdOG9wrVrY8vqh6Qm
         d0F1AictWAkNMb8LBs0vE6EWwGX8pD86OOmNEKOeehdNpH6XF9Ydbyhn1mHCB+ZXDuOb
         Mxs5qxAWSa8sga+PQ403yq0UvqiFbdZWFHtDcqwvPWH+Jnv0cPyymm3ptX4XW4jGwEKK
         Q4afdop6P/bZA3RoK9wPG/R273smMqdR2Frr4iGfecoODTF6GuqY7U/cB6DH4hvuOdEP
         p6fg==
X-Gm-Message-State: AAQBX9ejvrK4oKDvKjc/T57gmbhQJlYpk5AQK/lYpV57o+kosKr+9SZk
        pKx2FHVVJvKt5/0YkP60f4Q=
X-Google-Smtp-Source: AKy350bWBQLn46YabJ/c+Q2TKqlCE1ezQOThoBuoeeKGXD2RFFJdL1nznp39Jdn24M2FdUwEMfi/cA==
X-Received: by 2002:a05:600c:b59:b0:3f0:80cf:f2d5 with SMTP id k25-20020a05600c0b5900b003f080cff2d5mr2656525wmr.11.1681928308102;
        Wed, 19 Apr 2023 11:18:28 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id z9-20020a05600c220900b003ee1b2ab9a0sm2875831wml.11.2023.04.19.11.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 11:18:27 -0700 (PDT)
Date:   Wed, 19 Apr 2023 19:18:26 +0100
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
Message-ID: <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 11:51:29AM -0600, Jens Axboe wrote:
> On 4/19/23 11:47?AM, Lorenzo Stoakes wrote:
> > On Wed, Apr 19, 2023 at 11:35:58AM -0600, Jens Axboe wrote:
> >> On 4/19/23 11:23?AM, Lorenzo Stoakes wrote:
> >>> On Wed, Apr 19, 2023 at 10:59:27AM -0600, Jens Axboe wrote:
> >>>> On 4/19/23 10:35?AM, Jens Axboe wrote:
> >>>>> On 4/18/23 9:49?AM, Lorenzo Stoakes wrote:
> >>>>>> We are shortly to remove pin_user_pages(), and instead perform the required
> >>>>>> VMA checks ourselves. In most cases there will be a single VMA so this
> >>>>>> should caues no undue impact on an already slow path.
> >>>>>>
> >>>>>> Doing this eliminates the one instance of vmas being used by
> >>>>>> pin_user_pages().
> >>>>>
> >>>>> First up, please don't just send single patches from a series. It's
> >>>>> really annoying when you are trying to get the full picture. Just CC the
> >>>>> whole series, so reviews don't have to look it up separately.
> >>>>>
> >>>>> So when you're doing a respin for what I'll mention below and the issue
> >>>>> that David found, please don't just show us patch 4+5 of the series.
> >>>>
> >>>> I'll reply here too rather than keep some of this conversaion
> >>>> out-of-band.
> >>>>
> >>>> I don't necessarily think that making io buffer registration dumber and
> >>>> less efficient by needing a separate vma lookup after the fact is a huge
> >>>> deal, as I would imagine most workloads register buffers at setup time
> >>>> and then don't change them. But if people do switch sets at runtime,
> >>>> it's not necessarily a slow path. That said, I suspect the other bits
> >>>> that we do in here, like the GUP, is going to dominate the overhead
> >>>> anyway.
> >>>
> >>> Thanks, and indeed I expect the GUP will dominate.
> >>
> >> Unless you have a lot of vmas... Point is, it's _probably_ not a
> >> problem, but it might and it's making things worse for no real gain as
> >> far as I can tell outside of some notion of "cleaning up the code".
> >>
> >>>> My main question is, why don't we just have a __pin_user_pages or
> >>>> something helper that still takes the vmas argument, and drop it from
> >>>> pin_user_pages() only? That'd still allow the cleanup of the other users
> >>>> that don't care about the vma at all, while retaining the bundled
> >>>> functionality for the case/cases that do? That would avoid needing
> >>>> explicit vma iteration in io_uring.
> >>>>
> >>>
> >>> The desire here is to completely eliminate vmas as an externally available
> >>> parameter from GUP. While we do have a newly introduced helper that returns
> >>> a VMA, doing the lookup manually for all other vma cases (which look up a
> >>> single page and vma), that is more so a helper that sits outside of GUP.
> >>>
> >>> Having a separate function that still bundled the vmas would essentially
> >>> undermine the purpose of the series altogether which is not just to clean
> >>> up some NULL's but rather to eliminate vmas as part of the GUP interface
> >>> altogether.
> >>>
> >>> The reason for this is that by doing so we simplify the GUP interface,
> >>> eliminate a whole class of possible future bugs with people holding onto
> >>> pointers to vmas which may dangle and lead the way to future changes in GUP
> >>> which might be more impactful, such as trying to find means to use the fast
> >>> paths in more areas with an eye to gradual eradication of the use of
> >>> mmap_lock.
> >>>
> >>> While we return VMAs, none of this is possible and it also makes the
> >>> interface more confusing - without vmas GUP takes flags which define its
> >>> behaviour and in most cases returns page objects. The odd rules about what
> >>> can and cannot return vmas under what circumstances are not helpful for new
> >>> users.
> >>>
> >>> Another point here is that Jason suggested adding a new
> >>> FOLL_ALLOW_BROKEN_FILE_MAPPINGS flag which would, by default, not be
> >>> set. This could assert that only shmem/hugetlb file mappings are permitted
> >>> which would eliminate the need for you to perform this check at all.
> >>>
> >>> This leads into the larger point that GUP-writing file mappings is
> >>> fundamentally broken due to e.g. GUP not honouring write notify so this
> >>> check should at least in theory not be necessary.
> >>>
> >>> So it may be the case that should such a flag be added this code will
> >>> simply be deleted at a future point :)
> >>
> >> Why don't we do that first then? There's nothing more permanent than a
> >> temporary workaround/fix. Once it's in there, motivation to get rid of
> >> it for most people is zero because they just never see it. Seems like
> >> that'd be a much saner approach rather than the other way around, and
> >> make this patchset simpler/cleaner too as it'd only be removing code in
> >> all of the callers.
> >>
> >
> > Because I'd then need to audit all GUP callers to see whether they in some
> > way brokenly access files in order to know which should and should not use
> > this new flag. It'd change this series from 'remove the vmas parameter' to
> > something a lot more involved.
> >
> > I think it's much safer to do the two separately, as I feel that change
> > would need quite a bit of scrutiny too.
> >
> > As for temporary, I can assure you I will be looking at introducing this
> > flag, for what it's worth :) and Jason is certainly minded to do work in
> > this area also.
>
> It's either feasible or it's not, and it didn't sound too bad in terms
> of getting it done to remove the temporary addition. Since we're now
> days away from the merge window and any of this would need to soak in
> for-next anyway for a bit, why not just do that other series first? It
> really is backward. And this happens sometimes when developing
> patchsets, at some point you realize that things would be easier/cleaner
> with another prep series first. Nothing wrong with that, but let's not
> be hesitant to shift direction a bit when it makes sense to do so.
>
> I keep getting this sense of urgency for a cleanup series. Why not just
> do it right from the get-go and make this series simpler? At that point
> there would be no discussion on it at all, as it would be a straight
> forward cleanup without adding an intermediate step that'd get deleted
> later anyway.

As I said, I think it is a little more than a cleanup, or at the very least
a cleanup that leads the way to more functional changes (and eliminates a
class of bugs).

I'd also argue that we are doing things right with this patch series as-is,
io_uring is the only sticking point because, believe it or not, it is the
only place in the kernel that uses multiple vmas (it has been interesting
to get a view on GUP use as a whole here).

But obviously if you have concerns about performance I understand (note
that the actual first iteration of this patch set added a flag specifically
to avoid the need for this in order to cause you less trouble :)

I would argue that you're _already_ manipulating VMAs (I do understand your
desire not to do so obviously) the only thing that would change is how you
get them and duplicated work (though likely less impactful).

So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
would still need to come along and delete a bunch of your code
afterwards. And unfortunately Pavel's recent change which insists on not
having different vm_file's across VMAs for the buffer would have to be
reverted so I expect it might not be entirely without discussion.

However, if you really do feel that you can't accept this change as-is, I
can put this series on hold and look at FOLL_ALLOW_BROKEN_FILE_MAPPING and
we can return to this afterwards.

>
> --
> Jens Axboe
>
