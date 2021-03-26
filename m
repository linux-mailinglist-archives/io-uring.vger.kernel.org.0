Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AF334A6AF
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 13:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhCZL7i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 07:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhCZL7Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 07:59:24 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8F4C0613AA;
        Fri, 26 Mar 2021 04:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=ODyi+x2q4gI/U6RBuQU+2I+ka8es7su5UqCF06laDvM=; b=p0OGW44s7Cb6zYKrF3zXXy8/z/
        upv45NZUhnq/eYaJA7WVEoUHTYp3CIe8HLiwg2JsOtrFguh0+jGF+A5ICjLuJE0AfDC2ef8ebW6aK
        4gurKUzXPAugL49LVmzKj6AugL+WimiP8S1CfqIIwzmFJhM3y9wwXaRshqXDTkUahy20y/9Fq6hFK
        TQeYGIyJbxffqbD0Vy0TZ9tJYYP44fzKPAwgSz2iOBJkOLJ/8YDOpvnxujCMJzMG0Oi1CUtb7SRlw
        147He/KObswPRRhzlreUfcX9cdanSrd/SQGHGbd8aT1TxP/YebxlxIFuK/DGIo2KoyRA0s/tSHRnD
        YUFUSx6L9i9hdjxtZdNIRW7wgSV1RqTF13xG70nm1iheDrgEoKqLE/FVXgi5n2U/SGyjDnJHGpiNi
        9M5o1VO+Ovez2XUJNoSKV7wTviQK+/fysBvcen2IVCUOX7jsJOgAOzqV5L+6PS1YmxEYg82AWezIr
        YKoWitn2+4tffYEDDv6rtC3l;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPl7Y-0001uW-5S; Fri, 26 Mar 2021 11:59:20 +0000
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
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
Message-ID: <04b006fd-f3fa-bd92-9ab6-4e2341315cc2@samba.org>
Date:   Fri, 26 Mar 2021 12:59:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <6a2c4fe3-a019-2744-2e17-34b6325967d7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens,

>> And /proc/$iothread/ should be read only and owned by root with
>> "cmdline" and "exe" being empty.
> 
> I know you brought this one up as part of your series, not sure I get
> why you want it owned by root and read-only? cmdline and exe, yeah those
> could be hidden, but is there really any point?
> 
> Maybe I'm missing something here, if so, do clue me in!

I looked through /proc and I think it's mostly similar to
the unshare() case, if userspace wants to do stupid things
like changing "comm" of iothreads, it gets what was asked for.

But the "cmdline" hiding would be very useful.

While most tools use "comm", by default.

ps -eLf or 'iotop' use "cmdline".

Some processes use setproctitle to change "cmdline" in order
to identify the process better, without the 15 chars comm restriction,
that's why I very often press 'c' in 'top' to see the cmdline,
in that case it would be very helpful to see '[iou-wrk-1234]'
instead of the seeing the cmdline.

So I'd very much prefer if this could be applied:
https://lore.kernel.org/io-uring/d4487f959c778d0b1d4c5738b75bcff17d21df5b.1616197787.git.metze@samba.org/T/#u

If you want I can add a comment and a more verbose commit message...

metze
