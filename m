Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA11B393333
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 18:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbhE0QLW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 12:11:22 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:53278 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbhE0QLV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 12:11:21 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:58506 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lmIZv-0001O5-GO; Thu, 27 May 2021 12:09:47 -0400
Message-ID: <6b67bd40815f779059f7f3d3ad22f638789452b1.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: handle signals before letting io-worker exit
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 27 May 2021 12:09:46 -0400
In-Reply-To: <7e10ffd2-5948-3869-b0dc-fd81d693fe33@kernel.dk>
References: <60ae94d1.1c69fb81.94f7a.2a35SMTPIN_ADDED_MISSING@mx.google.com>
         <3d1bd9e2-b711-0aac-628e-89b95ff8dbc3@kernel.dk>
         <1e5c308bd25055ac8a899d40f00df08fc755e066.camel@trillion01.com>
         <7e10ffd2-5948-3869-b0dc-fd81d693fe33@kernel.dk>
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

On Thu, 2021-05-27 at 09:30 -0600, Jens Axboe wrote:
> > > 
> > Jens,
> > 
> > You are 100% correct. In fact, this is the same problem for ALL
> > currently existing and future io threads. Therefore, I start to
> > think
> > that the right place for the fix might be straight into
> > do_exit()...
> 
> That is what I was getting at. To avoid poluting do_exit() with it, I
> think it'd be best to add an io_thread_exit() that simply does:
> 
> void io_thread_exit(void)
> {
>         if (signal_pending(current)) {
>                 struct ksignal ksig;
>                 get_signal(&ksig);
>         }
>         do_exit(0);
> }
> 
> and convert the do_exit() calls in io_uring/io-wq to io_thread_exit()
> instead.
> 
IMHO, that would be an acceptable compromise because it does fix my
problem. However, I am of the opinion that it wouldn't be poluting
do_exit() and would in fact be the right place to do it considering
that create_io_thread() is in kernel and theoritically, anyone can call
it to create an io_thread and would be susceptible to get bitten by the
exact same problem and would have to come up with a similar solution if
it is not addressed directly by the kernel.

Also, since I have submitted the patch, I have made the following
realization:

I got bitten by the problem because of a race condition between the io-
mgr thread and its io-wrks threads for processing their pending SIGKILL
and the proposed patch does correct my problem.

The issue would have most likely been buried by 5.13 io-mgr removal...

BUT, even the proposed patch isn't 100% perfect. AFAIK, it is still
possible, but very unlikely, to get a signal between calling
signal_pending() and do_exit().

It might be possible to implement the solution and be 100% correct all
the time by doing it inside do_exit()... I am currently eyeing
exit_signals() as a potential good site for the patch...


