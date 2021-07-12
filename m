Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64823C6303
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 20:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhGLS5l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 14:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbhGLS5j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 14:57:39 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0245EC0613DD
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 11:54:50 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id u14so15123481ljh.0
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 11:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ozw+6MWyzFzZLgq1G+qukdxG70r5Hi4Eg2TGfVckcOc=;
        b=O3xUh+Fq/+dVJ0DQCH2SupydS5UBVQhOmDnixnLe0/gggMpo0XGiT6bplFs6vOFM/7
         A1+pijbV1tYD1tIhfD4uYR9PgeLF0MSiwqdCEvnTmL+CoY8w6rMf/WgFLYsKj7ixVIOa
         OPWOLpAzi8d8GHLoSU4eG2x50o1oarHyHLG3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ozw+6MWyzFzZLgq1G+qukdxG70r5Hi4Eg2TGfVckcOc=;
        b=Y6ZaYjvEWMdS8qU4VYj6sKi/gBxSxSwvGvoj1CeYAclMOd/8et9Y8jLuZQl5Ott239
         TGUmlOm6wtKISiWD2lCyIYHyO9cpyHQhzgfaL7IZCTNoR1mTN3G9B3VGqWTOKI15339F
         ct8g44O8wRiktp0XRBfR3doVSCvQ22mrz3+3DSguN7oo3AofCAtT4rzYF2Tb5/glMguu
         jhQM6XU1dMI6yfOpEjk8As3UYjt6zq6jXeCMyAUwsTc9viSWZlAaqLTuY6rFR4GF3Kw3
         fh30rQ4z2BCip7/kErC0xxojSuApwv6NoYa4GIf/Et8bPek/FjWYbYfJKJO84QSH2s/j
         dliA==
X-Gm-Message-State: AOAM531z1utCnyFveb53HXgguSX4BLz7s5QORRVvRE3c7Ce44UScejj+
        HzCD0iDwiNFrrZzcIn3V1L5FSmZZZqBHUSVi
X-Google-Smtp-Source: ABdhPJxa/A17JhQdz9F1Z6gOa2Ad/7YjvA0MMxBvVjp/ZXoXb+n/DZsaHF5Vt1OWPczPhwbBegMcgw==
X-Received: by 2002:a2e:9e52:: with SMTP id g18mr507754ljk.167.1626116087969;
        Mon, 12 Jul 2021 11:54:47 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id f18sm1272780lfc.251.2021.07.12.11.54.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 11:54:47 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id a18so45251348lfs.10
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 11:54:47 -0700 (PDT)
X-Received: by 2002:a05:6512:404:: with SMTP id u4mr175462lfk.40.1626116086978;
 Mon, 12 Jul 2021 11:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210712123649.1102392-1-dkadashev@gmail.com> <20210712123649.1102392-6-dkadashev@gmail.com>
In-Reply-To: <20210712123649.1102392-6-dkadashev@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Jul 2021 11:54:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=whH4msnFkj=iYZ9NDmZEAiZKM+vii803M8gnEwEsF1-Yg@mail.gmail.com>
Message-ID: <CAHk-=whH4msnFkj=iYZ9NDmZEAiZKM+vii803M8gnEwEsF1-Yg@mail.gmail.com>
Subject: Re: [PATCH 5/7] namei: clean up do_symlinkat retry logic
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 12, 2021 at 5:37 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> +
> +int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
> +{
> +       int error;
> +
> +       if (IS_ERR(from)) {
> +               error = PTR_ERR(from);
> +               goto out;
>         }
> -out_putnames:
> +
> +       error = symlinkat_helper(from, newdfd, to, 0);
> +       if (retry_estale(error, 0))
> +               error = symlinkat_helper(from, newdfd, to, LOOKUP_REVAL);
> +
> +out:
>         putname(to);
>         putname(from);
>         return error;

So here you moved that part that was outside the retry loop into the
caller. Except it's very ugly and keeps the goto mess.

So I'd suggest either keep it as a nested if - avoiding the goto - or
like in the previous patch, do that "we can do this test twice" with a
big commit message note about why it's ok.

Because it _is_ ok to repeat the test inside the retry_estale, and
'from' won't have changed (and won't have been -ESTALE in the first
place).

Looking at the pattern of this and the previous one, I think just
repeating the test is what generates the cleanest end result.

               Linus
