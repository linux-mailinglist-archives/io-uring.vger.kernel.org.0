Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB733E4758
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 16:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbhHIOT2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 10:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhHIOTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 10:19:20 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D1BC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 07:19:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bo18so6176364pjb.0
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 07:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=btVQYXMSvj/Ga9xOjXRy1VOqvthxQwqf0+w3SiP6tXY=;
        b=TNmLqzP5JFIRRIoOOrDAZAth9cDxuqTFVwEMkod/Aj3dmO7L+IEzQKFvkX5iaQ7zrE
         5JVwrOdIhz8Opn12h4QYZ1pysxI3e7oTBAEWvtbayZH17cWg4SM+Rg4GY+gqLoov+1Rb
         g/dV/YMGYQDB5lp8J3vpbaFpIzhjmk1+M14m9x2ntg7n7qf6ZjKZz4D7H3TyDtNEymZG
         sqt/5tTlnRPVpBm+zek2LoHkLKYRHWQk5A00LamfwLuehhhRa6yYgfLWLqbwRPjUyzVj
         QSu/befZ6RAdEUqHdD+98TC4OU5ZtcTCECE4xaPKSr2F0iMh13oFhZA6Rnem1i/9EoYY
         EoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=btVQYXMSvj/Ga9xOjXRy1VOqvthxQwqf0+w3SiP6tXY=;
        b=D+vh2VFWGx/wNYgBlhLvkW37D7E+EoHTr5dMO18xN1jC9OEQkq5iUcwOebzqF6VVo8
         Q/pVRsSc5p7EpCc6Ynx4MNRyY0lSZmhV/YEwqucVj+EqWb/xWFJTxjPEaOgrEJH0i3Ct
         bk2tJC6JAsCfejcr4iOIFHlqxSbVImCSD3SvfQlPai+lu42RVyd8XjQmg7mgPcErPnuN
         sFOJH03zvr6WEr7cP14x/UznmqgiV6G+gZv2n/gWUVmI8jHSoBxRZcgKVNHYlYvDY+uc
         vZwk7DKEkL7vuA5ymPsx6sLGuAjNZ4fXEsVpyB5J44iMxoS4Fk9mLFSHVTmnRcN3dD+R
         TPOQ==
X-Gm-Message-State: AOAM532/Kbr7v24cHYBMJeGjbMalg8dr8l5SeAchkqsYb8YWeSA2eQHp
        u5ZVEdmemyQE0A9j1ELPCbpDeg==
X-Google-Smtp-Source: ABdhPJws4vOdPf4PmnI+pQkFEzNBRgCU0x+8QMk83emLZf1y8hgAysAwEuQtMGsZ6oPDG6i+CHJwmg==
X-Received: by 2002:a63:f342:: with SMTP id t2mr776597pgj.45.1628518739783;
        Mon, 09 Aug 2021 07:18:59 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id z15sm21059050pfn.90.2021.08.09.07.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 07:18:59 -0700 (PDT)
Subject: Re: [PATCH 1/2] io-wq: fix bug of creating io-wokers unconditionally
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210808135434.68667-1-haoxu@linux.alibaba.com>
 <20210808135434.68667-2-haoxu@linux.alibaba.com>
 <eb56a09e-0c10-2aad-ad94-f84947367f07@kernel.dk>
 <36fa131c-0a86-81de-2a93-265af921c38a@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2df89a6c-edf4-8b1d-85d2-720ee25d816c@kernel.dk>
Date:   Mon, 9 Aug 2021 08:18:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <36fa131c-0a86-81de-2a93-265af921c38a@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 8:08 AM, Hao Xu wrote:
> 在 2021/8/9 下午10:01, Jens Axboe 写道:
>> On 8/8/21 7:54 AM, Hao Xu wrote:
>>> The former patch to add check between nr_workers and max_workers has a
>>> bug, which will cause unconditionally creating io-workers. That's
>>> because the result of the check doesn't affect the call of
>>> create_io_worker(), fix it by bringing in a boolean value for it.
>>>
>>> Fixes: 21698274da5b ("io-wq: fix lack of acct->nr_workers < acct->max_workers judgement")
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io-wq.c | 19 ++++++++++++++-----
>>>   1 file changed, 14 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index 12fc19353bb0..5536b2a008d1 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -252,14 +252,15 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>>>   
>>>   		raw_spin_lock_irq(&wqe->lock);
>>>   		if (acct->nr_workers < acct->max_workers) {
>>> -			atomic_inc(&acct->nr_running);
>>> -			atomic_inc(&wqe->wq->worker_refs);
>>>   			acct->nr_workers++;
>>>   			do_create = true;
>>>   		}
>>>   		raw_spin_unlock_irq(&wqe->lock);
>>> -		if (do_create)
>>> +		if (do_create) {
>>> +			atomic_inc(&acct->nr_running);
>>> +			atomic_inc(&wqe->wq->worker_refs);
>>>   			create_io_worker(wqe->wq, wqe, acct->index);
>>> +		}
>>>   	}
>>
>> I don't get this hunk - we already know we're creating a worker, what's the
>> point in moving the incs?
>>
> Actually not much difference, I think we don't need to protect
> nr_running and worker_refs by wqe->lock, so narrow the range of
> raw_spin_lock_irq - raw_spin_unlock_irq

Agree, we don't need it, but it's not a fix as such. I'd rather defer that
one to a separate cleanup for the next release.

-- 
Jens Axboe

