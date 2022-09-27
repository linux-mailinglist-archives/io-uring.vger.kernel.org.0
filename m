Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCFF5EC063
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 13:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiI0LDk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 07:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiI0LCe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 07:02:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E9A606BC
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 04:02:21 -0700 (PDT)
Received: from [172.16.0.2] (unknown [8.30.234.156])
        by gnuweeb.org (Postfix) with ESMTPSA id 3288D8093C;
        Tue, 27 Sep 2022 11:02:18 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1664276541;
        bh=88N8vZtXCXwdgGYHvp58NvrhJp9JApS9mlhHbIbpIfE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bi6E6qBqx/u0IU9ypcOgR/OyWsTc7bID9fS7fiIeoq2z3406i1ZmwM6fdP2fJTX2C
         DjaONVB9/7/ZHqHEJoXpZiy+vQByciD9zBQxVx2MtMIvyF4pjKMBCsecoWtqRqRmTV
         4qvWS/tGAISSszo2jnWIjo5gRmZehImEDPHHLW0F37/c+6WBtrqEQy5GWdZ6VIrdxJ
         E7DDKd/7TeDBtlpa9JxX830n7qaVa39xXR3BjM+8XPNQ2a6l7TBtyVe3HgPujhNgs+
         g/S8gYsE4aEvxldIHpEZNZuzKD4lhHWr8wpPOTh0Vgxp9Pr1D3bzQ5G+11OWIvSF78
         RWvh7p86EJS6g==
Message-ID: <3027a8fc-b988-ba04-07ac-781d2943cab1@gnuweeb.org>
Date:   Tue, 27 Sep 2022 18:02:16 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing v2 2/3] update documentation to reflect no 5.20
 kernel
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20220927102202.69069-1-dylany@fb.com>
 <20220927102202.69069-3-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220927102202.69069-3-dylany@fb.com>
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
> The documentation referenced the wrong kernel version.
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi
