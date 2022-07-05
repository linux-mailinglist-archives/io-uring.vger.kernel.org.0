Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685995663BC
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 09:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiGEHFk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 03:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiGEHFf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 03:05:35 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B7A13D27
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 00:05:29 -0700 (PDT)
Received: from [192.168.88.254] (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 74A6D804B8;
        Tue,  5 Jul 2022 07:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1657004729;
        bh=/twbPkMeeMCQVzZQtby/m+XQ15hZ9iyuU7aFqKNT8Xo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MZxHSoR37T77b+wB2whgEsBmbzbtZ1uNDHlGczNWTqHeIC+ScV4o3fibG9hkCAoOj
         zf+Plj3RldFG5YyAjITtkf1Aeq99iYV6VP1RzGh/Umce3gishsLJBtzBf0I22WI56U
         LIABUEap/nvU17IWT9VyfX/JtFUaSfpdPXW3SLq7tj1Q4yZBsqcXuPBVlkrovanA67
         dOZD1nEfGiVA7kWLFmCcZf0PUt0oNC/A00sGhyNjHQM8cz+2DOMsr+WCrglJXpLVL7
         ZCCsU+CiCAS3+dOvdQwbitqwh+wokeStxuDgXxcafvy/Cj5J3Sje78gRCCfFmnk6/T
         64t/hhzOz8ceg==
Message-ID: <1dd48bf8-557d-8088-e96b-58aecbb6b1c5@gnuweeb.org>
Date:   Tue, 5 Jul 2022 14:05:18 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing v4 02/10] arch: syscall: Add `__sys_open()`
 syscall
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220704192827.338771-1-ammar.faizi@intel.com>
 <20220704192827.338771-3-ammar.faizi@intel.com>
 <CAOG64qMDn0_YmQ9SjkvgFTvPHLo-V4MVNQ26MBt8bgkgvGV-JA@mail.gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <CAOG64qMDn0_YmQ9SjkvgFTvPHLo-V4MVNQ26MBt8bgkgvGV-JA@mail.gmail.com>
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

On 7/5/22 1:46 PM, Alviro Iskandar Setiawan wrote:
> On Tue, Jul 5, 2022 at 2:31 AM Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> A prep patch to support aarch64 nolibc. We will use this to get the
>> page size by reading /proc/self/auxv. For some reason __NR_open is
>> not defined, so also define it in aarch64 syscall specific file.
> 
> The commit message should also be updated, no extra definition for
> __NR_open anymore in this version.

Ah right, forgot to remove that from the commit message, will do it
in v5. Thanks!

-- 
Ammar Faizi
