Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0784D66A0
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 17:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350423AbiCKQoh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 11:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236353AbiCKQog (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 11:44:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB39E17BC48;
        Fri, 11 Mar 2022 08:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NopFJbqdz3k/t/PgQ+v4eLqHiQWYYU5ZglRx8JUL8HA=; b=rXa+yTCicdMNJOtnaYJbXIbh4s
        NmUxvslF776Mle0p3sYZ26+x2IYEQLmnqkmyTazdab8D4wByJuq4qnsf4rjOAzK53vy+a2cHWwWJz
        /LEAfXkm+Xwd8VMk3RduJNGYOtBJ/hn2ElIw4TMTBTEoJ0ModY6FCgxBoeLbcAunjHxk9YtThVgGn
        1D44I79t2DOIwRaep11CfPdkKuSjh9hLHmIlrFLdtCpBEEP209mabfVjELcWueTw27w5BVBIW32ei
        Cs9GHRvkIGoNI02zM4U4WzxwWS7gHSfxeaYKmd6oSMYi4JJ2gyvqHOu7fa23Izr85q/VWNotYTtxL
        iyNk/P/g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSiMO-00HNRj-AL; Fri, 11 Mar 2022 16:43:24 +0000
Date:   Fri, 11 Mar 2022 08:43:24 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 00/17] io_uring passthru over nvme
Message-ID: <Yit8LFAMK3t0nY/q@bombadil.infradead.org>
References: <CGME20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696@epcas5p1.samsung.com>
 <20220308152105.309618-1-joshi.k@samsung.com>
 <20220310082926.GA26614@lst.de>
 <CA+1E3rJ17F0Rz5UKUnW-LPkWDfPHXG5aeq-ocgNxHfGrxYtAuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJ17F0Rz5UKUnW-LPkWDfPHXG5aeq-ocgNxHfGrxYtAuw@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 10, 2022 at 03:35:02PM +0530, Kanchan Joshi wrote:
> On Thu, Mar 10, 2022 at 1:59 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > What branch is this against?
> Sorry I missed that in the cover.
> Two options -
> (a) https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-big-sqe
> first patch ("128 byte sqe support") is already there.
> (b) for-next (linux-block), series will fit on top of commit 9e9d83faa
> ("io_uring: Remove unneeded test in io_run_task_work_sig")
> 
> > Do you have a git tree available?
> Not at the moment.
> 
> @Jens: Please see if it is possible to move patches to your
> io_uring-big-sqe branch (and maybe rename that to big-sqe-pt.v1).

Since Jens might be busy, I've put up a tree with all this stuff:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20220311-io-uring-cmd

It is based on option (b) mentioned above, I took linux-block for-next
and reset the tree to commit "io_uring: Remove unneeded test in
io_run_task_work_sig" before applying the series.

  Luis
