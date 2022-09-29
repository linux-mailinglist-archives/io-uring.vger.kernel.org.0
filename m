Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9335EF679
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 15:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiI2N02 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 09:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiI2N0D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 09:26:03 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA500EDD15;
        Thu, 29 Sep 2022 06:26:02 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7800E68BFE; Thu, 29 Sep 2022 15:25:59 +0200 (CEST)
Date:   Thu, 29 Sep 2022 15:25:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH for-next v11 05/13] block: rename bio_map_put to
 blk_mq_map_bio_put
Message-ID: <20220929132559.GB27768@lst.de>
References: <20220929120632.64749-1-anuj20.g@samsung.com> <CGME20220929121647epcas5p2d4ca8ae0b83a1fce230914f586ee3cc0@epcas5p2.samsung.com> <20220929120632.64749-6-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929120632.64749-6-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
