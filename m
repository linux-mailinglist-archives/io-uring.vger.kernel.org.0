Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AF731A5CF
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 21:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhBLUId (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 15:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhBLUIc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 15:08:32 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13641C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:07:52 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id g21so511765ljl.3
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0juuztKOuclJVf6jO919ZUtqCO3CXkHV+6pZcrWrmmE=;
        b=BA5V+MeDf3hiYcXETRHIj14RfrSZqfo+NHe3ba+gHW1zpVXmjHVwBkhwhyIcS3zv6d
         IJZ2cKJuGp4oPrDz1AGnhW8kaSIqeAPqeiAtNQb3nfdwfYoGxrjf8Qx1GYAHxldI2+/d
         3BUOpn56jaMEojw+blTFDwDVKREncakZ0CJuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0juuztKOuclJVf6jO919ZUtqCO3CXkHV+6pZcrWrmmE=;
        b=jIrmhVRLAxq2mwRItbpf70Y8Fl1OQcmqIiy1zZIXFjD9mo/Zy9PB0JpEw17PSewK8C
         z67yOb4nQjZwdFDsUQF1WStfD6E5No9qaHT2L2N8L9WmQPAY+6cLOVS1OyRsk3ZvUAaH
         gVOzk0Xr7S04bm7kl0FCLdkhX4bbdi/GXqji2Elq/OhgFdsi2/pj3Fl01nMV0XjoNzh8
         JGmqHqZ/ViTdTesPIdNdHDADkEDmYFdnUOBq+V5hH5u2T87sg7rSuVCdz8z61cDebzy8
         dwQEGGuBR6J2iGKUsAVS+uvm+WT4xhJgg/qlHLTlJxNOeWA78ALoKedBwz59+G9I6ICY
         vdsw==
X-Gm-Message-State: AOAM531nWk/KlZtjeUYi9CmbjZedbTn72jsB0YcXNE71iL6O/AnqwMbf
        Gn3GbD/e9kTSYsiNAOFJRbXQOcePN6uf1g==
X-Google-Smtp-Source: ABdhPJxBx5q77668XrIzFLFdPPncdm3dAkscLWzLL8JLqn94e0ibBkIgCE+FNpdmA8uZ31A2cQrGnQ==
X-Received: by 2002:a2e:a555:: with SMTP id e21mr2531833ljn.423.1613160470250;
        Fri, 12 Feb 2021 12:07:50 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id 5sm1238368lff.176.2021.02.12.12.07.49
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 12:07:49 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id f1so1226300lfu.3
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:07:49 -0800 (PST)
X-Received: by 2002:a19:8186:: with SMTP id c128mr2340758lfd.377.1613160469143;
 Fri, 12 Feb 2021 12:07:49 -0800 (PST)
MIME-Version: 1.0
References: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
 <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com> <1b7b68bd-80d4-8be8-cf6d-26df28e334ce@kernel.dk>
In-Reply-To: <1b7b68bd-80d4-8be8-cf6d-26df28e334ce@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Feb 2021 12:07:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjEuDEVBM+3SMStLC8Jh8iaDe4JY5hKg4SRGR5G6HuCtg@mail.gmail.com>
Message-ID: <CAHk-=wjEuDEVBM+3SMStLC8Jh8iaDe4JY5hKg4SRGR5G6HuCtg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.11 final
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 12, 2021 at 12:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> We end up doing path resolution for certain cases, so having the
> right fs_struct ends up being paramount. Do you want me to update the
> commit with a fuller description?

I've pulled it, but please keep it in mind.

What are the "certain cases" that need path resolution for sendmsg?
I'm assuming AF_UNIX dgram case, but it really would be interesting to
just document this.

Which was kind of my point.

               Linus
