Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7C9370D86
	for <lists+io-uring@lfdr.de>; Sun,  2 May 2021 17:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhEBPCI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 May 2021 11:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhEBPCI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 May 2021 11:02:08 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F951C06174A;
        Sun,  2 May 2021 08:01:16 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 12so4319298lfq.13;
        Sun, 02 May 2021 08:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2KrJJUJkSjKMGeIgnhlr8UaRUqJR8X3RnPrqNiC5mho=;
        b=gFpp31vhRno67oZ4qs1YYGLJCCTVCfnOGHW6AeZAcHDLKNdY2RPaiYUL+qww7iBvdp
         jLPJZR2ir6RBZxAn9IkxscTG0x5PLLdeUGFU0HaTrKJU6NhaLzuzR8GtJih0Zay0yUqK
         xlwEp3NymZVwlXmFq3Coum9BqZvX1nSqEGdlLXoSZhdNnrDIb7YgRChwl1H48Kw950wk
         EpEH01jDYl936uMPkDNvbpLitjN0p7WXPr792CCe/I8CF79JBbzoGC/C9gNJGLPDxft5
         8ZL7ONYqAUmnaGlqg7hkVIlavpJLa1djBsTt3+MfTfvUDpNARk8viamqzjW5nYPzY0eM
         Qjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2KrJJUJkSjKMGeIgnhlr8UaRUqJR8X3RnPrqNiC5mho=;
        b=sWukIZNp/iiBD64pMAgWuHu7tGtGMee3RJfBp7M4E0lYw2PXEGyJKTQ6Jl/Cb4UZzk
         rqS/SSjg+Ok83aznA9ioT0vErg0896KmeJ9Se0dSlDbvme2aMZlvpZPBkiX1uid7CykR
         cq+4eFgu/G1r5I/hepSxeZqlvW+lHk79mkCmR1TlYZILYDl+hHMZDUJP+RQHvEAxndSI
         DED84wSV4bKjPLYmIMoUdwCHpXaPVNNVyJ0psyDi3tSxVTyl214x898jXt1D0wKpf5Ua
         ikdCXJm8U3IcunUrS367gkRdGw5tNvI5Xy9otLKgGcAtB3B19/pNcLWc+W/qFGvDYY57
         90pg==
X-Gm-Message-State: AOAM532CU/AmN5ZqRWM01MsvjRAMkeJjydWuozYIg3X8BLi6prZuECba
        3nlwIOrl85G2SNtSWPgh0SN7O3qkJLqxT7Ylx74=
X-Google-Smtp-Source: ABdhPJydayfR18ybm6VTswWed5R8D/ew2zWIfn3GUoTqFZCZo9BBctr6FNlV6QNW1n9QjAIov6GEFwsqj4msg1qmLTA=
X-Received: by 2002:a05:6512:3b07:: with SMTP id f7mr10498383lfv.470.1619967674845;
 Sun, 02 May 2021 08:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000c97e505bdd1d60e@google.com> <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com> <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <a6ce21f4-04e7-f34c-8cfc-f8158f7fe163@gmail.com> <CAGyP=7czG1nmzpM5T784iBdApVL14hGoAfw-nhS=tNH5t9C79g@mail.gmail.com>
 <12e84e19-a803-25e3-7d15-d105b56d15b6@gmail.com>
In-Reply-To: <12e84e19-a803-25e3-7d15-d105b56d15b6@gmail.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Sun, 2 May 2021 20:31:03 +0530
Message-ID: <CAGyP=7fAsgXjaK9MHOCLAWLY9ay6Z03KtxaFQVcNtk25KQ5poQ@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hillf Danton <hdanton@sina.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 2, 2021 at 4:04 PM Pavel Begunkov <asml.silence@gmail.com> wrote:

> > I tested against the HEAD b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
>
> However, there is a bunch patches fixing sqpoll cancellations in
> 5.13, all are waiting for backporting. and for-next doesn't trigger
> the issue for me.
>
> Are you absolutely sure b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
> does hit it?
>
> > commit on for-next tree
> > https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/?h=for-next
> > and the reproducer fails.

Hi Pavel and Hillf,

I believe there's a little misunderstanding, apologies. The reproducer
does not trigger the bug on the for-next tree which has patches for
5.13. The reproducer process exits correctly. Likely one of those
commits that will be back-ported to 5.12 will address this issue.
When I wrote `the reproducer fails`, I meant to indicate that the bug
is not triggered on for-next. I will word it better next time!

Palash
