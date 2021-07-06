Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B140B3BDCAD
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 20:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhGFSIR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 14:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhGFSIQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 14:08:16 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ACDC061574
        for <io-uring@vger.kernel.org>; Tue,  6 Jul 2021 11:05:36 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id v14so14270541lfb.4
        for <io-uring@vger.kernel.org>; Tue, 06 Jul 2021 11:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Em9c4ZPKERgAPy8Qvk6GosFDZCvYA+8F/8hRBjAZ/yU=;
        b=S22eWRM9cqp1ZGHh3bFaL5OIJ3DNjFhPPb/oA3C49rhtA4loRgsaNFmFLXwps/16x3
         JbjIyir5e4U/KiVEOEai0YepGthbexe30ApJeKK6SnyodxfFFpXN8PbB1Q0kAc3Qc8G8
         TsRjiHmCcBRVMgn7VZfln7LDBRApU7IKC/01o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Em9c4ZPKERgAPy8Qvk6GosFDZCvYA+8F/8hRBjAZ/yU=;
        b=cEs9rXiB9/DDEnm9vo2sSaoTwr+0b4hYDX+/SkagWeyrBmDOoZp6TbLgWNWhfdxtOt
         KfvuU9AyVCQOpNfyjyS6uNrRfXCmIV7kUeieHHb9Kb1N00/9DyksD1nDKn00L58em/S8
         LyMtnMW6WNTOLmpCCLgFhjtXRHvioTrIjSEMOgkj/5pNwTnFURKE7SoXgnIFHSKJlxm7
         5dHgisi/XoO0y/bZJDGtu2wfwjWFFZyPQWgvhJBYuNzKEipvNKC5bXKEKVqWkt/8iX9n
         HjlVXcUDaU/HdWJEpAP4XNFrWEKAS6SiHJVMdw/c8P6m8wG1Y8HPV7dlVg9o/crV6zSE
         WLSQ==
X-Gm-Message-State: AOAM530JNcMmhR+KP76MNRy/OsuNhEjbdwj2MUcYc+7OjHcXfN7R4WNf
        ECxRZgSMK8EpjM7n65LrUAhmh41IwVxGP7s5
X-Google-Smtp-Source: ABdhPJwnX2v94OKjJPd34spVYe57hZFYPoo1jtoYJkbEm2+34bNZZdHV603ekmNyj53WBzcddmrVRQ==
X-Received: by 2002:a05:6512:783:: with SMTP id x3mr13867943lfr.560.1625594734922;
        Tue, 06 Jul 2021 11:05:34 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id 189sm770080ljf.117.2021.07.06.11.05.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 11:05:34 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id t30so10288930ljo.5
        for <io-uring@vger.kernel.org>; Tue, 06 Jul 2021 11:05:34 -0700 (PDT)
X-Received: by 2002:a2e:50b:: with SMTP id 11mr16701446ljf.220.1625594734000;
 Tue, 06 Jul 2021 11:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210706124901.1360377-1-dkadashev@gmail.com> <20210706124901.1360377-8-dkadashev@gmail.com>
In-Reply-To: <20210706124901.1360377-8-dkadashev@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 6 Jul 2021 11:05:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=whdhY-RT=8wky=MgxAo0C9gSODcimLg3brdNy9p6OzhxA@mail.gmail.com>
Message-ID: <CAHk-=whdhY-RT=8wky=MgxAo0C9gSODcimLg3brdNy9p6OzhxA@mail.gmail.com>
Subject: Re: [PATCH v7 07/10] fs: make do_linkat() take struct filename
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

On Tue, Jul 6, 2021 at 5:49 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> Pass in the struct filename pointers instead of the user string, for
> uniformity with do_renameat2, do_unlinkat, do_mknodat, etc.

This is the only one in the series that I still react fairly negatively at.

I still just don't like how filename_lookup() used to be nice and easy
to understand ("always eat the name"), and while those semantics
remain, the new __filename_lookup() has those odd semantics of only
eating it on failure.

And there is exactly _one_ caller of that new __filename_lookup(), and it does

        error = __filename_lookup(olddfd, old, how, &old_path, NULL);
        if (error)
                goto out_putnew;

and I don't even understand why you'd want to eat it on error, because
if if *didn't* eat it on error, it would just do

        error = __filename_lookup(olddfd, old, how, &old_path, NULL);
        if (error)
                goto out_putnames;

and it would be much easier to understand (and the "out_putnew" label
would go away entirely)

What am I missing? You had some reason for not eating the name
unconditionally, but I look at this patch and I just don't see it.

              Linus
