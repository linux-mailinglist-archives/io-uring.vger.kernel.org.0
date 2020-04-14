Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792531A6FF9
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 02:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390381AbgDNANy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 20:13:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:64690 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390372AbgDNANx (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 13 Apr 2020 20:13:53 -0400
IronPort-SDR: Tcx1HYoDFFG/1ecGXpMr1zxOB2GVLzRwBS/5G4vwoQVPIV4Z2qNJ9d4jejWxd2UPkM0dMhnXlI
 6Q6Hejcy44YQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 17:13:53 -0700
IronPort-SDR: WwSP/bjwzVqCvzpfDJVQx7mHVD9DqAVfA90u9u6YJ0BE3eg8B7Aus6XqC75wdrzGtPX0vlI9oI
 I6IjfgU71shQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,380,1580803200"; 
   d="scan'208";a="277078198"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga004.fm.intel.com with ESMTP; 13 Apr 2020 17:13:48 -0700
Date:   Mon, 13 Apr 2020 20:04:10 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtualization@lists.linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/6] i915/gvt/kvm: a NULL ->mm does not mean a thread is
 a kthread
Message-ID: <20200414000410.GE10586@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200404094101.672954-1-hch@lst.de>
 <20200404094101.672954-3-hch@lst.de>
 <20200407030845.GA10586@joy-OptiPlex-7040>
 <20200413132730.GB14455@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413132730.GB14455@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 13, 2020 at 03:27:30PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 06, 2020 at 11:08:46PM -0400, Yan Zhao wrote:
> > hi
> > we were removing this code. see
> > https://lore.kernel.org/kvm/20200313031109.7989-1-yan.y.zhao@intel.com/
> 
> This didn't make 5.7-rc1.
> 
> > The implementation of vfio_dma_rw() has been in vfio next tree.
> > https://github.com/awilliam/linux-vfio/commit/8d46c0cca5f4dc0538173d62cd36b1119b5105bc
> 
> 
> This made 5.7-rc1, so I'll update the series to take it into account.
> 
> T
> > in vfio_dma_rw(),  we still use
> > bool kthread = current->mm == NULL.
> > because if current->mm != NULL and current->flags & PF_KTHREAD, instead
> > of calling use_mm(), we first check if (current->mm == mm) and allow copy_to_user() if it's true.
> > 
> > Do you think it's all right?
> 
> I can't think of another way for a kernel thread to have a mm indeed.
for example, before calling to vfio_dma_rw(), a kernel thread has already
called use_mm(), then its current->mm is not null, and it has flag
PF_KTHREAD.
in this case, we just want to allow the copy_to_user() directly if
current->mm == mm, rather than call another use_mm() again.

do you think it makes sense?

Thanks
Yan

> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev
