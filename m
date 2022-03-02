Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4E94CB02F
	for <lists+io-uring@lfdr.de>; Wed,  2 Mar 2022 21:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244230AbiCBUsl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Mar 2022 15:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiCBUsj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Mar 2022 15:48:39 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EA13BBC8;
        Wed,  2 Mar 2022 12:47:54 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id s1so2595496plg.12;
        Wed, 02 Mar 2022 12:47:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/8RzJI/cV5QLUaK7OFWN4qtubroSrlMbLOdRPpIyWFQ=;
        b=U/benTwITi48kAs3XKBcYSLSExoN8Ti8b3oerB4sNOEr5ZeQZdpPYq0Rrlaw7cCIj0
         LD0TIlUc2wGkBZFbWkzgxPcXsCcdt0l8CY0rWDx5DFjhnGhXj9Mt3Oa7zUMDD60pdJEy
         FjY79a4tuMcVonDlpVyuTL1hQwPDw+lxbkOq/qAwIR18szKUgISbxAOfjqaHiQhobHdJ
         mtIhJ17xyApwbDD2Sbngxv9XfRXHTPQYqNEOBUNiAbivGAfjlA/QSeQ2+d7WPj9+LKM+
         dzc1TiIQLCevnCs55moywtVG4dXNxoenS7Y9ya6ctuoyf5lvUQ8JkmxcyL4uWFtYOSOE
         kVzg==
X-Gm-Message-State: AOAM530sVtdmUce82nO9KGXyPSuefxN8Kat4tGtRuUnQ4/xYL8qrhRiQ
        yYNUrFLOyWRRre5GmURxYhI=
X-Google-Smtp-Source: ABdhPJxmupNHujhiGV8P8/41cjzWqCEh3zk4qKmxMoCyV6RrPawt20cUfWrygRx3Lca72CdYHeMo9Q==
X-Received: by 2002:a17:903:248:b0:14f:139f:191f with SMTP id j8-20020a170903024800b0014f139f191fmr32545625plh.71.1646254074201;
        Wed, 02 Mar 2022 12:47:54 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
        by smtp.gmail.com with ESMTPSA id lr11-20020a17090b4b8b00b001bc4098fa78sm6483516pjb.24.2022.03.02.12.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 12:47:53 -0800 (PST)
Date:   Wed, 2 Mar 2022 12:47:50 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "hch@infradead.org" <hch@infradead.org>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Kanchan Joshi <joshiiitr@gmail.com>,
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
Message-ID: <20220302204750.e3vt3w5uggd35x3a@garbanzo>
References: <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
 <20200731130802.GA16665@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731130802.GA16665@infradead.org>
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

On Fri, Jul 31, 2020 at 02:08:02PM +0100, hch@infradead.org wrote:
> And FYI, this is what I'd do for a hacky aio-only prototype (untested):

So... are we OK with an aio-only approach (instead of using io-uring)
for raw access to append?

  Luis
