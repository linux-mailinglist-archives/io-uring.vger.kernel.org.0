Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F311A73F9
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 09:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406131AbgDNHAU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 03:00:20 -0400
Received: from verein.lst.de ([213.95.11.211]:37725 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728471AbgDNHAT (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 14 Apr 2020 03:00:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 024D068BEB; Tue, 14 Apr 2020 09:00:13 +0200 (CEST)
Date:   Tue, 14 Apr 2020 09:00:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Felipe Balbi <balbi@kernel.org>,
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
Subject: Re: [PATCH 2/6] i915/gvt/kvm: a NULL ->mm does not mean a thread
 is a kthread
Message-ID: <20200414070013.GA23680@lst.de>
References: <20200404094101.672954-1-hch@lst.de> <20200404094101.672954-3-hch@lst.de> <20200407030845.GA10586@joy-OptiPlex-7040> <20200413132730.GB14455@lst.de> <20200414000410.GE10586@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414000410.GE10586@joy-OptiPlex-7040>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 13, 2020 at 08:04:10PM -0400, Yan Zhao wrote:
> > I can't think of another way for a kernel thread to have a mm indeed.
> for example, before calling to vfio_dma_rw(), a kernel thread has already
> called use_mm(), then its current->mm is not null, and it has flag
> PF_KTHREAD.
> in this case, we just want to allow the copy_to_user() directly if
> current->mm == mm, rather than call another use_mm() again.
> 
> do you think it makes sense?

I mean no other way than using use_mm.  That being said nesting
potentional use_mm callers sounds like a rather bad idea, and we
should avoid that.
