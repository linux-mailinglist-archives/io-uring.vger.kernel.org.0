Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895F4154CCF
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 21:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgBFUQc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 15:16:32 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:38980 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgBFUQb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 15:16:31 -0500
Received: by mail-io1-f68.google.com with SMTP id c16so7675656ioh.6
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 12:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Rl1cZ2hCYZ3zf8LtvrBF29RarrZSPRnALrhsal0XxzM=;
        b=hVCX27GHhG55W2iQC/Y4fgfE3z5pEMKyhxsAIUwz/wKAj1DPQnGrakm4LTV6MrlED0
         nYO8+lCcV+IETyQdfaH1M4gUHbeHOcnNJX+M9/vFbyk3ADcYVMVjNNchm1yBoZ8CB4kL
         8BLo9foCkLIscO7L7atj0hMAwz6CvZZGl00KpUDHCg12VWrHoBfeCoQzBiDeqKU3nhD8
         5Wr2j7rj8nXyNFv5WUx2DkHA26yHDn+9qqMAFEv0PS+mv1asZ8GGDCu8jYvAuA8Hi9mT
         nGY2NFolzWTedWQlBGCEErnQyhlxP2PGcv5hw2zoCf3MujmctnSM5wIF20oSWmvE28ki
         OetQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rl1cZ2hCYZ3zf8LtvrBF29RarrZSPRnALrhsal0XxzM=;
        b=YAIBHANENBb79WMDpoFYbr0k7rL2NTHVdw+EqVcotJyYCgrClXQfd298aqVLmPHA8K
         /VOaKtHR9yghQw2c8tuWysMVoAcswY24lBSqmujJCN6CR/ksRHPEB1gAQ0/C4PtKAITw
         bWLoKAVZdhuK1pdgiGonBFa0dVqzjUF2nlYJJkRRZViByGPOUERGlFt0flyJjy8CLwL9
         F4EHeIyp9ZAfuXvpXbcvr/BrKjyaYFxhqzwKiN/keshHSkSJpb05x5AEDCQqmntL2wDJ
         6rNZCJGLP2SK58mE+FiFxoEsxkzXc8vlyERiZY1caZEJExBKX96pZ6ri14b0CrLCy0ou
         +OjA==
X-Gm-Message-State: APjAAAWCxoh62vqMw6l0i8ljn5S/0Sj2kH9i/ncUGVqVCAkhwDKmLy/7
        7scIl7bT8e0aUA2YakRU0CDPFw==
X-Google-Smtp-Source: APXvYqy0mprHkAChVDzZxmGW8RDOISjy9ZkVdA9272pGAK0JdxV+Fjme9WeJqnbesw/CaIqaTzx5yA==
X-Received: by 2002:a6b:3b10:: with SMTP id i16mr36600512ioa.46.1581020189887;
        Thu, 06 Feb 2020 12:16:29 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s88sm286832ilk.79.2020.02.06.12.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 12:16:29 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
 <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
 <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
 <4f7f61d3-b3f9-43db-ad32-ee502dc06c8b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>
Date:   Thu, 6 Feb 2020 13:16:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4f7f61d3-b3f9-43db-ad32-ee502dc06c8b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 1:00 PM, Pavel Begunkov wrote:
> On 06/02/2020 22:56, Jens Axboe wrote:
>> On 2/6/20 10:16 AM, Pavel Begunkov wrote:
>>> On 06/02/2020 20:04, Pavel Begunkov wrote:
>>>> On 06/02/2020 19:51, Pavel Begunkov wrote:
>>>>> After defer, a request will be prepared, that includes allocating iovec
>>>>> if needed, and then submitted through io_wq_submit_work() but not custom
>>>>> handler (e.g. io_rw_async()/io_sendrecv_async()). However, it'll leak
>>>>> iovec, as it's in io-wq and the code goes as follows:
>>>>>
>>>>> io_read() {
>>>>> 	if (!io_wq_current_is_worker())
>>>>> 		kfree(iovec);
>>>>> }
>>>>>
>>>>> Put all deallocation logic in io_{read,write,send,recv}(), which will
>>>>> leave the memory, if going async with -EAGAIN.
>>>>>
>>>> Interestingly, this will fail badly if it returns -EAGAIN from io-wq context.
>>>> Apparently, I need to do v2.
>>>>
>>> Or not...
>>> Jens, can you please explain what's with the -EAGAIN handling in
>>> io_wq_submit_work()? Checking the code, it seems neither of
>>> read/write/recv/send can return -EAGAIN from async context (i.e.
>>> force_nonblock=false). Are there other ops that can do it?
>>
>> Nobody should return -EAGAIN with force_nonblock=false, they should
>> end the io_kiocb inline for that.
>>
> 
> If so for those 4, then the patch should work well.

Maybe I'm dense, but I'm not seeing the leak? We have two cases here:

- The number of vecs is less than UIO_FASTIOV, in which case we use the
  on-stack inline_vecs. If we need to go async, we copy that inline vec
  to our async_ctx area.

- The number of vecs is more than UIO_FASTIOV, this is where iovec is
  allocated by the vec import. If we make it to completion here, we
  free it at the end of eg io_read(). If we need to go async, we stash
  that pointer in our async_ctx area and free it when the work item
  has run and completed.

-- 
Jens Axboe

