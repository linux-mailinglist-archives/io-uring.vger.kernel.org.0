Return-Path: <io-uring+bounces-7160-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7937EA6BD60
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 15:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC4543BBBA3
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 14:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FED154426;
	Fri, 21 Mar 2025 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YzT0V64D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07517150980
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 14:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742567998; cv=none; b=GRIP0JpeM5kSz9gUHhaAZT+WhmHNbTjqGolSCnnLS9aproO1Vz7a+9t1mXDiqmjXdKsHbCyY0RdAAdF8p2eTcJqkUxiMlzAyfGeDXRRBV+Q6lFbf7xfhTFChp4B9T/JV0BdU9OI942KuUbQuayiYhazFMZ606cDBFIY5Vgg03sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742567998; c=relaxed/simple;
	bh=f5ZiARBtg6Khrt/xHNtVEnR0m2gUMtZdOwHXq/EyoQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cQvlu4dv6sFxXOHjtcfExjAeGYY/K6FZxD94zrFoFJdhEuJC2Qgm8nSaeC63O5CCbGuFgbOysQM8NVW+wS7yNeNn0tQ3mq2nZGMN5iIDjyzjwTr3cW8yRNLmKMzE9k+AQNyfyUI58P2laAcGI1d+Moi9vvl67hQayD/F7nA3Yl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YzT0V64D; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac297cbe017so557003666b.0
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 07:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742567995; x=1743172795; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8BrNFFQWdq1/YTizuvrU/hgPeR+v6URDYzocDsaZu+Y=;
        b=YzT0V64Da80Pn9R3GQxiZSOM6sX8ixEf7CYvQrjOiZmYxjHO7Mx5GF01Niz1EvJJHH
         fLJCmAOrZU1E13jkQYCBRKDgJN/TJ3J0w77LhIQ0Pn+y0iayPpVG3FvPeOHsZLOoDZfF
         yviiWcB/4SJ0jee2quY2/2LhIWE0EVL+g8yAzGE7Idu22Kf2CRc8qDV6aV6h2n4UfD7G
         i/VfWgVtVJOHlLICemd6tBKhwkQnrQx0IptlLjUcg5H64LLVHPA0skuhWcBYO1izAlQU
         yr8KoEl2ooLHM/zvNmPjVh4JwArbteekhVT6SMHTYXdZst5UxbLzKnR75EpqHXtOcRnF
         ccDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742567995; x=1743172795;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8BrNFFQWdq1/YTizuvrU/hgPeR+v6URDYzocDsaZu+Y=;
        b=OFeQczFxLs8ppX6jFz1YY4Yupt6Z6v6o1hRpsuPUriBfhURjcT4f2axel0vfw9UwWz
         BgABPwF33oaIGqXOokELO0R3jOnlpun6x2U5iFbtGDxuqMf613XxJLQofPL0sDCNCc3Y
         PZ/bqjRCI55llIaKmmsan356MsbL2o0xH9AC5cD5gp3C8QI/LvHEWC78dF7qi5r+l4ys
         UHgRigIIL5Tj8fXf/B01UyxGfG93oLexVeLJij1d7QG3rVWGGCWkAAyewvJ8Oq3l3X7d
         6CeivuQR9O0H4f6XcAuccLY6Tcl3Ba/aKuMC5V7G+OF597xho/NCiFTWx7X7y2CrJbPF
         c3Ew==
X-Forwarded-Encrypted: i=1; AJvYcCVpFhOiYoUR9hoZF3xBk2UjRQTyt+5ewLxUstynWwbJ6yJXqCUm7GgjI6Gr5joO18xGOPM4fIzhug==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPNmKAGqFHZaC1aGZujm2xQr6JMsflHQNtYv+YEQykjJIX4mO5
	/T2wwD5RhvbWGeIJENLLkdeCXoOpS8Hqysp3fzvt5r1yWEd7B39W2H470g==
X-Gm-Gg: ASbGnctm1qWswYbyv71rYeacg30DYIZWXB1wCtHmFtcKUpEIp8DkP9/FIITRMLcxMy5
	HOTwCeFzaxa+Hy5gDK4ap2mAuwUV8GBN6OXKVhcBOMv80ZxMDeoiL96nInE5UG9/MvLJI+i+kQs
	QVSbfZ21piUF+hmveUMpo0xz+hZP4oXG37rrIwiIl2sNT6Bor9+3G8n8Gy44NKnFFmt4VHcjrnX
	zMJQc3FeT6Gi3Vrs+qMc8i304klft0qphoCybqqlU9W2uxuzP7CQ9H8z5bwOo8jZUjT5yNCteGd
	CmxHsW/0nzf0eliodxeHcar3wGlvvOxzfbWLrpOVmAc5EV5AZDRCnA==
X-Google-Smtp-Source: AGHT+IEnJZFqfDEPkd4A93LYv/G5vx7gnmwSZiFBPW9wLlXd8jClfCd2fY3Oi8/O+q9K8gY6whGcjQ==
X-Received: by 2002:a17:907:d84d:b0:ac3:4228:6e00 with SMTP id a640c23a62f3a-ac3f00b2ef4mr436397866b.6.1742567994969;
        Fri, 21 Mar 2025 07:39:54 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef8d3d38sm163532466b.39.2025.03.21.07.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 07:39:54 -0700 (PDT)
Message-ID: <e2a4e9ac-f823-4068-918f-e4ab1180b308@gmail.com>
Date: Fri, 21 Mar 2025 14:40:49 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug] kernel panic when running ublk selftest on next-20250321
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
References: <Z9140ceHEytSh-sz@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z9140ceHEytSh-sz@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/21/25 14:33, Ming Lei wrote:
> Hello,
> 
> When running ublk selftest on today's next tree, the following kernel
> panic is triggered immediately:

Jens already stumbled on that one, it's likely because the
cached structure is not zeroed on alloc. I believe the
troubled patch is removed from the tree for now.

-- 
Pavel Begunkov


