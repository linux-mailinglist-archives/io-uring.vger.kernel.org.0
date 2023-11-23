Return-Path: <io-uring+bounces-141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD4B57F5544
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 01:26:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A7FF281671
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 00:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C357E3;
	Thu, 23 Nov 2023 00:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a0RMRtdr"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAFA1B3;
	Wed, 22 Nov 2023 16:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700699164; x=1732235164;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=kMJqNQrPFkouBUmP1tIxtozSsYheDkR/LnL4F11wiis=;
  b=a0RMRtdr45SnsHLYk3kiLIfZs2Z292eQtCjDOGkSajq4kJgqoPyPz1Z8
   xhWoNH51ino8oe9+Nmimsn7SFdTQgw8cA/qSM06asNrV9XlVmhWFA6efE
   bx/KJxGEkz9CgKaAcRip2AVvQj244oSCMbQ2SV3R4DIR0CTNKXPPkI00S
   8UPzwDbKGWrNEIvyOLU2GF23JoceIic+G88FMkrhNsWS/7MACg0sIjNMf
   ijDW0ytrIcjGYvd6MSyu2liYjeaUIruC6bgfya5Y7v4Nc28NcFQbnBBQQ
   f0zW1UCdi/Sb7g9NYp8o9b8iKurHqbTYEdk8doLf35VPgtN8OmhSA3u25
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="389323011"
X-IronPort-AV: E=Sophos;i="6.04,220,1695711600"; 
   d="asc'?scan'208";a="389323011"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 16:26:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="716903060"
X-IronPort-AV: E=Sophos;i="6.04,220,1695711600"; 
   d="asc'?scan'208";a="716903060"
Received: from debian-skl.sh.intel.com (HELO debian-skl) ([10.239.160.45])
  by orsmga003.jf.intel.com with ESMTP; 22 Nov 2023 16:25:45 -0800
Date: Thu, 23 Nov 2023 08:24:24 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
	Oded Gabbay <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>,
	Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Xu Yilun <yilun.xu@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhi Wang <zhi.a.wang@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Diana Craciun <diana.craciun@oss.nxp.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-fpga@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	linux-usb@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-aio@kvack.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 1/4] i915: make inject_virtual_interrupt() void
Message-ID: <ZV6buHrQy2+CJ7xX@debian-scheme>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
 <20231122-vfs-eventfd-signal-v2-1-bd549b14ce0c@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ehCOKC0wDaVXxQlM"
Content-Disposition: inline
In-Reply-To: <20231122-vfs-eventfd-signal-v2-1-bd549b14ce0c@kernel.org>


--ehCOKC0wDaVXxQlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023.11.22 13:48:22 +0100, Christian Brauner wrote:
> The single caller of inject_virtual_interrupt() ignores the return value
> anyway. This allows us to simplify eventfd_signal() in follow-up
> patches.
>=20
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  drivers/gpu/drm/i915/gvt/interrupt.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/interrupt.c b/drivers/gpu/drm/i915/=
gvt/interrupt.c
> index de3f5903d1a7..9665876b4b13 100644
> --- a/drivers/gpu/drm/i915/gvt/interrupt.c
> +++ b/drivers/gpu/drm/i915/gvt/interrupt.c
> @@ -422,7 +422,7 @@ static void init_irq_map(struct intel_gvt_irq *irq)
>  #define MSI_CAP_DATA(offset) (offset + 8)
>  #define MSI_CAP_EN 0x1
> =20
> -static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
> +static void inject_virtual_interrupt(struct intel_vgpu *vgpu)
>  {
>  	unsigned long offset =3D vgpu->gvt->device_info.msi_cap_offset;
>  	u16 control, data;
> @@ -434,10 +434,10 @@ static int inject_virtual_interrupt(struct intel_vg=
pu *vgpu)
> =20
>  	/* Do not generate MSI if MSIEN is disabled */
>  	if (!(control & MSI_CAP_EN))
> -		return 0;
> +		return;
> =20
>  	if (WARN(control & GENMASK(15, 1), "only support one MSI format\n"))
> -		return -EINVAL;
> +		return;
> =20
>  	trace_inject_msi(vgpu->id, addr, data);
> =20
> @@ -451,10 +451,10 @@ static int inject_virtual_interrupt(struct intel_vg=
pu *vgpu)
>  	 * returned and don't inject interrupt into guest.
>  	 */
>  	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
> -		return -ESRCH;
> -	if (vgpu->msi_trigger && eventfd_signal(vgpu->msi_trigger, 1) !=3D 1)
> -		return -EFAULT;
> -	return 0;
> +		return;
> +	if (!vgpu->msi_trigger)
> +		return;
> +	eventfd_signal(vgpu->msi_trigger, 1);
>  }

I think it's a little simpler to write as
    if (vgpu->msi_trigger)
            eventfd_signal(vgpu->msi_trigger, 1);

Looks fine with me.

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

Thanks!

> =20
>  static void propagate_event(struct intel_gvt_irq *irq,
>=20
> --=20
> 2.42.0
>=20

--ehCOKC0wDaVXxQlM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCZV6bswAKCRCxBBozTXgY
JySHAJ4qE2jv0i0ZauQv+Bv/bGwHt0ZrbACeJadIIL6gQC6kmoICLhyqplCwOeo=
=1+t0
-----END PGP SIGNATURE-----

--ehCOKC0wDaVXxQlM--

