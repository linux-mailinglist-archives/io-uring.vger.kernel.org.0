Return-Path: <io-uring+bounces-1329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9C489213C
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 17:07:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B5551C289AA
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7285B1E7;
	Fri, 29 Mar 2024 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eXKF4Lbi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F3F21100
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 16:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711728438; cv=none; b=WvgLeHYo5KAjSSLUN5VEk1xVCkt6efCj6FvHriUN5qLJWfuR8dkFrN6u405qz1UkVk8l/1SiYo/sow/yoYDHp4oMvgyea/uniVxY6SR+0/ELYi8hWJqhGhZWgGixv/yvnZdjPWpQEPe6UZNDAB3nYUIgwkbGRGUdElDXC3nYOCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711728438; c=relaxed/simple;
	bh=y2A2u4xyMbpyXNA8E/b61YqiwpEtEmuD50tDEBvlfJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rZrLZu/aLiMtaYAe/9dYENv954c6XBl2K9dmbkT/a0hihSuNZy1RhdyMP1Ik3w8YKdwf2VVK01ItHBQlFsPVm8W6QyKlrh1rQKuguiRrVc9hlpiGG6Y5P6ZbtFEdJjDi7w5HFItwXHlb5cyKbNuZ3VXnsWv3TIZt9/umXDP9D+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eXKF4Lbi; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ea895eaaadso415801b3a.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 09:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711728435; x=1712333235; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CBfpVXx2MUyvWN4iMB22QMOKaw+7NkonVMiDnm6Y/ZE=;
        b=eXKF4LbikI9LwUvu4LB4KnTqJ0U/sAELZKEsBjGcL7DXewYeXGY8OYor5ISHXVrFV9
         76Bw1KkqdnUf95DSAZ6/INLMxkreRQ7fw6+jyoGvl2pF2gb0iV+kwsSY5IUgsJpGOW5H
         wCiYW5/9eWarka1Vw5HwlNg1VfgoFBBGvgPS7nzVw3kLSJpVmnfurPRdH09UROv5gaS6
         wLdi8ysIHR9cDvj8tnoexuFsPBylgJRqPbDpjSONMm7rxXEICMmJwWbOZVfAJs3uIRfq
         Z0kxf22VSR/KCBfOMJPAqgJNgUhQuJvzoWFPrRBsut7bz4Fr1oxuL/tdZZOv6sB8oIZ5
         EF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711728435; x=1712333235;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CBfpVXx2MUyvWN4iMB22QMOKaw+7NkonVMiDnm6Y/ZE=;
        b=fgAA8MH/OVBDsvO9FpO6S1G6hQivNZ0qp0pJdUyiuNttKMJpASeKieD1I9qg98RbDH
         Y1SYPYr5UMTsO0v2EgRIYI8nkbRRheTcPeTITUk7/1wf671eHdMGZsHOQHMJuDuASTOC
         ZR3J9rHyUdtAPmqIyrVl8vmrcc/jqaFfVXY9mItYdf94W48vQ6EkPjDV9wDoZHmZZDUr
         xhOODscZRn1TWb44GFnMB1acDha2v6NckwtzidLH21qx5nyv9ahjrlRgI9P4h245TuLm
         mpVqBXXN7SIzilpqpdZXIsba8JPQtReohHJaztva/80JUt70FzblCEZAloNNai8RZQ35
         f9Rg==
X-Forwarded-Encrypted: i=1; AJvYcCXHHDB3HxKYcFYtVWIc5qy8i5LQbRRfV2tVlM+pbFIKfikFGe/v/4lHKA2jKY6K28u2xbwD161hh1klTJNUitFhAkEzgdJJCi8=
X-Gm-Message-State: AOJu0Ywb9Q5l2hb4IktLANEq7ceBtKNckUoCeYTsUWaoHmwGPBbHAl/3
	LObjHYGRZkimhZkQVY2zy/SU4MJIWjzil0A/46c7Ex1mpgwszbS2IMnHOyNFageOPW/CPth2ow8
	X
X-Google-Smtp-Source: AGHT+IHfmwsooTT6nEcpoNmm/9gZ/lrS7U7x9I7ljDdOE+OcNXqScBu7wyIliq2SyzVJBjoAgMBqwA==
X-Received: by 2002:a05:6a21:6d85:b0:1a3:c3a1:b780 with SMTP id wl5-20020a056a216d8500b001a3c3a1b780mr2534901pzb.1.1711728435068;
        Fri, 29 Mar 2024 09:07:15 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id v17-20020a056a00149100b006e631af9cefsm3206213pfu.62.2024.03.29.09.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 09:07:14 -0700 (PDT)
Message-ID: <4387133d-1b5c-477c-bff3-f1b7956fbc4a@kernel.dk>
Date: Fri, 29 Mar 2024 10:07:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: return void from io_put_kbuf_comp()
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
References: <20240329155054.1936666-1-ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240329155054.1936666-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 9:50 AM, Ming Lei wrote:
> The two callers don't handle the return value of io_put_kbuf_comp(), so
> change its return type into void.

We might want to consider changing the name of it too, it's a bit
different in that it's just recyling/dropping this kbuf rather than
posting a completion on behalf of it.

Maybe io_kbuf_drop() would be better. Would distuingish it from the
normal use cases of "drop this kbuf and return the cflags representation
of it, as I'm posting a completionw ith it".

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  io_uring/kbuf.h | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> index 1c7b654ee726..86931fa655ad 100644
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -119,18 +119,12 @@ static inline void __io_put_kbuf_list(struct io_kiocb *req,
>  	}
>  }
>  
> -static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
> +static inline void io_put_kbuf_comp(struct io_kiocb *req)
>  {
> -	unsigned int ret;
> -
>  	lockdep_assert_held(&req->ctx->completion_lock);
>  
> -	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
> -		return 0;
> -
> -	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
> -	__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
> -	return ret;
> +	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
> +		__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
>  }

If you post a v2 with the above suggestion, let's please just keep the
flags checking how it is. It's consistent with what we do elsewhere.

-- 
Jens Axboe


