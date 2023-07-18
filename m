Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B564D7574B3
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 08:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjGRGzo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 02:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjGRGzn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 02:55:43 -0400
Received: from out-62.mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D501A6
        for <io-uring@vger.kernel.org>; Mon, 17 Jul 2023 23:55:42 -0700 (PDT)
Message-ID: <fd136d07-0da3-ce9c-9d49-6ab9a0e056bd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689663340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=byzEJ8KQDir+xTs9pfgOhNsoeOFRsWikoU7YhfIE5oo=;
        b=oTO3y2PcfO14EfDH2drouQqLTF1iu3gLCOv6ePkBHxmqKsNQKDALb2Gm48b0kfCT0Fqvem
        ZZfpZoHgRBP2VLe3sS+9qcsX0Esxc0UPmsVdAXc/9fEt5PXD6mTs5Gz01gCuXUTzt7gnHO
        s+ExkqXjjdjv9I5wi6X4ch8QYtebr7U=
Date:   Tue, 18 Jul 2023 14:55:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] io_uring: add support for getdents
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-4-hao.xu@linux.dev>
 <20230712-alltag-abberufen-67a615152bee@brauner>
 <bb2aa872-c3fb-93f0-c0da-3a897f39347d@linux.dev>
 <20230713-sitzt-zudem-67bc5d860cb4@brauner>
 <da88054b-c972-f4d1-fbdc-c6e10a9c559b@linux.dev>
 <20230713-verglast-pfuschen-50197f8be98b@brauner>
 <e76f0ab9-768e-2f8c-24f0-95a0dd375c98@linux.dev>
In-Reply-To: <e76f0ab9-768e-2f8c-24f0-95a0dd375c98@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/16/23 19:57, Hao Xu wrote:
> On 7/13/23 23:14, Christian Brauner wrote:
> 
>> Could someone with perf experience try and remove that f_count == 1
>> optimization from __fdget_pos() completely and make it always acquire
>> the mutex? I wonder what the performance impact of that is.
> 
> Hi Christian,
> For your reference, I did a simple test: writed a c program that open a
> directory which has 1000 empty files, then call sync getdents64 on it
> repeatedly until we get all the entries. I run this program 10 times for
> "with f_count==1
> optimization" and "always do the lock" version.
> Got below data:
> with f_count==1:
> 
> time cost: 0.000379
> time cost: 0.000116
> time cost: 0.000090
> time cost: 0.000101
> time cost: 0.000095
> time cost: 0.000092
> time cost: 0.000092
> time cost: 0.000095
> time cost: 0.000092
> time cost: 0.000121
> time cost: 0.000092
> 
> time cost avg: 0.00009859999999999998
> 
> always do the lock:
> time cost: 0.000095
> time cost: 0.000099
> time cost: 0.000123
> time cost: 0.000124
> time cost: 0.000092
> time cost: 0.000099
> time cost: 0.000092
> time cost: 0.000092
> time cost: 0.000093
> time cost: 0.000094
>              time cost avg: 0.00010029999999999997
> 
> So about 1.724% increment
> 
> [1] the first run is not showed here since that try does real IO
>      and diff a lot.
> [2] the time cost calculation is by gettimeofday()
> [3] run it in a VM which has 2 CPUs and 1GB memory.
> 
> Regards,
> Hao

Did another similar test for more times(100 rounds), about 1.4%
increment. How about:
if CONFIG_IO_URING: remove the f_count==1 logic
else: do the old logic.
