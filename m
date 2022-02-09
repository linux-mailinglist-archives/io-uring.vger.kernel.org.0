Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D533A4AF0F0
	for <lists+io-uring@lfdr.de>; Wed,  9 Feb 2022 13:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiBIMI1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Feb 2022 07:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbiBIMGg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Feb 2022 07:06:36 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2013EC03C1B6;
        Wed,  9 Feb 2022 03:06:32 -0800 (PST)
Received: from [192.168.88.87] (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id 3CFF57E254;
        Wed,  9 Feb 2022 11:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644404791;
        bh=CMIyqS9DnDZDs9eLANac+euir/RYD6fyCVyaDWjZp/w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QA2XpAp7H5Eh/37AmSmulLKjlB59txXBn0mTK/RATT1dH06TPnEMzMQOe2+F9c4G2
         B+KmB/XL6d9hvIXa+s/wWu8+6GmV3kDVuyqAt4xt3vY2CdLzxrWa8RKY5wE3Yi23nm
         jySsr8e7vwiEY9nZBpt19UV2Iewcd72Md132dwo7A4M2F1IPO3eX2AIRviYoY5pA+Y
         OOq+DeYmmmRmikP1WpmurdJndxYpAJcuOriLZtv8yKpHveTWnv9kdOIfYCxq//ecDu
         IbsdF8d/MChqxI7Pw30+jJgS/6o5k0od2kifbR3AsNC0ZkTogetMdVxHzcKNFUS2np
         zbygG0YMGzOUg==
Message-ID: <ff729ee0-fbc0-bb6f-d638-cc33dd4734a6@gnuweeb.org>
Date:   Wed, 9 Feb 2022 18:06:15 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] io_uring: Fix uninitialized use of ret in
 io_eventfd_register()
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20220209102637.34088-1-jiapeng.chong@linux.alibaba.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220209102637.34088-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/22 5:26 PM, Jiapeng Chong wrote:
> In some scenarios, ret is not assigned in the whole process, so it
> needs to be initialized at the beginning.
> 
> Clean up the following clang warning:
> 
> fs/io_uring.c:9373:13: note: initialize the variable 'ret' to silence
> this warning.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---

This is already fixed in commit
4c65723081332607ca331072b0f8a90189e2e447 ("io_uring: Fix use of uninitialized ret in io_eventfd_register()")

https://lore.kernel.org/all/20220207162410.1013466-1-nathan@kernel.org/T/

https://github.com/torvalds/linux/commit/4c65723081332607ca331072b0f8a90189e2e447.patch

-- 
Ammar Faizi
