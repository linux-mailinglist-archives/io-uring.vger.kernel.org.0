Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3DD40D42E
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 10:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhIPIBV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 04:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbhIPIBV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 04:01:21 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0676BC061574
        for <io-uring@vger.kernel.org>; Thu, 16 Sep 2021 01:00:01 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id v20-20020a4a2554000000b0028f8cc17378so1825517ooe.0
        for <io-uring@vger.kernel.org>; Thu, 16 Sep 2021 01:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=93zx3vU1aklDWU/pl0rAprDMWU2o0pwv4FUA4FyOCAc=;
        b=Nh3thr9/uwyT4GqeuZdCadhw3TTv9l0fUkLi4cddtGIVWB/kSoHsl8RTQbXDy5GtT6
         wjIzSY6/nzhY3Fc7vPfgHXDXQlFjS38SbEqO52gLhY7c0UBT72zY3Y6nYK4JTwqzCZI/
         qFwoCHIJM81r1ojcjumVtghzPeYlmah802j9eAtxSnxipUWOoeU1WYA9BYbiUblowCll
         ru/hes4cVP8nQnR1HUMMazk26L/mC97CFDZhAjxqVBDhpE18Dbm6V6s+ot1wnykLKzV9
         S7V+FTjKBAIyAND6vb6Y5jSEpeAi0x/tYu1olh4Nm76fhsHdzEfKzLkfzENxcf7P6UAB
         YHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=93zx3vU1aklDWU/pl0rAprDMWU2o0pwv4FUA4FyOCAc=;
        b=02+muvgA48BdRP+qwxfjoTYNnfA+aeNpBD1DaPCxYV28gWMCZ6/mRgocos30ejq+Gz
         irJqTi6TNUjmZiC45vxeKF6ZxTO0LIf5iulyN8xn+TMYaC8FUnWz/pi64EyxuBJQ/HX+
         9kFAJ/l38236dJvecvaaqZJy7KGeMnpaHgik7Z6O/ZUZ91LC8LlgMb939l3KY4roc5aK
         xmwbxSLht7WPern9MwGqv/TwThZWA1CXn2opLWst6Ya+gcTSFmx/SpGcVRuzf/Xi0GiD
         CM28iSj3+Mp/tJoX7cn2xj9uq94XnqhNkarBGm9sPaHE4L1RUpUjWuTxbr+6Q3a3X1yq
         YV2g==
X-Gm-Message-State: AOAM530pWmtmmn7hKEbxNAG9UqqTYAq9rDrMNzZOMOOF8OZQVAmL/Npv
        9ewBeZ/7o54rof58WJXi6eVKlv2I6Ck9J6I1WdVU3g==
X-Google-Smtp-Source: ABdhPJx9WYkZtAm+l9hmPej8DdPKD0lNlKUA5YclHnJHZua1+FIPkm8muONXSS2oM1OJ+gYUhz1mA/ik1Z98A1nQUt4=
X-Received: by 2002:a4a:e792:: with SMTP id x18mr3298706oov.53.1631779199332;
 Thu, 16 Sep 2021 00:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006e9e0705bd91f762@google.com> <0000000000006ab57905cbdd002c@google.com>
In-Reply-To: <0000000000006ab57905cbdd002c@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 16 Sep 2021 09:59:48 +0200
Message-ID: <CACT4Y+avszKiyXYBTRus9DqeSUoGrWC8d2uEiJN3z=oYQSdz0g@mail.gmail.com>
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
To:     syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, coreteam@netfilter.org,
        davem@davemloft.net, dsahern@kernel.org, fw@strlen.de,
        hdanton@sina.com, io-uring@vger.kernel.org, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 13 Sept 2021 at 11:22, syzbot
<syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 43016d02cf6e46edfc4696452251d34bba0c0435
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon May 3 11:51:15 2021 +0000
>
>     netfilter: arptables: use pernet ops struct during unregister
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10acd273300000
> start commit:   c98ff1d013d2 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c70e618af4c2e92
> dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145cb2b6d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157b72b1d00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: netfilter: arptables: use pernet ops struct during unregister
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

I guess this is a wrong commit and it was fixed by something in io_uring.
Searching for refcount fixes I see
a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 "io_uring: fix link timeout
refs".
Pavel, does it look right to you?
