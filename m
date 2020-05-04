Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC3A1C37B8
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 13:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgEDLJb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 07:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbgEDLJa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 07:09:30 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A003C061A0F
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 04:09:30 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f18so9172688lja.13
        for <io-uring@vger.kernel.org>; Mon, 04 May 2020 04:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kdLTHxO9IddcIoMI/8THqMR0N6LIXAbkMhmdlHl48Hc=;
        b=EBkBWfDsbVxU7ShnPu9MmCzKnY96MUEv8NG3QCP9FdBISR6BN2GZq9UQ3Cdmg/flkp
         +OVkM1mF0URDaXGbY+OD9SsFs+ceKjLZinXQU+NCB8VLXKVxXZfOmBNODg6s1f2vWgN0
         6+rjuqtE2q09uIcQDXvWXWuS+4MBSvAov8MAMrr+whe/6rNQgDPi7lxMMgo4cllYt658
         jZG7FaTHkSrUDBifEO7ZZomaXD5NM1ez/9Kmv7A99+Vw9wIPnP0o3hTrbAnpSsL8+gHn
         y3zPSNwlkmrx8VTaMHd+KfDN5FJYOHTHFUgzihcLJi01WIe2AsRJjU4JP+mmM38ZBY5d
         Pi/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kdLTHxO9IddcIoMI/8THqMR0N6LIXAbkMhmdlHl48Hc=;
        b=Pj2Mpclp3wKAcrmahJbfc2uF5Edtde7QrHJlRMxP4+uZUR8wZIW4FfBUdUHeKWo4LX
         gNIvEYHgjXnKtxGFEgrBxTd9dvW8DbhwgALJU8DvHfSbmg5imsMeFaOCzzSn5jTwfDvR
         2zJs9mRATdkTyN1FL/OOaHFco3mqt5w1OI3uGU0JMsbX88zheJ2bE+E9bTEIEfBiZigK
         o7F0nPu/osIItnbnT3CyU/3ueLOFFCRhAWfga9Y2NmkoJynxK20/YJBivJQbEa1zJa33
         7tuU2/XvlY/1ocH3i7rVpqHOBFelG43/gC+09rrHp1Vtgt2Z98X1sOuNstfaf5TLUmm/
         JdwQ==
X-Gm-Message-State: AGi0PuZA2eNJLG6Q7Tt6XznMrjWt22OmDYq4P6t8FtUH1+81edW8lpKT
        IxG7acnEzcD4oyTO5LNI782UeWmfR2cZcLdSIeUglQ==
X-Google-Smtp-Source: APiQypJz8mA1HuzgTjGk9FEd8v3Q8Dc+SfvfQTO03PV4DBCDSRRorW8Kz5Zbda7dc18IvxS6cjlGP5xFaHCFenBSFL4=
X-Received: by 2002:a2e:8087:: with SMTP id i7mr9226190ljg.99.1588590568751;
 Mon, 04 May 2020 04:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588421219.git.asml.silence@gmail.com> <56e9c3c84e5dbf0be8272b520a7f26b039724175.1588421219.git.asml.silence@gmail.com>
In-Reply-To: <56e9c3c84e5dbf0be8272b520a7f26b039724175.1588421219.git.asml.silence@gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 4 May 2020 13:09:02 +0200
Message-ID: <CAG48ez0h6950sPrwfirF2rJ7S0GZhHcBM=+Pm+T2ky=-iFyOKg@mail.gmail.com>
Subject: Re: [PATCH 1/2] splice: export do_tee()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Clay Harris <bugs@claycon.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, May 2, 2020 at 2:10 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> export do_tee() for use in io_uring
[...]
> diff --git a/fs/splice.c b/fs/splice.c
[...]
>   * The 'flags' used are the SPLICE_F_* variants, currently the only
>   * applicable one is SPLICE_F_NONBLOCK.
>   */
> -static long do_tee(struct file *in, struct file *out, size_t len,
> -                  unsigned int flags)
> +long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
>  {
>         struct pipe_inode_info *ipipe = get_pipe_info(in);
>         struct pipe_inode_info *opipe = get_pipe_info(out);

AFAICS do_tee() in its current form is not something you should be
making available to anything else, because the file mode checks are
performed in sys_tee() instead of in do_tee(). (And I don't see any
check for file modes in your uring patch, but maybe I missed it?) If
you want to make do_tee() available elsewhere, please refactor the
file mode checks over into do_tee().

The same thing seems to be true for the splice support, which luckily
hasn't landed in a kernel release yet... while do_splice() does a
random assortment of checks, the checks that actually consistently
enforce the rules happen in sys_splice(). From a quick look,
do_splice() doesn't seem to check:

 - when splicing from a pipe to a non-pipe: whether read access to the
input pipe exists
 - when splicing from a non-pipe to a pipe: whether write access to
the output pipe exists

... which AFAICS means that io_uring probably lets you get full R/W
access to any pipe to which you're supposed to have either read or
write access. (Although admittedly it is rare in practice that you get
one end of a pipe and can't access the other one.)

When you expose previously internal helpers to io_uring, please have a
look at their callers and see whether they perform any checks that
look relevant.
