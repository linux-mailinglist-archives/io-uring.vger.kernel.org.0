Return-Path: <io-uring+bounces-9071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE65B2C8BE
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 17:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A609B189EABB
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 15:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D09283FF9;
	Tue, 19 Aug 2025 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFxeBDue"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377DD26E707;
	Tue, 19 Aug 2025 15:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755618668; cv=none; b=Fh9MsmIq6gGCECBGcQ/3eaQdjwU9FwNBZD/9XbZ+MixB5vmwdLVKZQTFW+4BHyE0hJzeY/pG6sdff3YrE/nBWk5vLnHIID8kftC9EONrWovH5BH4mlm6afUBldAHn0URFWFzYzIU82vSY/8kZ/kLa9TFDoNkhDO18v7IwtXcmQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755618668; c=relaxed/simple;
	bh=a6ZGqGqQriw5wtcTQnJQ+E8H9T2G8nhUgo1qAhPQw6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LCpjpxuoBuNN+XazdxsMCrQvMR7RdUDWd83CIurHo7cee9VkMwXr2a4E1+ym3zQVZZe9NywPEdzHLGpMqSn9gvY8X3gDSF4JsPEcPK0gipTl4lWZUzRDUaFT0YdaHc3VZfkbGQom/Rjm10cWl9N5BI7c3b1oqb2sir5mPqEVa5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FFxeBDue; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b9edf0e4efso3692994f8f.2;
        Tue, 19 Aug 2025 08:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755618666; x=1756223466; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=As+W4X5MBTwXfXiBGJpiHyliRWQospCn+A6ubJW8Mxo=;
        b=FFxeBDueSuMEs4mytFc9DXiSgvyTu0KGuJnsRgLhHZlI2IYpLRnoiMJx8IQ1yznnji
         Wr1swvjj5A0vMylcoL53GQXFQ1HAHI3nWocr58L/IluYHWkSXfHxRoZ3OAbQ1tDO7otL
         p2WZeS1o7alpNK/3ornZCQW01GEThLdUj4ZBNb7PrSBCaRsBiV0FenLcfjdeX+/dGU4I
         Oq7dQKD1ficuPjde2Frc0QG7Cxlc5grwXy0YOT4Ay7elRELutR2A8sv923IfQSvXtybl
         +5zl8+Zkxhn6ERJEc3Cv6HrfcJNB+Dw77GPowq5+XxNFpNwer6R90smYY5EzvVC3uWcg
         2Cxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755618666; x=1756223466;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=As+W4X5MBTwXfXiBGJpiHyliRWQospCn+A6ubJW8Mxo=;
        b=n0qUhHKPHNF79v0Ijzi4+eYTRbmE+lDaroeTCOlKHrRG88h6yOWwgctg0kM/dN3Iwi
         UaB5Kj9mPoboZ2Kp2EsH1eAE78W98dOir47W90fFfqo8lF/0JNxU7/3Or1ZwW1U1u+9+
         +NCPyxPOzbX1yMr09syirSShYkQb7ctga0SM4HW4jOquM7RcJAGs8k8vQfMBPgYWTNrE
         ciRVJ/RsFo6MOsk/t084Hg29OVYI4CabMdS46WXbdQdCdaWBgBNdlBeuA+nqbDD9NdYI
         sp2SkDZjXdp19FnyHLyJfCldcmQbtO838ArhW+axv8KsY66fjlWoSf5AgNiXOdXlkE2Z
         l5tQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoXdQEjV+yN+oByangEJx8gF9qrI0vnvr8nEJuM+KBFqQLrwjSlrF+R+01KQTZes8JQKHF+Iuf@vger.kernel.org, AJvYcCX577BlDHnN/gUbSaWC3mJunIBV5Ugm9sX8Kd8SvUZ912nyTOTkhAi+zNm6q971Et0LbAFSpTwcnA==@vger.kernel.org, AJvYcCXzy6/SMFAZIMe0Dk1Qkn0ti1g6OMxULUVFRdFvZvhGT0nwUYfDQY9i8tKAUGZaSyMOMpK00M3rte+fbkxf@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+hP+oangx+1svzCfdO3lzODz25Np7vq0GdbGUQHDYbhz681Y0
	+Qee5XbRXVL2S9vZPRYID5geBAXxjgNCZ1JYfwbp9LwDg5iXd1lpsk09
X-Gm-Gg: ASbGnctiToQVtJ2jKyzwkwGUSkINSynJx7maqFCT4wB+HkwArvTPKhocUm6VxePrOdI
	yxuwgLpgGsu+tT0nmqPGrQU7uOVPOu0kwk4e+bYZzyMdj7QN6eqTVsgpZ5cGjFdnttgvls5sL28
	Y3L3kudXTUeA4nzjCkujwRtKSa4KIeKoJycepqVxIlO1itvcVDnX69+zth/7GytKDrhhyZx2Hzy
	qd9LMblzYTIfMVkMgUKEbHRegP0FD8sTBlaWm6Z2DpVXMdvCABuuZHp5AM2exRLhyN/SNc7zklO
	PpN8OgeoV/TupwTjPfabp7lTjhuO71QU7vK3wZ6WU88ZwE7n/OBCGbryKQkcf/BmC5beygTZ5di
	zajN6OveFn9u39PS8e5zPlpzZqubAbA==
X-Google-Smtp-Source: AGHT+IFa2tWwTkP68HwXkeiF+gbI3rKcWiSfezlHfbTT5pMSW84KwuEvkwpHueKL3GIcKmlRBv5Gew==
X-Received: by 2002:a5d:64ef:0:b0:3b7:9c28:f846 with SMTP id ffacd0b85a97d-3c0ed1f3372mr2637658f8f.44.1755618665366;
        Tue, 19 Aug 2025 08:51:05 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077c5776fsm4132783f8f.61.2025.08.19.08.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 08:51:04 -0700 (PDT)
Message-ID: <ab60ab17-c398-492b-beb7-0635de4be8e6@gmail.com>
Date: Tue, 19 Aug 2025 16:52:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 04/23] net: use zero value to restore
 rx_buf_len to default
To: Mina Almasry <almasrymina@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>,
 Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <cover.1755499375.git.asml.silence@gmail.com>
 <d36305d654e82045aff0547cb94521211245ed2c.1755499376.git.asml.silence@gmail.com>
 <CAHS8izO_ivHDO_i9oxKZh672i6GSWeDOjB=wzGGa00HjA7Zt7Q@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izO_ivHDO_i9oxKZh672i6GSWeDOjB=wzGGa00HjA7Zt7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/19/25 01:07, Mina Almasry wrote:
> On Mon, Aug 18, 2025 at 6:56 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> From: Jakub Kicinski <kuba@kernel.org>
>>
>> Distinguish between rx_buf_len being driver default vs user config.
>> Use 0 as a special value meaning "unset" or "restore driver default".
>> This will be necessary later on to configure it per-queue, but
>> the ability to restore defaults may be useful in itself.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> I wonder if it should be extended to the other driver using
> rx_buf_len, hns3. For that, I think the default buf size would be
> HNS3_DEFAULT_RX_BUF_LEN.

I'd rather avoid growing the series even more, let's follow up on
that in a separate patch on top, that should be just fine. And
thanks for the review

> Other than that, seems fine to me,
> 
> Reviewed-by: Mina Almasry <almasrymina@google.com>

With the said above, do you want me to retain the review tag?

-- 
Pavel Begunkov


