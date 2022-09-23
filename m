Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F16F5E7E6B
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 17:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiIWPaS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 11:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiIWPaP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 11:30:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02C1ABD7D;
        Fri, 23 Sep 2022 08:30:12 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 45EA267373; Fri, 23 Sep 2022 17:30:10 +0200 (CEST)
Date:   Fri, 23 Sep 2022 17:30:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v8 4/5] block: add helper to map bvec iterator
 for passthrough
Message-ID: <20220923153009.GB21275@lst.de>
References: <20220923092854.5116-1-joshi.k@samsung.com> <CGME20220923093919epcas5p3d019fa1db990101478b8d6673ac0eaa6@epcas5p3.samsung.com> <20220923092854.5116-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923092854.5116-5-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 23, 2022 at 02:58:53PM +0530, Kanchan Joshi wrote:
> Add blk_rq_map_user_bvec which maps the bvec iterator into a bio and
> places that into the request. This helper will be used in nvme for
> uring-passthrough with fixed-buffer.
> While at it, create another helper bio_map_get to reduce the code
> duplication.

As per discussion on the last round - this needs to into
blk_rq_map_user_iov.
