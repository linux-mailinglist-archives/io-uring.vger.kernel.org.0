Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C7439F2C5
	for <lists+io-uring@lfdr.de>; Tue,  8 Jun 2021 11:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhFHJtX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Jun 2021 05:49:23 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:57977 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229536AbhFHJtX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Jun 2021 05:49:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Ubkgp-5_1623145644;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ubkgp-5_1623145644)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Jun 2021 17:47:25 +0800
Subject: Re: [syzbot] WARNING in io_wqe_enqueue
To:     syzbot <syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <0000000000000bdfa905c3f6720f@google.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <b9cb6dc4-3dfe-de60-a933-1f423301b3ca@linux.alibaba.com>
Date:   Tue, 8 Jun 2021 17:47:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0000000000000bdfa905c3f6720f@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/6/5 上午4:22, syzbot 写道:
> syzbot has bisected this issue to:
> 
> commit 24369c2e3bb06d8c4e71fd6ceaf4f8a01ae79b7c
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Tue Jan 28 00:15:48 2020 +0000
> 
>      io_uring: add io-wq workqueue sharing
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17934777d00000
> start commit:   f88cd3fb Merge tag 'vfio-v5.13-rc5' of git://github.com/aw..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=14534777d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10534777d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=82d85e75046e5e64
> dashboard link: https://syzkaller.appspot.com/bug?extid=ea2f1484cffe5109dc10
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d5772fd00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10525947d00000
> 
> Reported-by: syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com
> Fixes: 24369c2e3bb0 ("io_uring: add io-wq workqueue sharing")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
This is not a bug, the repro program first set RLIMIT_NPROC to 0, then 
submits an unbound work whcih raises a warning of
WARN_ON_ONCE(!acct->max_workers). Since unbound->max_workers is
task_rlimit(current, RLIMIT_NPROC), so it is expected.
