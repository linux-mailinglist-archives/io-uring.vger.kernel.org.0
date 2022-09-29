Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1035EF670
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 15:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiI2N0N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 09:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiI2NZp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 09:25:45 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1F86554F;
        Thu, 29 Sep 2022 06:25:42 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B78D268BFE; Thu, 29 Sep 2022 15:25:38 +0200 (CEST)
Date:   Thu, 29 Sep 2022 15:25:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH for-next v11 04/13] nvme: refactor nvme_alloc_request
Message-ID: <20220929132538.GA27768@lst.de>
References: <20220929120632.64749-1-anuj20.g@samsung.com> <CGME20220929121643epcas5p4c58f6ebb794bde58981272cd33c69f9f@epcas5p4.samsung.com> <20220929120632.64749-5-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929120632.64749-5-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 29, 2022 at 05:36:23PM +0530, Anuj Gupta wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> nvme_alloc_request expects a large number of parameters.
> Split this out into two functions to reduce number of parameters.
> First one retains the name nvme_alloc_request, while second one is
> named nvme_map_user_request.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
