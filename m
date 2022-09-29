Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5275EF68B
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 15:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiI2N24 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 09:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbiI2N21 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 09:28:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF4CE11E3;
        Thu, 29 Sep 2022 06:28:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4F7DB68BFE; Thu, 29 Sep 2022 15:28:11 +0200 (CEST)
Date:   Thu, 29 Sep 2022 15:28:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH for-next v11 11/13] block: add blk_rq_map_user_io
Message-ID: <20220929132811.GE27768@lst.de>
References: <20220929120632.64749-1-anuj20.g@samsung.com> <CGME20220929121709epcas5p325553d10a7ada7717c2f51ddb566a3e5@epcas5p3.samsung.com> <20220929120632.64749-12-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929120632.64749-12-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 29, 2022 at 05:36:30PM +0530, Anuj Gupta wrote:
> Create a helper blk_rq_map_user_io for mapping of vectored as well as
> non-vectored requests. This will help in saving dupilcation of code at few
> places in scsi and nvme.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Suggested-by: Christoph Hellwig <hch@lst.de>

This looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

but it should be early on in this series.  Certainly before the fixebufs
addition, and probably also before the nvme refactoring.
