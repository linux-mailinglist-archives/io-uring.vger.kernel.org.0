Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4C240B721
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 20:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhINSqj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 14:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhINSqj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 14:46:39 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65406C061762
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 11:45:21 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id y6so525836lje.2
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 11:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DwfWF1/sa0I9dbhN43EgUUYnc2H+27BjX60Lj9OqoKU=;
        b=hKg/rvnaQx1/R4MfQhSq5ZhF5SC+1wsxY1GdCuLkeAIRTBF+EfsEoEN5GgxGoLpoSh
         JdKu0h5xwl2xVh8gvYj+ok5RfiniFB5k92ryBjTeDpUoZIHtHOcuUe94JkSE6CwxqJyk
         bpGT4E1iZRJ9G2dS0GvBnOuU4tC70y7mHtppk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DwfWF1/sa0I9dbhN43EgUUYnc2H+27BjX60Lj9OqoKU=;
        b=LqAlJ/fCaKWzZU8RYvCfgDkW+ELgfOBjEDtDc3ysgWRn+hEDSULaGIINv+kDd3eYCe
         VQd7eKxVWifbfIvroXndHtQ81sN3zE1feapsk0W9yNHgAECPAGG9wIUm1S1UBhtP0XOj
         v1/X4kJZEtX0oVlhZr/CsKHKYE+sdMPuIuSF0rmJjmXL+2ozFNOMfLO+c4bpjcrbSaKa
         B0JfRoUimaCG2EembL7nTAbfOw8dSd4aWFHjdpMJd5KQA6/kWeH5EB/o9gNsIXRxUllP
         Sk5X7xXihCPDCipBISGn/CbdwO0U0ULlKzxLXXmTgDfvkvzFEj2rdadrhafDneXpVUNB
         8y7g==
X-Gm-Message-State: AOAM531xLEDuLaW+1YHEZzK1HgurYOpwDX9iTfTILyKj0FZE1IF7oCkI
        HNfn0yxj1NDRUNamJB18mXJ581vnFXEzVFiQXPo=
X-Google-Smtp-Source: ABdhPJwU2Z29T7RUKZy/+asKv5+2IIEnO720jwWEu2ZYIf2/eMyM8yF2SPnZVoL7GN5+pVxuXp3VlQ==
X-Received: by 2002:a2e:990d:: with SMTP id v13mr16849864lji.127.1631645118940;
        Tue, 14 Sep 2021 11:45:18 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id b31sm1188032lfv.276.2021.09.14.11.45.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:45:18 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id f2so535352ljn.1
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 11:45:18 -0700 (PDT)
X-Received: by 2002:a2e:1542:: with SMTP id 2mr17081124ljv.249.1631645118003;
 Tue, 14 Sep 2021 11:45:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210914141750.261568-1-axboe@kernel.dk> <20210914141750.261568-3-axboe@kernel.dk>
In-Reply-To: <20210914141750.261568-3-axboe@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 11:45:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh6mGm0b7AnKNRzDO07nrdpCrvHtUQ=afTH6pZ2JiBpeQ@mail.gmail.com>
Message-ID: <CAHk-=wh6mGm0b7AnKNRzDO07nrdpCrvHtUQ=afTH6pZ2JiBpeQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] io_uring: use iov_iter state save/restore helpers
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 14, 2021 at 7:18 AM Jens Axboe <axboe@kernel.dk> wrote:
>
>
> +       iov_iter_restore(iter, state);
> +
...
>                 rw->bytes_done += ret;
> +               iov_iter_advance(iter, ret);
> +               if (!iov_iter_count(iter))
> +                       break;
> +               iov_iter_save_state(iter, state);

Ok, so now you keep iovb_iter and the state always in sync by just
always resetting the iter back and then walking it forward explicitly
- and re-saving the state.

That seems safe, if potentially unnecessarily expensive.

I guess re-walking lots of iovec entries is actually very unlikely in
practice, so maybe this "stupid brute-force" model is the right one.

I do find the odd "use __state vs rw->state" to be very confusing,
though. Particularly in io_read(), where you do this:

+       iov_iter_restore(iter, state);
+
        ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
        if (ret2)
                return ret2;

        iovec = NULL;
        rw = req->async_data;
-       /* now use our persistent iterator, if we aren't already */
-       iter = &rw->iter;
+       /* now use our persistent iterator and state, if we aren't already */
+       if (iter != &rw->iter) {
+               iter = &rw->iter;
+               state = &rw->iter_state;
+       }

        do {
-               io_size -= ret;
                rw->bytes_done += ret;
+               iov_iter_advance(iter, ret);
+               if (!iov_iter_count(iter))
+                       break;
+               iov_iter_save_state(iter, state);


Note how it first does that iov_iter_restore() on iter/state, buit
then it *replaces&* the iter/state pointers, and then it does
iov_iter_advance() on the replacement ones.

I don't see how that could be right. You're doing iov_iter_advance()
on something else than the one you restored to the original values.

And if it is right, it's sure confusing as hell.

           Linus
