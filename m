Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3584951D0EF
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 07:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbiEFF7r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 01:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389281AbiEFF7q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 01:59:46 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47923612A3
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 22:56:04 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5FDB768AA6; Fri,  6 May 2022 07:56:00 +0200 (CEST)
Date:   Fri, 6 May 2022 07:56:00 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "hch@lst.de" <hch@lst.de>, Clay Mayers <Clay.Mayers@kioxia.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>, "shr@fb.com" <shr@fb.com>,
        "joshiiitr@gmail.com" <joshiiitr@gmail.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH v4 3/5] nvme: refactor nvme_submit_user_cmd()
Message-ID: <20220506055600.GA22544@lst.de>
References: <20220505060616.803816-1-joshi.k@samsung.com> <CGME20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994@epcas5p1.samsung.com> <20220505060616.803816-4-joshi.k@samsung.com> <80cde2cfd566454fa4b160492c7336c2@kioxia.com> <ce25812c-9cf4-efe5-ac9e-13afd5803e64@kernel.dk> <93e697b1-42c5-d2f4-8fb8-7b5d1892e871@kernel.dk> <0b16682a30434d9c820a888ae0dc9ac5@kioxia.com> <70c1a8d3-ed82-0a5b-907a-7d6bedd73ccc@kernel.dk> <20220505195039.GA7032@lst.de> <06a03ddf-215a-b558-4ff6-bae46c33d51d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06a03ddf-215a-b558-4ff6-bae46c33d51d@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 05, 2022 at 02:44:40PM -0600, Jens Axboe wrote:
> On 5/5/22 1:50 PM, hch@lst.de wrote:
> > On Thu, May 05, 2022 at 01:31:28PM -0600, Jens Axboe wrote:
> >>>> Jens Axboe
> >>>
> >>> This does work and got me past the null ptr segfault.
> >>
> >> OK good, thanks for testing. I did fold it in.
> > 
> > It might make sense to just kill nvme_meta_from_bio and pass the
> > meta pointer directly with this version of the code.
> 
> Do you want to do an incremental for that? Looking at
> nvme_execute_user_rq() and nvme_uring_task_cb() there's a fair bit of
> duplication of the meta copy.

Yes, there is.  And the right way is to keep the integrity payload alive
longer, but I'm not sure we are going to get that done in time..
