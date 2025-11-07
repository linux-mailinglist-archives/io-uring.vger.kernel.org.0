Return-Path: <io-uring+bounces-10447-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B93EC41C0C
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 22:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F06261882B46
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 21:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A5A30216D;
	Fri,  7 Nov 2025 21:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qMK5LSPu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA30238178
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 21:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762550101; cv=none; b=rVW7fsYTdT/M8DI4k8T423Ff7nY8RaZKvwLazj0Yr4+HtYlHGVrlTBc5o3BF9eGm9xOsu6A+bhScxqOPWrkaNW0zyf/Ln8MTWRFEiEw4Zf+9AwWR3KwsPAO1Cdgox6oujBz1UC6Zcvhmh4alN865y8kevE8w+B0d3iMY3fE8ieI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762550101; c=relaxed/simple;
	bh=vOZpNpSXrd1W0ShviGZhNuhesScEZTYlyLT7Keoqf9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cN4oa+LOQeTwzKrFb5orvwxrAy9Ip/3cFQuAVqEVwqSBQ4KyRF9NZ6qDQYextlIjm4Lb7V+JHXBcrB2pWMnR9DoYgmXTpNdc/tmxbQnwc1AeahbHc4J0dyxjoXhlxhWXKSDqgrUU9ESxj1Qdyd6nWusii4HklbaDLrNKZAuDmpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qMK5LSPu; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42557c5cedcso732130f8f.0
        for <io-uring@vger.kernel.org>; Fri, 07 Nov 2025 13:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762550098; x=1763154898; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dM0QYndz87BxaRfoLJCupInuSN4RI3ZsebdVyhoIEkk=;
        b=qMK5LSPuW1FintCTTbSUqflG4eMdb+6elKSNCoFeOBxVh3dkNofEWUKEWV/Mq3UvT6
         fIjOR8JEu9L5ZGjDXfj2IhiUuJUV86h8VW6FXV1mls5FXxmD63bJzyJJWtUXRQaHCfKt
         TTW/IGLdA+BIKFeshCZsmu+kaPF77TF/PnFsl3AKPRaOACy46zHEGalvgQOODc3ZUeXy
         tHMy1T7O2k4TU+9R0wfhPCisLHDKFeRsgVQupSNvDWzFSZ/MD91BWdKiB8ClbQE1ad8f
         2r8mk5vKa7KnXM5MpC+MJ9FuYTtmt51qQKpj51gxvfa+4J+G0IwzbuH3S3jDT0jl9FMZ
         qjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762550098; x=1763154898;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dM0QYndz87BxaRfoLJCupInuSN4RI3ZsebdVyhoIEkk=;
        b=MK0y4zNQKSmhu4OA8obNQDUlbJ7zaV2t1SLlGcmjtDKzRKzupzOMWv4prqO6HEXUoJ
         Y6hTUZBCnXdE++nU4dh4etbd4iD38evq2G20GZalCG3XzIwkl5BL+AVvlXWx7H9CiRg8
         tvxrwaf2sGjaecrDrzXtLit1WK7lhuevCiUfA7ZWPM7whOVithaKTD3GFBGhaHx9eUwc
         ru6IbiB6T9C6BKkj8WzHshdMsRGb6ET9LWywI1IymuKQEgbBRzVuVn1iStQ2dUvS/Hgw
         p0fA1o29hlWVY4FrcGEGlf8wxwsg/bg/x/3mWE1Is99oMClLhJKNxhcvhI7W/fVmjUiC
         mG4g==
X-Gm-Message-State: AOJu0YyGGkY7PS6RVgW9KCOKn1KZfDOXnGUy6G4AihmGeTQ7yRvFue89
	TMWXJp869s4ZGXkH2e/qfE40AGOYsUaga0ju2w9ArwBg/xCEEud+QnWEJ5CPQwBRNA==
X-Gm-Gg: ASbGncvuddwagMtfCSvsgfhM11x45xHK9BagDK+l+wEhaRN06W1VbR3XS9v3/YD2iDc
	E7nfn0n7YxLXWLTgVY2FFQ5x9UqjF9YPkU773QyKYxUAaShBvqZfY8NeXcZnRhysh7f3sFNVln9
	L/CFqClZJ8TsaUhNHlsDIz/j3F8YyWYgAsIVzKE+lse2FhD7ctnI6R7kY82MqBWyAI86SxZL4Ml
	Oh0JStQMF+d5JFcJaRKpIwToe/jlOK0pcByu2S4d4F2U1llSEffXMw4heRHfm4Q4P3a6g9n9CjC
	MTgFCt/KNAYV6TlYKoABVvVgDGXDmJR7Ils4CDF41nvXngZF2JiS24sJN0Xl05M4iKTjeJnLClP
	9GQUsZ3gqAF413bTppBtOPhwSDYtbV66ClXTLmwnBFyh6ScNENTqzYnAAU5BD9qw0w6nOk17uYc
	SULaekD/WCEr1KVTa8r/dvQS2Eq8kiCA==
X-Google-Smtp-Source: AGHT+IFuXAg0N0zdkFyStzsnAj9kyv3rUY+PZ7FHx/geMtCnoeaTftasE33y/muB32zWiPBQzUag7w==
X-Received: by 2002:a05:6000:2681:b0:429:cc5f:689d with SMTP id ffacd0b85a97d-42b2dc6d0e0mr279838f8f.61.1762550097706;
        Fri, 07 Nov 2025 13:14:57 -0800 (PST)
Received: from google.com ([2a00:79e0:288a:8:8753:845b:f85d:5b1e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42abe64fd90sm7236979f8f.21.2025.11.07.13.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:14:57 -0800 (PST)
Date: Fri, 7 Nov 2025 22:14:52 +0100
From: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
	Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>
Subject: Re: [PATCH 1/1] io_uring: regbuf vector size truncation
Message-ID: <aQ5hTIBM0euPZGnD@google.com>
References: <11fbc25aecfd5dcb722a757dfe5d3f676391c955.1762540764.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11fbc25aecfd5dcb722a757dfe5d3f676391c955.1762540764.git.asml.silence@gmail.com>

On Fri, Nov 07, 2025 at 06:41:26PM +0000, Pavel Begunkov wrote:
> There is a report of io_estimate_bvec_size() truncating the calculated
> number of segments that leads to corruption issues. Check it doesn't
> overflow "int"s used later. Rough but simple, can be improved on top.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9ef4cbbcb4ac3 ("io_uring: add infra for importing vectored reg buffers")
> Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/rsrc.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 4053d104bf4c..a49dcbae11f0 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1405,8 +1405,11 @@ static int io_estimate_bvec_size(struct iovec *iov, unsigned nr_iovs,
>  	size_t max_segs = 0;
>  	unsigned i;
>  
> -	for (i = 0; i < nr_iovs; i++)
> +	for (i = 0; i < nr_iovs; i++) {
>  		max_segs += (iov[i].iov_len >> shift) + 2;
> +		if (max_segs > INT_MAX)
> +			return -EOVERFLOW;
> +	}
>  	return max_segs;
>  }
>  
> @@ -1512,7 +1515,11 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
>  		if (unlikely(ret))
>  			return ret;
>  	} else {
> -		nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);
> +		int ret = io_estimate_bvec_size(iov, nr_iovs, imu);
> +
> +		if (ret < 0)
> +			return ret;
> +		nr_segs = ret;
>  	}
>  
>  	if (sizeof(struct bio_vec) > sizeof(struct iovec)) {
> -- 
> 2.49.0
> 

I reviewed the logic and the check looks correct,
and I tested that it works as expected.

(Minor remark: You might want to annotate the conditions as unlikely()?)

Reviewed-by: Günther Noack <gnoack@google.com>
Tested-by: Günther Noack <gnoack@google.com>

—Günther

