Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932A0520EB5
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 09:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbiEJHih (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 03:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240788AbiEJHYN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 03:24:13 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9B246B39
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 00:20:16 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B4A6F68BEB; Tue, 10 May 2022 09:20:11 +0200 (CEST)
Date:   Tue, 10 May 2022 09:20:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: Re: [PATCH v4 0/5] io_uring passthrough for nvme
Message-ID: <20220510072011.GA11929@lst.de>
References: <CGME20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c@epcas5p2.samsung.com> <20220505060616.803816-1-joshi.k@samsung.com> <d99a828b-94ed-97a0-8430-cfb49dd56b74@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d99a828b-94ed-97a0-8430-cfb49dd56b74@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 05, 2022 at 12:20:37PM -0600, Jens Axboe wrote:
> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
> > This iteration is against io_uring-big-sqe brach (linux-block).
> > On top of a739b2354 ("io_uring: enable CQE32").
> > 
> > fio testing branch:
> > https://github.com/joshkan/fio/tree/big-cqe-pt.v4
> 
> I folded in the suggested changes, the branch is here:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-passthrough
> 
> I'll try and run the fio test branch, but please take a look and see what
> you think.

I think what is in the branch now looks pretty good.  Can either of you
two send it out to the lists for a final review pass?
