Return-Path: <io-uring+bounces-11152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CF8ECC8462
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 15:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DA338305EFCA
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 14:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 934EB34E26B;
	Wed, 17 Dec 2025 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Eckikt03"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4EC34405E
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765982193; cv=none; b=JUST8VECftvwJSQCNkd1sRpUQiRPr/dpwDejLVtmg886g00bYDXrGErJyHcaHWOVleYv0UywZF0RBF6PIwQtWmMdTpx4kSkYibzEILGTidQLTpjmy8vHPw1ABarD3W1q6giTyL0N7akrg1+4gisFF/E6B5ZbBbJGLXykFDybSto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765982193; c=relaxed/simple;
	bh=94ycW3lgyjdSORnztV6EHe59jRLi4KhAVL3am8BaQ+0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VPTsrhGabGL+5TT4RAFyDr5tppdaZxOsARQk1ivd1JrvPO6I2NI5yOH70F6kY/vE3vDP8WDHJ18xzrZm8igHMPgSA1qYX7MI6Nv5R0kNy5/R01gj5JJtNP83b6KrCSVMGsccimhgGXI347m3ty3ozxM3jjwOUXLYkOSC3a8zzHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Eckikt03; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-3ec47e4c20eso3715894fac.1
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 06:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765982181; x=1766586981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ld6T8UtWouDR3xKdn1TrtGxRAlGZmoqNloVepqhEues=;
        b=Eckikt03DpREGa7a2kyvI0Gr8Ynn1TZERqKAHFlkmDP3gRwvszuVwLoM2G2P+dae3G
         vCnnoUFwVmjp0fMEasy0JVdIxQ6IYlgBbvTgYlw2c8XtUdgH4cN4yzfghoGne4Yt5cHV
         Ev+n6ic9eIMRvNKcggHxXAZ0P97B+sE0NSPBhcl7q+1EvZfBAD5ANCkSbsQB9UdQ4afO
         7vuWLoJ6cHmFxW6FRutyOUgXCFDoyq6D+aAfb+kGklk/2KM4UfAxtWk9s3mxMz8XhzcM
         XytPgySzVzFaQ1Sn84nXs5BV/MZGZtdN1QUUqSA7fwjrXMYxVCqVzoVcenCq8f83+atB
         Ty9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765982181; x=1766586981;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ld6T8UtWouDR3xKdn1TrtGxRAlGZmoqNloVepqhEues=;
        b=ZGQKz1Q+uD95Vg7w85msxc61/b+mKJXhzkXVVKLSmuEZgl53k3UphmtR57tWvwT96m
         yxYn/6kNZQTfNt60/2s8nY2rT1P61IuZVmb43XCccV0w0rhXA3UwW+Q2Zn+ulDuUd3tj
         a7+NReyGctDGtD6ipzb8Mn9WTP6LKGLd32GXjfdtWsi86RTtCaTtdk6NkyEe2OiYsrxR
         1tvIxFtezjiadU05zvQKdBWKQ3UPdmhn94ib6RInWzXkH0unUPSL9LL1rHvuwakJP2/4
         L+YFytX3Vx3OM59Iz/wowA06MfKbhLqLFdUFUxI5rSOoU4AKS/2VQBlVpWQQ+K5sJs/C
         /OsA==
X-Gm-Message-State: AOJu0YzQzwg8yQ99cRUtWq3A4E0B+F2h0FMju8ZD4wlB25+mp3GTt0qo
	oaWyXaR07e/b5AJSt7HSZEagHJrTb1Ky/x3B2Gozd3vkjyQctHdVN+Sx9b8FMOCD53o=
X-Gm-Gg: AY/fxX40QBd9vaH5o0S7k3nvsno0KkTAUuiFKPcp2Sei4E6Smnbf9ag4jZxkpVqfg4z
	q7DXBKj4It5DmIQWBYpfVWeh0J/jFmgKJMasw2jcsgNS/apoTtBQR6ajegzXoHBA3RdObl3IVHF
	5Lsby8z94tJEt8hFuS2PfvSrrCTzQwyOFDV+C4oNU3KIEWsJsjdOacQSrDhuvqpJJXQCo2qA759
	yALq+BHjHFKVpPb6sNFD4YikE1ah1+8lqLXIr+8VUil1uPYHOtViirjiw7bkZ6dT4m3eM98FZcG
	HC0vdBob7KMFbswnTFUEVED/OQgiWEJRBhRr1a7Hp2t74Z6s81XMzqm7n92SIiyY9GJkwgnVSk8
	iNZD1I8tcVOBNH1txp3MbpUenDnhDY7DUo9e+QBNiZ8MOz855WoVIBeeIsGMKsPHFHtucL0xjBH
	odOQM=
X-Google-Smtp-Source: AGHT+IFYryRICuUu40ewcf2L22LVn1aCV+6k+Edu2uvw+mN9u3Yo7M43WfwfxSDL8NCOVtBigpLq5g==
X-Received: by 2002:a05:6820:1b07:b0:659:9a49:901a with SMTP id 006d021491bc7-65b4529c619mr7323246eaf.71.1765982181125;
        Wed, 17 Dec 2025 06:36:21 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65b867ae255sm2141700eaf.1.2025.12.17.06.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:36:17 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: csander@purestorage.com, huang-jl <huang-jl@deepseek.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ming.lei@redhat.com
In-Reply-To: <20251217062632.113983-1-huang-jl@deepseek.com>
References: <CADUfDZo4Kbkodz3w-BRsSOEwTGeEQeb-yppmMNY5-ipG33B2qg@mail.gmail.com>
 <20251217062632.113983-1-huang-jl@deepseek.com>
Subject: Re: [PATCH v2] io_uring: fix nr_segs calculation in io_import_kbuf
Message-Id: <176598217718.7122.7321090942996172863.b4-ty@kernel.dk>
Date: Wed, 17 Dec 2025 07:36:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 17 Dec 2025 14:26:32 +0800, huang-jl wrote:
> io_import_kbuf() calculates nr_segs incorrectly when iov_offset is
> non-zero after iov_iter_advance(). It doesn't account for the partial
> consumption of the first bvec.
> 
> The problem comes when meet the following conditions:
> 1. Use UBLK_F_AUTO_BUF_REG feature of ublk.
> 2. The kernel will help to register the buffer, into the io uring.
> 3. Later, the ublk server try to send IO request using the registered
>    buffer in the io uring, to read/write to fuse-based filesystem, with
> O_DIRECT.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix nr_segs calculation in io_import_kbuf
      commit: 114ea9bbaf7681c4d363e13b7916e6fef6a4963a

Best regards,
-- 
Jens Axboe




