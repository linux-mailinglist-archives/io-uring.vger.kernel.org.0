Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D60571289
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 08:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiGLGw4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 02:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiGLGwz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 02:52:55 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B4D8AEC2;
        Mon, 11 Jul 2022 23:52:54 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 394AF68AA6; Tue, 12 Jul 2022 08:52:51 +0200 (CEST)
Date:   Tue, 12 Jul 2022 08:52:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220712065250.GA6574@lst.de>
References: <20220711110155.649153-1-joshi.k@samsung.com> <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com> <20220711110155.649153-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711110155.649153-5-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hmm, I'm a little confused on what this is trying to archive.

The io_uring passthrough already does support multipathing, it picks
an available path in nvme_ns_head_chr_uring_cmd and uses that.

What this does is adding support for requeing on failure or the
lack of an available path.  Which very strongly is against our
passthrough philosophy both in SCSI and NVMe where error handling
is left entirely to the userspace program issuing the I/O.

So this does radically change behavior in a very unexpected way.
Why?
