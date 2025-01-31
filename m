Return-Path: <io-uring+bounces-6204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D2CA241DC
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 18:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A19E188ACFD
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5354B1EE7D6;
	Fri, 31 Jan 2025 17:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LI2Go13Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD941C54A6;
	Fri, 31 Jan 2025 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738344340; cv=none; b=lu+7KSk/0r9EFrxDXqrnm2J7h90fZdB76fUumnd5exeaNA+zANjg21iv/yxfydZqzRZ8IswHhHImG9f3wDXARBOZD23JnJfy9dqEIYdtryORDmqfcS91iDB1CuALIQs2o95/KpaUSLcQZHw78QJap6ACKQn9NzCWNZroEFy5gFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738344340; c=relaxed/simple;
	bh=wawbbulNNxwAzKLlK8yrskMGjXdbPaG278y4IdliaDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rW1XwMXIxdtWzc3uCYOa531RQHSQkHYCq9vnIfdgYaCh4pma3HFiRQBO+CQljWw9bGHE2fNZOl3m6FQe6BMmHO+evNytGHe/2eigzjuhb1aL1Bxmd56zbORD8D6AQ8VnKMWjg/TQx2jxw8f/vzvL7TVbvuxJ9KPksqrp081VcX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LI2Go13Q; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3f65844deso3906087a12.0;
        Fri, 31 Jan 2025 09:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738344337; x=1738949137; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jCf6o6+VYyrha3BObcM+V6OidzBHC5biJLUIxBcS/xo=;
        b=LI2Go13QVt6dElrTfFmCSy9lgFaCKW59/xrIU7kSdsf9APHNA6TOuxW8fTZhcR4Vdh
         kgv3HzHAqkyQgeOI2WnLl7eRf7IJdVrbqLbdpeyMGx9tip2ypTHUympmul3/LQqEBXR+
         urb/tN+3ACihA2Qjp+yQY7/qnv21cd51Y4t/RivGP6yMfGTlZcjjVtWm80fMHGp23xHb
         qL6DhDwBzHLIl92cZAkQAYHoeMC9ZvkDBaFvuEVAnbfznCBTV32f6/G0HupHcy57jM6r
         JaqkawkOWFd166tL7KK2buYGMTYppLhx/PjucP64+MmgIxyUy9G0N6O6F/kqJ/1qWDze
         nmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738344337; x=1738949137;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jCf6o6+VYyrha3BObcM+V6OidzBHC5biJLUIxBcS/xo=;
        b=VBHljnimwYTboI4JqEeEEaDseIa6GN5wvwaexKbZ6WMwtgfKyrx/+8lNrM2sEPFUkA
         s4kAVQumODgnTBn2V6Q8rnjhEhkzqDDnwd+PthWNipNwGiBzcVPcyGr7Kv6sKkxIQd6d
         im7ReJzMWpXuiRmELl49wv5Jko29SBs5UCt/R/ntw/Hp8LYYlqNfEs+MhnVexeA6ZM7U
         bCWWaJ7mCkxlg+Mr22gatMR/Zx6zKNJVxglo6QJMfbNrkzGXEovxTY/zP16byKlROVHH
         swdcBSeyDVCHn6hpCXKpUbKhBBz78hdkNPlBtRJaOk3AIdgVA8TuZ0uzY3kLJ12G+Ocr
         uonA==
X-Forwarded-Encrypted: i=1; AJvYcCWj/j78kYHAFc3cwLKkYYZbkm1TGqPhQIeqj+geOzzOBAaEd0tCGXVsjcy85xqBzeAO8GX/89u/JVDf9TdQ@vger.kernel.org, AJvYcCX/0Wb4GNpurcXtQ7Ka3LpBLJ5gyyocULRURP4xZenpMf8rxVuL8oTHSh+ZfUCnB6KCzWImWHXikA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgJlnF/GRij2L8g2dInWorsyKIZdrOnkiGe77U0gf0zPmn42f1
	DCwX0Xis0b4UpoxvSkZBQuZovFjlVcffleMZ0ljVCtgTkpSz/d9w
X-Gm-Gg: ASbGnct0wo//+Q154ZTX6zEv6ySMKPVly9b0OBCJ0BsrAgR93Tt+bgEG8Ej/etHEKFi
	bGT/NyyoKRlYj384SiTPb4C9Y8aSY4dNppyWxVR1Zwa35v1ZhRsYSeBWFhdwMJ88Te/SPI0BF90
	Y06Ozrk/GmGwWhySB1ZdgCqwPDjivk2vDDdDnYAdBBoMvfvHDr+r/Xhx4TgoLfYwxO/rhGPbciM
	UiD2XvFr3L9xUcnci3M7ImaBGu36jeQhYJXWVLdbOunUi7Gk8JNcNqBVpjcSmVwrDe1ptQFrWEb
	+zZ/wP+pWiVx8Txp2+wp2CkcPNrp/VjZxrjXEI84H9DM1tAB
X-Google-Smtp-Source: AGHT+IHeeFl7LOEuw+usNfvGPiS/5Chn+qZLqCF8e5ffflcM4LpVdjIZwOa5FrL96wWgZA8XdMaJ5g==
X-Received: by 2002:a17:907:9452:b0:ab6:f997:216f with SMTP id a640c23a62f3a-ab6f9972265mr501895066b.38.1738344336718;
        Fri, 31 Jan 2025 09:25:36 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a54cd2sm325721266b.160.2025.01.31.09.25.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 09:25:35 -0800 (PST)
Message-ID: <42716256-70a5-4a8d-bcb8-4a3c0be87880@gmail.com>
Date: Fri, 31 Jan 2025 17:25:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] io_uring: skip redundant poll wakeups
To: Max Kellermann <max.kellermann@ionos.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-9-max.kellermann@ionos.com>
 <794043b6-4008-448e-b241-1390aa91d2ab@gmail.com>
 <CAKPOu+-SYVHAWbLgrih338E_wCyOqEqA3cBHXf3qa-Xbx43hgg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAKPOu+-SYVHAWbLgrih338E_wCyOqEqA3cBHXf3qa-Xbx43hgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/31/25 17:16, Max Kellermann wrote:
> On Fri, Jan 31, 2025 at 2:54 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>                                   |     // it's still 0, wake up is lost
> 
> I think I misunderstood how these polling functions in the kernel work
> - thanks for the explanation, Pavel. This one patch is indeed flawed,
> and I'll try to come up with something better.

No worries, it's too easy to get lost there, it takes me some
staring at the code every time as well.

-- 
Pavel Begunkov


