Return-Path: <io-uring+bounces-5522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD929F5587
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 19:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B59561895F1A
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 18:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C961FA243;
	Tue, 17 Dec 2024 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RyHAqJ/m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADE81FA17F
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 17:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458070; cv=none; b=JNXtpoy8+AwQbiULrwR8HdPMJENDiSBGd2iS6e1J7dS+DLZNO7JYv9Sm40mc/B/jT7mM5fRIlIsBXUxniKrlk0LNZYGusRp701AGIyPgMC5ztfLJF9lYb4lwj4sD8Kw1khnHJ1iRH6/364hBtt3sW/jWoakacAelLlVu6oB/lo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458070; c=relaxed/simple;
	bh=Lyz3pxba+WfjDFPIDQ6xn8XAtkSqhUaQDO2p6HbBcnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=txsrUupS99MOqBURrK+g8pFeoa6eqg5ASag1vmUb8WmHtugKChvEDrf28RhWZUFe8qjacmAlEPFRR1fd89RcbP7w5+W6WMi7cl64kemo0aTI0NzcuT7CiLxZVhgacTOd2FiSwL54goSLK4v6v9PcqRJL2suNUIb8RA/sb/MMNv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RyHAqJ/m; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8442ec2adc7so186333639f.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 09:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734458067; x=1735062867; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+S2KbhIrhYKECFApyJjGLk7qrmZwBnp+gEfOwbZqgUo=;
        b=RyHAqJ/mDor0NPB6E4y9tWb453DBiOvljE6m6eiPMtOr4e2sRJSzWqNZYd1dkMO3bl
         7vKY0s0MkSFXVmEZ3ZA8VhVNsx62cY3/jKsFeVzfY/bsR1gHnKXu4hx1iK1dKA8Cce6p
         XrKrmuCa8p7I7qyn7u8G5SKpBrsC42+6iXol+y7UoYJ+YT3cHPwn8p2zBVyFDkfpjPyF
         JfoaFmmD3JyyXzanbOmSUA+E8coMIOaRCGJkBDpr9Q6CgsaoyRaLZENp2i9/cgpjxPEu
         YUaxV2SMYjK6shepU6EPMNADn+CZGuDKOYrzxXC8n+1TTnIQVopfXVRhWJe1KbHD6wMI
         rksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734458067; x=1735062867;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+S2KbhIrhYKECFApyJjGLk7qrmZwBnp+gEfOwbZqgUo=;
        b=ljidmlA2uNbQ47EGRcN4vpWd4rDKUXo4eHytNDEUpcZsrZ3IOSf5bsAmVMUNuXRRWO
         aC23KDeU3EK1oyBugrAcVZ1dct5oly27YGjWQ6RNxY1g8LrdVtIK0M7EJiZv50+6qBSA
         XUYMm1Pef6SkAvVdKDtOeHUr38TsCTY1arsIRLXqg5Wwp479YMZ53ycnMRia01nTUfnf
         ILs2JsKGsYdQQzhA5Dz7W19XJKsYyPiiybWufnpEZIghzghxXryfPePtKJGZHF2XuTxr
         rf2J4sPsoj6ZE35vn7krW/6sOEOWahI9+GpvHZCMzZE1hZRFz/gxVJMYTlAdxY0b6/hC
         vM/w==
X-Forwarded-Encrypted: i=1; AJvYcCXDb/KtVAJqkU/rg9vpCmOaKHJsMMqE3MsjBBE4WKlBTWZRVA2PxfwfIS0+FAzK7H8sU6hcvZ0Nhg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyAPmAUfruJ5vSk2gC4dRK4dSBoXNeUmKAYfP6HrypEU5TyXE0d
	mlGDw+YcHoGgYkJYGkgcI7qte37HDIkHh+7AzLUAKA3DmUERBiikKQQL5YcZfPU=
X-Gm-Gg: ASbGncvWIiY2tTq2AqWi12toKLoc+ThQAfiMVCWTUp+pnIvPfoDwCwxk4XD+Sefr93z
	tnaQQ3TBCetqEKzUFt2IfNMtlCydN6jruP6PbndGX7xOcyN5io3HAp/PVDbJrGSbJA3FIrZ+sVX
	3J0STGBgW+V6meppF2vt6Uf/kUJxKfsyYfKO8zy57toWrZhAvcRKhL8fufmkPHBCyI2pxsmc5Zo
	JWjWstirhwOIunoroQpMJ5Yib35Y9HhAkjb0qw3YC0oTFO6vER6
X-Google-Smtp-Source: AGHT+IEu4IjNs/5xorwpYlZBESvq5LvFi/8gufZqjoD/nmtALPkmYF9FSVwvwu7wAaOMQC3j/4k6gQ==
X-Received: by 2002:a92:c564:0:b0:3a7:6636:eb3b with SMTP id e9e14a558f8ab-3aff800d5d2mr172047215ab.17.1734458067401;
        Tue, 17 Dec 2024 09:54:27 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e32a33cdsm1793038173.81.2024.12.17.09.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 09:54:26 -0800 (PST)
Message-ID: <acaf46f3-3f6c-44c9-86b5-98aa7845f1b6@kernel.dk>
Date: Tue, 17 Dec 2024 10:54:26 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for
 virtio-blk
To: Jingbo Xu <jefflexu@linux.alibaba.com>,
 Stefan Hajnoczi <stefanha@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: Ferry Meng <mengferry@linux.alibaba.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-block@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
 <Z2BNHWFWgLjEMiAn@infradead.org>
 <CAJSP0QXU_uNqL-9LmLRkDdPPSdUAGdesQ2DFuCMHnjyEuREvXQ@mail.gmail.com>
 <0535520b-a6a6-4578-9aca-c698e148004e@linux.alibaba.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0535520b-a6a6-4578-9aca-c698e148004e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/16/24 11:08 PM, Jingbo Xu wrote:
>> That's why I asked Jens to weigh in on whether there is a generic
>> block layer solution here. If uring_cmd is faster then maybe a generic
>> uring_cmd I/O interface can be defined without tying applications to
>> device-specific commands. Or maybe the traditional io_uring code path
>> can be optimized so that bypass is no longer attractive.

It's not that the traditional io_uring code path is slower, it's in fact
basically the same thing. It's that all the other jazz that happens
below io_uring slows things down, which is why passthrough ends up being
faster.

-- 
Jens Axboe

