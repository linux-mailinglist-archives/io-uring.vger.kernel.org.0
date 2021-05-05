Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B1E374BBE
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 01:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhEEXNV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 19:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEEXNV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 19:13:21 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A87DC061574;
        Wed,  5 May 2021 16:12:24 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0b070001dc1f090e11b831.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:700:1dc:1f09:e11:b831])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 656801EC03E4;
        Thu,  6 May 2021 01:12:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620256342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=pHBZcgkU3g+GoQktUdRL0M8+l+YYMwtlXCzLYv6pKzQ=;
        b=bp20NVypmdQc4K4VZz9SQrgwc4/ZoJxqU4Te7/f5Mx3V+Q3EjfgeqhcvmHEz4R8hlYkWsV
        nG29Imxw9EY3vcLS/QIU1RmCd2zgX6ynJmpLQDhJVdxI2R/xTGtxibmblpNVG8vNZmncrZ
        MGcW9SXuqDEqSYCExz/96Xck5rIe6gQ=
Date:   Thu, 6 May 2021 01:12:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Simon Marchi <simon.marchi@polymtl.ca>,
        Stefan Metzmacher <metze@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-toolchains@vger.kernel.org
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Message-ID: <YJMmVHGn33W2n2Ux@zn.tnic>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net>
 <YJFptPyDtow//5LU@zn.tnic>
 <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca>
 <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
 <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca>
 <CALCETrUF5M+Qw+RfY8subR7nzmpMyFsE3NHSAPoMVWMz6_hr-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUF5M+Qw+RfY8subR7nzmpMyFsE3NHSAPoMVWMz6_hr-w@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 05, 2021 at 03:11:18PM -0700, Andy Lutomirski wrote:
> Since I'm not holding my breath, please at least keep in mind that
> anything you do here is merely a heuristic, cannot be fully correct,
> and then whenever gdb determines that a thread group or a thread is
> "32-bit", gdb is actually deciding to operate in a degraded mode for
> that task, is not accurately representing the task state, and is at
> risk of crashing, malfunctioning, or crashing the inferior due to its
> incorrect assumptions.  If you have ever attached gdb to QEMU's
> gdbserver and tried to debug the early boot process of a 64-bit Linux
> kernel, you may have encountered this class of bugs.  gdb works very,
> very poorly for this use case.

So we were talking about this with toolchain folks today and they gave
me this example:

Imagine you've stopped the target this way:

	<insn><-- stopped here
	<insn>
	<mode changing insn>
	<insn>
	<insn>
	...

now, if you dump rIP and say, rIP + the 10 following insns at the place
you've stopped it, gdb cannot know that 2 insns further into the stream
a

<mode changing insn>

is coming and it should change the disassembly of the insns after that
<mode changing insn> to the new mode. Unless it goes and inspects all
further instructions and disassembles them and analyzes the flow...

So what you can do is 

(gdb) set arch ...

at the <mode changing insn> to the mode you're changing to.

Dunno, maybe I'm missing something but this sounds like without user
help gdb can only assume things.

Good night and good luck.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
