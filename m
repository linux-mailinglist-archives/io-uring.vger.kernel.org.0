Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806023A228C
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 05:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFJDF5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 23:05:57 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:13927 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhFJDFy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 23:05:54 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UbvWAhs_1623294226;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UbvWAhs_1623294226)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 11:03:47 +0800
Subject: Re: [syzbot] WARNING in io_wqe_enqueue
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <0000000000000bdfa905c3f6720f@google.com>
 <b9cb6dc4-3dfe-de60-a933-1f423301b3ca@linux.alibaba.com>
 <CACT4Y+az0ZsTRyj+FjA08ZjpoesoxSde+1vxn-WQnTgXM1rPGQ@mail.gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <b38c580a-2f74-39ee-706a-13eab4e16d1c@linux.alibaba.com>
Date:   Thu, 10 Jun 2021 11:03:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACT4Y+az0ZsTRyj+FjA08ZjpoesoxSde+1vxn-WQnTgXM1rPGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/6/8 下午8:01, Dmitry Vyukov 写道:
> On Tue, Jun 8, 2021 at 11:47 AM Hao Xu <haoxu@linux.alibaba.com> wrote:
>>
>> 在 2021/6/5 上午4:22, syzbot 写道:
>>> syzbot has bisected this issue to:
>>>
>>> commit 24369c2e3bb06d8c4e71fd6ceaf4f8a01ae79b7c
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Tue Jan 28 00:15:48 2020 +0000
>>>
>>>       io_uring: add io-wq workqueue sharing
>>>
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17934777d00000
>>> start commit:   f88cd3fb Merge tag 'vfio-v5.13-rc5' of git://github.com/aw..
>>> git tree:       upstream
>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=14534777d00000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=10534777d00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=82d85e75046e5e64
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=ea2f1484cffe5109dc10
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d5772fd00000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10525947d00000
>>>
>>> Reported-by: syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com
>>> Fixes: 24369c2e3bb0 ("io_uring: add io-wq workqueue sharing")
>>>
>>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>>>
>> This is not a bug, the repro program first set RLIMIT_NPROC to 0, then
>> submits an unbound work whcih raises a warning of
>> WARN_ON_ONCE(!acct->max_workers). Since unbound->max_workers is
>> task_rlimit(current, RLIMIT_NPROC), so it is expected.
> 
> Hi Hao,
> 
> Then this is a mis-use of WARN_ON. If this check is intended for end
> users, it needs to use pr_err (also print understandable message and
> no stack trace which is most likely not useful for end users):
> https://elixir.bootlin.com/linux/v5.13-rc5/source/include/asm-generic/bug.h#L71
>
  Agree, pr_err/pr_warn is better here.


