Return-Path: <io-uring+bounces-4508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C71C9BF15D
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 16:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 307F31F21C12
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3B82022D1;
	Wed,  6 Nov 2024 15:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bhd48pl+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A321D7E30
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 15:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730906234; cv=none; b=DRHF/Mcwarsokq4awYgHs0s+K4NUS6/FHWd6bo+5iNkSwLSqIRixMcz5tWp+3gPc1KUbWvaLLAAUJohZaHnHsfk2R7bDOCArmSMUKPIqOIFskyaqenTAjLwJeKfKHAmk1HyeVC7KqbGNaNEZ/iZe+3SFNwqAuTboi9mkWQUNwyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730906234; c=relaxed/simple;
	bh=gwhIT01Rty6D3qESQCpRlUMDB3Aw6oKB5NyfMA+odNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k3RIVFOAD9K9TcsBwZGFPrgUAuvKaBCRxshTz9EgsFFQACE28pb2sUCmIcjGgVcoTYyN7hFqM6X6rYx6ZsNqruc92q/FqqW5qM6VCpIQRecob9KTtDDoUKPskzdvBZS/vRgUwNNVPAPayoFgcIkh3qiwBlQpSFKV7k2yJz3t8Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bhd48pl+; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83a9be2c028so233638439f.1
        for <io-uring@vger.kernel.org>; Wed, 06 Nov 2024 07:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730906232; x=1731511032; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fU6iZ4qpfSFQA/Yqv1SRdLVGe0meMYepxYwkN5DksAw=;
        b=Bhd48pl+5YsJCXxDhXIhuKJ4St9fstzYCGhEPMRsO3AvwJMLrlj5NyGMIEMCkXQkMI
         t71EVGTXr9bhBqmnHmCZerDGZHsFb9hC9SlzmfwAIN5hcwCcMUesNxNetzN+mBvPXzLK
         5Hbpr3Dimy1zlrJgTvyUpre/GRQo4t2dAiasnrHdbhE0oB2gTMGR7OR9F7mMmNzF/rDo
         Iuol7UNzn7aw0qGLkX1iuznv7Rb/HxsMMSnDdHM59v9MGuiSppUyBWDS4SZQYZpHRn5o
         7C2l51IbWR86JT/KY911iNmexYP6xjr4jrZeO91NXaHual0oqaNX9fPWycnDuQ2/xYxR
         sbNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730906232; x=1731511032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fU6iZ4qpfSFQA/Yqv1SRdLVGe0meMYepxYwkN5DksAw=;
        b=CX6qUwmJEzrfDpavP+QwnF/V3sqFWyBK+lWZA3dNxwK8T5gRc34pen7Wq8QYMGaxbB
         6lcsryKypcY+dlDfdlnMeJdgP0ppoc5sqqBJ8BxHxhGwhwk/KEolkPKgRxpgFmIexqpJ
         Vp0Ua+4SOOzu1Pqabj6tnDHHx7ysFuhZUxeyZo6zLpKBZIYffpH7+wHUX4HVfDjEo5Le
         4F9rF5k/iq0nAY1cutElMwu222XvlrU3nO7jnhXZItD/YuzzBpA/t/XRJ2y4Jt+2Sbkb
         zecYzbdiPnN0OPcUiSqhxI2sLpO/gpTJgZmaEOct8jqV4/wVS0li1c74j5L0TzVNPp8Q
         5vlA==
X-Forwarded-Encrypted: i=1; AJvYcCVffxe4VALAUpOlXdq0vCNioFlbtjBXmyqq3PxVc/Dhw5DgMWrUMkvw8pAuOt27/Xk5Yc2ut7vtMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOenJvhb0l6ZMbCgpWMy1GPIV11UxodS4zzzuuXW1d0mhUBecN
	WQwiuHuNutySDwQza2US7iQoe3nQ9V3Om8t6zWboWnE96W56cJkF604UMkGI8bg=
X-Google-Smtp-Source: AGHT+IGgE8xdpIjMmnXO4QOkmSW2OCnqnEdZE8DQuVNanaXpoLOG/fPE8oOW4EjfaTFY84uZIDez1Q==
X-Received: by 2002:a05:6602:2c05:b0:83b:47:8d5 with SMTP id ca18e2360f4ac-83b7190ab09mr2451131039f.3.1730906231712;
        Wed, 06 Nov 2024 07:17:11 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de049a4739sm2897084173.136.2024.11.06.07.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 07:17:11 -0800 (PST)
Message-ID: <8f2cb112-29bf-4aa1-8d5c-5291d9f634fc@kernel.dk>
Date: Wed, 6 Nov 2024 08:17:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_BUF
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241106122659.730712-1-ming.lei@redhat.com>
 <20241106122659.730712-6-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241106122659.730712-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/24 5:26 AM, Ming Lei wrote:
> @@ -670,6 +689,14 @@ struct io_kiocb {
>  		struct io_buffer_list	*buf_list;
>  
>  		struct io_rsrc_node	*buf_node;
> +
> +		/* valid IFF REQ_F_GROUP_BUF is set */
> +		union {
> +			/* store group buffer for group leader */
> +			const struct io_mapped_buf *grp_buf;
> +			/* for group member */
> +			bool	grp_buf_imported;
> +		};
>  	};

Just add a REQ_F flag for this.

> +/* For group member only */
> +static inline void io_req_mark_group_buf(struct io_kiocb *req, bool imported)
> +{
> +	req->grp_buf_imported = imported;
> +}
> +
> +/* For group member only */
> +static inline bool io_req_group_buf_imported(struct io_kiocb *req)
> +{
> +	return req->grp_buf_imported;
> +}

And kill these useless helpers, should just set or clear the above
mentioned REQ_F flag instead.

-- 
Jens Axboe

