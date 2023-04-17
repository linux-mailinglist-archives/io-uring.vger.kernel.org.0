Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA8A6E4CC8
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 17:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjDQPVv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Apr 2023 11:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjDQPVZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Apr 2023 11:21:25 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE63DC64C;
        Mon, 17 Apr 2023 08:20:40 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f1763ee8f8so3200475e9.1;
        Mon, 17 Apr 2023 08:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744839; x=1684336839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQDSqHH17hYfTNLrFjs84ctoH0UTXd1VRJaXaEoqgiA=;
        b=I4ojaBcrnVZQs/M/AZcS0EaF0gOS2a9WvXZNBiTDSMeZFlGhGUnr3r6xBnT++FkAKb
         jmeXkOY09WH6pKRmuGLdOi3wSGFkVkJcrBhOtKVsIV6A20MrPqxly55z/iM1ieHndmug
         xpjE0PMitt1yczm2b48xTNbWsV2dw53QXv/fZoIaGyoY8+FjweN+D865xRoBp8It9axF
         l7qinG2ZsUa4XrYjvtNGZcbwcbqRfoRZvRslXrgza0rjcGj5u9TNaxkDuoYIk7YbTl4b
         /Z8pWo9ROMugg7Rm9HJxlGYso5B8jWYp9rI4BeZb+UMWzry9DTyvbGioN8GNUlbhRadf
         K9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744839; x=1684336839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQDSqHH17hYfTNLrFjs84ctoH0UTXd1VRJaXaEoqgiA=;
        b=RdGpdHryi9WY2z6NwdSPGU9R1qPqLgEKMc22a7aJEN833uLCLkC1KkKXlCO7UDAIfD
         NpCrXBBFmVtsNw+slToRri1sQ5ldyaS15doARTfzMxZ6E5xRolVtHM2PzahOMHOXvFdS
         g+PefcBdGEbQpVdhrwkWOcTN57zlsZl7iQirN8/x88o4xVukY3ZLpzvsVTo56xIYlL6S
         j1IwQXPjgxDrp+dHAJC/Wa2i2Yh8pBqkS7XZH9DtoDKNyiUjXC32uYsbnxp3+Ecpt1e6
         rwtfmCnJJUqSa62f5PaP5b8feA//QtE0zyFieAxvOwxbW2f0ssR9UutHbfb+CJK9ri5c
         liVQ==
X-Gm-Message-State: AAQBX9fhVVg44vrUOtrANcdSbElvYxCn5bLaC5NW/R2lS/rhx2aVfPM7
        gYHE85rhQ+EZwbo8TXpi8Ns=
X-Google-Smtp-Source: AKy350ZOMCW2n6XzeidxNZXgiJylme1WhhGqKzfcA0zTI7glb7Vc9xWe4n4TEYopToDAF7gTFOFUMA==
X-Received: by 2002:adf:f8c5:0:b0:2cf:ec6c:f253 with SMTP id f5-20020adff8c5000000b002cfec6cf253mr6174725wrq.20.1681744838549;
        Mon, 17 Apr 2023 08:20:38 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id s15-20020adfeb0f000000b002c55306f6edsm10750461wrn.54.2023.04.17.08.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:20:37 -0700 (PDT)
Date:   Mon, 17 Apr 2023 16:20:36 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
Message-ID: <b9b3b339-c31f-48a5-91c8-278e88bbcb97@lucifer.local>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <b1f125c8-05ec-4b41-9b3d-165bf7694e5a@lucifer.local>
 <ZD1I8XlSBIYET9A+@nvidia.com>
 <34959b70-6270-46cf-94c5-d6da12b0c62d@lucifer.local>
 <ZD1UbgeoeNFEvv9/@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD1UbgeoeNFEvv9/@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 17, 2023 at 11:15:10AM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 17, 2023 at 03:00:16PM +0100, Lorenzo Stoakes wrote:
> > On Mon, Apr 17, 2023 at 10:26:09AM -0300, Jason Gunthorpe wrote:
> > > On Mon, Apr 17, 2023 at 02:19:16PM +0100, Lorenzo Stoakes wrote:
> > >
> > > > > I'd rather see something like FOLL_ALLOW_BROKEN_FILE_MAPPINGS than
> > > > > io_uring open coding this kind of stuff.
> > > > >
> > > >
> > > > How would the semantics of this work? What is broken? It is a little
> > > > frustrating that we have FOLL_ANON but hugetlb as an outlying case, adding
> > > > FOLL_ANON_OR_HUGETLB was another consideration...
> > >
> > > It says "historically this user has accepted file backed pages and we
> > > we think there may actually be users doing that, so don't break the
> > > uABI"
> >
> > Having written a bunch here I suddenly realised that you probably mean for
> > this flag to NOT be applied to the io_uring code and thus have it enforce
> > the 'anonymous or hugetlb' check by default?
>
> Yes
>
> > So you mean to disallow file-backed page pinning as a whole unless this
> > flag is specified?
>
> Yes
>
> > For FOLL_GET I can see that access to the underlying
> > data is dangerous as the memory may get reclaimed or migrated, but surely
> > DMA-pinned memory (as is the case here) is safe?
>
> No, it is all broken, read-only access is safe.
>
> We are trying to get a point where pin access will interact properly
> with the filesystem, but it isn't done yet.
>
> > Or is this a product more so of some kernel process accessing file-backed
> > pages for a file system which expects write-notify semantics and doesn't
> > get them in this case, which could indeed be horribly broken.
>
> Yes, broadly
>
> > I am definitely in favour of cutting things down if possible, and very much
> > prefer the use of uaccess if we are able to do so rather than GUP.
> >
> > I do feel that GUP should be focused purely on pinning memory rather than
> > manipulating it (whether read or write) so I agree with this sentiment.
>
> Yes, someone needs to be brave enough to go and try to adjust these
> old places :)

Well, I liek to think of myself as stupid^W brave enough to do such things
so may try a separate patch series on that :)

>
> I see in the git history this was added to solve CVE-2018-1120 - eg
> FUSE can hold off fault-in indefinitely. So the flag is really badly
> misnamed - it is "FOLL_DONT_BLOCK_ON_USERSPACE" and anon memory is a
> simple, but overly narrow, way to get that property.
>
> If it is changed to use kthread_use_mm() it needs a VMA based check
> for the same idea.
>
> Jason

I'll try my hand at patching this also!

As for FOLL_ALLOW_BROKEN_FILE_MAPPINGS, I do really like this idea, and
think it is actually probably quite important we do it, however this feels
a bit out of scope for this patch series.

I think perhaps the way forward is, if Jens and Pavel don't have any issue
with it, we open code the check and drop FOLL_SAME_FILE for this series,
then introduce it in a separate one + replace the open coding there?

I am eager to try to keep this focused on the specific task of dropping the
vmas parameter as I think FOLL_ALLOW_BROKEN_FILE_MAPPINGS is likely to
garner some discussion which should be kept separate.
