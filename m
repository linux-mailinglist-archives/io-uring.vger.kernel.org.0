Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212BB351C9C
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhDASS4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbhDASKo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:10:44 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC4AC0045E5;
        Thu,  1 Apr 2021 07:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=JAhe/kVm5RlUfIXG3d28OFe9fHKwCAi5mQmsyoLxPQk=; b=prNxZCHuW5yBFgVGyBtP7FZl4l
        /i+wo8cszkl1eQcXFS8t1iFq4e/yeYB0FlNrahfI0TurKnHnUchJL7hg9wfdtbG6FuepdJeXMM7D6
        P+wGzfeHC+x02J86iR2X3CZBW20tKeXm9iqnz03yHppaXw9M4b0B40DEBpKzih3T9t0/vhHUSyriJ
        J1Z3ldi794ZY0fVOq7Ng8XOHjDMt5HMO9stJ+lOVy45okLBR8wKNvfwYUThF79KJXONxnY+Vo3043
        8TZseI1m+LKS/aTRjoe2rb7XSBwNWoSlRGDY0ihz4ZmezR6TCc/zhytUWr5xllkNYYpfM4cLJY7lc
        qgFr6ikJu8UVp5biNZFOBrKk0AOIqjfFmaCNNJfaxyxWdBxl2u17aC4R+SNJZy0Fa+cj6XflOa9TD
        VcBuXp1MBLleFc5ECSAjGyDf9GYRo1vX2K1GOMY9/JhWv5LcwRQRiotrnkItYwD1mo+5T1a1Az12v
        nVd/7Zyy58F1QHU3RckVGznJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lRyUy-0007Kf-A6; Thu, 01 Apr 2021 14:40:40 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <CAHk-=wgUcVeaKhtBgJO3TfE69miJq-krtL8r_Wf_=LBTJw6WSg@mail.gmail.com>
 <ad21da2b-01ea-e77c-70b2-0401059e322b@kernel.dk>
 <f9bc0bac-2ad9-827e-7360-099e1e310df5@kernel.dk>
 <5563d244-52c0-dafb-5839-e84990340765@samba.org>
 <6a2c4fe3-a019-2744-2e17-34b6325967d7@kernel.dk>
 <04b006fd-f3fa-bd92-9ab6-4e2341315cc2@samba.org>
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
Message-ID: <a6a3961b-19a9-2476-effa-33bee33dd57b@samba.org>
Date:   Thu, 1 Apr 2021 16:40:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <04b006fd-f3fa-bd92-9ab6-4e2341315cc2@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

>> I know you brought this one up as part of your series, not sure I get
>> why you want it owned by root and read-only? cmdline and exe, yeah those
>> could be hidden, but is there really any point?
>>
>> Maybe I'm missing something here, if so, do clue me in!
> 
> I looked through /proc and I think it's mostly similar to
> the unshare() case, if userspace wants to do stupid things
> like changing "comm" of iothreads, it gets what was asked for.
> 
> But the "cmdline" hiding would be very useful.
> 
> While most tools use "comm", by default.
> 
> ps -eLf or 'iotop' use "cmdline".
> 
> Some processes use setproctitle to change "cmdline" in order
> to identify the process better, without the 15 chars comm restriction,
> that's why I very often press 'c' in 'top' to see the cmdline,
> in that case it would be very helpful to see '[iou-wrk-1234]'
> instead of the seeing the cmdline.
> 
> So I'd very much prefer if this could be applied:
> https://lore.kernel.org/io-uring/d4487f959c778d0b1d4c5738b75bcff17d21df5b.1616197787.git.metze@samba.org/T/#u
> 
> If you want I can add a comment and a more verbose commit message...

I noticed that 'iotop' actually appends ' [iou-wrk-1234]' to the cmdline value,
so that leaves us with 'ps -eLf' and 'top' (with 'c').

pstree -a -t -p is also fine:
      │   └─io_uring-cp,1315 /root/kernel/linux-image-5.12.0-rc2+-dbg_5.12.0-rc2+-5_amd64.deb file
      │       ├─{iou-mgr-1315},1316
      │       ├─{iou-wrk-1315},1317
      │       ├─{iou-wrk-1315},1318
      │       ├─{iou-wrk-1315},1319
      │       ├─{iou-wrk-1315},1320


In the spirit of "avoid special PF_IO_WORKER checks" I guess it's ok
to leave of as is...

metze
