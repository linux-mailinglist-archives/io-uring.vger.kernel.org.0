Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57852536EF
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 20:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgHZS0M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 14:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgHZS0D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 14:26:03 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB770C061574
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 11:26:02 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id o12so2916749qki.13
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 11:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ab4+2xFGz8ScvQkP9uzaxhwXK819gPfwVLBetv8zsMQ=;
        b=cJRD+WFYB9jJRljeORq2jE+JmoHQETqZiCEQajF7CnYrk3UWxoMcH0VSqEbmdYbgiO
         joeeXT43iaMOgMeYn1KTiCH6y7ks5TMoYy3OGp7VO0q0XGDJR8rxb+XGZQNBgWTwaHUO
         SeDEIUvxXEeOhlt0QhV5LfgJ5uPdKzU0/8uVIocOFHliC7PYJXGaMdf7dPZ/xZH7tqMP
         oVqEBupO7b4WLs8Isjb5TSwyq9NWuwT27rYJ5MyGBfdyAFrW0AmYD1mQOPFq5v8l1gi4
         RkpQZ1lbgOC4Hzz0T2HNKnf0Z/iDi5tsMmPkI4/Xv2p3n40oy9qs8SpEEkd+ZZ7Gzp5D
         9Mpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ab4+2xFGz8ScvQkP9uzaxhwXK819gPfwVLBetv8zsMQ=;
        b=jTVbXzTbJ/vweeqqIJs/CW9hzBIS7zlqvOBrqprPwmWaIdDoOmSnQj09vaxsUo8pQC
         cMP+v2+ZLNoky/yZURYfxguglP4WEQ4VvRwFvqSAlOlMVCQ1BPWTyV0oI9+HvjgZfPV8
         AgrlZNxwf5fGyeD8f53h7DE7g6wY4rm1sQMpTqAjGnkNwlZasv/92ewxmvKciqsxNDOC
         ehUDhdwYEZcoNd477owOIxK7Jf4F0HJ67bpSDEo3ImQsl2rMTwYywXNsh19TYrnzLPX7
         K7WYSH0T3fRSqd2Gt19DHpKeiLP3Pb0yTUECWKVfSPoMRnFahtoD0ARGEZYq0pTlkzZF
         E3Cg==
X-Gm-Message-State: AOAM530qJtCFfd5qMvdzkrzRRw/9Nq43HDzu9sYQmmH52M3k4HR4RAID
        s8SKS2+Tqr0DCHNUMJZTOShfLFaZRIQmzLRmftVD6qYyWzesvz01
X-Google-Smtp-Source: ABdhPJwyXofsVdk/8RxY6X6uohJpDIP6XTRQt8GeB6fWb+WuxoqMj3sgoxAsUWKxZs5R8ENoxd3eoZlVvL3dWEmYrOU=
X-Received: by 2002:a37:8d7:: with SMTP id 206mr9163139qki.422.1598466360953;
 Wed, 26 Aug 2020 11:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
 <639db33b-08f2-4e10-8f06-b6d345677df8@kernel.dk> <308222a7-8bd2-44a6-c46c-43adf5469fa3@kernel.dk>
 <c07b29d1-fff4-3019-4cba-0566c8a75fd0@kernel.dk> <CAAss7+rKt6Eh7ozCz5syJSOjVVaZnrVSXi8zS8MxuPJ=kcUwCQ@mail.gmail.com>
 <ab3ddb12-c3ca-5ebb-32ff-d041f8eb20d1@kernel.dk> <CAAss7+o5_74C3tG09Yw2KaL4B7vVg68aNf=UF-YmTaNGokSOfQ@mail.gmail.com>
 <432c76f2-9893-83b0-5cee-b001070f886d@kernel.dk>
In-Reply-To: <432c76f2-9893-83b0-5cee-b001070f886d@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Wed, 26 Aug 2020 20:25:49 +0200
Message-ID: <CAAss7+r17LPZwun2ex4puSS_gkZz42p9s0Ta57yyD6XKV814oQ@mail.gmail.com>
Subject: Re: io_uring file descriptor address already in use error
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 26 Aug 2020 at 15:44, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/25/20 9:01 PM, Josef wrote:
> >> In order for the patch to be able to move ahead, we'd need to be able
> >> to control this behavior. Right now we rely on the file being there if
> >> we need to repoll, see:
> >>
> >> commit a6ba632d2c249a4390289727c07b8b55eb02a41d
> >> Author: Jens Axboe <axboe@kernel.dk>
> >> Date:   Fri Apr 3 11:10:14 2020 -0600
> >>
> >>     io_uring: retry poll if we got woken with non-matching mask
> >>
> >> If this never happened, we would not need the file at all and we could
> >> make it the default behavior. But don't think that's solvable.
> >>
> >>> is there no other way around to close the file descriptor? Even if I
> >>> remove the poll, it doesn't work
> >>
> >> If you remove the poll it should definitely work, as nobody is holding a
> >> reference to it as you have nothing else in flight. Can you clarify what
> >> you mean here?
> >>
> >> I don't think there's another way, outside of having a poll (io_uring
> >> or poll(2), doesn't matter, the behavior is the same) being triggered in
> >> error. That doesn't happen, as mentioned if you do epoll/poll on a file
> >> and you close it, it won't trigger an event.
> >>
> >>> btw if understood correctly poll remove operation refers to all file
> >>> descriptors which arming a poll in the ring buffer right?
> >>> Is there a way to cancel a specific file descriptor poll?
> >>
> >> You can cancel specific requests by identifying them with their
> >> ->user_data. You can cancel a poll either with POLL_REMOVE or
> >> ASYNC_CANCEL, either one will find it. So as long as you have that, and
> >> it's unique, it'll only cancel that one specific request.
> >
> > thanks it works, my bad, I was not aware that user_data is associated
> > with the poll request user_data...just need to remove my server socket
> > poll which binds to an address so I think this patch is not really
> > necessary
> >
> > btw IORING_FEAT_FAST_POLL feature which arming poll for read events,
> > how does it work when the file descriptor(not readable yet) wants to
> > read(non blocking) something and I close(2) the file descriptor? I'm
> > guessing io_uring doesn't hold any reference to it anymore right?
>
> Most file types will *not* notify you through poll if they get closed,
> so it'll just sit there until canceled. This is the same with poll(2) or
> epoll(2). io_uring will continue to hold a reference to the file, it
> does that over request completion for any request that uses a file.


okay, btw according to the man page IORING_OP_POLL_REMOVE it's unclear
to me what value user_data contains in the cqe
I'm guessing user_data is always 0 right? just tested it with liburing
I got always 0(user_data) even if there is no polling request


---
Josef Grieb
