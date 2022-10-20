Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D226060C0
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 14:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJTM5l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 08:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiJTM5k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 08:57:40 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C2B18A01B
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:57:38 -0700 (PDT)
Received: from [10.7.7.5] (unknown [182.253.183.172])
        by gnuweeb.org (Postfix) with ESMTPSA id 2D1D08060C;
        Thu, 20 Oct 2022 12:57:34 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1666270657;
        bh=a8t42p954zCgi5gPdDbWOwpsnrHaIjtT2nPLjAGUhLs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nT2tmJpx1iQbXVLav/D2FLgRtkdwkEfXjWPzir8dNeAkLj6Aq8QeSWJ6XBy/Ki65X
         s/BMflpGQCu7D/OrNvXQ/fFpWisyCAq407f9vdXQycA/qnzvldK9laygw7r+WlWZKn
         y/3NPhRpFYQwQmfr+mk3Ds2ybDmWiimHkch5/nvFAW5ulERLn9q69LioWp7ruWbLaQ
         4TzXn6TyGGEVCIbBvvKNYHD62QIdNy8lm5kS4s80M6tPCkxWJfb/xAos2Z+k/cdpBZ
         +bjt9M9rFbaUUzPN30MqZ89DF8vmhMYVj0JITW8Wmk0Gzd8RNdzQDJ15x6cAFwlS/H
         gvwG1mv1PUn2w==
Message-ID: <60956f6f-b42b-3511-4d4a-a091f7700895@gnuweeb.org>
Date:   Thu, 20 Oct 2022 19:57:32 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH liburing v1 0/3] Clean up clang `-Wshorten-64-to-32`
 warnings
To:     Dylan Yudaken <dylany@meta.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221020114814.63133-1-ammar.faizi@intel.com>
 <0c8a9f3fe2ff056e9f375f95fa9ecb328587fab5.camel@fb.com>
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <0c8a9f3fe2ff056e9f375f95fa9ecb328587fab5.camel@fb.com>
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

On 10/20/22 7:53 PM, Dylan Yudaken wrote:
> I think better to take my co-authored and signed-off tags from patch
> 2/3, as its not really similar to what I had done

I'll send v2 with that fixed.

-- 
Ammar Faizi

