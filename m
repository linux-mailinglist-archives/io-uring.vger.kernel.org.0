Return-Path: <io-uring+bounces-4410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C703C9BB92F
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 037891C21F98
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A801BF81B;
	Mon,  4 Nov 2024 15:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kp9/S5TU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178131BFE06
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730734895; cv=none; b=P/QJ8SBlaDy31IgIs24Hyj1CXQvBOCp+kzKQTkpqBX8y0Y1A2rFS3Ucp5xOotlMaiRo7n/yTIfkF8r1PH3hBDrzSeGV5V8zRN9CYut1JqtfKNcaq7fEI3XtOyQtkEb6WEwyIp7l9k82LGdGK8V0ztxo0vdOunjF3pTRKQ0miFgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730734895; c=relaxed/simple;
	bh=ngNp7D/S7Qy+isRKyVzxXRsSmD971bxTr7yOAGyuOio=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=irwfz4gnh/A+1qnBP62ITSTHDuYKfzCnYU3o3rwcxcBiB7DOaEL56YTkkprufefyK/FA0aaDNZLWFrFDbWwZgazrLaSIV122tnPb67WDPZhWtshjXXIXhw9LegAN3fGH3ZUgMA4cmvmDojQ5eomJm/0yl8SK6IiJPK1JtAaOYoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kp9/S5TU; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a86e9db75b9so695824466b.1
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 07:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730734892; x=1731339692; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=561z6F6LosmmdXVqosUX4O3idG5UAQWm90nE7byCxLc=;
        b=kp9/S5TUBXykkgPYQXB+Pi996ZwvdzyDYxi30QlLGBAJ94QbRSF6V4JzFv7WTbqbBD
         +W8ezfBl2Tsmeo0wl/1vzQYBJnttT2XIsOCTNWLXi4W2iuqf24GmxHbdnebrUC5lLmlV
         ojbyvigfCjezEXgqrRsMBO1SXhzWkWrYi+yMM4Fz1sVEtcrw4ZXKOQ0slwh0baRs2jwK
         jcymblHqz3Mvp7hF7Scv8V0bmRw2mZZdS3t9C8hnb5gMGvM1usZ/I3VlIsNavEjcmco/
         FtRQfnEgfOeEB3faY2zO+579Ee9gmj98SIg3w9gEdVfsy+XAHgPXW2GWEDTMRdWM7bkQ
         4fBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730734892; x=1731339692;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=561z6F6LosmmdXVqosUX4O3idG5UAQWm90nE7byCxLc=;
        b=MRQsuhBbtuXLZEKZWHWnYgb600HSlI5GOpe+JWkNLtkfAm2ZsCc0SwdoZviZ7iFHjq
         buFKQGlp2rraNSYo3AjZvH11UpQ40k4mn1sWwa4GMAM3dshv8tfulvV9VFgqjsfLr22Q
         1UaVLJMZnzJUUXOgoykpv27pWHBFvrYdeT/WePrqkwd9Kb661+dSCCaOItc6jCV8tEFa
         cyKHpu3XRVi0lKfESCdGyiVwmJ05bJdnoCrICi6owOnIFbnw0b5jDTpbMXrVwhQpp95U
         6oCMLkJLPuMzigjLSn/vPbVpO9frAfGRHRGPAqynz+jAkZmKSCXA9G4xKVJP9BuS4pOy
         v+5w==
X-Forwarded-Encrypted: i=1; AJvYcCVNTNjKVT7C70o8sJ6XpVzz7iVbH+lbz3brQ1iJNTN7h5shbJ52lSB8jdQzualIT0YgngK0oecH1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGPX3AoPEWs6tLlrEc+k3uEEEeZpRqOwOO/RWEcGD/PUdZZyvB
	vYFqlCF3H5TSFGuAaViuyDFRSHzMBmWHNSSB8A+2NRF4/FQHtitx
X-Google-Smtp-Source: AGHT+IFzwLhCIUjiIcfLioKLbxp+/RSRFTdC4wwgGjJczqYQgrcIalyQAcOAj0eBmoxQx2xBBklNhA==
X-Received: by 2002:a17:907:7ba7:b0:a9a:522a:eddd with SMTP id a640c23a62f3a-a9e5089b4admr1550629666b.11.1730734892347;
        Mon, 04 Nov 2024 07:41:32 -0800 (PST)
Received: from [192.168.42.239] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564e8e63sm566407166b.91.2024.11.04.07.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 07:41:31 -0800 (PST)
Message-ID: <573a63c4-0cb7-4ecf-a4b1-b1b0e208020e@gmail.com>
Date: Mon, 4 Nov 2024 15:41:38 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: move struct io_kiocb from task_struct to
 io_uring_task
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241103175108.76460-1-axboe@kernel.dk>
 <20241103175108.76460-4-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241103175108.76460-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/24 17:49, Jens Axboe wrote:
> Rather than store the task_struct itself in struct io_kiocb, store
> the io_uring specific task_struct. The life times are the same in terms
> of io_uring, and this avoids doing some dereferences through the
> task_struct. For the hot path of putting local task references, we can

Makes me wonder, is __io_submit_flush_completions() the only hot
place it tries to improve? It doesn't have to look into the task
there but on the other hand we need to do it that init.
If that's costly, for DEFER_TASKRUN we can get rid of per task
counting, the task is pinned together with the ctx, and the task
exit path can count the number of requests allocated.

if (!(ctx->flags & DEFER_TASKRUN))
	io_task_get_ref();

if (!(ctx->flags & DEFER_TASKRUN))
	io_task_put_ref();

But can be further improved

-- 
Pavel Begunkov

