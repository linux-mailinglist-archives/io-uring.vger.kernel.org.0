Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E54039124D
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 10:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhEZIaC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 04:30:02 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:45458 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbhEZIaC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 04:30:02 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:52994 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1llotx-00088p-SJ; Wed, 26 May 2021 04:28:29 -0400
Message-ID: <fc0e08faf765b50d5f0a38b026d5ed0dfd9d1090.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 04:28:28 -0400
In-Reply-To: <5fb15014-94ba-e0ca-fa13-f9e898824185@kernel.dk>
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
         <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
         <2236ed83-81fd-cd87-8bdb-d3173060cc7c@gmail.com>
         <af1a868ed91466312786f11913cf06118139838e.camel@trillion01.com>
         <6133244fb6181420b27694abdfe3f42d43df8868.camel@trillion01.com>
         <5fb15014-94ba-e0ca-fa13-f9e898824185@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2021-05-25 at 16:28 -0600, Jens Axboe wrote:
> > My issue is that I haven't been able to see hashed pointers output
> > from trace.
> 
> Just a quick guess, but does it rely on using %p to print the pointers?
> 
My very limited understanding of how the trace subsystem works is that
by default, it doesn't use the provided TK_printk macro at all.

the kernel trace subsystem does format internally the passed parameters
before sending the output to a ring buffer (yes another ring!).

You can override this method through the tracing option to use printk
instead and when you do, this is where the TK_printk() macro is used.

Before I did realize that, this was making me scratch my head as to
why, I was getting a different format output. ie:

  9287.369 test/625 io_uring:io_uring_task_run(ctx: 0xffff8fbf9a834800,
opcode: 22, user_data: 216454257090494477, result: 195)
  9287.386 test/625 io_uring:io_uring_task_run(ctx: 0xffff8fbf9a834800,
opcode: 22, user_data: 216454257090494477, result: 195)

while the TK_printk macro is:
        TP_printk("ring %p, req %p, op %d, data 0x%llx",
                  __entry->ctx, __entry->req, __entry->opcode,
                  (unsigned long long) __entry->user_data)

The TK_printk macro is naming the ctx variable as 'ring', yet you still
get ctx in the trace output!

but the pointer hashing that it is supposed to do is a mystery to me...


