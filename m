Return-Path: <io-uring+bounces-7584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B8ACA94A0D
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 02:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A9457A5514
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 00:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA8411713;
	Mon, 21 Apr 2025 00:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Utu5SeC1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8DCEAD7
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 00:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745195139; cv=none; b=qElI7NdMTmf3pxcejwleIpFDazhzENThNE0Vbzrv0u1dUi0uWj7dfirAB6iV6bhBTbJGFhqOmcx9dWAs6pEHQ6mB0C8sg9zz0fv6najoNafTIVzljfwaUpB7UVnoBKRLDKIg2gD5HKuvHbpi4LcBJYzZhM5+AG4e4vdd6AYtIuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745195139; c=relaxed/simple;
	bh=kE1HfR6vBwzsXJf2vyIBT2aUDP/BDoZmfmfMJO49TvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rXK++8U84xjHGBCo5Q1xmi7XqmW3l/Rxc/EiSCnL+LI+oXoKWu/EJxR7M4jPUhbuNC+uXQ5b1vNDK8ziVr9zu/KbWjnXhsEGD9xh+0+Bqkqxa/QI6VtzPuVH9hJ9MFlAPV2ccGWhMwEtNR1ZBfaDF8TLwXbM/FMD9GSZsjaIGIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Utu5SeC1; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-736bfa487c3so2974162b3a.1
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 17:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1745195137; x=1745799937; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IPU7zTm3LoOFF6EgGQaem1Xt5e7pKtD3hjilK3vQtQI=;
        b=Utu5SeC1SCKMXM56WubEHgI2nMPVcHsqIZRWN4EKoJEUh/oBOiEQsezpIdhK3jojss
         M0WpWi+ulbNkzGsMBpMOvIhZBZkKcUZ0njDeCR0xRaoPwuDJI4KJVuyK3mwU9jRvN95i
         VGhs3HpZSGWjbi+rDKMKh3QeRYvj84uSXHjxK7JlJwlLn3eaeFaAcskhKCZbUil7NYU8
         GRqAvUtb0R+6UL6wXU9v3isAtKYnKIk0re3roxa2Td0LPSqonvBbRhTl4rKHC2vruZXa
         XlS6AFUpxKoszn05KzDHoWLVCiN+JAMfmjGLMiPNofoQ/Fng/Tyu/l4Mlx1jGGnjMCfz
         DZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745195137; x=1745799937;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPU7zTm3LoOFF6EgGQaem1Xt5e7pKtD3hjilK3vQtQI=;
        b=r3SxdKJBzDqqkxHAoeiC/hql2AILjPIuIFUdkFB/uB2EuzXYd4t1pM9+Py8orI74nt
         UeWdB+7AJhqFWh4RvORaTYoEQZYNpLCczjN5SSWwbbsiuRamSkeW5hKFffyede4PE9gf
         se1CHupgaYMcQdAitEKkWZDm6d00lbwLyGIrKBSXFDna+qNd31GahtHKsRZv9SSzI6zn
         PDLa7VJtxnUIFYGF/bvJgk3iWzOuRI1YJBVFjH37E6/Kybm6100kvaeMfPKv7YXtFCyJ
         HhPf1qNVcJPG40I2EVV/9G7tBsknqNhWWR2o150qFvdQvN9cBlI7KlfXP+1cLEBCSlKw
         XPCw==
X-Forwarded-Encrypted: i=1; AJvYcCXypsLUUjL1YJgVZXbeYA7Qpc5g+lsk9aGjjKLOsCYps9k9RnQx6Gq8vClq5pnY1zqtItsT64P0zQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFfxokmB6KS+PhTUXi99VHpnvJivYZ0Fs1NHIooE794QXzbUvt
	sszGPKTePZWdSnIU++O3kTl6DT0Q8JiKhLfUa9rTk5LlE09FpUTB3qfH7w20cNg=
X-Gm-Gg: ASbGncuZRFR+g0ZELNpGqwu91VR4xUyrwfM9ZnnjKERLRTUX16nw3HZmjJW57y6facY
	/enMgnGyu3ocQVRyqUkgDyj8QtT9o9C8+L5MRSA+c6L/XFWkfuHfW+lsZbcos238S05quwvne2r
	kXg7bhW4acrFH8neFii/PIy7WjLFDRbcpFB6Tydsf1Tn3UUerkwUjwEjeuF1tuY5v1xY/xHWxtZ
	C2/nl9UmUKTX2AZNav5/4YPyAr+OrMiD2nQFG3cQqEbTN3/ZpCEZAIdF8ONUZ5fLgU7I0PUjJ2l
	/dCuofKJL7tdwanNqaoZ15x1g0OpA4Qh2/+8UOOmfFwN9i0=
X-Google-Smtp-Source: AGHT+IFh+HVBxvIwrMNNedlNn9bbmP7SCymTov4jJXFOVZ6jrPAGRNAZkl6iMXCwOKQ7BfQM3q+ncw==
X-Received: by 2002:a05:6a00:3a18:b0:736:62a8:e52d with SMTP id d2e1a72fcca58-73dc14c7d0dmr12380704b3a.12.1745195137293;
        Sun, 20 Apr 2025 17:25:37 -0700 (PDT)
Received: from [192.168.1.12] ([97.126.136.10])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b102701e679sm1406964a12.55.2025.04.20.17.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Apr 2025 17:25:37 -0700 (PDT)
Message-ID: <7b10527c-6e82-48f4-83a6-b8b5f8c615cc@davidwei.uk>
Date: Sun, 20 Apr 2025 17:25:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 2/3] examples/zcrx: constants for request types
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1745146129.git.asml.silence@gmail.com>
 <bd94694fe41c6be7275231d762adfb1a88dd0686.1745146129.git.asml.silence@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <bd94694fe41c6be7275231d762adfb1a88dd0686.1745146129.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-20 04:24, Pavel Begunkov wrote:
> Instead of hard coding user_data, name request types we need and use
> them.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  examples/zcrx.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Wei <dw@davidwei.uk>

