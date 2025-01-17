Return-Path: <io-uring+bounces-5970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D375BA14EBC
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 12:48:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8C5A168E2A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 11:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D39935960;
	Fri, 17 Jan 2025 11:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K46pZpWM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B5925A658;
	Fri, 17 Jan 2025 11:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737114523; cv=none; b=CSAfLSzixfMtoLxabtxkJMqKgpFiGVevW+LaQnUr1pI6kZb4xvBZFzZcMOUC6fCjolmrf1dw6WeJNNhfFdzNQRRaDliDA0wVQeSYGXB+6sJFQA50MeJRe975BavlVIkUKixaSIw/o7IuaAEXNs3lY9To/4YlBHbkmps+RlmxeQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737114523; c=relaxed/simple;
	bh=nv07x0s7t+mgqJ3uTt+hjGjJQYONLene+H/UVg6zd4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s6K8EHK20qsJsr4MklgAamPYFXDGUDVsB7br7iY10QrLF5UO6tR+I7YBNt2a4MfsTKZMVvPU78rHo7ZPa3NMcwlnOiLdQSow8e5dM9YDs3aWfj4A1nj1Mls2NYE8wKbTKawR3KAeelTAdNkGQ7UzKItm2BdHHFkyHY06RtxRdXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K46pZpWM; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fdafso3952325a12.0;
        Fri, 17 Jan 2025 03:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737114520; x=1737719320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n+q/MKZtQ2i9KSscg0qw4oKnakpdQBBLDGkuk4AHxm4=;
        b=K46pZpWMFI30XTROzNZDLAXtHb7TyTe0sSXl8TDZJ6CDZWEZ646mw6QMbYvOwh3mNQ
         ItI317SSDozplysq0QK9ptDXNUJUUaI1poaAeQbUPnaReJCFND7hddeNuQowx2xsOZNf
         7rTdSxgCv27f4hGliBBiwahwnyLHMiZ/Yag/G6bH1Hv6VH8O0alL40GCfandSDwhkFUl
         TVVOMEH3NC+5o3dt+AJHploWQxd47AIOFfjZmTW0LwTzm8q7AbN4yLKR4chjAlXSe+1y
         d85h2Bq2KYIJcRIvfeXeVsXCpBip3MSBtX583t6JbgwgQfq59Ley/fMUR43N5TqRAfUm
         /TQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737114520; x=1737719320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n+q/MKZtQ2i9KSscg0qw4oKnakpdQBBLDGkuk4AHxm4=;
        b=wg5tnCHpLzohYg8EVVCErtr4+lv65armqCJY4LTNRBSSQtxzXj7MX2xqsOjDn7HI8k
         4E4cVSJqb3h0+Ds8ythEgAQFUM6evQ26bsb7/Hfe9A2A7tsydSLH0NmwwISmjvX/AsRc
         Qg2eAVHWG88GAqWbcws1Mj6B8kxXHeikU0StzAeec0eKOdKQodsy47cuNGukrZZR2r/N
         Gmw/wxmwXCOL4RnfaEuVsPVaE+lV95CVSOeMj1gK0sG5FUibKYMukBkXPp6sHTgLs9EL
         69rY+YZlmOoYJ2nM1OZ8B7+8oC3ybw+SFUTqvianYlGlQLiXhJPgwpNRGHNgcA6y53bt
         4pZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb0lWkWLxtVpb/u+EgZL6EQvrd4kYhDlxRNwMVwnokrwfUiqhUU+v1W840ZO1k1sSYez86IjR92Toh7SkoEA==@vger.kernel.org, AJvYcCXUy8XQO5QcxbnPw0gkq+GbsUWTAj5mPykfMy4QBT1qdT6Tntuq4NBF7a6V5F0ASwJEn8b1KsHsqA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs1+KUdCAab8gIfUI0N0sZtkO0/yVnSwg+gr6AW5Fk+7EhK/ZM
	AZSRTy08A2t4wcPDlmWqHfHKMarUpZfX4EvScTJgoHwKOexcf7/j
X-Gm-Gg: ASbGncvBggWbOQJDPG+D1hqRs2bVDlCLVLtjk39VJLF7Ad/YhgWOIIBbpijqIuZ+ecQ
	E+oDkYsk8j2lHR3wdhtYDXzvPJadeX94TzRcfKsa/idwjQot6/UVdSWrNfl0qVV/Jra5DrLPJK5
	pmJHshp/nkzU87tT1QxTll52Kd4LLk8UPSrk8JDVPkjXV/edviRg7ExAEyoo2EWjtOH1cmCUbOZ
	lbryCGKYDGo4FAagwiyR/62DsP31l2W/qbtC8yL2PEvLR+7IvHRCp1EJX/3oQSVddu0aLVSl+3C
	5G7awvUyyHkpqK+qKPkboFHrSOI=
X-Google-Smtp-Source: AGHT+IFJNsQffDjkmWyl9dKBuWxWxVmoFAdc7UltVP2pIKVUWEhyXGiD1JWeO+AJplnvTg+kC1w50g==
X-Received: by 2002:a05:6402:2807:b0:5db:7316:6309 with SMTP id 4fb4d7f45d1cf-5db7d2dc140mr2109240a12.7.1737114520365;
        Fri, 17 Jan 2025 03:48:40 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5db73eb56fbsm1380963a12.64.2025.01.17.03.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 03:48:39 -0800 (PST)
Message-ID: <a9519c9d-1f73-43b0-a47b-d635ddbd35d6@gmail.com>
Date: Fri, 17 Jan 2025 11:49:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/17] fuse: Allow to queue bg requests through
 io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-14-9c786f9a7a9d@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-14-9c786f9a7a9d@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/25 00:25, Bernd Schubert wrote:
> This prepares queueing and sending background requests through
> io-uring.


Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring

> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   fs/fuse/dev.c         | 24 ++++++++++++-
>   fs/fuse/dev_uring.c   | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/fuse/dev_uring_i.h | 12 +++++++
>   3 files changed, 134 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index ecf2f805f456222fda02598397beba41fc356460..afafa960d4725d9b64b22f17bf09c846219396d6 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c

-- 
Pavel Begunkov


