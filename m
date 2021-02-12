Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEC931A5A5
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 20:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBLTwX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 14:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhBLTwW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 14:52:22 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F202FC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 11:51:41 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id v24so1123732lfr.7
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 11:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XI1CcDZ2SyiVK78cpdgHN5DEl1oQ21xAe3VnrWgWe4Q=;
        b=BaOhUoZW7EGBG22X2wgg2TlHHbP9a67oDi0s9xcVtgLrY5YgyJrSujKK5CggRj94ls
         G4mJaYQ/DBdX2j6fjhswP1RjMrVEBUPBjNHjtdC663T2yHoxF3af4VWrvgoGy8vuNU1y
         a2m6DQ8qV2BscDtB7p+IrbricRU1vsigAPMkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XI1CcDZ2SyiVK78cpdgHN5DEl1oQ21xAe3VnrWgWe4Q=;
        b=JappiyQyyzxZ9LPDDYAVrMtKyRTrF/jEzzrZNzyb9yU1nslG9VOVqfiE2tbGcBJJMF
         9Xipja9MyWInD/RoWk+V0wDSNc/yf9BCP9aY6ob5QXGfhlg3VS0LsUu9BCnvFyjx0O+y
         cHQL3CAd5VBG3AuFAtIMEdEnqb9fuSeZedWISFiHURYgkim7qFITGV1AEnITFxDP/FMm
         LI76xRe7bjBl3/VmkNtnCxHGMeCdKd9Wf3SvhwdkhV3HWpVMAG0PPXG+I/SR/4qw5zim
         FFmHp2vlD1Otw5QrKqN5sse3xaYOgR28X/+NR43K4+s/qTpHH7jsOqUODwz5mW8IkJbJ
         7RZg==
X-Gm-Message-State: AOAM531eJcBvGJBcOMvieRV1ZLYqW1kt1m97bersVgbruQo/HgmyuOoB
        ImmSQRpkyC1IACm9U7dJ0XpyVjR4X3iYHA==
X-Google-Smtp-Source: ABdhPJzjC2VTwIEB34v5i2hX0S2QeEG3SR/hdG22z72dsqjzfK4WKj8TsomvQZd718Z4E8XPRhOHtA==
X-Received: by 2002:a19:7e15:: with SMTP id z21mr2461460lfc.290.1613159500099;
        Fri, 12 Feb 2021 11:51:40 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id u13sm71459lfu.80.2021.02.12.11.51.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 11:51:39 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id j19so1069073lfr.12
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 11:51:39 -0800 (PST)
X-Received: by 2002:a19:7f44:: with SMTP id a65mr2281892lfd.41.1613159498759;
 Fri, 12 Feb 2021 11:51:38 -0800 (PST)
MIME-Version: 1.0
References: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
In-Reply-To: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Feb 2021 11:51:22 -0800
X-Gmail-Original-Message-ID: <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com>
Message-ID: <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.11 final
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 12, 2021 at 6:08 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Revert of a patch from this release that caused a regression.

I really wish that revert had more of an explanation of _why_ it
needed to retain the ->fs pointer.

I can guess at it, but considering that we got it wrong once, it might
be better to not have to guess, and have it documented.

            Linus
