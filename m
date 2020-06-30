Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4945F20F77F
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 16:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbgF3Oq4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 10:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgF3Oqz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 10:46:55 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D894C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:46:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e18so10049972pgn.7
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RhclxmHJZEf7D9s84DaExKT4SgyKfGzOQ5WKf+IpWTw=;
        b=YMlbz9u4OM9xkLA14DBup1FUIwhB6On6HISvsbLpSMQU1sWrVGnOtj0hmdQXeoMatk
         tWttTSBKxj6F1qbL4VAPtotPKhP19y7i81XzuMbqvYYeQ+xbf3PBvC6eAMGS5EfEKus9
         JwVdJNs4F0ko4AHB56YUTsxCu8D19W/nv2z4AcV10yeSU3Q9WfvIaYlSbith67iczBOZ
         t2LojP9BGqzIQOMw9Cj93/vZJARibkPM14s/86GkMt4rJj18tmzJsH+2ZrPkVvSWEAqv
         M/4hvjKioW1PZfrupm4fU+dA++pBazQqTwPQ2SQcr3z0cb/NYCNvlYLvHw2q9HT5pNpz
         F/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RhclxmHJZEf7D9s84DaExKT4SgyKfGzOQ5WKf+IpWTw=;
        b=eV0OsSu/O9tS+ShdTByCzG2BCUg+wkJ1o0drW0LSHEKzo1LS1OgPyHmY7GHHkXC1pp
         MMyCjZThiq/K2ZxHEyHuNMRk3zJ/pb8W/58dNVpfQtK0oTguu0PKGTy69MYIve4MMZNf
         X2tE7bnv/1o3H+RWSLI4fwdmPCC29ELpvquSMEaKr2FxABVVMhzUr89CEGoHqXRg6BlI
         Dvrjt7n+sG2UXCua5qGzR+6F710Zy3kdOo8atFu5NgI8Y4G9xfgJjcZbLWbmFa2a5aLH
         iflN8jonQ4XFT3vGHANaLkUGQmvmUIH71tUhdF9kaJ9FR+Il4l9IWFKqalITJE4TCjXR
         ZX5Q==
X-Gm-Message-State: AOAM531izgujfjnUYik+y2oWZ/fso9XLpDqEBWodWkfWEoiBbG6+V+y5
        Nu/iLpP9Txgw9ZFQeTtu6iltI+4s3B3RtA==
X-Google-Smtp-Source: ABdhPJxzkexKW/1RgOzsu+3hiru2VsV+m0TnqlCZMj5paLfwMZ01ctJkBfAFxxEh7JKaJ87f2POtwg==
X-Received: by 2002:aa7:8388:: with SMTP id u8mr19819106pfm.253.1593528414868;
        Tue, 30 Jun 2020 07:46:54 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4113:50ea:3eb3:a39b? ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id z2sm3165411pff.36.2020.06.30.07.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 07:46:54 -0700 (PDT)
Subject: Re: [PATCH 2/8] io_uring: fix commit_cqring() locking in iopoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593519186.git.asml.silence@gmail.com>
 <75e5bc4f60d751239afa5d7bf2ec9b49308651ac.1593519186.git.asml.silence@gmail.com>
 <65675178-365d-c859-426b-c0811a2647a3@kernel.dk>
 <6c499cf3-418d-2edf-d308-2bb5a8d1d007@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <312bbba1-878c-5681-5e6c-b6de3f7feb55@kernel.dk>
Date:   Tue, 30 Jun 2020 08:46:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6c499cf3-418d-2edf-d308-2bb5a8d1d007@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/20 8:36 AM, Pavel Begunkov wrote:
> On 30/06/2020 17:04, Jens Axboe wrote:
>> On 6/30/20 6:20 AM, Pavel Begunkov wrote:
>>> Don't call io_commit_cqring() without holding the completion spinlock
>>> in io_iopoll_complete(), it can race, e.g. with async request failing.
>>
>> Can you be more specific?
> 
> io_iopoll_complete()
> 	-> io_req_free_batch()
> 		-> io_queue_next()
> 			-> io_req_task_queue()
> 				-> task_work_add()
> 
> if this task_work_add() fails, it will be redirected to io-wq manager task
> to do io_req_task_cancel() -> commit_cqring().
> 
> 
> And probably something similar will happen if a request currently in io-wq
> is retried with
> io_rw_should_retry() -> io_async_buf_func() -> task_work_add()

For the IOPOLL setup, it should be protected by the ring mutex. Adding
the irq disable + lock for polling would be a nasty performance hit.

-- 
Jens Axboe

