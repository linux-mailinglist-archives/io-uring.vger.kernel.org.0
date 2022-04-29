Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EDC5153E8
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 20:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380105AbiD2Srv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378784AbiD2Sru (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:47:50 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DF7CE650
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:44:31 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e1so4534694ile.2
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=/hOqfPof6MGoQyHiGJJBxx3mVIUhm+cWYPpkYdkl/LU=;
        b=0lyHe+A8lY+849yDj1Fxa+sGKdOGYX0HrqlflKP0miLo2RbGfypbQpSypXp5Ob5Zgb
         ujI0mO1FWlqhgEEJuyR0DsyBlCSJKBRBqN6prjIP7fN2b+ssgpJgZ0BOY2xntlyzQbfu
         Cs2bJUhhYqJFmTKaz9tvBCznPxlo98U2ImezWpw3lUxNOUqjTRIk9rWx11eJCNCRbnGL
         eNY1SBkxCGlSP41MiDhLlH0RIA9x3MGyQH7OQ2b5/E9Rkq4BAQ5DImJ6DBoH7EIXIDCe
         pTTXGiqQWUxclcWLzP+cWQLLE60w6ha/WekUuEI2Wf+vG4gXIqtD7yKgl3QLDmGMB0u+
         ERLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/hOqfPof6MGoQyHiGJJBxx3mVIUhm+cWYPpkYdkl/LU=;
        b=rRwxaa0vDUyyXDTQKOBViacOCJRLModCWZrUQmLwLv32h9dFnOqDTl2IAhTZGVshnb
         ovg1FCIlyR6PYk2pCXzpdiwPGW9ov/uBaVlNToh3dA4w3cPuSDQuBFJtKbICiKGDEmII
         RqusPrEfKu9ttuwei/bYc5XONi0M1kcQ9WeNDvvcv+3xi3mZJM+NX8oJd4qz0uPg3yAZ
         vwMjNj2qpfn916OhT2DCgRunQe+WKe9Zrl5NiBhE1OaeQ3YwAHRFeErx+edxGu5nDIU+
         BPmWIBx83M7VPuAnXOzRDwKyEL1VQ30iLmoYk1RANXAo1DqBDe7At2XGum8zLpRkUcsS
         EovA==
X-Gm-Message-State: AOAM533cB4uc+VgbeYX6DNscN76/Xj+o6/IrDjiWoEvro8PQKV95AO3N
        GBIFotGmr7wH4zUXkS/b15pzJGuWBJ2O6g==
X-Google-Smtp-Source: ABdhPJyU1PcKMZb3njYswo1ghmOZNU4URT/mY6Gee4lQJpOXCNPCrqEXb4j5Bc8K8NJsYr3RbEuYSg==
X-Received: by 2002:a05:6e02:1748:b0:2cd:a0ea:8ff4 with SMTP id y8-20020a056e02174800b002cda0ea8ff4mr263265ill.269.1651257870818;
        Fri, 29 Apr 2022 11:44:30 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k18-20020a056e02135200b002cde6e352c6sm729937ilr.16.2022.04.29.11.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 11:44:30 -0700 (PDT)
Message-ID: <065df62a-a4bd-27d7-58eb-437d11995890@kernel.dk>
Date:   Fri, 29 Apr 2022 12:44:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET 0/2] Add support for IORING_RECVSEND_POLL_FIRST
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
References: <20220427015428.322496-1-axboe@kernel.dk>
 <7368ecc8-1255-09a5-0d1e-e4250062f84e@gmail.com>
 <cc44706e-a249-86b6-55f5-38683ad110af@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cc44706e-a249-86b6-55f5-38683ad110af@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/22 12:40 PM, Hao Xu wrote:
> 
> 
> On 4/30/22 02:31, Hao Xu wrote:
>> On 4/27/22 09:54, Jens Axboe wrote:
>>> Hi,
>>>
>>> I had a re-think on the flags2 addition [1] that was posted earlier
>>> today, and I don't really like the fact that flags2 then can't work
>>> with ioprio for read/write etc. We might also want to extend the
>>> ioprio field for other types of IO in the future.
>>>
>>> So rather than do that, do a simpler approach and just add an io_uring
>>> specific flag set for send/recv and friends. This then allow setting
>>> IORING_RECVSEND_POLL_FIRST in sqe->addr2 for those, and if set, io_uring
>>> will arm poll first rather than attempt a send/recv operation.
>>>
>>> [1] https://lore.kernel.org/io-uring/20220426183343.150273-1-axboe@kernel.dk/
>>>
>>
>> Hi Jens,
>> Could we use something like the high bits of sqe->fd to store general flags2
>> since I saw the number of open FDs can be about (1<<20) at most.
> 
> oops, sorry my bad, (1<<20) is just a default value..

Indeed, you can certainly go higher and people do.

-- 
Jens Axboe

