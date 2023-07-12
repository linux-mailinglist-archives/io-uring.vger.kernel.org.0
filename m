Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC89C7500AB
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 10:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjGLIEG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 04:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjGLIDw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 04:03:52 -0400
Received: from out-16.mta0.migadu.com (out-16.mta0.migadu.com [IPv6:2001:41d0:1004:224b::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A91919A7
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 01:03:49 -0700 (PDT)
Message-ID: <d7c071e7-8ee1-a236-77d6-88b1b3937a98@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689149028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0Bqn9KeuYfuEBwho/CBqy2f7wayGj8KewGy0AzMbok=;
        b=Ar/Bt5TxNrSEdD48yZmoAaSVCi7HVxofNx/BxPRNVcQBy7pNyyENB+x6Jrh+LMxeRQfxI8
        b2+ntlGc4LtWGeFu4B5xdwGjZhsSlJMkadGhK+PYtvPrvawJWTgcc7qQ3a6RScSvkEYkbN
        hw5mInJqwzONi5c3jPYgveUSDOEj/4A=
Date:   Wed, 12 Jul 2023 16:03:41 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZK1S3s/hOLOq0Ym+@biznet-home.integral.gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/23 21:02, Ammar Faizi wrote:
> On Tue, Jul 11, 2023 at 07:40:25PM +0800, Hao Xu wrote:
>> This splits off the vfs_getdents function from the getdents64 system
>> call.
>> This will allow io_uring to call the vfs_getdents function.
>>
>> Co-developed-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
>> ---
> 
> Since you took this, it needs your Signed-off-by.
> 

Hi Ammar,
I just add this signed-off-by of Stefan to resolve the checkpatch 
complain, no code change.
