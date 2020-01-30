Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1795614DDA1
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 16:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgA3POJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 10:14:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33261 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbgA3POJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 10:14:09 -0500
Received: from [109.134.33.162] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1ixBW5-0004Q2-IO; Thu, 30 Jan 2020 15:14:03 +0000
Date:   Thu, 30 Jan 2020 16:13:42 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jann Horn <jannh@google.com>, Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Message-ID: <20200130151342.u554shnaliau42jq@wittgenstein>
References: <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
 <CAG48ez1qVCoOwcdA7YZcKObQ9frWNxCjHOp6RYeqd+q_n4KJJQ@mail.gmail.com>
 <20200130102635.ar2bohr7n4li2hyd@wittgenstein>
 <cf801c52-7719-bb5c-c999-ab9aab0d4871@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cf801c52-7719-bb5c-c999-ab9aab0d4871@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 30, 2020 at 07:11:08AM -0700, Jens Axboe wrote:
> On 1/30/20 3:26 AM, Christian Brauner wrote:
> > On Thu, Jan 30, 2020 at 11:11:58AM +0100, Jann Horn wrote:
> >> On Thu, Jan 30, 2020 at 2:08 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>> On 1/29/20 10:34 AM, Jens Axboe wrote:
> >>>> On 1/29/20 7:59 AM, Jann Horn wrote:
> >>>>> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
> >>>>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
> >>>>> [...]
> >>>>>>>> #1 adds support for registering the personality of the invoking task,
> >>>>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
> >>>>>>>> just having one link, it doesn't support a chain of them.
> >>>>> [...]
> >>>>>> I didn't like it becoming a bit too complicated, both in terms of
> >>>>>> implementation and use. And the fact that we'd have to jump through
> >>>>>> hoops to make this work for a full chain.
> >>>>>>
> >>>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
> >>>>>> This makes it way easier to use. Same branch:
> >>>>>>
> >>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
> >>>>>>
> >>>>>> I'd feel much better with this variant for 5.6.
> >>>>>
> >>>>> Some general feedback from an inspectability/debuggability perspective:
> >>>>>
> >>>>> At some point, it might be nice if you could add a .show_fdinfo
> >>>>> handler to the io_uring_fops that makes it possible to get a rough
> >>>>> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
> >>>>> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
> >>>>> helpful for debugging to be able to see information about the fixed
> >>>>> files and buffers that have been registered. Same for the
> >>>>> personalities; that information might also be useful when someone is
> >>>>> trying to figure out what privileges a running process actually has.
> >>>>
> >>>> Agree, that would be a very useful addition. I'll take a look at it.
> >>>
> >>> Jann, how much info are you looking for? Here's a rough start, just
> >>> shows the number of registered files and buffers, and lists the
> >>> personalities registered. We could also dump the buffer info for
> >>> each of them, and ditto for the files. Not sure how much verbosity
> >>> is acceptable in fdinfo?
> >>
> >> At the moment, I personally am just interested in this from the
> >> perspective of being able to audit the state of personalities, to make
> >> important information about the security state of processes visible.
> >>
> >> Good point about verbosity in fdinfo - I'm not sure about that myself either.

Afaik, there's no rule here. I would expect that it shouldn't exceed
4096kb just because that is the limit that seems to be enforced for
writes to proc files atm; other than that it should be the wild west.
The fdinfo files are mostly interesting for anon_inode fds imho and the
ones that come to mind right now simply don't have a lot of information
to provide:

eventfd
timerfd
seccomp_notify_fd

Potentially, the mount fds from David could be extended in the future.

(Side note: One thing that comes to mind is that we should probably
enforce^Wdocument that all fdinfo files use CamelCase?)

Christian
