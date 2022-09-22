Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88ADF5E62BE
	for <lists+io-uring@lfdr.de>; Thu, 22 Sep 2022 14:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiIVMs4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Sep 2022 08:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiIVMsz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Sep 2022 08:48:55 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E682B24B3;
        Thu, 22 Sep 2022 05:48:53 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0976E40418;
        Thu, 22 Sep 2022 12:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1663850930; x=1665665331; bh=1oTTLOVpNbb59fNrT4bLbmXqUOOFkWyDmNS
        tFQJjWsY=; b=OxyZVAHSNb4N4uBmgadpoko/FuYsetRvK5Sdo/9xLGsP1e7GCtl
        xiUKwBf8NjOfkDf3SPSkMS8CgeDJ2fN+arhjsMabL6Q8Tr49B9U7NJOtPWwJzhMZ
        /bPMHdkUjiSrhDZ5MPHuSJ9eSvvmAa4oGAl5rOy1r8OCGgWtsQODZ0og=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nAxnMvok_hvf; Thu, 22 Sep 2022 15:48:50 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D1EE140354;
        Thu, 22 Sep 2022 15:48:49 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 22 Sep 2022 15:48:49 +0300
Received: from yadro.com (10.199.18.119) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 22 Sep
 2022 15:48:48 +0300
Date:   Thu, 22 Sep 2022 15:48:46 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>
Subject: Re: [PATCH v5 2/3] block: io-uring: add READV_PI/WRITEV_PI operations
Message-ID: <20220922124846.d4mhaugyd4is7gd5@yadro.com>
Mail-Followup-To: "Alexander V. Buev" <a.buev@yadro.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com
References: <20220920144618.1111138-1-a.buev@yadro.com>
 <20220920144618.1111138-3-a.buev@yadro.com>
 <54666720-609b-c639-430d-1dc61e96a6c6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <54666720-609b-c639-430d-1dc61e96a6c6@kernel.dk>
X-Originating-IP: [10.199.18.119]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> In general, I think this feature is useful. I do echo Keith's response
> that it should probably be named a bit differently, as PI is just one
> use case of this.
Accepted. 
In the next version, this suffix "pi" will be renamed to "meta"
(meta_addr, meta_len, READV_META, WRITEV_META and etc...)


> But for this patch in particular, not a huge fan of the rote copying of
> rw.c into a new file. Now we have to patch two different spots whenever
> a bug is found in there, that's not very maintainable. I do appreciate
> the fact that this keeps the PI work out of the fast path for
> read/write, but I do think this warrants a bit of refactoring work first
> to ensure that there are helpers that can be shared between rw and
> rw_pi. That definitely needs to be solved before this can be considered
> for inclusion.
I think it would be better to move some of the shared code to another file. 
For example "rw_common.[ch]". What do you think about?
As an alternative I can leave such code in "rw.[ch]" file as is.

-- 
Alexander V. Buev
