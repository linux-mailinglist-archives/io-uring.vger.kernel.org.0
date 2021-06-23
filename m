Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAFD3B1348
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 07:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFWFhi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 01:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFWFhh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 01:37:37 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB69C061574;
        Tue, 22 Jun 2021 22:35:20 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c23so2165093qkc.10;
        Tue, 22 Jun 2021 22:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PP5dIDUBMjPRy89Fci0P3cI/PKvVprrPTs2qTlqJFXc=;
        b=HoqFdq00dI5ZldEZME0+lGg9OntlVW7T5Yk0XX8oHk0U/Etr/3QXtspxcooqoKBso/
         cEmAgxW50ezLXRGLmhr5+FL33HO5CYVqdIij6EYndQ33HTh2Pz7VK0q5soLR2KDcbAwJ
         lHPDKc8DnfPkZtwlHIUhNQdyC3DdQW0MjUjD2WImM6D674C+/i/NhM3DHdIHy0AwTSWf
         4XigdCLBTGGW0/g1tRXN2mhMTnFLQQQgNLYQtFhXLWzWFCvoKILnV7fVVkcbM4ZQdqeU
         KqXjGWPiFY4iZKDZSccz7xyz7dSZRYRpKMSfY1f/sqrNA4AGBNsLuPF2Q1scKanTttiv
         5h0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PP5dIDUBMjPRy89Fci0P3cI/PKvVprrPTs2qTlqJFXc=;
        b=DyVw/Twpz9MEq9ZhjBcGhZwj2fYLOnyktYTL2TOdCAW9ptIOR8Et1Il2iyx/zRpU+B
         ctNxgqrqXMhaZ14CCdc65w0tBBm8hNyVAMRzu1p1sFSOqrVuh8nE5jXK5KjXLQkYBido
         l+Iw6aYg9+y3YO1gEsCIyMNjg7GcLoj+guzMbbWZJdnCd6HdNWkS4N8XKxdgpZn15EkI
         ks//6tw79aGNXevRdLY1YpzLeNILg7u3ukz/BmTvgE2x/u/Oe48TlW+4oWuP9Xw1u7lo
         MXlSqzZK7ZvvWmyHLS2r656/24bqIbAH04DM8Vb6v2YWofePvB6zJ9t0t0kVUaYyu9xX
         jRBw==
X-Gm-Message-State: AOAM531iV/Fw860YwyvvMbIhxM+TTToaYE7/XVOykKxHVVbSqhjmuRV+
        NoeQ3KhtBqclnI4dwp9PCX1LrYJlvkbAmUH2Udw=
X-Google-Smtp-Source: ABdhPJxJaV6tN6VQlIjDfsK1w6kYg2Cspb7beUN/DhrKm7PXJ9dDj13GdccqNYe/b/l5mcVc3LIe1oS3fVRfNwgzfTE=
X-Received: by 2002:a25:5048:: with SMTP id e69mr9574929ybb.511.1624426519908;
 Tue, 22 Jun 2021 22:35:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
In-Reply-To: <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Jun 2021 12:35:09 +0700
Message-ID: <CAOKbgA71euyOxvzg3PwHxsCFqJ3-hZdC8Ms=TogGLyb-KfLkDQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat support
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 22, 2021 at 6:56 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> > This started out as an attempt to add mkdirat support to io_uring which
> > is heavily based on renameat() / unlinkat() support.
> >
> > During the review process more operations were added (linkat, symlinkat,
> > mknodat) mainly to keep things uniform internally (in namei.c), and
> > with things changed in namei.c adding support for these operations to
> > io_uring is trivial, so that was done too. See
> > https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
>
> io_uring part looks good in general, just small comments. However, I
> believe we should respin it, because there should be build problems
> in the middle.

I knew my celebration was premature! :)

-- 
Dmitry Kadashev
