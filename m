Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C93518F88
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 22:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242148AbiECU7N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 16:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242558AbiECU7C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 16:59:02 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DFC18381
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 13:55:26 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8DE4F68B05; Tue,  3 May 2022 22:55:22 +0200 (CEST)
Date:   Tue, 3 May 2022 22:55:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Pankaj Raghav <p.raghav@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v3 4/5] nvme: wire-up uring-cmd support for io-passthru
 on char-device.
Message-ID: <20220503205522.GC9567@lst.de>
References: <20220503184831.78705-1-p.raghav@samsung.com> <CGME20220503184915eucas1p2ae04772900c24ef0b23fd8bedead20ae@eucas1p2.samsung.com> <20220503184831.78705-5-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503184831.78705-5-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 03, 2022 at 08:48:30PM +0200, Pankaj Raghav wrote:
> operation NVME_URING_CMD_IO. This operates on a new structure
> nvme_uring_cmd, which is similiar to struct nvme_passthru_cmd64 but
> without the embedded 8b result field. This is not needed since uring-cmd
> allows to return additional result to user-space via big-CQE.

So let's have a discussion for everyone on whether to reuse the existing
struct or not.

Pros for reusing:

 - any application that is passing around a nvme_passthru_cmd64 doesn't
   need to do special marshalling

Cons:

 - these fields are pointless

I'm fine going either way, we just need to think about the implications.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
