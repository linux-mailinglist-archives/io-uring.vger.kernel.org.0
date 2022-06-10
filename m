Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810BA5463F1
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 12:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbiFJKiC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 06:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346700AbiFJKhX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 06:37:23 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52F74C7A4
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 03:34:15 -0700 (PDT)
Message-ID: <eb18cbbf-5ae7-de3a-8784-e7b27da9ef53@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654857254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=znaw4dMCM2j/5UdYTJ2FvJYdo7xtjBvG3CPDg7M17cg=;
        b=RVr6zFhkCC1MvlqVxV6/UZ47PRXAUhPvtElfmW5oZNxL9Ga3Ez0zdkroRUKNFP/RdlTl0g
        ViAgbYLOrCQz5xLcde6II+3fzqai88w9EDsHsk1SXRZY/fR8iYs4pHEn7DiqFMpEK/n3sl
        tW6yTLbHTLLUODTjaUiqBHawgxcaTds=
Date:   Fri, 10 Jun 2022 18:34:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/5] misc update for openclose and provided buffer
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220610090734.857067-1-hao.xu@linux.dev>
 <695b0207-2a93-6bbc-bb5c-b771283967c2@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <695b0207-2a93-6bbc-bb5c-b771283967c2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

On 6/10/22 18:13, Pavel Begunkov wrote:
> On 6/10/22 10:07, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Patch 1 and 2 are bug fixes for openclose
>> Patch 3 is to support better close logic
>> Patch 4 is code clean
>> Patch 5 is a bug fix for ring-mapped provided buffer
> 
> Looks that at least the problem from 1/5 also exists in 5.19,
> can you split out 5.19 fixes and send them separately?

Sure.

> 
> 
>> Hao Xu (5):
>>    io_uring: openclose: fix bug of closing wrong fixed file
>>    io_uring: openclose: fix bug of unexpected return value in
>>      IORING_CLOSE_FD_AND_FILE_SLOT mode
>>    io_uring: openclose: support separate return value for
>>      IORING_CLOSE_FD_AND_FILE_SLOT
>>    io_uring: remove duplicate kbuf release
>>    io_uring: kbuf: consume ring buffer in partial io case
>>
>>   io_uring/io_uring.c  |  6 ------
>>   io_uring/kbuf.c      |  9 +++++++--
>>   io_uring/kbuf.h      | 10 ++++++++--
>>   io_uring/openclose.c | 10 +++++++---
>>   io_uring/rsrc.c      |  2 +-
>>   5 files changed, 23 insertions(+), 14 deletions(-)
>>
> 

