Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433EC1A66B9
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 15:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgDMNIM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 09:08:12 -0400
Received: from verein.lst.de ([213.95.11.211]:34692 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgDMNIM (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 13 Apr 2020 09:08:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2D8A968BEB; Mon, 13 Apr 2020 15:08:07 +0200 (CEST)
Date:   Mon, 13 Apr 2020 15:08:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@kernel.org>,
        amd-gfx@lists.freedesktop.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-usb@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        intel-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Jason Wang <jasowang@redhat.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH 3/6] i915/gvt: remove unused xen bits
Message-ID: <20200413130806.GA14455@lst.de>
References: <20200404094101.672954-1-hch@lst.de> <20200404094101.672954-4-hch@lst.de> <20200408014437.GF11247@zhen-hp.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408014437.GF11247@zhen-hp.sh.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 08, 2020 at 09:44:37AM +0800, Zhenyu Wang wrote:
> On 2020.04.04 11:40:58 +0200, Christoph Hellwig wrote:
> > No Xen support anywhere here.  Remove a dead declaration and an unused
> > include.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> We'll keep that off-tree.
> 
> Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>

Can you pick this up through the i915 tree?
