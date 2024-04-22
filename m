Return-Path: <io-uring+bounces-1608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A04F88AD3BC
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 20:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB5991C20B58
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 18:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0F1154431;
	Mon, 22 Apr 2024 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DXPGKlr6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16CE13F015
	for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 18:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713809776; cv=none; b=HPwQNZZ0vW0WapdMFHiORcpg5nLsL8lYjz5FoXRUcR17FJVAXFAWDWBth3YB6hjSyurGUoxc+2o39D5g0QdC/NiuFDFmWwOtnYWKiRFJPoW+omJMl3A8B83iSKz7qZXPrJfh4aQsjNKDVVPi4FYhe7WDYLR4CeR0rfLA1Xhjb0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713809776; c=relaxed/simple;
	bh=B5CZ+oTZvPpnGx9k1dUn+OLWXo+guU/qjTe5CjADExA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FwVJgkXHhCYr+u4NJYL041DneVcHAMjVxuhRebNIZewmbTVewZgUqtvO+qPrT+tYolfj9C2zLqO9gFY8pI2kvNFd+ibQQyTXd5sgwjtq9XkQgVHIp4hf859GY3UIVm73BBqlBSdcgBG9Wa6NUz57VnlqHokr1+e1oEtFsTEkF54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DXPGKlr6; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7d6b362115eso35240139f.0
        for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 11:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713809774; x=1714414574; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JewW7W3HTo6e/LmWHxbYyvro6tSYTVzXWjpzdonwN24=;
        b=DXPGKlr6YdhkOUq1kQ3gNrJHTx0Y+VnjzQkzAz8/+6dSETh8Y9B3TtwEyuPJNwJJOP
         kFaHGrzNxH14AvigHeCmPShxuq/AwDt4/UwE1DR01exp9qRPRfpE/zlNQe+tlmqnphrx
         weKUeGypssFpKvaRO83E7gg/JUHXRXoCvMepif1PLkRHhOzMgNuiCp9+V/jm316j+BEa
         J5RDJjM/XHXzKdfrOUpZvmOYLTkV6jWxPA1VdOe7TCm4Vgnk3K4nNU46CKZ6hQyqQmlu
         6o1Lxt6vR+KLl7LyZR698GRjg1IO8gQYmWb0JPSiGTuhYr/WGdxc3gfPxw8EN+Syzljp
         9p+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713809774; x=1714414574;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JewW7W3HTo6e/LmWHxbYyvro6tSYTVzXWjpzdonwN24=;
        b=SJfdKDs7YO3iEdW6ldxKWNJRdPEGTdd/cF3HOTSZQUIRmAx9doolm1R6VxAeymV9g9
         cSkAROwIAnvOrPhkuxHlU6wKwSLOVJ+tJcHfaUhN8Fk65/GoTsVBnMd0xwc/Dv+4cyc5
         qK4vIbzSwP0Wry/+u3xMzJbmdosmHVBBmp6em45thrnVqkzFjWSCq6M33EqaR54xsHAf
         YRXGMmgk5/WOhdYNWLLqN4Du29SB8muJdd+vlZOMYLaawUBY4ccXlOx7r2Isn+Ue471y
         4eta8m8rqB0+/b1Sag+J2oICtNIGgycyHp9L9Ps7hUbi/x2fAWoxJmh9Aq6zwVAfIYTK
         Hvkw==
X-Forwarded-Encrypted: i=1; AJvYcCUsIXsNSU+QfeuCNa1tKMvt5v2j39WDDpT9buZ1gRrY3mH3uEyv6kdMgci0RYU3jIk3jzuWOkK7hz3CX6yESmsfaT57z8+kiDA=
X-Gm-Message-State: AOJu0YwFqSo7KHsPI9GPUwbCZu7U0Bfq4o1uvrKCu7BeGxviTPdAD9rV
	yGbju5GHkgknki42q25hvzitDT+ekf+96SJeBbS58NCv3RzQLOk/e4//kpX7TJg=
X-Google-Smtp-Source: AGHT+IEYClAeu3ei9D/fFRRhWuam87Jr9e0V4FfrCrQWW87IB3ZIJgWQU3fIECpXh27eQ1tSePlMRQ==
X-Received: by 2002:a6b:6805:0:b0:7da:7278:be09 with SMTP id d5-20020a6b6805000000b007da7278be09mr9573036ioc.2.1713809773585;
        Mon, 22 Apr 2024 11:16:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y8-20020a02c008000000b00482f496ade4sm3118588jai.83.2024.04.22.11.16.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Apr 2024 11:16:13 -0700 (PDT)
Message-ID: <89dac454-6521-4bd8-b8aa-ad329b887396@kernel.dk>
Date: Mon, 22 Apr 2024 12:16:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] io_uring: support user sqe ext flags
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Kevin Wolf <kwolf@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-3-ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240408010322.4104395-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/7/24 7:03 PM, Ming Lei wrote:
> sqe->flags is u8, and now we have used 7 bits, so take the last one for
> extending purpose.
> 
> If bit7(IOSQE_HAS_EXT_FLAGS_BIT) is 1, it means this sqe carries ext flags
> from the last byte(.ext_flags), or bit23~bit16 of sqe->uring_cmd_flags for
> IORING_OP_URING_CMD.
> 
> io_slot_flags() return value is converted to `ULL` because the affected bits
> are beyond 32bit now.

If we're extending flags, which is something we arguably need to do at
some point, I think we should have them be generic and not spread out.
If uring_cmd needs specific flags and don't have them, then we should
add it just for that.

-- 
Jens Axboe


