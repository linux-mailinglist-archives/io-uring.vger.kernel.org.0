Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6EA3948C4
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 00:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhE1Wo1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 May 2021 18:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhE1Wo0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 28 May 2021 18:44:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D3561378;
        Fri, 28 May 2021 22:42:50 +0000 (UTC)
Date:   Fri, 28 May 2021 18:42:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@redhat.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
Message-ID: <20210528184248.46926090@gandalf.local.home>
In-Reply-To: <9505850ae4c203f6b8f056265eddbffaae501806.camel@trillion01.com>
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
        <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
        <9a8abcc9-8f7a-8350-cf34-f86e4ac13f5c@samba.org>
        <9505850ae4c203f6b8f056265eddbffaae501806.camel@trillion01.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 26 May 2021 12:18:37 -0400
Olivier Langlois <olivier@trillion01.com> wrote:

> > If that gets changed, could be also include the personality id and
> > flags here,
> > and maybe also translated the opcode and flags to human readable
> > strings?
> >   
> If Jens and Pavel agrees that they would like to see this info in the
> traces, I have no objection adding it.
> 
> Still waiting input from Steven Rostedt which I believe is the trace
> system maintainer concerning the hash-ptr situation.
> 
> I did receive an auto-respond from him saying that he was in vacation
> until May 28th...

Yep, I'm back now.

Here's how it works using your patch as an example:

>  	TP_fast_assign(
>  		__entry->ctx		= ctx;
> +		__entry->req		= req;

The "__entry" is a structure defined by TP_STRUCT__entry() that is located
on the ring buffer that can be read directly by user space (aka trace-cmd).
So yes, that value is never hashed, and one of the reasons that tracefs
requires root privilege to read it.

>  		__entry->opcode		= opcode;
>  		__entry->user_data	= user_data;
>  		__entry->force_nonblock	= force_nonblock;
>  		__entry->sq_thread	= sq_thread;
>  	),
>  
> -	TP_printk("ring %p, op %d, data 0x%llx, non block %d, sq_thread %d",
> -			  __entry->ctx, __entry->opcode,
> -			  (unsigned long long) __entry->user_data,
> -			  __entry->force_nonblock, __entry->sq_thread)
> +	TP_printk("ring %p, req %p, op %d, data 0x%llx, non block %d, "
> +		  "sq_thread %d",  __entry->ctx, __entry->req,
> +		  __entry->opcode, (unsigned long long)__entry->user_data,
> +		  __entry->force_nonblock, __entry->sq_thread)
>  );

The TP_printk() macro *is* used when reading the "trace" or "trace_pipe"
file, and that uses vsnprintf() to process it. Which will hash the values
for %p (by default, because that's what it always did when vsnprintf()
started hashing values).

Masami Hiramatsu added the hash-ptr option (which I told him to be the
default as that was the behavior before that option was created), where the
use could turn off the hashing.

There's lots of trace events that expose the raw pointers when hash-ptr is
off or if the ring buffers are read via the trace_pip_raw interface.

What's special about these pointers to hash them before they are recorded?

-- Steve
