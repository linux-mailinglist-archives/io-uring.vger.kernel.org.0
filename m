Return-Path: <io-uring+bounces-4316-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84D279B963A
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB386B2255F
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB0713A3F3;
	Fri,  1 Nov 2024 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wEEh4l2y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739E41BD9DC
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730480737; cv=none; b=GbidxTkZ9VRheUvBZ2i7z4RP2md+Ahwi+4FYUArbJyBa6c92NTkZJkLvwUKZFn4VWjLDBPBdvqQUrimDG3clZGwzo8puJfZETfUA1YExVKDK7znC/DAhmNiRMBStTT/V6UcyTpF3jbcMd1Qy/mIxoWjUCsEhZ185jOIAYkK1U0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730480737; c=relaxed/simple;
	bh=5MhF83ZwmDeykwiUmDiXoDOvTxSlseeEZWvpoZUfQLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OQD1Nwq1KZrqAUFb6nE5MWiCAWLmjDQ2s1yHlVcrzKhdW0zxdB4Ye0SR0XUvK+2pn3xARQrhVRQATT6kzjXkuJGGGcYYErcgeNMq6M4mEbtlB93UPhEMuQKfMPUlW1wG0E0uReizK+FLUHvX0OxoqWKL+jaZmNAU/Q5fFzcmCNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wEEh4l2y; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-720d14c8dbfso778632b3a.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 10:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730480734; x=1731085534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qfYyy1SbPldcPSzTabocTJt4jPShqf+lAsxrzapGsfA=;
        b=wEEh4l2ydSuaN4XHTy0wPsfFE76RaqN5DlpLdpHPfxIv02EE6bN8qiaUH9fmvfDvIz
         keVg/VcouIIJPMZwOAG+CkAvbK+7MXE417RzVH8pyMtrKyZIyaIUib6oXEQNeLBV7uiV
         +W7UonwBa8ACTh0PqDgdsO3uarpy6QGTzJXG0Q5BDEfG+hvmdY0mHKMMgmXF/iCRaBAL
         fyLpiVZBH9vwqwP7eUUv3KsFm+EZ+WUad+pyfPmu01pQqyuSXzXZILkmLgUHyWQaQiwl
         Xu9JO2Efudlo0RDSGCGOspRXONzRNVaZK23p3nsQ8ME1ZfdBd4DqWvaz8HeTOP9HkHw7
         kYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730480734; x=1731085534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qfYyy1SbPldcPSzTabocTJt4jPShqf+lAsxrzapGsfA=;
        b=DGVRs/F0yy8dGm4kfviLjEHJZEa2R0XE2dzVxbhYlPXE8bXa+dIqMWYQo8AdDIW+LP
         JlgLvv24/0h1i0wxR4nJevOpviJ52Z93lT2tun2lsON2q3EkK99FJ/Wxailwg0RliOA9
         GDHEzv+QlfA/ybP6Vb7sLD7pomOmKTNwfm6Rno82IQz9mkIp9AIC38yoAnyaUomUazZv
         mfVtxuRxINPLx4KcOEL8Jb5VQauDrDEYmbdLdvcqBvGbuKSoXicxIqIuwHZfbvOoNniJ
         HwRIFZ03JVChn6qKhVjZ1aRkrU06RThm4DXcJghdRp7rAiASq4AtB+EwAZZyaauMtCVA
         nScA==
X-Forwarded-Encrypted: i=1; AJvYcCXMzf6HODPHykp3nWfIJM/ECuQTYeWWFcRw9kjrWLLoGGr1nMStUDzVVQnC9sk3XVPV15N97RAaPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxeBXw5urM6gKn9ffOuOXhaL5GlV27M3aATabeNI9fuW+mTi3iQ
	JpTvx53hj5xyqlRZYC+B63rND5NeOesieQ/l15PngEAdeCZQraiEbCCDd7N6stA=
X-Google-Smtp-Source: AGHT+IFEpSoLa4Lh5tuK3yFGnGdOon09ZNkzct8SP5ECXFTA2gPiypPv1QwGFI/VoOm+WHxHh5Kugg==
X-Received: by 2002:a05:6a20:ce44:b0:1d9:1cea:2e3d with SMTP id adf61e73a8af0-1db91e5f887mr9746082637.40.1730480733596;
        Fri, 01 Nov 2024 10:05:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc316a79sm2823926b3a.205.2024.11.01.10.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 10:05:32 -0700 (PDT)
Message-ID: <8ed55d21-f66b-48a7-ba94-64f6b834ba54@kernel.dk>
Date: Fri, 1 Nov 2024 11:05:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
 <f375e5d0-e870-47cd-b3c0-7a0a7ce99657@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f375e5d0-e870-47cd-b3c0-7a0a7ce99657@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/24 10:59 AM, Pavel Begunkov wrote:
> On 10/31/24 21:22, Jens Axboe wrote:
>> In hindsight everything is clearer, but it probably should've been known
>> that 8 bits of ->flags would run out sooner than later. Rather than
>> gobble up the last bit for a random use case, add a bit that controls
>> whether or not ->personality is used as a flags2 argument. If that is
>> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
>> which personality field to read.
>>
>> While this isn't the prettiest, it does allow extending with 15 extra
>> flags, and retains being able to use personality with any kind of
>> command. The exception is uring cmd, where personality2 will overlap
>> with the space set aside for SQE128. If they really need that, then that
>> would have to be done via a uring cmd flag.
> 
> Interesting, I was just experimenting using the personality bits for
> similar purposes I mentioned but in a different way, and I even thought
> if anything it could be used to extend sqe flags though I'm not a huge
> fan of that.

We're going to need more SQE flags at some point. At least with the
potential to extend it with a setup flag in the future, we can grab the
last one and have that other option down the line.

I don't mind grabbing personality. Obviously it'd be better to get free
space somewhere, but there's no free real estate...

-- 
Jens Axboe

