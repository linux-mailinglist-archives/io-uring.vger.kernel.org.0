Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21454E67A
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 17:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377602AbiFPP6T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 11:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377289AbiFPP6S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 11:58:18 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565131E3F2
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 08:58:17 -0700 (PDT)
Message-ID: <bc5a2e17-439e-23f5-bfb0-bd4c10a6b14b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655395095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1/Smaj4k5p9InvEfB/nqTCwK2f0CFeDnykN5aRYSINc=;
        b=XthrnsHK7veJKvcHikAAXrY6Fx/q4n92/QkP22p0sfMgj8R8KVBMNsteJTSp7+9KVxjlnn
        1i5q83IID65XTF4HWXXXl84XSHkLN8ciqLdHunQIvPdG7RD7tuVb80916z+nAy4vEuwGDf
        YHaalSIrHmlF97FNGtc0csJoBORWluo=
Date:   Thu, 16 Jun 2022 23:58:08 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v3 00/16] 5.20 cleanups and poll optimisations
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655371007.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/22 17:21, Pavel Begunkov wrote:
> 1-4 kills REQ_F_COMPLETE_INLINE as we're out of bits.
> 
> Patch 5 from Hao should remove some overhead from poll requests
> 
> Patch 6 from Hao adds per-bucket spinlocks, and 16-19 do a little
> bit of cleanup. The downside of per-bucket spinlocks is that it adds
> additional spinlock/unlock pair in the poll request completion side,
> which shouldn't matter much with 20/25.
> 
> Patch 11 uses inline completion infra for poll requests, this nicely
> improves perf when there is a good tw batching.
> 
> Patch 12 implements the userspace visible side of
> IORING_SETUP_SINGLE_ISSUER, it'll be used for poll requests and
> later for spinlock optimisations.
> 
> 13-16 introduces ->uring_lock protected cancellation hashing. It
> requires us to grab ->uring_lock in the completion side, but saves
> two spin lock/unlock pairs. We apply it automatically in cases the
> mutex is already likely to be held (see 25/25 description), so there
> is no additional mutex overhead and potential latency problemes.
> 

Reviewed-by: Hao Xu <howeyxu@tencent.com>
