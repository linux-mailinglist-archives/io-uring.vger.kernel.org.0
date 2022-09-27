Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9722B5EC03C
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 13:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiI0LAQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 07:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiI0LAP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 07:00:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAC624098
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 04:00:14 -0700 (PDT)
Received: from [172.16.0.2] (unknown [8.30.234.156])
        by gnuweeb.org (Postfix) with ESMTPSA id 9D0528093C;
        Tue, 27 Sep 2022 11:00:11 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1664276413;
        bh=KFiymaVOqA6dB1+qHMkDA+BmvZ+1kun120HC/VsTyJE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=I/ZrzF4wBsEzTjNBhfG20x0U4RaVDy/IRFzE1h/3LhMiPiCD/30ZHyXYG9kxUAENv
         rGhXl5qKaBfdu69LHTg8G22vWIwAhAO2M1591/BJauIa4CZqxlPHrdVEkPZSkuFV66
         VLHXE8T2MgNBCkg4CZrpa+MQ6WJBXMMHT7ydoDhfx8XQs+0rlc1th/CenCGq5Mkm96
         bqI/WqcwXdEU4jn3TBXav32FK+Y3v02BWnE3kAZ8syAnzqbUgY6+Zg8I2fZEL3Yhw7
         rVQKeicxhqba3qX8mUXmwvVVnGPE003+A6fDeiQCBamZkwcoUPNyqoJzpa9KbUsqsp
         hK1BbsVDwDKzw==
Message-ID: <6035bf4e-9b7c-1463-4606-a6c887cb67eb@gnuweeb.org>
Date:   Tue, 27 Sep 2022 18:00:08 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing v2 3/3] give open-direct-pick.c a unique path
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20220927102202.69069-1-dylany@fb.com>
 <20220927102202.69069-4-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220927102202.69069-4-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/27/22 5:22 PM, Dylan Yudaken wrote:
> This was making make runtest-parallel flaky
> 
> Signed-off-by: Dylan Yudaken<dylany@fb.com>
> ---
>   test/open-direct-pick.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Yeah, it clashes with test/open-close.c's.

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi
