Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90D94ED029
	for <lists+io-uring@lfdr.de>; Thu, 31 Mar 2022 01:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347974AbiC3Xb6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 19:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351818AbiC3Xb6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 19:31:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFE1427FE
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 16:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75D76B81D46
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 23:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D133AC340F0;
        Wed, 30 Mar 2022 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648683008;
        bh=krUcZCe7koSNv2R9jp6NopW4Q2aaQo3uuiKTIRXscSI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G3g1TxqTezrgJt02deOdJd4AsyiLjqPPziPpNLUUunoFVZPE70zzBOgIto7rIF0Wm
         SbUtDZDMTcGTYXI0wK6uWp1q2e+XOKkqPIAS4zXf90EuBxE/k/HDovXa3bDrZCHyuR
         Q7GDQAU7zl6aqPnMLyYVS7nXKYzTTEvNLj6kWgH9/OKpQKo5WO7+5ngdAzlq0ltGiS
         CPQr4Q9ZrwTQ/u17rnVMEugT8m7bbcBLJhJDGHi9cqzaMyINAhEoFNO2h+Qy4GyB1O
         X8meIk/I+g9hmc8mAWyTeYUHTzWiwYDIBc4SEXnmToo7GtVdtONE0hCrr6sAPZGARe
         eBYBkQG/d+ZjA==
Date:   Wed, 30 Mar 2022 16:30:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Message-ID: <20220330163006.0ff1fec2@kernel.org>
In-Reply-To: <20220326143049.671b463c@kernel.org>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
        <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
        <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
        <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
        <20220326143049.671b463c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 26 Mar 2022 14:30:49 -0700 Jakub Kicinski wrote:
> In any case, let's look in detail on Monday :)

I have too many questions, best if we discuss this over the code.

Can we get the change reverted and cross-posted to netdev?

Thanks.
