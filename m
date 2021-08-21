Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836553F3AFC
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 16:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhHUO0c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 10:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhHUO0b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 10:26:31 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D52FC061575
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 07:25:52 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id a201-20020a1c7fd2000000b002e6d33447f9so8547717wmd.0
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 07:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QHpCZ0y7qMUC6V5MALaqb4pxEBGVOdtWoAoIhwiqnX4=;
        b=Qwo6IkfPyKiYvVnRlYxRKY3VK5iUFSZmmGgzDZ4eCLGt2IcYYMLUoX6CJVFGXltccd
         65YUkXNqAmmcPpeZl8y1tzhS82iSsM/4zyOQuE/P8Evu2uxwxhnhURavv92U+P6TnX9r
         j4JEQYPMcaVxthYlOUCQt43s4+KqUAlymbfZxJHuO7md6Gh+Ri4SNiAgZGphsLQetv37
         oSwhIsWPHTC25Ldbl3Up1T/1UUucHLYcCl08wHp/rrU9lnMiMODIZugUeqmH9tYK6u2/
         UHyFbvXhdONUAITOdJ0fqncimAnrpQC7bsZb9ehxHtqnIQrvGFwPW+KTgFPduVUpPZLX
         37YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QHpCZ0y7qMUC6V5MALaqb4pxEBGVOdtWoAoIhwiqnX4=;
        b=cFW0R8H2In6HPNLa2c9JocGtCjLJXFtpCihz15Pcv4Hmj1+VZkgJqziQPzOOYBm1yA
         CnJcLtV9iwhNe0z1CYHr4jbWd45TT2I/XWN8gptn996CQWuqFWGIiXGC7izkCqZqLm1V
         cElD63FW3NaH0VIg8y4K5RJ7eXFnO0CQZMe4/U9RO0oKELAkyePo1ZQsJ71JQiihJkpR
         rvmEglONcYDQUpZJgows2Xjolt8gKYGCZ0Xj36jP+BY6oLOySb9+Nt7EZ+v2t0QEE782
         z22qcff1tLvTx1mBE19Sl24vLRVSBKjEyvyugpBXCTj1ORjqOsSLSax1s/mdko3jXApx
         o5Ww==
X-Gm-Message-State: AOAM5335V0PVc2PL2P8m2LPLSTslLV1saEP+x3nu+VezGqwm0dv9K4WU
        PKvCmwAEMgK37bc6AwjSyQFCDuLLTWA=
X-Google-Smtp-Source: ABdhPJz5kKWoDR/YKYx0CU521b8SDyzsdNOgJ2FUV7e2mF6Nbab4U8v+DqgR9WWXDDSCJj9VLPqP4g==
X-Received: by 2002:a05:600c:3ba9:: with SMTP id n41mr8301103wms.111.1629555950595;
        Sat, 21 Aug 2021 07:25:50 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id l2sm8967967wrx.2.2021.08.21.07.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 07:25:50 -0700 (PDT)
Subject: Re: [PATCH 0/3] changes around fixed rsrc
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1629451684.git.asml.silence@gmail.com>
 <1929aac2-14ca-789e-fe6f-faebd858abb4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8c0d4023-6b6b-8216-bdbe-d680a893cbc4@gmail.com>
Date:   Sat, 21 Aug 2021 15:25:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1929aac2-14ca-789e-fe6f-faebd858abb4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/21/21 2:18 PM, Jens Axboe wrote:
> On 8/20/21 3:36 AM, Pavel Begunkov wrote:
>> 1-2 put some limits on the fixed file tables sizes, files and
>> buffers.
>>
>> 3/3 adds compatibility checks for ->splice_fd_in, for all requests
>> buy rw and some others, see the patch message.
>>
>> All based on 5.15 and merked stable, looks to me as the best way.
>>
>> Pavel Begunkov (3):
>>   io_uring: limit fixed table size by RLIMIT_NOFILE
>>   io_uring: place fixed tables under memcg limits
>>   io_uring: add ->splice_fd_in checks
>>
>>  fs/io_uring.c | 61 ++++++++++++++++++++++++++++++---------------------
>>  1 file changed, 36 insertions(+), 25 deletions(-)
> 
> Applied - especially 3/3 will be a bit of a stable pain. Nothing difficult,
> just needs attention for each version...

Yep. Thanks, Jens

-- 
Pavel Begunkov
