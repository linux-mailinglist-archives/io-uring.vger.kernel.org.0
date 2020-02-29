Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3672317486E
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 18:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgB2Rcn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 12:32:43 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38886 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbgB2Rcn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 12:32:43 -0500
Received: by mail-pg1-f195.google.com with SMTP id d6so3206234pgn.5
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 09:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=25KNSBg9kcl4ku18skLT24eI9oonSb5X0vF+ZMfqX5o=;
        b=PqqAJy8uZXXJIUBTHE43X04y93w47Z12dQVwjgSdw4cVpfsqeqZ3yVuT2y+bBvqpO4
         pRoc2OQIl5rV9y/10oTkVovKmI0fhMLrGyQDeS4VX+FhG0XRC3GcN7Sb+kISg/j3WjUv
         JH0pntP/ZozbGbe48S1O4Ixzxg0SuoVNMxejmNtNH6N5IFTCr/I0hRxVggXM/eN0kGhx
         thNmEVkbyapUBcvIgJ+Tb0I1wRcHzWVZXw7dlH8nWiRoBoGHJri632wLc+E0bP32yCcp
         vYOLz+qaAu0wR+jlM3MRvFcJyXsUcr90FA7GB8VCN+vIvXbnI04gLAa8DbvZ/Rxj9Bxh
         jDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=25KNSBg9kcl4ku18skLT24eI9oonSb5X0vF+ZMfqX5o=;
        b=ZNxRDvFFU9WZ9Ws/C/+WYJllZLZNMHa5AxXGH+hbbp15fD5s9F1Jv4w5MtMggAIQH5
         1ORrq9GPv7EmZMSadWzexgvgzMZKDsDz8l6m6y5WCh9zY53tCbQoPARIJb4u+LbSY52F
         PEtpIBEscIaWtrDovIZy6iPeuikF2mFSk2XL7U4RCNKYSNYDt0WOP8pQ1dTgL38dQWBX
         3FYSE+73TCs7CI9oxsz2DeN0y33u8KjTYgdAli5bHzrM9xQee9qcWvQ4pSZR3QnB2q2r
         JZ4wDt64QHBdeFDke0fCodxmXlNl8mLXDakscQxhT+n0r1pQySBMaw430hB3cWn6eLqG
         xrGw==
X-Gm-Message-State: APjAAAXyI+nqtn24G5o/p2MZjRBbmIX6ci50zoe6vjbgYVNpYcLZpVke
        MjOE+XUdP/SSBgyLTF/8E0V83EDAo9w=
X-Google-Smtp-Source: APXvYqyB1PM9levP9E1JD4bhOoU4dn3+5iWtHHpStMFke/ahxZ7GwjkHaDQ6u1fWYIAI+fcSITlBXw==
X-Received: by 2002:aa7:820d:: with SMTP id k13mr10522621pfi.10.1582997560603;
        Sat, 29 Feb 2020 09:32:40 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a31sm568925pgl.58.2020.02.29.09.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 09:32:40 -0800 (PST)
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
 <7671b196-99cc-d0a9-3b7e-86769c304b10@gmail.com>
 <297b6e91-b683-80a3-38a2-9c3b845c4d06@kernel.dk>
 <d7eebc93-4efb-730c-21fd-d866dd54eaa6@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f55f74bf-9146-0720-ee8c-021732276d0b@kernel.dk>
Date:   Sat, 29 Feb 2020 10:32:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d7eebc93-4efb-730c-21fd-d866dd54eaa6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/29/20 4:36 AM, Pavel Begunkov wrote:
> On 2/29/2020 7:50 AM, Jens Axboe wrote:
>> On 2/28/20 5:43 PM, Pavel Begunkov wrote:
>>>> +static int io_provide_buffers(struct io_kiocb *req, struct io_kiocb **nxt,
>>>> +			      bool force_nonblock)
>>>> +{
>>>> +	struct io_provide_buf *p = &req->pbuf;
>>>> +	struct io_ring_ctx *ctx = req->ctx;
>>>> +	struct list_head *list;
>>>> +	int ret = 0;
>>>> +
>>>> +	/*
>>>> +	 * "Normal" inline submissions always hold the uring_lock, since we
>>>> +	 * grab it from the system call. Same is true for the SQPOLL offload.
>>>> +	 * The only exception is when we've detached the request and issue it
>>>> +	 * from an async worker thread, grab the lock for that case.
>>>> +	 */
>>>> +	if (!force_nonblock)
>>>> +		mutex_lock(&ctx->uring_lock);
>>>
>>> io_poll_task_handler() calls it with force_nonblock==true, but it
>>> doesn't hold the mutex AFAIK.
>>
>> True, that's the only exception. And that command doesn't transfer data
>> so would never need a buffer, but I agree that's perhaps not fully
>> clear. The async task handler grabs the mutex.
> 
> Hmm, I meant io_poll_task_func(), which do __io_queue_sqe() for @nxt
> request, which in its turn calls io_issue_sqe(force_nonblock=true).
> 
> Does io_poll_task_func() hold @uring_mutex? Otherwise, if @nxt happened
> to be io_provide_buffers(), we get there without holding the mutex and
> with force_nonblock=true.

Ah yes, good point! Not sure why I missed that... I've added the locking
around __io_queue_sqe() if 'nxt' is set in the handler.

-- 
Jens Axboe

