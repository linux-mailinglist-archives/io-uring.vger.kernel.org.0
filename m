Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34083518F73
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 22:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbiECU4i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 16:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbiECU4h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 16:56:37 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACF333A3B
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 13:53:04 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 80F9168AFE; Tue,  3 May 2022 22:53:01 +0200 (CEST)
Date:   Tue, 3 May 2022 22:53:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Pankaj Raghav <p.raghav@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, gost.dev@samsung.com
Subject: Re: [PATCH v3 2/5] block: wire-up support for passthrough plugging
Message-ID: <20220503205301.GB9567@lst.de>
References: <20220503184831.78705-1-p.raghav@samsung.com> <CGME20220503184913eucas1p156abb6e2273c8dabc22e87ec8b218a5c@eucas1p1.samsung.com> <20220503184831.78705-3-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503184831.78705-3-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +	if (plug) {
> +		blk_add_rq_to_plug(plug, rq);
> +	} else {

I'd just do an eary return after the blk_add_rq_to_plug call and leave
the rest of the code untouched and unindented.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
