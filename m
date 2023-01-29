Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDC96802E7
	for <lists+io-uring@lfdr.de>; Mon, 30 Jan 2023 00:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjA2XRW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Jan 2023 18:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjA2XRV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Jan 2023 18:17:21 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709E02D7E
        for <io-uring@vger.kernel.org>; Sun, 29 Jan 2023 15:17:20 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p24so9866717plw.11
        for <io-uring@vger.kernel.org>; Sun, 29 Jan 2023 15:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e/0J/IzzPq9fdcyZAs/joxNcTZNhSj7v6eOpqfWjdZA=;
        b=ySMaG1xqRmhcrlSoiBsoVrGpP0E2KQsQyR9YTXTm2v8SKbj0YuSa+bAK0bUcJMVhNL
         3+xJShLMuCZDwFfwUK/jc+8xLT8La5CAFehw87OlLdDQKBSq8fLTysQCSmhEjBSNfB5f
         8Z4IMox5cdFO56e/qbKsFVRKJLMw9TaOQyTsPzIqKEL/tvgcm9h5iAt8teQSHzX7MfRP
         Y6Lhm5tNEhASiLgI2lg5y2SrF0zBDXC0nwPP69nM5kRB8vgwh0ebgn0jAsAUunqA3J70
         7cpnsw2bMf1jIs8KzI+hJZjDy5kLS4cACTXSd4+7Xqye/E4jWboPwTRm9Cn6C+IWs+nk
         /ZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e/0J/IzzPq9fdcyZAs/joxNcTZNhSj7v6eOpqfWjdZA=;
        b=dcD2M+HRhbSnWmyB0euvolgg1QxM7x98cDiKxkUNNM//a2qeIqun7ooxYF9zHCl/J/
         vn+7ZQW9nlBcKmmGVqzFiUSz0p0YTUKOsqrSibpv2AlNez1orSplORPlvlNvKxH9NHHE
         NzuqaecHWrdCgDdWyOAJo9LagwKSVKcKLbZF6kzKU9axSKNQqPY6YvK5Z6AYIOEm2hE0
         DrJb3/Q0SB8UY0ccgtz0l7as1O5UEOXO7J33m4fP9HV9YNj12G/emupy8mNcDsUOwMMi
         6xIzINqzv9x2KdE/i+qvyORuIEMs3NCYC24c0F7hGuh7guaHzeYRzdNaFrAQb360C5/7
         sXaQ==
X-Gm-Message-State: AO0yUKX70esPIDKF0yOM0XFzHK90dc+FNBxQ+2yiC9J2c6M2Rw5mcyMT
        Q+g0goDNSDSXnZyuhKJJ22Vv3Q==
X-Google-Smtp-Source: AK7set+xLWTAicMdDJJG8+qXj/fdpNP6dTzyQ7QgElJe6ny0/N9Wc64CPQCwB5wH+7VUJteUc0L/Wg==
X-Received: by 2002:a17:902:f68e:b0:196:4d17:2f51 with SMTP id l14-20020a170902f68e00b001964d172f51mr3082802plg.5.1675034239863;
        Sun, 29 Jan 2023 15:17:19 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902bd4400b00193020e8a90sm999181plx.294.2023.01.29.15.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 15:17:19 -0800 (PST)
Message-ID: <aa6c75e2-5c39-713a-e5c2-8a50a4687b11@kernel.dk>
Date:   Sun, 29 Jan 2023 16:17:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-next 1/4] io_uring: if a linked request has
 REQ_F_FORCE_ASYNC then run it async
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20230127135227.3646353-1-dylany@meta.com>
 <20230127135227.3646353-2-dylany@meta.com>
 <297ad988-9537-c953-d49a-8b891204b0f0@kernel.dk>
In-Reply-To: <297ad988-9537-c953-d49a-8b891204b0f0@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/23 3:57 PM, Jens Axboe wrote:
> On 1/27/23 6:52?AM, Dylan Yudaken wrote:
>> REQ_F_FORCE_ASYNC was being ignored for re-queueing linked
>> requests. Instead obey that flag.
>>
>> Signed-off-by: Dylan Yudaken <dylany@meta.com>
>> ---
>>  io_uring/io_uring.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index db623b3185c8..980ba4fda101 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1365,10 +1365,12 @@ void io_req_task_submit(struct io_kiocb *req, bool *locked)
>>  {
>>  	io_tw_lock(req->ctx, locked);
>>  	/* req->task == current here, checking PF_EXITING is safe */
>> -	if (likely(!(req->task->flags & PF_EXITING)))
>> -		io_queue_sqe(req);
>> -	else
>> +	if (unlikely(req->task->flags & PF_EXITING))
>>  		io_req_defer_failed(req, -EFAULT);
>> +	else if (req->flags & REQ_F_FORCE_ASYNC)
>> +		io_queue_iowq(req, locked);
>> +	else
>> +		io_queue_sqe(req);
>>  }
>>  
>>  void io_req_task_queue_fail(struct io_kiocb *req, int ret)
> 
> This one causes a failure for me with test/multicqes_drain.t, which
> doesn't quite make sense to me (just yet), but it is a reliable timeout.

OK, quick look and I think this is a bad assumption in the test case.
It's assuming that a POLL_ADD already succeeded, and hence that a
subsequent POLL_REMOVE will succeed. But now it's getting ENOENT as
we can't find it just yet, which means the cancelation itself isn't
being done. So we just end up waiting for something that doesn't happen.

Or could be an internal race with lookup/issue. In any case, it's
definitely being exposed by this patch.

-- 
Jens Axboe


