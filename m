Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF4D3B8980
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 22:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbhF3UIf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 16:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhF3UId (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 16:08:33 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8FFC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:06:03 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id f30so7405169lfj.1
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kSK7qsw5oN8dRNyBJJXCk0tNGvyuE1uUNx2c5x4YTVA=;
        b=KmSs0xsuAtgiF1lz0KWKAGQBfVe7fLAkUFe/aG0o9dlqwTs9dA+v8OI9sWj1jL//M7
         HV0OvhQBf/9wScJkRtWOEXQYkU36kMe0XRVv/g99hNzG+/wBEJu8PI0OGcuVOR/e8Up5
         z2Vi/frgXlBXO/e4sLvrCEjsL3x9ZsZntVvFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kSK7qsw5oN8dRNyBJJXCk0tNGvyuE1uUNx2c5x4YTVA=;
        b=nfYivW89NuZLSZuOJlh2li/7aYWnGZ4lytPwLDzgH8iB8KxBG2fBHNV0uwS0LmHiQW
         gJvG5pmnbNFkBh4vQS0KNW9hThsiKu6/QSv7KHts7NfxJ28U6XYh66SvOCT29OF73gZu
         yuEt+afRJQIfZsa6mvVTQUaOHQB9sjlOIwSevTuSBK7aCVyZ9VroaHc7gWq0+W99lFUC
         /Kp7sgvLeOnFPeHU/FNKTbn57aAmQ2xBwfW+iSDXSj/0ydf60uQCWrnRIETZlD1vpwyG
         oFqYphKG8AGf/OqX7x9i6VLck/lZvmYQFvKk1h4RTZjOuhW7ZmnTlrLSDPyPyIwt8djj
         B6dw==
X-Gm-Message-State: AOAM532yverAjKl0gW7ML5KQwOzIfPFFHTTdfPFjgIcK97LD/jFRHwPH
        spDvpNrU4tn2/1sZNIawxOdkMa0zkqy/sW30ugY=
X-Google-Smtp-Source: ABdhPJyF1jfPyMipPZnJFJoHYCRQbldrhSpD+wZ+VAdITE25uzc9/gEXm5LnDS/F+Xqe26GUudyR4w==
X-Received: by 2002:ac2:5cda:: with SMTP id f26mr27799768lfq.190.1625083561595;
        Wed, 30 Jun 2021 13:06:01 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id x207sm2009070lff.53.2021.06.30.13.06.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 13:06:01 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id k21so5005908ljh.2
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:06:00 -0700 (PDT)
X-Received: by 2002:a2e:b553:: with SMTP id a19mr9054330ljn.507.1625083560736;
 Wed, 30 Jun 2021 13:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
In-Reply-To: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Jun 2021 13:05:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
Message-ID: <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
To:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Dmitry Kadashev <dkadashev@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 29, 2021 at 1:43 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> - Support for mkdirat, symlinkat, and linkat for io_uring (Dmitry)

I pulled this, and then I unpulled it again.

I hate how makes the rules for when "putname()" is called completely
arbitrary and very confusing. It ends up with multiple cases of
something like

        error = -ENOENT;
        goto out_putnames;

that didn't exist before.

And worse still ends up being that unbelievably ugly hack with

        // On error `new` is freed by __filename_create, prevent extra freeing
        // below
        new = ERR_PTR(error);
        goto out_putpath;

that ends up intentionally undoing one of the putnames because the
name has already been used.

And none of the commits have acks by Al. I realize that he can
sometimes be a bit unresponsive, but this is just *UGLY*. And we've
had too many io_uring issues for me to just say "I'm sure it's fine".

I can see a few ways to at least de-uglify things:

 - Maybe we can make putname() just do nothing for IS_ERR_OR_NULL() names.

   We have that kind of rules for a number of path walking things,
where passing in an error pointer is fine. Things like
link_path_walk() or filename_lookup() act that way very much by
design, exactly to make it easy to handle error conditions.

 - callers of __filename_create() and similar thar eat the name (and
return a dentry or whatever) could then set the name to NULL, not as
part of the error handling, but unconditionally as a "it's been used".

So I think this is fixable.

But I'm *VERY* tired of io_uring being so buggy and doing "exciting"
things, and when it then starts affecting very core functionality and
I don't even see ack's from the one person who understands all of
that, I put my foot down.

No more flaky io_uring pulls. Give me the unambiguously good stuff,
not this kind of unacked ugly stuff.

               Linus
