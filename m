Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB1642454E
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 19:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhJFR4D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 13:56:03 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:47767 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJFR4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 13:56:03 -0400
Received: by mail-io1-f70.google.com with SMTP id x24-20020a6b6a18000000b005db732f9449so2750081iog.14
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 10:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=V+I890c20q7qNEdOd1hUGCnKcSpI6F+6PfMtuEIOa7E=;
        b=MVrogCzfbzy78Q7sxXXTTlc87ulaxnwmbb+naCWt+abSLpGOcExxzP/slSWTU3nqDA
         f01IFSztS53OcFOu0dLNVgXsKoyVQqslHR7KBlFNijczMwTYfaypofv0icCxlgFqZGI2
         EjsTF1v4dAE/nRfJvd5m/Uam+CnPUmQ+OWC//yQl9dKFAh46/ryeFnX1Aku3iOu7LlE/
         3lIpyqmEDtmdfB8Bc01xuwhhjknUSmkFeFNDCxk6eIpwXZ/buScIN7nzWI20M4GGe+yg
         2yA+jbUClqC6jBozJ28WomTPVlZr7cEJj4idomEfMjXiKgXnJ1jhV1fpC5qJotE1ZeNE
         tr/Q==
X-Gm-Message-State: AOAM530iPfPrW3Cr+62JFbbj9IeB7dzELgROTnV+8XPJtvPH4q63uNCF
        cdaLQMafdu7ZfR7DHJ6qTsGeGqHKhJxwPmmL0/qazkLQFjbQ
X-Google-Smtp-Source: ABdhPJwsyjZ6t7YeGUzi2E7eUx+7aaW1DzCy0NGrvQJYbyqWVCx9ftgACQozGvaotlyE8L8gj9MZAt+RjYMH/QNwTTn5gv04aF9b
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c05:: with SMTP id l5mr1984571ilh.7.1633542850801;
 Wed, 06 Oct 2021 10:54:10 -0700 (PDT)
Date:   Wed, 06 Oct 2021 10:54:10 -0700
In-Reply-To: <0000000000006d354305cae2253f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000058faf705cdb2d5f6@google.com>
Subject: Re: [syzbot] general protection fault in __io_file_supports_nowait
From:   syzbot <syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit c6d3d9cbd659de8f2176b4e4721149c88ac096d4
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Tue Aug 31 13:13:10 2021 +0000

    io_uring: fix queueing half-created requests

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=174ee814b00000
start commit:   b91db6a0b52e Merge tag 'for-5.15/io_uring-vfs-2021-08-30' ..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=961d30359ac81f8c
dashboard link: https://syzkaller.appspot.com/bug?extid=e51249708aaa9b0e4d2c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a91625300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12512291300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring: fix queueing half-created requests

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
