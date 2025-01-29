Return-Path: <io-uring+bounces-6179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A30FCA22455
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 19:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B83003A6168
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 18:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180451E0DFE;
	Wed, 29 Jan 2025 18:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cH68fTiz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5034114F9FF;
	Wed, 29 Jan 2025 18:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738177007; cv=none; b=ESuqNipDYfN2mwxRwmatcJ+d9NIfCfgucSecmT0JfDTPhNhqCqpfJkXs3IYXG4MxeYi7NtLVB7JQ+u015kNUfG2q9BEZytfaLXImwdA2dJmHNYcC1/JMkOp8hdWZ01+iboEYnH0hrYi0fcoK73iXboFADsjxVJZfWimpGhFquvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738177007; c=relaxed/simple;
	bh=uFN7vk1+aLRICxhxtXD4DkYVEPVIJWRiyhA0EUkMPp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=a0ZMWCrdpclcQqaZnfO4s9iFZeIcDRv+J79a31XbA1XfWlLRtjNQ8v//zS9HBfSWs5rXHSzcwBlKU/GbFCVKlNMjD4aeDZFPjCXkpAmSZz1gbJ0bd471iaXWVcbwjOOJiLq/NmJsbxnoprxTmx50mbP9DjyT1/p6MP4Zm3jiKmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cH68fTiz; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4363ae65100so81172975e9.0;
        Wed, 29 Jan 2025 10:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738177004; x=1738781804; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eLrOqI5zbNi3idrMn9+//2tsg6H8m7LiRgXuJFOQwCM=;
        b=cH68fTizkKCIBBc4k2/lDw0lps6cGjLNZ8pSooIZOYUDlCC5dOOGsaDlcs5Y6wYQ6m
         fPGU17I4YU5txnOHGmJJVF181mDaFk6fLMPcaAVJiimLcGUPdegpRQpexpW54ySvTXqe
         0Cn8thNX6d/8L5eNYM8JNiS3Fo21VIgpFBUibrz6prlX/Zi2+k36QP6f791J8rHmu3dM
         ZM2OvAIu0vzWQ28ONqZ7/KJWZJqEy81kQz0Tbg9HlyzCohXJDgf7ZMg1pY+QwfJqXNiy
         BJOs8Ut1/wFViSi5U7c14XiV0D/jEEkZ0vfk9vPeFOo/Fovz5R37J3/p3oGjUT7SnSua
         2kQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738177004; x=1738781804;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eLrOqI5zbNi3idrMn9+//2tsg6H8m7LiRgXuJFOQwCM=;
        b=wsrfsT5p7W46ZhHfKqi6CZ6aRNd5/PnR20miqCCruJG30m0/rl8EHNCJ+nK/Lel+Hf
         gDwQVN5sUDVNUp93/Qt+QKWpCsdz0AFzJtHkjbV7zBeb9nZITbcEirnay3cVvLY0i3Jh
         DvIYKkFzG3LKnVoLYyONceO/Av+ibV4cSk9+oee72tReUU+xrof3e6bjMuJ9IpOLNEQ2
         N5RQ0mc3Y0v0PjOijeza1QhXqh/HXdHxIgeZCPj5i90/aH8rm9+FL/ZFQhXWKasdXUzh
         rih4cjL92q9XREd1vAsWsq87ufIyK49pLR42ypxAwBdVDG+eZaroiKC1ijfIK8i4wkVT
         psyA==
X-Forwarded-Encrypted: i=1; AJvYcCVABpLOEOiLjpr8wp/yAEPkV7swDBUmS615/ltufFYK0MVwe/+MBOpDWt+92/uhABX6qyuqbuZQbA==@vger.kernel.org, AJvYcCWnZ8/fOhpVou7VUL2lDock0hM5TEMwNBskxRpD683ckb4MXMwX8q/KhHJIzjToJ2IB7ZhTrIIM8BeNTx46@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+QrDxwQa9Y5cJPlKMXWX9N783FhUdgy669IYWQueRhBqCgbdQ
	pPTsEVPJUQmxzrYDLw4wNZmD6cf2LeS/jk1SKbN8cahckqAyOmAhKj92iQ==
X-Gm-Gg: ASbGnct2jbTfoHl10PBxHgO//LGUhubcpXUBtV9bdBU6SHX7X58CCkph6C/SIkpXPvC
	wax8mMSTJYJmlnAsSbA8x9/zhEIhHGRTn4VTsybbK0EUoONaFu5YQlhpxJh505Hdq07p0tHGoQL
	AD7Iuwe93mkO54fcoY+6k+TG/er6xty2przCiAAmmqnPcSNJsZw+apz7dwlprQgZa5Wf4oF5hZa
	Uvcii2sQd7bm1ARf0iRWgVI5Z2DJ/NpM/e+6zjOC/YniYJGSOjtzcREilmxVJT3O8HDQb7RTDy/
	12FyUVeSpjG7RiH5vXvstV7yTA==
X-Google-Smtp-Source: AGHT+IH0GlNXnBxBo7vugQK05ndvY3w+vL40buD2W4pX+0v902qAGn/SyNq8za4vStuIJTmwaZ0Hmg==
X-Received: by 2002:a05:600c:4e87:b0:434:fddf:5c0c with SMTP id 5b1f17b1804b1-438dc3ab5afmr43760925e9.4.1738177003363;
        Wed, 29 Jan 2025 10:56:43 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.217])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc27130sm31684885e9.16.2025.01.29.10.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 10:56:41 -0800 (PST)
Message-ID: <856ed55d-b07b-499c-b340-2efa70c73f7a@gmail.com>
Date: Wed, 29 Jan 2025 18:57:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] io_uring/io-wq: cache work->flags in variable
To: Max Kellermann <max.kellermann@ionos.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-5-max.kellermann@ionos.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250128133927.3989681-5-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/28/25 13:39, Max Kellermann wrote:
> This eliminates several redundant atomic reads and therefore reduces
> the duration the surrounding spinlocks are held.

What architecture are you running? I don't get why the reads
are expensive while it's relaxed and there shouldn't even be
any contention. It doesn't even need to be atomics, we still
should be able to convert int back to plain ints.
  
> In several io_uring benchmarks, this reduced the CPU time spent in
> queued_spin_lock_slowpath() considerably:
> 
> io_uring benchmark with a flood of `IORING_OP_NOP` and `IOSQE_ASYNC`:
> 
>      38.86%     -1.49%  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
>       6.75%     +0.36%  [kernel.kallsyms]  [k] io_worker_handle_work
>       2.60%     +0.19%  [kernel.kallsyms]  [k] io_nop
>       3.92%     +0.18%  [kernel.kallsyms]  [k] io_req_task_complete
>       6.34%     -0.18%  [kernel.kallsyms]  [k] io_wq_submit_work
> 
> HTTP server, static file:
> 
>      42.79%     -2.77%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
>       2.08%     +0.23%  [kernel.kallsyms]     [k] io_wq_submit_work
>       1.19%     +0.20%  [kernel.kallsyms]     [k] amd_iommu_iotlb_sync_map
>       1.46%     +0.15%  [kernel.kallsyms]     [k] ep_poll_callback
>       1.80%     +0.15%  [kernel.kallsyms]     [k] io_worker_handle_work
> 
> HTTP server, PHP:
> 
>      35.03%     -1.80%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
>       0.84%     +0.21%  [kernel.kallsyms]     [k] amd_iommu_iotlb_sync_map
>       1.39%     +0.12%  [kernel.kallsyms]     [k] _copy_to_iter
>       0.21%     +0.10%  [kernel.kallsyms]     [k] update_sd_lb_stats
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

-- 
Pavel Begunkov


