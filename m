Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34260390B67
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 23:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhEYV2U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 17:28:20 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:46670 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhEYV2T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 17:28:19 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:52984 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lleZc-0002Q1-Q5; Tue, 25 May 2021 17:26:48 -0400
Message-ID: <af1a868ed91466312786f11913cf06118139838e.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 25 May 2021 17:26:47 -0400
In-Reply-To: <2236ed83-81fd-cd87-8bdb-d3173060cc7c@gmail.com>
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
         <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
         <2236ed83-81fd-cd87-8bdb-d3173060cc7c@gmail.com>
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

Hi Pavel,

On Tue, 2021-05-25 at 09:33 +0100, Pavel Begunkov wrote:
> On 5/25/21 9:21 AM, Pavel Begunkov wrote:
> > On 5/25/21 6:54 AM, Olivier Langlois wrote:
> > > The req pointer uniquely identify a specific request.
> > > Having it in traces can provide valuable insights that is not
> > > possible
> > > to have if the calling process is reusing the same user_data value.
> > 
> > How about hashing kernel pointers per discussed? Even if it's better
> > to have it done by tracing or something as you mentioned, there is no
> > such a thing at the moment, so should be done by hand.
> 
> Or do you mean that it's already the case? Can anyone
> confirm if so?

I did consider your option but then I did some research on the pointer
hashing idea.

It turns out to be already addressed by the trace subsystem.

Here is what I have found:

whippet2 /sys/kernel/tracing # cat trace_options 
print-parent
nosym-offset
nosym-addr
noverbose
noraw
nohex
nobin
noblock
trace_printk
annotate
nouserstacktrace
nosym-userobj
noprintk-msg-only
context-info
nolatency-format
record-cmd
norecord-tgid
overwrite
nodisable_on_free
irq-info
markers
noevent-fork
nopause-on-trace
hash-ptr
function-trace
nofunction-fork
nodisplay-graph
nostacktrace
notest_nop_accept
notest_nop_refuse

hash-ptr option is enabled by default.

I am not 100% sure to understand why I am getting naked pointer values
when I am getting the traces with 'sudo perf':

  9287.369 test/625 io_uring:io_uring_task_run(ctx: 0xffff8fbf9a834800,
opcode: 22, user_data: 216454257090494477, result: 195)
  9287.386 test/625 io_uring:io_uring_task_run(ctx: 0xffff8fbf9a834800,
opcode: 22, user_data: 216454257090494477, result: 195)

but the pointers should be hashed by trace.

That would be nice if someone more knowledgeable about the tracing
system could jump in and comment about the hash-ptr option and tell
when it is applied and when it is not...


