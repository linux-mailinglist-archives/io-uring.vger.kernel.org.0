Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C118522CAB
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 08:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiEKGya (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 02:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbiEKGy3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 02:54:29 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8878B243105
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 23:54:27 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BAAE368C4E; Wed, 11 May 2022 08:54:23 +0200 (CEST)
Date:   Wed, 11 May 2022 08:54:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v5 6/6] io_uring: finish IOPOLL/ioprio prep handler
 removal
Message-ID: <20220511065423.GA814@lst.de>
References: <20220511054750.20432-1-joshi.k@samsung.com> <CGME20220511055320epcas5p2457aaf8e7405387282f60831f5a4eca9@epcas5p2.samsung.com> <20220511054750.20432-7-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511054750.20432-7-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I think this should go first, and the uring_cmd bits need to do the
right thing from the beginning.

On Wed, May 11, 2022 at 11:17:50AM +0530, Kanchan Joshi wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> Commit 73911426aaaa unified the checking of this, but was done before we
> had a few new opcode handlers.

Also please quote the actual commit subject as well here per the usual
Fixes-like refernence style.
