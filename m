Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE5751E437
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 07:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379498AbiEGFHT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 01:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356601AbiEGFHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 01:07:08 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83155C862
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 22:03:21 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D82F668AFE; Sat,  7 May 2022 07:03:17 +0200 (CEST)
Date:   Sat, 7 May 2022 07:03:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru
 on char-device.
Message-ID: <20220507050317.GA27706@lst.de>
References: <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com> <20220505060616.803816-5-joshi.k@samsung.com> <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk> <20220505134256.GA13109@lst.de> <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk> <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk> <20220506082844.GA30405@lst.de> <6b0811df-e2a4-22fc-7615-44e5615ce6a4@kernel.dk> <20220506145058.GA24077@lst.de> <45b5f76b-b186-e0b9-7b24-e048f73942d5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45b5f76b-b186-e0b9-7b24-e048f73942d5@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Getting back to this after a good night's worth of sleep:

On Fri, May 06, 2022 at 08:57:53AM -0600, Jens Axboe wrote:
> > Just add this:
> > 
> > "Add a small helper to act as the counterpart to nvme_add_user_metadata."
> > 
> > with my signoff:
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Both done, thanks.

I think we're much better of folding "nvme: add nvme_finish_user_metadata
helper" into "nvme: refactor nvme_submit_user_cmd()" as the first basically
just redos the split done in the first patch in a more fine grained way
to allow sharing some of the metadata end I/O code with the uring path,
and basically only touches code changes in the first patch again.

> >> I did not do your async_size changes, I think you're jetlagged eyes
> >> missed that this isn't a sizeof thing on a flexible array, it's just the
> >> offset of it. Hence for non-sqe128, the the async size is io_uring_sqe -
> >> offsetof where pdu starts, and so forth.
> > 
> > Hmm, this still seems a bit odd to me.  So without sqe128 you don't even
> > get the cmd data that would fit into the 64-bit SQE?
> 
> You do. Without sqe128, you get sizeof(sqe) - offsetof(cmd) == 16 bytes.
> With, you get 16 + 64, 80.

Can we please get a little documented helper that does this instead of
the two open coded places?
