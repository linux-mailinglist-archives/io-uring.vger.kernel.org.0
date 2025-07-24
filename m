Return-Path: <io-uring+bounces-8786-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFEAB10DFC
	for <lists+io-uring@lfdr.de>; Thu, 24 Jul 2025 16:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBA51179C5F
	for <lists+io-uring@lfdr.de>; Thu, 24 Jul 2025 14:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B5471FE455;
	Thu, 24 Jul 2025 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jcKW9405"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDAA1C5F23
	for <io-uring@vger.kernel.org>; Thu, 24 Jul 2025 14:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753368546; cv=none; b=fGl9D+5zBT2yjJ95gULAE5NlcECmzeoQOf0iCrpgVcCRgt1S2+yUrb6bntPzbr0bQXsDKvIjfP/mnXH6yCh3elu8Hcn7YcyywzH0rkGhAoCyll/qg1rXQFwIdN3eItnbGKYyu3fkjWDUl10F2pQoFmi4kadefk8fkz2r+pL8DQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753368546; c=relaxed/simple;
	bh=XtPaYn10BNsleUzP2QAy/hh18rXZPKq1F/5d1xCM8to=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RYmtHzp+1YMQTUaTnREEtYkuDQeXtOicb/rPGOoeqvjo1B7K0MupaTJYlwqw23a5/u6EjV+c41EEX6A0UTYD9Io2Qrtr6uiKvJ4hFe2/mQUKMC+H7/nXlc15jE1lNC2aZuGhngipSy2qmAMXhyP0kC5l2ZYiQIxyMeKVvrRHTgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jcKW9405; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-879c49e8ac3so67749939f.1
        for <io-uring@vger.kernel.org>; Thu, 24 Jul 2025 07:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753368541; x=1753973341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZTmXwk1ln2aXPH7A2yGIjn7/c0BIQF13mQsY+Oex6Mg=;
        b=jcKW9405flgmNcwPe0H+Ovh+ThdhR+TOw/MuGwGqQJFd7QG3iAYfVUukM84dBmfEMe
         3tHIxeD35bd6yofdVVPEq7e9qNKJctdGoU5RMW75JDjB+RK6Ii2zmN1/yN87wlC3ylJd
         Gy/qRJQtivAM6o5+M+WJLiT/W3Wr0r94D++HHBZSVZpPeelQ81FOEp9OAnYtF4H3DhIv
         e0cARnjnTCtMn3YAkD3Hua5CVFU2E759wZcnkEhtHH7DbEQWGqvK6FDuM9k2lzFvHYG2
         ouC7TwrCaN9lJqkTfjvCVTnUl9Q9w210UD+CzCQ0jigNLmBvHAjfoUERtnS1Lix7vQmT
         JswQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753368541; x=1753973341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTmXwk1ln2aXPH7A2yGIjn7/c0BIQF13mQsY+Oex6Mg=;
        b=nu5nsj0A3eKPq6c0pQIxEfIIAcDTU9a7ze5qF4j7vsEX6YHmZQjq3RCcBm7aD0TDrE
         MgcQp+zyjB65oWbnD18hESwJcAGoFehH5P2sCEni5eDJwxT1EgGCrF2M0h5/VO6ScKPp
         ZVju8t83gs4kjYmLgImCc2f5nGTTZ6SvuwWSo5qpWhT4k/9guw8yojCvU3VMNWFdqS4k
         cOsGbNMaD2l2fOHHY/b5xhnxWpmMSFfo+DewhYDFFbvRyLFV8BVkMPLcFIZe2jbsg5/E
         KlL8l/TM6e2wRISQ9AeuMyoDgfRGRHzTkbpcSAlTpHygqJN6/RszjD4OqhRXs3mpSKk4
         z0Yw==
X-Forwarded-Encrypted: i=1; AJvYcCV5UJ1CO9Vjq/96SBkBSXwTXa2srcKSuhedJcraAbkspMwzm4GDlQfn3qy+NbMwH2tqfy1c8195vg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFOVMcwvH8Eh1taMGmQBansx+WSCXwS3A7WbqqXCSx3mCx4r0f
	DG1g+DWNVbYaKIdDC4zsecIVo/7K81tlkM8cXmxC5xIg6aDvBGahoRn0DYiqSijL6kwBykg/yBb
	3ywDJ
X-Gm-Gg: ASbGncvOGRDHBeuby/tNCSYyU+Zn5M5Qcqtr/mYPvIkEx92GAT6Q9UB79h458SoRw46
	hboiyKvyB87MQxCT99zuAArdlPT8xJEghCTZjUDuigZ3uW9c101dmnMCJlcKLri1FnVhUa7fDeh
	1EsFQhJJuNqiZFRDimxknYPIBCc0tKiOb4NdXqqnk0Tqdwj8REIaXMvZM4G+NwW0cxO0KEHajsy
	r0ez91n6Z0guLAOCVRFNPmNhZcDxUynSxgyGn8p8trswssyFyO0Xq2ilObSLIWagWSsbhr1b/bQ
	MuMi7hj2XQiDP4EpUZtG9fOtfMAWM4qkhg1xofdQ7KZzenlBtoHhHT3wbwwcysGc3kdVhwBlQdU
	TSg1U/q9Cys7Azeb54A==
X-Google-Smtp-Source: AGHT+IEsVhZp6sfXvvbrk0+pk8CrKgMTF0rbWs/Xg6wu9OFOJYI9phVzzEeaauuezSbMk24eFI2wlA==
X-Received: by 2002:a6b:6113:0:b0:875:28e5:92e5 with SMTP id ca18e2360f4ac-87c6506dd59mr1083400639f.13.1753368541189;
        Thu, 24 Jul 2025 07:49:01 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87c743167d4sm47471639f.22.2025.07.24.07.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 07:49:00 -0700 (PDT)
Message-ID: <9d13f0b8-e224-40ed-acb3-0dcd50f94ddd@kernel.dk>
Date: Thu, 24 Jul 2025 08:49:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: Allow to do vectorized send
To: norman.maurer@googlemail.com, io-uring@vger.kernel.org
Cc: Norman Maurer <norman_maurer@apple.com>
References: <20250724051643.91922-1-norman_maurer@apple.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250724051643.91922-1-norman_maurer@apple.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/23/25 11:16 PM, norman.maurer@googlemail.com wrote:
> From: Norman Maurer <norman_maurer@apple.com>
> 
> At the moment you have to use sendmsg for vectorized send. While this
> works it's suboptimal as it also means you need to allocate a struct
> msghdr that needs to be kept alive until a submission happens. We can
> remove this limitation by just allowing to use send directly.

Looks pretty clean, just a few minor comments below. For the commit
message above, you should wrap it at ~72 chars.

> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index b8a0e70ee2fd..6957dc539d83 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -392,12 +392,16 @@ enum io_uring_op {
>   *				the starting buffer ID in cqe->flags as per
>   *				usual for provided buffer usage. The buffers
>   *				will be	contiguous from the starting buffer ID.
> + *
> + * IORING_SEND_VECTORIZED	If set, SEND[_ZC] will take a pointer to a io_vec
> + * 				to allow vectorized send operations.
>   */
>  #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
>  #define IORING_RECV_MULTISHOT		(1U << 1)
>  #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
>  #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
>  #define IORING_RECVSEND_BUNDLE		(1U << 4)
> +#define IORING_SEND_VECTORIZED		(1U << 5)

Do we want to support this on the recv side too? I guess that can be
added later and IORING_RECV_VECTORIZED can just be defined to
IORING_SEND_VECTORIZED in that case.

> diff --git a/io_uring/net.c b/io_uring/net.c
> index ba2d0abea349..d4a59f5461ed 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -420,6 +424,9 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	sr->flags = READ_ONCE(sqe->ioprio);
>  	if (sr->flags & ~SENDMSG_FLAGS)
>  		return -EINVAL;
> +        if (req->opcode != IORING_OP_SEND && req->opcode != IORING_OP_SEND_ZC && sr->flags & IORING_SEND_VECTORIZED)
> +                return -EINVAL;
> +

	if (req->opcode == IORING_OP_SENDMSG && sr->flags & IORING_SEND_VECTORIZED)
		return -EINVAL;

?

-- 
Jens Axboe

