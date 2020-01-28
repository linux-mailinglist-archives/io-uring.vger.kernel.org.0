Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABC114C231
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 22:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgA1V1n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 16:27:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38246 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgA1V1n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 16:27:43 -0500
Received: from ip5f5bd665.dynamic.kabel-deutschland.de ([95.91.214.101] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iwYMY-0002dt-4j; Tue, 28 Jan 2020 21:25:34 +0000
Date:   Tue, 28 Jan 2020 22:25:33 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Message-ID: <20200128212533.snjm34gct3kmfxfi@wittgenstein>
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>
 <60253bd9-93a7-4d76-93b6-586e4f55138c@gmail.com>
 <43a57f2a-16da-e657-3dca-5aa3afe31318@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <43a57f2a-16da-e657-3dca-5aa3afe31318@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jan 28, 2020 at 01:56:00PM -0700, Jens Axboe wrote:
> On 1/28/20 1:50 PM, Pavel Begunkov wrote:
> > On 28/01/2020 23:19, Jens Axboe wrote:
> >> On 1/28/20 1:16 PM, Pavel Begunkov wrote:
> >>> On 28/01/2020 22:42, Jens Axboe wrote:
> >>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
> >>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
> >>>>>> On 1/28/20 9:19 AM, Jens Axboe wrote:
> >>>>>>> On 1/28/20 9:17 AM, Stefan Metzmacher wrote:
> >>>>>> OK, so here are two patches for testing:
> >>>>>>
> >>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
> >>>>>>
> >>>>>> #1 adds support for registering the personality of the invoking task,
> >>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
> >>>>>> just having one link, it doesn't support a chain of them.
> >>>>>>
> >>>>>> I'll try and write a test case for this just to see if it actually works,
> >>>>>> so far it's totally untested. 
> >>>>>>
> >>>>>> Adding Pavel to the CC.
> >>>>>
> >>>>> Minor tweak to ensuring we do the right thing for async offload as well,
> >>>>> and it tests fine for me. Test case is:
> >>>>>
> >>>>> - Run as root
> >>>>> - Register personality for root
> >>>>> - create root only file
> >>>>> - check we can IORING_OP_OPENAT the file
> >>>>> - switch to user id test
> >>>>> - check we cannot IORING_OP_OPENAT the file
> >>>>> - check that we can open the file with IORING_OP_USE_CREDS linked
> >>>>
> >>>> I didn't like it becoming a bit too complicated, both in terms of
> >>>> implementation and use. And the fact that we'd have to jump through
> >>>> hoops to make this work for a full chain.
> >>>>
> >>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
> >>>> This makes it way easier to use. Same branch:
> >>>>
> >>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
> >>>>
> >>>> I'd feel much better with this variant for 5.6.
> >>>>
> >>>
> >>> To be honest, sounds pretty dangerous. Especially since somebody started talking
> >>> about stealing fds from a process, it could lead to a nasty loophole somehow.
> >>> E.g. root registers its credentials, passes io_uring it to non-privileged
> >>> children, and then some process steals the uring fd (though, it would need
> >>> priviledged mode for code-injection or else). Could we Cc here someone really
> >>> keen on security?
> >>
> >> Link? If you can steal fds, then surely you've already lost any sense of
> > 
> > https://lwn.net/Articles/808997/
> > But I didn't looked up it yet.
> 
> This isn't new by any stretch, it's always been possible to pass file
> descriptors through SCM_RIGHTS. This just gives you a new way to do it.
> That's not stealing or leaking, it's deliberately passing it to someone
> else.

I've been reading along quietly. In addition to what Jens said, to ease
everyone's mind: pidfd_getfd() doesn't allow to unconditionally grab
file descriptors for any task. That would be crazy. The calling task
needs ptrace_may_access() permissions on the target task, i.e. the task
from which you want to grab the io_uring file descriptor. And any
calling task that has ptrace_may_access() permissions on the target can
do much worse than just grabbing an fd.

Christian
