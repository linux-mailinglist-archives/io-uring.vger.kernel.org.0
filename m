Return-Path: <io-uring+bounces-9978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 57ECFBD58BE
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 19:39:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2363E4E1CD1
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 17:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5692C0296;
	Mon, 13 Oct 2025 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="i94qfilt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD023019C3
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760377168; cv=none; b=HTc57qSTermxO8Eskc+qejXJz7KvXHHcYbdXbA1nPmB26H0imPtgH6KQRRPrjp1Td/QD7CL/8zsvbFwxQh5gVMsGKkpDIk3OEcyNE4MplRpVtjrDkm3RKlPRVkzMzf5iYT+gsiyNpknNFR0u29CBJt4ZikwDYM4AaozyDjclK94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760377168; c=relaxed/simple;
	bh=tBKj0paClMXjAnPifLpImfeBKw8ONL3nDmiqD1CE2EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AjdzvpZQzDecAOUILGS+p+jI0gDbNlWbO4aA27PuMIXEZtYCEbNq+him4iuBVEUA7RQ8FOPae7jzrxOMr5SoxMaqhIXeLeI7KL90NARo3ww5cZCT+Sv7Fr8rpPg+vmcuqnrR1KfihEh41/N1q57GE9tBnJLopKHV6RMGE1InTwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=i94qfilt; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-42f8da689a6so45158875ab.2
        for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 10:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760377164; x=1760981964; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rzLO0pZZA8ekdXSShPJl0yVWLtGlFBCKFvlrQEHTbO0=;
        b=i94qfiltxy/Zy4y7msg2GI3f5bxYM7dvZmGICdakajvry5k8rbf6HZQwRM8EqtYTqv
         n6BAAIyyq3BjlwhgXCGpKgHVmmv7VfV05bVf09BxTBk43JM9rS1SV3IzDAM5g4HPFPyt
         UrFMJioaRuxZrg07VGt/huk0RTas66/bEXk5PwApYo2HHGLj1rZVgb6dc5O0Gc7n4R6m
         yy/SbI+zE3flQ0TfaerhA+m1d0UYQNe3X/hpsUiMcvVxZJAs8sgimtyjDyqE0EtQNtLd
         pv0/Mseb0xeNusn3HKy5xgax69neCV5mk0bDgiQqgiHDcgcOfM7j7Jd6mO6Goimeu5IL
         NB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760377164; x=1760981964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rzLO0pZZA8ekdXSShPJl0yVWLtGlFBCKFvlrQEHTbO0=;
        b=gVCuHUqSj7acnlp3of9ZBcPW7A0gnX3fYQVxnTZVABI8RiEJmhJMC8Altn07VUOVbN
         vbaRM7srTzsmKOwa8mlSKfuipHF3bJxFbPhpOugw1sCnILhZhegXURNzbqC3nHAxPECK
         o0qwzJxeiohdkgZ8UmxHdcblq/3yCzALO9C4nJX1GMrtc9rJMfL6SEB8isi7OR5wBlPn
         oEdsGXb85Y5VP8EUhya5F1/y8JlL2gQAE4UueJjWcvH6LTQWJq66zGArApMuN9Tiq/t6
         DS4lcxc1xUKExchkB7Ffyv4go4liwVAtFRm1iGVM/JbjeWtXTm+VJlk2QWRE2veuJssW
         xJrA==
X-Forwarded-Encrypted: i=1; AJvYcCWPLCxKpS0GdghtgXWQvK8fz4yjeRYt1sghW4KltsPOTyBbMCwQ9on0wxAwoIrwRHk7uLZeIT7A8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUqShVcT98OVUK6rYoJNK+LFjKu+QlQjlCH0lSplcFO3sy3J7Y
	sZ0cNFfuUXeHvJ5EDkU8kM6L8CMO93kp2m6uuoWaU7ZqxnBcApkYUzPs95tHbUYbZ/4=
X-Gm-Gg: ASbGncsn2l/YkHYCl4eeqHBa5CW876iLlKEzvG6F+ClrX+EUMlQW9Rb8bO1imp3dIjL
	qtsHjhcNuGKMclJRyYXwZu4Yzay8/PxunOX1uTzueIN3GG96ZoOitJqk9kE4A04w0FZTqvOA0At
	QwnhOefEXakuHwXGqgBR4JsH8WW8F1Y30ovetZND7YvZ/xhS/rn5K+fK4bTsPFs9W6RA4wVdf0P
	KfwMCLTLWiJxR1hIwvJMiDj2AB5kk4GV1hYZpVWMzqXoo8mLLXO7icds7vJC03UEc3J31rdlGWO
	tyMxOWFbI0y/4iENWpzCqdbyfc3qahmfW1JsP57A0GaQPuROf7tUmHc6TQAnbC4EmZhi4Zw1ESv
	46M2LS1aGNJ+wogCHXs/u/ZPJ18+0sVvqSA9tRyoDIPnikk4F
X-Google-Smtp-Source: AGHT+IEYUcotTO5TgO24JWUwd3SKPuOolQ0D8zOlSlwd+Xf+cG7WUx6N9bQeElQ49aoJKpTxbYcbQg==
X-Received: by 2002:a05:6e02:1d83:b0:42f:8b46:bc5f with SMTP id e9e14a558f8ab-42f8b46bf0emr248026825ab.17.1760377163927;
        Mon, 13 Oct 2025 10:39:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-59c6a285c3fsm543481173.69.2025.10.13.10.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 10:39:23 -0700 (PDT)
Message-ID: <5ac45cbf-bdae-44da-a5fd-6b1ae8321d22@kernel.dk>
Date: Mon, 13 Oct 2025 11:39:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 0/1] io_uring: mixed submission queue entries sizes
To: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@meta.com>
Cc: Keith Busch <kbusch@kernel.org>,
 io-uring Mailing List <io-uring@vger.kernel.org>
References: <20251009143645.2659663-1-kbusch@meta.com>
 <CADUfDZoJkk6a6Kx4=MAnPbQHycA5AXe=MUrPkuWV8fmjb=H3HQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZoJkk6a6Kx4=MAnPbQHycA5AXe=MUrPkuWV8fmjb=H3HQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/25 2:44 PM, Caleb Sander Mateos wrote:
> FYI looks like you may have the wrong email address for the mailing
> list. Should be io-uring@ instead of io_uring@. CCing the correct
> address.

Indeed, Keith can you please resend? Nobody else can see these two
patchsets.

-- 
Jens Axboe


