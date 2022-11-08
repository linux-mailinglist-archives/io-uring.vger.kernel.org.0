Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B58621907
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 17:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiKHQFq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 11:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiKHQFp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 11:05:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD841D30C;
        Tue,  8 Nov 2022 08:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBEED616A0;
        Tue,  8 Nov 2022 16:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5731C433C1;
        Tue,  8 Nov 2022 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667923544;
        bh=cYz5E87iUJQ0qMvC4JY5TVCHxoq+xl7lwPdukbDqTyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iCabfHXoX9FMtq42+9sW7BKZwGj4Nn4kwJD2Mysz1MPwi1WNRApvHArFJmz4xNZZo
         pEErpcfTwLNNWWpCbEki8UNkNLw2qQszxllt5uKHwg91TigctELmBrRA4+SWaxJGXQ
         t9ABqBQFy9Orsm+NMvPQ3BD/+S7+z6g9XAAunuLUhU8/K54sH/1h+6vgxvCIdpiaVC
         oiq3vYAh87Iu5OSwnUK5ROE5/J7A0KCf2MwmtRy6D6H/gVc7Iy0/REURHTKNExJpx9
         kjQpVyMom9MMFxp0/ogEtjMK24ALgpxOupekLah221C9O1J2XfjsXzH6crLGSjUt8w
         jHot1Wq1DcLjA==
Date:   Tue, 8 Nov 2022 09:05:41 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Keith Busch <kbusch@meta.com>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, io-uring@vger.kernel.org, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] iov: add import_ubuf()
Message-ID: <Y2p+VSb+qcQrHrkx@kbusch-mbp>
References: <20221107175610.349807-1-kbusch@meta.com>
 <20221107175610.349807-2-kbusch@meta.com>
 <Y2n9dd3QOwcgk5Cx@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2n9dd3QOwcgk5Cx@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 07, 2022 at 10:55:49PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 07, 2022 at 09:56:07AM -0800, Keith Busch wrote:
> > From: Jens Axboe <axboe@kernel.dk>
> > 
> > Like import_single_range(), but for ITER_UBUF.
> 
> So what is the argument for not simplify switching
> import_single_range to always do a ITER_UBUF?  Maybe there is a reason
> against that, but it should be clearly stated here.

That may be a good idea if everyone uses the more efficient iter, but I
thought it'd be safer to keep them separate. There are just a few
import_single_range() users that expect the result be ITER_IOVEC. It
will take some extra time on my side to make sure that kind of change
won't break anything.
