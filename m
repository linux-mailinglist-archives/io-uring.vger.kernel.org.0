Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E617CFD25
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbjJSOnt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 10:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbjJSOnt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 10:43:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0C0112;
        Thu, 19 Oct 2023 07:43:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05890C433C7;
        Thu, 19 Oct 2023 14:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697726627;
        bh=hSBVWeSZe5ffsEJ6LfBWhfatOoODWKY5sq7K/71m4+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C0+2XF5otbiWSqpRKgma6/wVgsFvfHFMAE8Rog4dNrR4wlcUeAokv00rSsRFR+MoE
         l510p2jRUOQqLPGFIwdZv5431l1x0t0UO0d2jxYM0JpCnb1NK0HOxX621kk3rLSKwq
         bxPnNpaZp9AD4hVfCynwykMRA0JFAAb2sVrtjJvy0m7vmV9kagtZ94wpXMYuBtXE9x
         V6GYqJdtN8Dk+50Ut/vC8NfOVY3WWF8A1rSTW42xUBDlaZlV7Zw0ki1XhH9PI9lz3n
         Uq3BTLJcdEcCZXUQ30oWF9PL5lrpH9whLa1hVI24T1TU0TN++DS8PScq14wEoXMsbd
         kJUP5ofJAvlvg==
Date:   Thu, 19 Oct 2023 08:43:44 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, joshi.k@samsung.com, martin.petersen@oracle.com
Subject: Re: [PATCH 3/4] iouring: remove IORING_URING_CMD_POLLED
Message-ID: <ZTFAoFhTMBpX8Iib@kbusch-mbp>
References: <20231018151843.3542335-1-kbusch@meta.com>
 <20231018151843.3542335-4-kbusch@meta.com>
 <20231019054105.GE14346@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019054105.GE14346@lst.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 19, 2023 at 07:41:05AM +0200, Christoph Hellwig wrote:
> Looks good and should probably go straight to the io_uring tree
> instead of being mixed up with the metadata changes.

The previos metadata patch removes the only user of the flag, so this
can't go in separately.

But if the driver needs to fallback to kernel bounce buffer for
unaligned or multi-page requests, I don't think I can easily get rid of
the iouring flag since the driver PDU doesn't have enough room to track
everything it needs.
