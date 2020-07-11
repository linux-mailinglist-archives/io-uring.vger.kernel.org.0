Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5F721C4D8
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 17:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgGKPbT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 11:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgGKPbT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 11:31:19 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6472C08C5DD
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:31:18 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id o38so6805923qtf.6
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 08:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cW3DDoR+bYXpCqskq28PYCt5nasgCzD6HXyzXGjgR3M=;
        b=uUqY7VZQilaDuVk737d2oFjfD0aXduTqlldv3uiV7ExRW7YEeaB2vW+t6VMT35be0T
         9nPXXOK4hRUDYwDK07mA505RqXCJBMChiGTWgfsyZ/xepzVJh3n1WQfdDcYWzkMijmTg
         DU1CKKDQC07EX0/ldB8VpcDG/d6Ui68cCcyiRG89T6j3IRHEhV1TbA+CQFatvORlU8tb
         MMaBhGWOC1fEV6ifylMeDX+ZA0dxB079iONNZma7T3RbvGFby8rm5Wpk3qtkSqrBnm3B
         cIuNNOiYUjfmHPdxopzy2t4Z6rsSySrNpcEvkzCOz/IJYyc6ShtH9GULsTNrN9ByzDru
         GR3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cW3DDoR+bYXpCqskq28PYCt5nasgCzD6HXyzXGjgR3M=;
        b=sGEpjNHredPvuGqcaWGV9BGjPeieC1uCtcnKXvIcNFDILFpEI4TjCxN+MI63fvjbgD
         VfCshkvAyA38ymZeNdtN1UlJOP99Yc7N1EyoUgWxwSigrHnDlzVeE4TDm9Gas+KLVBjj
         aNdTXxktOg6U4qz7xqbdrFj90/Kst100LY/0pxWqaOAMN95PY25u16DXOvzac/lKgvI6
         PHhpJ6XPbKhpfwQq0tod9mPXsVPOTEq8EC5aFV7jWTwbsln3i8K6ZNZdvAurTndy1gPb
         auNIqniJtsZGSHNoeTcYIK8Wtg6FZVWINtwLTNph9QvMEmyj17szU5cRliXPZ/onMEjA
         yXmA==
X-Gm-Message-State: AOAM532jX6cluMEoKr5S6X7KD38pnM0pgUop9NACEq/CHZt1fVQ19UsK
        wCyvY0tdxrD7UDWQ6IYP+aZHth1WwZ829oLxcIZeUHP11b7X8A==
X-Google-Smtp-Source: ABdhPJybnCEuXrLbgq7EAsiT02xcFp1/efZhincgMgOkG+j8Ji2KNMWy9F2MGRrav1G1GH7lsZKyGiS0uBg8j+xMrH0=
X-Received: by 2002:ac8:260b:: with SMTP id u11mr76995028qtu.380.1594481477791;
 Sat, 11 Jul 2020 08:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200711093111.2490946-1-dvyukov@google.com> <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
In-Reply-To: <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 11 Jul 2020 17:31:06 +0200
Message-ID: <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Necip Fazil Yildiran <necip@google.com>, io-uring@vger.kernel.org,
        Hristo Venev <hristo@venev.name>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jul 11, 2020 at 5:16 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/11/20 3:31 AM, Dmitry Vyukov wrote:
> > rings_size() sets sq_offset to the total size of the rings
> > (the returned value which is used for memory allocation).
> > This is wrong: sq array should be located within the rings,
> > not after them. Set sq_offset to where it should be.
> >
> > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > Cc: io-uring@vger.kernel.org
> > Cc: Hristo Venev <hristo@venev.name>
> > Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")
> >
> > ---
> > This looks so wrong and yet io_uring works.
> > So I am either missing something very obvious here,
> > or io_uring worked only due to lucky side-effects
> > of rounding size to power-of-2 number of pages
> > (which gave it enough slack at the end),
> > maybe reading/writing some unrelated memory
> > with some sizes.
> > If I am wrong, please poke my nose into what I am not seeing.
> > Otherwise, we probably need to CC stable as well.
>
> Well that's a noodle scratcher, it's definitely been working fine,
> and I've never seen any out-of-bounds on any of the testing I do.
> I regularly run anything with KASAN enabled too.

Looking at the code more, I am not sure how it may not corrupt memory.
There definitely should be some combinations where accessing
sq_entries*sizeof(u32) more memory won't be OK.
May be worth adding a test that allocates all possible sizes for sq/cq
and fills both rings.
