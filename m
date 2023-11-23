Return-Path: <io-uring+bounces-145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D9F7F6004
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 14:19:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E0C5281DC2
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 13:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CA124B5C;
	Thu, 23 Nov 2023 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r42g7gVE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A51C24B3F;
	Thu, 23 Nov 2023 13:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFAAC433C9;
	Thu, 23 Nov 2023 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700745532;
	bh=BJOuctG/jOXVT0hO6qxyVXBeYyH4TG/ylT0dyLa92yI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r42g7gVEtjBJ5WfLPAfCypJTdeIZa9tza+98XErRLkZuJq42IHSNqt9TjDoS1u/dO
	 mqRTO6hyOgRcqG5Vqi98sspSbfx6Ne64w0KZSaAUUdSmCRm0SeW9B8r2AffO7bhDq0
	 voQrIzDl2Rys7kYNdpWCPkldE19sNixdWiKMUoa9j34EYG62L/DgZtbbaspmEPmu14
	 PuPzBMdYXfPSBprGxxIV2rleVHq+xRFaQ7/X8REU4C8BYG2H4sP4+OADV7Tg2Ri8NY
	 w8CXZUWWNJUaMlJH5PPc15vZ4ox/kvWZIeet2zBszz9qi15zBW/WlVu+mFthIg8ovM
	 qoF7yc2VytIMg==
Date: Thu, 23 Nov 2023 14:18:33 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jani Nikula <jani.nikula@linux.intel.com>
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
Subject: Re: [PATCH v2 2/4] eventfd: simplify eventfd_signal()
Message-ID: <20231123-portwein-geeignet-787b940c7d2d@brauner>
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
 <20231122-vfs-eventfd-signal-v2-2-bd549b14ce0c@kernel.org>
 <877cm9n7dh.fsf@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <877cm9n7dh.fsf@intel.com>

> >   * eventfd_signal - Adds @n to the eventfd counter.
> 
> This still refers to @n here, and in patch 4.

Fixed and folded. Thanks!

