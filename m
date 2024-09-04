Return-Path: <io-uring+bounces-3034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A39596C6F8
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 20:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25E7F1F229D8
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 18:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456BD1E4107;
	Wed,  4 Sep 2024 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1Mzz9bCX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A147E1E2034
	for <io-uring@vger.kernel.org>; Wed,  4 Sep 2024 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725476352; cv=none; b=TsuAoS0Ymom01iPYb/4WBjFYf52bfk9qnOHQTzZts4CnSfPlkjPcnZJ3+i4tZayoIkzQeelXIzMDdR65PSe9O9lueCOYEB93iOHYxMlaVL275g8aMCXlD5xgwCWmSIT0M66bSFVIJWh3bb8HDpfhMPNzgcXwzxDJGRc2Njkas10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725476352; c=relaxed/simple;
	bh=Kr4wnJWAVLiOQ+87uD8Ult0dwg3eo90OJJGevl8kV+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ri4QV0Zs01mMQs1nPO8ypkBqptlwpDDh1Ys3iDn6mVRGUmqq+xbMZOY8sWhUxkInGN3aje/bqlUAAVlDjapYMbH0YyqRoaTmHglGI8xaEIdAe9ENVWQsRlYQuXegKXCeXXRywkAXC9WlP3WfSaRM+cDkExUjm0ikq2S8/xZaPUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1Mzz9bCX; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2d8a4bad409so3090945a91.0
        for <io-uring@vger.kernel.org>; Wed, 04 Sep 2024 11:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725476348; x=1726081148; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x8LsCKVZwV5lQ3jWhAlg4mSx2NCcOVeDvZznPs+OiwI=;
        b=1Mzz9bCXApQcIpuWTQ5BZUYPHNJS8dbtQQYtc9pe/QkvvyrEDi3QZqMlut0SdwW2HB
         nNH5qGyANnOAdMFnJYAJAwmkjH4lnA6/eOeNgUUKrNVWY5IyFF4llABSPuzGUF1aDG9D
         54ZIJUjeUptk5CspCdYetWtJUTj25KHgl/xQgzDkRXp38SI0XYIB6LJrxdLaSWCeEESg
         FIV7MIazHYlr9qGk5UPd/5YniB1F1aGJ9W1Y8IN7W5q4j6UmQ771GlU49PSrkFxDHtpd
         IGT7fGxD+LVT/0GQZZBFMSlzgNs+IG4fWen72KpPFrQSbAtyQea9hcvAsaQ8CfHs6irr
         Kgdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725476348; x=1726081148;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x8LsCKVZwV5lQ3jWhAlg4mSx2NCcOVeDvZznPs+OiwI=;
        b=jEXVo+ekXTcpyeJxISoJHmmqJfADrqBr0w7AejU2HpEqY6DFCIO6VcG3KgeymVuloq
         H539cy43QlZz3EtvXCHNWcgfqPXILiBJYTcY6kw8KwVMn2IgS0DzhszQF0Y0ZsEJ5iZ7
         P/vhY509OnlrUMedos/F3akRQZsMe69IIzFHbIfGm7GDorNziWHvHqA4GQ7NjBEgdavC
         yjJCQqiVSjtnIkLHAEUINfBgJJX8/2FnXhBPVvz36PdTmShd6JbDvypevzs/bKX1iBXE
         VCV12yRtPD6Eaz5Ts4a8xdwk8udaQxN9GODYP+oVtfyPE4NSg3iwVC4r77y2h+xo/F/m
         8WyA==
X-Forwarded-Encrypted: i=1; AJvYcCU51x5H2wSGERRf3qK5h6r9ma4htyzJ94KR936eqa4IxzG3fOmCgthMlK84ZlRhnHQhKHFd0ZfCNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzinHUCfOsYhvjWy9dr3PGO6GcoI3bdOXdF69C0YD23KGagYZtA
	JZ+AZXdTTaWHEWIvd+lBs2bk4cCq4WnVEoP9xLQusbgfd5TdzBRim87lrv+L/mU=
X-Google-Smtp-Source: AGHT+IEczGwYE1W6qKTTzXwAPYEQh+2rAiwq81FMnvGCUVLI1W5fddQWW+CUvwy+U8JB2KVDKRXq8g==
X-Received: by 2002:a17:90a:dc13:b0:2da:936c:e5ad with SMTP id 98e67ed59e1d1-2da936cef76mr2879780a91.33.1725476347815;
        Wed, 04 Sep 2024 11:59:07 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21cf::1030? ([2620:10d:c090:400::5:fa1a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8cc28ac9asm7592934a91.28.2024.09.04.11.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 11:59:07 -0700 (PDT)
Message-ID: <364a2201-34cb-4888-9e27-9a34999d5a79@kernel.dk>
Date: Wed, 4 Sep 2024 12:59:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 17/17] fuse: {uring} Pin the user buffer
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-17-9207f7391444@ddn.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-17-9207f7391444@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/1/24 7:37 AM, Bernd Schubert wrote:
> @@ -465,53 +486,41 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>  
>  static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
>  				     struct fuse_req *req,
> -				     struct fuse_ring_ent *ent)
> +				     struct fuse_ring_ent *ent,
> +				     struct fuse_ring_req *rreq)
>  {
> -	struct fuse_ring_req __user *rreq = ent->rreq;
>  	struct fuse_copy_state cs;
>  	struct fuse_args *args = req->args;
>  	struct iov_iter iter;
> -	int err;
> -	int res_arg_len;
> +	int res_arg_len, err;
>  
> -	err = copy_from_user(&res_arg_len, &rreq->in_out_arg_len,
> -			     sizeof(res_arg_len));
> -	if (err)
> -		return err;
> -
> -	err = import_ubuf(ITER_SOURCE, (void __user *)&rreq->in_out_arg,
> -			  ent->max_arg_len, &iter);
> -	if (err)
> -		return err;
> +	res_arg_len = rreq->in_out_arg_len;
>  
>  	fuse_copy_init(&cs, 0, &iter);
>  	cs.is_uring = 1;
> +	cs.ring.pages = &ent->user_pages[FUSE_RING_PAYLOAD_PG];
>  	cs.req = req;
>  
> -	return fuse_copy_out_args(&cs, args, res_arg_len);
> +	err = fuse_copy_out_args(&cs, args, res_arg_len);
> +
> +	return err;
>  }

This last assignment, and 'err' in general, can go away after this
patch.

-- 
Jens Axboe


