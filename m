Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A01751744
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 06:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbjGMESV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 00:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbjGMESN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 00:18:13 -0400
X-Greylist: delayed 90110 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Jul 2023 21:18:12 PDT
Received: from out-31.mta1.migadu.com (out-31.mta1.migadu.com [IPv6:2001:41d0:203:375::1f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0BB2106
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 21:18:11 -0700 (PDT)
Message-ID: <1d44fd43-376d-7dde-0298-e62feef8e36a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689221890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWUawpQGXuuL18KlAo+tf3X2RrDshcORABMEoSEwms0=;
        b=xAyaszgSf3JBB3qbuHDn7labzAshbQS4r/+tLTuD0oTGRoNIi0BrBGlEIFWVi57fYniZhW
        03cLREi+UDWX7YNOfwRH+c+u1vT4DGZfUfp1UWvL/GVQajw90knHNTxW89ERKI3PfoHhoI
        +dRYQRjsYdq/RtODGuNHtNw+vPHC2Hs=
Date:   Thu, 13 Jul 2023 12:17:54 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] fs: split off vfs_getdents function of getdents64
 syscall
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Fsdevel Mailing List <linux-fsdevel@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-2-hao.xu@linux.dev>
 <ZK1S3s/hOLOq0Ym+@biznet-home.integral.gnuweeb.org>
 <d7c071e7-8ee1-a236-77d6-88b1b3937a98@linux.dev>
 <ZK6wtZrwCRKoa3X8@biznet-home.integral.gnuweeb.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZK6wtZrwCRKoa3X8@biznet-home.integral.gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 7/12/23 21:55, Ammar Faizi wrote:
> On Wed, Jul 12, 2023 at 04:03:41PM +0800, Hao Xu wrote:
>> On 7/11/23 21:02, Ammar Faizi wrote:
>>> On Tue, Jul 11, 2023 at 07:40:25PM +0800, Hao Xu wrote:
>>>> Co-developed-by: Stefan Roesch <shr@fb.com>
>>>> Signed-off-by: Stefan Roesch <shr@fb.com>
>>>> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
>>>> ---
>>> Since you took this, it needs your Signed-off-by.
>>>
>> Hi Ammar,
>> I just add this signed-off-by of Stefan to resolve the checkpatch complain,
>> no code change.
> Both, you and Stefan are required to sign-off. The submitter is also
> required to sign-off even if the submitter makes no code change.
>
> See https://www.kernel.org/doc/html/latest/process/submitting-patches.html:
> """
> Any further SoBs (Signed-off-by:'s) following the author's SoB are from
> people handling and transporting the patch, but were not involved in its
> development. SoB chains should reflect the real route a patch took as it
> was propagated to the maintainers and ultimately to Linus, with the
> first SoB entry signalling primary authorship of a single author.
> """
>
> It also applies to the maintainer when they apply your patches.


Hi Ammar,

I see, this information is really helpful, I'll fix it in next version 
to make it

more standardized.


Thanks,

Hao

