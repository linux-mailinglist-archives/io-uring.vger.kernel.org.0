Return-Path: <io-uring+bounces-6746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A759FA44224
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 15:15:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9746188BC73
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562C926A095;
	Tue, 25 Feb 2025 14:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMToON8a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA452686B3;
	Tue, 25 Feb 2025 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740492563; cv=none; b=gcMkOrxFSJ4DLXUmZfpvIkYJpn6WLuY73T0qZiSBgwGTOK3hhtg2syuL9dnXWzdUsYiwc+CwBK9NzPtZnCJbZ2fp5cNWw1XpvKAkzgoJFo/XTGoDE930S6teddS3VjwUySdcJmWhwnpnaV5SnwrRjdJVfPaHdQQKBUPtL2+PFT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740492563; c=relaxed/simple;
	bh=47S0pmJ7l7iwmR8sgPZy6GoALWuWVBThKlFsMRkuCHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7r/f3qac0f4ajjEl+NLrGlLIXBkabLYZiZGE4DI++q6Y9jPsp+zn22DnRTJuHqNd+1Y3EtEAulja3xQu6K6XF2o4iWTDj9oOfPenTvTdCFH5Xy5wHR891DvvMo6WS3hNgVcuKDrwB7Vq21ZLkqj1/Mldx+1cjh9oFnAqbFYu/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dMToON8a; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5debbced002so10182677a12.1;
        Tue, 25 Feb 2025 06:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740492560; x=1741097360; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FB3d9tybilnrfPXu/afq7QXhGY6VXByiwod+wHD3pyw=;
        b=dMToON8a7HhtMOQWnUadp7Y1/iruGSHRP17jnqOQorut08E68zuLlVLL+FSLrfAnRt
         ZwAlvkw0iuStBgPbWA4OgpicN+KJy/Tn52chlLVvvLiSssWgTspyRorbH8PpP8eFrWJg
         28YTDHCQHJhEFZqqVqWLCgHxzqnIMi2p+qXlbjLrnt22npnQ1fTBBXvF3Fsv4tvADOI/
         mlDECfY95nJbiqP9owrwPDB9JsCMK9Nbd6dHKWF9RIBQEcTefblMkAmPUEtg1K7pqUul
         3GXSEzBis/F1XSqDj/Et3hj07fUbeDUH+m6dVS/7AiYtfZtLhm7D1FZlsXsnP8TtFthi
         RbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740492560; x=1741097360;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FB3d9tybilnrfPXu/afq7QXhGY6VXByiwod+wHD3pyw=;
        b=b7rlIFUgQ5sRKcXxnjBtHHw1l/0hw28y26+YMXUlXdG7xftgNB2Yg5vSBZXZ0ZriZZ
         gQT0Qg+aBSvZ1bktkaK8xzs1U8rbBdOn/JNP2lGZvcJUFHBqf3C1AeJpNYIeRZoGinZy
         CraN4qfVJu0GYAkMiay9fjCw7YIsWU96jHGnnLJHDGdiL9TvI4xmqUWhU74pv9nyMjJo
         76E5OU7dr6Pv3enJ+8fwItihWyNF98GB8g5QktdJQKqBKIZH2qOknXT0aMAWihmTunr0
         /J1FQQtnqkYZsybxDQLOCufFEp3VqXjE71y1f2+J+ikA/iY1o+5KuxgCkhV37VcasCIJ
         f46Q==
X-Forwarded-Encrypted: i=1; AJvYcCXnXey8iVUcITKe2dkmM537ZJeZ8NlDOytUlwNeL8NvLflw+Fem/Idc36lHDbLb0+/SAx2GfAY6PwjPGRk=@vger.kernel.org, AJvYcCXqmrV2riPVotu3r1Y/J3jZV8KvsG/+cyLtF6ez2xXgaRPfWwzF+BaVb5vJmKoKAnY9VrdjKH5ygQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAIMpMH0GCCRP1p50HM70XzI6A/0BWsbRnIHQ6DG11eJsEyHI1
	bOUWDi1vLw2Use3hVbWbfFON5B+Tf09NfEtum2dqC6DFJFxIjwc5
X-Gm-Gg: ASbGnctYdNRnglUMEUujXPhVVA3aQYdllLrcpKfCKyYQ2TBAFf3DReEBRJNo9cviL64
	Yiyji1YsE4WjVjSz7CSHR3MPGVCaSIE/vJT1wruAp5QiBResvbdUL5zzEa3f9lDOf1YnXi7VAJb
	S58YhXuUj1RdRYZkbbZC3f1uR5nAyNSfd0jUXnAwjHXVvSYvP8b6BUlribo/P1PUAYoXOJdJP5Q
	zxIWYEq5PTruet9YUTaqNka2pC78//5CfRLbBFMDVHRaDC9QANg9x1zPV/UudeFei/AG216t8Y9
	A8V3SA3ycLy9H/zRkzFXk6ln/zIeprX3ss7j2RG78rl8UceU9xgePuArN3E=
X-Google-Smtp-Source: AGHT+IHIX+AvrYVeTb0BdPiHk6NLaPln1ybXHZHVcwHwuqRHXlbvqAwbdIVGY38LDT63U/vefGiDbA==
X-Received: by 2002:a05:6402:2683:b0:5d9:a5b:d84c with SMTP id 4fb4d7f45d1cf-5e0b62df50dmr18472340a12.3.1740492559835;
        Tue, 25 Feb 2025 06:09:19 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e46212761bsm1259793a12.80.2025.02.25.06.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 06:09:18 -0800 (PST)
Message-ID: <6354970e-bbd2-4435-945a-efd9e0f71eb4@gmail.com>
Date: Tue, 25 Feb 2025 14:10:18 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 00/11] ublk zero copy support
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224213116.3509093-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:31, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Changes from v4:

Should we pick the first 3 patches so that you don't have to carry
them around? Probably even [1-5] if we have the blessing from nvme
and Keith.

-- 
Pavel Begunkov


