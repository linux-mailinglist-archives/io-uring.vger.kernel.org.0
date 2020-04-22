Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61351B3979
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 09:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgDVH4K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 03:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgDVH4J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 03:56:09 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B94C03C1A6
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2020 00:56:09 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id f12so778803edn.12
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2020 00:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z1biaZy6y7PqsHY/+KktbP6zQiSCk/Tgyi9hv1rSztM=;
        b=bq86XvJQnxv50SBPGcKLs3Fr8gh99Hv1Y4lzJCnHBgVuYJVbw6RrjrVKfGtFku6EZG
         kO4dXzupMYLoia0Lmt+RHfv1Xuu9JA4Y2Vmd3a8UrJgbKKxBUsTKJGojbSu5aJgfhEmo
         5EM4zr0i3Guzu9oLNTActfb698GxdY2nsEaBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z1biaZy6y7PqsHY/+KktbP6zQiSCk/Tgyi9hv1rSztM=;
        b=CxzCWE8s+JMNbaIhfBE+QjWgz09OMJfl9ApYvgT2+LBy074PCPDAp7DMmGsiG+r3mt
         oahhhZwtvaw977WJJQgpsFSGwLBwq1VRLQtl3vxbmw9kz4polL6Fl2CI3nMNE9I1GXpM
         FYUUmoeVERMISYL3Rw9+LMaWfFw6SjP01xyt5wexIwG4wmu8H037c1Yi8HqvBVbt82CQ
         MPqvcg3lup2eefNkPk3vjNSmzswDyzRYnVlMC1HNC6gf7jrnoDs++WonQ2R4tykAfJt0
         niuC5S9x2ysb7vHZyMUggWEWTREgwpGa0ufkd/iU93MDBP6sPHKOI9UnaiYsVSmfw3Mo
         SNnQ==
X-Gm-Message-State: AGi0PuYyGotxf6ixPieJtvSRDeKB8/4VLqXI/1baIh55UuXnCHsuAZRx
        XQ7GWzGPtsrp3WJ1pU/93+Fivl/hcm/uxzZSKq08qw==
X-Google-Smtp-Source: APiQypK9NkZBpfIRxtVZgJkwWgqgZC5WwR3a2fRu7Zp4jUgGSYA2Xwz4zVEf0igsy8uL0etsgNy6Z5nE2u7gSECiDNk=
X-Received: by 2002:a05:6402:22ed:: with SMTP id dn13mr21651703edb.212.1587542168000;
 Wed, 22 Apr 2020 00:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587531463.git.josh@joshtriplett.org> <9873b8bd7d14ff8cd2a5782b434b39f076679eeb.1587531463.git.josh@joshtriplett.org>
 <CAKgNAkjo3AeA78XqK-RRGqJHNy1H8SbcjQQQs7+jDwuFgq4YSg@mail.gmail.com>
In-Reply-To: <CAKgNAkjo3AeA78XqK-RRGqJHNy1H8SbcjQQQs7+jDwuFgq4YSg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 22 Apr 2020 09:55:56 +0200
Message-ID: <CAJfpegt=xe-8AayW2i3AYrk3q-=Pp_A+Hctsk+=sXoMed5hFQA@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
To:     Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     Josh Triplett <josh@joshtriplett.org>, io-uring@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 22, 2020 at 8:06 AM Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
>
> [CC += linux-api]
>
> On Wed, 22 Apr 2020 at 07:20, Josh Triplett <josh@joshtriplett.org> wrote:
> >
> > Inspired by the X protocol's handling of XIDs, allow userspace to select
> > the file descriptor opened by openat2, so that it can use the resulting
> > file descriptor in subsequent system calls without waiting for the
> > response to openat2.
> >
> > In io_uring, this allows sequences like openat2/read/close without
> > waiting for the openat2 to complete. Multiple such sequences can
> > overlap, as long as each uses a distinct file descriptor.

If this is primarily an io_uring feature, then why burden the normal
openat2 API with this?

Add this flag to the io_uring API, by all means.

This would also allow Implementing a private fd table for io_uring.
I.e. add a flag interpreted by file ops (IORING_PRIVATE_FD), including
openat2 and freely use the private fd space without having to worry
about interactions with other parts of the system.

Thanks,
Miklos
