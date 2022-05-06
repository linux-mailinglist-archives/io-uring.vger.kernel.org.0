Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348B051DB1B
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 16:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378537AbiEFOyr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 10:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442466AbiEFOyr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 10:54:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73668201B9
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 07:51:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3A06468AFE; Fri,  6 May 2022 16:50:58 +0200 (CEST)
Date:   Fri, 6 May 2022 16:50:58 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru
 on char-device.
Message-ID: <20220506145058.GA24077@lst.de>
References: <20220505060616.803816-1-joshi.k@samsung.com> <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com> <20220505060616.803816-5-joshi.k@samsung.com> <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk> <20220505134256.GA13109@lst.de> <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk> <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk> <20220506082844.GA30405@lst.de> <6b0811df-e2a4-22fc-7615-44e5615ce6a4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b0811df-e2a4-22fc-7615-44e5615ce6a4@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 06, 2022 at 07:37:55AM -0600, Jens Axboe wrote:
> Folded most of it, but I left your two meta data related patches as
> separate as I they really should be separate. However, they need a
> proper commit message and signed-off-by from you. It's these two:
> 
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring-passthrough&id=b855a4458068722235bdf69688448820c8ddae8e

This one should be folded into "nvme: refactor nvme_submit_user_cmd()",
which is the patch just before it that adds nvme_meta_from_bio.

> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring-passthrough&id=2be698bdd668daeb1aad2ecd516484a62e948547

Just add this:

"Add a small helper to act as the counterpart to nvme_add_user_metadata."

with my signoff:

Signed-off-by: Christoph Hellwig <hch@lst.de>

> I did not do your async_size changes, I think you're jetlagged eyes
> missed that this isn't a sizeof thing on a flexible array, it's just the
> offset of it. Hence for non-sqe128, the the async size is io_uring_sqe -
> offsetof where pdu starts, and so forth.

Hmm, this still seems a bit odd to me.  So without sqe128 you don't even
get the cmd data that would fit into the 64-bit SQE?
