Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8542372D84
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 18:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhEDQEe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 12:04:34 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55800 "EHLO smtp.polymtl.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhEDQEd (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 4 May 2021 12:04:33 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 12:04:32 EDT
Received: from simark.ca (simark.ca [158.69.221.121])
        (authenticated bits=0)
        by smtp.polymtl.ca (8.14.7/8.14.7) with ESMTP id 144FtMdo022653
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 4 May 2021 11:55:28 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.polymtl.ca 144FtMdo022653
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=polymtl.ca;
        s=default; t=1620143731;
        bh=mb48+00zpPbvRbcsykAoM8HYST7h93Xm5FluF1gWiIs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jF4fg/WfD6s661HWEVr8b+CLh7y5FMJ0G2DAmYpbQQZoQmIq/ezQlwPgOX+ujiA9R
         krtvf/fB+y0k7rgagEFjoLou7TF67ynZAo1ZWZLblYtfQ9mFLxWOR84D8wRSEkAMQ0
         wpORgf2sSe6GgZgPWWaWT9rPO5hzAERyeunWojpw=
Received: from [10.0.0.11] (192-222-157-6.qc.cable.ebox.net [192.222.157.6])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by simark.ca (Postfix) with ESMTPSA id 82CBD1E54D;
        Tue,  4 May 2021 11:55:21 -0400 (EDT)
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-toolchains@vger.kernel.org
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net> <YJFptPyDtow//5LU@zn.tnic>
From:   Simon Marchi <simon.marchi@polymtl.ca>
Message-ID: <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca>
Date:   Tue, 4 May 2021 11:55:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YJFptPyDtow//5LU@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Poly-FromMTA: (simark.ca [158.69.221.121]) at Tue,  4 May 2021 15:55:22 +0000
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-05-04 11:35 a.m., Borislav Petkov wrote:
> On Tue, May 04, 2021 at 10:39:23AM +0200, Peter Zijlstra wrote:
>> Anybody on toolchains that can help get GDB fixed?
> 
> In the meantime, Tom is looking at fixing this, in case people wanna try
> gdb patches or give him a test case or so...
> 
> https://sourceware.org/bugzilla/show_bug.cgi?id=27822

Yes, please provide reproducing steps in that bug.  Unlike what was said
in this thread, some people do work on gdb and are willing to fix
things, but they can only do so if they know about the problem.

Simon
