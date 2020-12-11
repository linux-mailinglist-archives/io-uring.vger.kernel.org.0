Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE762D79A1
	for <lists+io-uring@lfdr.de>; Fri, 11 Dec 2020 16:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391885AbgLKPl3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Dec 2020 10:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391209AbgLKPlZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Dec 2020 10:41:25 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A15C0613CF
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 07:40:44 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id i24so9764571edj.8
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 07:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EYEhmqgMBelT+r3UvsYmm6GV5gehaW4irkf5MJK5PqY=;
        b=eSC7wuVh8qa+mVWnfXaO9dQlrHtO3/aEXpRaX3SHQLSsMEZITngILaZpEc6gFEZ+tU
         Rf/Q6ujYBZFLFj5m89//f32/kztfEBHJQzk1KPL0byYiBa0pdbKpu+IMzwa+FA4tSL2O
         qVwCXmHnIWJoy0ZlFoQUpZTxQ9yxLg+gCMVd+zNbuKsdKFAwXjyEitI1ngkNBp/OVq8x
         gzKpZMyhMdx4E9fk86amdU9GOS0cyxyM65ZXxElY9eZRgMcKFMBp3GN8NyUTpmXF48mk
         fAzWzh/vI1wXEqtEjzNbxFuQwi0wmFEWFouKG5ARMzSRyDdD9QfBVkI8Pjv+Tp2W/bjI
         YAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EYEhmqgMBelT+r3UvsYmm6GV5gehaW4irkf5MJK5PqY=;
        b=IDyjkWvpEJ9RQ2laVRJrLqALtJogd5gsiHktP9FOUdZgDAbM35SR9WdgcK0fIGmu80
         tl/UIiS8lpFx4YJ0lhaXw07gp8xyAqILjitXyAmq6AtBLSQlf5PMcj/c3jBdFpqRqxaU
         d0+SFAzXmOVwtMQWKEU9pdEaWOMCsuOlD8BJqpbmNLpHN/IMx4ShfjHdaKVa4CDYsavO
         YlIkunyTVSZ+Cf0H/XXOREdQMX77Kmvd7qaWQN6JpuBUgILw72apMvMb9a95pjQsJ32u
         88Q2l5Dyls7BGx86S7DoxUe+Q3UcTNclfk1fxqwh0/r9sm9HFUkQ8WwJAl+6em4fGBxD
         Arpw==
X-Gm-Message-State: AOAM530KRUy1ZadPCn8uvD3bSZFqpgi5fubgvIo7TPyWvIIQNyfh5DDz
        gsuJVfJ4/xUnKfKVGRHSdsXSkA==
X-Google-Smtp-Source: ABdhPJxHE2IdtUNCOx0bPjb2SxLmU5wnNVe/UoEiscHoKgu4ucw9owJA6iDcNGBT7y3Qyq1Ng9g1MA==
X-Received: by 2002:aa7:cac2:: with SMTP id l2mr12401004edt.141.1607701243402;
        Fri, 11 Dec 2020 07:40:43 -0800 (PST)
Received: from localhost ([2620:10d:c093:400::5:ee7a])
        by smtp.gmail.com with ESMTPSA id k21sm7032894ejv.80.2020.12.11.07.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:40:42 -0800 (PST)
Date:   Fri, 11 Dec 2020 16:38:36 +0100
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/2] block: no-copy bvec for direct IO
Message-ID: <20201211153836.GA291478@cmpxchg.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <51905c4fcb222e14a1d5cb676364c1b4f177f582.1607477897.git.asml.silence@gmail.com>
 <20201209084005.GC21968@infradead.org>
 <20201211140622.GA286014@cmpxchg.org>
 <2404b68a-1569-ce25-c9c4-00d7e42f9e06@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2404b68a-1569-ce25-c9c4-00d7e42f9e06@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 11, 2020 at 02:20:11PM +0000, Pavel Begunkov wrote:
> On 11/12/2020 14:06, Johannes Weiner wrote:
> > On Wed, Dec 09, 2020 at 08:40:05AM +0000, Christoph Hellwig wrote:
> >>> +	/*
> >>> +	 * In practice groups of pages tend to be accessed/reclaimed/refaulted
> >>> +	 * together. To not go over bvec for those who didn't set BIO_WORKINGSET
> >>> +	 * approximate it by looking at the first page and inducing it to the
> >>> +	 * whole bio
> >>> +	 */
> >>> +	if (unlikely(PageWorkingset(iter->bvec->bv_page)))
> >>> +		bio_set_flag(bio, BIO_WORKINGSET);
> >>
> >> IIRC the feedback was that we do not need to deal with BIO_WORKINGSET
> >> at all for direct I/O.
> > 
> > Yes, this hunk is incorrect. We must not use this flag for direct IO.
> > It's only for paging IO, when you bring in the data at page->mapping +
> > page->index. Otherwise you tell the pressure accounting code that you
> > are paging in a thrashing page, when really you're just reading new
> > data into a page frame that happens to be hot.
> > 
> > (As per the other thread, bio_add_page() currently makes that same
> > mistake for direct IO. I'm fixing that.)
> 
> I have that stuff fixed, it just didn't go into the RFC. That's basically
> removing replacing add_page() with its version without BIO_WORKINGSET
> in bio_iov_iter_get_pages() and all __bio_iov_*_{add,get}_pages() +
> fix up ./fs/direct-io.c. Should cover all direct cases if I didn't miss
> some.

Ah, that's fantastic! Thanks for clarifying.
