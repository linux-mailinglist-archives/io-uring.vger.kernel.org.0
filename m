Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF5E123B28
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 00:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfLQX4D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 18:56:03 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44770 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfLQX4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 18:56:03 -0500
Received: by mail-oi1-f196.google.com with SMTP id d62so105416oia.11
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 15:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uSrcrrmPD2HZZfVbkp1SOmo6OrJr9Uy/MkJXxU1BuKQ=;
        b=BciJzHLBwtLM77jVMtBYhAevWZzXWU7epivW4diMgfngZD5Vc7l9XqN+WuFJg9o3Tn
         jh8qjHPMQVyV8LLDIESzfYhnKv/xXfJl0fNSPxzsLuAfBu8YBtDDvZo2R09K411Nxpy2
         ZqMVpo5mhjucPyBtq7D8FkpdlpoO9mxewotIUcBolsdzdMWhuIu6bJY7IqLiJTyHB53g
         MJghTLXf6ylqgKj/izG3tKXTyfrBgZrXlp4tyoI/iv7J6m8eM+Y2wwBb1cAmHehemsMR
         TvNaWEzZc3U/7owuwb7QaP6GnvWkesYsF1LrVJIGX3d8lhSVV42ekjkn14xxPOp1QANR
         lN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uSrcrrmPD2HZZfVbkp1SOmo6OrJr9Uy/MkJXxU1BuKQ=;
        b=EX2WdoittSJKvjyOT6Dhzg3/VvLKA/1dbyHtpgETZR7zlbcfR2r+evAj6p+E5xamYC
         5AuveketAjlak+qmDHNum3r9FQMyBzQweel/0INAPQSA0hFFosgFIwvhCwOVkZk2ZbfH
         zIA2YNH9Gfwm0XVIurAn072wl5FG3jEPQUXAgrQLdmbfFxwKKuS5y7laTd9Y2vAXfpnj
         OMl4NgwRFR7hpwFjSNdR0yL3MxVbphJtZsoKqt5QHak3Rg96aOdJIscUE0je4Tdz+IDn
         NJUnXRdiSihTpu3l4W5PXcHtRBdpiWCH9Om218BIGkLD1Hrv0fG/Zwi6PK8w/HpZ51AJ
         rsRA==
X-Gm-Message-State: APjAAAVBtnv7e/3pXONUZqAekCuMEPbFo+ZS8XO1jt3Mm6YDfH8MCrI4
        GhFx3A0XjompE7QJiR2sS2lfQSyQnHd51slAPv2LEw==
X-Google-Smtp-Source: APXvYqwrOCbCg/ESp2zlljby9Ba2gr6DV3ew6j4AQUNR95y4mxT8z/4/uiPGM9Z+m/1zGaPMx0yOd28PYrfcxAJcqRg=
X-Received: by 2002:aca:bb08:: with SMTP id l8mr3134569oif.47.1576626962574;
 Tue, 17 Dec 2019 15:56:02 -0800 (PST)
MIME-Version: 1.0
References: <20191217225445.10739-1-axboe@kernel.dk> <20191217225445.10739-4-axboe@kernel.dk>
In-Reply-To: <20191217225445.10739-4-axboe@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 18 Dec 2019 00:55:36 +0100
Message-ID: <CAG48ez3kndOnUmEKRiL0SJ8=Tt_+NqZAg7ESwB9Us2xX43rnHg@mail.gmail.com>
Subject: Re: [PATCH 3/7] io_uring: don't wait when under-submitting
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 17, 2019 at 11:54 PM Jens Axboe <axboe@kernel.dk> wrote:
> There is no reliable way to submit and wait in a single syscall, as
> io_submit_sqes() may under-consume sqes (in case of an early error).
> Then it will wait for not-yet-submitted requests, deadlocking the user
> in most cases.
>
> In such cases adjust min_complete, so it won't wait for more than
> what have been submitted in the current io_uring_enter() call. It
> may be less than total in-flight, but that up to a user to handle.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
[...]
>         if (flags & IORING_ENTER_GETEVENTS) {
>                 unsigned nr_events = 0;
>
>                 min_complete = min(min_complete, ctx->cq_entries);
> +               if (submitted != to_submit)
> +                       min_complete = min(min_complete, (u32)submitted);

Hm. Let's say someone submits two requests, first an ACCEPT request
that might stall indefinitely and then a WRITE to a file on disk that
is expected to complete quickly; and the caller uses min_complete=1
because they want to wait for the WRITE op. But now the submission of
the WRITE fails, io_uring_enter() computes min_complete=min(1, 1)=1,
and it blocks on the ACCEPT op. That would be bad, right?

If the usecase I described is valid, I think it might make more sense
to do something like this:

u32 missing_submissions = to_submit - submitted;
min_complete = min(min_complete, ctx->cq_entries);
if ((flags & IORING_ENTER_GETEVENTS) && missing_submissions < min_complete) {
  min_complete -= missing_submissions;
  [...]
}

In other words: If we do a partially successful submission, only wait
as long as we know that userspace definitely wants us to wait for one
of the pending requests; and once we can't tell whether userspace
intended to wait longer, return to userspace and let the user decide.

Or it might make sense to just ignore IORING_ENTER_GETEVENTS
completely in the partial submission case, in case userspace wants to
immediately react to the failed request by writing out an error
message to a socket or whatever. This case probably isn't
performance-critical, right? And it would simplify things a bit.
