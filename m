Return-Path: <io-uring+bounces-144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 554ED7F5FBE
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 14:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 102F4281DEA
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 13:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9573624A08;
	Thu, 23 Nov 2023 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSfg5H2P"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454CB24A05;
	Thu, 23 Nov 2023 13:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B246C433C7;
	Thu, 23 Nov 2023 13:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700745135;
	bh=VBAn7FZcvw1drif9KzTmaabLPVAYO4zX2eeQPqBTwFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nSfg5H2PW95uhmCyWswaCk18HBzNnUr8lrZC9/jswVOaVEk9Necoc/3PSsg/eWI+c
	 nUSNVQiBVNuTkdJG4ZroseK0fKTuKodiCnTfp5VBFncFM3thhaeXbqdq7/1OyUlFkh
	 hvhoTdxdxKP2qiIgsXRrtgQ8aW/glFRtrG5pk0o8niH7Far3mtrppzle/A5KWCQFN1
	 0J9D7XnhqZQWKtQ8+7lAsz1DeizPazr+k6Se4xCbJkyOxPi+pXbCyvcnpPCySfoTu/
	 nxY4zeQuXLH9O0FYHNYyhAuFpYV+0VZCYLV3awl8R2o5zjol3Qy1blkTCXoR/k3lKT
	 V10Lsp2N5sNOQ==
Date: Thu, 23 Nov 2023 14:11:56 +0100
From: Christian Brauner <brauner@kernel.org>
To: Zhenyu Wang <zhenyuw@linux.intel.com>
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
	Xu Yilun <yilun.xu@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
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
Message-ID: <20231123-randlage-instinkt-e458628d2d7c@brauner>
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
 <20231122-vfs-eventfd-signal-v2-1-bd549b14ce0c@kernel.org>
 <ZV6buHrQy2+CJ7xX@debian-scheme>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZV6buHrQy2+CJ7xX@debian-scheme>

> > +	if (!vgpu->msi_trigger)
> > +		return;
> > +	eventfd_signal(vgpu->msi_trigger, 1);
> >  }
> 
> I think it's a little simpler to write as
>     if (vgpu->msi_trigger)
>             eventfd_signal(vgpu->msi_trigger, 1);

Good point. I folded that suggestion into the patch.

