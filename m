Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4B177BE5F
	for <lists+io-uring@lfdr.de>; Mon, 14 Aug 2023 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjHNQum (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 12:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjHNQu3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 12:50:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CA2D2;
        Mon, 14 Aug 2023 09:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 544D26327C;
        Mon, 14 Aug 2023 16:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603F6C433C8;
        Mon, 14 Aug 2023 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692031827;
        bh=xejVDIFW4M3KqYcvfFvp6idaZ0x1SMTNjqiyN51qDiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iZFnF+gQRBF3qE+MXsyv83rodax3KV8Jy1NHSqQZnav4FZLwOFe+zqT73zPi3oJAj
         NLohBS7p4LMDVA1sO1KHk6fXjYlsqTZ3k2zvtK84Ctkx4VBX1EHWfwccWaczW7ei6d
         k0kD/hgSEkppkQUxTRAlz+jAzGurQOAIJ4DZ+paJoovXgeJd8JPrcJ7vEH4xTsTr4j
         txCMt1+M4y96rvS43Nuvt0QaFqcjUL1i2WT0pvTEaOCL4pTWcSD/aKrohUtAkQgVWw
         1VjLJbWS3ACZ3XilwcbDJKLL2O+lwZeiqZphw4za5Ai+fgrnNaU9R6S0IO2ye9zAo4
         NjQUnlq/QKClA==
Date:   Mon, 14 Aug 2023 10:50:25 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Keith Busch <kbusch@meta.com>, asml.silence@gmail.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCHv3] io_uring: set plug tags for same file
Message-ID: <ZNpbUeDDIMYgJSkt@kbusch-mbp.dhcp.thefacebook.com>
References: <20230731203932.2083468-1-kbusch@meta.com>
 <cbf529c4-6fb7-40da-8b01-514a8e3e6f5c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbf529c4-6fb7-40da-8b01-514a8e3e6f5c@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 11, 2023 at 01:24:17PM -0600, Jens Axboe wrote:
> 
>      3.51%     +2.84%  [kernel.vmlinux]  [k] io_issue_sqe
>      3.24%     +1.35%  [kernel.vmlinux]  [k] io_submit_sqes
> 
> With the kernel without your patch, I was looking for tag flush overhead
> but didn't find much:
> 
>      0.02%  io_uring  [kernel.vmlinux]  [k] blk_mq_free_plug_rqs
> 
> Outside of the peak worry with the patch, do you have a workload that we
> should test this on?

Thanks for the insights! I had tested simply 4 nvme drives with 1
thread, default everything:

   ./t/io_uring /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1

Which appeared to show a very small improvement with this patch on my
test vm. I'll test more to see where the tipping point is, and also see
if there's any other ways to reduce time spent in io_issue_sqe.
