Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8135B3CD8
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 18:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiIIQUL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 12:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiIIQUG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 12:20:06 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A6C47BAB;
        Fri,  9 Sep 2022 09:20:04 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7AA0C57018;
        Fri,  9 Sep 2022 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received
        :received; s=mta-01; t=1662740401; x=1664554802; bh=7t1pkpI3Kyvk
        wk7f3trAVX9nZtHLRyiBTdqTz4+V0iw=; b=Gmi1jgGjnLzDm6aV4O/FSLi6mmQM
        LIEugbBPERS3MyND4dqmwD+3TcEKt5D7hjTGcmB5YGj1oGsj+W4clEWKQHTTQsOg
        zokfoD4OLfZbl85f3rm/6dGi5DN9/+AJkveB/CofieSwqMlEZc9AwcdULTxqrd34
        S5g3dpmg6rEoBU4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZfB7VV8H76WB; Fri,  9 Sep 2022 19:20:01 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 185D556FFB;
        Fri,  9 Sep 2022 19:20:00 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 19:20:00 +0300
Received: from yadro.com (10.199.18.119) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Sep 2022
 19:19:59 +0300
Date:   Fri, 9 Sep 2022 19:19:57 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Pavel Begunkov" <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>
Subject: Re: [PATCH v4 1/3] block: bio-integrity: add PI iovec to bio
Message-ID: <20220909161957.5zhkgmximg6ghxtr@yadro.com>
Mail-Followup-To: "Alexander V. Buev" <a.buev@yadro.com>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com
References: <20220909122040.1098696-1-a.buev@yadro.com>
 <20220909122040.1098696-2-a.buev@yadro.com>
 <20220909143818.GA10143@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220909143818.GA10143@lst.de>
X-Originating-IP: [10.199.18.119]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> «Внимание! Данное письмо от внешнего адресата!»
> 
> On Fri, Sep 09, 2022 at 03:20:38PM +0300, Alexander V. Buev wrote:
> > Added functions to attach user PI iovec pages to bio and release this
> > pages via bio_integrity_free.
> 
> Before I get into nitpicking on the nitty gritty details:
> 
> what is the reason for pinning down the memory for the iovecs here?
> Other interfaces like the nvme passthrough code simply copy from
> user assuming that the amount of metadata passed will usually be
> rather small, and thus faster doing a copy.

In short, for the universality of the solution.
From my point of view we have a data & metadata (PI) 
and process data & PI with the same method.

We also worked with large IO and PI can be greater than PAGE_SIZE.
I think that allocating & copying of data with PAGE_SIZE bytes of length (an in the feature more) 
per one IO is not good idea.
Also any block driver can register it's own integrity profile 
with tuple_size more than 8 or 16 bytes.

May be I am wrong but in the feature we can register some amount buffers
and pin them once at start. This is very same idea as "SELECT BUFFERS" technics but
for vector operations and with PI support.

For now we want to be able make IO with PI to block device
with minimal restriction in interface.

But I think you are right - on small IO it's may be faster to allocate & copy 
instead of pin pages. May be this is point for feature optimization?



-- 
Alexander Buev
