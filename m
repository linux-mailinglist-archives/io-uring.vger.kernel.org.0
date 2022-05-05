Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC92451C0C1
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 15:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379519AbiEENeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 09:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243197AbiEENeK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 09:34:10 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3FB5FB3
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:30:30 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6BE0568AA6; Thu,  5 May 2022 15:30:27 +0200 (CEST)
Date:   Thu, 5 May 2022 15:30:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 3/5] nvme: refactor nvme_submit_user_cmd()
Message-ID: <20220505133026.GB11853@lst.de>
References: <20220505060616.803816-1-joshi.k@samsung.com> <CGME20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994@epcas5p1.samsung.com> <20220505060616.803816-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505060616.803816-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 05, 2022 at 11:36:14AM +0530, Kanchan Joshi wrote:
> +{
> +	struct bio_integrity_payload *bip = bio_integrity(bio);
> +
> +	return bip ? bvec_virt(bip->bip_vec) : NULL;
> +}

Nit, I'd prefer this as the slightly more verbose:

	if (!bip)
		return NULL;
	return bvec_virt(bip->bip_vec);
