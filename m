Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9348375BB7
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 21:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhEFTdU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 15:33:20 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:45184 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhEFTdU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 15:33:20 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:43478 helo=[192.168.1.177])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lejjR-0005mz-DQ; Thu, 06 May 2021 15:32:21 -0400
Message-ID: <22332a52476059b676f60deca1b6453271b3274c.camel@trillion01.com>
Subject: Re: IORING_OP_POLL_ADD/IORING_OP_POLL_REMOVE questions
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Date:   Thu, 06 May 2021 15:32:20 -0400
In-Reply-To: <2a4437a06ad910142d27d22d9e17a843dbd6d6fc.camel@trillion01.com>
References: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
         <db4d01cc-9f58-c04d-d1b6-1208f8fb7220@gmail.com>
         <0a12170604cfcbce61259661f579fe5640cc7ffb.camel@trillion01.com>
         <7fa90154d1fbe1969383261539b7fbee20caad43.camel@trillion01.com>
         <2a4437a06ad910142d27d22d9e17a843dbd6d6fc.camel@trillion01.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.4 
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

On Thu, 2021-05-06 at 11:46 -0400, Olivier Langlois wrote:
> On Thu, 2021-05-06 at 04:42 -0400, Olivier Langlois wrote:
> > On Wed, 2021-05-05 at 23:17 -0400, Olivier Langlois wrote:
> > > Note that the poll remove sqe and the following poll add sqe don't
> > > have
> > > exactly the same user_data.
> > > 
> > > I have this statement in between:
> > > /* increment generation counter to avoid handling old events */
> > >           ++anfds [fd].egen;
> > > 
> > > poll remove cancel the previous poll add having gen 1 in its user
> > > data.
> > > the next poll add has it user_data storing gen var set to 2:
> > > 
> > > 1 3 remove 85 1
> > > 1 3 add 85 2
> > > 
> > > 85 gen 1 res -125
> > > 85 gen 1 res 4
> > > 
> > Good news!
> > 
> > I have used the io_uring tracepoints and they confirm that io_uring
> > works as expected:
> > 
> > For the above printfs, I get the following perf traces:
> > 
> >  11940.259 Execution SVC/134675 io_uring:io_uring_submit_sqe(ctx:
> > 0xffff9d3c4368c000, opcode: 7, force_nonblock: 1)
> >  11940.270 Execution SVC/134675 io_uring:io_uring_complete(ctx:
> > 0xffff9d3c4368c000, user_data: 4294967382, res: -125)
> >  11940.272 Execution SVC/134675 io_uring:io_uring_complete(ctx:
> > 0xffff9d3c4368c000)
> >  11940.275 Execution SVC/134675 io_uring:io_uring_file_get(ctx:
> > 0xffff9d3c4368c000, fd: 86)
> >  11940.277 Execution SVC/134675 io_uring:io_uring_submit_sqe(ctx:
> > 0xffff9d3c4368c000, opcode: 6, user_data: 4294967382, force_nonblock:
> > 1)
> >  11940.279 Execution SVC/134675 io_uring:io_uring_complete(ctx:
> > 0xffff9d3c4368c000, user_data: 4294967382, res: 4)
> > 
> > So, it seems the compiler is playing games on me. It prints the
> > correct
> > gen 2 value but is passing 1 to io_uring_sqe_set_data()...
> > 
> > I'll try to turn optimization off to see if it helps.
> > 
> > thx a lot again for your exceptional work!
> > 
> > 
> The more I fool around trying to find the problem, the more I think
> that my problem is somewhere in the liburing (v2.0) code because of a
> possibly missing memory barrier.
> 
> The function that I do use to submit the sqes is
> io_uring_wait_cqe_timeout().
> 
> My problem did appear when I did replace libev original boilerplate
> code for liburing (v2.0) used for filling and submitting the sqes.
> 
> Do you remember when you pointed out that I wasn't setting the
> user_data field for my poll remove request in:
> 
> io_uring_prep_poll_remove(sqe,
> iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
> //          io_uring_sqe_set_data(sqe,
> iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
> 
> ?
> 
> The last call to remove the non-existant 'add 85 2' is replied by
> ENOENT by io_uring and this was caught by an assert in my case
> IOURING_POLL cqe handler.
> 
>   iouring_decode_user_data(cqe->user_data, &type, &fd, &gen);
> 
>   switch (type) {
> 
> This is impossible to end up there because if you do not explicitly set
> user_data, io_uring_prep_rw() is setting it to 0.
> 
> In order for my assert to be hit, user_data would have to be set with
> the commented out io_uring_sqe_set_data(), and it happens to also be
> the value of the previously sent sqe user_data...
> 
> I did replace the code above with:
> 
> io_uring_prep_poll_remove(sqe,
> iouring_build_user_data(IOURING_POLL_ADD, fd, anfds [fd].egen));
> io_uring_sqe_set_data(sqe, iouring_build_user_data(IOURING_POLL_REMOVE,
> fd, anfds [fd].egen));
> 
> and my assert for cqe->res != -ENOENT has stopped being hit.
> 
> There is clearly something messing with the sqe user_data communication
> between user and kernel and I start to suspect that this might be
> somewhere inside io_uring_wait_cqe_timeout()...
> 
> 
All is good. After looking under every possible rock, I have finally
found my problem and it has been under my nose during all that time. It
was right in the code that I did share in my original post:

inline_speed
void *
iouring_build_user_data(char type, int fd, uint32_t egen)
{
    return (void *)((uint32_t)fd | ((__u64)(egen && 0x00ffffff) << 32 )
|
                    ((__u64)type << 56));
}

It is the the usage of the boolean && operator instead of using the
bitwise one...

Hopefully, I didn't annoy too much the list members...

The whole saga did at least allow me to become much more knowledgeable
about the amazing io_uring API.

I'm looking forward contributing it sometime in a near future.

thx,
Olivier


