Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C6221D2B5
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 11:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgGMJYn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 05:24:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32333 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726360AbgGMJYm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 05:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594632281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8taBpeNWfYvGCIuu+3RcwP8mgr+DtPBfUd45yt6a9tM=;
        b=eWwcMIJqBhlKBxHmuHRc22ra6gg5WxyyHZIRR8yYcgQFV4A71bBe9ELfBWWAuz9cC/QgL+
        t3kSXMBrqJUtSlS7aJsLW3OklZR5S6Lxz2RxddAk5h+jgENlBT6UmfxOrMHVMmlme6BIUS
        UUnh2frH7XiY/5/wPWa+ZY2QAMQC12M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-p6tDz3eYNamNtlQUM20UWg-1; Mon, 13 Jul 2020 05:24:39 -0400
X-MC-Unique: p6tDz3eYNamNtlQUM20UWg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3A3F19200C3;
        Mon, 13 Jul 2020 09:24:37 +0000 (UTC)
Received: from localhost (ovpn-114-66.ams2.redhat.com [10.36.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C68C719D61;
        Mon, 13 Jul 2020 09:24:36 +0000 (UTC)
Date:   Mon, 13 Jul 2020 10:24:35 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [PATCH RFC 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200713092435.GC28639@stefanha-x1.localdomain>
References: <20200710141945.129329-1-sgarzare@redhat.com>
 <20200710153309.GA4699@char.us.oracle.com>
 <20200710162017.qdu34ermtxh3rfgl@steredhat>
MIME-Version: 1.0
In-Reply-To: <20200710162017.qdu34ermtxh3rfgl@steredhat>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2020 at 06:20:17PM +0200, Stefano Garzarella wrote:
> On Fri, Jul 10, 2020 at 11:33:09AM -0400, Konrad Rzeszutek Wilk wrote:
> > .snip..
> > > Just to recap the proposal, the idea is to add some restrictions to t=
he
> > > operations (sqe, register, fixed file) to safely allow untrusted appl=
ications
> > > or guests to use io_uring queues.
> >=20
> > Hi!
> >=20
> > This is neat and quite cool - but one thing that keeps nagging me is
> > what how much overhead does this cut from the existing setup when you u=
se
> > virtio (with guests obviously)?
>=20
> I need to do more tests, but the preliminary results that I reported on
> the original proposal [1] show an overhead of ~ 4.17 uS (with iodepth=3D1=
)
> when I'm using virtio ring processed in a dedicated iothread:
>=20
>   - 73 kIOPS using virtio-blk + QEMU iothread + io_uring backend
>   - 104 kIOPS using io_uring passthrough
>=20
> >                                 That is from a high level view the
> > beaty of io_uring being passed in the guest is you don't have the
> > virtio ring -> io_uring processing, right?
>=20
> Right, and potentially we can share the io_uring queues directly to the
> guest userspace applications, cutting down the cost of Linux block
> layer in the guest.

Another factor is that the guest submits requests directly to the host
kernel sqpoll thread. When a virtqueue is used the sqpoll thread cannot
poll it directly so another host thread (QEMU) needs to poll the
virtqueue. The same applies for the completion code path.

Stefan

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8MKFMACgkQnKSrs4Gr
c8iWaQgAkvf4Ga+PHPaSTucaASbYCgeYbSgiUPCLRsOB0g2+3HM6buSTHpdfYoUk
Fy1Y3Yl7cDqGmCCHdTx9rYTQCd6SYSElqylNNnn6yEMiMgvcYcK4xn+wgY8BxVGy
yIv0Rl52ucmtkQ4Iry5mA/vSNZiiVnDyP5Mq9EahEKDO9RtC0duf4xJeR1Lhyk9G
QDbDx9I2/TZgsxar1+Tettaf6vbC1d8S5WCSSktvMl7Jn2zP/uyJg9DyuMCRWMVl
YPX8SPGK/Kr0uKRWkWtBdbK0TuDJtM5i8hdD59ppdQaSwt7JrmowOFDKg9iznl4r
Z9f95iJ6QD2dHTtGo4Yc5WKyhZ9BmA==
=KoLY
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--

