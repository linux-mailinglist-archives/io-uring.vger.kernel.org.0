Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA804CB020
	for <lists+io-uring@lfdr.de>; Wed,  2 Mar 2022 21:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiCBUoV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Mar 2022 15:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiCBUoV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Mar 2022 15:44:21 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BFA36B6A;
        Wed,  2 Mar 2022 12:43:37 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so2753935pjb.3;
        Wed, 02 Mar 2022 12:43:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lgYOR0NAjV43r8oYaHMPMronWC+T+uvO+TYbc9ZRf2U=;
        b=Do7KuqMBP/y4oIXCc27REEmmeyXsQ6BpAC2gB6U/LVB2ZNfh4Nh9GmKMZPuFes/YLC
         pHO8uQOYa/PKUaJhi3WDoHy8KcCkLkLZgvHOBnNnqfRzrGEz20DRVGbHUkIIRZWGQeu8
         fzyZDAGiKgkuRZ2dtHZaLS6JzPV4zMF/sygEzbeF+6zvqGtxSzRIEZTFhRfQBIlE7RJF
         9F9iFyjiuHKY1F/mE/XWWByHSumXeQHnLjkI2CPFr/t/5PwZpfOtCNX2x1/qW/0/t33L
         A8k649uAPfZ972Tlr0KQCNp6qHYmmsl+UT0hXzwKmpD7N/O9s7bQ4EvEGLeMaLL2z9NI
         jZIw==
X-Gm-Message-State: AOAM532wr43A/92deLW2TbooI5zAFm1jwDp3LLIoYzl5q46w9sHMXH0W
        tTkJFtYz6r/mm07TRtQWbFcqdUTLcF4=
X-Google-Smtp-Source: ABdhPJyaNbmqlyYCF0pLP/kU5mYs6ZZtG6sJ6Lt4AcJ3790H8g6EdnWM4bXzhCMZArL+GVOyY1Rd0w==
X-Received: by 2002:a17:902:d50b:b0:151:94d9:eeaf with SMTP id b11-20020a170902d50b00b0015194d9eeafmr5879371plg.133.1646253816786;
        Wed, 02 Mar 2022 12:43:36 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
        by smtp.gmail.com with ESMTPSA id k4-20020a17090a910400b001bd171c7fd4sm5933510pjo.25.2022.03.02.12.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 12:43:35 -0800 (PST)
Date:   Wed, 2 Mar 2022 12:43:32 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "hch@infradead.org" <hch@infradead.org>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        "Remzi H. Arpaci-Dusseau" <remzi@cs.wisc.edu>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <20220302204332.dgstbjcpzgiurn5t@garbanzo>
References: <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
 <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org>
 <CA+1E3r+WXC_MK5Zf2OZEv17ddJDjtXbhpRFoeDns4F341xMhow@mail.gmail.com>
 <20200908151801.GA16742@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908151801.GA16742@infradead.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 08, 2020 at 04:18:01PM +0100, hch@infradead.org wrote:
> On Mon, Sep 07, 2020 at 12:31:42PM +0530, Kanchan Joshi wrote:
> > But there are use-cases which benefit from supporting zone-append on
> > raw block-dev path.
> > Certain user-space log-structured/cow FS/DB will use the device that
> > way. Aerospike is one example.
> > Pass-through is synchronous, and we lose the ability to use io-uring.
> 
> So use zonefs, which is designed exactly for that use case.

Using zonefs to test append alone can introduce a slight overhead with
the VFS if we want to do something such as just testing any hot path
with append and the block layer. If we want to live with that, that's
fine!

Just saying.

  Luis
