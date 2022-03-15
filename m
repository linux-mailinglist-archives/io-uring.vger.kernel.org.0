Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7BE4D96E4
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 09:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345206AbiCOI7A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 04:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346290AbiCOI7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 04:59:00 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5D522D;
        Tue, 15 Mar 2022 01:57:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 11FEF68AA6; Tue, 15 Mar 2022 09:57:46 +0100 (CET)
Date:   Tue, 15 Mar 2022 09:57:45 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 14/17] io_uring: add polling support for uring-cmd
Message-ID: <20220315085745.GE4132@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152723epcas5p34460b4af720e515317f88dbb78295f06@epcas5p3.samsung.com> <20220308152105.309618-15-joshi.k@samsung.com> <20220311065007.GC17728@lst.de> <CA+1E3rKKCE53TJ9mJesK3UrPPa=Vqx6fxA+TAhj9v5hT452AuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rKKCE53TJ9mJesK3UrPPa=Vqx6fxA+TAhj9v5hT452AuQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 14, 2022 at 03:46:08PM +0530, Kanchan Joshi wrote:
> But, after you did bio based polling, we need just the bio to poll.
> iocb is a big structure (48 bytes), and if we try to place it in
> struct io_uring_cmd, we will just blow up the cacheline in io_uring
> (first one in io_kiocb).
> So we just store that bio pointer in io_uring_cmd on submission
> (please see patch 15).
> And here on completion we pick that bio, and put that into this local
> iocb, simply because  ->iopoll needs it.
> Do you see I am still missing anything here?

Yes.  The VFS layer interface for polling is the kiocb.  Don't break
it.  The bio is just an implementation detail.
