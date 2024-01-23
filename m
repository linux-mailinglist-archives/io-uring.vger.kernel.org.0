Return-Path: <io-uring+bounces-460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC2E08393CB
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 16:53:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84EC828C2EA
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 15:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58728604C8;
	Tue, 23 Jan 2024 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="heRgPpfj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A16604C1
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706025010; cv=none; b=hzfz/7hBmxjLmQw3FrT+nsuhFYbcaGgp43Kpntr2932fkAVshlvZIfN90jmee4Gn/n1WCsb/fECDvDoiGAaXe25J1fIm+QYSp6+nkvM4OdbS7xXg6RfhSzDvJAWk/bdZZeLO9jkRz2nohKzVRKYiquc9Z0S/LcmuYP2iRfN3cIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706025010; c=relaxed/simple;
	bh=KswaHIEMxdhYECtCi1AgcFpuxNXa2OchKSN/2CJn3IE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VhXlgk2+YEmtVW25M2988ZmVzWMHeYbYMPIiAHpfBnhwEp57AsV3gzw1/c29kLdLvtFdfcp14y4oEPWstvojKiljTWM/CMgn0S++9pCJwxfgbQS7HaW3Y4bD9zzy1q161eKhnb9Dlno8ZoS/4nc3xWdwqFofRYobdqsGYrYxzYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=heRgPpfj; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso54741139f.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 07:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706025007; x=1706629807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rMgLKcmlVoPO351CHbnBIfp34m0EAJmb7SGJrMZHn0w=;
        b=heRgPpfj6XLH0ffeCDvDqbWF/7lRQwd6zVZKD27OXyPoI6tabQLeSqZL4Xcp982VmA
         PuSFyFl+phWWSjad21fJUx7Jg8wUU+HSZ+UEqFB5dgbIfUWPyLycoj04sAmb/8HDY0VY
         LeqdCUP215PvKTRXCeON1MzkRWjqBpFyqv3wY8DMWBDI5sWS2mK28uWkiMnmJPtn/HAA
         uaNflp/DC+rojAavAoZqnPPkaY+MciLcQ5qSN3TtL0FLGGcIf0SmjPkc5oc/y0Yqkg9k
         pkwZ/E1VyQOtOUO4L/A3+4ktNXrFd3B/TnJggx218hvC72lVQvLNYh+EqUJNTNkTCUzW
         +mhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706025007; x=1706629807;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rMgLKcmlVoPO351CHbnBIfp34m0EAJmb7SGJrMZHn0w=;
        b=gWxEvTJ1s05XeQCJKncADgmqSGBiGNWNymyViCgHXaA+AlpSvIbnYyLeXIZfDWvxde
         bYQZPp27T9WpueTHDLSBQCo7uo8wfMRMcP+UxnzM/Z6Ba7n+kFWDNBw2YN5drlYCgXUt
         MN5Ul1FMExPZSItgpJB1FpVoS8uGKJWKAFudDVChsOhdoxcbAY3DjAyo94hEFt8jMgpn
         Y4wyfUOukGT+8iX/0oOGwDdnSSc2T783bNtdpxbrVrCjixST2ZwKnZ7OVzsdijft+v/v
         G1RQ9iGiipHn5Z3chfbs9s7vQnK9WVk3glW1Ae4u3oGUTwhwAjKWm3V9qJcHlHpiMeBT
         6khQ==
X-Gm-Message-State: AOJu0YzJmw+46P7jTzObZIL9TiESw0gkT+8PeUJuP1zkzjlZtTSq+Ej4
	SxLfrtHdZh2BFjv92/Uc61RNcoMaF/DQpn4/5qiafAD5jcJe7YzwSXiGvEfLvBe9il1Gyj6hJa2
	eF5Q=
X-Google-Smtp-Source: AGHT+IHDpG/ctkKmSFPSDqo9a7ucm9sCxBLAnz9aRADJ8WbaisQhezJHXff5ty8Nn5e0g5zRADd77w==
X-Received: by 2002:a05:6e02:1a8d:b0:35f:b9ea:16dd with SMTP id k13-20020a056e021a8d00b0035fb9ea16ddmr8160932ilv.0.1706025007530;
        Tue, 23 Jan 2024 07:50:07 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g15-20020a056e02130f00b00362918ec7cdsm151576ilr.61.2024.01.23.07.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 07:50:07 -0800 (PST)
Message-ID: <e61a3053-4f50-4cd6-a72a-6be45fd53683@kernel.dk>
Date: Tue, 23 Jan 2024 08:50:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring: add support for ftruncate
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: krisman@suse.de, leitao@debian.org, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
 <20240123113333.79503-1-tony.solomonik@gmail.com>
 <20240123113333.79503-2-tony.solomonik@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240123113333.79503-2-tony.solomonik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 4:33 AM, Tony Solomonik wrote:
> +int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
> +
> +	if (sqe->addr || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
> +		return -EINVAL;

Since you're not using len anymore, that should be included in these
checks, and addr3.

-- 
Jens Axboe


