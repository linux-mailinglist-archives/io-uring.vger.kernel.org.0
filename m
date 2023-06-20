Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A11736C02
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 14:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjFTMft (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 08:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjFTMfs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 08:35:48 -0400
Received: from out-59.mta0.migadu.com (out-59.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FB210DA
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 05:35:47 -0700 (PDT)
Message-ID: <6833cd2a-b137-0294-205c-f84b38290210@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687264544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPSaC7z0L0JwSH3NopdUNyLbwOS8vbMEXS5JsLuCm+U=;
        b=KaU9TlWxxmgKGK/z327N2AHEmPpS1XOylssSutEl5IUv/5ypJeT/Qus+xYaJdcvEv19m9D
        EhNmzzLp4ydF6L8FfTrW5rtMhgwQifHRDZx31ElpJa/51z7ptzODhBFFo01h6tadf9G6Nc
        QRV4yfPGpmA8hoLiEg+nQptkXRKSA8w=
Date:   Tue, 20 Jun 2023 20:35:37 +0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH 00/11] fixed worker
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20230609122031.183730-1-hao.xu@linux.dev>
Content-Language: en-US
In-Reply-To: <20230609122031.183730-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens and all,

On 6/9/23 20:20, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> The initial feature request by users is here:
> https://github.com/axboe/liburing/issues/296
> 
> Fixed worker provide a way for users to control the io-wq threads. A
> fixed worker is worker thread which exists no matter there are works
> to do or not. We provide a new register api to register fixed workers,
> and a register api to unregister them as well. The parameter of the
> register api is the number of fixed workers users want.
> 

Here is a liburing test case to show how it works:
https://github.com/axboe/liburing/commit/bc9e862d1317f2466381adb6243be8cc86c3bd27

Regards,
Hao

