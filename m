Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2092440CD28
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 21:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhIOT1y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 15:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhIOT1y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 15:27:54 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C815FC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 12:26:34 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m3so6775582lfu.2
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 12:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6P9z1QCvAbv+k1VCp+BJZaSRLDdYfJBGVDJTbeRLGGs=;
        b=RYKWs9AXUkHcdaPvDhM9IiyTnFbvdFnNl9EWvWcjqUXDqr2f/hZEtv9pQp1KoMWL0A
         scCYipyvVNdf7qZYFLlaqanfBGdt7EngTZ41qZmuWN9jpiOJrrXi7I+JbbNaCtBplC5S
         jdU29T018/5bOfc5OAMr+9gI+XuB3QtFda90I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6P9z1QCvAbv+k1VCp+BJZaSRLDdYfJBGVDJTbeRLGGs=;
        b=614gSr0n0u03VbL+yyC7/TA0/6+Oca+xLZ5p45hg7xBX10ark0ZECbo+IDjipI4gvR
         NO2MEgEbG4z6SHwoUNPwMxUrfG+Y7rzlFdjbWQzUAfdklqxjV1h4G8ahBE8fOjgs8Tsy
         QKYSVt0nw8rgJ3tNhFhwBuZ/ER3BkhdhMlYZdCbtFxSGduv+jJFUF/l35NJuhGVw33u2
         0oL9+ElPdBmVRrkEXcDcKBQFt+XZK7RyFsu2lRiZmQYFBKFeb9OsOft5WVceXPJJuDEw
         Qv76GvZW3gBYLfKIDY05Rh4uQW5CNeyeuIyoWM1Vw0A1fiYK7xQygchaygcgu6beaOpq
         9fzA==
X-Gm-Message-State: AOAM531Z3V6h4U8PTWFPEjW70HB9FG9i4vhdh6FFipXPy9O+gzzDNoEl
        s5nDzPZ0MuzrBaIqmABKdG6vhJt8sTWJiDPZqs8=
X-Google-Smtp-Source: ABdhPJxCJWo8oL9zx922G6Dlb+pw/4xL/YoLVw++EChHjCTKj5qtV22egXt1awNHdmD23krQKVDl2w==
X-Received: by 2002:a05:6512:513:: with SMTP id o19mr1179690lfb.31.1631733992717;
        Wed, 15 Sep 2021 12:26:32 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id k8sm89311lja.57.2021.09.15.12.26.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 12:26:32 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id c8so8668874lfi.3
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 12:26:31 -0700 (PDT)
X-Received: by 2002:a2e:7f1c:: with SMTP id a28mr1419825ljd.56.1631733991308;
 Wed, 15 Sep 2021 12:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210915162937.777002-1-axboe@kernel.dk> <CAHk-=wgtROzcks4cozeEYG33UU1Q3T4RM-k3kv-GqrdLKFMoLw@mail.gmail.com>
 <8c7c8aa0-9591-a50f-35ee-de0037df858a@kernel.dk>
In-Reply-To: <8c7c8aa0-9591-a50f-35ee-de0037df858a@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Sep 2021 12:26:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj3dsQMK4y-EeMD1Zyod7=Sv68UqrND-GYgHXx6wNRawA@mail.gmail.com>
Message-ID: <CAHk-=wj3dsQMK4y-EeMD1Zyod7=Sv68UqrND-GYgHXx6wNRawA@mail.gmail.com>
Subject: Re: [PATCHSET v3 0/3] Add ability to save/restore iov_iter state
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 15, 2021 at 11:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>
>    The usual tests
> do end up hitting the -EAGAIN path quite easily for certain device
> types, but not the short read/write.

No way to do something like "read in file to make sure it's cached,
then invalidate caches from position X with POSIX_FADV_DONTNEED, then
do a read that crosses that cached/uncached boundary"?

To at least verify that "partly synchronous, but partly punted to async" case?

Or were you talking about some other situation?

            Linus
