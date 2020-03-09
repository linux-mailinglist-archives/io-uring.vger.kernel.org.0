Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28E317E58F
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2020 18:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgCIRRt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Mar 2020 13:17:49 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:43678 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgCIRRt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Mar 2020 13:17:49 -0400
Received: by mail-il1-f194.google.com with SMTP id o18so9357489ilg.10
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2020 10:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tUzBMXVrqfY27jWor8IKTUQTxXMD7eNpVMJXrGlTgNE=;
        b=KvXnSKaJYgmmV+u+sCNXf68UKZ1BjTz689YSc7V/2WOl1ZSwSfH4669ZfYC0alB76V
         HQz4YKpG8Ly5nTKKErYrZqrDBS07Jz/c0TWQVqMakHxK9AvR3xcrhw948al1AUdSwqbk
         Z/Ds/IlVwPp8KqSGjOZ2gSlWaA6tVN3yI2Flpdsd6UIlPtsquXF2WSbuh0VXHzBlGP+G
         BNguri4kIYBBSNr0pri6f8LTwybCp3KWO0MwHew2NaFNlchLpZMb4MZnt9dBJkCEu/5R
         WUcXiVrX22IEEIgFbQ9DB2bESqHrz+HrxYHIRPRCSi2M+M/fHeRTVb4i4cOznQSJPuID
         oUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tUzBMXVrqfY27jWor8IKTUQTxXMD7eNpVMJXrGlTgNE=;
        b=r+2CLDU4ZHPkE3ACXAsIsa39eX88TuFgJL5Gydw1ERr2aifjDe/Jy8aO0yuUm1YQW9
         5YXurHG4RNlSrdJBJ6k+p7bvj+u7EUAy6DFvEfv0+nVvz78bbdKVY5m+Bs68Nd8ZPLC9
         uWP9Mh8N7qYxOn3eIGJ6oi1CA+EKRfOfa+q0Pt9AROtGS+Vu6GGIAj4Mh7LoNreq+0CC
         jdlBgfEG2Bm1vno9YaGpUdxe+ZRenjyUM1p36PZZdWPsb3XT/PYvdkYiYSngoUgyC6yN
         LSQYSn5NkDZfRsm6sBw5KpeY/4bpyYkXsldjeC3QkXLNw+axdGQ+znaeHF1Lcp/eH+hw
         IBvg==
X-Gm-Message-State: ANhLgQ0Er3Ny620PyZ5X5yiu6YuNeFZ+j7fW3bFju6a6DEdHZkE2WoEt
        FUG2m3sTTCJBCJh21w4iq9hxGt0LRhg=
X-Google-Smtp-Source: ADFU+vtGK84DweZk3nU+73jo4J5SHPBr6pe2d4QhEfgGhUOwmxAdvJCO7OxsqUbiwa6X6AN9ZPJwug==
X-Received: by 2002:a92:d708:: with SMTP id m8mr15861830iln.244.1583774267793;
        Mon, 09 Mar 2020 10:17:47 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f69sm27111ilg.10.2020.03.09.10.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 10:17:47 -0700 (PDT)
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
 <20200309170313.perf4zbtdhq4jtvs@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a2283eb6-4b86-b858-a440-af4a8a7c2ba9@kernel.dk>
Date:   Mon, 9 Mar 2020 11:17:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200309170313.perf4zbtdhq4jtvs@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/20 11:03 AM, Andres Freund wrote:
> Hi,
> 
> I like this feature quite a bit...
> 
> Sorry for the late response.
> 
> 
> On 2020-02-28 13:30:49 -0700, Jens Axboe wrote:
>> +static int io_provide_buffers_prep(struct io_kiocb *req,
>> +				   const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_provide_buf *p = &req->pbuf;
>> +	u64 tmp;
>> +
>> +	if (sqe->ioprio || sqe->rw_flags)
>> +		return -EINVAL;
>> +
>> +	tmp = READ_ONCE(sqe->fd);
>> +	if (!tmp || tmp > USHRT_MAX)
>> +		return -EINVAL;
> 
> Hm, seems like it'd be less confusing if this didn't use
> io_uring_sqe->fd, but a separate union member?

Sure, not a big deal to me, and we can make this change after the fact
too as it won't change the ABI.

>> +	p->nbufs = tmp;
>> +	p->addr = READ_ONCE(sqe->addr);
>> +	p->len = READ_ONCE(sqe->len);
>> +
>> +	if (!access_ok(u64_to_user_ptr(p->addr), p->len))
>> +		return -EFAULT;
>> +
>> +	p->gid = READ_ONCE(sqe->buf_group);
>> +	tmp = READ_ONCE(sqe->off);
>> +	if (tmp > USHRT_MAX)
>> +		return -EINVAL;
> 
> Would it make sense to return a distinct error for the >= USHRT_MAX
> cases? E2BIG or something roughly in that direction? Seems good to be
> able to recognizably refuse "large" buffer group ids.

Don't feel too strongly, but it does help to separate the error.

>> +static int io_add_buffers(struct io_provide_buf *pbuf, struct list_head *list)
>> +{
>> +	struct io_buffer *buf;
>> +	u64 addr = pbuf->addr;
>> +	int i, bid = pbuf->bid;
>> +
>> +	for (i = 0; i < pbuf->nbufs; i++) {
>> +		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
>> +		if (!buf)
>> +			break;
>> +
>> +		buf->addr = addr;
>> +		buf->len = pbuf->len;
>> +		buf->bid = bid;
>> +		list_add(&buf->list, list);
>> +		addr += pbuf->len;
>> +		bid++;
>> +	}
>> +
>> +	return i;
>> +}
> 
> Hm, aren't you loosing an error here if you kmalloc fails for i > 0?
> Afaict io_provide_buffes() only checks for ret != 0. I think userland
> should know that a PROVIDE_BUFFERS failed, even if just partially (I'd
> just make it fail wholesale).

The above one does have the issue that we're losing the error for i ==
0, current one does:

return i ? i : -ENOMEM;

But this is what most interfaces end up doing, return the number
processed, if any, or error if none of them were added. Like a short
read, for example, and you'd get EIO if you forwarded and tried again.
So I tend to prefer doing it like that, at least to me it seems more
logical than unwinding. The application won't know what buffer caused
the error if you unwind, whereas it's perfectly clear if you asked to
add 128 and we return 64 that the issue is with the 65th buffer.

>> +static int io_provide_buffers(struct io_kiocb *req, struct io_kiocb **nxt,
>> +			      bool force_nonblock)
>> +{
>> +	struct io_provide_buf *p = &req->pbuf;
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct list_head *list;
>> +	int ret = 0;
> 
>> +	list = idr_find(&ctx->io_buffer_idr, p->gid);
> 
> I'd rename gid to bgid or such to distinguish from other types of group
> ids, but whatever.

Noted!

-- 
Jens Axboe

