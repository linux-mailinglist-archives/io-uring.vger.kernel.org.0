Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF72E51D36B
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389909AbiEFIce (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 04:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386333AbiEFIce (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 04:32:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBC2522D8
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 01:28:51 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 73B1A68AFE; Fri,  6 May 2022 10:28:44 +0200 (CEST)
Date:   Fri, 6 May 2022 10:28:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru
 on char-device.
Message-ID: <20220506082844.GA30405@lst.de>
References: <20220505060616.803816-1-joshi.k@samsung.com> <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com> <20220505060616.803816-5-joshi.k@samsung.com> <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk> <20220505134256.GA13109@lst.de> <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk> <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 05, 2022 at 11:23:01AM -0600, Jens Axboe wrote:
> The top three patches here have a proposed solution for the 3 issues
> that I highlighted:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-passthrough
> 
> Totally untested... Kanchan, can you take a look and see what you think?
> They all need folding obviously, I just tried to do them separately.
> Should also get tested :-)

I've also pushed out a tree based on this, which contains my little
fixups that I'd suggest to be folded.  Totally untested and written
while jetlagged:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/io_uring-passthrough

Note that while I tried to keep all my changes in separate patches, the
main passthrough patch had conflicts during a rebase, which I had to
fix up, but I tried to touch as little as possible.
