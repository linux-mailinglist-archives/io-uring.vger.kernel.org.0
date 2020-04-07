Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41EB01A0533
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 05:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgDGDS1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 23:18:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:19262 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgDGDS0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 6 Apr 2020 23:18:26 -0400
IronPort-SDR: 9vRluI4iJ7LncyDqqP9OOkqmrDCqYY8nZY0vJXvjyyNaUn016xWtinCmu0YWMEidX6uih+VMKy
 PcbSIPYQYVVQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 20:18:26 -0700
IronPort-SDR: 2xR9uCM5BCNi15KKmsOhl436RFPRAMt47uVHr0POCE9sbZmZYVeBcv4l84JGJCChQ2Yo+l3GPc
 XmGUNL+cWKeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,353,1580803200"; 
   d="scan'208";a="451069613"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 06 Apr 2020 20:18:21 -0700
Date:   Mon, 6 Apr 2020 23:08:46 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@kernel.org>,
        amd-gfx@lists.freedesktop.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-usb@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        intel-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Jason Wang <jasowang@redhat.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH 2/6] i915/gvt/kvm: a NULL ->mm does not mean a thread is
 a kthread
Message-ID: <20200407030845.GA10586@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200404094101.672954-1-hch@lst.de>
 <20200404094101.672954-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404094101.672954-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Apr 04, 2020 at 11:40:57AM +0200, Christoph Hellwig wrote:
> Use the proper API instead.
> 
> Fixes: f440c8a572d7 ("drm/i915/gvt/kvmgt: read/write GPA via KVM API")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 074c4efb58eb..5848400620b4 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -2037,7 +2037,7 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
>  	struct kvmgt_guest_info *info;
>  	struct kvm *kvm;
>  	int idx, ret;
> -	bool kthread = current->mm == NULL;
> +	bool kthread = (current->flags & PF_KTHREAD);
>  
>  	if (!handle_valid(handle))
>  		return -ESRCH;
> -- 
> 2.25.1
>
hi
we were removing this code. see
https://lore.kernel.org/kvm/20200313031109.7989-1-yan.y.zhao@intel.com/

The implementation of vfio_dma_rw() has been in vfio next tree.
https://github.com/awilliam/linux-vfio/commit/8d46c0cca5f4dc0538173d62cd36b1119b5105bc

in vfio_dma_rw(),  we still use
bool kthread = current->mm == NULL.
because if current->mm != NULL and current->flags & PF_KTHREAD, instead
of calling use_mm(), we first check if (current->mm == mm) and allow copy_to_user() if it's true.

Do you think it's all right?

Thanks
Yan



> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev
