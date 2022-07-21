Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E4F57CE5A
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 16:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGUO5y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 10:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiGUO5y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 10:57:54 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B3485D69
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:57:50 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.97.11])
        by gnuweeb.org (Postfix) with ESMTPSA id BB4857E312;
        Thu, 21 Jul 2022 14:57:47 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658415470;
        bh=VPDgfmVrPLUKsQQi2gI2jsxxOkg1XgMC8VejEMzL2vY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RLvtBYarOJQO1kQFuJeOF/xOs8CxLXxD2gXh4r5ULZpH0xS79PZdJtkyUMh/1ML1m
         6i07vSzWewUnkxP6WjgY/nIUN+K7OJzxr8p5v9w7VXMJUMXi6a0/m2vewIaHCI0X+a
         MmbneLbH8A3Q6NdEh63qMBbHo1honT2QogW+FtD2h4RVuj0SxF3zNQm4T9LAXIh5Lw
         Bc2TF9EvKFvBBAUqPhIYKaxrpX2PAn5vk0PiXhe9jP373CqK/muoETA3hw7dMJn2fT
         pMdOG/AIz5G+F0lbwKriVcgGUtK5DZZLYwXKkt8LsX3tz4BsCftvR2NfCkGae3aj1S
         EAJUjqC/EN8uQ==
Message-ID: <ae852d94-c8a8-ff11-158c-3d5af1ee00eb@gnuweeb.org>
Date:   Thu, 21 Jul 2022 21:57:34 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 4/4] skip poll-mshot-overflow on old kernels
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20220721144229.1224141-1-dylany@fb.com>
 <20220721144229.1224141-5-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220721144229.1224141-5-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/22 9:42 PM, Dylan Yudaken wrote:
> Older kernels have slightly different behaviour, so rather skip the test
> on them.
> 
> Reported-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> Signed-off-by: Dylan Yudaken <dylany@fb.com>

Tested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Thanks!

-- 
Ammar Faizi
