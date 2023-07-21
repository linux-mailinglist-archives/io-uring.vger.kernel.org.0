Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8575675CCC0
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjGUPzf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjGUPzd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:55:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D517F30FF;
        Fri, 21 Jul 2023 08:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61B7C61D1C;
        Fri, 21 Jul 2023 15:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05E4C433C8;
        Fri, 21 Jul 2023 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689954906;
        bh=l/t/aumKMOLUaBETZDV2N+Dl+d/K5rMYsOQZF20MaKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aRz0ttqgUHkeyg2MOrKz5yWUoWwhzXwpO/popkTxd2hN1p6WNWADv4Pw1W5t8MXUj
         VCvbUzBLysKllQ3WIxd3QxTgfehyl8+A7UiMERcXUSxOCLIzY5WQ0m/6u6IC42AalM
         V6n39KyH/WLHy13mJzdVPMqx8stRwf/fL6CHvAg3PA6UKqtZnEitjg95pdtgRmFXP5
         o95btKthIk3LESScsiDCJDbn55GpzqsVWgnrBMK3BV4KIoPk7OGVgUUNtG1t3v+i3s
         pq6nxfPuYlAzLbtYDUqC0NKlX9VvYzw7pa61enMo3trfmdG8/RmZ9nClb9fLiue8J0
         upcK+KvkfD1WQ==
Date:   Fri, 21 Jul 2023 08:55:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        linux-xfs@vger.kernel.org, andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 3/8] iomap: treat a write through cache the same as FUA
Message-ID: <20230721155506.GQ11352@frogsfrogsfrogs>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-4-axboe@kernel.dk>
 <20230721061554.GC20600@lst.de>
 <5b14e30b-1a22-b5fe-1a21-531397b94b16@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b14e30b-1a22-b5fe-1a21-531397b94b16@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 21, 2023 at 08:04:19AM -0600, Jens Axboe wrote:
> On 7/21/23 12:15?AM, Christoph Hellwig wrote:
> > On Thu, Jul 20, 2023 at 12:13:05PM -0600, Jens Axboe wrote:
> >> Whether we have a write back cache and are using FUA or don't have
> >> a write back cache at all is the same situation. Treat them the same.
> >>
> >> This makes the IOMAP_DIO_WRITE_FUA name a bit misleading, as we have
> >> two cases that provide stable writes:
> >>
> >> 1) Volatile write cache with FUA writes
> >> 2) Normal write without a volatile write cache
> >>
> >> Rename that flag to IOMAP_DIO_STABLE_WRITE to make that clearer, and
> >> update some of the FUA comments as well.
> > 
> > I would have preferred IOMAP_DIO_WRITE_THROUGH, STABLE_WRITES is a flag
> > we use in file systems and the page cache for cases where the page
> > can't be touched before writeback has completed, e.g.
> > QUEUE_FLAG_STABLE_WRITES and SB_I_STABLE_WRITES.
> 
> Good point, it does confuse terminology with stable pages for writes.
> I'll change it to WRITE_THROUGH, that is more descriptive for this case.

+1 for the name change.

With IOMAP_DIO_WRITE_THROUGH,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


Separately: At some point, the definition for IOMAP_DIO_DIRTY needs to
grow a type annotation:

#define IOMAP_DIO_DIRTY		(1U << 31)

due (apparently) triggering UBSAN because "1" on its own is a signed
constant.  If this series goes through my tree then I'll add a trivial
patch fixing all of this ... unless you'd rather do it yourself as a
patch 9?

--D

> -- 
> Jens Axboe
> 
