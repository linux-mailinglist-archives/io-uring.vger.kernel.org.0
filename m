Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F8E330CD0
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 12:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhCHL4L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 06:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhCHLzu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 06:55:50 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76C5C06174A;
        Mon,  8 Mar 2021 03:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=PwI8dCamfwkjdQ3kDaZK4hl0YYmdivFXf7HdXZhlyWM=; b=Fp/6VqOGk2wX9c6w0UOwhCFA5H
        XoU1gzuR9MX/WrYWu1pJGu2mdsxZgD+T8kSTZ5naKbe61YBSDBS7+4EA/dOTA5C1OespH8WLBZ2zB
        IvrjzEvFicyLlHhk9Y3oDp/xBF0PhXaOJoXBW3i+3y3JH8fRgKRJC3r4NH+pTj1LiJf2ykHxqKW0f
        8eb+S9/1iV42AVBXKugJ57NAWrM64oQiLyNVLh/znrLBKaak14MkAuc29Gna9U2dTmCgPXGB2lRvq
        ko+aFV8+TOsqiWBAcBPGGPlABjTS92SXE1p34PoOZXmiIC1Z6CSlWnCVqIazkV1GpR/2DKLmC0n86
        cOYZzVtYpu55jRCQUEfRBrmesEQzpNbNpXX17wA7FRAT6X4553yiE/QE3ebN3893lxqtVYNTW4Jlq
        TvxBd1a2BdKEZILkyVyfVsuRs0EhJgdZZMixtl8bv88ftuik3tbsoZv5YtxOmUs1fG+8P/sfg6+Le
        LPEbapWkkCpjV3SBW93TpIYD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lJEUF-0000eQ-TD; Mon, 08 Mar 2021 11:55:47 +0000
To:     David Laight <David.Laight@ACULAB.COM>,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     "kernel@collabora.com" <kernel@collabora.com>,
        "krisman@collabora.com" <krisman@collabora.com>,
        "pgriffais@valvesoftware.com" <pgriffais@valvesoftware.com>,
        "z.figura12@gmail.com" <z.figura12@gmail.com>,
        "joel@joelfernandes.org" <joel@joelfernandes.org>,
        "malteskarupke@fastmail.fm" <malteskarupke@fastmail.fm>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "fweimer@redhat.com" <fweimer@redhat.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        io-uring <io-uring@vger.kernel.org>
References: <20210304004219.134051-1-andrealmeid@collabora.com>
 <ecbed98e-882a-0c0e-d4e1-bd33960f3674@samba.org>
 <f594f043f5c7440d8e3534e9a14c97c4@AcuMS.aculab.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC PATCH v2 00/13] Add futex2 syscall
Message-ID: <2f3e8fd5-acc9-1617-f161-7357d3e15307@samba.org>
Date:   Mon, 8 Mar 2021 12:55:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f594f043f5c7440d8e3534e9a14c97c4@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 08.03.21 um 12:11 schrieb David Laight:
> From: Stefan Metzmacher
>> Sent: 07 March 2021 11:35
>>
>> Hi André,
>>>  ** The wait on multiple problem
>>>
>>>  The use case lies in the Wine implementation of the Windows NT interface
>>>  WaitMultipleObjects. This Windows API function allows a thread to sleep
>>>  waiting on the first of a set of event sources (mutexes, timers, signal,
>>>  console input, etc) to signal.
> 
> They are all events.
> You can only wait on either events or sockets (using select).
> There is a socket api to signal an event when data arrives (etc).
> There is also the insane (these days) restriction of 64 events.

Ok.

>> With that in mind would it be good to have some interaction with epoll (and similar calls)?
> 
> Or hook something up so that pollwakeup can kick a futex as well
> as waking up poll() and adding an event to epoll().

I guess as FUTEX_FD was already there and was removed we can stop this discussion.

If there will every be the need to an async call, I guess a io_uring based one would
be the best...

metze

