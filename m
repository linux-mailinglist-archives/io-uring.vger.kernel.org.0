Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AC94D4B77
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 16:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243325AbiCJOVo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 09:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245193AbiCJOUu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 09:20:50 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421F210D6;
        Thu, 10 Mar 2022 06:19:49 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7E3C068AFE; Thu, 10 Mar 2022 15:19:45 +0100 (CET)
Date:   Thu, 10 Mar 2022 15:19:45 +0100
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
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Message-ID: <20220310141945.GA890@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com> <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de> <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 10, 2022 at 05:20:13PM +0530, Kanchan Joshi wrote:
> In sync ioctl, we always update this result field by doing put_user on
> completion.
> For async ioctl, since command is inside the the sqe, its lifetime is
> only upto submission. SQE may get reused post submission, leaving no
> way to update the "result" field on completion. Had this field been a
> pointer, we could have saved this on submission and updated on
> completion. But that would require redesigning this structure and
> adding newer ioctl in nvme.

Why would it required adding an ioctl to nvme?  The whole io_uring
async_cmd infrastructure is completely independent from ioctls.

> Coming back, even though sync-ioctl alway updates this result to
> user-space, only a few nvme io commands (e.g. zone-append, copy,
> zone-mgmt-send) can return this additional result (spec-wise).
> Therefore in nvme, when we are dealing with inline-sqe commands from
> io_uring, we never attempt to update the result. And since we don't
> update the result, we limit support to only read/write passthru
> commands. And fail any other command during submission itself (Patch
> 2).

Yikes.  That is outright horrible.  passthrough needs to be command
agnostic and future proof to any newly added nvme command.

> > Overly long line.
> 
> Under 100, but sure, can fold it under 80.

You can only use 100 sparingly if it makes the code more readable.  Which
I know is fuzzy, and in practice never does.  Certainly not in nvme and
block code.
