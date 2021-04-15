Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDCE360755
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 12:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhDOKlq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 06:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhDOKlm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 06:41:42 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5165EC061574;
        Thu, 15 Apr 2021 03:41:19 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id y2so23514135ybq.13;
        Thu, 15 Apr 2021 03:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mIWeTeGpopC86lILoKeSqvrfX/KXvaTXsf3RCKzoZxY=;
        b=Ub+5ERlZN9gClgd44QCMHBwONiTwNkGi2pg34w+dF98I5IHtEyWNmeRj17G/PeHlpE
         bZOXlEJbgBxQP7DIqLnDpiP2TI45m+78jb9iMClIY0aVnYpObJRlcEKprjGrxipSNtpf
         /xWADwE09jDGbRBvRw2f8AlW1GDCIp9prnDgEAEQJU6J2xJRT3zlzj6O5wcc5lS3pxvX
         x2ThHjha6BF7xsHyBj0hbtG1dPwMt2RN/8iVjTuWrjDpxR57yhcGpff1DwY5SQwTuHX3
         9su1M7/RMp2TTVcBlbksExofPIf4hA4lRR7icL5Ke6YQpDCUQ+24rQa1VNbiCtOh2k18
         VHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mIWeTeGpopC86lILoKeSqvrfX/KXvaTXsf3RCKzoZxY=;
        b=PI/baJFy2XgqcHOMuj5LSHsZrFowa2RDFdOwEG5B4AyvDaziNX+nou3O01tcoaap7z
         m9ML1Mf0/WpKJCoopG/zKbOFKhSAAYJkIOv8XD4JOT5KQjVDtvSd4Mqxlrm3UqEcCMAX
         XaUw1aV/A48/UqsE9Ayil3oJIsJeuW9aiWEV+fxK3ZeBhTLbUkGdB2+mIJpVKt4Uwkm1
         250+4KolA1ALICS7QWDQ7WNsl/L3x34oeJ0PwHpkMJ7jnmiF9n7zLuK0Nxb4Y6kytEpR
         qrKXzo5KlJDpdg7SO9CBsOsl2C5Q9zHO4JodVEQADmiTtaJpBqjnRaEXGucMHrYWL4Qy
         onBQ==
X-Gm-Message-State: AOAM5323/QIjr0u/ERqhcQDfb37AvszWCreh/DZqUIplOL+zwkIikNw0
        lB/dSO5Tazw3VyCOQE/KVz8mOSmEHEwW/Gl2PEU=
X-Google-Smtp-Source: ABdhPJzYRu9lr0PH2qD7KNGp+015oRnjXvF3q8klHyJhHJ6EQMOGBdkTnEanJuFwk0JfQJ1TLFQAr7o2fKp1H8mFILM=
X-Received: by 2002:a25:1689:: with SMTP id 131mr3429887ybw.375.1618483278652;
 Thu, 15 Apr 2021 03:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210330055957.3684579-1-dkadashev@gmail.com> <20210330055957.3684579-2-dkadashev@gmail.com>
 <20210330071700.kpjoyp5zlni7uejm@wittgenstein> <CAOKbgA6spFzCJO+L_uwm9nhG+5LEo_XjVt7R7D8K=B5BcWSDbA@mail.gmail.com>
 <CAOKbgA6Qrs5DoHsHgBvrSGbyzHcaiGVpP+UBS5f25CtdBx3SdA@mail.gmail.com>
 <20210415100815.edrn4a7cy26wkowe@wittgenstein> <20210415100928.3ukgiaui4rhspiq6@wittgenstein>
In-Reply-To: <20210415100928.3ukgiaui4rhspiq6@wittgenstein>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 15 Apr 2021 17:41:07 +0700
Message-ID: <CAOKbgA6Tn9uLJCAWOzWfysQDmFWcPBCOT6x47D-q-+_tu9z2Hg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 15, 2021 at 5:09 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Thu, Apr 15, 2021 at 12:08:20PM +0200, Christian Brauner wrote:
> > Would something like this help?

Thanks for the reply, Christian!

But it's not the AT_EMPTY_PATH / LOOKUP_EMPTY part that is tricky, it's
the fact that do_linkat() allows AT_EMPTY_PATH only if the process has
CAP_DAC_READ_SEARCH capability. But AT_EMPTY_PATH is processed during
getname(), so if do_linkat() accepts struct filename* then there is no
bullet-proof way to force the capability.

We could do something like this:

do_linkat(oldfd, getname_uflags(oldname, flags), newfd,
          getname(newname), flags);

I.e. call getname_uflags() without checking the capability and rely on
the fact that do_linkat() will do the checking. But this is fragile if
somehow someone passes different flags to getname_uflags and do_linkat.
And there is no way (that I know of) for do_linkat to actually check
that AT_EMPTY_PATH was not used if it gets struct filename.

Or am I creating extra problems and the thing above is OK?


--
Dmitry Kadashev
