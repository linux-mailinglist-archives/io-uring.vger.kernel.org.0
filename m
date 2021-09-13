Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0C9408813
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 11:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbhIMJXw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 05:23:52 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:38489 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238520AbhIMJXk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 05:23:40 -0400
Received: by mail-io1-f71.google.com with SMTP id n8-20020a6b7708000000b005bd491bdb6aso13418437iom.5
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 02:22:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HFFQPLAJXYx4bvBZVVBupuysAIuBOZazsLsw7gSGXPM=;
        b=1D6T2ZQO3jFNuWU/LBGvgUFyn/UGeCjWm7Kz4tmEM+OV1nFbIa3qqtdC41Fv7+1S5q
         SWX7YjFbFBpab+lrxdXWm1YJ4OUSvw4x3IIBSdEga1dFAK9cVXzI3P7BUmbWkj31hvf4
         rPHSiRJmE8iCc0h64XI588+PD4uhAPGKu1L7RDEi3FyP01zi7VnQdfQy9G2T6ySTMv5S
         CiUfNCHn8j//h2xPhses9ZzwuLmjfRn1HxyF/4q1TPpEZdfGtijyDHIk3vkfDJmIjzOk
         Nqv7hL6WPOy+C/LnSrWU+HPJbmx46xx8opl3fF/H781G1qcZA9cMbRlMY0ix5lDGy18W
         GcRw==
X-Gm-Message-State: AOAM533tn2cM6iVkb9hjteYnuz+vJ1k2kvY2aN2PgD1ewxQQQZgnHgSV
        oVJBly+t6TotOew77VpgEr0demThNDAXcXe2PILvuy+vCvv4
X-Google-Smtp-Source: ABdhPJz7iVHqBJwGMWVtkrGExpiG1/xH+YHaKqOpWGtfsh6vf6jjB1BWXgH366JewGOkGwNFwNOdUNMP/62JNgA5QSGR5CPvzAXQ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1564:: with SMTP id k4mr7564234ilu.146.1631524938755;
 Mon, 13 Sep 2021 02:22:18 -0700 (PDT)
Date:   Mon, 13 Sep 2021 02:22:18 -0700
In-Reply-To: <0000000000006e9e0705bd91f762@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ab57905cbdd002c@google.com>
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
From:   syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, coreteam@netfilter.org,
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

syzbot suspects this issue was fixed by commit:

commit 43016d02cf6e46edfc4696452251d34bba0c0435
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 3 11:51:15 2021 +0000

    netfilter: arptables: use pernet ops struct during unregister

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10acd273300000
start commit:   c98ff1d013d2 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c70e618af4c2e92
dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145cb2b6d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157b72b1d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: arptables: use pernet ops struct during unregister

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
