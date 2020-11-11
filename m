Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB65D2AF22F
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 14:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgKKNbF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Nov 2020 08:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgKKNbE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Nov 2020 08:31:04 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECAEC0613D4
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 05:31:04 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id b16so993767qtb.6
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 05:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=bt7KK3+6FBeKnmbngl2aQPxELz+xreb5TfjkrECem4g=;
        b=lmZfYSKk7jOB4MzdaSfM2mgwqqvFcDhTsEOerCxu1GBckK75+PpPU9f4UxcaqCuk3W
         pQZngJ6CDTTpT5jXFKl+GB1EahkbeLRD1TLwYzF2LsKeuxc9T8Uha78Rdw9w1sIm1999
         xaBXda5NXvjOV+intCXhHnGVF7tUPLt1AWD2xdL+YLO7REgHiiYlYh8JKSZfjzjHGIxm
         0S2c8dUb4Oj1f9VSGwiqonO6g615ZjhlRFKgnb+ZxsNTXKRrl7T1sk4ohTaf+eJe7Mv2
         CY7/2zL309yCXQeJXqfm3hvND7PHb53Qld8ZRPnVj3q6XpL4o4bJxPCwXroyJhyCzBnx
         0g4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=bt7KK3+6FBeKnmbngl2aQPxELz+xreb5TfjkrECem4g=;
        b=JWE9zaU+c2xHTx+jtLDef8Rh+O6kKwNmDY/UkMKKoHqs4pzckK7wrCaI3sseJXp2ZR
         9PdqdzwgNDcqJnyAemyjzzNEWTnoYBYwD2LTI7DqI8T63ZhMZ/J3GAwSFbyAtUx3i1YC
         k/7Dohx5YcLOsv8GimfmDQO4ttRuA8FG+OqxdozDb+0YarY8yBIAc3L10I0RdVvWSai9
         yW4NmL7tnmC46r43yUckGk9uVpvdU1/nrnkHfdj73kz+HsCbaLoKtaL2KR2TnoGT7JtI
         13L2rM2S7T6KtSmm2SrOjpgD0/FFLctNYn2jZHwhJaIm2Q9k5Jas+eIcyfo0zp+BOODe
         dWZQ==
X-Gm-Message-State: AOAM532hgFyeejNM7UDo6QqMHRCC+StQJ+ePM3hqQsr/LdQeYwyhlkTt
        gkum7KFvLBQGI30H3AbH0NVaP2AVubJ7DjCqU138WYKymxFbHLno
X-Google-Smtp-Source: ABdhPJyRCZFa3UmFUtcfYdkdGN6GURhyTgbzlysV/UeEWVPHTmgAjre92EHBLNtxk5EL33HIh93Up8R411fdGzeSRpg=
X-Received: by 2002:ac8:37f2:: with SMTP id e47mr23137052qtc.290.1605101463414;
 Wed, 11 Nov 2020 05:31:03 -0800 (PST)
MIME-Version: 1.0
References: <000000000000b09d8c059a3240be@google.com> <00000000000036d7e005b3cc1e79@google.com>
In-Reply-To: <00000000000036d7e005b3cc1e79@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 14:30:52 +0100
Message-ID: <CACT4Y+YeEVViLbJXOogzer+3MqtrMuFpt9-kj+1UENJw7uyAAw@mail.gmail.com>
Subject: Re: WARNING in percpu_ref_exit (2)
To:     syzbot <syzbot+8c4a14856e657b43487c@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Nov 11, 2020 at 4:09 AM syzbot
<syzbot+8c4a14856e657b43487c@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit c1e2148f8ecb26863b899d402a823dab8e26efd1
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Mar 4 14:25:50 2020 +0000
>
>     io_uring: free fixed_file_data after RCU grace period
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=161ea46e500000
> start commit:   63849c8f Merge tag 'linux-kselftest-5.6-rc5' of git://git...
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4527d1e2fb19fd5c
> dashboard link: https://syzkaller.appspot.com/bug?extid=8c4a14856e657b43487c
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c30061e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1251b731e00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: io_uring: free fixed_file_data after RCU grace period
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: io_uring: free fixed_file_data after RCU grace period
