Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DC15733E6
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 12:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiGMKMl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 06:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiGMKMk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 06:12:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1A6F789B;
        Wed, 13 Jul 2022 03:12:39 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7CBD167373; Wed, 13 Jul 2022 12:12:35 +0200 (CEST)
Date:   Wed, 13 Jul 2022 12:12:35 +0200
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
Message-ID: <20220713101235.GA27815@lst.de>
References: <20220711110155.649153-1-joshi.k@samsung.com> <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com> <20220711110155.649153-5-joshi.k@samsung.com> <20220712065250.GA6574@lst.de> <436c8875-5a99-4328-80ac-6a5aef7f16f4@grimberg.me> <20220713053633.GA13135@lst.de> <24f0a3e6-aa53-8c69-71b7-d66289a63eae@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24f0a3e6-aa53-8c69-71b7-d66289a63eae@grimberg.me>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 13, 2022 at 11:04:31AM +0300, Sagi Grimberg wrote:
> Maybe the solution is to just not expose a /dev/ng for the mpath device
> node, but only for bottom namespaces. Then it would be completely
> equivalent to scsi-generic devices.
>
> It just creates an unexpected mix of semantics of best-effort
> multipathing with just path selection, but no requeue/failover...

Which is exactly the same semanics as SG_IO on the dm-mpath nodes.

> If the user needs to do the retry, discover and understand namespace
> paths, ANA states, controller states, etc. Why does the user need a
> mpath chardev at all?

The user needs to do that for all kinds of other resons anyway,
as we don't do any retries for passthrough at all.
