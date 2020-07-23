Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599EA22ACB6
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 12:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGWKkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 06:40:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49538 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgGWKj7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 06:39:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595500797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OroazbspJMAWk8IItdGjVpPCZoCWX8pkuMgG1WcYA/I=;
        b=GBsh7ZQzAKrLQ4sCKj+veiL6VM6YI7yU9KTD16Sn95V/7zYbbhZuc6FB+nut1aBW0S6dmS
        7qb0dUHc87Wve4LhskE5AaNDm65gwbht/YxM+YpSy4740GLZTkMKHOnxurtE6ZPXAX47Qk
        7mIF5FuZKG6Qn8mE3+AAxwq9994+EU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-QIUSu_4VN7e_6n4PXA-BIg-1; Thu, 23 Jul 2020 06:39:54 -0400
X-MC-Unique: QIUSu_4VN7e_6n4PXA-BIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2D92193F560;
        Thu, 23 Jul 2020 10:39:51 +0000 (UTC)
Received: from localhost (ovpn-114-204.ams2.redhat.com [10.36.114.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9065478538;
        Thu, 23 Jul 2020 10:39:50 +0000 (UTC)
Date:   Thu, 23 Jul 2020 11:39:49 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Kees Cook <keescook@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: strace of io_uring events?
Message-ID: <20200723103949.GE186372@stefanha-x1.localdomain>
References: <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
 <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com>
 <202007151511.2AA7718@keescook>
 <20200716131404.bnzsaarooumrp3kx@steredhat>
 <202007160751.ED56C55@keescook>
 <20200717080157.ezxapv7pscbqykhl@steredhat.lan>
 <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
 <20200721155848.32xtze5ntvcmjv63@steredhat>
MIME-Version: 1.0
In-Reply-To: <20200721155848.32xtze5ntvcmjv63@steredhat>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cYtjc4pxslFTELvY"
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--cYtjc4pxslFTELvY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2020 at 05:58:48PM +0200, Stefano Garzarella wrote:
> On Tue, Jul 21, 2020 at 08:27:34AM -0700, Andy Lutomirski wrote:
> > On Fri, Jul 17, 2020 at 1:02 AM Stefano Garzarella <sgarzare@redhat.com=
> wrote:
> > >
> > > On Thu, Jul 16, 2020 at 08:12:35AM -0700, Kees Cook wrote:
> > > > On Thu, Jul 16, 2020 at 03:14:04PM +0200, Stefano Garzarella wrote:
> >=20
> > > > access (IIUC) is possible without actually calling any of the io_ur=
ing
> > > > syscalls. Is that correct? A process would receive an fd (via SCM_R=
IGHTS,
> > > > pidfd_getfd, or soon seccomp addfd), and then call mmap() on it to =
gain
> > > > access to the SQ and CQ, and off it goes? (The only glitch I see is
> > > > waking up the worker thread?)
> > >
> > > It is true only if the io_uring istance is created with SQPOLL flag (=
not the
> > > default behaviour and it requires CAP_SYS_ADMIN). In this case the
> > > kthread is created and you can also set an higher idle time for it, s=
o
> > > also the waking up syscall can be avoided.
> >=20
> > I stared at the io_uring code for a while, and I'm wondering if we're
> > approaching this the wrong way. It seems to me that most of the
> > complications here come from the fact that io_uring SQEs don't clearly
> > belong to any particular security principle.  (We have struct creds,
> > but we don't really have a task or mm.)  But I'm also not convinced
> > that io_uring actually supports cross-mm submission except by accident
> > -- as it stands, unless a user is very careful to only submit SQEs
> > that don't use user pointers, the results will be unpredictable.
> > Perhaps we can get away with this:
> >=20
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 74bc4a04befa..92266f869174 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -7660,6 +7660,20 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int,
> > fd, u32, to_submit,
> >      if (!percpu_ref_tryget(&ctx->refs))
> >          goto out_fput;
> >=20
> > +    if (unlikely(current->mm !=3D ctx->sqo_mm)) {
> > +        /*
> > +         * The mm used to process SQEs will be current->mm or
> > +         * ctx->sqo_mm depending on which submission path is used.
> > +         * It's also unclear who is responsible for an SQE submitted
> > +         * out-of-process from a security and auditing perspective.
> > +         *
> > +         * Until a real usecase emerges and there are clear semantics
> > +         * for out-of-process submission, disallow it.
> > +         */
> > +        ret =3D -EACCES;
> > +        goto out;
> > +    }
> > +
> >      /*
> >       * For SQ polling, the thread will do all submissions and completi=
ons.
> >       * Just return the requested submit count, and wake the thread if
> >=20
> > If we can do that, then we could bind seccomp-like io_uring filters to
> > an mm, and we get obvious semantics that ought to cover most of the
> > bases.
> >=20
> > Jens, Christoph?
> >=20
> > Stefano, what's your intended usecase for your restriction patchset?
> >=20
>=20
> Hi Andy,
> my use case concerns virtualization. The idea, that I described in the
> proposal of io-uring restrictions [1], is to share io_uring CQ and SQ que=
ues
> with a guest VM for block operations.
>=20
> In the PoC that I realized, there is a block device driver in the guest t=
hat
> uses io_uring queues coming from the host to submit block requests.
>=20
> Since the guest is not trusted, we need restrictions to allow only
> a subset of syscalls on a subset of file descriptors and memory.

BTW there's only a single mm in the kvm.ko use case.

Stefan

--cYtjc4pxslFTELvY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8ZaPUACgkQnKSrs4Gr
c8g3gQgAyCD8y5GHtXlxs23BbgNqd/8tiO02REWzw2jBut5VyHXhfX7MqZ3L/jFc
vxPAlkPQwzKgyoIdhUXukXhFWhR5Zu2DuKtceGkdk6Y6MNfqaSBL2MX0oxPqondI
nH3tizipLCJWb31XRrntm7EONxiSA7A4CC/ZDGKUu1rVAfIRJd1AK/5+Ymg/5lqz
9RhG60zrTMG/CrSM1ZLaX2ko6QHHqJJji0uMLJyDsUxY2SRVljAS54kt0pX11Uxl
YkONk+ZDISAWYEofcawpoT3yLkfpTCQ4CS1gyVzxb8lFljBSxBJfk6pfzReYECy3
IFGMwOrd2ux1ti3osGizht2otYVbbw==
=juCa
-----END PGP SIGNATURE-----

--cYtjc4pxslFTELvY--

