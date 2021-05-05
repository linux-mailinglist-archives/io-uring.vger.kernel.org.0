Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB10374AEF
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 00:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhEEWBA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 18:01:00 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59209 "EHLO smtp.polymtl.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhEEWBA (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 5 May 2021 18:01:00 -0400
Received: from simark.ca (simark.ca [158.69.221.121])
        (authenticated bits=0)
        by smtp.polymtl.ca (8.14.7/8.14.7) with ESMTP id 145LxFNj005429
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 May 2021 17:59:21 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.polymtl.ca 145LxFNj005429
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=polymtl.ca;
        s=default; t=1620251964;
        bh=VtPK8w5u0Y3L04qcpOAxhksGyNXxkJ4yMUaaC/M14GI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qUnjxmDBeet1J5EMZ+jqGV2Ruc//cqsc3d+FjO4vULw/WtI7/ymOz5Db00Ll9yQ41
         rnhHlc4WCIVc+f0/COnp98GOoTojA4i73z76deRg1brtKUJeF4OkYsUdpE0D7RkhDY
         gP2ACkaYl4EcrotVGquSwG6DyPEJ8xKORgMxWb2Q=
Received: from [10.0.0.11] (192-222-157-6.qc.cable.ebox.net [192.222.157.6])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simark.ca (Postfix) with ESMTPSA id 49C7B1E813;
        Wed,  5 May 2021 17:59:13 -0400 (EDT)
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Stefan Metzmacher <metze@samba.org>,
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
 <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
From:   Simon Marchi <simon.marchi@polymtl.ca>
Message-ID: <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca>
Date:   Wed, 5 May 2021 17:59:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Poly-FromMTA: (simark.ca [158.69.221.121]) at Wed,  5 May 2021 21:59:15 +0000
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-05-05 7:29 a.m., Stefan Metzmacher wrote:
> See https://lore.kernel.org/io-uring/0375b37f-2e1e-7999-53b8-c567422aa181@samba.org/
> and https://lore.kernel.org/io-uring/20210411152705.2448053-1-metze@samba.org/T/#m461f280e8c3d32a49bc7da7bb5e214e90d97cf65
> 
> The question is why does inferior_ptid doesn't represent the thread
> that was specified by 'gdb --pid PIDVAL'

Hi Stefan,

When you attach to PIDVAL (assuming that PIDVAL is a thread-group
leader), GDB attaches to all the threads of that thread group.  The
inferior_ptid global variable is "the thread we are currently working
with", and changes whenever GDB wants to deal with a different thread.

After attaching to all threads, GDB wants to know more about that
process' architecture (that read_description call mentioned in [1]).
The way this is implemented varies from arch to arch, but as you found
out, for x86-64 it consists of peeking into a thread's CS/DS to
determine whether the process is x86-64, x32 or i386.  The thread used
for this - the inferior_ptid value - just happens to be the latest
thread we switched inferior_ptid to (presumably because we iterated on
the thread list to do something and that was the last thread in the
list).  And up to now, this was working under the assumption that
picking any thread of the process would yield the same values for that
purpose.  I don't think it was intentionally done this way, but it
worked and didn't cause any trouble until now.

With io threads, that assumption doesn't hold anymore.  From what I
understand, your v1 patch made it so that the kernel puts the CS/DS
values GDB expects in the io threads (even though they are never
actually used otherwise).  I don't understand how your v2 patch
addresses the problem though.

I don't think it would be a problem on the GDB-side to make sure to
fetch these values from a "standard" thread.  Most likely the thread
group leader, like Tom has proposed in [1].

Thanks,

Simon

[1] https://sourceware.org/bugzilla/show_bug.cgi?id=27822#c0
