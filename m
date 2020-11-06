Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A832A93B1
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 11:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgKFKIH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 05:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgKFKIG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 05:08:06 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DD2C0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 02:08:05 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id 126so1115674lfi.8
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 02:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GbzzshkzRr+lGPbbHp3UIh4O45Aa72enWtS1Ov7TaxY=;
        b=toh0iMumfabIcRkjYol1OX0OJhYCs9RwgWzXr9WuG5u88hTG/avojOQezub18xs3HT
         R7FvBOPjUIUpcKdU3ncyiDSUevaaX2cRNHHc59TTRAO789WtTdTK7O3mpC6v0lV4QNLs
         SkjV2l9vJBnQEwBWoYAv8itCZBDXztISYAmUV4csH8eeJUIHofPKsIQbwd5dFcV8Psdg
         5pLjGQOTZi/vPk6YVfh++9dzBqLe8XzhPH+7r3JHFJRF1jr8TjH4kZSwx3BkobKQJHq4
         bJTJMfme3LzSzLa8xF3SuFCq/YBrFTfTeaPskpI7QR9JASecQngMKW8YxJQ372Xy3231
         GS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GbzzshkzRr+lGPbbHp3UIh4O45Aa72enWtS1Ov7TaxY=;
        b=kZGXk5xhqswADdB7fDh3wZaWczRDBjKYzKxwAuR7Z9R7TAVAqg/bP4HFixRZ/3vsuy
         7971KjGFqrVsBE//vKUV7hDO7JLFYdCcUGSql7s+xh/HKURI8aA6Hz0zhELXyfpD4EoD
         GOY3o+jLf8/D7fRR3pCx5l+itPAx0hCzc6GARe/9G7orqNIvsq+SpF8CltlF+VgkM3/J
         +qHQwfiqLkht2ziXzX9lMW3F00IZnvKfXgsCgDC+qGfzRhERdQdhcrGXopgDFjtKNKNm
         JuytbWuxWYmfig9sk4irIdb3a+eJbwu/NyBj0S7KbUiBMBrKGTcIFKJtOI+EQ0ETMuct
         j6QA==
X-Gm-Message-State: AOAM533ny/uZlyFOpGiQ5B7rEwuEmff0yawwI/s9tJlw9KCFxgKURWwG
        DctXgl7tGKtXNxPK+hHxlDs=
X-Google-Smtp-Source: ABdhPJx2PVJtSJEOu/J54AjQNM7Lxjl8th6orN5VFxMxTXnycx/at2ZmTc3CR1X2EktYKrYX1YAsnw==
X-Received: by 2002:a19:4b0a:: with SMTP id y10mr639083lfa.570.1604657283623;
        Fri, 06 Nov 2020 02:08:03 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.gmail.com with ESMTPSA id m132sm107356lfa.34.2020.11.06.02.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 02:08:02 -0800 (PST)
Date:   Fri, 6 Nov 2020 17:08:00 +0700
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
Message-ID: <20201106100800.GA3431563@carbon.v>
References: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
 <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
 <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
 <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
 <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
 <361ab9fb-a67b-5579-3e7b-2a09db6df924@kernel.dk>
 <9b52b4b1-a243-4dc0-99ce-d6596ca38a58@gmail.com>
 <266e0d85-42ed-e0f8-3f0b-84bcda0af912@kernel.dk>
 <ae71b04d-b490-7055-900b-ebdbe389c744@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae71b04d-b490-7055-900b-ebdbe389c744@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 05, 2020 at 08:57:43PM +0000, Pavel Begunkov wrote:
> On 05/11/2020 20:49, Jens Axboe wrote:
> > On 11/5/20 1:35 PM, Pavel Begunkov wrote:
> >> On 05/11/2020 20:26, Jens Axboe wrote:
> >>> On 11/5/20 1:04 PM, Pavel Begunkov wrote:
> >>>> On 05/11/2020 19:37, Jens Axboe wrote:
> >>>>> On 11/5/20 7:55 AM, Pavel Begunkov wrote:
> >>>>>> On 05/11/2020 14:22, Pavel Begunkov wrote:
> >>>>>>> On 05/11/2020 12:36, Dmitry Kadashev wrote:
> >>>>>> Hah, basically filename_parentat() returns back the passed in filename if not
> >>>>>> an error, so @oldname and @from are aliased, then in the end for retry path
> >>>>>> it does.
> >>>>>>
> >>>>>> ```
> >>>>>> put(from);
> >>>>>> goto retry;
> >>>>>> ```
> >>>>>>
> >>>>>> And continues to use oldname. The same for to/newname.
> >>>>>> Looks buggy to me, good catch!
> >>>>>
> >>>>> How about we just cleanup the return path? We should only put these names
> >>>>> when we're done, not for the retry path. Something ala the below - untested,
> >>>>> I'll double check, test, and see if it's sane.
> >>>>
> >>>> Retry should work with a comment below because it uses @oldname
> >>>> knowing that it aliases to @from, which still have a refcount, but I
> >>>> don't like this implicit ref passing. If someone would change
> >>>> filename_parentat() to return a new filename, that would be a nasty
> >>>> bug.
> >>>
> >>> Not a huge fan of how that works either, but I'm not in this to rewrite
> >>> namei.c...
> >>
> >> There are 6 call sites including do_renameat2(), a separate patch would
> >> change just ~15-30 lines, doesn't seem like a big rewrite.
> > 
> > It just seems like an utterly pointless exercise to me, something you'd
> > go through IFF you're changing filename_parentat() to return a _new_
> > entry instead of just the same one. And given that this isn't the only
> > callsite, there's precedence there for it working like that. I'd
> > essentially just be writing useless code.
> > 
> > I can add a comment about it, but again, there are 6 other call sites.
> 
> Ok, but that's how things get broken. There is one more idea then,
> instead of keeping both oldname and from, just have from. May make
> the whole thing easier.
> 
> int do_renameat2(struct filename *from)
> {
> ...
> retry:
>     from = filename_parentat(from, ...);
> ...
> exit:
>     if (!IS_ERR(from))
>         putname(from);
> }

That's pretty much what do_unlinkat() does btw. Thanks Pavel for looking
into this!

Can I pick your brain some more? do_mkdirat() case is slightly
different:

static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
{
	struct dentry *dentry;
	struct path path;
	int error;
	unsigned int lookup_flags = LOOKUP_DIRECTORY;

retry:
	dentry = user_path_create(dfd, pathname, &path, lookup_flags);

If we just change @pathname to struct filename, then user_path_create
can be swapped for filename_create(). But the same problem on retry
arises. Is there some more or less "idiomatic" way to solve this?

-- 
Dmitry
