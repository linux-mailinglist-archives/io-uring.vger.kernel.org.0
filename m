Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A08374BC4
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 01:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhEEXRS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 19:17:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46291 "EHLO smtp.polymtl.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhEEXRS (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 5 May 2021 19:17:18 -0400
Received: from simark.ca (simark.ca [158.69.221.121])
        (authenticated bits=0)
        by smtp.polymtl.ca (8.14.7/8.14.7) with ESMTP id 145NFuAZ013297
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 May 2021 19:16:00 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.polymtl.ca 145NFuAZ013297
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=polymtl.ca;
        s=default; t=1620256562;
        bh=pc45n/BWF7lDKLmoC8+fLn/BhW3jQ7nH+5jK1B5rYNU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nuaN8LfF7O+hFXk4ovvB4VaQ82brXcrghgJBxZS37ImCQHhHDcgtu+32xkIKehahe
         KXhPSRCLOFJI6zgAyheiCNuRZsrXWBqKkhkCN2UtF78u8AMOxLXSWRCrxrwq/bLWg2
         89raNRow77e5tbFdw6GsG8sjF9wc3T1/PwiYrxno=
Received: from [10.0.0.11] (192-222-157-6.qc.cable.ebox.net [192.222.157.6])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simark.ca (Postfix) with ESMTPSA id 631DE1E813;
        Wed,  5 May 2021 19:15:55 -0400 (EDT)
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
 <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca>
 <f15f0ccd-fe30-c3cf-9b01-df7ba462401f@samba.org>
From:   Simon Marchi <simon.marchi@polymtl.ca>
Message-ID: <0bd34171-1e94-fab6-b186-3ddd21bacc0e@polymtl.ca>
Date:   Wed, 5 May 2021 19:15:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f15f0ccd-fe30-c3cf-9b01-df7ba462401f@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Poly-FromMTA: (simark.ca [158.69.221.121]) at Wed,  5 May 2021 23:15:56 +0000
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Is it clear now?
> metze

Yes, thanks.  I had missed that the point of the 2nd patch is to not do
the memset for these threads.  Makes sense now.

Simon
