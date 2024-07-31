Return-Path: <io-uring+bounces-2626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6EC943930
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 01:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97A551F21D0C
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 23:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E13016D4D2;
	Wed, 31 Jul 2024 23:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OJX6JWZW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6255F16D4CE
	for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 23:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722467340; cv=none; b=Sgdg+ZkJaq7x2z6ucZuItnvHuW6/mAOXj/ePBqJswrTi44L1bs9lTuBDQPP64QUpJJNz5G6ZID8ppiURsj9jW3w9pyalYCZcIGsRcbXz3uC0eHWriz4dbN8C/Y0YgS7uIORI83apgfrL/n2hJAfzznYZg0ch/Et2MXpsYJ1w0OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722467340; c=relaxed/simple;
	bh=Bl5NMZggLJjvv1m1ENmjqQtmZ0N14/cHIvtqEZV0+WY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m3KKRtjO0XosTtbd8so0BahS4t1DKXjhC1rj24/IUxJHYrr5PJvBhkU8QlMQcIE88KEK4buLLvTGbvld32zXu02ahacN14ytMwdV4ufRJgRp5BUtNwQVATEvxghnYT9AA9fY5kJUZfKgB2lodTRN9fmF5hrlZKhlF4UOgnkHPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OJX6JWZW; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52fc14d6689so6732176e87.1
        for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 16:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722467336; x=1723072136; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gXA3D9Hyt8EzO/k2qrmzTBjIEXGZL88cdL63N70tGw8=;
        b=OJX6JWZWVIYJokXrinAO9HVnJR5bVE0vWVdFwXI0VBollWGyPQn0yxOvgn73C3A3KD
         jZdZ0Zzz/NNDWTdPg2tq4l+I51dHPhcoQkaXZyXxu1FnfeRsKlDtc2IYLqweMwvT7F8n
         N2oantl/z9fLQ9Ynaltdm8c16GBIT5+69kg5JwhClgyNFGNDHG9AGevxIHdWu+rs5csp
         WFWxb6RJJyuIzXtBuhWSR2reMZnXVJJsiLSWzKf7TZ9WYg1MWjbteoRS/MWN1jxfugc/
         NEgvI7g9JzQlIW4+ZSR5cL3NQniDaiYz6SMe1p6y+g0NaxHR9rCLgZ0AwDne29qoHZJZ
         iaIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722467336; x=1723072136;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gXA3D9Hyt8EzO/k2qrmzTBjIEXGZL88cdL63N70tGw8=;
        b=g/LxoJlfA8Utt42BJeDpzjdf0dvN9W+918xST+vJ5723kKTjjKGUghnDeigz0Sg4y2
         7ZF6IPeFi2IEm8N6W7re+PUAvQsi1Selnuw7LV+Zn20xnk7VuddJhzEqcNbYSE1uUfdW
         ImCxB6t6TegN4uWRvkC9FBYHbOxbBiGFgyOkrk0cDb++kdiRyUXchGZaj8BsuQrOtPoR
         xK/3Fp+wLkXd52IBMn3VBXUWxPt0zelFhI4ETG9iphwrODfcEQU6JdggXDBTtieZqT8i
         3yWPFFUum5Dl+1tKxLVjcQNJIMs1JQF4tHNnh0jwEOBjFxRg/M/IpCAhVXJ6u8+2gkxy
         AFCg==
X-Gm-Message-State: AOJu0YwMYxKGbiHSUkc/harBbpTmLH7xjzC/GhqASJDGAGCt/GwKwCGn
	nxg0mNOBsww7hVy7zMZsAIxYhY5YbKpRSl+1Wk4El0G0kNrgMmdr
X-Google-Smtp-Source: AGHT+IE991vAdDyvtr61jYzx9gdNtObldgXNLVBrHuRk1iLFz47iXg5mF6NJnRoAcjNBKhrCjvUA2w==
X-Received: by 2002:a05:6512:3f02:b0:52e:9b9e:a6cb with SMTP id 2adb3069b0e04-530b61af262mr329966e87.15.1722467336070;
        Wed, 31 Jul 2024 16:08:56 -0700 (PDT)
Received: from [192.168.42.198] ([148.252.147.239])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac63590d81sm9338585a12.23.2024.07.31.16.08.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 16:08:55 -0700 (PDT)
Message-ID: <59b96d52-126e-417b-93c9-a2588138fd43@gmail.com>
Date: Thu, 1 Aug 2024 00:09:29 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20240731090133.4106-1-cliang01.li@samsung.com>
 <CGME20240731090145epcas5p459f36e03c78655d92b5bd4aca85b1d68@epcas5p4.samsung.com>
 <20240731090133.4106-3-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240731090133.4106-3-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 10:01, Chenliang Li wrote:
> Add support for checking and coalescing multi-hugepage-backed fixed
> buffers. The coalescing optimizes both time and space consumption caused
> by mapping and storing multi-hugepage fixed buffers.
> 
> A coalescable multi-hugepage buffer should fully cover its folios
> (except potentially the first and last one), and these folios should
> have the same size. These requirements are for easier processing later,
> also we need same size'd chunks in io_import_fixed for fast iov_iter
> adjust.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

