Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1514A573562
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 13:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiGML24 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 07:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbiGML2y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 07:28:54 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C9E29CAF;
        Wed, 13 Jul 2022 04:28:49 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3B61267373; Wed, 13 Jul 2022 13:28:46 +0200 (CEST)
Date:   Wed, 13 Jul 2022 13:28:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220713112845.GA780@lst.de>
References: <20220711110155.649153-1-joshi.k@samsung.com> <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com> <20220711110155.649153-5-joshi.k@samsung.com> <20220712065250.GA6574@lst.de> <436c8875-5a99-4328-80ac-6a5aef7f16f4@grimberg.me> <20220713053633.GA13135@lst.de> <24f0a3e6-aa53-8c69-71b7-d66289a63eae@grimberg.me> <20220713101235.GA27815@lst.de> <772b461a-bc43-c229-906d-0e280091e17f@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <772b461a-bc43-c229-906d-0e280091e17f@grimberg.me>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 13, 2022 at 02:00:56PM +0300, Sagi Grimberg wrote:
> I view uring passthru somewhat as a different thing than sending SG_IO
> ioctls to dm-mpath. But it can be argued otherwise.
>
> BTW, the only consumer of it that I'm aware of commented that he
> expects dm-mpath to retry SG_IO when dm-mpath retry for SG_IO submission
> was attempted (https://www.spinics.net/lists/dm-devel/msg46924.html).

Yeah.  But the point is that if we have a path failure, the kernel
will pick a new path next time anyway, both in dm-mpath and nvme-mpath.

> I still think that there is a problem with the existing semantics for
> passthru requests over mpath device nodes.
>
> Again, I think it will actually be cleaner not to expose passthru
> devices for mpath at all if we are not going to support retry/failover.

I think they are very useful here.  Users of passthrough interface
need to be able to retry anyway, even on non-multipath setups.  And
a dumb retry will do the right thing.
