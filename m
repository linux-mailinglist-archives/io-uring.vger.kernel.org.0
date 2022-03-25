Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95B4E6DCF
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 06:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbiCYFkd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 01:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiCYFkc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 01:40:32 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E871D1EEDE;
        Thu, 24 Mar 2022 22:38:59 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 009BE68B05; Fri, 25 Mar 2022 06:38:55 +0100 (CET)
Date:   Fri, 25 Mar 2022 06:38:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 11/17] block: factor out helper for bio allocation from
 cache
Message-ID: <20220325053855.GA5344@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152716epcas5p3d38d2372c184259f1a10c969f7e4396f@epcas5p3.samsung.com> <20220308152105.309618-12-joshi.k@samsung.com> <20220310083503.GE26614@lst.de> <CA+1E3rLF7D4jThUPZYbxpXs9LLdQ7Ek=Qy+rXZE=xgwBcLoaWQ@mail.gmail.com> <20220324063011.GA12660@lst.de> <CA+1E3rJAK9fPuS6g_po_vpvde_LpOjkuoU=E5h=v9rnHhc3+mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJAK9fPuS6g_po_vpvde_LpOjkuoU=E5h=v9rnHhc3+mw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 24, 2022 at 11:15:20PM +0530, Kanchan Joshi wrote:
> Thanks, that can be reused here too. But to enable this feature - we
> need to move to a bioset from bio_kmalloc in nvme, and you did not
> seem fine with that.

Yeah, kmalloc already does percpu caches, so we don't even need it.
