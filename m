Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D51C628294
	for <lists+io-uring@lfdr.de>; Mon, 14 Nov 2022 15:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiKNOcC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Nov 2022 09:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbiKNObu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Nov 2022 09:31:50 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3AC29369;
        Mon, 14 Nov 2022 06:31:49 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221114143148euoutp022e1d72158b421ec29cb993275bb61e50~nefuKvsWt1523315233euoutp02c;
        Mon, 14 Nov 2022 14:31:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221114143148euoutp022e1d72158b421ec29cb993275bb61e50~nefuKvsWt1523315233euoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668436308;
        bh=dQNwfBdIpqaepn/RDINMXYASngIiK5me72nEGTHG5UY=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=YsMxlYkIA4Kw86rr8e90jC0rKprf6oQqf3N2ORtAOi8XkzrNfPZInuCPWRkDfoNYa
         E9SKp2KHmLHQPNn4HzV8qYo+3wlqVJkIqpBcjFadVdrBs6nxtsSJnG37uxecnoem3W
         3bWgJ2LBK2AjxxfhabWaGfuK2wMYFwIOoWDoGhFQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221114143147eucas1p122ae102cdc6d073ab5498e9745195930~neft7Xi9p2102821028eucas1p1B;
        Mon, 14 Nov 2022 14:31:47 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 7F.54.09561.35152736; Mon, 14
        Nov 2022 14:31:47 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221114143147eucas1p1902d9b4afc377fdda25910a5d083e3dc~neftYp_GB1176311763eucas1p1Y;
        Mon, 14 Nov 2022 14:31:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221114143147eusmtrp20aac6134b5cc3d3136fcf567899c2e12~neftXwote2551925519eusmtrp2r;
        Mon, 14 Nov 2022 14:31:47 +0000 (GMT)
X-AuditID: cbfec7f2-0b3ff70000002559-04-63725153c12d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 47.AC.09026.35152736; Mon, 14
        Nov 2022 14:31:47 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221114143147eusmtip15cf4f3c97add76f0639c4b23fc1db327~neftH2Kxk1514615146eusmtip1d;
        Mon, 14 Nov 2022 14:31:47 +0000 (GMT)
Received: from localhost (106.110.32.133) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Mon, 14 Nov 2022 14:31:46 +0000
Date:   Mon, 14 Nov 2022 15:31:45 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Paul Moore <paul@paul-moore.com>
CC:     Jeffrey Vander Stoep <jeffv@google.com>,
        Gil Cukierman <cukie@google.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, <kernel-team@android.com>,
        <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <selinux@vger.kernel.org>
Subject: Re: [PATCH v1 0/2] Add LSM access controls for io_uring_setup
Message-ID: <20221114143145.ha22rdxphhpgd53u@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="2ctr4pslrx4mhrsa"
Content-Disposition: inline
In-Reply-To: <CAHC9VhRTWGuiMpJJiFrUpgsm7nQaNA-n1CYRMPS-24OLvzdA2A@mail.gmail.com>
X-Originating-IP: [106.110.32.133]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7djP87rBgUXJBstnGFrMWbWN0WL13X42
        i3+rYyw6H55ltnjXeo7FYk7rLnaLdesXM1ns2C5icXnXHDaLDz2P2CxuT5rOYnH++DF2i/MX
        zrFbPD8/mdGBz2Pb7m2sHjtn3WX3WLCp1OPa7kiPy2dLPXq+J3uc/RrlsXbvC0aPz5vkAjij
        uGxSUnMyy1KL9O0SuDJWXt7CWnBQv+LE9ZtMDYzN6l2MnBwSAiYSB3bMY+li5OIQEljBKLHk
        ylFmkISQwBdGiYWtJRCJz4wSJ1/+YIfpmHrgBhtEYjmjxK7T15jgqhY/ugCV2cIo8ebgdkaQ
        FhYBVYlph46zgthsAjoS59/cAdshIqAisfjpekaQBmaB28wS35Y3MYEkhAXcJNr7P7OB2LwC
        5hKrP69ih7AFJU7OfMICYjMLVEhM2zwJyOYAsqUllv/jAAlzCgRKvDt/lQniVCWJr296WSHs
        Wom1x86wg+ySEHjEKTHx82WoIheJntlboH4Tlnh1HMaWkfi/cz5UTbbEzim7mCHsAolZJ6ey
        geyVELCW6DuTA2E6Sny/Yg9h8knceCsIcSSfxKRt05khwrwSHW1CEDPUJHY0bWWcwKg8C8lb
        s5C8NQvhLYiwjsSC3Z/YMIS1JZYtfM0MYdtKrFv3nmUBI/sqRvHU0uLc9NRiw7zUcr3ixNzi
        0rx0veT83E2MwDR5+t/xTzsY5776qHeIkYmD8RCjClDzow2rLzBKseTl56UqifDOk8lPFuJN
        SaysSi3Kjy8qzUktPsQozcGiJM7LNkMrWUggPbEkNTs1tSC1CCbLxMEp1cDEJsRzQPIGf2S4
        2pXVbXcqzrIGlgSluskzepxZedyuoDwo9dFOp7onrMcLPqYd7RfieWO6bEVI4c/M3NM/1K2X
        dZt53/ufXXk1Qszl43qT9UsenWjeFhTpy9Y9W3RO9sI/y0z03O9Wl/6ZyN25T7D9ZuO6LfrK
        IsyrSrM2LSk2dvHdqZJlOnlGU3C8aB37382Lf+VcdZi/smfTysJ3MzMevX7WdFwr3GWi6UyR
        RTcXFj5+dWL1nMUs5wwTQ34YcD/JiHddMWWVWlKVe6XIvKvJYv86XgleyE2Wq5Pz/nSq58NP
        RY5//xV3mbYf+pAQeK+bSXfhpGtv99RMbxWed2V/2I/vE05duv/m2tk7sUsKlFiKMxINtZiL
        ihMBwRB+Eg4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t/xu7rBgUXJBlfW8lnMWbWN0WL13X42
        i3+rYyw6H55ltnjXeo7FYk7rLnaLdesXM1ns2C5icXnXHDaLDz2P2CxuT5rOYnH++DF2i/MX
        zrFbPD8/mdGBz2Pb7m2sHjtn3WX3WLCp1OPa7kiPy2dLPXq+J3uc/RrlsXbvC0aPz5vkAjij
        9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLW/X/F
        XLBfv2LurWtMDYyN6l2MnBwSAiYSUw/cYOti5OIQEljKKLF8yX9miISMxKcrH9khbGGJP9e6
        oIo+MkqcPPaBCcLZwijx+8cCJpAqFgFViWmHjrOC2GwCOhLn39wBmyQioCKx+Ol6RpAGZoGb
        zBLv2yaCNQgLuEm0939mA7F5BcwlVn9exQ4xtYdJovfmHKiEoMTJmU9YQGxmgTKJ5um9QHEO
        IFtaYvk/DpAwp0CgxLvzV5kgTlWS+PqmlxXCrpV4dX834wRG4VlIJs1CMmkWwiSIsJbEjX8v
        mTCEtSWWLXzNDGHbSqxb955lASP7KkaR1NLi3PTcYiO94sTc4tK8dL3k/NxNjMCkse3Yzy07
        GFe++qh3iJGJg/EQowpQ56MNqy8wSrHk5eelKonwzpPJTxbiTUmsrEotyo8vKs1JLT7EaAoM
        xonMUqLJ+cB0llcSb2hmYGpoYmZpYGppZqwkzutZ0JEoJJCeWJKanZpakFoE08fEwSnVwNS1
        9eWuyZVv7UpE1t1wZZPl2xPhn/o94OqLqnfRhwvvd4ZOefZ8YfqX2cU3+ku9atbePVQVf/Qr
        1+wWnf62X8tdJr86m/v7zYWt5Vv+Rtpyhwe/2aVerOpwgyWSS7M1ntXkxasJF+34ef4/v6e8
        PHa5+XX1l8r3o4TFNmZLK1jMcdukYJH503mjsEWUf+quyXJLUmUKfabcNVv8cIXSZZM9tw8x
        rlpddr9ztoX1FpmL+o+lS6KWXpV9uuqL5cbX0VcKttRL9yf4SbVcit2rvU/lvabCk1lTF21a
        O/X/+eIlyo18HQcYp6v8eTBT/eUDN5fSMz+72xd1JbimXdgYv/TV6czl8TfP8E76ytOya2mt
        EktxRqKhFnNRcSIAmD8uKK8DAAA=
X-CMS-MailID: 20221114143147eucas1p1902d9b4afc377fdda25910a5d083e3dc
X-Msg-Generator: CA
X-RootMTR: 20221114143147eucas1p1902d9b4afc377fdda25910a5d083e3dc
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221114143147eucas1p1902d9b4afc377fdda25910a5d083e3dc
References: <20221107205754.2635439-1-cukie@google.com>
        <CAHC9VhTLBWkw2XzqdFx1LFVKDtaAL2pEfsmm+LEmS0OWM1mZgA@mail.gmail.com>
        <CABXk95ChjusTneWJgj5a58CZceZv0Ay-P-FwBcH2o4rO0g2Ggw@mail.gmail.com>
        <CAHC9VhRTWGuiMpJJiFrUpgsm7nQaNA-n1CYRMPS-24OLvzdA2A@mail.gmail.com>
        <CGME20221114143147eucas1p1902d9b4afc377fdda25910a5d083e3dc@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--2ctr4pslrx4mhrsa
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 10, 2022 at 04:04:46PM -0500, Paul Moore wrote:
> On Thu, Nov 10, 2022 at 12:54 PM Jeffrey Vander Stoep <jeffv@google.com> =
wrote:
> > On Mon, Nov 7, 2022 at 10:17 PM Paul Moore <paul@paul-moore.com> wrote:
> > >
> > > On Mon, Nov 7, 2022 at 3:58 PM Gil Cukierman <cukie@google.com> wrote:
> > > >
> > > > This patchset provides the changes required for controlling access =
to
> > > > the io_uring_setup system call by LSMs. It does this by adding a new
> > > > hook to io_uring. It also provides the SELinux implementation for a=
 new
> > > > permission, io_uring { setup }, using the new hook.
> > > >
> > > > This is important because existing io_uring hooks only support limi=
ting
> > > > the sharing of credentials and access to the sensitive uring_cmd fi=
le
> > > > op. Users of LSMs may also want the ability to tightly control which
> > > > callers can retrieve an io_uring capable fd from the kernel, which =
is
> > > > needed for all subsequent io_uring operations.
> > >
> > > It isn't immediately obvious to me why simply obtaining a io_uring fd
> > > from io_uring_setup() would present a problem, as the security
> > > relevant operations that are possible with that io_uring fd *should*
> > > still be controlled by other LSM hooks.  Can you help me understand
> > > what security issue you are trying to resolve with this control?
> >
> > I think there are a few reasons why we want this particular hook.
> >
> > 1.  It aligns well with how other resources are managed by selinux
> > where access to the resource is the first control point (e.g. "create"
> > for files, sockets, or bpf_maps, "prog_load" for bpf programs, and
> > "open" for perf_event) and then additional functionality or
> > capabilities require additional permissions.
>=20
> [NOTE: there were two reply sections in your email, and while similar,
> they were not identical; I've trimmed the other for the sake of
> clarity]
>=20
> The resources you mention are all objects which contain some type of
> information (either user data, configuration, or program
> instructions), with the resulting fd being a handle to those objects.
> In the case of io_uring the fd is a handle to the io_uring
> interface/rings, which by itself does not contain any information
> which is not already controlled by other permissions.
>=20
> I/O operations which transfer data between the io_uring buffers and
> other system objects, e.g. IORING_OP_READV, are still subject to the
> same file access controls as those done by the application using
> syscalls.  Even the IORING_OP_OPENAT command goes through the standard
> VFS code path which means it will trigger the same access control
> checks as an open*() done by the application normally.
>=20
> The 'interesting' scenarios are those where the io_uring operation
> servicing credentials, aka personalities, differ from the task
> controlling the io_uring.  However in those cases we have the new
> io_uring controls to gate these delegated operations.  Passing an
> io_uring fd is subject to the fd/use permission like any other fd.
>=20
> Although perhaps the most relevant to your request is the fact that
> the io_uring inode is created using the new(ish) secure anon inode
> interface which ensures that the creating task has permission to
> create an io_uring.  This io_uring inode label also comes into play
> when a task attempts to mmap() the io_uring rings, a critical part of
> the io_uring API.
>=20
> If I'm missing something you believe to be important, please share the de=
tails.
>=20
> > 2. It aligns well with how resources are managed on Android. We often
> > do not grant direct access to resources (like memory buffers).
>=20
> Accessing the io_uring buffers requires a task to mmap() the io_uring
> fd which is controlled by the normal SELinux mmap() access controls.
>=20
> > 3. Attack surface management. One of the primary uses of selinux on
> > Android is to assess and limit attack surface (e.g.
> > https://twitter.com/jeffvanderstoep/status/1422771606309335043) . As
> > io_uring vulnerabilities have made their way through our vulnerability
> > management system, it's become apparent that it's complicated to
> > assess the impact. Is a use-after-free reachable? Creating
> > proof-of-concept exploits takes a lot of time, and often functionality
> > can be reached by multiple paths. How many of the known io_uring
> > vulnerabilities would be gated by the existing checks? How many future
> > ones will be gated by the existing checks? I don't know the answer to
> > either of these questions and it's not obvious. This hook makes that
> > initial assessment simple and effective.
>=20
> It should be possible to deny access to io_uring via the anonymous
> inode labels, the mmap() controls, and the fd/use permission.  If you
> find a way to do meaningful work with an io_uring fd that can't be
> controlled via an existing permission check please let me know.

Also interested in a more specific case. Sending reply so I get added to
the group response.
>=20
> --
> paul-moore.com

--2ctr4pslrx4mhrsa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmNyUUoACgkQupfNUreW
QU+inAv/do7MKKHTSeQFTr+qTo1NYVoXryjw9rfz3xinweQV5XNVCvmzY1OO7Gkk
pnDb+FOXdVjDrp97L5lQfHM7jRsJY2Ia8x1KYW+zhn79rxH9BQxWs646Q6g7ORJz
6C9NlOMyoBIgssRaPqLMRe8E9ewIzfhgLpjn4yI23kl7uDkyVStGLTZtCarWTMi2
ffFN8DFmZm3hm42LUKElGqSlrDxR5eWDGBQYBknkFHwsHKj5C/cL1ch020decZwB
JSponYgw4OIAslxF+nWhTtIFBk40m+ji4QuxZv16bVxy1ei4yQayZYHelnT/Swvv
j4BR2S0ifeBp5HEprMRpPBKMxRe045J0IcHsDlg6d5Sz1039yLGcNySQnQwOND+t
dsVYv3f//2NIJF3eThgBi+KPAQS33USVk9qZujIFdcESRYfIoL0uA8el8TOop2gM
DaFkBKQqNrq3s01NUfuTrOoK7wrvalgngev67gVv0TAEQQebaWZovjgR/NHl16nI
ywSdStI+
=aESw
-----END PGP SIGNATURE-----

--2ctr4pslrx4mhrsa--
