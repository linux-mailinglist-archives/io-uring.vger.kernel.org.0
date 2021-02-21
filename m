Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6C4320E43
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 23:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhBUWVC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Feb 2021 17:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhBUWVB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Feb 2021 17:21:01 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8477C061786
        for <io-uring@vger.kernel.org>; Sun, 21 Feb 2021 14:20:20 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id r23so52763532ljh.1
        for <io-uring@vger.kernel.org>; Sun, 21 Feb 2021 14:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1qgd2CaVptvTGUhKDlRkh0Z0LDGRbgbRYJVc77psjI0=;
        b=fQbjNDMH2LW1wJ6/r4mnToB2sVMQoAqDNnIZC0tTft5RHW4oL4vhaTeQgpZVKMxF30
         nT/00d78iK839oXEHN4u+yaZt1zEu/r+rdbRCiRpFFQ0sRSQ1Q8kcb6WJ03qin0IMNCZ
         KtNASVw7j3Rywzu1pVAHxoAg6F7vA+1EvIbPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1qgd2CaVptvTGUhKDlRkh0Z0LDGRbgbRYJVc77psjI0=;
        b=bgduW8ytHPd0fe+qi8j/KenR/6mf+cmqEpXrW0ETzR1wQF3lc6KdmGcC0NQ61y9/lH
         lIgz3SuQrgbl63b3ZKMW2tiv2b1Dei9NzCrinQaolt+v33ANV8y2ejzx0s65k/0ZJ6jx
         KJmR720bupkSsJRqKnB16D4qQXA78uMPlArAqlAY4g/pJYQiuOrBdoTPG+gI5PzZzS/B
         OvFH5yGNIhtvkn6iHYPWRAqtuDvaBBPinCoPDCtaYeRZN/rRmgP4UutQ9OQpS3q9wkHy
         HF6gs1HVfpbvFfn0q4f1hMLuST9ERqzgBjwbH9KFuUNOS6WprNw9ocak3wTMnxH5lZq8
         ZKQw==
X-Gm-Message-State: AOAM5304NjPnrwhs0Z6K6Q5nx1hawFXRoKatvKoyDWdeTmYpKt/Y9tHi
        MfznlpI5UTbBue9cHOIgtRU16cV2P7bN7Q==
X-Google-Smtp-Source: ABdhPJxc/nDDrzVGlQKz4K1iSDyLkOftg41jL1Iy+smRpgL965Jw/uYxY5zTxi1SCg5CAtl+klPjZA==
X-Received: by 2002:a2e:b355:: with SMTP id q21mr12492849lja.209.1613946018815;
        Sun, 21 Feb 2021 14:20:18 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id p13sm1874266ljj.49.2021.02.21.14.20.16
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 14:20:17 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id q14so52705744ljp.4
        for <io-uring@vger.kernel.org>; Sun, 21 Feb 2021 14:20:16 -0800 (PST)
X-Received: by 2002:ac2:4acd:: with SMTP id m13mr6041704lfp.201.1613946016272;
 Sun, 21 Feb 2021 14:20:16 -0800 (PST)
MIME-Version: 1.0
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
In-Reply-To: <cover.1613392826.git.gladkov.alexey@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 21 Feb 2021 14:20:00 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
Message-ID: <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] Count rlimits in each user namespace
To:     Alexey Gladkov <gladkov.alexey@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Alexey Gladkov <legion@kernel.org>,
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

On Mon, Feb 15, 2021 at 4:42 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> These patches are for binding the rlimit counters to a user in user namespace.

So this is now version 6, but I think the kernel test robot keeps
complaining about them causing KASAN issues.

The complaints seem to change, so I'm hoping they get fixed, but it
does seem like every version there's a new one. Hmm?

            Linus
