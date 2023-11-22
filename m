Return-Path: <io-uring+bounces-136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 926987F4A16
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 16:19:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43693281655
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 15:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAAE4EB21;
	Wed, 22 Nov 2023 15:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WnPr6GfR"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4EAF9;
	Wed, 22 Nov 2023 07:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700666375; x=1732202375;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=nrNPcz4uYEQBP3pOrCUXcuO8X6G/FSLQKBhZfBz9dLY=;
  b=WnPr6GfRsmHheX8m0dMDThH9SdbMmURgop2QVRUSnHTfuQkivH84A0t1
   lc+YRQ2nV87kyMZ5PhHTkOrh7Excs6jGFS/xofM/urtHV4kBMLhIvg1YF
   gVEFTOsy20Pn+yYCZ3a0AUvM63kxv2GSXq49MzmfaAS3T1NpXGd/0MHyG
   5DH8aPv7m1cOXumvpMhYld46TIkpCZqp+oNcfN62jj09wTcEajPR8hT1h
   LuXAbfqp+oJY4ozRFRLCITIyEab3FsYIEtaPnftYgNfGlVQORA1+U0LD9
   pwP+0AqQNgTATs0DjAIhfs1z99yaaRKKfBL7A3LnvNKXz+B4G4tssZRi8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="390932784"
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="390932784"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 07:19:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833052538"
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="833052538"
Received: from tjquresh-mobl.ger.corp.intel.com (HELO localhost) ([10.252.41.76])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 07:19:09 -0800
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Vitaly
 Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, Oded Gabbay
 <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>, Tom Rix
 <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>, Xu Yilun
 <yilun.xu@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang
 <zhi.a.wang@intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tvrtko.ursulin@linux.intel.com>, David Airlie <airlied@gmail.com>, Daniel
 Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, Frederic Barrat <fbarrat@linux.ibm.com>, Andrew
 Donnellan <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Farman
 <farman@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>, Halil
 Pasic <pasic@linux.ibm.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 Peter Oberparleiter <oberpar@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Tony
 Krowiak <akrowiak@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
 Harald Freudenberger <freude@linux.ibm.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Diana Craciun <diana.craciun@oss.nxp.com>,
 Alex Williamson <alex.williamson@redhat.com>, Eric Auger
 <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>, Benjamin LaHaise
 <bcrl@kvack.org>, Christian Brauner <brauner@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun
 Song <muchun.song@linux.dev>, Kirti Wankhede <kwankhede@nvidia.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fpga@vger.kernel.org,
 intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, linux-usb@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-aio@kvack.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Jens
 Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
Subject: Re: [PATCH v2 2/4] eventfd: simplify eventfd_signal()
In-Reply-To: <20231122-vfs-eventfd-signal-v2-2-bd549b14ce0c@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
 <20231122-vfs-eventfd-signal-v2-2-bd549b14ce0c@kernel.org>
Date: Wed, 22 Nov 2023 17:19:06 +0200
Message-ID: <877cm9n7dh.fsf@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, 22 Nov 2023, Christian Brauner <brauner@kernel.org> wrote:
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index 33a918f9566c..dc9e01053235 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -74,20 +74,17 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
>  /**
>   * eventfd_signal - Adds @n to the eventfd counter.

This still refers to @n here, and in patch 4.

BR,
Jani.

>   * @ctx: [in] Pointer to the eventfd context.
> - * @n: [in] Value of the counter to be added to the eventfd internal counter.
> - *          The value cannot be negative.
>   *
>   * This function is supposed to be called by the kernel in paths that do not
>   * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
>   * value, and we signal this as overflow condition by returning a EPOLLERR
>   * to poll(2).
>   *
> - * Returns the amount by which the counter was incremented.  This will be less
> - * than @n if the counter has overflowed.
> + * Returns the amount by which the counter was incremented.
>   */
> -__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
> +__u64 eventfd_signal(struct eventfd_ctx *ctx)
>  {
> -	return eventfd_signal_mask(ctx, n, 0);
> +	return eventfd_signal_mask(ctx, 1, 0);
>  }
>  EXPORT_SYMBOL_GPL(eventfd_signal);
>  

-- 
Jani Nikula, Intel

