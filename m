Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF504D96D4
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 09:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346167AbiCOI4z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 04:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241081AbiCOI4y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 04:56:54 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E774D9C0;
        Tue, 15 Mar 2022 01:55:42 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 81C4968AA6; Tue, 15 Mar 2022 09:55:39 +0100 (CET)
Date:   Tue, 15 Mar 2022 09:55:39 +0100
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
Subject: Re: [PATCH 08/17] nvme: enable passthrough with fixed-buffer
Message-ID: <20220315085539.GB4132@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152709epcas5p1f9d274a0214dc462c22c278a72d8697c@epcas5p1.samsung.com> <20220308152105.309618-9-joshi.k@samsung.com> <20220311064321.GC17232@lst.de> <CA+1E3rKnsdap7wb4RqO7HCBq8hxjF48k9NydMRAKht43xnhB9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rKnsdap7wb4RqO7HCBq8hxjF48k9NydMRAKht43xnhB9A@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 14, 2022 at 06:36:17PM +0530, Kanchan Joshi wrote:
> > And I'm also really worried about only supporting fixed buffers.  Fixed
> > buffers are a really nice benchmarketing feature, but without supporting
> > arbitrary buffers this is rather useless in real life.
> 
> Sorry, I did not get your point on arbitrary buffers.
> The goal has been to match/surpass io_uring's block-io peak perf, so
> pre-mapped buffers had to be added.

I'm completely interesting in adding code to the nvme driver that is
just intended for benchmarketing.  The fixed buffers are nice for
benchmarking and a very small number of real use cases (e.g. fixed size
database log), but for this feature to be generally useful for the real
world we'll need to support arbitrary user memory.
