Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816DF1AD616
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 08:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgDQGbH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Apr 2020 02:31:07 -0400
Received: from verein.lst.de ([213.95.11.211]:55867 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgDQGbH (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 17 Apr 2020 02:31:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CB09368BEB; Fri, 17 Apr 2020 08:31:02 +0200 (CEST)
Date:   Fri, 17 Apr 2020 08:31:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: improve use_mm / unuse_mm v2
Message-ID: <20200417063102.GA18556@lst.de>
References: <20200416053158.586887-1-hch@lst.de> <20200417031744.GI5820@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417031744.GI5820@bombadil.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 16, 2020 at 08:17:44PM -0700, Matthew Wilcox wrote:
> On Thu, Apr 16, 2020 at 07:31:55AM +0200, Christoph Hellwig wrote:
> > this series improves the use_mm / unuse_mm interface by better
> > documenting the assumptions, and my taking the set_fs manipulations
> > spread over the callers into the core API.
> 
> I appreciate all the work you're doing here.
> 
> Do you have plans to introduce a better-named API than set_fs() / get_fs()?

Eventually.  For now I just plan to kill as many as possible.

> Also, having set_fs() return the previous value of 'fs' would simplify
> a lot of the callers.

One thing that should go relatively soon is the need to store the
previous value because we'll have so few callers left that we know we can't
recurse. We should be able to get there around 5.9 / 5.10.
