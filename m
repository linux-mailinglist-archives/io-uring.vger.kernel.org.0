Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED01D1C6334
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 23:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgEEVjO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 17:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbgEEVjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 17:39:14 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8BCC061A0F;
        Tue,  5 May 2020 14:39:13 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v8so3469770wma.0;
        Tue, 05 May 2020 14:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aRAIpjXyotidBKkqciTqOh/EE3Z2jnBEjfcZbjgQaoA=;
        b=PJS+Z2+TyTdp8SDOsm8l7bLOZzDcf9C4HL7clVDo171MgJGGIkkrNIAm+qr7+yUHyu
         xeG/0vZK/OrKV5mc8A63gurkxiRROIcWXgbIJbQlKU5YpJHqunglc39TVhHpsHeNkKMm
         1/XrORN+WbRAb2nUv5GrruXy8hPXYcFz2dTG3J6XmSgXrfKp+omiXbEf2FCHxuIVFLvE
         /R9RG0pmM7FAQVkxNA8zvwXK71u9z4KJuIST1gXCHydU0+ntHVK1QN8jagSyXxnBi1M/
         Sq2gG2t1ibwZckhzCZuX//OAIbVCJQSpGSMHD8zZ1xR6BYrfrl+yDDuv72m3ttBAqIiH
         GGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aRAIpjXyotidBKkqciTqOh/EE3Z2jnBEjfcZbjgQaoA=;
        b=CNwm8CAYZ/kShD8RChLJuMUodL8UjktOkBVlnbDsoNS8YUgQY+o29phWyrHbUaS9cB
         vDaqUdStYdv6EPFgRyLhdQanMA7zex8EKs1SgOp2xop0q2h+L+8guGiyIfV6FxuSO5+M
         TgJhY3IegiY4NOTZPY0Y2vSP3JwPOk2KLD9Fy9B2V1haAZlbZei+AUg12nU+iGGdmUOb
         8FtSyIL3SYrlDATT2EiATxwPUrZDotRkJqV6yNaoIna/lljrQUbmp5IAxNGRun7FVgBd
         0wJoZQ5fFFqnLvVFC0+ORXa1oAPlkT7Vw0DIKL/JRdZuxbEUPzqCpZ5OkxOCUjpdIeW1
         b6bQ==
X-Gm-Message-State: AGi0PuY3AOw9E9pAd2MewqJOwW3cjFJ7NpSPish3QTEDyfCp3j0FdjD+
        bhcWg6EzDJzKuA1YD9rQnPuoP95k
X-Google-Smtp-Source: APiQypLOZFlJJqwFwZ3XiqW1ckHXjhRbkRd7RMCq5p2avQIMcxw9QSeNreatZ0AvJYJ7BDeDc3huNg==
X-Received: by 2002:a7b:c755:: with SMTP id w21mr767282wmk.120.1588714751903;
        Tue, 05 May 2020 14:39:11 -0700 (PDT)
Received: from [192.168.43.168] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id c20sm16355wmd.36.2020.05.05.14.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 14:39:11 -0700 (PDT)
Subject: Re: [PATCH for-5.7] splice: move f_mode checks to do_{splice,tee}()
To:     Clay Harris <bugs@claycon.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <51b4370ef70eebf941f6cef503943d7f7de3ea4d.1588621153.git.asml.silence@gmail.com>
 <20200505211029.azfj2c4scoh6x2kx@ps29521.dreamhostps.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Message-ID: <2146b60d-d982-59c4-33d3-a5e6ad68fc8e@gmail.com>
Date:   Wed, 6 May 2020 00:38:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200505211029.azfj2c4scoh6x2kx@ps29521.dreamhostps.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/05/2020 00:10, Clay Harris wrote:
> On Mon, May 04 2020 at 22:39:35 +0300, Pavel Begunkov quoth thus:
> 
>> do_splice() is used by io_uring, as will be do_tee(). Move f_mode
>> checks from sys_{splice,tee}() to do_{splice,tee}(), so they're
>> enforced for io_uring as well.
> 
> I'm not seeing any check against splicing a pipe to itself in the
> io_uring path, although maybe I just missed it.  As the comment
> below says: /* Splicing to self would be fun, but... */ .

io_uring just forwards a request to do_splice(), which do the check at the exact
place you mentioned. The similar story is with do_tee().

> 
>> Fixes: 7d67af2c0134 ("io_uring: add splice(2) support")
>> Reported-by: Jann Horn <jannh@google.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/splice.c | 45 ++++++++++++++++++---------------------------
>>  1 file changed, 18 insertions(+), 27 deletions(-)
>>
>> diff --git a/fs/splice.c b/fs/splice.c
>> index 4735defc46ee..fd0a1e7e5959 100644
>> --- a/fs/splice.c
>> +++ b/fs/splice.c
>> @@ -1118,6 +1118,10 @@ long do_splice(struct file *in, loff_t __user *off_in,
>>  	loff_t offset;
>>  	long ret;
>>  
>> +	if (unlikely(!(in->f_mode & FMODE_READ) ||
>> +		     !(out->f_mode & FMODE_WRITE)))
>> +		return -EBADF;
>> +
>>  	ipipe = get_pipe_info(in);
>>  	opipe = get_pipe_info(out);
>>  
>> @@ -1125,12 +1129,6 @@ long do_splice(struct file *in, loff_t __user *off_in,
>>  		if (off_in || off_out)
>>  			return -ESPIPE;
>>  
>> -		if (!(in->f_mode & FMODE_READ))
>> -			return -EBADF;
>> -
>> -		if (!(out->f_mode & FMODE_WRITE))
>> -			return -EBADF;
>> -
>>  		/* Splicing to self would be fun, but... */
>>  		if (ipipe == opipe)
>>  			return -EINVAL;
>> @@ -1153,9 +1151,6 @@ long do_splice(struct file *in, loff_t __user *off_in,
>>  			offset = out->f_pos;
>>  		}
>>  
>> -		if (unlikely(!(out->f_mode & FMODE_WRITE)))
>> -			return -EBADF;
>> -
>>  		if (unlikely(out->f_flags & O_APPEND))
>>  			return -EINVAL;
>>  
>> @@ -1440,15 +1435,11 @@ SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
>>  	error = -EBADF;
>>  	in = fdget(fd_in);
>>  	if (in.file) {
>> -		if (in.file->f_mode & FMODE_READ) {
>> -			out = fdget(fd_out);
>> -			if (out.file) {
>> -				if (out.file->f_mode & FMODE_WRITE)
>> -					error = do_splice(in.file, off_in,
>> -							  out.file, off_out,
>> -							  len, flags);
>> -				fdput(out);
>> -			}
>> +		out = fdget(fd_out);
>> +		if (out.file) {
>> +			error = do_splice(in.file, off_in, out.file, off_out,
>> +					  len, flags);
>> +			fdput(out);
>>  		}
>>  		fdput(in);
>>  	}
>> @@ -1770,6 +1761,10 @@ static long do_tee(struct file *in, struct file *out, size_t len,
>>  	struct pipe_inode_info *opipe = get_pipe_info(out);
>>  	int ret = -EINVAL;
>>  
>> +	if (unlikely(!(in->f_mode & FMODE_READ) ||
>> +		     !(out->f_mode & FMODE_WRITE)))
>> +		return -EBADF;
>> +
>>  	/*
>>  	 * Duplicate the contents of ipipe to opipe without actually
>>  	 * copying the data.
>> @@ -1795,7 +1790,7 @@ static long do_tee(struct file *in, struct file *out, size_t len,
>>  
>>  SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
>>  {
>> -	struct fd in;
>> +	struct fd in, out;
>>  	int error;
>>  
>>  	if (unlikely(flags & ~SPLICE_F_ALL))
>> @@ -1807,14 +1802,10 @@ SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
>>  	error = -EBADF;
>>  	in = fdget(fdin);
>>  	if (in.file) {
>> -		if (in.file->f_mode & FMODE_READ) {
>> -			struct fd out = fdget(fdout);
>> -			if (out.file) {
>> -				if (out.file->f_mode & FMODE_WRITE)
>> -					error = do_tee(in.file, out.file,
>> -							len, flags);
>> -				fdput(out);
>> -			}
>> +		out = fdget(fdout);
>> +		if (out.file) {
>> +			error = do_tee(in.file, out.file, len, flags);
>> +			fdput(out);
>>  		}
>>   		fdput(in);
>>   	}
>> -- 
>> 2.24.0

-- 
Pavel Begunkov
