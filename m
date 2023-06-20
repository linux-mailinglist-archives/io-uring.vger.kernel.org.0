Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1BA736D5C
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 15:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjFTN3k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 09:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjFTN3j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 09:29:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C266199;
        Tue, 20 Jun 2023 06:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4/wJuUgBUk+76Y/jWEXgicRIeEPHzThXq3/N/MUtCXg=; b=fQGv+1DHmIsgD25L5ApJTTpl8D
        zEVRIlOSXJAoQ3IA3GNZ2BMDn9xdBFyrbYlFKoBQmmTPmhTBNjOQzSxjDqvp1SFzODTkutG4cR0jw
        PwmIkMtRCyks91hg6bRMKcDH+Gon3wqqecq0eI3S6RiC9dLBnAuewFGNIaiZUzoTdnpVpkzc7LBdd
        JkL8/iq15iIv7I+pnPhVa6/0jgeuUShGuB03Pt84lYqs3dZe6bkYN7rEGnGcoW6SHEjN0M3P0lZeZ
        pX8hd1D26qf2wurUA/30O/T8r1VaVLpyoJ6r15DQx6o8RqbrcST5GX3Pecv8ZgD6/Alh71ciaGpiS
        3c4wpyhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qBbQN-00BOXy-32;
        Tue, 20 Jun 2023 13:29:35 +0000
Date:   Tue, 20 Jun 2023 06:29:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 2/3] block: mark bdev files as FMODE_NOWAIT if underlying
 device supports it
Message-ID: <ZJGpv4WjadjdBTmN@infradead.org>
References: <20230509151910.183637-1-axboe@kernel.dk>
 <20230509151910.183637-3-axboe@kernel.dk>
 <ZFucWYxUtBvvRJpR@infradead.org>
 <8d5daf0d-c623-5918-d40e-ab3ad1c508ad@kernel.dk>
 <ZJFEz2FKuvIf8aCL@infradead.org>
 <a7a1dcc3-5aaf-53bc-7527-ba62292c44cd@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7a1dcc3-5aaf-53bc-7527-ba62292c44cd@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 20, 2023 at 07:24:56AM -0600, Jens Axboe wrote:
> I think we need stronger justification than that, it's much nicer to
> have it in the open path than doing the same check over and over for
> each IO.
> 
> With your new proposed scheme, why can't the check and FMODE_NOWAIT set
> still be in open?

Because I want to move the by now huge number of static flags out of
file->f_mode and into file->f_op.flags.  It's just that with this patch
this one flag isn't static anymore for block devices.  We could also
do two sets of file operations assuming we never allow run-time changes
for QUEUE_FLAG_NOWAIT.  If we care about optimizing fo async I/O on the
few drivers not supporting QUEUE_FLAG_NOWAIT that's probably the next
best thing.

