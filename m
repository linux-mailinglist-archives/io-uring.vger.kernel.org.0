Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55FB5204E7
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 21:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbiEITG1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 15:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiEITG0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 15:06:26 -0400
X-Greylist: delayed 1645 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 May 2022 12:02:30 PDT
Received: from a4-15.smtp-out.eu-west-1.amazonses.com (a4-15.smtp-out.eu-west-1.amazonses.com [54.240.4.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8971F929A;
        Mon,  9 May 2022 12:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ob2ngmaigrjtzxgmrxn2h6b3gszyqty3; d=urbackup.org; t=1652120094;
        h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=moCKIlR1VoGBDZv7bxLTB0rBLKiRz1QcPC33EzoNnt0=;
        b=C4lPPFd/BL1NLovwh7MWYmrvYs820UC3KP7QN8CoQZTJ0GLWjcnwO2NN8zxHEE58
        h7eL/Ie+WMnJRxCiGE+kr6LE2RFcFOaZd+FrNuV/YgRDvQ/24XsOLFRhz7pM9KLNqr9
        BJKdJ44XvY6fhWNkjCYti4tvQZp0UKjPHsozKq6Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ihchhvubuqgjsxyuhssfvqohv7z3u4hn; d=amazonses.com; t=1652120094;
        h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=moCKIlR1VoGBDZv7bxLTB0rBLKiRz1QcPC33EzoNnt0=;
        b=lzPMZQwKC5VH4ANqtvKfzIX194vwwB+Oxsf4b+F2oMy/se9Bm89BPKWK17ZFrroA
        pVWEXnsGs0foBMQ6lfAlmY/LNDP8rHU6HUS/g6GPtPG0Kd+qBMeXlXWfk116ct69ces
        abUhf0RTuXETFcMXYvXMsHVyKPv/u6+sWTxdHSdU=
Message-ID: <01020180aa080721-08a3231e-71b7-4fb2-a411-cac2cbf85ae3-000000@eu-west-1.amazonses.com>
Date:   Mon, 9 May 2022 18:14:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Martin Raiber <martin@urbackup.org>
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20220509092312.254354-1-ming.lei@redhat.com>
In-Reply-To: <20220509092312.254354-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
X-SES-Outgoing: 2022.05.09-54.240.4.15
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09.05.2022 11:23 Ming Lei wrote:
> This is the driver part of userspace block driver(ubd driver), the other
> part is userspace daemon part(ubdsrv)[1].
>
> The two parts communicate by io_uring's IORING_OP_URING_CMD with one
> shared cmd buffer for storing io command, and the buffer is read only for
> ubdsrv, each io command is indexed by io request tag directly, and
> is written by ubd driver.
>
> For example, when one READ io request is submitted to ubd block driver, ubd
> driver stores the io command into cmd buffer first, then completes one
> IORING_OP_URING_CMD for notifying ubdsrv, and the URING_CMD is issued to
> ubd driver beforehand by ubdsrv for getting notification of any new io request,
> and each URING_CMD is associated with one io request by tag.
>
> After ubdsrv gets the io command, it translates and handles the ubd io
> request, such as, for the ubd-loop target, ubdsrv translates the request
> into same request on another file or disk, like the kernel loop block
> driver. In ubdsrv's implementation, the io is still handled by io_uring,
> and share same ring with IORING_OP_URING_CMD command. When the target io
> request is done, the same IORING_OP_URING_CMD is issued to ubd driver for
> both committing io request result and getting future notification of new
> io request.
>
> Another thing done by ubd driver is to copy data between kernel io
> request and ubdsrv's io buffer:
>
> 1) before ubsrv handles WRITE request, copy the request's data into
> ubdsrv's userspace io buffer, so that ubdsrv can handle the write
> request
>
> 2) after ubsrv handles READ request, copy ubdsrv's userspace io buffer
> into this READ request, then ubd driver can complete the READ request
>
> Zero copy may be switched if mm is ready to support it.
>
> ubd driver doesn't handle any logic of the specific user space driver,
> so it should be small/simple enough.
>
> [1] ubdsrv
> https://github.com/ming1/ubdsrv/commits/devel

Great! It would be interesting to do some tests on how much faster (IOPS) this is than doing this via fuse: https://github.com/uroni/fuseuring


