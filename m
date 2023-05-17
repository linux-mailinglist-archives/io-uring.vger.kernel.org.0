Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD898706853
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 14:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjEQMj1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 08:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjEQMj0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 08:39:26 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808EC1BFC;
        Wed, 17 May 2023 05:39:25 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E2BDC68BEB; Wed, 17 May 2023 14:39:21 +0200 (CEST)
Date:   Wed, 17 May 2023 14:39:21 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, kbusch@kernel.org, sagi@grimberg.me,
        joshi.k@samsung.com
Subject: Re: [PATCH for-next 2/2] nvme: optimise io_uring passthrough
 completion
Message-ID: <20230517123921.GA19835@lst.de>
References: <cover.1684154817.git.asml.silence@gmail.com> <ecdfacd0967a22d88b7779e2efd09e040825d0f8.1684154817.git.asml.silence@gmail.com> <20230517072314.GC27026@lst.de> <9367cc09-c8b4-a56c-a61a-d2c776c05a1c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9367cc09-c8b4-a56c-a61a-d2c776c05a1c@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 17, 2023 at 01:32:53PM +0100, Pavel Begunkov wrote:
> 1) ublk does secondary batching and so may produce multiple cqes,
> that's not supported. I believe Ming sent patches removing it,
> but I'd rather not deal with conflicts for now.
>
> 2) Some users may have dependencies b/w requests, i.e. a request
> will only complete when another request's task_work is executed.
>
> 3) There might be use cases when you don't wont it to be delayed,
> IO retries would be a good example. I wouldn't also use it for
> control paths like ublk_ctrl_uring_cmd.

You speak a lot of some users and some cases when the only users
are ublk and nvme, both of which would obviously benefit.

If you don't want conflicts wait for Ming to finish his work
and then we can do this cleanly and without leaving dead code
around.
