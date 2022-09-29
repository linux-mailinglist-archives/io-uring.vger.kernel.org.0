Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A306A5EF687
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 15:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiI2N2T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 09:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbiI2N1m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 09:27:42 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0666211E97E;
        Thu, 29 Sep 2022 06:27:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4EE9B68C4E; Thu, 29 Sep 2022 15:27:12 +0200 (CEST)
Date:   Thu, 29 Sep 2022 15:27:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH for-next v11 09/13] nvme: pass ubuffer as an integer
Message-ID: <20220929132712.GD27768@lst.de>
References: <20220929120632.64749-1-anuj20.g@samsung.com> <CGME20220929121701epcas5p287a6d3f851626a5c7580d9a534432e9b@epcas5p2.samsung.com> <20220929120632.64749-10-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929120632.64749-10-anuj20.g@samsung.com>
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
