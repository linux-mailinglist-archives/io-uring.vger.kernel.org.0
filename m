Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B144B2235
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 10:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348748AbiBKJkB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 04:40:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348745AbiBKJj7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 04:39:59 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8373310D5;
        Fri, 11 Feb 2022 01:39:46 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id EE66F47753;
        Fri, 11 Feb 2022 09:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1644572383;
         x=1646386784; bh=LQcbOastj9QBIy1juLvBYG/IfneSfYFuWBe1Eqrfur0=; b=
        VOK8UGz/bM3+KtIcaTXufXxpgsQG/NdrBaJY3VxMFoW4/d3DaBfGMwpjsRG7ntk6
        mIXFmDdoZa+LrHOIfOENdE5WSgdzlvAObl+Ctag6hjsxN/j0E3RAnacqTgsfDxa3
        kJaJ+TRwlehT7LhCNyVfrvsFo4G5ElLAojaBrUOUH00=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CWke-Mc8_V0F; Fri, 11 Feb 2022 12:39:43 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BBB184783D;
        Fri, 11 Feb 2022 12:39:42 +0300 (MSK)
Received: from yadro.com (10.178.114.63) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 11
 Feb 2022 12:39:40 +0300
Date:   Fri, 11 Feb 2022 12:39:38 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>
Subject: Re: [PATCH v2 2/3] block: io_uring: add READV_PI/WRITEV_PI operations
Message-ID: <20220211093938.h2uu5cvaw2hswp3z@yadro.com>
Mail-Followup-To: "Alexander V. Buev" <a.buev@yadro.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com
References: <20220210130825.657520-1-a.buev@yadro.com>
 <20220210130825.657520-3-a.buev@yadro.com>
 <6d505bdc-d687-a9e7-54a1-9a2e662e9707@kernel.dk>
 <20220210190311.driobrtfavnb7ha3@yadro.com>
 <b8082a03-ab50-8a28-b6fd-1bf6985713ec@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <b8082a03-ab50-8a28-b6fd-1bf6985713ec@kernel.dk>
X-Originating-IP: [10.178.114.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On 2/10/22 12:03 PM, Alexander V. Buev wrote:
> >> On 2/10/22 6:08 AM, Alexander V. Buev wrote:
> >>> Added new READV_PI/WRITEV_PI operations to io_uring.
> >>> Added new pi_addr & pi_len fields to SQE struct.
> >>> Added new pi_iter field and IOCB_USE_PI flag to kiocb struct.
> >>> Make corresponding corrections to io uring trace event.
> >>>
> >>> +struct io_rw_pi_state {
> >>> +	struct iov_iter			iter;
> >>> +	struct iov_iter_state		iter_state;
> >>> +	struct iovec			fast_iov[UIO_FASTIOV_PI];
> >>> +};
> >>> +
> >>> +struct io_rw_pi {
> >>> +	struct io_rw			rw;
> >>> +	struct iovec			*pi_iov;
> >>> +	u32				nr_pi_segs;
> >>> +	struct io_rw_pi_state		*s;
> >>> +};
> >>
> >> One immediate issue I see here is that io_rw_pi is big, and we try very
> >> hard to keep the per-command payload to 64-bytes. This would be 88 bytes
> >> by my count :-/
> >>
> >> Do you need everything from io_rw? If not, I'd just make io_rw_pi
> >> contain the bits you need and see if you can squeeze it into the
> >> existing cacheline.
> > 
> > In short - Yes. Current patch code call existing io_read/io_write functions.
> > This functions use io_rw struct information and process this data.
> > I wanted to use existing functions but may be this is wrong way in this 
> > case.
> >                                                                                 
> > The second problem with request size is that the patch adds pi_iter   
> > pointer to kiocb struct. This also increase whole request union
> > length.
> > 
> > So I can see some (may be possible) solution for this: 
> > 
> >  1) do not store whole kiocb struct in request
> >     and write fully separated io_read/write_pi functions
> > 
> >  2) make special CONFIG_XXX variable and simplify hide this code
> >     as default
> 
> Option 2 really sucks, because then obviously everyone wants their
> feature enabled, and then we are back to square one. So never rely on a
> config option, if it can be avoided.
> 
> I'd like to see what option 1 looks like, that sounds like a far better
> solution.
> 
Accepted. I am starting to prepare v3 in this way. 

Thanks to all for feedback!

-- 
Alexander Buev
