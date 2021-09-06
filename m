Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E777A401DAF
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 17:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242495AbhIFPgu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 11:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbhIFPgu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 11:36:50 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755ACC061575
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 08:35:45 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q11so10406291wrr.9
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 08:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VTbCfTRZu3G9rHxl2HquRQKnrQMgBK/OBJLDaEqYi2I=;
        b=WQsodxoZkJFHCV7lhOVEKOtBwgVL/OSok0rO3OowIOHlYlgD9SMkq/CzCp5YZOgAOb
         XYhxrPMrVpPGN2/gK0ax7bpCS52DQhSxczzR9umBaKxB0YCYD6NtDElln/G8ZJcaA3gb
         q/HwQRQnvaTtIdX9YfizrETYxOf/++Khv+94M9NjDzTLKH4SlSwPxKNf9q94OIpfnJ5R
         qS5ztLtsnDGTSM85b8eHHBPhvxvcPMzlp3epKtGyAtlN/w2KMvnMt9NqGWyyfSZkr/vN
         bfF72s0OdHr6wuz8wLqCsPSTaj7CL3uBTeEvlE6fxpJhk5JejUOrEzt2+hKYujGZY93F
         72CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VTbCfTRZu3G9rHxl2HquRQKnrQMgBK/OBJLDaEqYi2I=;
        b=ukarouwhREGvhm610o+lD/NmFYUHVQI/4rZgQIqEBKqS66/NJwQUErwYsYK3bvKkrK
         MTnWKXbX7iCzC+LwvGEA5pMCMEW4L96cFkegGTqdC62c/nAKgUGxy+aXy/5PMkUow5OM
         jN3rlTjp8jWc+G7tTQi1/yHz4sYZD3yWDoacBhyhb2Rciv8w6PJZBNf2QyQM+TiPJ79c
         tQLhVfam1YmvoFGzRWKEQOqAbFfyx5H/Q1Qtem7gR+m8FI4zr0f5g5gqTkep1DVClbIw
         TfElYiRexVuwW08fZnEFY0aOt10NqyL0lsU2sgWVso5mUO9ZVyA6E6gZIX9kvZey9Mms
         xftg==
X-Gm-Message-State: AOAM531MdkTRCyN7aowlDRBFAFgtt0xKxPwux7O/IIrjEGRQTPoCaAve
        J05kd5PNPDFR80CDA0IoRLisOEZmdPg=
X-Google-Smtp-Source: ABdhPJxTFgaeY/Wc8KVNn8A4NOefsEOaYJVeNJDbEVahKhyfgfXXAs75y0iLR8IDfRVapF3WlPvByQ==
X-Received: by 2002:a5d:438a:: with SMTP id i10mr14321780wrq.285.1630942543984;
        Mon, 06 Sep 2021 08:35:43 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id z17sm8452361wrh.66.2021.09.06.08.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 08:35:30 -0700 (PDT)
Subject: Re: [PATCH 5/6] io_uring: implement multishot mode for accept
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-6-haoxu@linux.alibaba.com>
 <3070a597-3326-5cac-253e-e2b58eebd3a2@gmail.com>
 <64734f7c-aaee-7ac7-752e-2d81a475d3d8@gmail.com>
Message-ID: <9406066e-bfd7-4491-576f-873f4396f10d@gmail.com>
Date:   Mon, 6 Sep 2021 16:34:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <64734f7c-aaee-7ac7-752e-2d81a475d3d8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/4/21 11:40 PM, Pavel Begunkov wrote:
> On 9/4/21 11:39 PM, Pavel Begunkov wrote:
>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>> Refactor io_accept() to support multishot mode.
>>
>> Multishot with the fixed/direct mode sounds weird (considering that
>> the slot index is specified by userspace), let's forbid them.
>>
>> io_accept_prep() {
>> 	if (accept->file_slot && (flags & MULTISHOT))
>> 		return -EINVAL;
>> 	...
>> }
> 
> Ah, never mind, it's already there in 6/6

btw, I think it would be less confusing if 5/6 and 6/6 are combined
into a single patch. But it's a matter of taste, I guess

>>
>>> theoretical analysis:
>>>   1) when connections come in fast
>>>     - singleshot:
>>>               add accept sqe(userpsace) --> accept inline
>>>                               ^                 |
>>>                               |-----------------|
>>>     - multishot:
>>>              add accept sqe(userspace) --> accept inline
>>>                                               ^     |
>>>                                               |--*--|
>>>
>>>     we do accept repeatedly in * place until get EAGAIN
>>>
>>>   2) when connections come in at a low pressure
>>>     similar thing like 1), we reduce a lot of userspace-kernel context
>>>     switch and useless vfs_poll()
>>>
>>> tests:
>>> Did some tests, which goes in this way:
>>>
>>>   server    client(multiple)
>>>   accept    connect
>>>   read      write
>>>   write     read
>>>   close     close
>>>
>>> Basically, raise up a number of clients(on same machine with server) to
>>> connect to the server, and then write some data to it, the server will
>>> write those data back to the client after it receives them, and then
>>> close the connection after write return. Then the client will read the
>>> data and then close the connection. Here I test 10000 clients connect
>>> one server, data size 128 bytes. And each client has a go routine for
>>> it, so they come to the server in short time.
>>> test 20 times before/after this patchset, time spent:(unit cycle, which
>>> is the return value of clock())
>>> before:
>>>   1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
>>>   +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
>>>   +1934226+1914385)/20.0 = 1927633.75
>>> after:
>>>   1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
>>>   +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
>>>   +1871324+1940803)/20.0 = 1894750.45
>>>
>>> (1927633.75 - 1894750.45) / 1927633.75 = 1.65%
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>
>>> not sure if we should cancel it when io_cqring_fill_event() reurn false
>>>
>>>  fs/io_uring.c | 34 +++++++++++++++++++++++++++++-----
>>>  1 file changed, 29 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index dae7044e0c24..eb81d37dce78 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4885,16 +4885,18 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  
>>>  static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>>>  {
>>> +	struct io_ring_ctx *ctx = req->ctx;
>>>  	struct io_accept *accept = &req->accept;
>>>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>  	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
>>>  	bool fixed = !!accept->file_slot;
>>>  	struct file *file;
>>> -	int ret, fd;
>>> +	int ret, ret2 = 0, fd;
>>>  
>>>  	if (req->file->f_flags & O_NONBLOCK)
>>>  		req->flags |= REQ_F_NOWAIT;
>>>  
>>> +retry:
>>>  	if (!fixed) {
>>>  		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
>>>  		if (unlikely(fd < 0))
>>> @@ -4906,20 +4908,42 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>>>  		if (!fixed)
>>>  			put_unused_fd(fd);
>>>  		ret = PTR_ERR(file);
>>> -		if (ret == -EAGAIN && force_nonblock)
>>> -			return -EAGAIN;
>>> +		if (ret == -EAGAIN && force_nonblock) {
>>> +			if ((req->flags & (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)) ==
>>> +			    (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED))
>>> +				ret = 0;
>>> +			return ret;
>>> +		}
>>>  		if (ret == -ERESTARTSYS)
>>>  			ret = -EINTR;
>>>  		req_set_fail(req);
>>>  	} else if (!fixed) {
>>>  		fd_install(fd, file);
>>>  		ret = fd;
>>> +		/*
>>> +		 * if it's in multishot mode, let's return -EAGAIN to make it go
>>> +		 * into fast poll path
>>> +		 */
>>> +		if ((req->flags & REQ_F_APOLL_MULTISHOT) && force_nonblock &&
>>> +		   !(req->flags & REQ_F_POLLED))
>>> +			ret2 = -EAGAIN;
>>>  	} else {
>>>  		ret = io_install_fixed_file(req, file, issue_flags,
>>>  					    accept->file_slot - 1);
>>>  	}
>>> -	__io_req_complete(req, issue_flags, ret, 0);
>>> -	return 0;
>>> +
>>> +	if (req->flags & REQ_F_APOLL_MULTISHOT) {
>>> +		spin_lock(&ctx->completion_lock);
>>> +		if (io_cqring_fill_event(ctx, req->user_data, ret, 0)) {
>>> +			io_commit_cqring(ctx);
>>> +			ctx->cq_extra++;
>>> +		}
>>> +		spin_unlock(&ctx->completion_lock);
>>> +		goto retry;
>>> +	} else {
>>> +		__io_req_complete(req, issue_flags, ret, 0);
>>> +	}
>>> +	return ret2;
>>>  }
>>>  
>>>  static int io_connect_prep_async(struct io_kiocb *req)
>>>
>>
> 

-- 
Pavel Begunkov
