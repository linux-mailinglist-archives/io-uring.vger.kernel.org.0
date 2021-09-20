Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27774110CA
	for <lists+io-uring@lfdr.de>; Mon, 20 Sep 2021 10:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhITIRp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Sep 2021 04:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhITIRo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Sep 2021 04:17:44 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D60C061760
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 01:16:18 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 67-20020a9d0449000000b00546e5a8062aso10446864otc.9
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 01:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SxNY97BOa0XmidHr8ngX6Xmdmy0rlhDyfhQlgL+xf9M=;
        b=PflVeIefh9PtZyUXgOPqCGhfsFGQSSoYDchsSVS5Wrh2uVaeVBJbila4EfZ/2fVXuP
         HJdnuNyXvRsF090bByE/Gj43INuq+5RbRXH78KatIS86fIQ8WgTnLdTMMOhRoFklJyMw
         uKIr96sGaEhw3+PQnryCOySdDSsY/f03Dbp50ugJ+HputJhUOvh1RuS9f6F3Q7X0Dp4f
         q6B9fYWrfi1TncQIfoET8rvBi3dL1XRRlB0DOapn9zdASXH15Lut5vMByWA82nxCboTN
         0Q+cH15PLPCz+7qviSSM31rZpLHpPCqoP/mfcigc+aq2YOWHGP8UPUfQbAWChLz+39ff
         2U1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SxNY97BOa0XmidHr8ngX6Xmdmy0rlhDyfhQlgL+xf9M=;
        b=7vhoZC2klmOrq0rNV6cmk/Va1pEMbNdTaIMNzZq/up4lDBxaWa/w/NtyW2nqjF2/NF
         5vspGZSC+SR7DnymHM16dhOP9Jkb7Y67H4LS97DkjGGacadJLdaFRROk2Dt6I8dM7c+B
         ThDA5jQmJIPM+n6aKF15LDmG00SX3E+0JBeUgu3/TxGwG3Tf27xFIvtxj4UtgkAFP+eG
         Bub5F0PytAIKeJZ+MCBDrlb1gIN9NXz9nifeI5jkQcXI9FjmpORZtDc2V43P+WA2nO1A
         +nqiu1sX0cImRDfrJY+tpymSCz8wJkNt29WBAzWR1L1uMMj9jqlkZRP9mlZpGrdx43M9
         EIAw==
X-Gm-Message-State: AOAM530cpv97z4um7n3hbP5TxCQovSR4teu0SduNOWOqKtDeSajodSyr
        9lfaMcEHGIf97a42W9oBlQgAECPVihfG2jZWSLUM8g==
X-Google-Smtp-Source: ABdhPJxQYvOjJDSfjPQAxmlMvAz00/cVUDbJh6wOo5gIhqB/Ki9Kim5C50bKjMQiFlkco3PXh5M74WpTTLLbTThY1X0=
X-Received: by 2002:a9d:7244:: with SMTP id a4mr20552216otk.137.1632125777610;
 Mon, 20 Sep 2021 01:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000022acbf05c06d9f0d@google.com> <00000000000053c98205cac53625@google.com>
In-Reply-To: <00000000000053c98205cac53625@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 20 Sep 2021 10:16:06 +0200
Message-ID: <CACT4Y+bnH0-6_M_BbB614j=1Vi3sjnU3oSxoKHKVYF-aGVBooQ@mail.gmail.com>
Subject: Re: [syzbot] WARNING in io_poll_double_wake
To:     syzbot <syzbot+f2aca089e6f77e5acd46@syzkaller.appspotmail.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, haoxu@linux.alibaba.com,
        hdanton@sina.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 30 Aug 2021 at 13:34, syzbot
<syzbot+f2aca089e6f77e5acd46@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit a890d01e4ee016978776e45340e521b3bbbdf41f
> Author: Hao Xu <haoxu@linux.alibaba.com>
> Date:   Wed Jul 28 03:03:22 2021 +0000
>
>     io_uring: fix poll requests leaking second poll entries
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15d8819d300000
> start commit:   98f7fdced2e0 Merge tag 'irq-urgent-2021-07-11' of git://gi..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=139b08f9b7481d26
> dashboard link: https://syzkaller.appspot.com/bug?extid=f2aca089e6f77e5acd46
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11650180300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1510c6b0300000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: io_uring: fix poll requests leaking second poll entries
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks sane (io_uring commit fixes an issue in io_uring):

#syz fix: io_uring: fix poll requests leaking second poll entries
