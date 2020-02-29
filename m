Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C218017486F
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 18:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbgB2ReF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 12:34:05 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35306 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbgB2ReF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 12:34:05 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so2522373plt.2
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 09:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b1CP0ojELH7AoGMtxsaNIKK/h97oQKb9YKlCU8EDFU8=;
        b=Fp13DCnzIa8wrP6gwz05Q+kSsrODrgM+OCyVORNSw6niUKQY3GJvzqwY78kiZv53+g
         +OnwWNtBSJ85/SBh7NepQ8Qgb6PdnHCpBYQzBtHyttyJ2VoFfSbbx/VDmI54O+Mzs+Bb
         2vM0wW+GEnRjivKiYh8keGz1fOCe+XNRn15ewwoJNDgle07wOLqrMkXLN0c8Mxcnsxk1
         BDPd3GLBLOQsl3gozp3AyO0NgCm/YBUs4NkZcImtBiZQ2Jv+a+zn3B3w1qMaMojiSFUe
         5h011u/Rt6eDF1Bpbf8ICu6mISw0rdeMX2YB/qimxUtPMp0o+VExyCOPcdxNRuve01Ma
         bl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b1CP0ojELH7AoGMtxsaNIKK/h97oQKb9YKlCU8EDFU8=;
        b=rFZN+rcBcvKOX8faPZ3xFTRC49z3R9znQs1lRrImhKsB3tdUESmqpfkCi2tbWNRUFK
         Vmu8zu6AFdt1pcPtjIZNQTEXVZm0AnFs7O/TcctkPKX+CQsaoGb5uTvTiY3oc6CQH//G
         2JStvYA7ybqJq+9oszk4xsyYl9l8voSSI4XiVuzu+IA6+YxbCLrWVE0jqc8lacV82UWb
         KdvW6SOwifOMWGmVr/SypCDt4m1i1CUya4cefmv3ZO6br65Q9dRI4lxaBjxrKJj2rD3V
         NJqMbkENZQojLN3UBRh7iZrP0nQFpsBBdEWlQ6ActM5ZExdpnz1T6ZMA0pSH+H1jpQ8t
         43gg==
X-Gm-Message-State: APjAAAXDMFk3f2Pqtf5ZJ8EL4BqfWAT9/QrAqkiiwUIvsj5vOoFfHaHg
        HtHz4QI0HmgwtgxSoQW0ESm47g==
X-Google-Smtp-Source: APXvYqxaHK7Qr1wFwGYmJpe1E+OiCnAEYlp1TBSA6CdgQ+lRAfkb9uO0qIeGgycKbfXCc5uLgqpayw==
X-Received: by 2002:a17:90b:34b:: with SMTP id fh11mr11550386pjb.8.1582997642671;
        Sat, 29 Feb 2020 09:34:02 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e2sm10796069pfh.151.2020.02.29.09.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 09:34:02 -0800 (PST)
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
 <1717ee0c-9700-654e-d75b-6398b1c4c1a9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a1dc31fb-36b5-3e54-7eb7-e88c67a6bb82@kernel.dk>
Date:   Sat, 29 Feb 2020 10:34:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1717ee0c-9700-654e-d75b-6398b1c4c1a9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/29/20 5:08 AM, Pavel Begunkov wrote:
> On 2/28/2020 11:30 PM, Jens Axboe wrote:
>> IORING_OP_PROVIDE_BUFFERS uses the buffer registration infrastructure to
>> support passing in an addr/len that is associated with a buffer ID and
>> buffer group ID. The group ID is used to index and lookup the buffers,
>> while the buffer ID can be used to notify the application which buffer
>> in the group was used. The addr passed in is the starting buffer address,
>> and length is each buffer length. A number of buffers to add with can be
>> specified, in which case addr is incremented by length for each addition,
>> and each buffer increments the buffer ID specified.
>>
>> No validation is done of the buffer ID. If the application provides
>> buffers within the same group with identical buffer IDs, then it'll have
>> a hard time telling which buffer ID was used. The only restriction is
>> that the buffer ID can be a max of 16-bits in size, so USHRT_MAX is the
>> maximum ID that can be used.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
> 
>>  
>> +static int io_provide_buffers_prep(struct io_kiocb *req,
>> +				   const struct io_uring_sqe *sqe)
>> +{
> 
> *provide* may be confusing, at least it's for me. It's not immediately
> obvious, who gives and who consumes. Not sure what name would be better yet.

It's the application providing the buffers upfront, at least that's how
the naming makes sense to me.

>> +static int io_provide_buffers(struct io_kiocb *req, struct io_kiocb **nxt,
>> +			      bool force_nonblock)
>> +{
>> +	struct io_provide_buf *p = &req->pbuf;
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct list_head *list;
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * "Normal" inline submissions always hold the uring_lock, since we
>> +	 * grab it from the system call. Same is true for the SQPOLL offload.
>> +	 * The only exception is when we've detached the request and issue it
>> +	 * from an async worker thread, grab the lock for that case.
>> +	 */
>> +	if (!force_nonblock)
>> +		mutex_lock(&ctx->uring_lock);
>> +
>> +	lockdep_assert_held(&ctx->uring_lock);
>> +
>> +	list = idr_find(&ctx->io_buffer_idr, p->gid);
>> +	if (!list) {
>> +		list = kmalloc(sizeof(*list), GFP_KERNEL);
> 
> Could be easier to hook struct io_buffer into idr directly, i.e. without
> a separate allocated list-head entry.

Good point, we can just make the first kbuf the list, point to the next
one (or NULL) when a kbuf is removed. I'll make that change, gets rid of
the list alloc.

-- 
Jens Axboe

