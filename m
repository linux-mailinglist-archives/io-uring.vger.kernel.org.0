Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117D7390BC9
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 23:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEYVu2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 17:50:28 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:55776 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhEYVu2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 17:50:28 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:52988 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1llev2-0003aX-85; Tue, 25 May 2021 17:48:56 -0400
Message-ID: <6133244fb6181420b27694abdfe3f42d43df8868.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 25 May 2021 17:48:55 -0400
In-Reply-To: <af1a868ed91466312786f11913cf06118139838e.camel@trillion01.com>
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
         <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
         <2236ed83-81fd-cd87-8bdb-d3173060cc7c@gmail.com>
         <af1a868ed91466312786f11913cf06118139838e.camel@trillion01.com>
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

On Tue, 2021-05-25 at 17:26 -0400, Olivier Langlois wrote:
> but the pointers should be hashed by trace.
> 
> That would be nice if someone more knowledgeable about the tracing
> system could jump in and comment about the hash-ptr option and tell
> when it is applied and when it is not...

My concern about hashing pointers directly in the io_uring code
directly. It is that by doing so will make it impossible for a
sufficiently priviledged user to get the raw pointer values without
reverting back the pointer hashing stuff.

that would not be the right way to address the security concern if the
tracing subsystem already hash them by default and is configurable to
display raw pointers if desired.

My issue is that I haven't been able to see hashed pointers output from
trace.

The only way that I know to get the traces is with 'sudo perf' and I
have never seen hashed pointers with it.

but the code is there... If you grep 'TRACE_ITER_HASH_PTR' in
kernel/trace/trace.c

I just haven't spent days in studying the tracing code to figure out
how it all works...


