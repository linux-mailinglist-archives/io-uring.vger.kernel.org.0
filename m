Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF515603A5
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 16:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiF2Owc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 10:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbiF2OwV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 10:52:21 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B468E1EAC8
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 07:52:20 -0700 (PDT)
Received: from [192.168.88.254] (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 8B6AD7ED9F;
        Wed, 29 Jun 2022 14:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656514340;
        bh=ycbCDHzHTJZboHNamtzLNDtZynuHfqoL/nxgg2x35SU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jmaOIzaY9i3XNven3F72iCR9eK/4xpQDTI5eIkKbmtIC5irHAq1aPbvO/k2vPK7fx
         JNEiO/RMnJhOvZ7/zXM4VzNQ2jOEDm8RQCJ8r/z1e6ocNH4DhNPQhF7FNSj+mFpWS1
         fqJXXDsmnlEg/eXiEPt1G+cP3yThr25ZFJiJW67L3MdFMhjrxiNQuohRaJAeB9H++8
         V+xRDVviF7Ei4PjnpupYrFKwChUIq6/YRqnXpcxJE2strpTpNaweRyHCvE/qS5UQ0i
         02rSUi/RWX5O8yAwpsaxv3gMk3jukii7YdVUXN+MQMu3oeZnRbmdANyEma16zrs+fs
         7eUhxHnb9uxlA==
Message-ID: <34daa7de-c6ae-f23a-293f-a22bda67bd6f@gnuweeb.org>
Date:   Wed, 29 Jun 2022 21:52:12 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing v1 7/9] arch/arm64: Add `get_page_size()`
 function
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
 <20220629002028.1232579-8-ammar.faizi@intel.com>
 <8bfba71c-55d7-fb49-6593-4d0f9d9c3611@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <8bfba71c-55d7-fb49-6593-4d0f9d9c3611@kernel.dk>
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

On 6/29/22 9:49 PM, Jens Axboe wrote:
> On 6/28/22 6:27 PM, Ammar Faizi wrote:
>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> This is a preparation patch to add aarch64 nolibc support.
>>
>> aarch64 supports three values of page size: 4K, 16K, and 64K which are
>> selected at kernel compilation time. Therefore, we can't hard code the
>> page size for this arch. Utilize open(), read() and close() syscall to
>> find the page size from /proc/self/auxv. For more details about the
>> auxv data structure, check the link below.
> 
> We should probably cache this value if already read? At least I don't
> think we have systems where the page size would differ between
> applications.

Good idea, will use a static variable to cache it in v2 then...

-- 
Ammar Faizi
