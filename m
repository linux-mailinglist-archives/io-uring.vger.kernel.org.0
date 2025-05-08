Return-Path: <io-uring+bounces-7917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF1FFAAFF66
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 17:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3629F1BC2FD6
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 15:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C815821ADA3;
	Thu,  8 May 2025 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qx9Fqp0T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218DBEACE
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 15:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746718937; cv=none; b=UK3gD4wEEDi5/hFbWWVxGMilTg0/2JgmGLbbfRAZlnl0QiI0PAGpu6+7PU/6j1F5Sb8B8zWTREFOpposRWHPoLY/pt3aE4pvoJtyNLixcCQ23RiUVdFt8i3YpLIMgpVAGiZDmkmW/bt+/Vl6JiYBaeQpoD0JgCSISTFYo/8qAJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746718937; c=relaxed/simple;
	bh=/P455RKNmIaMVq4nDiGQ7xDlSzC+yNHsbqrjbOjo+8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pyOuZGpXpecfSb2zQ2XxxrtsCjHqgvgfUky0VBs2xCdeuRRvZfVyUGbz4wQf893ilyLHs0V7eeMNHs87Z16NVeexaxRFfkUiC1uxHplJllsUtToMJaotdavz8W9DuEJnnIc54xo8/WCaZ68e22Lvln7NLGbRkbiGe/rn/8JWPzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qx9Fqp0T; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e6f4b3ebe5so2178133a12.0
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 08:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746718933; x=1747323733; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8ijsT0/WGLv4W7K3V9UOlRSBehXFi3lP1ZGmjyd4h+g=;
        b=Qx9Fqp0TbCi5Wb3UUo8r5fAJqWkEUmRMJ6tZiAvVZ/VzQumGY28Q4X07krlneeKZD+
         Cge/4Ybu6231Tji5y2KS3uRPg7MsYpdj5NhGlqmbywCr7UAvMTa4eWVK4Oh95nazvlR0
         nzhk1otlIiOaPiP5LysXjqRwH2/HMIHFKPhXmiTQ28NSdNlN3whyb3LG6fj0RRv3aQ4q
         IbfRi9t+TzcsDsJ1GBtJ5+l8bLeQQi/6TVsUAbNBDpO4smjnu50ZEakLRdZh6Ev4MIrc
         EM/rwYmfaFBoqXYg5zxbH1z8cfaLW4BvzBG7pBB0d0Tt/U9uadwvmK3v7gzh4f9TvVbQ
         LDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746718933; x=1747323733;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ijsT0/WGLv4W7K3V9UOlRSBehXFi3lP1ZGmjyd4h+g=;
        b=TUgtEX+b/LAxLOjXBv4aoRz6JvVF3et9ZfMo2ZtnVTI4Q3JRzQ+m/qdStAG2SAp6Fo
         VVr0EpRbzMvzKv3eSmNbUz+upz3JZR0MfNJm2LSMwCN0Xfo3igrflcjDHvken8AYGLbz
         gpqA0ytdNhVjDXyAHgZJXwh/X9fXyJJ5TiEjGUhRaY2egI9q7XvTOcW80exJxISQ4wOW
         XUMjxvntjAORqK+GIhcFg1ELVfmd6ufjyZFw5yKZm2WE+77tzu1pNIB8pYSwv2CqkxnI
         YEV9PCmnUwGgT4arFvMzYDvp8BowhTYo0Lg5RsLEZC5OkxcEEQag/LlhJxT43PtD6/TZ
         1KqA==
X-Forwarded-Encrypted: i=1; AJvYcCULcZEmEAmu2JxWcRf87Rqde/mWlA8CND/KmVqJsDnn8SnLsllzhZHye14QhSv09DgrqmKKBMAKTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzoQlG7TGAzekph5/3swWpT7Grg18FzCZV0mUI+C8zhCflKfI1f
	3rBsZ36XYQzCS/NGk3sb8jXYzy5GYzhm/JYb7QJV1P28hlhM61wd
X-Gm-Gg: ASbGncsxsd7e1+8hsBIusTg5FzJk1raHIfNTVjZdAGPP5Zr0uh82PDhLOJY5cD8H8D6
	hvLRzYW2cThq1cnYzWVR3jLqUaSpyrzQ7b9LFIRtO8SGyr9OVkoR9N9KihE286RdmIj6FHiD7L6
	IVwOjWBY6iqDVRLXRVzhraDNNNBYvirpukvpoyMgN9IetsA+rM401aiQ5a+0t1+Q9X1rYu2jAWm
	N5TJnGkR5cBXGzFJU+Kq7vZlEaDYXlFpBrYLELe1Xn+QJ51vIKjbstyqQfHJw7ykWdsH4zeJ3iD
	Vpj0zFwkBJXYtm1+lTTbPFu29A7GgPyApueEw3xJb9KbOfLW
X-Google-Smtp-Source: AGHT+IGlWPvGS6nvGHrkZPIlL9BAbdFjbDxeeI5GcW4XhPnM4UfBkfK74+Ht28X/YbAJKbHqZGgu9w==
X-Received: by 2002:a17:907:97d6:b0:ad1:fa32:b608 with SMTP id a640c23a62f3a-ad219170628mr9884166b.42.1746718933212;
        Thu, 08 May 2025 08:42:13 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad21985858asm1053566b.176.2025.05.08.08.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 08:42:12 -0700 (PDT)
Message-ID: <64fbb741-a50d-4cc3-af2a-e90c7a8c6ac5@gmail.com>
Date: Thu, 8 May 2025 16:43:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] io_uring: consolidate drain seq checking
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <cover.1746702098.git.asml.silence@gmail.com>
 <4fab0c9fc5e785d7c49db39c464455b46aa35872.1746702098.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4fab0c9fc5e785d7c49db39c464455b46aa35872.1746702098.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/25 12:52, Pavel Begunkov wrote:
> We check sequences when queuing drained requests as well when flushing
> them. Instead, always queue and immediately try to flush, so that all
> seq handling can be kept contained in the flushing code.

That might be not entirely correct, I'll need to remake it.

-- 
Pavel Begunkov


