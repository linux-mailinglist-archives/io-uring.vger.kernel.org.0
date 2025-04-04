Return-Path: <io-uring+bounces-7409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 656C2A7C598
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 23:37:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1FCB1894A6B
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 21:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569DD1CD3F;
	Fri,  4 Apr 2025 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zf3WbOYs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0EA14831E
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 21:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743802643; cv=none; b=nhpBr5bVFJVu1JwbIGxyf6xds5Pprx1M5b8mkrvPi1W6Vmc5DuZIWfXXf3HBFtlcrSOn9EKoWvaXokOWYpVbfZ7GunvWUT43Bb1w0PbyXQU2fqFNSZmSk3/mXik74Gmv6XBtm6btw26WGMkhbNfq9r7rQtbRT7Kyx03PUkemH5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743802643; c=relaxed/simple;
	bh=0DCKlxMd4WOSG3ftUZ4Ctz+cXJGkOENPvlIM5sFV9LY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TeDqy3fxsxpuz4Zz9ZjNGeCPx4lj1pQwFg6jbCn3l2EzK2qvUKepBmk/0uPua4dkkyIp1j+H0MbklNeFGVQNUM6tMok87lDRXtqCbzhAE51SrFwoxYKXVB/0KRQThXgYa1fw55EYq5F+T5FVm3FlrgAHMXD0Ji4xnu/Ptqh9Lyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zf3WbOYs; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e6194e9d2cso4549097a12.2
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 14:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743802640; x=1744407440; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8lptF9nYhOxbBQOhHpjYCkU2eHVven7AZKBE9Gu59kE=;
        b=Zf3WbOYs4+P9WVwDdq35X8g8HR3ihSLmkVo62H+BoJxkU4GEduZKQsXuFlmxkMPjiD
         WLY4slzNlVUR9KDThVjvyDQ/RGMs5UqzGyv7IqSGQdI72ZLl2iaJD0y5WcAjICs3DlJg
         THnt4WRahDYe5mTGyjtEmL7xDAD2lvPViVu21fXUrTVvq+GRQ9AAeGbs144bv8Tr1qG3
         mzl6ik7ArIFkIKlZxm/8ocQVk4lqKOF88LiTJSr8zNcrxmVu9aDj8HyYCRdvOyRABd1T
         2xgy/5im1kQoHbAkJ33imXNcuE+0TRazOzgq1ub4AZDOg9iyz/bgqUXtywVLDKc9jzHd
         Hb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743802640; x=1744407440;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8lptF9nYhOxbBQOhHpjYCkU2eHVven7AZKBE9Gu59kE=;
        b=JxZQCKir8qGdn+q22U/TJJD1WYwQ/yMACYuSsLKXrw5IVuCKlet3v+tIaYCeB1KUw2
         3xYED1zPwT65pdI9vpaNllbvD9zgyWXLqmVoCWDpSEHHTiwm89vTCk1JoeLxwPBzcd1/
         +LowZWbvbqfjcHt9oU91nPwZU/F0ZokJe1t+ooCjs11WvI2xQmwgvrshTJjdPuflNwg+
         A2bCPfkmkUykcrUe75i3NfQ6QAM60g7Nnzp/A+gRL0uhJD4QsVxeASZ0Y0F3vFL0SfV9
         CTcZR5ZbEqcGpIKBrDR1BzdL5ZxoajMk6oA/9w78PZB7lw3ieXF2pqRpKQSO79xYQcr2
         ARVg==
X-Forwarded-Encrypted: i=1; AJvYcCU45VuQi/JPzKAY7IqvAoK4m7owcmkUMe9WyoYCCZ6engYUEcbcC8soyeG5wgyyhVuDz3Kon9mMxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPRcJ2cB+kOrdSfy32T8LNnc4KdXD/n3YKZEWmSMwOzzzfXwH+
	UtpmSnC6rKPs7Sk+NGG/aMFJSseZcxI3bForUk9z/nwY+YEiaaDw
X-Gm-Gg: ASbGncsD17DLK96qb1hiRAu05Ur3fHxtkrZqoSdFEfGQvj64YaW+/J/X3cnV86aUmxq
	DgQlUzdbiFJIHgLpZyNtbzWbR8IdXo6kWkuy82s2eUuMQmdqdd+52TpGPy8kGmuThRvXWh0k7f9
	xfxWlA0V750u9djxYWr6TeOBs8O/F1lvFnmS37IwicSVtHwC2k90s1Zzn8CyxgqLvICrSFuQvqy
	6ysX7XDVbrMTx8GW8xahr6uL9gXxR93+QjFdAS2IO5MThuoU4OjH8vzsJPypxItP0/sjvIHkJNM
	8gQ5m0yY4Nas3BPkaj2CD4l4W/t/nSeYnWHiEt43zskz+/zQ9vGyLJQ=
X-Google-Smtp-Source: AGHT+IFYEamDMF1AoiHh+63jf15w1or0kXtTJ6yPtK8tN8RItY4b+yds/qYXmdrfg/BVtA/h3MqdRQ==
X-Received: by 2002:a05:6402:40c9:b0:5e5:b572:a6d6 with SMTP id 4fb4d7f45d1cf-5f0b3b98ac6mr3577549a12.10.1743802639672;
        Fri, 04 Apr 2025 14:37:19 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.155])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f087f0d6bbsm3036217a12.46.2025.04.04.14.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 14:37:18 -0700 (PDT)
Message-ID: <609ff085-34a2-4b3d-a984-57ab2f9fcad6@gmail.com>
Date: Fri, 4 Apr 2025 22:38:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring: reuse buffer updates for registration
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1743783348.git.asml.silence@gmail.com>
 <8996ffd533db8bd12c84cdc2ccef1fddbbb3da27.1743783348.git.asml.silence@gmail.com>
 <1f12d9bc-b20f-4228-af96-a5c885f255ee@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1f12d9bc-b20f-4228-af96-a5c885f255ee@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/25 17:38, Jens Axboe wrote:
> On 4/4/25 10:22 AM, Pavel Begunkov wrote:
>> @@ -316,17 +318,26 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>>   			err = PTR_ERR(node);
>>   			break;
>>   		}
>> -		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
>> -		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
>> -		ctx->buf_table.nodes[i] = node;
>> +		i = array_index_nospec(up->offset + done, buf_table->nr);
>> +		io_reset_rsrc_node(ctx, buf_table, i);
>> +		buf_table->nodes[i] = node;
>>   		if (ctx->compat)
>>   			user_data += sizeof(struct compat_iovec);
>>   		else
>>   			user_data += sizeof(struct iovec);
>>   	}
>> +	if (last_error)
>> +		*last_error = err;
>>   	return done ? done : err;
>>   }
>>   
>> +static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>> +				   struct io_uring_rsrc_update2 *up,
>> +				   unsigned int nr_args)
>> +{
>> +	return io_buffer_table_update(ctx, &ctx->buf_table, up, nr_args, NULL);
>> +}
> 
> Minor style preference, but just do:
> 
> 	unsigned last_err;
> 	return io_buffer_table_update(ctx, &ctx->buf_table, up, nr_args, &last_err);
> 
> and skip that last_error could be conditionally set?

I can't say I see how that's better though

-- 
Pavel Begunkov


