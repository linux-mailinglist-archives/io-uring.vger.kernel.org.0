Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F5D2AE6CF
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 04:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgKKDJG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Nov 2020 22:09:06 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:41008 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgKKDJF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Nov 2020 22:09:05 -0500
Received: by mail-il1-f199.google.com with SMTP id h4so385354ilj.8
        for <io-uring@vger.kernel.org>; Tue, 10 Nov 2020 19:09:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wf9hL6Te9sp/yqa+Doc2BxzTapoLp41NMYlihKhsE5U=;
        b=C0Asr13HzB/QxHzxQYt/yYQZWpI+c8MPAloWhHqNQ7gd0CjROLtQDdxj+Jk+98hxhg
         pydWdqfQkDeiOzvQIDNvTHZ5LqIjvlTAYwg3qX/uo4+QFO44u0REGgViYEL8GyyoB5Ae
         Ul2scDxzCgEwoDl8rV994bLh71WPj9nG53LABfDaKuhKZxQ4XU/6VlYoSwjtAt7uNiHu
         Kjut62LTKeMdJsL2w3efdxRhOYbS8bPsNd43Q3aVtjhdUYI7nEwy31FsCLZyhc3Hnsp6
         v73krQFcEubfaRJxl0g0FlsLy/woqQsnFJJpaNJEYdWUtoHSW/mz74pKqp05TLe0InSl
         Baaw==
X-Gm-Message-State: AOAM530Zoo6RyVNypY6flj17YUOMqWc55LyVI3Gu9Fc5wrt09Lob3GQX
        bUG3cf1VpgoOQ+UHGy1P9FBlD4HTwh4+Ayp3eGnKr94DITR4
X-Google-Smtp-Source: ABdhPJw322s2MJlVk9+t74N1ScoBaJO4J3N8LABAJKKIIvfejPk/tSGh8Y8hRv9pCYKg3l9qjzobyF5QLxxkTWZVc72IPUvFMa5q
MIME-Version: 1.0
X-Received: by 2002:a92:ba14:: with SMTP id o20mr17040042ili.76.1605064145162;
 Tue, 10 Nov 2020 19:09:05 -0800 (PST)
Date:   Tue, 10 Nov 2020 19:09:05 -0800
In-Reply-To: <000000000000b09d8c059a3240be@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000036d7e005b3cc1e79@google.com>
Subject: Re: WARNING in percpu_ref_exit (2)
From:   syzbot <syzbot+8c4a14856e657b43487c@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, ebiggers@kernel.org, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit c1e2148f8ecb26863b899d402a823dab8e26efd1
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Mar 4 14:25:50 2020 +0000

    io_uring: free fixed_file_data after RCU grace period

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=161ea46e500000
start commit:   63849c8f Merge tag 'linux-kselftest-5.6-rc5' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=4527d1e2fb19fd5c
dashboard link: https://syzkaller.appspot.com/bug?extid=8c4a14856e657b43487c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c30061e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1251b731e00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring: free fixed_file_data after RCU grace period

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
