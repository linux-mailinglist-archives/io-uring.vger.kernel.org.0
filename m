Return-Path: <io-uring+bounces-2795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29AD29550F1
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF2A21F215BB
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 18:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F531BE873;
	Fri, 16 Aug 2024 18:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1ZG/T8BJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B7B1BDABA
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 18:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723833329; cv=none; b=WqgARdAkhlpd0fvFF5kCOsisKqWQgiA8xIZgwpuM1PE1zO9Vw8JWK5u3PeH+ief/A87J+QBjrUvSkYrW49i3xT6uCofDZeMn+R/ra6ANR6gpfm9tvPDv+jCn/PhCrJFvzJF/Ba1qKdYHlE0DqG0C2LKbfi4MUNnN/Tz8jkG5yc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723833329; c=relaxed/simple;
	bh=MAkKrYXI8F7YqkSvDKsJySfTx3CPHe2RgR7hEQy6jE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iH0rWxfbXDfpi0BBF8cW792UT5E7dBAXWsvpWpJJhviHFPYfGvguR6Cfgwxcsc4/Bm2h6iwrrs0QALvYTkOpxmwYCM+Iw5zszZkUC3V2nq1ow0YBeXEGLqLfX+uQyxYnkowJn98ZwaUeDZa7Ep36quRU6gb4Xo0xLMhe5rmtduo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1ZG/T8BJ; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-39d2d4f487fso466225ab.1
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 11:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723833326; x=1724438126; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X7/m/VGtRW4LmqhXZu6fIcOaxCx94EyhRgV4S5KUp+Y=;
        b=1ZG/T8BJbnrEUh+E455cLx0YRDfVcCAEFd13R56eS8yZF5BYjD0JRKEudxJLraq5pn
         TzRtxjjWXG3Cc8zEteFemMMgyN+IwmJNsgL1X6JDyd3iiFPhhGsZ9yI8+9zIotMdjTOE
         uZHBUL+74SyBv5qwxja/NUvCTc4/EG3GLGrHfnYVaT0c/YjH1xJxNReOwOHc1gjrA0bN
         FHvt1oSy0CptpNaDUAPAO15yp007pt3E1kDxyE0oSq7qenNIowuxKoOClHKCYLV6fe5v
         4c0NQ5D+nySuDdMdkwG1b0nhlJzC3gBrJd+9xG+qLIR1J9eZVA4npzHqvuaHaHm525YM
         iNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723833326; x=1724438126;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X7/m/VGtRW4LmqhXZu6fIcOaxCx94EyhRgV4S5KUp+Y=;
        b=af5i8Ta5gghBWVOwzbgSl9lDOLmMDl8o5aLtAcfuWcQ15K5Y0slfTkbo3qAv9p1NFE
         VhHLD/rtxD37GTresva/Rnd1W2pLN2ZsdBqA205SFk/dBbS3akNfgIL5T1kB1FkISGIb
         93vdJdESdUvus5QHEI1GKCxo5EfKJDlITHYDfkjo0IV7p5V7kqRncLgxSWKi/jS+vHx/
         sSqBm7dhsoirQMuTBIkBSdXYSkW5e0lN1A0gQmKAyjH5PFvexRgwoEgqY/9+vbSgjzqP
         1S3O00MavNHmDsXX1YzGt2A7E3s5nQ8ffiMoOLzrE5mEizLmQIHE8ITKKhyCEdCVciO7
         A1Zg==
X-Forwarded-Encrypted: i=1; AJvYcCV7Mm/+BE7S9z5SdAO1sk7dZh7z4c48u7t0piDIBwigd725Dp+VyOsnd+gpJxnweUaq8hgsxb55ea5ughqkoHQ5flhYDbel+Sg=
X-Gm-Message-State: AOJu0YxC5Ib4OiQfHfHEeCxRQy3yrusaGtswHuSOLO195dLuYW+sk+xr
	NGKtBBoBpvsdJDt7VfzvmaVpHbRqt5HHhrLo9lx2GYIAGt7vGwTbrLs70gHInqE=
X-Google-Smtp-Source: AGHT+IGotBwIkStn+XvKgVStrtls/ZU0P6Fr0RzYZkoB6utH63jEJP2FGLyC5PfR4B2C9pfjWrPRjA==
X-Received: by 2002:a6b:7d05:0:b0:7f6:85d1:f81a with SMTP id ca18e2360f4ac-824f3c1df91mr251373439f.2.1723833326246;
        Fri, 16 Aug 2024 11:35:26 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-824e9b708basm137184439f.51.2024.08.16.11.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 11:35:25 -0700 (PDT)
Message-ID: <590fc500-345c-4204-87ff-65c646cef7c6@kernel.dk>
Date: Fri, 16 Aug 2024 12:35:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] io_uring: add IORING_ENTER_NO_IOWAIT flag
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240816180145.14561-1-dw@davidwei.uk>
 <20240816180145.14561-2-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240816180145.14561-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/24 12:01 PM, David Wei wrote:
> Add IORING_ENTER_NO_IOWAIT flag. If this is set then io_uring will not
> set current->in_iowait prior to waiting.

Ordering is a bit wrong here - with this patch, you can set
IORING_ENTER_NO_IOWAIT and it will appear to work (eg no -EINVAL
return), but it won't actually work.

I'd just squash patch 1 + 2, as just having patch 2 with the uapi hunk
be patch 1 leaves patch 2 as just adding it to the flags check.

And at that point you'd probably just want to fold in patch 3 as well,
not sure that makes sense as a separate patch.

-- 
Jens Axboe


