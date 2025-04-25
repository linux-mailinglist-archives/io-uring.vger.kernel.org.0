Return-Path: <io-uring+bounces-7723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 815F6A9C809
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 13:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7DD61BC3397
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 11:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D667E21ABA4;
	Fri, 25 Apr 2025 11:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WfueG8L5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1C323F40F
	for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 11:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745581549; cv=none; b=JW3GNsIczGgcd5d9jPQRi6kWk64LVzoJrbRSg5TBVQL8pgcU9E265KI5ROXSWn0vyMI6hQ747Bv2S2qs3aFAKMsGYaVI2DDEW0hImV5Y7vGKRa31ZR0QH9fG9PR/sBum2jfvQkFRSoQgU3DUNEvSU1wyaYcIjqXiupE1htATpu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745581549; c=relaxed/simple;
	bh=6VkyXKXeJhG529YVCgOitZLGFUHhdoq47SN18V/vENM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nCodUtz8F8SOpzZt9hmvpcfp97z2mYBSddqrIiwGbjFfY7AdGsrLBnkciIXpDNEEA+HPnMUqAYLhcTeE7qAyVCu/cTWj9nOb86/5z8c2VG89ik6uLhinDZqyA2LsCepfkgm7NfQrVZobjWqPGSn1jClXM9ZbOLjjToZaVFJNly8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WfueG8L5; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9eb1eso1681a12.0
        for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 04:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745581546; x=1746186346; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hCePAq9q+LEkItPhO+xr6j/u2WwYKkwsx4oU9ouRbwk=;
        b=WfueG8L5l7crUjQ1DcTJaBGBJUsuHU72P9UJTltP+aTiFsR5YfyjM5Vg3yJeaJx2YP
         pFYyHIpx/qrueckVO9SJsGBOKooSiWQXDYMGZ4nIGQCYT2U67NnaORnuAlxpdjQKdm9x
         LC4vs2m0AGhSccL+VBD0GobaZQtjHlDcXBLKpasjWS7ScCu0iGUtwFthpf2dlXB+vx63
         MMydkANFLFSz8sVA1HPk0pj7JKZN+WIKYxp7NPYfu87E/jLVMBk+omwRRA82WwgnBEKv
         w6v3FUw2bKCsAaQ3PXnlQgcC7YhHqj1kqIZRW0DjF8V/MVRyr/qGAjmyPSIR9RcvVy+u
         RTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745581546; x=1746186346;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hCePAq9q+LEkItPhO+xr6j/u2WwYKkwsx4oU9ouRbwk=;
        b=DjzqEO3R7uiYL8SLotxgzkNIxVyd0idDHtWBeZaBvrNzM1DxKmD8/9bVVqSac1SlQ+
         NWMBXGaKmtLIfoFQpv5HaeRPqdG6spgBgyAsrbKcoOf0OWeLQCFqrCpqdr2ta5v5aklk
         bkV5Ri40FrOjaJ4pwtoCCwIPCBD3D3TaDNhKlWr8EMhCyLfclFUAHlr9bCoZlassUpSw
         71YFexY+PQWlZO+LjgZc4y30Dq+sSZSwzupyE2j4arFNow4Gpolg6qJlInt0bvAu+VEQ
         dQZkFHeWaNLarCaH/1KEclPxvZvl1/rSBWxUejaJZ/XmXQL1iym3IJ2x48NUVVLZQw5s
         ChTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvFtPGoRRPo+fxsIiCbsIoHP04SX23CmO9xoLeSSLZJPuejRsSz29uR8uXwbGeaChwhJpTpzOd2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzId3Ipvc2Eh0K5cS61Llw8cGtsnzw72Rai7ppjtfOAM/PQvVNp
	25oTZpvZC632bdIX8rrtmm5BpwtJtOekhEHWqPQHW7an+prNMoCH
X-Gm-Gg: ASbGncu8G7C9kJbgJBrhfXvdLaqg9WRZRFdeqappmYsmNQtZJiZBSWB2GLpqLp0kvoI
	FHE+plK0nuSeMVSKTjuoHzAQWQMrQ7F2L0cSlwEga0NXD3RpdiIX2JlhVujt03ufZaTXAytK5Zi
	H69NUKS3XIO95GKnvM3xe9IfV2PdkVjGZIg9Z9KKHpnwbnqKO113kguUH1QFp3P6v4r3x7KQdVb
	QC6ncxqbXJLyu9tdqB8p47HTRCkNMPJt5UrhMZ0wpkDfSFbWiwE6SWfD9u3zC1qfD7IIfCkJjlI
	gqIhmN5vQmG/TkWNDlcmC2OQrD7+InFJ1s6PmCShgIJURlMfhx6e
X-Google-Smtp-Source: AGHT+IHkTv8Kt8zXt4iJahZ4yaJKMzOyXv+9msGhLwlW1MvfWicMWy+kbi8pdjjcjTyrzDWo9c5yGQ==
X-Received: by 2002:a05:6402:26c6:b0:5f4:35c7:ff37 with SMTP id 4fb4d7f45d1cf-5f7257976d4mr1710666a12.1.1745581545784;
        Fri, 25 Apr 2025 04:45:45 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::44? ([2620:10d:c092:600::1:9541])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7038323c1sm1140119a12.68.2025.04.25.04.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 04:45:45 -0700 (PDT)
Message-ID: <92a8fd11-ddd8-4ab3-a983-ff5c4cedefc2@gmail.com>
Date: Fri, 25 Apr 2025 12:47:00 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: update parameter name in io_pin_pages function
 declaration
To: leo.lilong@huaweicloud.com, axboe@kernel.dk
Cc: leo.lilong@huawei.com, yangerkun@huawei.com, io-uring@vger.kernel.org
References: <20250425113241.2017508-1-leo.lilong@huaweicloud.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250425113241.2017508-1-leo.lilong@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/25/25 12:32, leo.lilong@huaweicloud.com wrote:
> From: Long Li <leo.lilong@huawei.com>
> 
> Fix inconsistent first parameter name in io_pin_pages between declaration
> and implementation. Renamed `ubuf` to `uaddr` for better clarity.
> 
> Fixes: 1943f96b3816 ("io_uring: unify io_pin_pages()")

I'm split on whether such patches make sense, slightly leaning
that they don't, but regardless, why is it a fix and which
problem exactly does it "fix"?

> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>   io_uring/memmap.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/memmap.h b/io_uring/memmap.h
> index dad0aa5b1b45..b9415a766c26 100644
> --- a/io_uring/memmap.h
> +++ b/io_uring/memmap.h
> @@ -4,7 +4,7 @@
>   #define IORING_MAP_OFF_PARAM_REGION		0x20000000ULL
>   #define IORING_MAP_OFF_ZCRX_REGION		0x30000000ULL
>   
> -struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
> +struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages);
>   
>   #ifndef CONFIG_MMU
>   unsigned int io_uring_nommu_mmap_capabilities(struct file *file);

-- 
Pavel Begunkov


