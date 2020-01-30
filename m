Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9CE14D8EA
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 11:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgA3K0m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 05:26:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55591 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgA3K0m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 05:26:42 -0500
Received: from [89.27.154.14] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1ix71w-0008In-MD; Thu, 30 Jan 2020 10:26:36 +0000
Date:   Thu, 30 Jan 2020 11:26:36 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Message-ID: <20200130102635.ar2bohr7n4li2hyd@wittgenstein>
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
 <CAG48ez1qVCoOwcdA7YZcKObQ9frWNxCjHOp6RYeqd+q_n4KJJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG48ez1qVCoOwcdA7YZcKObQ9frWNxCjHOp6RYeqd+q_n4KJJQ@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 30, 2020 at 11:11:58AM +0100, Jann Horn wrote:
> On Thu, Jan 30, 2020 at 2:08 AM Jens Axboe <axboe@kernel.dk> wrote:
> > On 1/29/20 10:34 AM, Jens Axboe wrote:
> > > On 1/29/20 7:59 AM, Jann Horn wrote:
> > >> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>> On 1/28/20 11:04 AM, Jens Axboe wrote:
> > >>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
> > >> [...]
> > >>>>> #1 adds support for registering the personality of the invoking task,
> > >>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
> > >>>>> just having one link, it doesn't support a chain of them.
> > >> [...]
> > >>> I didn't like it becoming a bit too complicated, both in terms of
> > >>> implementation and use. And the fact that we'd have to jump through
> > >>> hoops to make this work for a full chain.
> > >>>
> > >>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
> > >>> This makes it way easier to use. Same branch:
> > >>>
> > >>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
> > >>>
> > >>> I'd feel much better with this variant for 5.6.
> > >>
> > >> Some general feedback from an inspectability/debuggability perspective:
> > >>
> > >> At some point, it might be nice if you could add a .show_fdinfo
> > >> handler to the io_uring_fops that makes it possible to get a rough
> > >> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
> > >> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
> > >> helpful for debugging to be able to see information about the fixed
> > >> files and buffers that have been registered. Same for the
> > >> personalities; that information might also be useful when someone is
> > >> trying to figure out what privileges a running process actually has.
> > >
> > > Agree, that would be a very useful addition. I'll take a look at it.
> >
> > Jann, how much info are you looking for? Here's a rough start, just
> > shows the number of registered files and buffers, and lists the
> > personalities registered. We could also dump the buffer info for
> > each of them, and ditto for the files. Not sure how much verbosity
> > is acceptable in fdinfo?
> 
> At the moment, I personally am just interested in this from the
> perspective of being able to audit the state of personalities, to make
> important information about the security state of processes visible.
> 
> Good point about verbosity in fdinfo - I'm not sure about that myself either.
> 
> > Here's the test app for personality:
> 
> Oh, that was quick...
> 
> > # cat 3
> > pos:    0
> > flags:  02000002
> > mnt_id: 14
> > user-files: 0
> > user-bufs: 0
> > personalities:
> >             1: uid=0/gid=0
> >
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index c5ca84a305d3..0b2c7d800297 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -6511,6 +6505,45 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
> >         return submitted ? submitted : ret;
> >  }
> >
> > +struct ring_show_idr {
> > +       struct io_ring_ctx *ctx;
> > +       struct seq_file *m;
> > +};
> > +
> > +static int io_uring_show_cred(int id, void *p, void *data)
> > +{
> > +       struct ring_show_idr *r = data;
> > +       const struct cred *cred = p;
> > +
> > +       seq_printf(r->m, "\t%5d: uid=%u/gid=%u\n", id, cred->uid.val,
> > +                                               cred->gid.val);
> 
> As Stefan said, the ->uid and ->gid aren't very useful, since when a
> process switches UIDs for accessing things in the filesystem, it
> probably only changes its EUID and FSUID, not its RUID.
> I think what's particularly relevant for uring would be the ->fsuid
> and the ->fsgid along with ->cap_effective; and perhaps for some
> operations also the ->euid and ->egid. The real UID/GID aren't really
> relevant when performing normal filesystem operations and such.

This should probably just use the same format that is found in
/proc/<pid>/status to make it easy for tools to use the same parsing
logic and for the sake of consistency. We've adapted the same format for
pidfds. So that would mean:

Uid:	1000	1000	1000	1000
Gid:	1000	1000	1000	1000

Which would be: Real, effective, saved set, and filesystem {G,U}IDs

And CapEff in /proc/<pid>/status has the format:
CapEff:	0000000000000000

Christian
