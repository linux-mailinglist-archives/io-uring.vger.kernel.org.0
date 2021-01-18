Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D412FAA02
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 20:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393930AbhARTWH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 14:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393929AbhARTWB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 14:22:01 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA460C061574
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 11:21:15 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id m10so19394286lji.1
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 11:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/nyXt2BwkLcSSRby7WCMrmE+WdBMXZvF9/GDTDgxsVY=;
        b=FgEuPeyIPamZN1Ti5cyla9+JQiWchG5usHW0nz7RiFfN4ZG12cH4uk+0GptG8B/IWA
         J+9VHvATxzV0qZoPxsaWt52OJ2WeDAZZ0Ey4l9G4Byauek/KmFoS0wtarV9C1U/vQhcp
         zDcDF/LIEdOs4AuBkR07AWCI6pKVrt2L/RMZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/nyXt2BwkLcSSRby7WCMrmE+WdBMXZvF9/GDTDgxsVY=;
        b=js3v6WIfCk29+rB+OozGa23x7XpIx/+6RBGvbjXP0YeJlPEoncZ/G/5Hs4JK5iMlcy
         Sy8+O3LNfK5wP9tE1EHaFLQQJOS9jfqySGXA9nQIT0/8XOIGCKv1h8HKrhbEQ+D5K58X
         C+/wNIHD5JLCgjHXEwrgKNGEk2ROosUeKGV9prc2Etc678CMMvdpIwp6HxlhrwebFVTK
         odkVXVNP3VMKRi3Yp/5XdIVdhc7MuCRlu8tfHXPBT8YFBL088qtvawSIQXG7DAaznjs3
         NofhieH2pPCU8+PWASfUpZgLZGygV1vQPggbwCYwvCa8Kvmb3sWbG6JbHCAqxUPiuHpZ
         K+Vw==
X-Gm-Message-State: AOAM533qnlanrlsGopgj4B9Ip+9hX4chrkb5t5SK0yzbmSuTy0tnpCSU
        uV5kVBTd+gSDRPd5Rd35s0Bhx+Pkkh3lmA==
X-Google-Smtp-Source: ABdhPJyS6zYwwr4AgpoQ3rFC7DWOT2d4j3eETNJ8ZymQCHb942lljvTA+kMewb9Oxpwd5zevd3sMsQ==
X-Received: by 2002:a2e:984a:: with SMTP id e10mr450159ljj.179.1610997674101;
        Mon, 18 Jan 2021 11:21:14 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id m16sm1993938lfb.248.2021.01.18.11.21.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 11:21:13 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id a12so25654569lfl.6
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 11:21:13 -0800 (PST)
X-Received: by 2002:a05:6512:a8c:: with SMTP id m12mr234936lfu.253.1610997304440;
 Mon, 18 Jan 2021 11:15:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610722473.git.gladkov.alexey@gmail.com> <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
In-Reply-To: <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 18 Jan 2021 11:14:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
Message-ID: <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
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

On Fri, Jan 15, 2021 at 6:59 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> @@ -152,10 +153,7 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
>                         ucounts = new;
>                 }
>         }
> -       if (ucounts->count == INT_MAX)
> -               ucounts = NULL;
> -       else
> -               ucounts->count += 1;
> +       refcount_inc(&ucounts->count);
>         spin_unlock_irq(&ucounts_lock);
>         return ucounts;
>  }

This is wrong.

It used to return NULL when the count saturated.

Now it just silently saturates.

I'm not sure how many people care, but that NULL return ends up being
returned quite widely (through "inc_uncount()" and friends).

The fact that this has no commit message at all to explain what it is
doing and why is also a grounds for just NAK.

           Linus
