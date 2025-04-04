Return-Path: <io-uring+bounces-7408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F74A7C1A3
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 18:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E9007A8357
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 849F620298D;
	Fri,  4 Apr 2025 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BKpsEr7/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478F727702
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 16:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743784719; cv=none; b=YOSVnpUXs7cAVRdlKhSiSMaZY/wkbQqRAjels9my1leatt5hyFdYFqoP9zFiRyShOqo0VvE/HGOmF5fbyEcxpx332VA+jr+P43Y3MmcdvizwfhPHlliuPC76osynq3R18oqv82vdlGe3+BruHVFN6JZ5aND4nUXc20gTFCAqFnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743784719; c=relaxed/simple;
	bh=fo1llYrD8NtH5qamuahC387dneDRNEohethUBbN8MjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d5D+RZoAVBR/hbTCckY83cP21+l4kx1xuB2mx7d9EFO2ctcNe6Hbujfuw1Z4TTF566L6GcGsuRUToERmdt0hG7CJnyPk6MyoUyotW5BzcdKrRv//rn0XT37rw8jLZMjU0YTv8hUsR6uRJUbFM8Txu5RIPPS72tR84YdlAI5HomM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BKpsEr7/; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d46aaf36a2so15523365ab.3
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 09:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743784714; x=1744389514; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MQZN1VSI/Kc/lU529WaoLPr7xrdN80ChMjfKr2a42zE=;
        b=BKpsEr7/y0zAGBqf/a4tUU0BNyRIVBW1hSpRkW9+ftzj14sp3GwGepwsoeP7ZXcYNu
         PiJacH22E4mYMI/rEL8YfC6k6TmfgwFicaUvTwUw59ZXplLjfV/J0f74JsXuMPzE3GHz
         qicmq/w46fwkDnnIuNm25euPvxk1tog7rzNVyNgcpcM48hjtNsrlWctqy/dHrDqwDuKb
         MFhMrr5RLbCGOQ1olwWeXdLO1FfiqjGuimz+kqWkb85Rjn782WNCSYbt63d6aJM2cbbM
         baTbTD6hQWdJ9ODOqv/eyf/QlOHfP8yozdDJEU27JontTTvu559dUHJXsS9UkZV9wwJs
         i1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743784714; x=1744389514;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MQZN1VSI/Kc/lU529WaoLPr7xrdN80ChMjfKr2a42zE=;
        b=w3YJCHCeHeNnKlfuu7x/f1/AR3GiOso4VwSAZK2+VDEpIAGBvEmTk88NT5T33t3blm
         /OxaMrYvWhBESl1Hy79/JLSQUWhtygrJtIM9//2IhAXcX9UMGd9AwnD/rCloa0Ea/q27
         ERZLOaL86FZhTJabHgM8YTbCc/DIAxqYBMqUTlGtjIA2Z+DHtpbK5xJ5SAftTY9gcPl+
         bueAriah+1EuTh9hUqD2Lpu4nvYeHb7Ye0btze7Yfow7hCu3qKPG902X7wDRznM2M1/J
         VYd5QvuRspvb6TBhZjapnguTLjOZehEAcW+KurKZ3m8kU9C7uQPxzeTNXfeRPYUfHaQl
         fq7A==
X-Forwarded-Encrypted: i=1; AJvYcCWjk4oOjPE2zdqDYznaEQ45AbXjNMZyqWT9VlTzIP2kwbTm+BPgBSpNFb6j6Aj8SGa002Y1ezNKEQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSKgM1WBDgs4J3TY3oVnjoG37hJ3qagaUcm25syOJWcGU6exIu
	gDIRQxOABigpgjtDDF5UrseQFOgpw2prvdj1+A9H8QmgTgeEpmLbwixtyX/7nMs=
X-Gm-Gg: ASbGncvxvjJQpdwGllKZ+Q3Au6U1hkEvzOgBzpusIz8RuGGDx9RdwwZEIbgeV5td+69
	wzZVD7p82Ad+do6RT+zvXdPIz6iGYTJO+s5D9ftzclxCfzEfMO3t9b7Q76dGnF0jUsAq93JWNyg
	Frf16cF7agMVuBzEVwEn4HvkNU7GkVfSk5DFBbD4Z9EQ8Pr5FwhgKiOZ5tceEWQ6N/q6C56ll36
	SGJ4/FpoQ+ehYS+NAGZG1wHxINKiywJmAPtpozI+Q2wmvDBS3eMaXhZgjcF5F9T8a5YpFNgOwu0
	1VVpggBfsHCDXljLwZdr6Zx8yPuepKlHGQy4xYii
X-Google-Smtp-Source: AGHT+IF8hUcDelBo0yJEJB1/d9xJpYgoNqtsWLJzaA99MdEdq32w/zSVpe85OoYz8tyEJPF/yrHyLA==
X-Received: by 2002:a05:6e02:3089:b0:3d1:7835:1031 with SMTP id e9e14a558f8ab-3d6e53181dfmr42328435ab.7.1743784714321;
        Fri, 04 Apr 2025 09:38:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5d24572sm877127173.83.2025.04.04.09.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 09:38:33 -0700 (PDT)
Message-ID: <1f12d9bc-b20f-4228-af96-a5c885f255ee@kernel.dk>
Date: Fri, 4 Apr 2025 10:38:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring: reuse buffer updates for registration
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1743783348.git.asml.silence@gmail.com>
 <8996ffd533db8bd12c84cdc2ccef1fddbbb3da27.1743783348.git.asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <8996ffd533db8bd12c84cdc2ccef1fddbbb3da27.1743783348.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/4/25 10:22 AM, Pavel Begunkov wrote:
> @@ -316,17 +318,26 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>  			err = PTR_ERR(node);
>  			break;
>  		}
> -		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
> -		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
> -		ctx->buf_table.nodes[i] = node;
> +		i = array_index_nospec(up->offset + done, buf_table->nr);
> +		io_reset_rsrc_node(ctx, buf_table, i);
> +		buf_table->nodes[i] = node;
>  		if (ctx->compat)
>  			user_data += sizeof(struct compat_iovec);
>  		else
>  			user_data += sizeof(struct iovec);
>  	}
> +	if (last_error)
> +		*last_error = err;
>  	return done ? done : err;
>  }
>  
> +static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
> +				   struct io_uring_rsrc_update2 *up,
> +				   unsigned int nr_args)
> +{
> +	return io_buffer_table_update(ctx, &ctx->buf_table, up, nr_args, NULL);
> +}

Minor style preference, but just do:

	unsigned last_err;
	return io_buffer_table_update(ctx, &ctx->buf_table, up, nr_args, &last_err);

and skip that last_error could be conditionally set?

Outside of that, no comments on the series, nice cleanups.

-- 
Jens Axboe

