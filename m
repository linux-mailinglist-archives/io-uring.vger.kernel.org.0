Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4744D96CC
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 09:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346232AbiCOIz2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 04:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbiCOIz1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 04:55:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33512615D;
        Tue, 15 Mar 2022 01:54:14 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5591968AA6; Tue, 15 Mar 2022 09:54:10 +0100 (CET)
Date:   Tue, 15 Mar 2022 09:54:10 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220315085410.GA4132@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com> <20220308152105.309618-6-joshi.k@samsung.com> <20220311070148.GA17881@lst.de> <20220314162356.GA13902@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314162356.GA13902@test-zns>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 14, 2022 at 09:53:56PM +0530, Kanchan Joshi wrote:
>>> +struct nvme_uring_cmd_pdu {
>>> +	u32 meta_len;
>>> +	union {
>>> +		struct bio *bio;
>>> +		struct request *req;
>>> +	};
>>> +	void *meta; /* kernel-resident buffer */
>>> +	void __user *meta_buffer;
>>> +} __packed;
>>
>> Why is this marked __packed?
> Did not like doing it, but had to.
> If not packed, this takes 32 bytes of space. While driver-pdu in struct
> io_uring_cmd can take max 30 bytes. Packing nvme-pdu brought it down to
> 28 bytes, which fits and gives 2 bytes back.

What if you move meta_len to the end?  Even if we need the __packed
that will avoid all the unaligned access to pointers, which on some
architectures will crash the kernel.

> And on moving meta elements outside the driver, my worry is that it
> reduces scope of uring-cmd infra and makes it nvme passthru specific.
> At this point uring-cmd is still generic async ioctl/fsctl facility
> which may find other users (than nvme-passthru) down the line. Organization 
> of fields within "struct io_uring_cmd" is around the rule
> that a field is kept out (of 28 bytes pdu) only if is accessed by both
> io_uring and driver. 

We have plenty of other interfaces of that kind.  Sockets are one case
already, and regular read/write with protection information will be
another one.  So having some core infrastrucure for "secondary data"
seems very useful.

> I see, so there is room for adding some efficiency.
> Hope it will be ok if I carry this out as a separate effort.
> Since this is about touching blk_mq_complete_request at its heart, and
> improving sync-direct-io, this does not seem best-fit and slow this
> series down.

I really rather to this properly.  Especially as the current effort
adds new exported interfaces.

> Deferring by ipi or softirq never occured. Neither for block nor for
> char. Softirq is obvious since I was not running against scsi (or nvme with
> single queue). I could not spot whether this is really a overhead, at
> least for nvme.

This tends to kick in if you have less queues than cpu cores.  Quite
command with either a high core cound or a not very high end nvme
controller.
