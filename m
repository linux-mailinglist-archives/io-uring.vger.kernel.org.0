Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB56E803D
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 19:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjDSRXZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 13:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjDSRXY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 13:23:24 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B8346B1;
        Wed, 19 Apr 2023 10:23:23 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ay3-20020a05600c1e0300b003f17289710aso1804931wmb.5;
        Wed, 19 Apr 2023 10:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681925001; x=1684517001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PbdVv88DWDlVS6fOv6CfQ4TcqHKZBvuBMSO1VZVRUV4=;
        b=Wy6Ctj0Kprf1YVYrpduGBmN1bUBvf8KbeRZJyo4EitncylaSdNDMYth80L7gMZxSye
         VM9mrr7bqRnT+5Lvwf+bDkBk1J96oB17wAC57D08Ps2MDPRQwCS44vgX0Ww/0WPM2q1r
         7/RfPFf2BWzksrskehryWdUKgBr46y2+FzE09QdNroXyWGdnggeciRYPZYHLTjaTyFRc
         GL03RUd+Qb6LPHxVFrtI0zAX2Nq0IKiZckjyowf1j/813S6ymxPBjFoojauQGOKs8Vnr
         bR892VqSwfFyqbm2HDlUOJN+O9x9QRgbar+yr2MLpmrFHx2KkRKJDhHbd01QFlTJsLHr
         YHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681925001; x=1684517001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PbdVv88DWDlVS6fOv6CfQ4TcqHKZBvuBMSO1VZVRUV4=;
        b=APLP9xXKBaW4baHoKBszrlX4ywWM8XSMScJu74UsAXwQmLVrUWyEjeKZ8KXvuM8ReK
         KqHHQG+jVicbfO2mvSXX01FNsJVc4oPRXMFegmebObgzlWX8/jhjAHjLCtleWP6qUY5u
         1wsNZPyR4n87eA1HyBTXCjYZU6PGUWFgTViVduxvMWoJl++KRMjIDQNiJG2wmpI9xOgI
         FyYwqJI0Q87b4XV8SlBhjaJUrk2Q3pT1Hcn/2usomE2TrCorJoihnjHLRBjlLdTBeL92
         km0zw4vpW0aEzdrS1beRu7t7OYabvU9KAtzjN9tvUDaO30B9QM5IxyL9K3ZHPrfbQAyG
         u+XA==
X-Gm-Message-State: AAQBX9f/6/RnzNy+2wuTDiV0ru9MAPYG21bxX6CXU/OZAsfj2bGyeL62
        m/beU9q7fozFXucbW20Byuo=
X-Google-Smtp-Source: AKy350bUR51nnMmwbXx1xt4z86WrUUpbxvFDqBTSzEFf/0HbReZDU/Z0j0yKNf0EiJ8HmzCkI8JMtQ==
X-Received: by 2002:a7b:cd0b:0:b0:3eb:37ce:4c3d with SMTP id f11-20020a7bcd0b000000b003eb37ce4c3dmr17068957wmj.38.1681925001356;
        Wed, 19 Apr 2023 10:23:21 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id c10-20020a7bc2aa000000b003f080b2f9f4sm2760084wmk.27.2023.04.19.10.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 10:23:20 -0700 (PDT)
Date:   Wed, 19 Apr 2023 18:23:19 +0100
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
Message-ID: <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 10:59:27AM -0600, Jens Axboe wrote:
> On 4/19/23 10:35?AM, Jens Axboe wrote:
> > On 4/18/23 9:49?AM, Lorenzo Stoakes wrote:
> >> We are shortly to remove pin_user_pages(), and instead perform the required
> >> VMA checks ourselves. In most cases there will be a single VMA so this
> >> should caues no undue impact on an already slow path.
> >>
> >> Doing this eliminates the one instance of vmas being used by
> >> pin_user_pages().
> >
> > First up, please don't just send single patches from a series. It's
> > really annoying when you are trying to get the full picture. Just CC the
> > whole series, so reviews don't have to look it up separately.
> >
> > So when you're doing a respin for what I'll mention below and the issue
> > that David found, please don't just show us patch 4+5 of the series.
>
> I'll reply here too rather than keep some of this conversaion
> out-of-band.
>
> I don't necessarily think that making io buffer registration dumber and
> less efficient by needing a separate vma lookup after the fact is a huge
> deal, as I would imagine most workloads register buffers at setup time
> and then don't change them. But if people do switch sets at runtime,
> it's not necessarily a slow path. That said, I suspect the other bits
> that we do in here, like the GUP, is going to dominate the overhead
> anyway.

Thanks, and indeed I expect the GUP will dominate.

>
> My main question is, why don't we just have a __pin_user_pages or
> something helper that still takes the vmas argument, and drop it from
> pin_user_pages() only? That'd still allow the cleanup of the other users
> that don't care about the vma at all, while retaining the bundled
> functionality for the case/cases that do? That would avoid needing
> explicit vma iteration in io_uring.
>

The desire here is to completely eliminate vmas as an externally available
parameter from GUP. While we do have a newly introduced helper that returns
a VMA, doing the lookup manually for all other vma cases (which look up a
single page and vma), that is more so a helper that sits outside of GUP.

Having a separate function that still bundled the vmas would essentially
undermine the purpose of the series altogether which is not just to clean
up some NULL's but rather to eliminate vmas as part of the GUP interface
altogether.

The reason for this is that by doing so we simplify the GUP interface,
eliminate a whole class of possible future bugs with people holding onto
pointers to vmas which may dangle and lead the way to future changes in GUP
which might be more impactful, such as trying to find means to use the fast
paths in more areas with an eye to gradual eradication of the use of
mmap_lock.

While we return VMAs, none of this is possible and it also makes the
interface more confusing - without vmas GUP takes flags which define its
behaviour and in most cases returns page objects. The odd rules about what
can and cannot return vmas under what circumstances are not helpful for new
users.

Another point here is that Jason suggested adding a new
FOLL_ALLOW_BROKEN_FILE_MAPPINGS flag which would, by default, not be
set. This could assert that only shmem/hugetlb file mappings are permitted
which would eliminate the need for you to perform this check at all.

This leads into the larger point that GUP-writing file mappings is
fundamentally broken due to e.g. GUP not honouring write notify so this
check should at least in theory not be necessary.

So it may be the case that should such a flag be added this code will
simply be deleted at a future point :)

> --
> Jens Axboe
>
