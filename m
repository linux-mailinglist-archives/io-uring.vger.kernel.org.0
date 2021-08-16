Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082073ED0EF
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 11:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhHPJVI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Mon, 16 Aug 2021 05:21:08 -0400
Received: from aposti.net ([89.234.176.197]:50528 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235163AbhHPJVI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 16 Aug 2021 05:21:08 -0400
Date:   Mon, 16 Aug 2021 11:20:25 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: IIO, dmabuf, io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jonathan Cameron <jic23@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?b?S/ZuaWc=?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@lst.de>, linux-iio@vger.kernel.org,
        io-uring@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>
Message-Id: <1YDXXQ.FDQ4R2DPJ42F@crapouillou.net>
In-Reply-To: <a343b14f-6b7e-e377-9ae0-871e23b70453@gmail.com>
References: <2H0SXQ.2KIK2PBVRFWH2@crapouillou.net>
        <a343b14f-6b7e-e377-9ae0-871e23b70453@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Le ven., août 13 2021 at 18:20:19 +0100, Pavel Begunkov 
<asml.silence@gmail.com> a écrit :
> Hi Paul,
> 
> On 8/13/21 12:41 PM, Paul Cercueil wrote:
>>  Hi,
>> 
>>  A few months ago we (ADI) tried to upstream the interface we use 
>> with our high-speed ADCs and DACs. It is a system with custom ioctls 
>> on the iio device node to dequeue and enqueue buffers (allocated 
>> with dma_alloc_coherent), that can then be mmap'd by userspace 
>> applications. Anyway, it was ultimately denied entry [1]; this API 
>> was okay in ~2014 when it was designed but it feels like 
>> re-inventing the wheel in 2021.
>> 
>>  Back to the drawing table, and we'd like to design something that 
>> we can actually upstream. This high-speed interface looks awfully 
>> similar to DMABUF, so we may try to implement a DMABUF interface for 
>> IIO, unless someone has a better idea.
>> 
>>  Our first usecase is, we want userspace applications to be able to 
>> dequeue buffers of samples (from ADCs), and/or enqueue buffers of 
>> samples (for DACs), and to be able to manipulate them (mmapped 
>> buffers). With a DMABUF interface, I guess the userspace application 
>> would dequeue a dma buffer from the driver, mmap it, read/write the 
>> data, unmap it, then enqueue it to the IIO driver again so that it 
>> can be disposed of. Does that sound sane?
>> 
>>  Our second usecase is - and that's where things get tricky - to be 
>> able to stream the samples to another computer for processing, over 
>> Ethernet or USB. Our typical setup is a high-speed ADC/DAC on a dev 
>> board with a FPGA and a weak soft-core or low-power CPU; processing 
>> the data in-situ is not an option. Copying the data from one buffer 
>> to another is not an option either (way too slow), so we absolutely 
>> want zero-copy.
>> 
>>  Usual userspace zero-copy techniques (vmsplice+splice, MSG_ZEROCOPY 
>> etc) don't really work with mmapped kernel buffers allocated for DMA 
>> [2] and/or have a huge overhead, so the way I see it, we would also 
>> need DMABUF support in both the Ethernet stack and USB (functionfs) 
>> stack. However, as far as I understood, DMABUF is mostly a DRM/V4L2 
>> thing, so I am really not sure we have the right idea here.
>> 
>>  And finally, there is the new kid in town, io_uring. I am not very 
>> literate about the topic, but it does not seem to be able to handle 
>> DMA buffers (yet?). The idea that we could dequeue a buffer of 
>> samples from the IIO device and send it over the network in one 
>> single syscall is appealing, though.
> 
> You might be interested to look up zctap, previously a.k.a netgpu.

CCing Jonathan (Lemon) then.

Jonathan: Am I right that zctap supports importing/exporting dmabufs? 
Because that would solve half of my problem.

Cheers,
-Paul

> For io_uring, it's work in progress as well.
> 
>> 
>>  Any thoughts? Feedback would be greatly appreciated.
>> 
>>  Cheers,
>>  -Paul
>> 
>>  [1]: 
>> https://lore.kernel.org/linux-iio/20210217073638.21681-1-alexandru.ardelean@analog.com/T/#m6b853addb77959c55e078fbb06828db33d4bf3d7
>>  [2]: 
>> https://newbedev.com/zero-copy-user-space-tcp-send-of-dma-mmap-coherent-mapped-memory
> 
> --
> Pavel Begunkov


