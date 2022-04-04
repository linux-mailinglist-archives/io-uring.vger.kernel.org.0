Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FCA4F0FCC
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 09:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350172AbiDDHLI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 03:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiDDHLI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 03:11:08 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B6E381BA
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 00:09:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3961268AFE; Mon,  4 Apr 2022 09:09:10 +0200 (CEST)
Date:   Mon, 4 Apr 2022 09:09:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, pankydev8@gmail.com,
        javier@javigon.com, joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [RFC 2/5] fs: add file_operations->async_cmd()
Message-ID: <20220404070910.GB444@lst.de>
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110833epcas5p18e828a307a646cef5b7aa429be4396e0@epcas5p1.samsung.com> <20220401110310.611869-3-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401110310.611869-3-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 01, 2022 at 04:33:07PM +0530, Kanchan Joshi wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> This is a file private handler, similar to ioctls but hopefully a lot
> more sane and useful.

Without the next patch this is rather pointless (and confusing), so
I'd suggest to move it into that.

>  	int (*fadvise)(struct file *, loff_t, loff_t, int);
> +	int (*async_cmd)(struct io_uring_cmd *ioucmd);

Given that it takes a io_uring_cmd argument I also thnink that the
name is a bit misleading.  Caling this uring_cmd or io_uring_cmd
would be more descriptive.
