Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC552FB3BD
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 09:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbhASIID (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 03:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731402AbhASIBF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 03:01:05 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2509AC061573
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 00:00:18 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id my11so1095999pjb.1
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 00:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nsE+qBnaiv3GVfViCouGJKwaHzzogENhZgaw5giCy5Q=;
        b=eBrOu2ZcjFG18zpkquMs+5qDnAjaSQQiqT5EJKnRDU0+4BSUJzmCgw9gn+4pu6L3yK
         +esQ+BqcQc8Kjy/5ptEBHN0gVwjwlkeb3ERGZfGmXEE27qCyawBClHSIDE9FZ6PRAlT0
         pULwzujyK67I/NdDmchpSj8X/SuLYxLAxnFM0kueqcz6JXOxzcPRXV0px+1QVhA3w9iM
         CffZnIhbVDvMLL8Q17w+cHr/331SLpSUb8jpHr1PNqXSp2HIxfnf/N/Te5piDnyvKigl
         16HaY8MEMQ2IoIDfPVkRA1CPK/32ogwK1uU6d0boke1D02QnznLathBJn91BGEg5A13D
         Im+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nsE+qBnaiv3GVfViCouGJKwaHzzogENhZgaw5giCy5Q=;
        b=p/rB4alXWR0EECDnqvIKNFqNt4Hs/ooTeF+Zod9Jxxg+i3Srt0gMF2Gio6RbTk/kWB
         L7yDpZy7dpLz2Oj2l0M60ShgJ4WSZ3PYkPBcQcLa8LzNxbuZUpRwzdffZggsA/04RSHD
         ehbl4XT+wxTCvgw2E/u/1hmmtA1Qa1iZs2b3ek47tegfBYNtmzjBlzo2BbsTxrXJU7wD
         jYeFsPkue3bOr/ngcGHjL1XQ+S4Zwq9QqGDk18U9Wz31bDETv4KcGoMNNkcBxJ/LwrrN
         xmfvspiopaacav9z5xXb1cp92jI7QO93lxchvYhfECX8cED6VQ9oWKHqbTbP7Gm9/9Uc
         uXag==
X-Gm-Message-State: AOAM533GRQINEcVVM7yJzKW9JSQmCBsQPon4cWb8/zDpjPqHmCMMlwax
        OLXOwBhuSOT/U21LlB1zKKy5JdU+Ds0=
X-Google-Smtp-Source: ABdhPJxq0szm9natawEQVLVqnIgN1F5tiYclZQ/O/JduUI4WnErf33N7LDUYwajEPaDJWsxBQ6Y/VA==
X-Received: by 2002:a17:90a:1a10:: with SMTP id 16mr3927264pjk.42.1611043217733;
        Tue, 19 Jan 2021 00:00:17 -0800 (PST)
Received: from B-D1K7ML85-0059.local ([47.89.83.82])
        by smtp.gmail.com with ESMTPSA id k15sm18297879pfp.115.2021.01.19.00.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 00:00:17 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix NULL pointer dereference for async cancel
 close
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1610963424-27129-1-git-send-email-joseph.qi@linux.alibaba.com>
 <4f1a8b42-8440-0e9a-ca01-497ccd438b56@gmail.com>
 <ae6fa12a-155b-cf43-7702-b8bb5849a858@gmail.com>
 <58b25063-7047-e656-18df-c1240fab3f8d@linux.alibaba.com>
 <164dff2a-7f23-4baf-bcb5-975b1f5edf9b@gmail.com>
From:   Joseph Qi <jiangqi903@gmail.com>
Message-ID: <17125fd3-1d0e-1c71-374a-9a7a7382c8fc@gmail.com>
Date:   Tue, 19 Jan 2021 16:00:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <164dff2a-7f23-4baf-bcb5-975b1f5edf9b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/19/21 10:38 AM, Pavel Begunkov wrote:
> On 19/01/2021 01:58, Joseph Qi wrote:
>>> Hmm, I hastened, for files we need IO_WQ_WORK_FILES,
>>> +IO_WQ_WORK_BLKCG for same reasons. needs_file would make 
>>> it to grab a struct file, that is wrong.
>>> Probably worked out because it just grabbed fd=0/stdin.
>>>
>>
>> I think IO_WQ_WORK_FILES can work since it will acquire
>> files when initialize async cancel request.
> 
> That the one controlling files in the first place, need_file
> just happened to grab them submission.
> 
>> Don't quite understand why we should have IO_WQ_WORK_BLKCG.
> 
> Because it's set for IORING_OP_CLOSE, and similar situation
> may happen but with async_cancel from io-wq.
> 
So how about do switch and restore in io_run_cancel(), seems it can
take care of direct request, sqthread and io-wq cases.

Thanks,
Joseph

> Actually, it's even nastier than that, and neither of io_op_def
> flags would work because for io-wq case you can end up doing
> close() with different from original files. I'll think how it
> can be done tomorrow.
>
