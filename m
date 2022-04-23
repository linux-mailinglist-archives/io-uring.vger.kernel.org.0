Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D3450CC4A
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 18:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiDWQdE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 12:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiDWQdD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 12:33:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9678D1400F
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 09:30:05 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b24so13831528edu.10
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 09:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=/EFAsKQvTcGlfJH1bFWzat4F0fcGcsXg8zt5KCAUjJ0=;
        b=flXzz+XNLn4SCUSzwzKN7t/Wa4FqjP6Llal8+rQzKknb3N3WlbMPBrM5jp3c7VyBnS
         W3zCqCZSKR10sqxPUlcWA07P5Wp+fcR+bt73TRBXyssomKQiiApeg+HRPmLGcl33qDE3
         O5R62wFsRXSOxik7MewgxhD5/qrpc0K52lylJgWJPBJzR3J06hm9qI/aWsWPUr2DuG7o
         JjezWx6lX4zseCQQGUEXq7gkSEPMaZf3rYTxt+MvJ3VgFpXB3AM9Ufrq2S4HDpVBIyJc
         F8kvxzZnWIfDVaIhvZZSbmMNy7qwJKPydbh/UgXCGPI8P4Rr3X7g5dDTHNXY92wh8e/E
         01iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=/EFAsKQvTcGlfJH1bFWzat4F0fcGcsXg8zt5KCAUjJ0=;
        b=YlWtznxyg5kcfH9ohy32KTwFXT89ljyS77GENCGDDNmw/Q32TQRxId/98xnA8z9RSW
         Tw+P+2dZ3ufpGLzC+SMDoIZmgNwb/tHUoeGSGsi/G6LU+fKA8RVq6RJH5dkYkueT9To3
         Bng4zwrDbB2RHOM4s8hyBCkvj6DMd2LpkaiRr1AzNz7iFKW79lGRVoXGJFC7mSQhSSp/
         lb/2gXUJA2+CgjPpVbzgEow5vi/A7LAm4CoIb66CgMrzLLLQZRL/CHsn7vq87nkoCj7J
         2sbCx1aW3v0jz5faJbaZKX6ssvnzRaAMusHuffPoYXEfffG855Pash3ATKE4QlQY6hJW
         uHgA==
X-Gm-Message-State: AOAM530y4MhkjmVa0pMfSQng6+c39aKpQAlIprN+K4PVv9TAm8dkunPX
        iwS9sFdpcd4noWrOMpVtABLBUg==
X-Google-Smtp-Source: ABdhPJxyDPhlbOf1+ADvk3J3OlwAJXKaGxWvkOtXdfuTXGwRaPIZYWnys7Cg0Zu8Y8A2FGUrKyHkxg==
X-Received: by 2002:a05:6402:4305:b0:423:f73b:4dd8 with SMTP id m5-20020a056402430500b00423f73b4dd8mr10767502edc.218.1650731403619;
        Sat, 23 Apr 2022 09:30:03 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id h27-20020a1709062ddb00b006f3851149ecsm128076eji.129.2022.04.23.09.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 09:30:02 -0700 (PDT)
Message-ID: <27bf5faf-0b15-57dc-05ec-6a62cd789809@scylladb.com>
Date:   Sat, 23 Apr 2022 19:30:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <c663649e-674e-55d0-a59c-8f4b8f445bfa@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <c663649e-674e-55d0-a59c-8f4b8f445bfa@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 22/04/2022 18.03, Jens Axboe wrote:
> On 4/22/22 8:50 AM, Jens Axboe wrote:
>> On 4/13/22 4:33 AM, Avi Kivity wrote:
>>> Unfortunately, only ideas, no patches. But at least the first seems very easy.
>>>
>>>
>>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op
>>> itself (1-8 bytes) to a user memory location specified by the op.
>>>
>>>
>>> Linked to another op, this can generate an in-memory notification
>>> useful for busy-waiters or the UMWAIT instruction
>>>
>>> This would be useful for Seastar, which looks at a timer-managed
>>> memory location to check when to break computation loops.
>> This one would indeed be trivial to do. If we limit the max size
>> supported to eg 8 bytes like suggested, then it could be in the sqe
>> itself and just copied to the user address specified.
>>
>> Eg have sqe->len be the length (1..8 bytes), sqe->addr the destination
>> address, and sqe->off the data to copy.
>>
>> If you'll commit to testing this, I can hack it up pretty quickly...
> Something like this, totally untested. Maybe the return value should be
> bytes copied?


Yes. It could be less than what the user expected, unless we enforce 
alignment (perhaps we should).


> Just returns 0/error right now.
>
> Follows the above convention.
>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2052a796436c..d2a95f9d9d2d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -586,6 +586,13 @@ struct io_socket {
>   	unsigned long			nofile;
>   };
>   
> +struct io_mem {
> +	struct file			*file;
> +	u64				value;
> +	void __user			*dest;
> +	u32				len;
> +};
> +


>   struct io_sync {
>   	struct file			*file;
>   	loff_t				len;
> @@ -962,6 +969,7 @@ struct io_kiocb {
>   		struct io_msg		msg;
>   		struct io_xattr		xattr;
>   		struct io_socket	sock;
> +		struct io_mem		mem;
>   	};
>   
>   	u8				opcode;
> @@ -1231,16 +1239,19 @@ static const struct io_op_def io_op_defs[] = {
>   		.needs_file		= 1,
>   	},
>   	[IORING_OP_FSETXATTR] = {
> -		.needs_file = 1
> +		.needs_file		= 1,
>   	},
>   	[IORING_OP_SETXATTR] = {},
>   	[IORING_OP_FGETXATTR] = {
> -		.needs_file = 1
> +		.needs_file		= 1,
>   	},
>   	[IORING_OP_GETXATTR] = {},
>   	[IORING_OP_SOCKET] = {
>   		.audit_skip		= 1,
>   	},
> +	[IORING_OP_MEMCPY_IMM] = {
> +		.audit_skip		= 1,
> +	},
>   };
>   
>   /* requests with any of those set should undergo io_disarm_next() */
> @@ -5527,6 +5538,38 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
>   	return 0;
>   }
>   
> +static int io_memcpy_imm_prep(struct io_kiocb *req,
> +			      const struct io_uring_sqe *sqe)
> +{
> +	struct io_mem *mem = &req->mem;
> +
> +	if (unlikely(sqe->ioprio || sqe->rw_flags || sqe->buf_index ||
> +		     sqe->splice_fd_in))
> +		return -EINVAL;
> +
> +	mem->value = READ_ONCE(sqe->off);
> +	mem->dest = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	mem->len = READ_ONCE(sqe->len);
> +	if (!mem->len || mem->len > sizeof(u64))
> +		return -EINVAL;
> +


I'd also check that the length is a power-of-two to avoid having to deal 
with weird sizes if we later find it inconvenient.


> +	return 0;
> +}
> +
> +static int io_memcpy_imm(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_mem *mem = &req->mem;
> +	int ret = 0;
> +
> +	if (copy_to_user(mem->dest, &mem->value, mem->len))
> +		ret = -EFAULT;
> +


Is copy_to_user efficient for tiny sizes? Or is it better to use a 
switch and put_user()?


I guess copy_to_user saves us from having to consider endianness.


> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +
>   #if defined(CONFIG_NET)
>   static bool io_net_retry(struct socket *sock, int flags)
>   {
> @@ -7494,6 +7537,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   		return io_getxattr_prep(req, sqe);
>   	case IORING_OP_SOCKET:
>   		return io_socket_prep(req, sqe);
> +	case IORING_OP_MEMCPY_IMM:
> +		return io_memcpy_imm_prep(req, sqe);
>   	}
>   
>   	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -7815,6 +7860,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>   	case IORING_OP_SOCKET:
>   		ret = io_socket(req, issue_flags);
>   		break;
> +	case IORING_OP_MEMCPY_IMM:
> +		ret = io_memcpy_imm(req, issue_flags);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		break;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 5fb52bf32435..853f00a2bddd 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -152,6 +152,7 @@ enum {
>   	IORING_OP_FGETXATTR,
>   	IORING_OP_GETXATTR,
>   	IORING_OP_SOCKET,
> +	IORING_OP_MEMCPY_IMM,
>   
>   	/* this goes last, obviously */
>   	IORING_OP_LAST,
>
