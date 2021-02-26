Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5E03266CD
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 19:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhBZSRe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 13:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhBZSRd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 13:17:33 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB67C061786
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 10:16:53 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id d24so15153877lfs.8
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 10:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99a7j3IPU6MsLjqN24w3g3bevy/blExnCopWiYUJ2d4=;
        b=BCEct3s4BbtrzQjX41Z4SpgBwTJ9dmwO8ooUU0+64pKs+Ngscm/jayLFL9bxcSuvjl
         NQnlO61TmM5W5BKWWp7psQT6ebIUU0/rwTrbbdFL03duoVnoBYzgntEELgiJGKg2yu5a
         4y8bg5ay3xFKVLEVtJAT0mfKIM+qAfrISpCvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99a7j3IPU6MsLjqN24w3g3bevy/blExnCopWiYUJ2d4=;
        b=CNeUDbwskvaaXy6pwZyX8fPk1uBUQJ2VyTDi6GfspT5jYqoe7plrlhWT1MMnaWuGCv
         e5YndSVqg7PDS58UB+pL6kioeb2V8tvZxDS1L8O+zbHoWqweCUbBuHNfXPvtA/SLdijJ
         B0NPrnM0in2wa4Z1bxuwbV/acYLEz+YMFA4p8ykd3kyHk7PGQM2yr7xFLa0PJOul/M6D
         XcUg+F7aLUcFBNTXgmWKOa2KXwJy+Ubo4peOnu/kK8FcODqgmVu2yXnXbeB33es5fmtY
         J3nsUhwQfPzgDNiZW8Qm0VmCpovqy4yjg48I/0AoDcJTuxkVPmj0o+xisWtvRnnEjCe4
         m7Lg==
X-Gm-Message-State: AOAM532rbAgpr6JZ0NPyZ4AHzj07MkSWhyHAqJooyeh/nksZ9AqSs+UJ
        hkVTxhqxQHXPgTNjFpnWTOW2RXpWXBDfQw==
X-Google-Smtp-Source: ABdhPJxROp1p3/zXyNDVJ5b448ooF4kyvGyMg7zjxHH6KcMnsA33SRO4pOTiE92r9gdx7M5spqvYDw==
X-Received: by 2002:a05:6512:22c8:: with SMTP id g8mr2463945lfu.388.1614363411598;
        Fri, 26 Feb 2021 10:16:51 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id d10sm84503ljg.112.2021.02.26.10.16.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 10:16:50 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id j19so15117078lfr.12
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 10:16:50 -0800 (PST)
X-Received: by 2002:a19:ed03:: with SMTP id y3mr1670550lfy.377.1614363410112;
 Fri, 26 Feb 2021 10:16:50 -0800 (PST)
MIME-Version: 1.0
References: <c044d125-76d4-2ac0-bcb1-96db348ee747@kernel.dk>
In-Reply-To: <c044d125-76d4-2ac0-bcb1-96db348ee747@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 26 Feb 2021 10:16:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjT=EZEeNScNUv4z-KoMphFSw4PM95e=MUXtBXMQF+VgA@mail.gmail.com>
Message-ID: <CAHk-=wjT=EZEeNScNUv4z-KoMphFSw4PM95e=MUXtBXMQF+VgA@mail.gmail.com>
Subject: Re: [GIT PULL] Followup io_uring fixes for 5.12-rc
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 25, 2021 at 2:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> A collection of later fixes that we should get into this release:

So you decided to not try to push the "user threads" rewrite for 5.12?

Probably just as well.

            Linus
