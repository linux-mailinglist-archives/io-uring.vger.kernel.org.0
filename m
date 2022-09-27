Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783285EBBDF
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 09:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiI0Hrk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 03:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiI0Hrf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 03:47:35 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C067AC0B;
        Tue, 27 Sep 2022 00:47:32 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A0DFA68AA6; Tue, 27 Sep 2022 09:47:28 +0200 (CEST)
Date:   Tue, 27 Sep 2022 09:47:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Alexander V. Buev" <a.buev@yadro.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com
Subject: Re: [PATCH v5 1/3] block: bio-integrity: add PI iovec to bio
Message-ID: <20220927074728.GB17819@lst.de>
References: <20220920144618.1111138-1-a.buev@yadro.com> <20220920144618.1111138-2-a.buev@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920144618.1111138-2-a.buev@yadro.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 20, 2022 at 05:46:16PM +0300, Alexander V. Buev wrote:
> Added functions to attach user PI iovec pages to bio and release this
> pages via bio_integrity_free.

I'd much prefer if for the first version we could just go down the
copy_from/to_user route as mentioned below and avoid the extra
complexity of the get_user_pages path.  Once we get the interface
right we can consider adding the get_user_pages version back if
we have benchmarks for relevant workloads that justify it.  In that
case we'll also need into refactoring thing so that more code is
shared with the bio data path.
