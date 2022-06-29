Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FEA5603A3
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 16:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiF2Ovp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 10:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiF2Ovp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 10:51:45 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9371EAC8
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 07:51:44 -0700 (PDT)
Received: from [192.168.88.254] (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 3F9857ED9F;
        Wed, 29 Jun 2022 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656514303;
        bh=q1ru1wPcdak7il0C8fJ2Nvxqk3ws5D6OyZASEuuxUhs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=S4tpXErdBemT++onSA/wnBgCVVz2uSyD6XFjfcpgPWpXVZmQ0CYR8tFdEy9IJ5fMS
         nqqw9WHr0t/w2TTR7g6VGTH+YFDPKhgTlDono6So+AwnVJeGGWR2rtF0E6ya3vDcft
         2/pmjMtkXVJbqqMqTr9hQz699s4uUzboLbUgfRjhnOKhyEOdvhKHgISxyUSZxgAGGp
         jUYPFnNpwVuEnZk93+dB3NA0LWMbRwedknleOimsPIWB/w34ZNtKd0Z3BeIKcUUrqx
         qePfqm9Rq4vCPmNAVYs9Jx7hTis5VVBjYPZEgzapebV33Uyi57Klg5bE9Ti0fYRWYI
         nZu7pk10A9pIg==
Message-ID: <4487fb84-9144-4d48-7b0f-28dfe2ad4ccc@gnuweeb.org>
Date:   Wed, 29 Jun 2022 21:51:36 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing v1 5/9] arch/arm64: Rename aarch64 directory to
 arm64
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
 <20220629002028.1232579-6-ammar.faizi@intel.com>
 <a2a07e28-4955-4b60-d2c4-2bfde114d6e9@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <a2a07e28-4955-4b60-d2c4-2bfde114d6e9@kernel.dk>
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

On 6/29/22 9:48 PM, Jens Axboe wrote:
> On 6/28/22 6:27 PM, Ammar Faizi wrote:
>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> In the Linux kernel tree, we use `arm64` instead of `aarch64` to name
>> the directory that saves this arch specific code. Follow this naming
>> in liburing too.
> 
> I don't feel too strongly about this, though I do think the linux
> kernel is wrong in this regard and liburing is doing it right :-)

OK, will drop this in v2.

-- 
Ammar Faizi
