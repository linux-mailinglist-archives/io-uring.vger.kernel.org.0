Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FBF372D0D
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 17:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhEDPgQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 11:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhEDPgQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 May 2021 11:36:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB1DC061574;
        Tue,  4 May 2021 08:35:21 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c8400351ab2c4e1964d4a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:8400:351a:b2c4:e196:4d4a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 519341EC050F;
        Tue,  4 May 2021 17:35:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620142518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9YS8rpRnHR92Rd5/l+wwPCakLldpm8xdN3Lf3MsyQh8=;
        b=NHbqzZHE9oHZ2K47IzFD2XP14aByJ1lvs5bM7HgyFKtKbiwF1K79ObjEsABzG4WJrebBfz
        EP92t1w0sl6vKwjOyFHBQpVp+FWSYh9BRi/PGWLg9s/A7TB8qsgpwb4eTBwOPtuKCLmA31
        Dz9/uaTfrC7Ad3jrnULYWcHldJ7cUnQ=
Date:   Tue, 4 May 2021 17:35:16 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-toolchains@vger.kernel.org
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Message-ID: <YJFptPyDtow//5LU@zn.tnic>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 04, 2021 at 10:39:23AM +0200, Peter Zijlstra wrote:
> Anybody on toolchains that can help get GDB fixed?

In the meantime, Tom is looking at fixing this, in case people wanna try
gdb patches or give him a test case or so...

https://sourceware.org/bugzilla/show_bug.cgi?id=27822

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
