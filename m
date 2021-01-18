Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594322FAB98
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 21:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394360AbhARUfb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 15:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388980AbhARUf3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 15:35:29 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A57C061574
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 12:34:48 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id x20so25880203lfe.12
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 12:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/gRDfD8YrbS3XwFv+1aIqhbdQ3uhWKzz+1gnqOggXc=;
        b=bt+FYJOGP9ZQRnSTHuwQLcEHZRbKmiPtmHbNsgK244Ouf8inj+gEKeqwbkLMxBsORz
         9XqHiL4j09NQl2Hbu7Zqohe8R4Mcab9BZ0x5QNfz6nqunlYqEM100bLwpChO1ztnC/8t
         YuMK5vRxoxly7Ufn/H5ahy9EptvTtBt/Xd6mM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/gRDfD8YrbS3XwFv+1aIqhbdQ3uhWKzz+1gnqOggXc=;
        b=WRT0R/7Ik1trttxyy/MHnKBWrRrDSK6SLgXTKZ4i0yDp5Pri5SeOw/i/kKyuqtmmDv
         ZWmOU2FHi7evAClfA6maKBKEVAdozaNaBDm31UiEVlRlhDB6ka+N7uJsxoS7YHe2aKlY
         KEvEWhW4/gXcCEULYQprC2Z8ox0b4/bxAxsqyTlOApRammbyF9nvLeTbF07P9EgFc7UI
         GYpcrMaFR7taG/2vtcu8qHwDDapfkBK1XvLVd9yREmbPpz3lI9iwUtConSdwfftaqylz
         pyVfJSaY0E37r1NnLsE4yaQeia3p/ynj9Q0osbNl61KbxscO+QQ5LwTsTx+Ea5Ez2syg
         u6DA==
X-Gm-Message-State: AOAM5319SU1t4BhcZxXa62hSEnkwrOsxZy+2/pTHihqIVmP90JMmFx6p
        eE11Fvqf2e/lVqIYmMD5asc2RJ1nICVMiQ==
X-Google-Smtp-Source: ABdhPJwDg63G+GWT/5kN6xqNwlrL2K4xl4Bq7Pvm1rp0BiTLWA5Zqyd4GcM8+l5WCECupHeaqHTWbA==
X-Received: by 2002:a19:7d7:: with SMTP id 206mr331682lfh.319.1611002087100;
        Mon, 18 Jan 2021 12:34:47 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id l8sm2082064lfk.120.2021.01.18.12.34.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 12:34:46 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id x20so25880109lfe.12
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 12:34:46 -0800 (PST)
X-Received: by 2002:a19:8557:: with SMTP id h84mr336671lfd.201.1611002085703;
 Mon, 18 Jan 2021 12:34:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
 <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com> <20210118194551.h2hrwof7b3q5vgoi@example.org>
In-Reply-To: <20210118194551.h2hrwof7b3q5vgoi@example.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 18 Jan 2021 12:34:29 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
Message-ID: <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
To:     Alexey Gladkov <gladkov.alexey@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 18, 2021 at 11:46 AM Alexey Gladkov
<gladkov.alexey@gmail.com> wrote:
>
> Sorry about that. I thought that this code is not needed when switching
> from int to refcount_t. I was wrong.

Well, you _may_ be right. I personally didn't check how the return
value is used.

I only reacted to "it certainly _may_ be used, and there is absolutely
no comment anywhere about why it wouldn't matter".

                 Linus
