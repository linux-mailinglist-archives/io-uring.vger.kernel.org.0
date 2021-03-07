Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB433005C
	for <lists+io-uring@lfdr.de>; Sun,  7 Mar 2021 12:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhCGLe5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Mar 2021 06:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCGLer (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Mar 2021 06:34:47 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA79C06174A;
        Sun,  7 Mar 2021 03:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=ex6BOrd2HXnCZrTmgz0TFR9fOgFEggpFA2E0Mod1QZ8=; b=MCcC1vKHip2w+lnHBTpl9dfHd6
        Xj8OWzLknA3UT7wBhAQcU8BVsmApkl88UW5NB0ydbsHa6sf71zUefLQgYgh6JwiA5eC3AwSKvkgGm
        DFyfdjrB5vurxoFjBxgt3iultGMPoFZYca0uRlS5jwd9Th9RpavYKKWz4rWLC5Je9TtYvyJvM/7HJ
        Aw9EK9KCCaliI5c7hvswoJhYQ2pFbZq8ttOt0EdRAX5SVUJyJBKTUdy/3AJt1pYQwwWXPl9PSfu/8
        8TOoJsZPt8kQ3qiGRVjyJYxicy9DxIRYF6j8zP2XKVrXDbiUV0OHw4g/XMM2iGARhPBCzFFIyz6t9
        ooGj5SJC9k4Cs92JtxUrOm0OAgj8Hqf8ag2OLvLd//d/dAiDBGFYaMw+x8BTH4ZfZCUBBQl5EjsUh
        nrOr5H3/3c1elVj6bzBHFUNqxYIg1ZDpLwo4DUoZigUOe55XeRkxdyXxsWPVcnmBX9+YiI9MRpZ/m
        ZuloOvuM2svUzee9gNCTtyhb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lIrgH-0000YF-2Q; Sun, 07 Mar 2021 11:34:41 +0000
To:     =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kernel@collabora.com, krisman@collabora.com,
        pgriffais@valvesoftware.com, z.figura12@gmail.com,
        joel@joelfernandes.org, malteskarupke@fastmail.fm,
        linux-api@vger.kernel.org, fweimer@redhat.com,
        libc-alpha@sourceware.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org, acme@kernel.org, corbet@lwn.net,
        io-uring <io-uring@vger.kernel.org>
References: <20210304004219.134051-1-andrealmeid@collabora.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC PATCH v2 00/13] Add futex2 syscall
Message-ID: <ecbed98e-882a-0c0e-d4e1-bd33960f3674@samba.org>
Date:   Sun, 7 Mar 2021 12:34:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210304004219.134051-1-andrealmeid@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi André,
>  ** The wait on multiple problem
> 
>  The use case lies in the Wine implementation of the Windows NT interface
>  WaitMultipleObjects. This Windows API function allows a thread to sleep
>  waiting on the first of a set of event sources (mutexes, timers, signal,
>  console input, etc) to signal.  

With that in mind would it be good to have some interaction with epoll (and similar calls)?

Instead of having a blocked futex_waitv() waiting on an fd (maybe a generic eventfd() or a new futex2fd())
would be a better interface?

Or instead introduce an IORING_OP_FUTEX2_WAITV? Then the futex_waitv logic wait
in an io-wq kernel thread...

I guess the io_uring way would mean we could have that in mind as future addition, which can be implemented
later...

metze
