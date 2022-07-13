Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40D4572D7B
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 07:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiGMFlx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 01:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbiGMFlb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 01:41:31 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AB7E026F;
        Tue, 12 Jul 2022 22:36:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 82B0E68AA6; Wed, 13 Jul 2022 07:36:33 +0200 (CEST)
Date:   Wed, 13 Jul 2022 07:36:33 +0200
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
Message-ID: <20220713053633.GA13135@lst.de>
References: <20220711110155.649153-1-joshi.k@samsung.com> <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com> <20220711110155.649153-5-joshi.k@samsung.com> <20220712065250.GA6574@lst.de> <436c8875-5a99-4328-80ac-6a5aef7f16f4@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <436c8875-5a99-4328-80ac-6a5aef7f16f4@grimberg.me>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 12, 2022 at 11:13:57PM +0300, Sagi Grimberg wrote:
> I think the difference from scsi-generic and controller nvme passthru is
> that this is a mpath device node (or mpath chardev). This is why I think
> that users would expect that it would have equivalent multipath
> capabilities (i.e. failover).

How is that different from /dev/sg?

> In general, I think that uring passthru as an alternative I/O interface
> and as such needs to be able to failover. If this is not expected from
> the interface, then why are we exposing a chardev for the mpath device
> node? why not only the bottom namespaces?

The failover will happen when you retry, but we leave that retry to
userspace.  There even is the uevent to tell userspace when a new
path is up.
