Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4523D21B66C
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 15:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgGJNaO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 09:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgGJNaN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 09:30:13 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0E1C08C5CE;
        Fri, 10 Jul 2020 06:30:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so5929094wml.3;
        Fri, 10 Jul 2020 06:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lae28X5NqcxG2FkZllIwJ7rLXNOqpJ0hcVAbxGcaJfo=;
        b=KcwrI94ePdRwkKKuRogJd8GJW5bDThOJjUI7BVmH6y23YIeZAxnzrTIJ8aYRPDmkc1
         +FIzAob5CZY0gvuCboQ/YlM0icsgy6oaztKFcopRxRuXuXpBxAPVfc/Jykb2trIlyV65
         EQM2Zxb967Z+HD7G5XpF0GzM4TvfcqiCEwYE1EeuSMdfeyUVtEBhxqU+toyhzmFCnbf2
         S3o1k7vViI85Rxsq6y9HQDzuWrqXfHwVjPxumG8I3jZZg0oceB02T4e0O7eUGLuvcdLa
         9bO9qwRoot5hjvxXmk3y1awkmnn0kg4QeJDkzVLchkWVtGf0nux2hmglYpva45PAFfR6
         876g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lae28X5NqcxG2FkZllIwJ7rLXNOqpJ0hcVAbxGcaJfo=;
        b=nnN7lFH1HYsY46JT/Spb5+oThT7GJN3oB8mCY4FwvPvJkQdpwwssBxbd5O2kTBM1ex
         i4ISQISo7zHfdJ95Nzmra2HYJLxoPpegO9X7l4qn68Yn5YrRfy2LjYfa2YOlM3WlW9Zm
         /fTe0c6PhccleszEeNFMuRSqsDyzWKBRyf4eH4QBvlo4ZRgjc5TKniWl+mGohuwnj5L3
         QTnha61SOqPQnWRPA70CblcmDP1ipkJlZY2cW9h6oJwpee2XFvgqMDc2pdzak3uF8OfD
         OpCDJrHyDbkKWZeMrhzbbEfnX9H36wdRW5SkF5mcs2BJ1sjOByB3nXMoWQZ6a7eYcv4g
         hJnA==
X-Gm-Message-State: AOAM531rYXUuBN8xusyef0pBj2FEpq3dEs6I9x8JNzNPPeZ3mMxMbrra
        eu6OCEJDEgHxwzpbHfoA5V/ckMWu6ImXpT9+6Dc=
X-Google-Smtp-Source: ABdhPJxV6sZDd/duo2t8dOTY3pdMfPW0OzsDpz5mQA4e2iT3L9zXWuR/crJcD3LQi6MzOrxc+eK7xqhsbYwEDDNTizk=
X-Received: by 2002:a7b:cc92:: with SMTP id p18mr5455500wma.4.1594387811885;
 Fri, 10 Jul 2020 06:30:11 -0700 (PDT)
MIME-Version: 1.0
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com> <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org> <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org> <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk> <20200710130912.GA7491@infradead.org>
In-Reply-To: <20200710130912.GA7491@infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 10 Jul 2020 18:59:45 +0530
Message-ID: <CA+1E3rJSiS58TE=hHv5wVv-umJ19_7zKv-JqZTNzD=xi3MoX1g@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        "Matias Bj??rling" <mb@lightnvm.io>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 6:39 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Jul 09, 2020 at 12:50:27PM -0600, Jens Axboe wrote:
> > It might, if you have IRQ context for the completion. task_work isn't
> > expensive, however. It's not like a thread offload.
> >
> > > Using flags have not been liked here, but given the upheaval involved so
> > > far I have begun to feel - it was keeping things simple. Should it be
> > > reconsidered?
> >
> > It's definitely worth considering, especially since we can use cflags
> > like Pavel suggested upfront and not need any extra storage. But it
> > brings us back to the 32-bit vs 64-bit discussion, and then using blocks
> > instead of bytes. Which isn't exactly super pretty.
>
> block doesn't work for the case of writes to files that don't have
> to be aligned in any way.  And that I think is the more broadly
> applicable use case than zone append on block devices.

But when can it happen that we do zone-append on a file (zonefs I
asssume), and device returns a location (write-pointer essentially)
which is not in multiple of 512b?


-- 
Joshi
