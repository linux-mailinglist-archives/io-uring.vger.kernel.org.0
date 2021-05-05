Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A02373950
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 13:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbhEELaf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 07:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhEELae (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 07:30:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B920C061574;
        Wed,  5 May 2021 04:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=SXc+Hsk02nVLuBMjf10SnN35jJ/Of9q2mO0biuxzEXM=; b=Py4Q8R38dfO/of5EDDnb3oG64y
        Nt99NHAs5OUMzF/amHgpD4wB/QySYC8f1L1llPJHiQn2i7t4wAaN4yDLio2piRH67T4Hrrwt9cxBY
        xlS1u5zdikOx6SFRZmFnu44RP4798h6BrJ7PTyNTXdhkVd8IR+8m/R1LJAUx3RrVMiNe+FpPlt4mj
        XCb9/t8/Ama2cwhIRGokvUORG3y1z323zgvz3+XxqOah5tZg0McjGXsjvSSOltSMo+dkvOvEGQxj4
        clXSJezhbGoIV2AZrdxl6EinK66SNKYIgP0JI/oOZj5Bfpi+QaKQQ8Y6M3pXAOJlE1vYBh0sj/aUv
        22P/xJH0WidfXLdYFF0yR1f6RDQnnsVBlYDNRJQ2muJrp/KDHM+jZ1huJ9BcE2ousIQDeqiCpY2G+
        m4je02WKuihYjAWpgxcKmDSdjvmZ1U6x+byUSxl7cd9Mw+VYKbf6E/DQtLAEj/dJmMaifxvRmqahV
        alHXsgIIxzvcKbYD1Z8ujcPM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1leFif-00012n-UR; Wed, 05 May 2021 11:29:34 +0000
To:     Simon Marchi <simon.marchi@polymtl.ca>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-toolchains@vger.kernel.org
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net> <YJFptPyDtow//5LU@zn.tnic>
 <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Message-ID: <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
Date:   Wed, 5 May 2021 13:29:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 04.05.21 um 17:55 schrieb Simon Marchi:
> On 2021-05-04 11:35 a.m., Borislav Petkov wrote:
>> On Tue, May 04, 2021 at 10:39:23AM +0200, Peter Zijlstra wrote:
>>> Anybody on toolchains that can help get GDB fixed?
>>
>> In the meantime, Tom is looking at fixing this, in case people wanna try
>> gdb patches or give him a test case or so...
>>
>> https://sourceware.org/bugzilla/show_bug.cgi?id=27822
> 
> Yes, please provide reproducing steps in that bug.  Unlike what was said
> in this thread, some people do work on gdb and are willing to fix
> things, but they can only do so if they know about the problem.

See https://lore.kernel.org/io-uring/0375b37f-2e1e-7999-53b8-c567422aa181@samba.org/
and https://lore.kernel.org/io-uring/20210411152705.2448053-1-metze@samba.org/T/#m461f280e8c3d32a49bc7da7bb5e214e90d97cf65

The question is why does inferior_ptid doesn't represent the thread
that was specified by 'gdb --pid PIDVAL'

https://www.samba.org/~metze/strace-uring-fail.txt
used "gdb --pid 1396" and does the following ptrace calls:

# grep ptrace strace-uring-fail.txt

> 18:46:35.319925 ptrace(PTRACE_ATTACH, 1396) = 0 <0.000048>
> 18:46:35.321622 ptrace(PTRACE_ATTACH, 1397) = 0 <0.000059>
> 18:46:35.322813 ptrace(PTRACE_ATTACH, 1398) = 0 <0.003052>
> 18:46:35.327287 ptrace(PTRACE_ATTACH, 1399) = 0 <0.000028>
> 18:46:35.334920 ptrace(PTRACE_GETREGS, 1396, NULL, 0x7ffed6173ea0) = 0 <0.000067>
> 18:46:35.341506 ptrace(PTRACE_SETOPTIONS, 1410, NULL, PTRACE_O_TRACESYSGOOD) = 0 <0.000056>
> 18:46:35.341681 ptrace(PTRACE_SETOPTIONS, 1410, NULL, PTRACE_O_TRACEFORK) = 0 <0.000051>
> 18:46:35.341816 ptrace(PTRACE_SETOPTIONS, 1410, NULL, PTRACE_O_TRACEFORK|PTRACE_O_TRACEVFORKDONE) = 0 <0.000054>
> 18:46:35.341957 ptrace(PTRACE_CONT, 1410, NULL, 0) = 0 <0.000056>
> 18:46:35.345568 ptrace(PTRACE_GETEVENTMSG, 1410, NULL, [1411]) = 0 <0.000081>
> 18:46:35.350541 ptrace(PTRACE_SETOPTIONS, 1410, NULL, PTRACE_O_EXITKILL) = 0 <0.000019>
> 18:46:35.354010 ptrace(PTRACE_SETOPTIONS, 1397, NULL, PTRACE_O_TRACESYSGOOD|PTRACE_O_TRACEFORK|PTRACE_O_TRACEVFORK|PTRACE_O_TRACECLONE|PTRACE_O_TRACEEXEC|PTRACE_O_TRACEVFORKDONE) = 0 <0.000019>
> 18:46:35.415730 ptrace(PTRACE_SETOPTIONS, 1396, NULL, PTRACE_O_TRACESYSGOOD|PTRACE_O_TRACEFORK|PTRACE_O_TRACEVFORK|PTRACE_O_TRACECLONE|PTRACE_O_TRACEEXEC|PTRACE_O_TRACEVFORKDONE) = 0 <0.000076>
> 18:46:35.421076 ptrace(PTRACE_GETREGS, 1412, NULL, 0x7ffed6174980) = 0 <0.000088>
> 18:46:35.429498 ptrace(PTRACE_PEEKUSER, 1397, 8*CS, [NULL]) = 0 <0.000022>
> 18:46:35.429632 ptrace(PTRACE_PEEKUSER, 1397, 8*SS + 24, [NULL]) = 0 <0.000019>
> 18:46:35.429732 ptrace(PTRACE_GETREGSET, 1397, NT_X86_XSTATE, [{iov_base=0x7ffed6174780, iov_len=576}]) = 0 <0.000030>
> 18:46:35.435507 ptrace(PTRACE_GETREGS, 1397, NULL, 0x7ffed6173cb0) = 0 <0.000019>
> 18:46:35.445877 ptrace(PTRACE_PEEKTEXT, 1397, 0x56357e99de00, [0x7f49d572b160]) = 0 <0.000057>
> 18:46:35.446043 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572b168, [0x7f49d572b190]) = 0 <0.000049>
> 18:46:35.447192 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572bbf0, [0x64762d78756e696c]) = 0 <0.000060>
> 18:46:35.447368 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572bbf0, [0x64762d78756e696c]) = 0 <0.000075>
> 18:46:35.447571 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572bbf8, [0x312e6f732e6f73]) = 0 <0.000070>
> 18:46:35.447762 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572bbf8, [0x312e6f732e6f73]) = 0 <0.000067>
> 18:46:35.448658 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572be10, [0x3638782f62696c2f]) = 0 <0.000076>
> 18:46:35.448917 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572be10, [0x3638782f62696c2f]) = 0 <0.000050>
> 18:46:35.449051 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572be18, [0x756e696c2d34365f]) = 0 <0.000045>
> 18:46:35.449173 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572be18, [0x756e696c2d34365f]) = 0 <0.000043>
> 18:46:35.449292 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572be20, [0x696c2f756e672d78]) = 0 <0.000042>
> 18:46:35.449414 ptrace(PTRACE_PEEKTEXT, 1397, 0x7f49d572be20, [0x696c2f756e672d78]) = 0 <0.000048>

ptrace(PTRACE_GETREGS, 1396, ... looks expected to me, but
starting with ptrace(PTRACE_PEEKUSER, 1397, 8*CS, [NULL]) (which triggers the actual problem)
it's unexpected to me why 1397 is used instead of 1396.

1397 is the iou-mgr-1396 iothread.

I hope that helps!
metze
