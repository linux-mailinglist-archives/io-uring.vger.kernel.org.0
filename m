Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36430778657
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 06:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjHKEBI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 00:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjHKEBG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 00:01:06 -0400
Received: from out-65.mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C2B2D5E
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 21:01:02 -0700 (PDT)
Message-ID: <0399dbf5-ada0-d528-b925-aa90fa42df49@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691726461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RrfE8pVWe9+l6LfOf+ZrUOjjEZuCOCNZNOEXVvPF62c=;
        b=XGJ5Hu+/ozF/+pDREmSPxVwz6ObITWXPvxGih16gVI7+/0NgO8hsCOLL26Zz1B84xqq/nA
        ChYAD8yAagy13rvNOWoAsCnebyshlpX0lsQsUoeqCc4rWxklBVIPvfFqynbLhINDkDIBj+
        xp9eISaBdnxxpIW5YZzLGUlph8s4TW8=
Date:   Fri, 11 Aug 2023 12:00:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCHSET 0/3] io-wq locking improvements
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20230809194306.170979-1-axboe@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20230809194306.170979-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/23 03:43, Jens Axboe wrote:
> Hi,
> 
> In chatting with someone that was trying to use io_uring to read
> mailddirs, they found that running a test case that does:
> 
> open file, statx file, read file, close file
> 
> The culprit here is statx, and argumentation aside on whether it makes
> sense to statx in the first place, it does highlight that io-wq is
> pretty locking intensive.
> 
> This (very lightly tested [1]) patchset attempts to improve this
> situation, but reducing the frequency of grabbing wq->lock and
> acct->lock.
> 
> The first patch gets rid of wq->lock on work insertion. io-wq grabs it
> to iterate the free worker list, but that is not necessary.
> 
> Second patch reduces the frequency of acct->lock grabs, when we need to
> run the queue and process new work. We currently grab the lock and check
> for work, then drop it, then grab it again to process the work. That is
> unneccessary.
> 
> Final patch just optimizes how we activate new workers. It's not related
> to the locking itself, just reducing the overhead of activating a new
> worker.
> 
> Running the above test case on a directory with 50K files, each being
> between 10 and 4096 bytes, before these patches we get spend 160-170ms
> running the workload. With this patchset, we spend 90-100ms doing the
> same work. A bit of profile information is included in the patch commit
> messages.
> 
> Can also be found here:
> 
> https://git.kernel.dk/cgit/linux/log/?h=io_uring-wq-lock
> 
> [1] Runs the test suite just fine, with PROVE_LOCKING enabled and raw
>      lockdep as well.
> 

Haven't got time to test it, but looks good from the code itself.

Reviewed-by: Hao Xu <howeyxu@tencent.com>

