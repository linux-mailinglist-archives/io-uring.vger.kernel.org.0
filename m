Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E084B15BC
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiBJTDT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Feb 2022 14:03:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343596AbiBJTDS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Feb 2022 14:03:18 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48463191;
        Thu, 10 Feb 2022 11:03:19 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B3AC647536;
        Thu, 10 Feb 2022 19:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1644519796;
         x=1646334197; bh=YfoHBazeBT8XZXrlGncvASdPnFAnnIpq46X6AOyi/rQ=; b=
        ldAk3C7LIYTMAF2aJ7bEhkPpC3/5eNAS9sb9MQhroyqG9IybBB/AvLqN4I1tMTAV
        MTcFYAwt7/JMVRaEQ3jexGcKBvsmUDhHb+z4NU8iKJW7RltZxk3B13A9C4psbt17
        bCGrtJc8vME5RiPfqhW+8n8sAkIpIf0ipyKTBqsSxM8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6WystcSTyc2L; Thu, 10 Feb 2022 22:03:16 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A392C470B0;
        Thu, 10 Feb 2022 22:03:15 +0300 (MSK)
Received: from yadro.com (10.178.114.63) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 10
 Feb 2022 22:03:13 +0300
Date:   Thu, 10 Feb 2022 22:03:11 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>
Subject: Re: [PATCH v2 2/3] block: io_uring: add READV_PI/WRITEV_PI operations
Message-ID: <20220210190311.driobrtfavnb7ha3@yadro.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <6d505bdc-d687-a9e7-54a1-9a2e662e9707@kernel.dk>
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

> On 2/10/22 6:08 AM, Alexander V. Buev wrote:
> > Added new READV_PI/WRITEV_PI operations to io_uring.
> > Added new pi_addr & pi_len fields to SQE struct.
> > Added new pi_iter field and IOCB_USE_PI flag to kiocb struct.
> > Make corresponding corrections to io uring trace event.
> > 
> > +struct io_rw_pi_state {
> > +	struct iov_iter			iter;
> > +	struct iov_iter_state		iter_state;
> > +	struct iovec			fast_iov[UIO_FASTIOV_PI];
> > +};
> > +
> > +struct io_rw_pi {
> > +	struct io_rw			rw;
> > +	struct iovec			*pi_iov;
> > +	u32				nr_pi_segs;
> > +	struct io_rw_pi_state		*s;
> > +};
> 
> One immediate issue I see here is that io_rw_pi is big, and we try very
> hard to keep the per-command payload to 64-bytes. This would be 88 bytes
> by my count :-/
> 
> Do you need everything from io_rw? If not, I'd just make io_rw_pi
> contain the bits you need and see if you can squeeze it into the
> existing cacheline.

In short - Yes. Current patch code call existing io_read/io_write functions.
This functions use io_rw struct information and process this data.
I wanted to use existing functions but may be this is wrong way in this 
case.
                                                                                
The second problem with request size is that the patch adds pi_iter   
pointer to kiocb struct. This also increase whole request union
length.

So I can see some (may be possible) solution for this: 

 1) do not store whole kiocb struct in request
    and write fully separated io_read/write_pi functions

 2) make special CONFIG_XXX variable and simplify hide this code
    as default

Any other variants?



-- 
Alexander Buev
