Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A21565D6F
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 20:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiGDSQX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 14:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGDSQW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 14:16:22 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB56B637C
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 11:16:21 -0700 (PDT)
Received: from [192.168.88.254] (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 70665801D5;
        Mon,  4 Jul 2022 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656958581;
        bh=MSrjuxI8s+EQnitdITXO/S74h0j/zVwNHbXsShw5Ciw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VOqvDN2RMOZvXp0TyBlzAZsJzhhLbHH0PJIia3uGX4PCW9taJPg3hp0YSL8E6hMr6
         FewsPqbiaixZryEuRUUwWEXY4TMXXfMUizhAnmNDYR2YggFCX/XNxXPaw34vlkyfzi
         24Km4aHBsRVxlR9gZs5CvckYDDIrJpNxCutKdPeDqMUJr1AVzxM/OURtfUhG2QVGpz
         MuubeCbjFvHECSXGLCFnv7QnpBvBqfu+LhPiCUwiWWfjXaqPHszKoLCA3O0uc37MGC
         lN+4K43eedPgejHQLVHY3S2yN97Yy+nSNElRSUcZD1ppXQDPDErPYeGMTqmfeJ9RpN
         JVBSgEaontP1Q==
Message-ID: <c750b558-ebcc-0d2f-f3fc-488d33776143@gnuweeb.org>
Date:   Tue, 5 Jul 2022 01:16:06 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing v3 03/10] arch: syscall: Add `__sys_read()`
 syscall
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220704174858.329326-1-ammar.faizi@intel.com>
 <20220704174858.329326-4-ammar.faizi@intel.com>
 <CAOG64qOvMW_UoSvHeMkwWJQST_CA7OAvP5ARJs12JjcQ8bCAPg@mail.gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <CAOG64qOvMW_UoSvHeMkwWJQST_CA7OAvP5ARJs12JjcQ8bCAPg@mail.gmail.com>
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

On 7/5/22 1:12 AM, Alviro Iskandar Setiawan wrote:
> On Tue, Jul 5, 2022 at 12:54 AM Ammar Faizi wrote:
>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> A prep patch to support aarch64 nolibc. We will use this to get the
>> page size by reading /proc/self/auxv.
>>
>> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> [...]
>> +static inline int __sys_read(int fd, void *buffer, size_t size)
>> +{
>> +       return (int) __do_syscall3(__NR_read, fd, buffer, size);
>> +}
> 
> __sys_read should return ssize_t and the cast should also (ssize_t).

Ah right, I missed it. Will fix in v4.

> With that fixed:
> 
> Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

Thanks!

-- 
Ammar Faizi
