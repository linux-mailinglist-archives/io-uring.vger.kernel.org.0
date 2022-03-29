Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47724EB41D
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 21:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240940AbiC2TcY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 15:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237960AbiC2TcX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 15:32:23 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2483AA5E83
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 12:30:40 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bq8so23225568ejb.10
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 12:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqZtLgWqxSZzXjkAfl775dcXAbHklyN1Q7jRggzdINU=;
        b=AnZOTenKt4SqSKZG+qgI4yIpKq7XeqrAv7qY1uefX74vZi+0np39itbU0kxtO1XUBu
         YNdOZW9yy+BKeSgydZFkhk0+FadldOMmqrT5z/qQWRO7VVYfE8X8uOkqamGI+6fwVqGO
         SXLUXpt6Giq+q+d+DE96gt0LILAjUKT0gcPWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pqZtLgWqxSZzXjkAfl775dcXAbHklyN1Q7jRggzdINU=;
        b=Ofv+Fogi99Wz68SFMOvHuVpX4/gW2kpk/pgsn99GFkzJ0U3XrbDLucoJpzUHdURjkl
         6tGtyTMMOUoir6nl5aKWYG7Fre0k1XSkMvmKtsnE4q8KKkc3vpTdo1lg9NRWSFpDj9Yr
         2D+UZC5snfvcUUK73YD3ukilSSQmLwF3sfSQSpbUvWavSsj+Oxqe/5OlQ08qX8AxXRaS
         ot1jKO6vD9bpwTsLPmO1maf49dltvjwIvycwjoESeJOs8jsgHAIUPeoG1cxY5yR72KfO
         koBtgM+QAcGh+RFT/VROby9Eo4PSNCTnY3T7BocewkdPmkF6CeEVHxMGQUz9v4mVKYGw
         dpGA==
X-Gm-Message-State: AOAM53307XqbGxwS9DRPE6GX95DD0Capvll+RS53V7NrD9c0WSgNSNUK
        c+18ZAOog2aF3am8W/8fIDbWa+NRwbkjU1lEpxBH5A==
X-Google-Smtp-Source: ABdhPJxRfnyP+H4Icz5adD3c6b4T/l9VBc4iwGOlJyJCI7HMnJHB/OAi4bIALe/3XKK+A41MybzK+xn1a15HcmLhE6U=
X-Received: by 2002:a17:907:c16:b0:6db:1dfc:ca73 with SMTP id
 ga22-20020a1709070c1600b006db1dfcca73mr36467850ejc.192.1648582237935; Tue, 29
 Mar 2022 12:30:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk> <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk> <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
In-Reply-To: <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 29 Mar 2022 21:30:26 +0200
Message-ID: <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 29 Mar 2022 at 20:40, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/29/22 12:31 PM, Miklos Szeredi wrote:
> > On Tue, 29 Mar 2022 at 20:26, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 3/29/22 12:21 PM, Miklos Szeredi wrote:
> >>> On Tue, 29 Mar 2022 at 19:04, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 3/29/22 10:08 AM, Jens Axboe wrote:
> >>>>> On 3/29/22 7:20 AM, Miklos Szeredi wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> I'm trying to read multiple files with io_uring and getting stuck,
> >>>>>> because the link and drain flags don't seem to do what they are
> >>>>>> documented to do.
> >>>>>>
> >>>>>> Kernel is v5.17 and liburing is compiled from the git tree at
> >>>>>> 7a3a27b6a384 ("add tests for nonblocking accept sockets").
> >>>>>>
> >>>>>> Without those flags the attached example works some of the time, but
> >>>>>> that's probably accidental since ordering is not ensured.
> >>>>>>
> >>>>>> Adding the drain or link flags make it even worse (fail in casese that
> >>>>>> the unordered one didn't).
> >>>>>>
> >>>>>> What am I missing?
> >>>>>
> >>>>> I don't think you're missing anything, it looks like a bug. What you
> >>>>> want here is:
> >>>>>
> >>>>> prep_open_direct(sqe);
> >>>>> sqe->flags |= IOSQE_IO_LINK;
> >>>>> ...
> >>>>> prep_read(sqe);
> >>>
> >>> So with the below merge this works.   But if instead I do
> >>>
> >>> prep_open_direct(sqe);
> >>>  ...
> >>> prep_read(sqe);
> >>> sqe->flags |= IOSQE_IO_DRAIN;

And this doesn't work either:

prep_open_direct(sqe);
sqe->flags |= IOSQE_IO_LINK;
...
prep_read(sqe);
sqe->flags |= IOSQE_IO_LINK;
...
prep_open_direct(sqe);
sqe->flags |= IOSQE_IO_LINK;
...
prep_read(sqe);

Yeah, the link is not needed for the read (unless the fixed file slot
is to be reused), but link/drain should work as general ordering
instructions, not just in special cases.

Thanks,
Miklos
