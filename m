Return-Path: <io-uring+bounces-7402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AA98A7C16D
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 18:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 589A4178EF2
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08C7145B0B;
	Fri,  4 Apr 2025 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cy6keKpD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDB93C38
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 16:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783628; cv=none; b=hKHXSxyl7PCkE1Nyr6BN36xXuX+w0IqLiIPx29EQdbgWDYZH4GKnEMJ/tqVaClddKaP1taXVHwxMaCwzKJII2refMjnSEs5W+HO6xeQWeEdea2gK5jM7yus5vEZzbJl0fn3QI3blXcRgishIPOD4dlFQ9H6LlX/MG0JG3uNRTf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783628; c=relaxed/simple;
	bh=af93rBw6lA79PnN1HOW7Tsi4f5L/UNQ8AgmBTpnb8Sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=FOueJYLquIpz9EIe3OaeRxXSRFcoxQgveKfA6Sh0iTybU0NWHGzuZMOfVVrZVXjxgbnblbsBhqXsSETt8HcHsc0n+zyxfyZrzFLl3NCR42HJ75pfWCYbo1OaE7lgys6VkWmyjH5eusj2cNxAEiVaNyQXsaOklCbMNkeJzm3S9tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cy6keKpD; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac29fd22163so377394266b.3
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 09:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743783625; x=1744388425; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jqo7YOfbojldabl54MXAbYmaCbEV6v4k897LWJJGDOE=;
        b=cy6keKpDSDDos9Wj9tA91xc0afKZSkEOHTmgvxtsQmZr3amBGwxSyTkE+V8J4PgPqb
         hcJnmA+8/Q4kLaVp6xAUZxQU5B6aKI/q13XndTT4GkI+CKtx8rpNkh6C6k2dTG6/7gAz
         +t9kfE19YkyE/AHNh4c06eutKJ+IUSz0/FlsLiYj7GD0+V/5TofjBIS3e4L+bewqrCub
         XTc5KULZuxja5YXyDJkBfxxcbp7WbbuvQL49TfHQ6WHH6H2jBSzD0giWra8EcA9Vlv0E
         6kIs/Nd8nZ6XrkJMempOoxBzQgWXVqtO6lIi74FkMTkztncxkYEUv1e82nbtr4m9qQxT
         XTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743783625; x=1744388425;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqo7YOfbojldabl54MXAbYmaCbEV6v4k897LWJJGDOE=;
        b=rF25qOMjOMSr/Z9JI7UvPKgwwM8Dg2+Lld6dO1gR2HgzKXI2WAtxZX8M1VzoZtBBMk
         yuwMkf3ySx5UY7logmzH9nkH2Rd9Daw0xSHB8AecaovbUVoZLZe0u+XdJ4jcReD0xfRZ
         +VDlWVHHGYn8fJ/r+tpmpG1szuCy+wU7Mw+I62PKOlpCA7TVGy7kz4bs3qVEGbFTosiN
         pdyUfClgJIune76I50PXCGNshc6BwHySuiO+Ej7zXosrmTRUPHA9fi6nJLUixQx/nMC1
         vdBDMpQFpSgG7kDQUYbi9H3f6EYTxoDuBOvjOLLeALXL8kiZsCH+SShpxdSTQ6rlz5+c
         Cb5Q==
X-Gm-Message-State: AOJu0Yze6JyUuB5pf4PDHRxFNxxSN1ZUf94WBanMxeSvGNpB6VECdTrw
	EGdYdqqerT2bnLZRS6iGP8xkL2MLoGtS8x/oQOzKoNJ/l9bjzEqphmXNzA==
X-Gm-Gg: ASbGncsY3s5HEEypUSTbQo38HuUUkR+I3t9PWEdIip/nOcDBFmYM6gy7vGqE8H3Ct9k
	x85dMT9CgRg0P3J6HgxfHpA2FSC7rTD57O9QW5ihdhs2qd+86GmUUJYYMM5iEj/NjGb0JOJ+lwS
	BxeQYA5ej3o+yvmXPx0Dw58RV5G77NC0Mc38yfj1gbadGgZMi3YygRi45BEoZ+NyysgELwokjmE
	GEQBtn5Xa5xjAuoetsXVuRuLzw652CoTHzszl93M609DgAvHQzaQ0d2guR9QBTKqEtQOt0hhMyu
	PAfn7QYHjsXpXli17nWBN9tZLo25AsHZUUeaN4AhsRmgWkF7awdGorJGn++haSvlZI0=
X-Google-Smtp-Source: AGHT+IG0CcdCdNrzIT42lQc63EwOpPI9nxqlktHV6ekqsI/mBxK8Qh8WCyKZxFO6KiSCGBJ9YJY67A==
X-Received: by 2002:a17:907:2d8f:b0:ac2:912d:5a80 with SMTP id a640c23a62f3a-ac7d6cbd75bmr311095566b.5.1743783625301;
        Fri, 04 Apr 2025 09:20:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::6c? ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c0185726sm277060066b.137.2025.04.04.09.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 09:20:24 -0700 (PDT)
Message-ID: <bd08d86d-da71-47ae-b6bf-fe8e0eb4b8cc@gmail.com>
Date: Fri, 4 Apr 2025 17:21:40 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] tests/rsrc_tags: partial registration
 failure tags
To: Pavel Begunkov <asml.silence@gmail.com>
References: <8791bcaf3c7d444724055a719c98903a83d7c731.1743782006.git.asml.silence@gmail.com>
Content-Language: en-US
Cc: io-uring <io-uring@vger.kernel.org>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8791bcaf3c7d444724055a719c98903a83d7c731.1743782006.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/25 17:18, Pavel Begunkov wrote:
> Make sure we don't post tags for a failed table registration.

Resent by mistake, please ignore

-- 
Pavel Begunkov


