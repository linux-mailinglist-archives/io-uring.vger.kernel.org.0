Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20544F22D9
	for <lists+io-uring@lfdr.de>; Tue,  5 Apr 2022 08:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiDEGEc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 02:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiDEGEb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 02:04:31 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBC41658C
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 23:02:32 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D454768BEB; Tue,  5 Apr 2022 08:02:25 +0200 (CEST)
Date:   Tue, 5 Apr 2022 08:02:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [RFC 5/5] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220405060224.GE23698@lst.de>
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150@epcas5p2.samsung.com> <20220401110310.611869-6-joshi.k@samsung.com> <20220404072016.GD444@lst.de> <CA+1E3rJ+iWAhUVzVrRDiFTUmp5sNF7wqw_7oVqru2qLCTBQrqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJ+iWAhUVzVrRDiFTUmp5sNF7wqw_7oVqru2qLCTBQrqQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 04, 2022 at 07:55:05PM +0530, Kanchan Joshi wrote:
> > Something like this (untested) patch should help to separate
> > the much better:
> 
> It does, thanks. But the only thing is - it would be good to support
> vectored-passthru too (i.e. NVME_IOCTL_IO64_CMD_VEC) for this path.
> For the new opcode "NVME_URING_CMD_IO" , either we can change the
> cmd-structure or flag-based handling so that vectored-io is supported.
> Or we introduce NVME_URING_CMD_IO_VEC also for that.
> Which one do you prefer?

I agree vectored I/O support is useful.

Do we even need to support the non-vectored case?

Also I think we'll want admin command passthrough on /dev/nvmeX as
well, but I'm fine solving the other items first.

> > +static int nvme_ioctl_finish_metadata(struct bio *bio, int ret,
> > +               void __user *meta_ubuf)
> > +{
> > +       struct bio_integrity_payload *bip = bio_integrity(bio);
> > +
> > +       if (bip) {
> > +               void *meta = bvec_virt(bip->bip_vec);
> > +
> > +               if (!ret && bio_op(bio) == REQ_OP_DRV_IN &&
> > +                   copy_to_user(meta_ubuf, meta, bip->bip_vec->bv_len))
> > +                       ret = -EFAULT;
> 
> Maybe it is better to move the check "bio_op(bio) != REQ_OP_DRV_IN" outside.
> Because this can be common, and for that we can avoid entering into
> the function call itself (i.e. nvme_ioctl_finish_metadata).

Function calls are pretty cheap, but I'll see what we can do.  I'll try
to come up with a prep series to refactor the passthrough support for
easier adding of the io_uring in the next days.
