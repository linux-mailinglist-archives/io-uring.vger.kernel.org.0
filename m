Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E5F3A344D
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 21:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhFJTxJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 15:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhFJTxI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 15:53:08 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FCFC0617A6
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 12:51:11 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p7so5053909lfg.4
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 12:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R7gUGOzETMzYFAG4seIz29zubSDkdiXjPsIc9hK01xE=;
        b=aBsNBHP0NpRBvB46PeLY9+arShvd1498r3GSD0O2n4SRYflDcL42dQNQtcGknUePat
         3nywBCNe6xd+GcU1Vx9TJ6128jk5YFNdIWWwxAVHawjXXU8e4kV4pi9X+M42A+gU72FM
         jdWC7EmtUd4URMrXwAJ1eo4czRMFqiB5EI9nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R7gUGOzETMzYFAG4seIz29zubSDkdiXjPsIc9hK01xE=;
        b=M6DertvGom0hfmgQ0j14D17VIRbf6dMQy3G8yYsGGQCpY26Zt8WHUrolAjDT7sOus5
         2T2FGuHTF2k+CxiIqsSLvNsdxtU80RLLHmUyC/NzHX65a43/cKUZtJRq8dxFlmEbuO07
         oCgnjDSkFIvjt7m84VgBF0Qvv6/d2m6NeuQay0zHO/SsozQmFZHpdi2BN82GpyRVOjZg
         lLys5tVReWpNP8LyAWqsLIi8DQwdc5GoStsf+Aw+oO6upsUEMnOunloW+XteEL+4xEJg
         PQLxFzt5XkZrI1IMVpTL9qM4t9uClQaSl4wBPVd9tFBWxo8/nc4N+cgUi9otStuRP1XB
         mVqg==
X-Gm-Message-State: AOAM5327pHgk9eSu+zl8ZfAnDMDqXkgYqbTa0suiUNfKEmZscGuFzRcz
        /lfsHV6vWUry5G9NYxpGczE+2U5nBKwd5jB+Xk0=
X-Google-Smtp-Source: ABdhPJxF/nm2CjqG4e+xh8YXLjWALkXhI3mI2dHe0J2TqxImyV30NDty/dRmy/pJgTOvgyO4MWiWGg==
X-Received: by 2002:a05:6512:3d8f:: with SMTP id k15mr304366lfv.362.1623354667071;
        Thu, 10 Jun 2021 12:51:07 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id y7sm431896ljp.69.2021.06.10.12.51.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 12:51:04 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id r198so5014758lff.11
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 12:51:04 -0700 (PDT)
X-Received: by 2002:a05:6512:3f82:: with SMTP id x2mr266721lfa.421.1623354664442;
 Thu, 10 Jun 2021 12:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133> <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
 <87eeda7nqe.fsf@disp2133> <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133> <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
In-Reply-To: <87y2bh4jg5.fsf@disp2133>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 10 Jun 2021 12:50:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
Message-ID: <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
Subject: Re: [CFT}[PATCH] coredump: Limit what can interrupt coredumps
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 10, 2021 at 12:18 PM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> I just didn't want those two lines hiding any other issues we might
> have in the coredumps.
>
> That is probably better development thinking than minimal fix thinking.

Well, I think we should first do the minimal targeted fix (the part in
fs/coredump.c).

Then we should look at whether we could do cleanups as a result of that fix.

And I suspect the cleanups might bigger than the two-liner removal.
The whole SIGNAL_GROUP_COREDUMP flag was introduced for this issue,

See commit 403bad72b67d ("coredump: only SIGKILL should interrupt the
coredumping task") which introduced this all.

Now, we have since grown other users of SIGNAL_GROUP_COREDUMP - OOM
hanmdling and the clear_child_tid thing in mm_release(). So maybe we
should keep SIGNAL_GROUP_COREDUMP around.

So maybe only those two lines end up being the ones to remove, but I'd
really like to think of it as a separate thing from the fix itself.

                Linus
