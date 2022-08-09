Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A1B58DA2E
	for <lists+io-uring@lfdr.de>; Tue,  9 Aug 2022 16:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbiHIOSv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 10:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237529AbiHIOSu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 10:18:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFACCFD0A;
        Tue,  9 Aug 2022 07:18:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 792766119A;
        Tue,  9 Aug 2022 14:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3650AC433D6;
        Tue,  9 Aug 2022 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660054728;
        bh=2LhUVq5qqhA07K3ujU4iHTLWET9cMKEYYfbz4Q7+IE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vl3medZy3zzJ4VtcvTvoAKMrq4GVgisF8Kb0JLF1h2fep5qGOC1AEKMYuNe1JLDWO
         3rsqkIylRErTjywt81Sz2x0APpdaFOsWLwCBUUz/5sUx9H3ieuSPYeybwISETp+95g
         MjoNcm1RybPY3HDupJV04qyIH32ycLmI0B8rW5nk0zne3Q7YJ9SFv6B+Tqxy+3g0iu
         iwqTLtQ011MD6RrgVdq1mRoWAAOoLG/a3HxUDpmsIahaNN53eQNWRsRV1cNy+/FeT8
         ljUqpNG9m3bA7n57aF4JiOtEBCVv2j5j3SQFxg2h7bQ+bgQ1Zp0rtM0l3rqA7EaZXl
         7k3AW/+kXMYbQ==
Date:   Tue, 9 Aug 2022 08:18:45 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCHv3 0/7] dma mapping optimisations
Message-ID: <YvJsxZucjbQmEZP8@kbusch-mbp.dhcp.thefacebook.com>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220809064613.GA9040@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809064613.GA9040@lst.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 09, 2022 at 08:46:13AM +0200, Christoph Hellwig wrote:
>  - the design seems to ignore DMA ownership.  Every time data in
>    transfered data needs to be transferred to and from the device,
>    take a look at Documentation/core-api/dma-api.rst and
>    Documentation/core-api/dma-api-howto.rst.

I have this doing appropriate dma_sync_single_for_{device,cpu} if we aren't
using coherent memory. Is there more to ownership beyond that?
