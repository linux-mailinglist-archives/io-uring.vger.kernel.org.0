Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEF23EB4A7
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 13:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240046AbhHMLmG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 07:42:06 -0400
Received: from aposti.net ([89.234.176.197]:46710 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239938AbhHMLmF (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 13 Aug 2021 07:42:05 -0400
Date:   Fri, 13 Aug 2021 13:41:26 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: IIO, dmabuf, io_uring
To:     Jonathan Cameron <jic23@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?b?S/ZuaWc=?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-iio@vger.kernel.org, io-uring@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>
Message-Id: <2H0SXQ.2KIK2PBVRFWH2@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

A few months ago we (ADI) tried to upstream the interface we use with 
our high-speed ADCs and DACs. It is a system with custom ioctls on the 
iio device node to dequeue and enqueue buffers (allocated with 
dma_alloc_coherent), that can then be mmap'd by userspace applications. 
Anyway, it was ultimately denied entry [1]; this API was okay in ~2014 
when it was designed but it feels like re-inventing the wheel in 2021.

Back to the drawing table, and we'd like to design something that we 
can actually upstream. This high-speed interface looks awfully similar 
to DMABUF, so we may try to implement a DMABUF interface for IIO, 
unless someone has a better idea.

Our first usecase is, we want userspace applications to be able to 
dequeue buffers of samples (from ADCs), and/or enqueue buffers of 
samples (for DACs), and to be able to manipulate them (mmapped 
buffers). With a DMABUF interface, I guess the userspace application 
would dequeue a dma buffer from the driver, mmap it, read/write the 
data, unmap it, then enqueue it to the IIO driver again so that it can 
be disposed of. Does that sound sane?

Our second usecase is - and that's where things get tricky - to be able 
to stream the samples to another computer for processing, over Ethernet 
or USB. Our typical setup is a high-speed ADC/DAC on a dev board with a 
FPGA and a weak soft-core or low-power CPU; processing the data in-situ 
is not an option. Copying the data from one buffer to another is not an 
option either (way too slow), so we absolutely want zero-copy.

Usual userspace zero-copy techniques (vmsplice+splice, MSG_ZEROCOPY 
etc) don't really work with mmapped kernel buffers allocated for DMA 
[2] and/or have a huge overhead, so the way I see it, we would also 
need DMABUF support in both the Ethernet stack and USB (functionfs) 
stack. However, as far as I understood, DMABUF is mostly a DRM/V4L2 
thing, so I am really not sure we have the right idea here.

And finally, there is the new kid in town, io_uring. I am not very 
literate about the topic, but it does not seem to be able to handle DMA 
buffers (yet?). The idea that we could dequeue a buffer of samples from 
the IIO device and send it over the network in one single syscall is 
appealing, though.

Any thoughts? Feedback would be greatly appreciated.

Cheers,
-Paul

[1]: 
https://lore.kernel.org/linux-iio/20210217073638.21681-1-alexandru.ardelean@analog.com/T/#m6b853addb77959c55e078fbb06828db33d4bf3d7
[2]: 
https://newbedev.com/zero-copy-user-space-tcp-send-of-dma-mmap-coherent-mapped-memory


