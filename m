Return-Path: <io-uring+bounces-6817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F0FA46B30
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:36:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0971A3AFB50
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD6EC241688;
	Wed, 26 Feb 2025 19:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3U8oErE5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CBE23A9AF
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 19:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740598575; cv=none; b=efflXyLY06dkPMc2OvLukzhNIn/9SttNU6B0cP90Z0N2RHH8u9g78VicHVa5ieqezLu4iGdfvsGK3GSe3s/kX/8GLTf1TFMJabetAx46gc4ZLw8w9FHnH9UKMC5GiriXdsV2DYikEKvx08D+4XwCGbOMzgiyMzoJ4/bmN++9oKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740598575; c=relaxed/simple;
	bh=7bcO+2fNVcIn6QQh8s6i3Sv8pSilFCdjl4g43H0pfVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lybwLg1CAr2pnhedQC3DCiPb7EGbS1aPnZHXVNxtqesISsKoHjXplfnTgqG9T96nsctnnYXaRH8CrLITx3wqThXoCAwtChLzGkv4aWm60myiYkGGTYwn+RWhob0oRh5Q7MDiiEBZ8N93C4oWIl8FLFV2dr1+xC2NDhUZx6Z9klQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3U8oErE5; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3cfeff44d94so924045ab.0
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740598573; x=1741203373; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZO9STZ95sF/hThjh2V4XP8IUCqoQU8S45+6Tzt1P4U=;
        b=3U8oErE5utlheiIpRIHDijiwKxsHx2JYJ7YG0AXd9sxbcd2BcWlQFHRzT2H4PcRkR2
         0DQqvST3zuJSNo+YJmHFkrMmYLt6BhOCHd/kyOh6cltwLiJ5c84+5uPslirO9FFSOJQ5
         RsoJB1FoXxPv28//1k8JLoMKKkzXUHWX58RmRBmdJD/2WKlO9m9YHPbMRlCFbWWX8E0G
         dObGwqoGe3DUgvDG4Q7VVHpWgTcIVjCbKuBXunMdA1ymsOPhqEfS30IzP5+RewPOUtex
         33qLN2RPooKv439Z8uCP9qX8Defaor2+yI5MxJuQoE0cMcgWT6vmOB/T+FV6lVm9+kzx
         meKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740598573; x=1741203373;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZO9STZ95sF/hThjh2V4XP8IUCqoQU8S45+6Tzt1P4U=;
        b=lzz2QemGLqjpg0BNmq/CPA9YyR3rtF4FaRWtllFtG9NP2HqkF+mwtdQHhCIu5t4kvd
         RdbLmcjc6vYgA8BnZz46/Nk6bEkoSr3D7khhDjVgy8IkPoqKDgZ0u/8mXAC+qKagiNmF
         125yabiSxPDUxxwgBHSuWd61HjS3uTY+jxTSdaYzyxrAKBy34XpQomU419eG0b5K4K0X
         mvRvVlFuZ/3Lr5UJRDV+CAy6kNJUP1PcoeCxXRAWnD900k4OfAcNUpLkFySmov0kYUrl
         HKfaBRCsSYUgwFUjYxKMiNpgyVCIsTU5gk/Ijfu19VaVNAZTLRIHqn/EnneGbX36QwFS
         phyg==
X-Forwarded-Encrypted: i=1; AJvYcCXrY7qEkJ0hy3KDgUUDM1NqyTh+Gr4x+nIxpovYu+N1fNCjm/SUs5xhSjplhRl5cIosd9WPNuW8sg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxX+IngjjoRpF9/DRjBRd9cZrRupVr4BcsyA2Kplz5k+WDHEmuw
	A0ZuJr5/2lJqrK03sfY6teIpBPXx/AmZuWu+EqVUzV1MIQsRTjPnTZf8KUl1hm8=
X-Gm-Gg: ASbGnctE6Y9APw6k18XLrDvM28YUICXPpAh2tjeedFlbvYk5O94GBkEHwnJySLTUrKX
	9rFtafdao0t6IZjp9eLTebptgVjOp2nrnDcr5vV9z6AHxBBbYGgVZ3CISxua6cFU4vaKxA1/M8S
	V9iDzZOQQJ+xUrMAbTmQ066Ghz5hf3S87MAVtNw7LWc4pRqQYzi+7+TAzFaWfWUMaikPLMtmAWG
	6xM5P7ufowKx5FlIK5IAJVWG1d8xJ0AF/ofTnyIb6+Scc3MElWYNZo5tjV5IA220KzpTh3qnjX4
	SpQ9B23xOTWOibVwvHwhzA==
X-Google-Smtp-Source: AGHT+IEbyL3881tCFlSZe9P+BIU2SFkXwfwwPxd72T/h1DgwPnDSWSN6qbGSXbtQaoY0apPWHhil4A==
X-Received: by 2002:a05:6e02:2148:b0:3d2:1206:cabe with SMTP id e9e14a558f8ab-3d2cb52f7cbmr218812255ab.22.1740598572682;
        Wed, 26 Feb 2025 11:36:12 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f04752dd55sm1043887173.113.2025.02.26.11.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 11:36:12 -0800 (PST)
Message-ID: <83b85824-ddef-475e-ba83-b311f1a7b98f@kernel.dk>
Date: Wed, 26 Feb 2025 12:36:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 6/6] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
 asml.silence@gmail.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-7-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250226182102.2631321-7-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/25 11:21 AM, Keith Busch wrote:
> +	return 0;
> +free_cache:
> +	io_alloc_cache_free(&table->node_cache, kfree);

kvfree?

> @@ -548,11 +607,19 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>  	return ret;
>  }
>  
> +static void io_rsrc_buffer_free(struct io_ring_ctx *ctx,
> +				struct io_buf_table *table)
> +{
> +	io_rsrc_data_free(ctx, &table->data);
> +	io_alloc_cache_free(&table->node_cache, kfree);
> +	io_alloc_cache_free(&table->imu_cache, kfree);
> +}

Ditto

-- 
Jens Axboe

