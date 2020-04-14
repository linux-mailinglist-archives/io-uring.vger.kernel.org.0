Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3742D1A7467
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 09:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgDNHN2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 03:13:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:60361 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728832AbgDNHN2 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 14 Apr 2020 03:13:28 -0400
IronPort-SDR: Bmi7r8AIOfEmVbCDegF0//TBTZ2W5wFR8I/kst/X8cYiCc4vCg/nCKmFwfbxylI0YhpRuTdTBt
 MXvcce6zRXIQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 00:13:27 -0700
IronPort-SDR: 3mzTZiupNXsl0k5QcLc9AHNCJBc5G9UIIEYO8qCIUclLUzsoEbBJJHUqxdgJkxiNvCr7gq5Idq
 YjsPeTwaKt8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="426968243"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005.jf.intel.com with ESMTP; 14 Apr 2020 00:13:22 -0700
Date:   Tue, 14 Apr 2020 03:03:44 -0400
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
Message-ID: <20200414070344.GF10586@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200404094101.672954-1-hch@lst.de>
 <20200404094101.672954-3-hch@lst.de>
 <20200407030845.GA10586@joy-OptiPlex-7040>
 <20200413132730.GB14455@lst.de>
 <20200414000410.GE10586@joy-OptiPlex-7040>
 <20200414070013.GA23680@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414070013.GA23680@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 14, 2020 at 09:00:13AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 13, 2020 at 08:04:10PM -0400, Yan Zhao wrote:
> > > I can't think of another way for a kernel thread to have a mm indeed.
> > for example, before calling to vfio_dma_rw(), a kernel thread has already
> > called use_mm(), then its current->mm is not null, and it has flag
> > PF_KTHREAD.
> > in this case, we just want to allow the copy_to_user() directly if
> > current->mm == mm, rather than call another use_mm() again.
> > 
> > do you think it makes sense?
> 
> I mean no other way than using use_mm.  That being said nesting
> potentional use_mm callers sounds like a rather bad idea, and we
> should avoid that.
yes, agree.
I was explaining why we just use "current->mm == NULL"
(not "current->flag & PF_KTHREAD") as a criteria to call use_mm()
in vfio_dma_rw(), which you might ask us when you take that part into your
series. :)
