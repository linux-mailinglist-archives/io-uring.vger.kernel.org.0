Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC553AC3CC
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 08:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhFRG07 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 02:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFRG06 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 02:26:58 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48B4C061574;
        Thu, 17 Jun 2021 23:24:48 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id g142so8363940qke.4;
        Thu, 17 Jun 2021 23:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZDqba+HMo2hjH8VMNmzNS2XYGWojB7LznAwCzaKmjNA=;
        b=U/v18vCMsQ63p8R8w0WJY9noBW6IndVG/EBdHCCS8NtKGIw+3oOkGNds39312yJ+AL
         l2y345byLylhgy3L9iTmHmqWvQnl7iotcShqLVtlixsj+9TrUamaEl6yuXZ49gulYwys
         KdokcyvQguVwnsn8Tr36uxk+mCC1pvSASA+HS+lz8Iw3K5Ff+wEk2EugaG0/QBge2ZD4
         EvLrUpLMgaxLkXex3JNd4gNkjdY2EIGaOPsDVmsfvfnXV/f2T9YmaVFerOhD5PsxxDvs
         c/Pww4pVzLlyosL58ny9sy9wchRw6K2IRTacUbZ7xAmnkbhruR0Rmd8s8r/EWTtQ03vn
         T9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZDqba+HMo2hjH8VMNmzNS2XYGWojB7LznAwCzaKmjNA=;
        b=dzVeUnGXOaTc2QXes1ejRuny1444XJj2nfDTVsJotoaZ/CY5hz1mGbhi6ZdQ1NKz6q
         gvhIUMBTv9lNKGRzopUROO8x757Z0WFpkgTVH613OSMj6qm8WxzD0F/IWiXR786GB2T9
         h6EtxaZJNIXkXmO35O4LEE/KAPVQBuJyX59Z/Yc15mR01ztcupNH+Io6QIOj0c63rYL8
         KLj18eG9iHJgQcZbp8NIn8aksntm8uF5ZqQfLDCdh3pmBWJUPfLikEadb6qA4cbm++Uo
         kH44905zIePa7jJsZqDuiKZziuydWx7ynolwJZCV6jdB90cSF3bsoDrAEYwRq5cHtyuP
         x1tw==
X-Gm-Message-State: AOAM530bbxMlxutit+8xbWg2AYb9xElC+98OkBFDyrEsxWHDHBzzgm8N
        nBa37vuVRF4pkHq/rPHzZEZcMZNyqp4fWHZv4gDs4K6dJF6XXQ==
X-Google-Smtp-Source: ABdhPJx95q0CiJtPFE8oKhtUprF0W2IOD/6djMLJAgeig1lTFp7t7s/w4I1tO06yGzU2KdR57UXqaXmz8UoGrt+i/LI=
X-Received: by 2002:a25:4d04:: with SMTP id a4mr10863333ybb.311.1623997487912;
 Thu, 17 Jun 2021 23:24:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com>
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Fri, 18 Jun 2021 13:24:37 +0700
Message-ID: <CAOKbgA69B=nnNOaHH239vegj5_dRd=9Y-AcQBCD3viLxcH=LiQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat support
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 3, 2021 at 12:18 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> This started out as an attempt to add mkdirat support to io_uring which
> is heavily based on renameat() / unlinkat() support.
>
> During the review process more operations were added (linkat, symlinkat,
> mknodat) mainly to keep things uniform internally (in namei.c), and
> with things changed in namei.c adding support for these operations to
> io_uring is trivial, so that was done too. See
> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/

Ping. Jens, are we waiting for the audit change to be merged before this
can go in?

-- 
Dmitry Kadashev
