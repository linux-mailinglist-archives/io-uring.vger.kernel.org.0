Return-Path: <io-uring+bounces-3854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 580199A6E34
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86F121C21AD3
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7901C3F09;
	Mon, 21 Oct 2024 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dSiUB+DW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FE0131182
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729524825; cv=none; b=CLWAj7oJULI7ES8MFZT+Am58PKPROcXjNsoYx0+PNhbbTaPHXtBIdZjDit3xBhfU5JNAprsdo1+kezuTQmNay5HUESWDGC382o+oGY+RB+ZMR+QVz6y0PBXrMb5th6JanQGXdY5+FRNLu1gRwGo56d2lg886CGYxKCVhdWxr0w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729524825; c=relaxed/simple;
	bh=ivqYELpgaDpw4njA2KZOsNMNucDaytmBPiP5ET+Pab0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rjguW7pssVlYRqGbCiY6zZkIzgm2LxDKhc07LwV8/aAu/W8QDDFIRBmP/dqrNB45eQ1ZGX1sye9oS8QYjYSVVoA61W6WqcGZ6ohiGMJADN2+X/LOXu8kn62omHH4088Y0PQE5W0tMY2A8bK3a2eFuzFsZ8XFkHc1FyAfzntd+Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dSiUB+DW; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83aba237c03so133871539f.3
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 08:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729524822; x=1730129622; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mpuQQDmnj494lLSCDDvemVcUQbjaRdq5xR7ItGLGrp8=;
        b=dSiUB+DWkdFQu6zGyyziQWgkhH4oSW+5ajaMA0Nnh+0ltJm6Jyt3w70ivH/+7lLufH
         CotnyRBM2OrFpAzWj7fm70p816Qe4cQLtlwP+NNqjd4kIZUWUzzsXBMUiXE1msfr/Gst
         jPfAWOfvbtmvTnTaUZQUK7LuOjxcoj78zzidKXR89fKP1C8sxARPbI6r1tAq0u2Pn6XR
         9sZiMebHI8DDgU3Rw3qYl9Gv51xoH+NWq/XmvmcOPrdkzSSLPfKm3gbGE4SXHX9QxOn6
         loxfAuPVvEEWSiq1pLxBkFbldr4RD+QxnGOpMckb8oPUQkQ/CgxS1J1jkvFycDfAm7ew
         DwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729524822; x=1730129622;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mpuQQDmnj494lLSCDDvemVcUQbjaRdq5xR7ItGLGrp8=;
        b=Bdp+nVPirMq+VbZNMBBS/M/G53lf8WIs6qr1RSsO8Vjy+pmRzSVGZ33vNlpy+GY7+2
         sOo3+5N9PCZyTcUfG04qgfnKMxnhXwoU9PJdYarohvtRN3I0sm3jgV89G6ef8a00MuAb
         SY0PtHVmzTHxUbTKkpditNpC0PTUIBeol+FofJfxLYQJkoHEMIBfKCpQFbDN/vIN7b9j
         o/7It3JxxNMfOFSx0rQrftZafX5whwOeCy3GCDbtWkEfYQ/2Lj8nw/rDPlBrMCj0TlIt
         mr6gIpnmrq33J1BgLmsYLIz0D+cpW+9uf9DOa38GYZUiTFVjQRC7aA+CLsiXrXPvJhqc
         dQhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNe+mfkJJyjrTVgCb+ZTi6qwmqCVL/+EwGmwHz1jpXzEgQp41gd1hWU9S5wtaNE3T5U0DAH21LPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrKwaU8mSD3V2cv4mwllfZnTRkpK/6fisxEDO0gmRyD00YCgt6
	hGpUTmprVxATTD0ua+zhkYHsgdgp46YPqK/t6rlzQqXK+joUPpPU75rBaoQ/wjfWErkOkWsLyUf
	M
X-Google-Smtp-Source: AGHT+IH6BUQrlfFVtmTg7Z5+pTFVrKO+hjGffseLxO0TBK4nbQnqZGSF7yr8BSZujI8V7KDqlhT3GQ==
X-Received: by 2002:a05:6602:6413:b0:83a:a8c6:21ad with SMTP id ca18e2360f4ac-83aba5e627fmr845386939f.7.1729524822275;
        Mon, 21 Oct 2024 08:33:42 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a631fd6sm1062120173.148.2024.10.21.08.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 08:33:41 -0700 (PDT)
Message-ID: <cddadf99-e8af-425c-a1b8-ee60fe5297e1@kernel.dk>
Date: Mon, 21 Oct 2024 09:33:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/15] io_uring/zcrx: add interface queue and refill
 queue
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-10-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241016185252.3746190-10-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/24 12:52 PM, David Wei wrote:
> From: David Wei <davidhwei@meta.com>
> 
> Add a new object called an interface queue (ifq) that represents a net
> rx queue that has been configured for zero copy. Each ifq is registered
> using a new registration opcode IORING_REGISTER_ZCRX_IFQ.
> 
> The refill queue is allocated by the kernel and mapped by userspace
> using a new offset IORING_OFF_RQ_RING, in a similar fashion to the main
> SQ/CQ. It is used by userspace to return buffers that it is done with,
> which will then be re-used by the netdev again.
> 
> The main CQ ring is used to notify userspace of received data by using
> the upper 16 bytes of a big CQE as a new struct io_uring_zcrx_cqe. Each
> entry contains the offset + len to the data.

Looks nicer now, I like the Kconfig symbol changes.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

