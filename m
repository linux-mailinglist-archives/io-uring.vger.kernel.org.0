Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3AA15AAE1
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 15:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgBLOXU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 09:23:20 -0500
Received: from mail-lf1-f46.google.com ([209.85.167.46]:34591 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgBLOXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 09:23:20 -0500
Received: by mail-lf1-f46.google.com with SMTP id l18so1756435lfc.1
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 06:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/zOpDpLrMd2NLa3wJlzierP2BVjcQfDv/FVJNprJMAQ=;
        b=tRLJ6QK6NzTNSqEGS7urdpu+ttkmkA68mx40tr1P3poE3kmCb/lAvCqqSYqMsyFa07
         xD3Lrrwg9nhHGeEa+FdBvprZNDWh2RjjGeKq1sDa9Shy2uJ5xYZZJ3Bs1jrvXBYvRspm
         EF1IwKYOgOCUP00RjO54yyuicmVH9oJGlYqvQKkzncn9Di8lo5M3A7YLuaFEjnQyQEhv
         e1CyheSff7D2K/Fxic+dyUIk83zbSyUwCmTIJKD8QsJg84IsXIxirhum5FOQVDH6rgBK
         nkr0Q/fc9QFXeCKukxj2WNv9iaFWsMWdM41f8KGZ1IoHiXLPmv7z0fid0tWphCBWvcfU
         CJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/zOpDpLrMd2NLa3wJlzierP2BVjcQfDv/FVJNprJMAQ=;
        b=WoGbX33qnIhXTPXb+rYfeK/vM8cy27GLjm40zeSm7qDaT0iJ9MCP+VGNHP5rGZP37a
         oLnxuCeFHfjyXLwX+s8yztr57TfLFZc2q2vPepAE+nSvLwlVi0VGqkonCUnCpX4WZbwg
         lm+UTrADT2E+mjBOnIRKHeQb6QOCH+pduyIS3BHtzpiBXb3xLft5Z+Xm6fpQd9ZZ1w6C
         2WjUcx8Gu0l8awBAD333MDPL58E/+o4vI8/eoezxnT6qcvkfwJqok99Aq0Q99fZrq1gw
         /B5IXwtEI6qQXBOzH79/H74KgZGSGA6BXVRF7IPiinp+HszrNbpr4mdOqGc7sMZBBK8W
         YVtQ==
X-Gm-Message-State: APjAAAXLWkxN8LwpB7//5tpmLofrDlmJPQs6XEkSvGGYX77YOzu7VAqV
        EcyeRH9lDSKs0oxyb7Vc3pprfNxTg1KUkmjxE2JnqA==
X-Google-Smtp-Source: APXvYqzLo8lPB8O2odMHYobGPnyXGoiH7bS5UAd3tZc0vMxbwOHEX/j2fnZw8hPEO5MFZvRVT3K8GOan30AzuqZEUjs=
X-Received: by 2002:a19:c014:: with SMTP id q20mr6900790lff.208.1581517398275;
 Wed, 12 Feb 2020 06:23:18 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zbYp0D5NSV1hqxpU7C-Ki+ffwretuXEYCxX5cbazA5WqQ@mail.gmail.com>
 <bc739db5-9dac-dc6d-ef14-aef269864598@kernel.dk>
In-Reply-To: <bc739db5-9dac-dc6d-ef14-aef269864598@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Wed, 12 Feb 2020 09:23:06 -0500
Message-ID: <CAD-J=zY1dhygi=0yapu6-RVj5nPW9z5bhOi+JxS1eZb8y1-32g@mail.gmail.com>
Subject: Re: how is register_(buffer|file) supposed to work?
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 12, 2020 at 9:20 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/11/20 9:12 PM, Glauber Costa wrote:
> > Hi,
> >
> > I am trying to experiment with the interface for registering files and buffers.
> >
> > (almost) Every time I call io_uring_register with those opcodes, my
> > application hangs.
> >
> > It's easy to see the reason. I am blocking here:
> >
> >                 mutex_unlock(&ctx->uring_lock);
> >                 ret = wait_for_completion_interruptible(&ctx->completions[0]);
> >                 mutex_lock(&ctx->uring_lock);
> >
> > Am I right in my understanding that this is waiting for everything
> > that was submitted to complete? Some things in my ring may never
> > complete: for instance one may be polling for file descriptors that
> > may never really become ready.
> >
> > This sounds a bit too restrictive to me. Is this really the intended
> > use of the interface?
>
> For files, this was added in the current merge window:
>

Ok, so this is what I was missing:

> commit 05f3fb3c5397524feae2e73ee8e150a9090a7da2
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Mon Dec 9 11:22:50 2019 -0700
>
>     io_uring: avoid ring quiesce for fixed file set unregister and update
>
> which allows you to call IORING_REGISTER_FILES_UPDATE without having to
> quiesce the ring. File sets can be sparse, you can register with an fd
> of -1 and then later use FILES_UPDATE (or IORING_OP_FILES_UPDATE) to
> replace it with a real entry. You can also replace a real entry with a
> new one, or switch it to sparse again.

^^^ this

I thought I've seen EBADF errors when registering -1, but maybe it
wasn't -1, it was
just really an invalid fd.

For memory I guess I could register early on and draw from a poll.
That's a bit inconvenient
as ideally that poll would grow and shrink dynamically, but it works

I'll give it a try
