Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06D354B236
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 15:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiFNNXW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 09:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbiFNNXV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 09:23:21 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A033C731;
        Tue, 14 Jun 2022 06:23:20 -0700 (PDT)
Message-ID: <5964648e-c192-5d31-4373-eeb1400c1855@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655212998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPDKgoi2sQuyu3iB0vnEYnvYtjr6SChnRHnxBf8haak=;
        b=wvb7dg/GcPvDrofW5l8P9WDbhNU1qFT+guUXM+sZS9tKRskTsOoJUcAawEe9jyu3Hc9ZEz
        wc82Uo21xDbYpUItxCnxcP+cREzp/EpJx0WhtNV+kuy1+ZA8nGDMl+6Fsonuf2McFQiB7K
        uskzbF3aaITxx4dbMo/hs3dtQwun4k0=
Date:   Tue, 14 Jun 2022 21:23:07 +0800
MIME-Version: 1.0
Subject: Re: [RFC 0/5] support nonblock submission for splice pipe to pipe
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
References: <20220607080619.513187-1-hao.xu@linux.dev>
In-Reply-To: <20220607080619.513187-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/7/22 16:06, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> splice from pipe to pipe is a trivial case, and we can support nonblock
> try for it easily. splice depends on iowq at all which is slow. Let's
> build a fast submission path for it by supporting nonblock.
> 
> Wrote a simple test to test time spent of splicing from pipe to pipe:
> 
> 
> Did 50 times test for each, ignore the highest and lowest number,
> calculate the average number:
> 
> before patchset: 119.85 usec
> with patchset: 29.5 usec
> 

Hi Al,
Any comments on this one?

Regards,
Hao

