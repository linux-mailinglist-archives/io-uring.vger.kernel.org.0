Return-Path: <io-uring+bounces-5175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B10449E1E05
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:44:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 542E6B389E2
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E471E4930;
	Tue,  3 Dec 2024 12:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fzgcehbx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42161E570D;
	Tue,  3 Dec 2024 12:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733228052; cv=none; b=pz3M9AiDbpUkfmMQ63/QgMu9W+3VS3OB83mCaTLNj1YdcYypwYm6LjHKEzNdkUCH6S+p9f7vVyQiWmvwJ+KULhMqYdb/J1CL37QH96qFko+gv/5rPJwRUDENH3vbfXTAZdNspwrJWNvLfkUdPJjwOH8KqWuNQHXDyEKaBZz8c3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733228052; c=relaxed/simple;
	bh=tAO0ZeRGqCmiIAKdtHt4tYNfmovaSCv8wWfWgBeLvH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l96ugr3lTkzDsbP4/EjsuKY6rARZFUagnakO0xlGFMr06YQPd4d+Uf6++8/aCCXO+HGy3TPDaSdRCBWO3yL53MLdQI7bdiMHL1jG30Akb5/aVPNkncMJ7W12NnVGl9UPC5UngkRA05VA8Y1oPoL3/m/GRuCSA0ypGMs90NNaHTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fzgcehbx; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d0be79e7e7so4943523a12.0;
        Tue, 03 Dec 2024 04:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733228049; x=1733832849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aYa41I3tMLsmNfstYOxMKi/+Fg9Ns9dKhwH3u1EbE6g=;
        b=Fzgcehbxc5865TMJS4MEfjbvTxSLhboxjfNoc83ux3m4y5ohiBHaGzxNOWRMQoKX52
         uuHnhRa0BAo0Udfg9+pH5yI6MV7mFUvfiF+X0cX11IvUGpjTrAfs4stj1fgU0BHJNX/o
         4ucOfjBCLI+NnmAXDPMGHbzV2tCczf4VBdo49cypllJmWyrpkro5gBe4D5MbV5lAUHW5
         A6b/T4G8YwLVB1hFGcZEz1sUZc2UEw7/262eLYmNZvp3cJRIUhHTKPCNimKpFfISd4Ug
         VqSggmfZAIH1Kc+LpesCiBZNujs+L0sTxGiR2Idy+MkkNjOj69/giRkSDESd99uu+wSV
         pCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733228049; x=1733832849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aYa41I3tMLsmNfstYOxMKi/+Fg9Ns9dKhwH3u1EbE6g=;
        b=T2KaZp1xXUC4ku9GJMDLrQUn+HDNhyaFEKNKKdixTKSEKUl2nqRRdsSecpiSictEWG
         mwmK9b3YYwnHRSdEOXz2duCV+lbN9TOfhy7zlxNCl5bMwft3MXHTSw9Zmw6nHLInizBK
         UcpRvlOxwsVleE0THhCRDvTdvgByhSwCNsbGrLbU/is7lmhqxdGpP5iSatg/mjBVBZ2a
         kOlSTHFe3Ox7EpzXwMFaYcT4BQNExFLerC/kOXlxjxmows3oy+w8P83/NKc5EHXVXXa1
         wxFAXzC6WcCouW29ZPwAlI9aF6wI07w3Sj2KknhkHimxUwrqH7gMCedtbbsEzQHJXDzX
         3Wug==
X-Forwarded-Encrypted: i=1; AJvYcCVpZ8BW3w/vuJzH51V9tasF31yZJBI2ou00KZieuks1dJQVIm7cG50tPVnh/Ty8BgEJiBcTD50HVPy6jRCCDA==@vger.kernel.org, AJvYcCWNIj4vzg+RNVhmY78cx1IQqJcqtCC7sxPutyrHeAtcXmTgVhtJ6s/980+xczQgXa0ee27YeDUSUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWiMS9qvsJLDrnKRLFalPhZ/708u6WSj9mMq+NqrVht0o78rjZ
	oeytTjvnACtPZg8fKNbm8AqCoX2Q37Byo3+rbY4fHZgSWB2P8dHnlD7USQ==
X-Gm-Gg: ASbGncvhLCPBIt/UHK3Ankrx5tGRqIffshXBWotuFjGUb4K1BAHxIOZIweF8WJYVI9y
	X9jjjqFgHy/5fj2Q56VzREHa9uqiA0600sDpKqKq+hm4cvmj2YBj/Hlk2Rg56/rvB6NoEEOkSmC
	yb4uf5NjMw8QKx/VywZPmElCUNUjjweyquwZXK09ABNuyD//ACP8TzwNEHVCBDFRlGpxJ2LVViA
	Ly1FsfnVMqNhjSCqsBgUYaI8MbsxBBz9ZFfwfQ/DJh7vO6XQ76dhxtpL5dYZw==
X-Google-Smtp-Source: AGHT+IFkUm6A9sR4sJL2tWNsExNALXeHj8sXuW+Op8uDwwRc1e/kSYJE816Fi9ms5GgmtPIoWY1dEA==
X-Received: by 2002:a05:6402:34d4:b0:5d0:ac78:57 with SMTP id 4fb4d7f45d1cf-5d10cb9a204mr1506296a12.30.1733228048921;
        Tue, 03 Dec 2024 04:14:08 -0800 (PST)
Received: from [192.168.42.213] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d0d49fc12bsm3269535a12.73.2024.12.03.04.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 04:14:08 -0800 (PST)
Message-ID: <2d156fde-117d-45c1-9216-eafbd437cfae@gmail.com>
Date: Tue, 3 Dec 2024 12:15:04 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 13/16] io_uring/cmd: let cmds to know about dying
 task
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-13-934b3a69baca@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-13-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 13:40, Bernd Schubert wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> When the taks that submitted a request is dying, a task work for that
> request might get run by a kernel thread or even worse by a half
> dismantled task. We can't just cancel the task work without running the
> callback as the cmd might need to do some clean up, so pass a flag
> instead. If set, it's not safe to access any task resources and the
> callback is expected to cancel the cmd ASAP.

It was merged through btrfs tree, so when you rebase patches onto
something branching off v6.13-rc1 it should already be there.

-- 
Pavel Begunkov


