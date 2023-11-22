Return-Path: <io-uring+bounces-127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C28D07F46B4
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 13:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6233AB211A0
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 12:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCF74B5D8;
	Wed, 22 Nov 2023 12:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AqfJxO8X"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED924AF64;
	Wed, 22 Nov 2023 12:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD60AC433C9;
	Wed, 22 Nov 2023 12:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700657358;
	bh=7uZiA7BV1EHvD8gDrmgEuc8Q4gkEdBarx0UpVsG1vNg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AqfJxO8XzZeGNu0mtpcXDTCSFRPOo0SlhhHv/QC0WO3Obsw0j2/dU4c4FuBQrd/OP
	 DbFK2NJl7j4VWDGp+SPsJ2YNue2rd7Zmwi8E3gfCSqgH9n/YLMrRNAlGE6SQVlsU23
	 vXqTRkoNBWRDxjRECNLDuPkVcLRsFUNxMuqqdeQsDkcrKlrPNXno9qOAJ6oepLCP+d
	 LXmPkukb1d8ai5dg0mrA/uqMeYv4stTQeV+VB3b1YYMaJJmaWGgihfWA/lNr2WTu1/
	 7/ZBuqxZhiJUisLEqasZPLQquM1tLv/D5upbL8C3NSwCaFqd+c3rIUmaf4Nu5T4QBL
	 r9gfOpX5Qg0Tw==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 22 Nov 2023 13:48:22 +0100
Subject: [PATCH v2 1/4] i915: make inject_virtual_interrupt() void
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231122-vfs-eventfd-signal-v2-1-bd549b14ce0c@kernel.org>
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
In-Reply-To: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
 Oded Gabbay <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>, 
 Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>, 
 Xu Yilun <yilun.xu@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
 Zhi Wang <zhi.a.wang@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, 
 David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, 
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Frederic Barrat <fbarrat@linux.ibm.com>, 
 Andrew Donnellan <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Eric Farman <farman@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>, 
 Halil Pasic <pasic@linux.ibm.com>, Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
 Jason Herne <jjherne@linux.ibm.com>, 
 Harald Freudenberger <freude@linux.ibm.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 Diana Craciun <diana.craciun@oss.nxp.com>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Eric Auger <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>, 
 Benjamin LaHaise <bcrl@kvack.org>, Christian Brauner <brauner@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fpga@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org, 
 intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-usb@vger.kernel.org, virtualization@lists.linux-foundation.org, 
 netdev@vger.kernel.org, linux-aio@kvack.org, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
X-Mailer: b4 0.13-dev-26615
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7uZiA7BV1EHvD8gDrmgEuc8Q4gkEdBarx0UpVsG1vNg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaTG/lijOaknSTlcRJzPILDJVd/TRk51g3yQX9PrhU6dq
 73z7mzoKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmIggF8P/skrZDdMFRVfP+ti2
 XjtpR/st0cgfoZuOF904N6NM/+fZTYwMt20s3h3lyVj0+C63y4d/387vnKA8ry7MYWFejO+c6q/
 /mAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The single caller of inject_virtual_interrupt() ignores the return value
anyway. This allows us to simplify eventfd_signal() in follow-up
patches.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 drivers/gpu/drm/i915/gvt/interrupt.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/interrupt.c b/drivers/gpu/drm/i915/gvt/interrupt.c
index de3f5903d1a7..9665876b4b13 100644
--- a/drivers/gpu/drm/i915/gvt/interrupt.c
+++ b/drivers/gpu/drm/i915/gvt/interrupt.c
@@ -422,7 +422,7 @@ static void init_irq_map(struct intel_gvt_irq *irq)
 #define MSI_CAP_DATA(offset) (offset + 8)
 #define MSI_CAP_EN 0x1
 
-static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
+static void inject_virtual_interrupt(struct intel_vgpu *vgpu)
 {
 	unsigned long offset = vgpu->gvt->device_info.msi_cap_offset;
 	u16 control, data;
@@ -434,10 +434,10 @@ static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
 
 	/* Do not generate MSI if MSIEN is disabled */
 	if (!(control & MSI_CAP_EN))
-		return 0;
+		return;
 
 	if (WARN(control & GENMASK(15, 1), "only support one MSI format\n"))
-		return -EINVAL;
+		return;
 
 	trace_inject_msi(vgpu->id, addr, data);
 
@@ -451,10 +451,10 @@ static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
 	 * returned and don't inject interrupt into guest.
 	 */
 	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
-		return -ESRCH;
-	if (vgpu->msi_trigger && eventfd_signal(vgpu->msi_trigger, 1) != 1)
-		return -EFAULT;
-	return 0;
+		return;
+	if (!vgpu->msi_trigger)
+		return;
+	eventfd_signal(vgpu->msi_trigger, 1);
 }
 
 static void propagate_event(struct intel_gvt_irq *irq,

-- 
2.42.0


