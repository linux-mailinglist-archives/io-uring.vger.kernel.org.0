Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA825B3ACB
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 16:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiIIOiX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 10:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiIIOiW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 10:38:22 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F6D979DB;
        Fri,  9 Sep 2022 07:38:21 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 641A468AA6; Fri,  9 Sep 2022 16:38:18 +0200 (CEST)
Date:   Fri, 9 Sep 2022 16:38:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Alexander V. Buev" <a.buev@yadro.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com
Subject: Re: [PATCH v4 1/3] block: bio-integrity: add PI iovec to bio
Message-ID: <20220909143818.GA10143@lst.de>
References: <20220909122040.1098696-1-a.buev@yadro.com> <20220909122040.1098696-2-a.buev@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909122040.1098696-2-a.buev@yadro.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 09, 2022 at 03:20:38PM +0300, Alexander V. Buev wrote:
> Added functions to attach user PI iovec pages to bio and release this
> pages via bio_integrity_free.

Before I get into nitpicking on the nitty gritty details:

what is the reason for pinning down the memory for the iovecs here?
Other interfaces like the nvme passthrough code simply copy from
user assuming that the amount of metadata passed will usually be
rather small, and thus faster doing a copy.
