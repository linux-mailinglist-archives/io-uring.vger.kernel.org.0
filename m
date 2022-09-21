Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2650E5BFAE8
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 11:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiIUJ1X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 05:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiIUJ1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 05:27:18 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC1F8E0F1;
        Wed, 21 Sep 2022 02:27:17 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9AE1941252;
        Wed, 21 Sep 2022 09:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received
        :received; s=mta-01; t=1663752434; x=1665566835; bh=Zo8hxc7svqb4
        BFaKV7Mv5NTNkTTzcrDesurD+cIxjTE=; b=XbnMHwzikvvrwMVzaW637TKfaflG
        tNgDyhAR7ITQjJWiyszQatfFDWEnfr1ljpTMNZmapG8DWIB/s1yPDtHCKcxvRqsm
        WFCXn9qIVfObg0KWQKRlZt+nC5QGeHU5uXEhPMVqtrIwHBEHANnUqTbWcIbka6Yf
        +Gj3uI81xQsJLVw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id n8-Aiz6fb9MR; Wed, 21 Sep 2022 12:27:14 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2B11F41263;
        Wed, 21 Sep 2022 12:26:12 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 21 Sep 2022 12:26:12 +0300
Received: from yadro.com (10.199.18.119) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 21 Sep
 2022 12:26:11 +0300
Date:   Wed, 21 Sep 2022 12:26:09 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     Keith Busch <kbusch@kernel.org>
CC:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>
Subject: Re: [PATCH v5 0/3] implement direct IO with integrity
Message-ID: <20220921092609.m4duniwc6jmfrort@yadro.com>
Mail-Followup-To: "Alexander V. Buev" <a.buev@yadro.com>,
        Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com
References: <20220920144618.1111138-1-a.buev@yadro.com>
 <Yyoer7aEPBWGQCfR@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yyoer7aEPBWGQCfR@kbusch-mbp.dhcp.thefacebook.com>
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

> «Внимание! Данное письмо от внешнего адресата!»
> 
> On Tue, Sep 20, 2022 at 05:46:15PM +0300, Alexander V. Buev wrote:
> > This series of patches makes possible to do direct block IO
> > with integrity payload using io uring kernel interface.
> > Userspace app can utilize new READV_PI/WRITEV_PI operation with a new
> > fields in sqe struct (pi_addr/pi_len) to provide iovec's with
> > integrity data.
> 
> Is this really intended to be used exclusively for PI? Once you give use space
> access to extended metadata regions, they can use it for whatever the user
> wants, which may not be related to protection information formats. Perhaps a
> more generic suffix than "_PI" may be appropriate like _EXT or _META?

Currently we use this code for transfer block IO with meta information 
from user space to special block device driver. This meta information includes PI and some other
information that helps driver to process IO with some optimization, 
special option and etc. In the near feature we can extend this info die to increased
requirements for our product.

Also we can use this code for transfer IO with PI information from user space
to supported block devices such as nvme & scsi.

And you are right. Just for me "_meta" is more appropriate and abstract suffix for this,
but:

 1. "PI" is shortly
 2. "PI" and "integrity" is widely used in block layer code and I decided that
    if it's called PI - everyone understands what exactly it is about.
 3. User can read/write general info only in case of using special block layer driver. 

Anyway I'm ready to rename this things.

May be it's enough to rename only userspace visible part?
(sqe struct members & op codes)


-- 
Alexander V. Buev
