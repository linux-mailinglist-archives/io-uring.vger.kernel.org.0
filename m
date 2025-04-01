Return-Path: <io-uring+bounces-7340-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A509A77BD1
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 15:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39EF616B363
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 13:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58A81F0982;
	Tue,  1 Apr 2025 13:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h5ugPYgr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30E01EEA3E
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 13:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743513188; cv=none; b=YGfiaITcAjORcdG8P+2yUvSWO7Nnl+AzyNoy9KUvJepk9ive5nqc9Lb0GDkj/+1382ql++i26YilVrIqfHx0bQf6edqX9I3t50gxB22u0tlcB1vfKWp5/WoX9pPSUMOpGIFjkMiBgCL+PBAib19S3IugFH8tMWzEfCunZsauo6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743513188; c=relaxed/simple;
	bh=Y17B0019XLV7AEbq7syUavp2Ljkx416PdM8lPWJcHOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Uxe86PZD77E5rriEFmjyr7oggoaVjCnl+AkCk0LCokDG8J8jakoGBEadwC7UlVtXFQzIrz4mkO0Umlh5l2M2PjlNgN87LfNwaXzT3E0MrpCDvFXLYgaHMTTia9elOlj3SYYDaIFRK2XdIH9F1Eb+qKU80IZ6VSsdxWgrsapYyNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h5ugPYgr; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85b40c7d608so485488239f.3
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 06:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743513184; x=1744117984; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dLVkSTEvuc5xjQBTF8WVqNAg0DDVts1ja1fSI1qTvZM=;
        b=h5ugPYgr0NOqYRSG4e7rz9wgj1V426oD0XabsPiEmmFc7zZqzBaCgCq6viJxf6WJWS
         l9Si0Ut9e0+bJH6ZMRmRKijAhjObz1fNkX73PB0zjB7iApmCGUytAcsBMoWVL27+VU5+
         ree10oNUiXOMjglSjo3YC5QOVPWJyQ62JJh565Tt5Kfd3LbQubcfPxdI0Xypm09mDJLs
         DSpfBrBhYrLFoQS3yVP6uq8o7fQu9NSRCO54oOZlenFXQrLvNIsmrs3W4j48mIgtCkfn
         hcoN5ffI42wBldXn0IUT6NpZV1hIPgWesMihcSsjCIeyLbGtWyJYahy8csj1WHTHSkFK
         SNyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743513184; x=1744117984;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dLVkSTEvuc5xjQBTF8WVqNAg0DDVts1ja1fSI1qTvZM=;
        b=waWJcAVOGV6uTDI0kqUIKjvH5DdYMYGsZy07pdg1PRjJYj8hsNO0svqTW1+F1Jg/1z
         Wm3ZF1YWF6IB4r29dVz7DA+YMyKE5SWVYDEgSL6CuorLN+5zgCdCRvIBhp086RLoIIKA
         EqDli+pFxJnCdEor12sbB0TUSkJO6ksXlaXkckCBl2MytXQv64wFzoa6jA4h738J8Jz2
         28Mbe5c/depArEiyEFvHwvRdZffSEhkP1xtuVyM1XRE/5qt+EhwR3LcqnJhc7UHMJUTM
         anKLheYRqfEEtPRTLhSUcpSQ4SLHR2cKO8auYnBhvNuvrvDB5h13MmlgpFLSXsS/6Y1W
         nr2g==
X-Forwarded-Encrypted: i=1; AJvYcCXq+MgOj3JVWAiiC3meZ989mxDUJGHBuJWJdlvUVxVdgoF9rW2uqLStzHK2zu6qh29BW//iiurnFw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvxSsm1Rq1u+6kXMvezh3ncXKoB4+bkFR7p8KmH2wnM2CL6DGi
	6Bsgu3NFwrCeOtT3LQRH+MTTMRhKRUR/aICFia9c/btirYmGgXTd2yrcjynnV70=
X-Gm-Gg: ASbGncuPntAl6M521ROQF1XilnFA1l/01bcXeoJY1L2J/kuPYe6GN/j9nt7NMeU1FvT
	rOVkALbBxgtu0dbagV/70F+BK41qVyDhkT7knp8nKEXdqDKXow1HqHZkyJQy+gXOgRshBJJlz1m
	idPvEKLI8ejzLhI2A7rWnS0X1ahOp8EYSLApI7It/LzClW8enwkXj5wZCy84Opr8TuWV2BwGsJq
	OfEv9ZZUjkXEDYclDsuG0X3zKKkuhmDhnY6g9oluwvhnHdrdStaUj7zEC9AS1ojz7ormnktm7fW
	WwAKGX7MV24kdUGUCimLoSW2fD7L+nSmxZOhvQCtlrlxLEbTlIiS
X-Google-Smtp-Source: AGHT+IG2Myb1j3bgYJCBjZwS8JpzBECAvjWKCz4PrTlCmzxFy48v9E6ItwzLtAYsuFCEKgHxXkPcmA==
X-Received: by 2002:a05:6602:4181:b0:85b:505a:7def with SMTP id ca18e2360f4ac-85e9e85c51amr1255843539f.6.1743513183562;
        Tue, 01 Apr 2025 06:13:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85e9027bd75sm214465939f.42.2025.04.01.06.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 06:13:02 -0700 (PDT)
Message-ID: <968861d1-23c0-40e6-9f7e-c306db54bb8d@kernel.dk>
Date: Tue, 1 Apr 2025 07:13:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/kbuf: remove last buf_index manipulation
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0c01d76ff12986c2f48614db8610caff8f78c869.1743500909.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0c01d76ff12986c2f48614db8610caff8f78c869.1743500909.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/25 5:15 AM, Pavel Begunkov wrote:
> It doesn't cause any problem, but there is one more place missed where
> we set req->buf_index back to bgid. Remove it.

Want me to just fold that in with the previous one, it's top of
tree anyway and part of the 6.16 series that I haven't even
pushed out yet?

-- 
Jens Axboe


