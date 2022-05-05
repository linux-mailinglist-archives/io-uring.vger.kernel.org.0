Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9B851C115
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 15:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377741AbiEENql (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 09:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237055AbiEENqk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 09:46:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DD557158
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:43:00 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C01F768AA6; Thu,  5 May 2022 15:42:56 +0200 (CEST)
Date:   Thu, 5 May 2022 15:42:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru
 on char-device.
Message-ID: <20220505134256.GA13109@lst.de>
References: <20220505060616.803816-1-joshi.k@samsung.com> <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com> <20220505060616.803816-5-joshi.k@samsung.com> <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 05, 2022 at 07:38:31AM -0600, Jens Axboe wrote:
> > +	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(cmd->addr),
> > +			cmd->data_len, nvme_to_user_ptr(cmd->metadata),
> > +			cmd->metadata_len, 0, cmd->timeout_ms ?
> > +			msecs_to_jiffies(cmd->timeout_ms) : 0, 0, rq_flags,
> > +			blk_flags);
> 
> You need to be careful with reading/re-reading the shared memory. For
> example, you do:

Uh, yes.  With ioucmd->cmd pointing to the user space mapped SQ
we need to be very careful here.  To the point where I'd almost prfer
to memcpy it out first, altough there might be performance implications.

On something unrelated while looking over the code again:  the cast
when asssigning cmd in nvme_uring_cmd_io should not be needed any more.

