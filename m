Return-Path: <io-uring+bounces-1472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1CDB89D14B
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 05:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28DFE1C22135
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 03:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5908554F92;
	Tue,  9 Apr 2024 03:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zUaGi2n/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC23854BEF
	for <io-uring@vger.kernel.org>; Tue,  9 Apr 2024 03:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712634544; cv=none; b=R229qgNYrh/LeVOzeQ7Ldo+Eq1xuaNyr4ITXkAqTpzwr+jQLUCDkoi8eBEfA5BACRj56Df3ymTZmjK/gbnmYu+sokm8jiU7gzcZDv5W4335YyK39KfRSt9ggOZtXLDRIARm0uI5oQtlPTp3NE9R+e2L0K9Eai8T0l+GJTuUY3zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712634544; c=relaxed/simple;
	bh=EqQaCtHDk46Ojh7EFuizFWvFeb8ve3UR3qKO3EiUExE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=clwqJTQK8m4XFIWRHiUuCK8/B7Z/FNMj4pYCteoq4WVX8E9so6+Y/0aWgcBDlS5c12l1QbSZoyyMQx/MXXChGZkCiYXzTx1e97mlANmdQjsZ8j1Mnz7G1Sk3RMSOm623uaQT7ETMKyQk+HL1wCBaKAV/UtFoRkHhacp7G/KvHjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zUaGi2n/; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e21db621caso10341075ad.0
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 20:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712634541; x=1713239341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gAl++n6N2HtFgkjZAhMk3WzpQOXYsjLTDAlFhBUVsMU=;
        b=zUaGi2n/ANjS1yrSQ07tfxSoW/xEJBM8feO0H5jVHth6x6+xizNQTUskVjzDNcLj9s
         OfCLONug3TRGfHlxr2eoO4Fjnf0QCT8lC2RmNdAYwfYCTcw1mLQ/ZPe6qr1jrGbQlzLB
         6+YHdjcHNeQRIeqv73QfFLexwMnBJg5WrEV5i0q5e/L4Te94sAR9i5L1Bci5yG8KpH21
         86cKHR1H4DI+/xTmowrQbYru1d+9ogNTn5xMykL9aCKSieJIIRfelIsKtHC4p0x+m28I
         S4CYc4/iYIzgeNKyqcOasRLaa3Mf760aQ9ZIy+0wRIQ77NcWx+IrT2PSBSLqm6BdprGv
         105g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712634541; x=1713239341;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gAl++n6N2HtFgkjZAhMk3WzpQOXYsjLTDAlFhBUVsMU=;
        b=tU/6XIl5woBUx4S5gaHjUhW0nm2u42FpCKCx39S62gZ4PFrtZHJXssYGclIT82aAhv
         YedowKgQwMNq763RgCH20UNcr5sE6C3+K6ouJZ3DTEYTn5bVQG8hwNHebq9DDyazIKgs
         p0ul/Q5mnxDd66lYvQWPiuT7rhhHGe67yEfPDlMs9Lym7flIRm5Qfb01t+fvL+8r9q8b
         cMpyzLJ5hWdQEqF9P6sVmAk5aj08mI52xn3HKbiS7X6tIzAQntJXaYiXzZxVnmGAXCFE
         vbd8SFp4KHZ7Kcuf0auGGGmBcPsQOGTiCm7HLOMxo7vU/rVyFEkMYEZMIfERsoC+HKpc
         sP7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcw2LWleQxtUo2v/Ld16+3m/U+F3GnuilNTI/2F7k4fL7q5Z9UKmkUIByET0PLJLAWeSCiV4A+4xSn65bjOpKAhaBRgPQ/IIw=
X-Gm-Message-State: AOJu0YxKLlLulKT8rAbJ3ocGLlbOUcuzQpHZkaFmG7AYtpS/jr00JS4s
	ldAJV35/TY5FnyEuu13+cljQrIFRw4933kriL8T6tARPrwwMcWWApuEj+N3NVKY=
X-Google-Smtp-Source: AGHT+IEpV0/pbcKBt0htMqdize5cScpwpfG4gR4fl/MVFHoc+6W5bmLqIVShCUlFw+G/sgVtnvlohg==
X-Received: by 2002:a17:902:f685:b0:1e2:2ac1:aef0 with SMTP id l5-20020a170902f68500b001e22ac1aef0mr12766980plg.2.1712634540951;
        Mon, 08 Apr 2024 20:49:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902c40c00b001d8edfec673sm7809733plk.214.2024.04.08.20.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Apr 2024 20:48:58 -0700 (PDT)
Message-ID: <2220db1b-f0b3-4306-82b4-e06266af6a20@kernel.dk>
Date: Mon, 8 Apr 2024 21:48:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-6.9] io_uring/net: restore msg_control on sendzc retry
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cc1d5d9df0576fa66ddad4420d240a98a020b267.1712596179.git.asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cc1d5d9df0576fa66ddad4420d240a98a020b267.1712596179.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/8/24 11:11 AM, Pavel Begunkov wrote:
> cac9e4418f4cb ("io_uring/net: save msghdr->msg_control for retries")
> reinstatiates msg_control before every __sys_sendmsg_sock(), since the
> function can overwrite the value in msghdr. We need to do same for
> zerocopy sendmsg.

I added:

Fixes: 493108d95f146 ("io_uring/net: zerocopy sendmsg")

-- 
Jens Axboe



