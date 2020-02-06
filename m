Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E2C154C7D
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 20:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFT47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 14:56:59 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33077 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBFT47 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 14:56:59 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so7645710ioh.0
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 11:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Q1s66fc5wEyyCtqAZ1fxyuIa4B0bjzdDWKhuT8omqjw=;
        b=YYJZJvMgL+oKB4Kf9hFzm3HKoaJu4d8ykkFQ54Qte3tsBTUxwnRX9PA8npvcW4R9JY
         q3LrSwfGvqC1MZVMiPx2jzWpkrmI45mvpBJqG1TIqBlepEoNV1jCbazWZ2k9YzKAHWU/
         mz+YiPwzqojbBKLyr2B6babbXal5qxQ849vDtTPPSSc7LNkgyPHZIr6J97sA9lrBeqQ/
         bWo6rkPlM795YTm1cLiKWR2AKWCqHJGZxpPJp+3Xm0rlJ25V5pDr/iBP3HeS67VEmdJ5
         jPHG7XsWJ69BLrtvkHg+Q6gyCE1F0nBFysQG9DC4DlMqBTjfMRjGakcrcWQlLdahOJ2f
         Mq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q1s66fc5wEyyCtqAZ1fxyuIa4B0bjzdDWKhuT8omqjw=;
        b=agDKJIgAshaQYSWQvWfHVRwAv9Gc32+VYoUJRcvygDAfKjC9d3yAvhmLMnhYCxjLQS
         7MFsA2CGii2ZxfUGsCBtGpgfqyUaacO90EzAtNxaa7CM4G7iVTvZSCaRDFOo7homg9TQ
         M9xbYmb9Ty6lVNezKqwM2t0d9NqJeAvcdELzFmu99kuNUujRHoPe8KyurLLXt+72Fque
         MnF2v4cAviiyhlM2AOKoHfiE2v4v/asDGZGS6RH870OL5oVEPhIVOks1vcpenHEfFg96
         q12TVxo46IUpPZoODyMecfZqwPAfj8n/l7rHaP8dsYkMYc/2NGYMLSiKL6OK7+KtGI0k
         /YGg==
X-Gm-Message-State: APjAAAXUL3d1L7hUcXiiHA3nf/aac32Cgtig7fh10eIS3k3BGNQfqfZ0
        O6XYm0eU3TbVcaCtuTiijyL/yw==
X-Google-Smtp-Source: APXvYqz+QvSEt+Y4gfc2jJkwH7BWM2Rg6NhieoRYQgbqTyY53hfJxMdb04HI/dWIHvGF6PgyppNXgg==
X-Received: by 2002:a6b:5902:: with SMTP id n2mr24866691iob.298.1581019018760;
        Thu, 06 Feb 2020 11:56:58 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o1sm156128ioo.56.2020.02.06.11.56.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 11:56:58 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
 <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
Date:   Thu, 6 Feb 2020 12:56:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 10:16 AM, Pavel Begunkov wrote:
> On 06/02/2020 20:04, Pavel Begunkov wrote:
>> On 06/02/2020 19:51, Pavel Begunkov wrote:
>>> After defer, a request will be prepared, that includes allocating iovec
>>> if needed, and then submitted through io_wq_submit_work() but not custom
>>> handler (e.g. io_rw_async()/io_sendrecv_async()). However, it'll leak
>>> iovec, as it's in io-wq and the code goes as follows:
>>>
>>> io_read() {
>>> 	if (!io_wq_current_is_worker())
>>> 		kfree(iovec);
>>> }
>>>
>>> Put all deallocation logic in io_{read,write,send,recv}(), which will
>>> leave the memory, if going async with -EAGAIN.
>>>
>> Interestingly, this will fail badly if it returns -EAGAIN from io-wq context.
>> Apparently, I need to do v2.
>>
> Or not...
> Jens, can you please explain what's with the -EAGAIN handling in
> io_wq_submit_work()? Checking the code, it seems neither of
> read/write/recv/send can return -EAGAIN from async context (i.e.
> force_nonblock=false). Are there other ops that can do it?

Nobody should return -EAGAIN with force_nonblock=false, they should
end the io_kiocb inline for that.

-- 
Jens Axboe

