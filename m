Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31963531CE
	for <lists+io-uring@lfdr.de>; Sat,  3 Apr 2021 02:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbhDCAst (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 20:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbhDCAss (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 20:48:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DE2C0613E6;
        Fri,  2 Apr 2021 17:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=2AiZoOOg9U2o2PhOoWYhGv2mrRjtuXLXHJijj1zwDSk=; b=TP3oDJvYvIo2MuG4As9GHkUT+C
        acOiRa9SpigKzMABfzb1TfR1bVwkFyfg9en0eIEkjMgXq0vxT32zyS0Fg1QeBHV+Nsva0i0mLHled
        1q1CVcnxFlwiZueL+wP9gC/tYsDGoApQpEmGFqsRb3eMS3Mf96tjJ+dHT7hmkUf+jMM+uyXfieHiK
        0a42B1CVDyL9iN7xkvGCNXKoBo/zwAkU44JogWLkKABYpgwyWXSe2UvvuQc/BfKYQdAURBCCmUkbM
        DLoYVWtNe6PFpdZlqsRfQkaWe3l8cMfMsXUJkOdYen9dKf6XOTMN0uUWvbWI5AtDZP5UllPfnnwI+
        ncxbt3ZAF2H+7UaJmTqCu07kXwopFx8NL82Hn/CF+HB6jY56jqH2fwDNbwZ+sMN9ZRFGVMBw+mRmg
        s0wY+e5gkeKt9dX8j5VbtHxAENnJtJL+AlH1yWGTVECH+NEX+1tG5wuWScUTHCdMDNWMZi8NLt+pg
        /OWHIN3qo7CGKU3agTZnCa+9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lSUSq-0003sK-6E; Sat, 03 Apr 2021 00:48:36 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <358c5225-c23f-de08-65cb-ca3349793c0e@samba.org>
 <5bb47c3a-2990-e4c4-69c6-1b5d1749a241@samba.org>
 <CAHk-=whEObPkZBe4766DmR46-=5QTUiatWbSOaD468eTgYc1tg@mail.gmail.com>
 <2d8a73ef-2f18-6872-bad1-a34deb20f641@samba.org>
 <CAHk-=wh-VE=4puZ+r-Mo0GcAUou3aKrvnNsU3JxjnMXNcJOoug@mail.gmail.com>
Subject: Re: [PATCH 0/6] Allow signals for IO threads
Message-ID: <0375b37f-2e1e-7999-53b8-c567422aa181@samba.org>
Date:   Sat, 3 Apr 2021 02:48:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wh-VE=4puZ+r-Mo0GcAUou3aKrvnNsU3JxjnMXNcJOoug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 01.04.21 um 18:24 schrieb Linus Torvalds:
> On Thu, Apr 1, 2021 at 9:00 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> I haven't tried it, but it seems gdb tries to use PTRACE_PEEKUSR
>> against the last thread tid listed under /proc/<pid>/tasks/ in order to
>> get the architecture for the userspace application
> 
> Christ, what an odd hack. Why wouldn't it just do it on the initial
> thread you actually attached to?
> 
> Are you sure it's not simply because your test-case was to attach to
> the io_uring thread? Because the io_uring thread might as well be
> considered to be 64-bit.

      │   └─io_uring-cp,1396 Makefile file
      │       ├─{iou-mgr-1396},1397
      │       ├─{iou-wrk-1396},1398
      │       └─{iou-wrk-1396},1399

strace -ttT -o strace-uring-fail.txt gdb --pid 1396
(note strace -f would deadlock gdb with SIGSTOP)

The full file can be found here:
https://www.samba.org/~metze/strace-uring-fail.txt
(I guess there was a race and the workers 1398 and 1399 exited in between,
that's it using 1397):

18:46:35.429498 ptrace(PTRACE_PEEKUSER, 1397, 8*CS, [NULL]) = 0 <0.000022>

>> so my naive assumption
>> would be that it wouldn't allow the detection of a 32-bit application
>> using a 64-bit kernel.
> 
> I'm not entirely convinced we want to care about a confused gdb
> implementation and somebody debugging a case that I don't believe
> happens in practice.
> 
> 32-bit user space is legacy. And legacy isn't io_uring. If somebody
> insists on doing odd things, they can live with the odd results.

Ok, I'd agree for 32-bit applications, but what about libraries?
E.g. distributions ship libraries like libsmbclient or nss modules
as 64-bit and 32-bit version, in order to support legacy applications
to run. Why shouldn't the 32-bit library builds not support io_uring?
(Note libsmbclient don't use io_uring yet, but I guess it will be in future).

Any ideas regarding similar problems for other architectures?

metze


