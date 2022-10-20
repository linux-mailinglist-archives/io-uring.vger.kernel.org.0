Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E2A605FCB
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 14:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiJTMMM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 08:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiJTMML (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 08:12:11 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F15153E35
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:12:10 -0700 (PDT)
Received: from [10.7.7.5] (unknown [182.253.183.172])
        by gnuweeb.org (Postfix) with ESMTPSA id 550D2804D1;
        Thu, 20 Oct 2022 12:12:08 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1666267930;
        bh=sLQzqjMZzRlc+ryGIyihVk2qTT6WrL4vgWF+XKpJdlU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Tk/K8OwLpQ8gElAUMAAQKGXQKKC3rqVIQLIeuW8IaQQBw54uo78MdvJFWU4X06Mf1
         wxsEVrHqsYzFUQoE4Ky91tHRNZj/LbcO8xsFP+EzcvkUJLXaCOtulD1YOeUgl6WFpl
         hjy72XN6qv9l5ykatH4j1xOgfcaOQZ8T6BfPjl1CL2JI8WH9+T2sVC7rdA+liE145T
         QT3yOb8EnBr8lmGZnb05Uj98lvpEGNb9cSAPqsCjUNGQQjjAugmdwTePUZlDLM4FrP
         uoZ0HTSRfSh03moVhd1lrs/yrBTJPHh1hZFIq9VyTJsdI/x5Z2KQnnZ81nCAbP2qNw
         ECF3Yj9YKGwmw==
Message-ID: <0e72af49-9e6c-2cc2-c53c-3966b20517cf@gnuweeb.org>
Date:   Thu, 20 Oct 2022 19:12:05 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH liburing v1 1/3] liburing: Clean up `-Wshorten-64-to-32`
 warnings from clang
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@meta.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
References: <20221020114814.63133-1-ammar.faizi@intel.com>
 <20221020114814.63133-2-ammar.faizi@intel.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221020114814.63133-2-ammar.faizi@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/22 6:52 PM, Ammar Faizi wrote:
> From: Dylan Yudaken<dylany@fb.com>
> 
> liburing has a couple of int shortening issues found by clang. Clean
> them all. This cleanup is particularly useful for build systems that
> include these files and run with that error enabled.
> 
> Link:https://lore.kernel.org/io-uring/20221019145042.446477-1-dylany@meta.com
> Signed-off-by: Dylan Yudaken<dylany@fb.com>
> Co-authored-by: Ammar Faizi<ammarfaizi2@gnuweeb.org>
> Signed-off-by: Ammar Faizi<ammarfaizi2@gnuweeb.org>

BTW, before it's too late. I think we should be consistent on the cast
style:

    (type) a

or

    (type)a

What do you think?

-- 
Ammar Faizi

