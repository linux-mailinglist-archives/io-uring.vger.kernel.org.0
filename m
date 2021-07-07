Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40B93BF03F
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 21:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhGGT33 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 15:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGGT32 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 15:29:28 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AD6C061574
        for <io-uring@vger.kernel.org>; Wed,  7 Jul 2021 12:26:46 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id v14so6986690lfb.4
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 12:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gurR/owSQDFNH0OSkKWy8rQ2chdbL863tihhAYffiok=;
        b=O4/ZeTQT6f+jFfZaJgO+nGN0TZllql6sOHLJC1MBLS2yfZlJJcV/LJ42OCqfaRFj+7
         xHL/olvJE3nX1wrc1P0N+TbWFBWePWgpKUGg4WF51rybJYdE0TI6byFY3xd+e93K9VNS
         CWTXY/c3bxrDm3ItM0cXM5enPAWo3dakT/0VA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gurR/owSQDFNH0OSkKWy8rQ2chdbL863tihhAYffiok=;
        b=lvRuQod0qAlGnwzBZPci0PDZKI56vuFx8HdFGz4je8/DwmjdMy8T7HT2RRGkEB9OQ9
         ckGoFU5ZwrsUtnr19/Yjj2Lb6JJjF937dJRF4n26djYwMvH9PpKpVq+U6YeuUlUqsr4q
         HFyWe5xfEABp5cBliZwWVIKa/xJeSboUS08D2fxBjnIO+0A32/yOMbHYPnAu/CaVGN50
         +gc8YmSy9g5oX4LJiUtWjuQeedJC5hwzZUZJg+lvhLxLWkvG2yKF47kiku5+bvplRFBr
         p6QYLX77cB7FDAFsGFSnixmN3Hr2itFH2F+dtJQobhcl/kXqIX0bZZT7LAgQfRVk3tmz
         Epeg==
X-Gm-Message-State: AOAM533cWCAgApVKBAlNu7dmvAEPDX7l2NDDQ38tUmydQWZAw1EgeZFp
        p1jLMctTsosu7RubpEu1LhNV4ypW/5CNMgbA4Z4=
X-Google-Smtp-Source: ABdhPJzmYXvd6Y03YiaLFJ+yucacKlAzyrz/PG5jvXBL/rcDCk1vJmOliwIaFNjI3i4BBMP2Ezr5mg==
X-Received: by 2002:a2e:b5c9:: with SMTP id g9mr7955118ljn.16.1625686004561;
        Wed, 07 Jul 2021 12:26:44 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id e16sm1774427lfq.295.2021.07.07.12.26.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 12:26:43 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id q18so6967834lfc.7
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 12:26:43 -0700 (PDT)
X-Received: by 2002:a2e:9c58:: with SMTP id t24mr19950330ljj.411.1625686003546;
 Wed, 07 Jul 2021 12:26:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210707122747.3292388-1-dkadashev@gmail.com>
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 7 Jul 2021 12:26:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiTyxUt61NxeMXb2Zn2stDBC7eG82RKj+3jXUORdYQtpg@mail.gmail.com>
Message-ID: <CAHk-=wiTyxUt61NxeMXb2Zn2stDBC7eG82RKj+3jXUORdYQtpg@mail.gmail.com>
Subject: Re: [PATCH v8 00/11] io_uring: add mkdir and [sym]linkat support
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 7, 2021 at 5:28 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> This started out as an attempt to add mkdirat support to io_uring which
> is heavily based on renameat() / unlinkat() support.

Ok, sorry for having made you go through all the different versions,
but I like the new series and think it's a marked improvement.

I did send out a few comments to the individual patches that I think
it can all now be made to be even more legible by avoiding some of the
goto spaghetti, but I think that would be a series on top.

(And I'd like to note again that I based all that on just reading the
patches, so there may be something there that makes it not work well).

One final request: can you keep the fs/namei.c patches as one entirely
separate series, and then do the io_uring parts at the end, rather
than intermixing them?

But at least I am generally happy with this version.

Al - please holler now if you see any issues.

               Linus
