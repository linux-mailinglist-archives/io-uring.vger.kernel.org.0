Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8585E58DFBB
	for <lists+io-uring@lfdr.de>; Tue,  9 Aug 2022 21:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345483AbiHITE2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 15:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345196AbiHITD1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 15:03:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F48B2BB3A;
        Tue,  9 Aug 2022 11:39:18 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5466B68AA6; Tue,  9 Aug 2022 20:39:14 +0200 (CEST)
Date:   Tue, 9 Aug 2022 20:39:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@fb.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCHv3 0/7] dma mapping optimisations
Message-ID: <20220809183913.GA15107@lst.de>
References: <20220805162444.3985535-1-kbusch@fb.com> <20220809064613.GA9040@lst.de> <YvJsxZucjbQmEZP8@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YvJsxZucjbQmEZP8@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 09, 2022 at 08:18:45AM -0600, Keith Busch wrote:
> On Tue, Aug 09, 2022 at 08:46:13AM +0200, Christoph Hellwig wrote:
> >  - the design seems to ignore DMA ownership.  Every time data in
> >    transfered data needs to be transferred to and from the device,
> >    take a look at Documentation/core-api/dma-api.rst and
> >    Documentation/core-api/dma-api-howto.rst.
> 
> I have this doing appropriate dma_sync_single_for_{device,cpu} if we aren't
> using coherent memory. Is there more to ownership beyond that?

As long as we only every support a single device that is fine, but
if we want to support that it gets complicated.  Sorry, this should
have been integrated with the mumblings on the multiple device mappings
as the statement iѕ false without that.
