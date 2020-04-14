Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B483F1A71A6
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 05:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404560AbgDNDSc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 23:18:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:45507 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404552AbgDNDSa (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 13 Apr 2020 23:18:30 -0400
IronPort-SDR: +NMZCy1JVAWaNUivVeURdiFWk6qA5gEF5LQ2edM7FSP3bOsxYl5B+CKx4T3WsT1sz6Fe6Xn+ZP
 re7ucNw1RIKQ==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 20:18:29 -0700
IronPort-SDR: A6dvFsKAF+nMYpB5Nxql8OZD8ESyhZEcZnZf1S7cpOWdTRI4yLKnP5sujEava2jQgnZvzsGGKH
 8bIyy78zkIAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="asc'?scan'208";a="256373748"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.147])
  by orsmga006.jf.intel.com with ESMTP; 13 Apr 2020 20:18:25 -0700
Date:   Tue, 14 Apr 2020 11:04:44 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@kernel.org>,
        amd-gfx@lists.freedesktop.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-usb@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        intel-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Jason Wang <jasowang@redhat.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH 3/6] i915/gvt: remove unused xen bits
Message-ID: <20200414030444.GO11247@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20200404094101.672954-1-hch@lst.de>
 <20200404094101.672954-4-hch@lst.de>
 <20200408014437.GF11247@zhen-hp.sh.intel.com>
 <20200413130806.GA14455@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3eH4Qcq5fItR5cpy"
Content-Disposition: inline
In-Reply-To: <20200413130806.GA14455@lst.de>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--3eH4Qcq5fItR5cpy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020.04.13 15:08:06 +0200, Christoph Hellwig wrote:
> On Wed, Apr 08, 2020 at 09:44:37AM +0800, Zhenyu Wang wrote:
> > On 2020.04.04 11:40:58 +0200, Christoph Hellwig wrote:
> > > No Xen support anywhere here.  Remove a dead declaration and an unused
> > > include.
> > >=20
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> >=20
> > We'll keep that off-tree.
> >=20
> > Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>=20
> Can you pick this up through the i915 tree?

Yes, I'll pick this.

Thanks

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--3eH4Qcq5fItR5cpy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXpUoTAAKCRCxBBozTXgY
JygxAJ9JZICeCzXSNp8YPszWNoMERUV94ACeJJLziuDjCDenyBchPPCAYkP+EtI=
=56PP
-----END PGP SIGNATURE-----

--3eH4Qcq5fItR5cpy--
