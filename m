Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842BD54F96F
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 16:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382355AbiFQOld (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 10:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382840AbiFQOlb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 10:41:31 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED235675D
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:41:22 -0700 (PDT)
Message-ID: <d89f93d0-cb35-9c70-605a-5d2c24f601a3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655476881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JQOGWi+CVdoHg8Mdx7TWMbkxKcipUcswj9TaoSvxPwY=;
        b=ZqZEPzD7kXZMeyl2osjLxlm7+D0a3H7FjWFVQf+l1Ck76QgNffLNUmmnX0FibnBexUhPiz
        M5vJ8MpbXNLGXWBmwyAGNOHi2PAUoTEHuiWQpnpeVfW7UzdOxjDgS3HT5EKwp1YxSGjUyh
        mOfnp7OF6oJwwj+e1heQdkBQeYP0qO8=
Date:   Fri, 17 Jun 2022 22:41:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH liburing 0/3] multishot accept test fix and clean
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Donald Hunter <donald.hunter@gmail.com>
References: <20220617143603.179277-1-hao.xu@linux.dev>
In-Reply-To: <20220617143603.179277-1-hao.xu@linux.dev>
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

On 6/17/22 22:36, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> The multishot accept test is skipped, patch 1 fixes this. After this
> it is still broken, patch 2 fixes it. And patch 3 is code clean.
> 
> Donald Hunter (1):
>    Fix incorrect close in test for multishot accept
> 
> Hao Xu (2):
>    test/accept: fix minus one error when calculating multishot_mask
>    test/accept: clean code of accept test
> 
>   test/accept.c | 76 ++++++++++++++++++++++++---------------------------
>   1 file changed, 36 insertions(+), 40 deletions(-)
> 

Cced Donald Hunter

