Return-Path: <io-uring+bounces-1439-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6065089B423
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 23:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC694B20DE3
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 21:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF7E107A6;
	Sun,  7 Apr 2024 21:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mHkqkj+v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AF92582
	for <io-uring@vger.kernel.org>; Sun,  7 Apr 2024 21:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712526444; cv=none; b=kw6LsqjLJ20LdMc+qCo/glZwK2OGeTEVvftNtWtnvEiaY57rC7f7wZ2hBjMaN55sY9JGGZ0RVXxhzovcv+Aa3UCjWoBYrXQE1AOg+24IiTWivdx/MO20OcV5o+B4AhDeeMO9cAvnIs1IH+gWohCbkPa+naO5FagoBB/73qkWIZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712526444; c=relaxed/simple;
	bh=aW1s4zCmw0nxiPjjQIZuTHEKDaUpOkLNh2jpRK7z6tY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JYO57aIptVImupqYZmRDFTJzd94NTv5eXqr2jR7fy1y/cXyaJv0qydBhar248ozcY7EtDautiNnaqdZpoq4UiITukpRgW3w53c5n56UGBSTnzrQKYbfG5LXYfTSZKS1t+VMLPi/dBKvXgR9of9kvOLLu6DuwJjiwjQT6fVQTFvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mHkqkj+v; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-36a1c0bf9faso348855ab.1
        for <io-uring@vger.kernel.org>; Sun, 07 Apr 2024 14:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712526440; x=1713131240; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ICvsAe5Gs9wOszm1g2dLlO06jFczhoU1jqpTnGImtIY=;
        b=mHkqkj+vf7FdqGeitFOklV0MsekS8YnlTpGdfJ4qlEfPn83tegbUMWVJUt2BGWMlOk
         pSmsG8KGMcAKYcbBWpKxvachhiXcihvSjUe9RMc2Kav7sIb7OkndB1LcWYhT/5FcGXQy
         rmqcrixYwtpmyPGLWI8AlVJ5qLIDJSfweQsOgHEzIgt/kFjOOTh09bDSWvsu2Mm7JbVc
         P93XJsTr1im6Ro/gBPK7y1I7YP4T6VkEJhtxTrS/wu7kERAEbwQL2ih5xJUrIv+A51JN
         GSoYJhKUx2p1pLOtvO7ehmj+7XYHvM0B3jhZi0pyq2ByJJ42S4xapUdq0vl0ii/uuNNb
         Psgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712526440; x=1713131240;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ICvsAe5Gs9wOszm1g2dLlO06jFczhoU1jqpTnGImtIY=;
        b=d+LPIbCgx6/yQMvWzii1G6w+7Rnarh+A1/tEVumj/PjdA98qHpqrSssch7G1wf8GBc
         DulMwhUrMZtck/C4CoMy6gNqisL2YxDilYMMlAVtlFH47uZO4qUGzKrm4UaonOoyM4UE
         B55VXuhdZZ6aMkIe+aAqCCLTfGrgPsUJxslK1uY+1u8aQr4O83HMRf1dXDSjKPicajfv
         XHBUWQKwt5xn/5uekbgL2GXGDdQmtqgx3CRVeGOcxgb+K7mSXJuPQbhmkx/o53A1mbg/
         GnWqEg/6mMl/z98gHqVwqEbjwaxsDTaVv/1zqIuEA32LE5EGjHQc69ypOcr4Ag6jy8K+
         XglA==
X-Forwarded-Encrypted: i=1; AJvYcCXXiEmZwL6Uw+FBEZlMfiV5ekpxcFjyvdb+ZdKW1BFMDUfEFro+wqHbLdZZZUy5RhrmrylBN4pExDSZ2ysdx9TX6R4BPgluAe0=
X-Gm-Message-State: AOJu0YzUXZFCd6+PYTsMS/L0IQyeMh/NA+qJltMUPaJ6G5aTeVr/jGMX
	oSmLMYk7VelB0OuWyA17NUF5Kf9hYQi2LR+RgHcNTJhzn9poK64apV+PjGv+/3JKAgPl1zvpa/T
	Y
X-Google-Smtp-Source: AGHT+IHmaC9/LGaQSbRE0QM/uIm9bk764TV+Sd2x8lKg5ImhshQwptiNoJkjoUhLXalf9OXXB5WNPQ==
X-Received: by 2002:a05:6602:4f1a:b0:7d5:ecc6:2e7d with SMTP id gl26-20020a0566024f1a00b007d5ecc62e7dmr571825iob.2.1712526440345;
        Sun, 07 Apr 2024 14:47:20 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h10-20020a5e974a000000b007cc6af6686esm1842874ioq.30.2024.04.07.14.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Apr 2024 14:47:19 -0700 (PDT)
Message-ID: <11088a6a-c498-48bd-b6e9-d728c03df1b8@kernel.dk>
Date: Sun, 7 Apr 2024 15:47:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/17] io_uring/net: switch io_send() and io_send_zc() to
 using io_async_msghdr
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240320225750.1769647-1-axboe@kernel.dk>
 <20240320225750.1769647-2-axboe@kernel.dk>
 <ec05edbe-0459-4549-a94b-cf4b17f2464d@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ec05edbe-0459-4549-a94b-cf4b17f2464d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/6/24 2:58 PM, Pavel Begunkov wrote:
> On 3/20/24 22:55, Jens Axboe wrote:
>> No functional changes in this patch, just in preparation for carrying
>> more state then we have now, if necessary. While unifying some of this
>> code, add a generic send setup prep handler that they can both use.
>>
>> This gets rid of some manual msghdr and sockaddr on the stack, and makes
>> it look a bit more like the sendmsg/recvmsg variants. We can probably
>> unify a bit more on top of this going forward.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/net.c   | 196 ++++++++++++++++++++++++-----------------------
>>   io_uring/opdef.c |   1 +
>>   2 files changed, 103 insertions(+), 94 deletions(-)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index ed798e185bbf..a16838c0c837 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -322,36 +322,25 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
>>  
> ...
>> -int io_send(struct io_kiocb *req, unsigned int issue_flags)
>> +static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
>> +                         struct io_async_msghdr *stack_msg,
>> +                         unsigned int issue_flags)
>>   {
>> -    struct sockaddr_storage __address;
>>       struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
>> -    struct msghdr msg;
>> -    struct socket *sock;
>> -    unsigned flags;
>> -    int min_ret = 0;
>> +    struct io_async_msghdr *kmsg;
>>       int ret;
>>   -    msg.msg_name = NULL;
>> -    msg.msg_control = NULL;
>> -    msg.msg_controllen = 0;
>> -    msg.msg_namelen = 0;
>> -    msg.msg_ubuf = NULL;
>> -
>> -    if (sr->addr) {
>> -        if (req_has_async_data(req)) {
>> -            struct io_async_msghdr *io = req->async_data;
>> -
>> -            msg.msg_name = &io->addr;
>> -        } else {
>> -            ret = move_addr_to_kernel(sr->addr, sr->addr_len, &__address);
>> +    if (req_has_async_data(req)) {
>> +        kmsg = req->async_data;
>> +    } else {
>> +        kmsg = stack_msg;
>> +        kmsg->free_iov = NULL;
>> +        kmsg->msg.msg_name = NULL;
>> +        kmsg->msg.msg_namelen = 0;
>> +        kmsg->msg.msg_control = NULL;
>> +        kmsg->msg.msg_controllen = 0;
>> +        kmsg->msg.msg_ubuf = NULL;
>> +
>> +        if (sr->addr) {
>> +            ret = move_addr_to_kernel(sr->addr, sr->addr_len,
>> +                          &kmsg->addr);
>>               if (unlikely(ret < 0))
>> -                return ret;
>> -            msg.msg_name = (struct sockaddr *)&__address;
>> +                return ERR_PTR(ret);
>> +            kmsg->msg.msg_name = &kmsg->addr;
>> +            kmsg->msg.msg_namelen = sr->addr_len;
>> +        }
>> +
>> +        if (!io_do_buffer_select(req)) {
> 
> it seems, this chunk leaked from another series as well. fwiw,
> it was moved in a later commit
> "io_uring/net: get rid of ->prep_async() for send side"

Thanks, yeah I think so too. Will fix, thanks!

-- 
Jens Axboe


