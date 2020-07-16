Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0A62223B6
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGPNSQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 09:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgGPNSQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 09:18:16 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC159C061755;
        Thu, 16 Jul 2020 06:18:15 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4B6vvS3QhPzQk8j;
        Thu, 16 Jul 2020 15:18:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id 8OkVigZRi11g; Thu, 16 Jul 2020 15:18:07 +0200 (CEST)
Date:   Thu, 16 Jul 2020 23:17:55 +1000
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jann Horn <jannh@google.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: strace of io_uring events?
Message-ID: <20200716131755.l5tsyhupimpinlfi@yavin.dot.cyphar.com>
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net>
 <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
 <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com>
 <202007151511.2AA7718@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7mp6nnuuqiljjvde"
Content-Disposition: inline
In-Reply-To: <202007151511.2AA7718@keescook>
X-MBO-SPAM-Probability: 0
X-Rspamd-Score: -2.81 / 15.00 / 15.00
X-Rspamd-Queue-Id: 80FE1178F
X-Rspamd-UID: dd2040
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--7mp6nnuuqiljjvde
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-07-15, Kees Cook <keescook@chromium.org> wrote:
> Earlier Andy Lutomirski wrote:
> > Let=E2=80=99s add some seccomp folks. We probably also want to be able =
to run
> > seccomp-like filters on io_uring requests. So maybe io_uring should cal=
l into
> > seccomp-and-tracing code for each action.
>=20
> Okay, I'm finally able to spend time looking at this. And thank you to
> the many people that CCed me into this and earlier discussions (at least
> Jann, Christian, and Andy).
>=20
> It *seems* like there is a really clean mapping of SQE OPs to syscalls.
> To that end, yes, it should be trivial to add ptrace and seccomp support
> (sort of). The trouble comes for doing _interception_, which is how both
> ptrace and seccomp are designed.
>=20
> In the basic case of seccomp, various syscalls are just being checked
> for accept/reject. It seems like that would be easy to wire up. For the
> more ptrace-y things (SECCOMP_RET_TRAP, SECCOMP_RET_USER_NOTIF, etc),
> I think any such results would need to be "upgraded" to "reject". Things
> are a bit complex in that seccomp's form of "reject" can be "return
> errno" (easy) or it can be "kill thread (or thread_group)" which ...
> becomes less clear. (More on this later.)
>=20
> In the basic case of "I want to run strace", this is really just a
> creative use of ptrace in that interception is being used only for
> reporting. Does ptrace need to grow a way to create/attach an io_uring
> eventfd? Or should there be an entirely different tool for
> administrative analysis of io_uring events (kind of how disk IO can be
> monitored)?

I would hope that we wouldn't introduce ptrace to io_uring, because
unless we plan to attach to io_uring events via GDB it's simply the
wrong tool for the job. strace does use ptrace, but that's mostly
because Linux's dynamic tracing was still in its infancy at the time
(and even today it requires more privileges than ptrace) -- but you can
emulate strace using bpftrace these days fairly easily.

So really what is being asked here is "can we make it possible to debug
io_uring programs as easily as traditional I/O programs". And this does
not require ptrace, nor should ptrace be part of this discussion IMHO. I
believe this issue (along with seccomp-style filtering) have been
mentioned informally in the past, but I am happy to finally see a thread
about this appear.

> For io_uring generally, I have a few comments/questions:
>=20
> - Why did a new syscall get added that couldn't be extended? All new
>   syscalls should be using Extended Arguments. :(

io_uring was introduced in Linux 5.1, predating clone3() and openat2().
My larger concern is that io_uring operations aren't extensible-structs
-- but we can resolve that issue with some slight ugliness if we ever
run into the problem.

> - Why aren't the io_uring syscalls in the man-page git? (It seems like
>   they're in liburing, but that's should document the _library_ not the
>   syscalls, yes?)

I imagine because using the syscall requires specific memory barriers
which we probably don't want most C programs to be fiddling with
directly. Sort of similar to how iptables doesn't have a syscall-style
man page.

> Speaking to Stefano's proposal[1]:
>=20
> - There appear to be three classes of desired restrictions:
>   - opcodes for io_uring_register() (which can be enforced entirely with
>     seccomp right now).
>   - opcodes from SQEs (this _could_ be intercepted by seccomp, but is
>     not currently written)
>   - opcodes of the types of restrictions to restrict... for making sure
>     things can't be changed after being set? seccomp already enforces
>     that kind of "can only be made stricter"

Unless I misunderstood the patch cover-letter, Stefano's proposal is to
have a mechanism for adding restrictions to individual io_urings -- so
we still need a separate mechanism (or an extended version of Stefano's
proposal) to allow for the "reduce attack surface" usecase of seccomp.
It seems to me like Stefano's proposal is more related to cases where
you might SCM_RIGHTS-send an io_uring to an unprivileged process.

> Solving the mapping of seccomp interception types into CQEs (or anything
> more severe) will likely inform what it would mean to map ptrace events
> to CQEs. So, I think they're related, and we should get seccomp hooked
> up right away, and that might help us see how (if) ptrace should be
> attached.

We could just emulate the seccomp-bpf API with the pseudo-syscalls done
as a result of CQEs, though I'm not sure how happy folks will be with
this kind of glue code in "seccomp-uring" (though in theory it would
allow us to attach existing filters to io_uring...).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--7mp6nnuuqiljjvde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXxBTgAAKCRCdlLljIbnQ
EgEuAQD0g4MbpgC7Lk7FN5CSDV+SxkJSd9OEls6+F/6HJwSKBwD+NTNBfGtd99hQ
z2FCK3kp9ysZiQi7K2MFUeWn33Inhw0=
=DJ+V
-----END PGP SIGNATURE-----

--7mp6nnuuqiljjvde--
