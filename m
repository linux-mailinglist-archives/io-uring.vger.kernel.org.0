Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3787C1BC3D0
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2020 17:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgD1PgQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Apr 2020 11:36:16 -0400
Received: from mout-p-202.mailbox.org ([80.241.56.172]:63956 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbgD1PgQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Apr 2020 11:36:16 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 49BQjB3yHRzQlHm;
        Tue, 28 Apr 2020 17:36:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id Rw9K7dG0uHR5; Tue, 28 Apr 2020 17:36:10 +0200 (CEST)
Date:   Wed, 29 Apr 2020 01:35:58 +1000
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Cyril Hrubis <chrubis@suse.cz>
Cc:     kernel test robot <rong.a.chen@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-arch@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        lkp@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        ltp@lists.linux.it
Subject: Re: [LTP] [fs] ce436509a8: ltp.openat203.fail
Message-ID: <20200428153558.r32pgvymgk56urtu@yavin.dot.cyphar.com>
References: <f969e7d45a8e83efc1ca13d675efd8775f13f376.1586830316.git.josh@joshtriplett.org>
 <20200427135210.GB5770@shao2-debian>
 <20200427142733.GD7661@rei>
 <20200428005126.6wncibudt6ohghvc@yavin.dot.cyphar.com>
 <20200428153022.GC4244@yuki.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qekeybbajeoqkaf2"
Content-Disposition: inline
In-Reply-To: <20200428153022.GC4244@yuki.lan>
X-Rspamd-Queue-Id: D19511738
X-Rspamd-Score: -8.94 / 15.00 / 15.00
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--qekeybbajeoqkaf2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-04-28, Cyril Hrubis <chrubis@suse.cz> wrote:
> Hi!
> > > > commit: ce436509a8e109330c56bb4d8ec87d258788f5f4 ("[PATCH v4 2/3] f=
s: openat2: Extend open_how to allow userspace-selected fds")
> > > > url: https://github.com/0day-ci/linux/commits/Josh-Triplett/Support=
-userspace-selected-fds/20200414-102939
> > > > base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-ksel=
ftest.git next
> > >=20
> > > This commit adds fd parameter to the how structure where LTP test was
> > > previously passing garbage, which obviously causes the difference in
> > > errno.
> > >=20
> > > This could be safely ignored for now, if the patch gets merged the te=
st
> > > needs to be updated.
> >=20
> > It wouldn't be a bad idea to switch the test to figure out the ksize of
> > the struct, so that you only add bad padding after that. But then again,
> > this would be a bit ugly -- having CHECK_FIELDS would make this simpler.
>=20
> Any pointers how can be the size figured out without relying on the
> E2BIG we are testing for? Does the kernel export it somewhere?

No, you would have to effectively binary search on -E2BIG at the moment.
CHECK_FIELDS is a proposal I have which would allow you to get get the
size of the in-kernel struct, but it's still a proposal.

In theory you could get the size through BTF, but it's probably more
effort than it's worth to implement that.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--qekeybbajeoqkaf2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXqhNWwAKCRCdlLljIbnQ
Esn9AQCkc2dq/DSy5/MYZkNgJc7GfzxvLJGPqfhRlbD3A09eyQEA0CfnnSVqWzit
PCqYg2CM/EUK36nHPWj7vQb7o8bFSQo=
=TzFl
-----END PGP SIGNATURE-----

--qekeybbajeoqkaf2--
