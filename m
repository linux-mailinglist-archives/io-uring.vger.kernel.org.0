Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3532751F45D
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 08:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiEIGLl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 02:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbiEIGEj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 02:04:39 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85CE8073E
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 23:00:45 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 60DD968AFE; Mon,  9 May 2022 08:00:11 +0200 (CEST)
Date:   Mon, 9 May 2022 08:00:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru
 on char-device.
Message-ID: <20220509060010.GA16939@lst.de>
References: <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk> <20220505134256.GA13109@lst.de> <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk> <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk> <20220506082844.GA30405@lst.de> <6b0811df-e2a4-22fc-7615-44e5615ce6a4@kernel.dk> <20220506145058.GA24077@lst.de> <45b5f76b-b186-e0b9-7b24-e048f73942d5@kernel.dk> <20220507050317.GA27706@lst.de> <d315712a-0792-d15f-040d-3a3922700a53@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d315712a-0792-d15f-040d-3a3922700a53@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, May 07, 2022 at 06:53:30AM -0600, Jens Axboe wrote:
> How about we just add a comment? We use it in two spots, but one has
> knowledge of the sqe64 vs sqe128 state, the other one does not. Hence
> not sure how best to add a helper for this. One also must be a compile
> time constant. Best I can think of is the below. Not the prettiest, but
> it does keep it in one spot and with a single comment rather than in two
> spots.

If you think just a comment is better I can live with that, also the
proposed macro also looks fine to me.
