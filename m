Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29761305947
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 12:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbhA0LKV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 06:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbhA0LHh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 06:07:37 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACD8C061756;
        Wed, 27 Jan 2021 03:06:57 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e1so1351341ilu.0;
        Wed, 27 Jan 2021 03:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y76FNPqB9qWS75pfeBmMezT/zILd26EsKHMVCZMEbb4=;
        b=JQCZfEN9pcGV+drUZVNwHoHfm1XathLlLOpF2qZM/OtnwwklrRgs0enCU0qUidLx4Z
         SPM6bm93Rsx0lNeFav/S6Va8t8zKVVsE21b0iCgpWkfPv0Kr4Xu5ajpZc16D+U2YIpaz
         zMQdXLiPmawtXdpaH47GmPWIqfvUUyAubxIe/+gRFmK07JgDbYBNyTVYgJH3IhmfOIPO
         KqeAZYWW1baAqdEW9pIxa2ShUIGI/K4Lx+xHzj07sFA9bLeXGLWG4SwUKr9ZX10ZtvH+
         X6ayHLr6nV86ke+HRC3bXNgR2E7+3Ecg3K3eBnjlbV07xf6ffbJnMGCli3t1vBIaRcLg
         P8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y76FNPqB9qWS75pfeBmMezT/zILd26EsKHMVCZMEbb4=;
        b=c034nVLu6Y7qFziJ6qZeif6CKbOCaCcEuMYD17X3iTLr7Sxua+XxC9qpGgPASAI5g/
         Z4y7DKfBO2kfC+ZnuKT4+G8/E3eRLhxF5ucSEVaNb33O298uQv5F1VL7kDo0IZynK8dm
         stuxIXhgHC94rZvsfthPoZIclh6ifIg7ydHIIp3rmWKRiClYueTcpfwc4Ht96019EfIq
         u/ApkfOQtY7fUNefJOSDkkugJe4JM5FaVB6s1proe0iwbo2nUlV9D6lsoI0qCXzNK1KK
         +Ba3FwxqGzk8Nmjs9PwONXHDfvgvda9Pau4QU2SRo8UV/QWThNqeFsQur2slwgNkFSG/
         mLPQ==
X-Gm-Message-State: AOAM530nZQaeGOR0mmuAycUp+HTElK3eUPOBxznJUhas9JaayMJgVELw
        o/PYeyJYOsTPJP4KPPxJrD2/vTcxvxgqe1bZAfvBXAKKFhw=
X-Google-Smtp-Source: ABdhPJwV1a8E/rXC3MwyJdqeGhovuK4D9G5C8ZCtkz5mpiaoNHhPcmpoOiEsefYRK1iQUbRK0wZ01fRKJ/1qEvG+1qk=
X-Received: by 2002:a92:c6cb:: with SMTP id v11mr1371562ilm.238.1611745616429;
 Wed, 27 Jan 2021 03:06:56 -0800 (PST)
MIME-Version: 1.0
References: <20201116044529.1028783-1-dkadashev@gmail.com> <3bb5781b-8e48-e4db-a832-333c01dba8ab@kernel.dk>
In-Reply-To: <3bb5781b-8e48-e4db-a832-333c01dba8ab@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 27 Jan 2021 18:06:44 +0700
Message-ID: <CAOKbgA6CAe22WknmGC7-bYDkwHRLBVqm9vUq6tz7Qp9ZECztpQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] io_uring: add mkdirat support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 27, 2021 at 5:35 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/15/20 9:45 PM, Dmitry Kadashev wrote:
> > This adds mkdirat support to io_uring and is heavily based on recently
> > added renameat() / unlinkat() support.
> >
> > The first patch is preparation with no functional changes, makes
> > do_mkdirat accept struct filename pointer rather than the user string.
> >
> > The second one leverages that to implement mkdirat in io_uring.
> >
> > Based on for-5.11/io_uring.
>
> I want to tentatively queue this up. Do you have the liburing support
> and test case(s) for it as well that you can send?

I do, I've sent it in the past, here it is:
https://lore.kernel.org/io-uring/20201116051005.1100302-1-dkadashev@gmail.com/

I need to (figure out the way to) fix the kernel / namei side after Al's
comments though.

-- 
Dmitry Kadashev
