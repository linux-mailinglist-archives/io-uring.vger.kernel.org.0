Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B01125149F
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 10:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgHYIw2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 04:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgHYIw1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 04:52:27 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA09C061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 01:52:26 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id u3so10233263qkd.9
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 01:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gaCBewwpabkMrS4ToRtqJsHXuCZO3TzKg5nwUPaP+PY=;
        b=ZChZP2pr3PNQy6v4rA8QfMUIH+FShq3+VI5BTUbMgVRZ1auLUf4xaNlVmXOU32/eQc
         f7/TSbGzNzIS0uwR2xWfV8UYoxThQ37qtJp9lDxw2D9bdq+65rrNlmuojbae0E00QC9n
         TGMv6Qy0gEQkhCH3HsHEmPa9nLXlTQSV4hPjN5tq4RLSrVBfJwyNH1aT4YBWCyaYNqF/
         eSCdpVOmdg2XWy9jhm/bQ4l/wrJ83FWAcwiTCS7D+oRB1UI/XzvW4Ikgy2KsDxn6QStr
         tMsjHgFoczdwti6fNpIXACwqMQNaccsZHbnYrUNuTJ/0TF/0vPLryXwLQlW3YA+CR5O2
         Q/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gaCBewwpabkMrS4ToRtqJsHXuCZO3TzKg5nwUPaP+PY=;
        b=r90tLtSpV1kCRwWc+/1i76TddtIXR7Mdo0ARJbQ4rgefFqZT+FNhDD+X9fZutE/uol
         tCQvmVAEeO+dE7KpOTxJQ0s+m4SjXsDZuWldbAirGV6okhuHkUUiDn47iUT4jl3zyL0X
         rr7vVcXLS5pQE6cgE5eAep2hkX6E6O3CB7cL75mE0cjjouLVKngRtF2OSgjbfOqmMpXU
         tcEz4PG1z7NN8LjgQFH/qIMPR7xn7S/97XjuYkdndHpL9WDNO81nhIuxTAECD+U/l+hN
         xrnnPH6rLHVSKBXCelePzO9xCKak94v1Yk2F7JP6t6mWdYaEOsijmkjwcaWCqK238gWU
         lF+A==
X-Gm-Message-State: AOAM5321IcCwUKzzUqlSprrjBWkTIQKHu2rp+NyhzYNvfL81MgsfjwkG
        cK1vHJ952rrCQCcZQ8ucgP8Z8jwrikJ/m9eppn73A4T72V8=
X-Google-Smtp-Source: ABdhPJwRwZACmguPcgaWVZxkVfxSAeslUT6pyPrYxd8o/0D7kRLOchtQPG5gF+N5+s5a+awlkYKHt9cVTXVaax8FBfM=
X-Received: by 2002:a37:5fc4:: with SMTP id t187mr8680123qkb.224.1598345546113;
 Tue, 25 Aug 2020 01:52:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk> <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
 <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk> <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
 <CAF-ewDrMO-qGOfXdZUyaGBzH+yY3EBPHCO_bMvj6yXhZeCFaEw@mail.gmail.com>
 <282f1b86-0cf3-dd8d-911f-813d3db44352@kernel.dk> <CAF-ewDrRqiYqXHhbHtWjsc0VuJQLUynkiO13zH_g2RZ1DbVMMg@mail.gmail.com>
 <ddc3c126-d1bd-a345-552b-35b35c507575@kernel.dk> <42573664-450d-bfe4-aa96-ca1ae0704adb@kernel.dk>
In-Reply-To: <42573664-450d-bfe4-aa96-ca1ae0704adb@kernel.dk>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Tue, 25 Aug 2020 11:52:14 +0300
Message-ID: <CAF-ewDqffa=e-EBOdreX9S7CXagM-ohQSsyyDMooDR83W9kjGg@mail.gmail.com>
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

this patch fixes the issue with 0 reads. there seems to be a
regression that is not specific to uring,
regular syscall reads slowed down noticeably.

On Mon, 24 Aug 2020 at 20:44, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/24/20 10:18 AM, Jens Axboe wrote:
> > On 8/24/20 10:13 AM, Dmitry Shulyak wrote:
> >> On Mon, 24 Aug 2020 at 19:10, Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 8/24/20 9:33 AM, Dmitry Shulyak wrote:
> >>>> On Mon, 24 Aug 2020 at 17:45, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>
> >>>>> On 8/24/20 8:06 AM, Jens Axboe wrote:
> >>>>>> On 8/24/20 5:09 AM, Dmitry Shulyak wrote:
> >>>>>>> library that i am using https://github.com/dshulyak/uring
> >>>>>>> It requires golang 1.14, if installed, benchmark can be run with:
> >>>>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
> >>>>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_5 -benchtime=8000000x
> >>>>>>>
> >>>>>>> note that it will setup uring instance per cpu, with shared worker pool.
> >>>>>>> it will take me too much time to implement repro in c, but in general
> >>>>>>> i am simply submitting multiple concurrent
> >>>>>>> read requests and watching read rate.
> >>>>>>
> >>>>>> I'm fine with trying your Go version, but I can into a bit of trouble:
> >>>>>>
> >>>>>> axboe@amd ~/g/go-uring (master)>
> >>>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
> >>>>>> # github.com/dshulyak/uring/fixed
> >>>>>> fixed/allocator.go:38:48: error: incompatible type for field 2 in struct construction (cannot use type uint64 as type syscall.Iovec_len_t)
> >>>>>>    38 |  iovec := []syscall.Iovec{{Base: &mem[0], Len: uint64(size)}}
> >>>>>>       |                                                ^
> >>>>>> FAIL  github.com/dshulyak/uring/fs [build failed]
> >>>>>> FAIL
> >>>>>> axboe@amd ~/g/go-uring (master)> go version
> >>>>>> go version go1.14.6 gccgo (Ubuntu 10.2.0-5ubuntu1~20.04) 10.2.0 linux/amd64
> >>>>>
> >>>>> Alright, got it working. What device are you running this on? And am I
> >>>>> correct in assuming you get short reads, or rather 0 reads? What file
> >>>>> system?
> >>>>
> >>>> Was going to look into this.
> >>>> I am getting 0 reads. This is on some old kingston ssd, ext4.
> >>>
> >>> I can't seem to reproduce this. I do see some cqe->res == 0 completes,
> >>> but those appear to be NOPs. And they trigger at the start and end. I'll
> >>> keep poking.
> >>
> >> Nops are used for draining and closing rings at the end of benchmarks.
> >> It also appears in the beginning because of the way golang runs
> >> benchmarks...
> >
> > OK, just checking if it was expected.
> >
> > But I can reproduce it now, turns out I was running XFS and that doesn't
> > trigger it. With ext4, I do see zero sized read completions. I'll keep
> > poking.
>
> Can you try with this? Looks like some cases will consume bytes from the
> iterator even if they ultimately return an error. If we've consumed bytes
> but need to trigger retry, ensure we revert the consumed bytes.
>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 91e2cc8414f9..609b4996a4e9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3152,6 +3152,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>         } else if (ret == -EAGAIN) {
>                 if (!force_nonblock)
>                         goto done;
> +               /* some cases will consume bytes even on error returns */
> +               iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>                 ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
>                 if (ret)
>                         goto out_free;
> @@ -3293,6 +3295,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>         if (!force_nonblock || ret2 != -EAGAIN) {
>                 kiocb_done(kiocb, ret2, cs);
>         } else {
> +               /* some cases will consume bytes even on error returns */
> +               iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>  copy_iov:
>                 ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
>                 if (!ret)
>
> --
> Jens Axboe
>
