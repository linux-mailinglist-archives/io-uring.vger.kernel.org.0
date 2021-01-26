Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375F8305830
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 11:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313388AbhAZXCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 18:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389536AbhAZRPD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 12:15:03 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DE7C06178A;
        Tue, 26 Jan 2021 09:14:32 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id jx18so2590226pjb.5;
        Tue, 26 Jan 2021 09:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9RUQDUCB4nEFZH/9cXs5GJzrckaItKmxCSraWMnirXk=;
        b=j3fMrSOEhbc64LKIGw9LoA5TX2A1MwYsnXX/wxqp5wCvR4f8+ezNT6wIaiEiNotTDF
         RlpLsvybHJnsnPtzk4FI/S974NL47u+bIjWabBSNRi2h7IoAZaoE92RRFZSqVEtaX6gx
         7U1+MXIHKskmB7XhcFLRy1mw1XDXCDxzXKQRdagTRclfQQtFFwJMGYngT/umYZ3hqxNL
         8rOXGMJ+3SeQ3PSZiXr1VV+cRbHqvAnuDtjM9Pbh12UE2RrfUlmBO1qxEq0DTJGovjaC
         t3cUkK9ZWenlRhQoi3gKdcWroQfpT5RLX79dquBmnGhgc6x8GxTyrefUipo8eSQfgkNE
         IQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9RUQDUCB4nEFZH/9cXs5GJzrckaItKmxCSraWMnirXk=;
        b=qqzf+Zn4HKqWUIEan4NJX+h2iB7veofJUsyPk4qt0brqOagMsup40emXKCX0/E5vtJ
         QeOpc0MzPF7455clEPObCCteLZQnOsD0b/cFylxpIWkqXFZMvVa+oGNOX0rGBRo2xCvG
         tGumwLRd6DnoxfeBAoHxYQLK43GSG7FBCCHkLmcNO7bQpmQjNjO/gqQr7kqRgSujYI1r
         QNipA3rW7ep8rpQluV7JK4NEsqUcfzS1AV3hfLpKVNGXapdigmT0iU87D9gDMnb1UCXg
         adg4LJVuESypOzqdaFtRvxq6HUIFtTSBTPP8WapPK/BIeRVZktaT7xVIN1k6vxOMK34c
         Z5jw==
X-Gm-Message-State: AOAM533mS99g/x9hNyF8hkcY4cW2Ht9H6fwOWhXnLmgXqUHUeHGzaXA4
        hFYAkNLqbpymlziiPgBaY7wwdcQqJarn5sW32zo=
X-Google-Smtp-Source: ABdhPJzYTKb9IEjRqjI7iyOcJZliWbdlre5eibcyLPnCNHKpuHHBAeMONkMRXQZEIX3rszJM5SLxXQ2HSlQ3BpSFjUE=
X-Received: by 2002:a17:90b:716:: with SMTP id s22mr763424pjz.223.1611681272019;
 Tue, 26 Jan 2021 09:14:32 -0800 (PST)
MIME-Version: 1.0
References: <20201220065025.116516-1-goldstein.w.n@gmail.com>
 <0cdf2aac-6364-742d-debb-cfd58b4c6f2b@gmail.com> <20201222021043.GA139782@gmail.com>
 <32c9ce7e-569d-3f94-535e-00e072de772e@gmail.com>
In-Reply-To: <32c9ce7e-569d-3f94-535e-00e072de772e@gmail.com>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Tue, 26 Jan 2021 12:14:21 -0500
Message-ID: <CAFUsyf+m8SseZ1NzZoYJe4KSH30v-XJeP5P9FvtxQT_5bvsK9Q@mail.gmail.com>
Subject: Re: [PATCH] fs: io_uring.c: Add skip option for __io_sqe_files_update
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     noah <goldstein.n@wustl.edu>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jan 26, 2021 at 7:29 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 22/12/2020 02:10, Noah Goldstein wrote:
> > On Sun, Dec 20, 2020 at 03:18:05PM +0000, Pavel Begunkov wrote:
> >> On 20/12/2020 06:50, noah wrote:> From: noah <goldstein.n@wustl.edu>
> >>>
> >>> This patch makes it so that specify a file descriptor value of -2 will
> >>> skip updating the corresponding fixed file index.
> >>>
> >>> This will allow for users to reduce the number of syscalls necessary
> >>> to update a sparse file range when using the fixed file option.
> >>
> >> Answering the github thread -- it's indeed a simple change, I had it the
> >> same day you posted the issue. See below it's a bit cleaner. However, I
> >> want to first review "io_uring: buffer registration enhancements", and
> >> if it's good, for easier merging/etc I'd rather prefer to let it go
> >> first (even if partially).
>
> Noah, want to give it a try? I've just sent a prep patch, with it you
> can implement it cleaner with one continue.
>

 Absolutely. Will get on it ASAP.

> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index 941fe9b64fd9..b3ae9d5da17e 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -7847,9 +7847,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
> >>      if (IS_ERR(ref_node))
> >>              return PTR_ERR(ref_node);
> >>
> >> -    done = 0;
> >>      fds = u64_to_user_ptr(up->fds);
> >> -    while (nr_args) {
> >> +    for (done = 0; done < nr_args; done++) {
> >>              struct fixed_file_table *table;
> >>              unsigned index;
> >>
> >> @@ -7858,7 +7857,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
> >>                      err = -EFAULT;
> >>                      break;
> >>              }
> >> -            i = array_index_nospec(up->offset, ctx->nr_user_files);
> >> +            if (fd == IORING_REGISTER_FILES_SKIP)
> >> +                    continue;
> >> +
> >> +            i = array_index_nospec(up->offset + done, ctx->nr_user_files);
> >>              table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
> >>              index = i & IORING_FILE_TABLE_MASK;
> >>              if (table->files[index]) {
> >> @@ -7896,9 +7898,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
> >>                              break;
> >>                      }
> >>              }
> >> -            nr_args--;
> >> -            done++;
> >> -            up->offset++;
> >>      }
> >>
> >>      if (needs_switch) {
>
> --
> Pavel Begunkov
