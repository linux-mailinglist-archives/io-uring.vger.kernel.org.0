Return-Path: <io-uring+bounces-126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5787F469E
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 13:49:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01D86B20BD3
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 12:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C543FE2B;
	Wed, 22 Nov 2023 12:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tc/2BAOy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C304D126;
	Wed, 22 Nov 2023 12:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B8AC433C7;
	Wed, 22 Nov 2023 12:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700657341;
	bh=6OXBSUL+nsBWDSWY/Q2r+0obUk1WW2944LvuwrKFOOg=;
	h=From:Subject:Date:To:Cc:From;
	b=Tc/2BAOyq/CL424TPKJ+8ok4iD2CSlMj4gj7I88R2wR3SRpoXrwpPP4CcDv0rCy4Q
	 imtDsj4NMmiBNZozdVII4r1Tu0lKWkktCHU3pI4LzAIFYMYIaMFpbulm6tUMVwguK4
	 qTlrJ2u4/DeMIiXbQyzfXkH/WxJG3G65JVkRZ5lf6r4VzUJTQXH/UjyJJ0V5cZAl2s
	 w/spDO6VPLhtfPliBsbbdWVAXUjht3ojtCQDl0LfCWNNwph8Zdy7ZX7mLHL0no3jWG
	 z8IdhyFNF5VEPzmpKIFkxea1CvPQqUVZAxIi/ByG3Lv1c90SwdjDEIcrL99R5YQgIg
	 fP3gmG5BvwYWQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 0/4] eventfd: simplify signal helpers
Date: Wed, 22 Nov 2023 13:48:21 +0100
Message-Id: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJX4XWUC/32OTQ6CMBBGr0K6dkhbYpu48h6GRX8GaMRiZkijI
 dzdwgFcvsV737cJRkrI4tZsgrAkTkuuoC+NCJPLI0KKlYWWupNWdVAGBiyY1yECpzG7GaSXURn
 rosEgqvgmHNLnjD76yt4xgieXw3SkXo5XpLaY1gIFdRhT4nWh7/miqMP7O1gUSLBDdCZco1ba3
 59IGed2oVH0+77/ALQAWw7XAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=564; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6OXBSUL+nsBWDSWY/Q2r+0obUk1WW2944LvuwrKFOOg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaTG/lhzPFmKbc7Vgs4lut/eP1hw9bOuxtyeI9s4tYwWe
 yZZxby53lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRf4IM/8NUuv3TH0hJOWz8
 c65PTujVFLaLGrq6vFP/9yxi7X77UInhf0113erTobU10gp/tt37unHeHp8P0ZHTLq5c7sWdN//
 2D04A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Hey everyone,

This simplifies the eventfd_signal() and eventfd_signal_mask() helpers
significantly. They can be made void and not take any unnecessary
arguments.

I've added a few more simplifications based on Sean's suggestion.

Signed-off-by: Christian Brauner <brauner@kernel.org>

Changes in v2:
- further simplify helpers
- Link to v1: https://lore.kernel.org/r/20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org

---



---
base-commit: b85ea95d086471afb4ad062012a4d73cd328fa86
change-id: 20230713-vfs-eventfd-signal-0b0d167ad6ec


