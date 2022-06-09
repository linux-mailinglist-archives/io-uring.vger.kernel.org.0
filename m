Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1F7544888
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 12:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiFIKP0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 06:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242505AbiFIKPZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 06:15:25 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2A812D15A
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 03:15:03 -0700 (PDT)
Message-ID: <ed5b8a0a-d312-1181-c6b4-95fd126ea9e9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654769701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1EpBMEtJaUUCCuFFDbgdicdQguhAvs7Aa4y2PLIIXQ=;
        b=apQ540mgMUNZYLL09VhyKhwrMephKvVzzePJgqIQoC6xpMm5+g2Jj6hECqNxq1SgHGab1b
        RfZ6KlESLCfJdXcY31XjzKtBWum97Tm+cTPwvIRbmoU6YabvepEsa+d8tILVoVFDQ1kNqO
        SWvRMc0IhFveReHP6lR+vfNaCmj0F5c=
Date:   Thu, 9 Jun 2022 18:14:55 +0800
MIME-Version: 1.0
Subject: Re: Possible bug for ring-mapped provided buffer
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
 <7c563209-7b33-4cc8-86d9-fecfef68c274@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <7c563209-7b33-4cc8-86d9-fecfef68c274@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/22 18:06, Jens Axboe wrote:
> On 6/9/22 1:53 AM, Hao Xu wrote:
>> Hi all,
>> I haven't done tests to demonstrate it. It is for partial io case, we
>> don't consume/release the buffer before arm_poll in ring-mapped mode.
>> But seems we should? Otherwise ring head isn't moved and other requests
>> may take that buffer. What do I miss?
> 
> On vacation this week, so can't take a look at the code. But the
> principle is precisely not to consume the buffer if we arm poll, because
> then the next one can grab it instead. We don't want to consume a buffer
> over poll, as that defeats the purpose of a provided buffer. It should
> be grabbed and consumed only if we can use it right now.
> 
> Hence the way it should work is that we DON'T consume the buffer in this
> case, and that someone else can just use it. At the same time, we should
> ensure that we grab a NEW buffer for this case, whenever the poll

If we grab a new buffer for it, then we have to copy the data since we
have done partial io...this also defeats the purpose of this feature.
What the legacy provided buffer mode do in this case is just
keep/consume that buffer. So I'd think we should keep the consistency.
But yes, there may be a better way.

> triggers and we can retry the IO. As mentioned I can't check the code
> right now, but perhaps you can take a look.
> 

