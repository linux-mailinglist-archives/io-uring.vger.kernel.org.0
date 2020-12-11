Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B12D2D7AAC
	for <lists+io-uring@lfdr.de>; Fri, 11 Dec 2020 17:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395217AbgLKQQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Dec 2020 11:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395024AbgLKQQj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Dec 2020 11:16:39 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23159C0613CF
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 08:15:59 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id w1so8427869ejf.11
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 08:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WW/IgNhybzf9n43eMLzqyKuFaTrBzPIKMpnR7SzERUk=;
        b=bYROoITLccQpGFGMZXPD6eWxSyrqAjonuDGHEXaEMRMw2U73UZPBA/Wx+3wcdLnuwE
         gH9Z8XDcULoJPsPcibh0AIQarFEI/KJBT0PJ6EA+bHu6T8MPr31cyPmomih/kjn5jZN7
         m8npqnDCucqxPsaatevB23b9SJj+ogwBY0rjZvp69Gjpbf+e+RzXPhh5A4eel+1sspFD
         x7FLY4Z07Wuzs1fGnz/y/aZTwusaVyQ4LocM7f1JYm86LAB2OOTRax8ujzryu2yP2Ccz
         ue90Kdx0V68pf/HNNRQhRhrQ8KqbaMiZn2oaZCKv9J9va1bg1TEY7vGFP2UbEtaCXYM3
         CkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WW/IgNhybzf9n43eMLzqyKuFaTrBzPIKMpnR7SzERUk=;
        b=pzz+q+V2ss1X84D2/+FyRUwQHUiuJB+IYzFq52kiTpqiDIoTqCxuSKLEvvdVabn5PL
         BZrnNj9vTy4DBkUqD7MOkYSC6tU+5QW+cwf+HWuomr7jFvTqtpWgl+qMshmVxjiHBEum
         3wc7SFTg39gp//+q66EX3PhG4OjJkrf8Pbslfpo3bgOZEU9QlhrH017XUq73hhVk4mj/
         hr3wqHDhS16QyfywuiuK/OP5sL4uBo5TJrBcfAW0cgiZpcRCxsLXw4tKk/VbbA6uN/Fv
         co4WdK3ZzLA869rkQ5pPijLmImL+S18Z3VGE2SzBRJpLhEyCLfDmbSRoJ9HSNIzZ93Q3
         md5w==
X-Gm-Message-State: AOAM5335lPV97VNJTJgQmEPB+2yZkChZm02RwbbGrhzhP4sSO3+QXUmr
        IVyTkCtIPt2mNjSQcVclBdnxjzu/3JiiAM9tOz0=
X-Google-Smtp-Source: ABdhPJzCbOj1KEERoOizE5nFoQrtWVhtDxa5igMqyGnmwwDfZ12nc/2x3mxL2z0PTn/ivUgMyLBp8A==
X-Received: by 2002:a17:906:1151:: with SMTP id i17mr11899657eja.250.1607703357882;
        Fri, 11 Dec 2020 08:15:57 -0800 (PST)
Received: from localhost ([2620:10d:c093:400::5:ee7a])
        by smtp.gmail.com with ESMTPSA id ga11sm7215778ejb.34.2020.12.11.08.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 08:15:57 -0800 (PST)
Date:   Fri, 11 Dec 2020 17:13:52 +0100
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/2] block: no-copy bvec for direct IO
Message-ID: <20201211161352.GB291478@cmpxchg.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <51905c4fcb222e14a1d5cb676364c1b4f177f582.1607477897.git.asml.silence@gmail.com>
 <20201209084005.GC21968@infradead.org>
 <20201211140622.GA286014@cmpxchg.org>
 <2404b68a-1569-ce25-c9c4-00d7e42f9e06@gmail.com>
 <20201211153836.GA291478@cmpxchg.org>
 <6507b474-6f91-f99d-1dff-d7c21462813e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6507b474-6f91-f99d-1dff-d7c21462813e@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 11, 2020 at 03:47:23PM +0000, Pavel Begunkov wrote:
> On 11/12/2020 15:38, Johannes Weiner wrote:
> > On Fri, Dec 11, 2020 at 02:20:11PM +0000, Pavel Begunkov wrote:
> >> On 11/12/2020 14:06, Johannes Weiner wrote:
> >>> On Wed, Dec 09, 2020 at 08:40:05AM +0000, Christoph Hellwig wrote:
> >>>>> +	/*
> >>>>> +	 * In practice groups of pages tend to be accessed/reclaimed/refaulted
> >>>>> +	 * together. To not go over bvec for those who didn't set BIO_WORKINGSET
> >>>>> +	 * approximate it by looking at the first page and inducing it to the
> >>>>> +	 * whole bio
> >>>>> +	 */
> >>>>> +	if (unlikely(PageWorkingset(iter->bvec->bv_page)))
> >>>>> +		bio_set_flag(bio, BIO_WORKINGSET);
> >>>>
> >>>> IIRC the feedback was that we do not need to deal with BIO_WORKINGSET
> >>>> at all for direct I/O.
> >>>
> >>> Yes, this hunk is incorrect. We must not use this flag for direct IO.
> >>> It's only for paging IO, when you bring in the data at page->mapping +
> >>> page->index. Otherwise you tell the pressure accounting code that you
> >>> are paging in a thrashing page, when really you're just reading new
> >>> data into a page frame that happens to be hot.
> >>>
> >>> (As per the other thread, bio_add_page() currently makes that same
> >>> mistake for direct IO. I'm fixing that.)
> >>
> >> I have that stuff fixed, it just didn't go into the RFC. That's basically
> >> removing replacing add_page() with its version without BIO_WORKINGSET
> 
> I wrote something strange... Should have been "replacing add_page() in
> those functions with a version without BIO_WORKINGSET".

No worries, I understood.

> >> in bio_iov_iter_get_pages() and all __bio_iov_*_{add,get}_pages() +
> >> fix up ./fs/direct-io.c. Should cover all direct cases if I didn't miss
> >> some.
> > 
> > Ah, that's fantastic! Thanks for clarifying.
> 
> To keep it clear, do we go with what I have stashed (I'm planning to
> reiterate this weekend)? or you're going to write it up yourself?
> Just in case there is some cooler way you have in mind :)

Honestly, I only wrote all my ideas down and asked for feedback
because I wasn't super excited about any of them ;-)

If your changes happen to separate the direct io path from the
buffered io path naturally, I'm okay with it.

I'd say let's go with what you already have and see whether Jens and
Christoph like it. We can always do follow-on cleanups.
