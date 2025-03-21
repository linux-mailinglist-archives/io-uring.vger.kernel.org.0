Return-Path: <io-uring+bounces-7172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 155E8A6C30C
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6A6A7A7978
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62381DE3A7;
	Fri, 21 Mar 2025 19:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WGaFeGxC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7AD13C914
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 19:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742584410; cv=none; b=J2oAsF1Vhf5ssGBuUOki8O0NrEjOKw/aNNB6HTFT+JOHZlLxp59fFKZ9qrmj+TTDYLh/FonkzQNp262UVidF6r2j8oANxdUGZ7jcr4CMXRDgGZJuNp7FTA+spxrMXTDfp56Eb/Q2zUX/eS9/a4XPFJ4zP8fu82WY9o5TT1kfNYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742584410; c=relaxed/simple;
	bh=Hnq/W9TyPXNU3C9XoXIM2ZENp3XbjOClPI4nqd8dgCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=jZbqFNgbGsw+w+j3xTmB89BkLp3WWSxFk+80027/Qm0r3WvRMtlfeAXFc7yVN6SdwOkwhCjBe/7+RySlZi47Vy+tqm56qi8rmcDwpo7vivalPuaGmmW9OKvLVmYxmkrivebfiaXwd0UEQZbGxxOUxeLP6A8wNUZm93uM2Z+jLw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WGaFeGxC; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-85b4277d03fso87930339f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 12:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742584405; x=1743189205; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+z2jprTaHP0ZXqwHTDmpVKB+7Pb26sJjgu5u9wo5sCs=;
        b=WGaFeGxC+Nk3S49OK6XGI72Wbqb3Py0XV5frPEO6VqkVt95BN2nSZw1nkDYM+3tI0u
         SFASokvHlw1JTUWtGMH0MQTEgzwx8Pr0n2i4kiljesDxhqSvOqnLk6I5KlriIOt7dtLK
         w1oFC+4CwSREK5cZVvOoVG+6dgIfmDJWZxIso2IYe9LSjneyaicOoOkOZiG6UR1yPoc7
         euniQQGBWo04Ik0JA3KmWB8t69zhI4/0CBkSmU1StSrz8z6z0+XX9qJmz/PI8yGQCkBF
         X/BjL51ZDO72A5Yq+u0dc05EM5m9DClh2M0l9CuBS7wjngnk86/BEBICt5vBxCOaUVDY
         Lz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742584405; x=1743189205;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+z2jprTaHP0ZXqwHTDmpVKB+7Pb26sJjgu5u9wo5sCs=;
        b=fQQH4s4JccOTykDu9RxB3ud/Cf3KwS1FY5ZWQBvFRpXylmZIAQAHvovOW4GNAa58yA
         cpEkMHksGnrabp5e8UnVdEdVlqz/I+LSImI61aJNH5ykFP66G4X5LH05HYf8RMpR4A8l
         FVdKqBFCa3HJoBp/T9cVJCN1kWfh/5W/A6A8EFdo9s7h4mbrx4cpInIjo8bjmXIX1PZl
         18uR8+YCi5zgSV9bjDotql+zE9ooSnF910AwWLJEjeF1d3apehQrLcYJLN5RFAtZxLPA
         A/GZ/7N9Z8yEv2MGG9XO9xwo+w3INKpFMvBzx84T0GcvkXU49TjgxKuwpRCAauge3yaz
         vK0A==
X-Forwarded-Encrypted: i=1; AJvYcCUUR1eJ/Ebsud8KTs6roUE22TI/SYaozNtxL4qDFcIr9Z8NZDnrUfELOZ8BXwLtwVvFkxeGoGNkhA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyB8IvcH7hjvxfZ6fPgQi36ncVZlbKt/g6LGlUiF0U3bCjSYrMp
	7hLn5Q1Q0SBDIeQBgasWYU20tCCYg+Vo3wSXIH8rnLT2zx9lePHmDD1X8oRNnvg=
X-Gm-Gg: ASbGncusnsus5e0XgObHBb3dngiCE1TqlJ6HFScqpisUW885OydPt7u5j21Sa/nPNhh
	SvFD6KEGP1pL0ZgrkaCfB8UCFmcE23O9EcrsqftSx+JAOBcyC62ou6+kj5ZMn712EL/4gtWKIvU
	G1oW+4gNI5bL/d4idA9OAvYCi0sNMnXpNXru9VuiGl3bSDbVvMvhya18PEpvxBy0ZyV6h3B1QwC
	ZPvkYG0oU3u0nYLv0BLG0gEw1Cu7OIKwfGPOpyA2c/ZKhxTKZc6h733rbuNgFrXEM4PcBkyoOvu
	JgzDSXuRb1IZ6BKfsZoma7aLAyqb85FMReugN85N7ArPXIdRJFtP
X-Google-Smtp-Source: AGHT+IGvpKBZdpw2DkyV1upUUYtgCNRn57r4f4eNsxwDkc8mtppuGF/p65hobw1qv1jlYVsOtT+Cmw==
X-Received: by 2002:a05:6602:7206:b0:85b:3d1e:2e23 with SMTP id ca18e2360f4ac-85e2cb4116amr460178639f.12.1742584404787;
        Fri, 21 Mar 2025 12:13:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbeb5364sm556501173.128.2025.03.21.12.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 12:13:24 -0700 (PDT)
Message-ID: <0c6e6b27-05db-4709-be80-52d0f877d2ce@kernel.dk>
Date: Fri, 21 Mar 2025 13:13:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] cmd infra for caching iovec/bvec
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1742579999.git.asml.silence@gmail.com>
Content-Language: en-US
Cc: Ming Lei <ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1742579999.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/25 12:04 PM, Pavel Begunkov wrote:
> Add infrastructure that is going to be used by commands for importing
> vectored registered buffers. It can also be reused later for iovec
> caching.
> 
> v2: clear the vec on first ->async_data allocation
>     fix a memory leak
> 
> Pavel Begunkov (2):
>   io_uring/cmd: add iovec cache for commands
>   io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
> 
>  include/linux/io_uring/cmd.h | 13 ++++++++++++
>  io_uring/io_uring.c          |  5 +++--
>  io_uring/opdef.c             |  1 +
>  io_uring/uring_cmd.c         | 39 +++++++++++++++++++++++++++++++++++-
>  io_uring/uring_cmd.h         | 11 ++++++++++
>  5 files changed, 66 insertions(+), 3 deletions(-)

This version works for me - adding in Ming, so he can test and
verify as well.

-- 
Jens Axboe


