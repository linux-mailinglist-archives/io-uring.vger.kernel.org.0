Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EB01AB84C
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2020 08:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408398AbgDPGnQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Apr 2020 02:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408168AbgDPGnO (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 16 Apr 2020 02:43:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AA5720787;
        Thu, 16 Apr 2020 06:43:13 +0000 (UTC)
Date:   Thu, 16 Apr 2020 08:43:11 +0200
From:   Greg KH <greg@kroah.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH 3/3] kernel: set USER_DS in kthread_use_mm
Message-ID: <20200416064311.GA300290@kroah.com>
References: <20200416053158.586887-1-hch@lst.de>
 <20200416053158.586887-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416053158.586887-4-hch@lst.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 16, 2020 at 07:31:58AM +0200, Christoph Hellwig wrote:
> Some architectures like arm64 and s390 require USER_DS to be set for
> kernel threads to access user address space, which is the whole purpose
> of kthread_use_mm, but other like x86 don't.  That has lead to a huge
> mess where some callers are fixed up once they are tested on said
> architectures, while others linger around and yet other like io_uring
> try to do "clever" optimizations for what usually is just a trivial
> asignment to a member in the thread_struct for most architectures.
> 
> Make kthread_use_mm set USER_DS, and kthread_unuse_mm restore to the
> previous value instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Michael S. Tsirkin <mst@redhat.com> [vhost]
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> [usb]
