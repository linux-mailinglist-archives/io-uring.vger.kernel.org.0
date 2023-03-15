Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D746BB0DD
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 13:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjCOMWD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 08:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjCOMVf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 08:21:35 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6573A968EA
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 05:20:56 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-3179d0e6123so262455ab.1
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 05:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678882855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9LWtMmwNU5RN2UUiNd6qX0REnIcvUfP+q+HAsDeToI=;
        b=tBd7j43X8Rcy5xGXZ8PD4WaLvF7fIg8H21xHti/LHPpWmBsgbMkRRjiwffaOrTq6T/
         Tq9+ZHmDu1wbwyV6Lt8eOvnXgA0q/fsIqeyAgfXJVql9NaGUcOodTKF/r6AvPNjewyHA
         DwF2MtdH7KzBHbQqkleW3KEqYvnFegPbm8Tr1Zco5X39YBnm5HOwwUTQH/URAaulsSNH
         zzmn45VlL17fUgEGFKSJlIn/cfjyReO5Ego0BMH6KsWsGHzCjgY6fRAaaFAa6v99MQD6
         45IkI4e8d0EVpF+nwZbFJdiF85WNJYxgI+SoyIq/GnByHu3IcIvYwk76htX0SHvBJsDY
         ay6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678882855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9LWtMmwNU5RN2UUiNd6qX0REnIcvUfP+q+HAsDeToI=;
        b=J8222W5Lz+YSiIUc0u3lcRHYNeTZux21ovZ8FZe9zYwW0CiDwvELkz31tBVy8bLXuX
         fdp+fqW1gpGr9qea6BID1H3rhHV7BrGOL/JjpAAnvWk/EwrEpBYfYKZJ9csQU48mtqC1
         y3SGyYjqHHBtGvEan472HxQBTfcKwLIrz/gnKVccLOcMhOikBMEmrY3BLhV0fQGz5Z0X
         d65RGpvS5Sx+ZA420qEMTZ+1vAmS6HY8eSsbIg3i5+cKiNhrfsU9lWSjQO9gClv+zyuH
         3kju6vDG0bJa1x9D9vYheg9AeoPlsYN2EnSbY/zrZmZxX5AtKE5dr9zeC/QguSE9DMbh
         /e1A==
X-Gm-Message-State: AO0yUKW1+nuxqM4bJGtj9RqYnh34wYjnwxfl+FyfG7cgmqB4KmFF35Na
        cLiNtQ/7qv42hCyyqJOzCbdG/DxC/DZN3GTAZeLYGEdpTbLzBSQ250lDWA==
X-Google-Smtp-Source: AK7set/BDCsFUC3o9yClLrmp6MTUMYjSwRRFok3qjddaILl8zvdw726C+KNgF5ZYz/yUDQqs/9cfSEGGM0rOUfwK8t4=
X-Received: by 2002:a05:6e02:1d95:b0:320:2d34:5f1c with SMTP id
 h21-20020a056e021d9500b003202d345f1cmr120943ila.9.1678882854961; Wed, 15 Mar
 2023 05:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009bff3c05f1ce87f1@google.com> <000000000000ec64a805f6a158c3@google.com>
In-Reply-To: <000000000000ec64a805f6a158c3@google.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Wed, 15 Mar 2023 13:20:43 +0100
Message-ID: <CANp29Y5Gfo8ZOGxtrM7DoZU+SwgXK1Nq79dsqh=bKL+B3M_EAw@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] KASAN: use-after-free Read in io_wqe_worker (2)
To:     syzbot <syzbot+ad53b671c30ddaba634d@syzkaller.appspotmail.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, hayeswang@realtek.com,
        io-uring@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 11, 2023 at 4:15=E2=80=AFPM syzbot
<syzbot+ad53b671c30ddaba634d@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 02767440e1dda9861a11ca1dbe0f19a760b1d5c2
> Author: Hayes Wang <hayeswang@realtek.com>
> Date:   Thu Jan 19 07:40:43 2023 +0000
>
>     r8152: reduce the control transfer of rtl8152_get_version()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D13284762c8=
0000
> start commit:   9b43a525db12 Merge tag 'nfs-for-6.2-2' of git://git.linux=
-..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dff5cf657dd0e7=
643
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dad53b671c30ddab=
a634d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D160480ba480=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D14cddc6a48000=
0
>
> If the result looks correct, please mark the issue as fixed by replying w=
ith:

The fix looks unrelated.

>
> #syz fix: r8152: reduce the control transfer of rtl8152_get_version()
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
