Return-Path: <io-uring+bounces-7179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D559A6C37C
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF4B5179A76
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771A141C64;
	Fri, 21 Mar 2025 19:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ryJdaFhY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2951E9900
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 19:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742586310; cv=none; b=hGTpyosgSNxOH7wMvTKozk+tVFEgPqR3yf+YC1ac1Z074/ZwXkPMe5qRBTF1k/lbJ30qzCXkM1H8nR5a+0lMyTH1LG7trd0xe8yV15lBfsIqF8wQxA4xkYhfy8pwLCofqY9POvuvIEyKJ8KsNPVf38b+D2/Rban8LMPwYhjol4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742586310; c=relaxed/simple;
	bh=ndX07lz4IkKveSr7RfuKImrebJfWogdyg7EuqeJfHqc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gbVPrHa0NM7pGjNkWS/VCKgtIVQ/GtEEubpAl951A4HJIvFgfz73PhAgNdKsjeH/2Vtw75cLN2kWCn4kAvlp4DGwmmCZUnqg1Rbgnh8vTeBu6zyvsmY3canrJBjmBAm/oVRpB/dxee7Gw4eBVPrKsgovWgeFDITYMONvGXdehQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ryJdaFhY; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d58908c43fso6479695ab.0
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 12:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742586307; x=1743191107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M8rFcB1tetOVYCqLjoPUhUNBKHO//UCMTcdQrFd9Yu0=;
        b=ryJdaFhYyn6bspgz8P4hOSHb5hoGzSSjr6DGbEe96RI7Lp6+NcQSd8mQOlWHBeU5dV
         2JCDALoIT99yNWJi89X6tpKaBmkGy4NvRyvxe4n0F0yKVjd3fOEz12RmrABfQ2R/OCJ1
         rspO9iZoAd+SzYYCbpRXsPSsIQjc2LTMrxK3XTp/zY9Njy/w9uIc1lT2MAzg7wlcImGi
         L4rzFC1zuoOsU43IhEBa9An/V8d2HL5hx2Z8JOpq7UCsmJQn27Cl8/8JLcwHL55T6rSm
         qHEUYpOPsq/eumOyC2rMJvpvtRpDJu0XSReZmS+ZGSzgEZLwrNQp5kd7B/i/27mv7f0Q
         o76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742586307; x=1743191107;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8rFcB1tetOVYCqLjoPUhUNBKHO//UCMTcdQrFd9Yu0=;
        b=IOfIyFH0N3zugDb7Ny8vi6+GylqTkPsEMF19Jv1I2rpirr6qnDrL/K1wXulns3lhOF
         YE6PlI+LZlSIaJ7uBMkLjeyaoRb5BcrygqH+I4b++WyOyrCD0ZPYFBdl88uAXMluY6cC
         MWXPEC6lteWa3N82dK0TmGcvq60fiGMsnU+G1roCUMqxQgsGP5Ig0xEdqF+Yuhl2ncxH
         IVuRhIu+LQfMNg+SiRNf7swYz2pUK+vu+yZlSnfxCNPzgKz3UjnPMMIBD3u9J+4+BiQq
         ookNnP94RX83w9Wg1Q5by39i16+ybnrwFXdhcrzl/PkZdyMRxALVcLh414eZJY9oXhMP
         /jPg==
X-Gm-Message-State: AOJu0YxJGSNBUlrYsFAmCZKeKROW0kylbGa2hSzp+6IZHsMAXLMOx6LG
	xB4ZtZhE+o4naZmP5YWiOyp7uw/cgaFVCFJDi26fdB0meyIm6NhupSujO1cG7n9Ex+ZnBNjmHXx
	x
X-Gm-Gg: ASbGncs6OlP1qHi/2I1h2nHGGZJ7aW9QgOABUd0uQmvEhPYBn1lQDqa0fwsYKebVxog
	Z5+n3kgqCCJmpkp4W71H9NlkbM/NAj0Ekr7k4gKyBwJuB8eeIcZC5Xujf6OODdTktvVOlYzRaE7
	LSpGoLLexkyMW5sYckG4PZ1rLpqJDxJ5E93FbMP5u3gja4AA5aXJrq6zs3uHw9ETFvHFyM0dWF8
	G07Z+U4qw2x0weBVUvvDqJxhrYkp3rA4Ou+PiAMXesdsauzFpzJbnHnjBQiWQ+VayPHgo46mLAx
	T4vxPdOPEkyDDy47Gwv/HAFyjxhux0U8fSfY
X-Google-Smtp-Source: AGHT+IGC+1fXHsdoDEOBNEEO3KkHJ1Vs3PoueEm4usL5scTZjOZVCZ6RXn9Gf/eBAQjS7apcGatVQA==
X-Received: by 2002:a05:6e02:220e:b0:3d3:fdb8:1792 with SMTP id e9e14a558f8ab-3d59616b864mr44309075ab.14.1742586307171;
        Fri, 21 Mar 2025 12:45:07 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbeb3822sm580578173.123.2025.03.21.12.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 12:45:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1742579999.git.asml.silence@gmail.com>
References: <cover.1742579999.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/2] cmd infra for caching iovec/bvec
Message-Id: <174258630648.741349.13699528577407308677.b4-ty@kernel.dk>
Date: Fri, 21 Mar 2025 13:45:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 21 Mar 2025 18:04:32 +0000, Pavel Begunkov wrote:
> Add infrastructure that is going to be used by commands for importing
> vectored registered buffers. It can also be reused later for iovec
> caching.
> 
> v2: clear the vec on first ->async_data allocation
>     fix a memory leak
> 
> [...]

Applied, thanks!

[1/2] io_uring/cmd: add iovec cache for commands
      commit: 3a4689ac109f18f23ea0d0c1c79e055142796858
[2/2] io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
      commit: ef490275297267d9461733ecd9b02bd3b798b3a4

Best regards,
-- 
Jens Axboe




