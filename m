Return-Path: <io-uring+bounces-151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB47A7F6D1C
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 08:48:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61F69281B09
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 07:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99BBD79E0;
	Fri, 24 Nov 2023 07:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgJMC0Yj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A108C18;
	Fri, 24 Nov 2023 07:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C4BC433C7;
	Fri, 24 Nov 2023 07:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700812116;
	bh=wuXwn6H3IYOQTJYurH/LAKoS23w/GwU7ryzU1+Vs8b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgJMC0Yj3JRcUDF8O8XpdEdYA/5STjclZLwUWXfVMJwJnFCmcyrJDVup7Rscs2p84
	 1lIevByzmjhiYL9n/DPGwW0r1qVsQ45xdWW1cCKjcoubJ/Np/IRSX/dXnPPAZi1lyB
	 ETOprEE5xY+akdxk7DWnyVkIziLf3Nu7PWCfTmFB985JDwr0PPgc9yJ4BLOQhlh8Nx
	 7J3VH6h2rRYlPJhbqQ9tIol8mM/LtKts+YBDNQd03tji9lqn5ZFKRzSp7zz5eJxPSA
	 m4YJmobEWMvUVEr6S2NJRsz4v9jSzMIYOHwn/4yZmgFOE0FpvuIzzDTt4O8YISu59u
	 jwN2CAG1O1gvw==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Oded Gabbay <ogabbay@kernel.org>,
	Wu Hao <hao.wu@intel.com>,
	Tom Rix <trix@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Xu Yilun <yilun.xu@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhi Wang <zhi.a.wang@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>,
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
	Eric Auger <eric.auger@redhat.com>,
	Fei Li <fei1.li@intel.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fpga@vger.kernel.org,
	intel-gvt-dev@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-usb@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-aio@kvack.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v2 0/4] eventfd: simplify signal helpers
Date: Fri, 24 Nov 2023 08:47:57 +0100
Message-ID: <20231124-traurig-halunken-6defdd66e8f2@brauner>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1378; i=brauner@kernel.org; h=from:subject:message-id; bh=wuXwn6H3IYOQTJYurH/LAKoS23w/GwU7ryzU1+Vs8b4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaQmhOr8Nb88ObVn73mvUyobyi/8m/y5yi2fL80o6/sb9 3cTN/yd21HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR7iBGhq1L7YSDDTVSee+x X1xccNDei/91c9MuqdqsiYtj7lg17WdkWCP3faH/qkmK79OnL3ut4/Vo+e0nB564XJ5mY6ruNdX 4JgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 22 Nov 2023 13:48:21 +0100, Christian Brauner wrote:
> Hey everyone,
> 
> This simplifies the eventfd_signal() and eventfd_signal_mask() helpers
> significantly. They can be made void and not take any unnecessary
> arguments.
> 
> I've added a few more simplifications based on Sean's suggestion.
> 
> [...]

Applied to the vfs.misc branch of the vfs/vfs.git tree.
Patches in the vfs.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.misc

[1/4] i915: make inject_virtual_interrupt() void
      https://git.kernel.org/vfs/vfs/c/858848719210
[2/4] eventfd: simplify eventfd_signal()
      https://git.kernel.org/vfs/vfs/c/ded0f31f825f
[3/4] eventfd: simplify eventfd_signal_mask()
      https://git.kernel.org/vfs/vfs/c/45ee1c990e88
[4/4] eventfd: make eventfd_signal{_mask}() void
      https://git.kernel.org/vfs/vfs/c/37d5d473e749

