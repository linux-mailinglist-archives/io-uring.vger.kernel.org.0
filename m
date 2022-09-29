Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405655EF68E
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 15:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiI2N3K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 09:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiI2N24 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 09:28:56 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42DFE11E3;
        Thu, 29 Sep 2022 06:28:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 12BD568BFE; Thu, 29 Sep 2022 15:28:53 +0200 (CEST)
Date:   Thu, 29 Sep 2022 15:28:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH for-next v11 12/13] scsi: Use blk_rq_map_user_io helper
Message-ID: <20220929132852.GF27768@lst.de>
References: <20220929120632.64749-1-anuj20.g@samsung.com> <CGME20220929121713epcas5p1824ed0c48c9e9ceeb18954d9c23564ed@epcas5p1.samsung.com> <20220929120632.64749-13-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929120632.64749-13-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 29, 2022 at 05:36:31PM +0530, Anuj Gupta wrote:
> Use the new blk_rq_map_user_io helper instead of duplicating code at
> various places.

Additionally this also takes advantage of the on-stack iov fast path
which should be mentined here.

Othewise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
