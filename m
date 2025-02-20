Return-Path: <io-uring+bounces-6575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 295DCA3D6B8
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 11:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2561F188F720
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 10:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883AF1EE035;
	Thu, 20 Feb 2025 10:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDwpg5t/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1AD1F12F4;
	Thu, 20 Feb 2025 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740047459; cv=none; b=uWxay7+965bK3+n25IIc3wa608EXSAz+Yjs/FXFFzMk0f6wIuiRv2FysyKJwkm+yo+bntUp0cx6YH7WwcITFYmkebUi+Ow5KbHwpRC63aDIP8VIepHyKzykkx6BfjveTaRYbR2XFuag1Sdop/6Lan29MT6sEB94vtLsuB8clZgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740047459; c=relaxed/simple;
	bh=WlGLJx/F4/xE8Rk69HW7eiR89gjEJN8gQNcSUoQnxCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SyisKVNrEuc3iyS058SuE+IFiAzGRp193inNSPaxQZpPF83kNGz6lrYNsI3zAFLIJ6Xd9AAGv6IwbokPSckZVavAvNmo+kGfSvgkMnb/Xb2q5pPdX7pYle3xidBO0W4z4jdrJbJ80bf0zKTj6l1709mLGUDbARYcSWrW7wZMbuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDwpg5t/; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e04cb346eeso1163203a12.2;
        Thu, 20 Feb 2025 02:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740047456; x=1740652256; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8+axQrXfFcpFr6044wZgNyEBu9WmQwt2mJOEIdqukD4=;
        b=CDwpg5t/e+h5q+f3Oq5B1qy7Y8J6pPKqNos1A3oT3SiJXB9Wx1jC3Pgy5Q1T9WX0ff
         deldsG+E2c1amebhsS5qqynUnHL4N5MDESwWLbMC5j6QASCU5aYT/8IkntLj1qBbHdZM
         jCnl+GAev2m3CMBhjbHPEYkKF9JkrD0KIpOENKo2P3+bABo1HiMeJ65iLr6TCaEb3KLT
         6vt6j+zcj9c8u+PmgdLMB7aFrd7HLrqsklpB9IHhDnz7e6tNearC+MgixCbKOcBKtpni
         t+CnUUf/P8r8a2TroW9nIEzjc4vqODnrNw0V9cK/qW5KyQOQkQMvAGnVOk9Jq0OMNl/T
         mJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740047456; x=1740652256;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8+axQrXfFcpFr6044wZgNyEBu9WmQwt2mJOEIdqukD4=;
        b=XakVLfY6dh5uGGZHuuLRlkpiG28wczf+Bkpqe8SPxE+JSdcX4qWjGD3e4bhWaOKbKf
         dDqIcL0LeB82+r+5wgX4oCRHgPxkItgvbE/LQgbU/J9mHrGkC+MUFB1tCPkR4Tb4SRiK
         z2oBM8NtWuPhdjco3Ha65y6u16G5GmoRzgfhhz6xvWG9GcyQWwJmNPyCCQ6eEdytNcMy
         jBX3RVbjjthKS+QaZ5CcpCnothQdTAzefsTPtxVNUlvnqyh39zg36IsHbmjk/R76zdkj
         XwqZWo0gactHYibA/kariviri/K4sOOVXeMpb8eILc1GofzPKldFgrS9QFfuFijSz4No
         Jk4g==
X-Forwarded-Encrypted: i=1; AJvYcCUu2XtTCCcD3r8jCF+Ro0VzDezJR1cjKAUG3TxiHIkygpgtmYY7ObUerVe0VFhDfFmHN5sbZ4qyhxy6J9w=@vger.kernel.org, AJvYcCXqEFox9rNnRcjtBpL1/o8t5VeHNaL3HQPKbL7oH2OAh0PH82OHRrPcjY+zBjnjo4iGRFCuFL2ZoA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNh+jmap+S5xpzM8yzRyl9ks1HWA8uDWACAgdaW7hazxENUD+l
	1j0nB9vKKpxnfka9K/H2CfazxfxenrPU7358C4VgemdmvMSaLfxm
X-Gm-Gg: ASbGnctn8/NwSLEcda/UJBsprQ28ZSScgoH0fi29/xeNzlEm5azzIKkIlwWp+UbJ1wY
	TEaYbYj5rtHcD9RLXLKt8AyTi6tIVT2dLWt0h0QGRlnKQzaQa/gVx1px7jHJp470qczPjwE0rfN
	9cTawD0zkapG8r00+IZ7/qeT65XaG4W+sEitqSASf6r46AK3n/6qRAoCnfO/uqWZUGM3wZ+XGD7
	eqH15WxUUv9jfPfc2rvvvMj9oCruAnoO2ZUURMRGj0uQ0EFzioytEQC8speWc64VlS+VWBV4ZPO
	MBG35auv5r5RXH0IGAxsC/2w8tGhSz3jfXcvuovZXIiFwq1o
X-Google-Smtp-Source: AGHT+IHTYXNTDRT/Lf98GZDBXaq5hcFDBJPGm/99DFmiD446kEK+zY3EItEd1zqUakSPscAll9Fmmw==
X-Received: by 2002:a05:6402:2791:b0:5de:5865:4994 with SMTP id 4fb4d7f45d1cf-5e0a4af7468mr1793517a12.8.1740047455466;
        Thu, 20 Feb 2025 02:30:55 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:f455])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e07f390626sm3724324a12.30.2025.02.20.02.30.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 02:30:53 -0800 (PST)
Message-ID: <bcf018f8-78eb-4060-b8f9-532aec4d66c7@gmail.com>
Date: Thu, 20 Feb 2025 10:31:55 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 2/5] io_uring: add support for kernel registered bvecs
To: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, axboe@kernel.dk, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, bernd@bsbernd.com, Keith Busch <kbusch@kernel.org>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-3-kbusch@meta.com>
 <CADUfDZr=8VPEtftPtqaQdr5hjsM4w_iADEAL6Xp06kk42nZfVg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZr=8VPEtftPtqaQdr5hjsM4w_iADEAL6Xp06kk42nZfVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/19/25 01:54, Caleb Sander Mateos wrote:
> On Tue, Feb 18, 2025 at 2:42 PM Keith Busch <kbusch@meta.com> wrote:
...
>>   int io_import_fixed(int ddir, struct iov_iter *iter,
>>                             struct io_mapped_ubuf *imu,
>>                             u64 buf_addr, size_t len)
>> @@ -874,6 +963,9 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>>          /* not inside the mapped region */
>>          if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
>>                  return -EFAULT;
>> +       if ((ddir == READ && !imu->readable) ||
>> +           (ddir == WRITE && !imu->writeable))
>> +               return -EFAULT;
> 
> This could be made less branchy by storing a bitmask of allowed data
> transfer directions instead of 2 bool fields. Then this could just be:
> if (!(imu->ddirs >> ddir & 1)
>          return -EFAULT;

I'd prefer a direction mask indeed.

-- 
Pavel Begunkov


