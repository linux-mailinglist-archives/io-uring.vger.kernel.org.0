Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFADA391CD5
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 18:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhEZQUM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 12:20:12 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:48026 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhEZQUL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 12:20:11 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:53000 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1llwEw-0002vq-SZ; Wed, 26 May 2021 12:18:38 -0400
Message-ID: <9505850ae4c203f6b8f056265eddbffaae501806.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
From:   Olivier Langlois <olivier@trillion01.com>
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 12:18:37 -0400
In-Reply-To: <9a8abcc9-8f7a-8350-cf34-f86e4ac13f5c@samba.org>
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
         <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
         <9a8abcc9-8f7a-8350-cf34-f86e4ac13f5c@samba.org>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

On Wed, 2021-05-26 at 14:38 +0200, Stefan Metzmacher wrote:
> Hi,
> 
> > > @@ -333,13 +333,14 @@ TRACE_EVENT(io_uring_complete,
> > >   */
> > >  TRACE_EVENT(io_uring_submit_sqe,
> > >  
> > > -       TP_PROTO(void *ctx, u8 opcode, u64 user_data, bool
> > > force_nonblock,
> > > -                bool sq_thread),
> > > +       TP_PROTO(void *ctx, void *req, u8 opcode, u64 user_data,
> > > +                bool force_nonblock, bool sq_thread),
> > >  
> > > -       TP_ARGS(ctx, opcode, user_data, force_nonblock,
> > > sq_thread),
> > > +       TP_ARGS(ctx, req, opcode, user_data, force_nonblock,
> > > sq_thread),
> > >  
> > >         TP_STRUCT__entry (
> > >                 __field(  void *,       ctx             )
> > > +               __field(  void *,       req             )
> > >                 __field(  u8,           opcode          )
> > >                 __field(  u64,          user_data       )
> > >                 __field(  bool,         force_nonblock  )
> > > @@ -348,26 +349,42 @@ TRACE_EVENT(io_uring_submit_sqe,
> > >  
> > >         TP_fast_assign(
> > >                 __entry->ctx            = ctx;
> > > +               __entry->req            = req;
> > >                 __entry->opcode         = opcode;
> > >                 __entry->user_data      = user_data;
> > >                 __entry->force_nonblock = force_nonblock;
> > >                 __entry->sq_thread      = sq_thread;
> > >         ),
> > >  
> > > -       TP_printk("ring %p, op %d, data 0x%llx, non block %d,
> > > sq_thread %d",
> > > -                         __entry->ctx, __entry->opcode,
> > > -                         (unsigned long long) __entry-
> > > >user_data,
> > > -                         __entry->force_nonblock, __entry-
> > > >sq_thread)
> > > +       TP_printk("ring %p, req %p, op %d, data 0x%llx, non block
> > > %d, "
> > > +                 "sq_thread %d",  __entry->ctx, __entry->req,
> > > +                 __entry->opcode, (unsigned long long)__entry-
> > > >user_data,
> > > +                 __entry->force_nonblock, __entry->sq_thread)
> > >  );
> 
> If that gets changed, could be also include the personality id and
> flags here,
> and maybe also translated the opcode and flags to human readable
> strings?
> 
If Jens and Pavel agrees that they would like to see this info in the
traces, I have no objection adding it.

Still waiting input from Steven Rostedt which I believe is the trace
system maintainer concerning the hash-ptr situation.

I did receive an auto-respond from him saying that he was in vacation
until May 28th...

Greetings,


