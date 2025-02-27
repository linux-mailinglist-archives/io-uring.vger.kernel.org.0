Return-Path: <io-uring+bounces-6839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C79FA48419
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 17:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EAC0173EF9
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 16:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7E81AE003;
	Thu, 27 Feb 2025 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3frpXic"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038101AF0C7;
	Thu, 27 Feb 2025 15:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740671618; cv=none; b=N0/MapiKtcE/4o1e0mnlJ6latMfpltwVh6xh8gkl8UoQ7RNV+EC5lbp/qmK9E5d8MwTPToYzjRSo+PMANZC1NPjUYlwSIHjB2Yy72TlUuoOaOkqmJdDb6ZJZZo4mHxnBKRoeCpOSS62pXgpGa8SICrK41V9nVFJEj1uNHog48dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740671618; c=relaxed/simple;
	bh=Fu2Wceg42d+ShiD4xmBolDi2TdENLbHfe1tPn5cZ5XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RpbeD9t1Q7Ekd0x9AOYKFLnTNBfHYjwVX1l6ag3dyl/7EnMZCvFb3RA7OQDZ40+rEEyoEOmmkojmlL5aM4oV8WsBVtDdvyRuMXRLGNkuz1vQL2uQ/56cTb7IW2IMzBCIMu5s/uWhtwwLBxQ0WUHG4ST3niFEA5/JGMqpMfabCk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3frpXic; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-abbb12bea54so199055066b.0;
        Thu, 27 Feb 2025 07:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740671615; x=1741276415; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hw6wJjdWo9Wiej484setvR6DkQWMZWwSNxLdWQ1MFf0=;
        b=b3frpXictZptL/7oxeySS/uLczQMy6X/s0sw3GIJJaI9iax8dNRlkdFnil6Ks/+u03
         +s78dX0XAgzsWLD1CUjvDkSYROj5UXMEReWfyK5wvw4A+Cr2wGnTIifYaDBaZGERxEVJ
         YwngJksyA/pzB2V1i5j8zpzigKUUdwFJA0haBLPhDJeOALEgNoD/89KKYPI3Shes4Q2s
         mk3sGvb4pGkUOdRisJQvWDcov8dn/q25+UDZ33myTw6x0tCe1K/1EgEexWRkRACNG1bX
         lXOCmJ16Rr2LSxI0j78bVodFxINx1cF8uwictzFYOgIRMg3VySZzdZTm23A7/wbRdLaz
         NFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740671615; x=1741276415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hw6wJjdWo9Wiej484setvR6DkQWMZWwSNxLdWQ1MFf0=;
        b=BxJ8ZSh+JJWIPI0GPQZb9hzB6aYqf0EjCFcT3EmY3aPG4vkiIS5HhRUcMtK6N0527G
         QzNC7+I0fzsBQvt8XvA95uzVTlj0trftqE18VNWqvb+vRRUPAliuRn5ZxOERylYFNbIa
         cv3FThM0351+uIKE8jF1M+Pq82pTkb2ikgjV+T5wk7MCa8LNIHUFPzB+KFjoOpiqavAB
         3LFGCAFBFl/0Evc1lkSXMzEvPiwigdsLF85dJWChCDRf9+eIT4ihLkmkWbJjWv9kNNVP
         jXYNRHIOLQr9yCcznNZnhH5Y3J01tnAHaCbUQbhVs5JSRB4x7WU/VWfZg1pAQb0YyMpC
         VoNA==
X-Forwarded-Encrypted: i=1; AJvYcCU35aLYStjP+RqBc3BiAIil2Pj0Zumw6YNkQaKIUSn0OfIexG/m3zPKl+zGwP9tV/DoiTPnJsqaZRfgxqA=@vger.kernel.org, AJvYcCX4hAvxAAXZ/DPaGbzHL0i1I3Eoz9FoeNKRh0D9/iwQnsZfpQc6AdGt4haVn8QOfjSF4rNfcCM2ww==@vger.kernel.org
X-Gm-Message-State: AOJu0YzE9KbslvbYOfbEbiOnR2WCcBsgafR+bfhP9/xo6rNOPL8AzsJK
	1JS4LI3j2la4j3YGBzlfFhL9WdKHKTdi8cJR0PPbMUDrGsOUUB49
X-Gm-Gg: ASbGncvmb53j35AvwXuanqHfQmiXxzEfULsxz/JoPKaAWzBfIalwQWL+3YKLve5D5G+
	UqteuPZaYtF+zfGZO5JVka7DgCZsOCau82mmMQcHdjfug4J5zfnXYj/msFhoyi1LSu+0G4vA0KB
	sMbYn4EMGn05+mLM/iMgwbn+/D1zn4DTwqHpsCXpTsJR37RucI+X3n1lEryk2FLImZ0gcQtu/uX
	0QII3IEbat9RikMUYjyKp/BEwBKkKVlQoKFNaJ90nnVkvUH71dK/Hp56Hxr64XJieEM62c1Ihab
	c3zSsc8E4uVb4mHpne/gn+uHG2R95AxGnUnGN7tPtkLixwR54uK34wPe3vw=
X-Google-Smtp-Source: AGHT+IF2NiaSjB15duG/MSduEve6ftOKjyFFg8HbNOjOGeFn8DcHTxCu0iO3xhPOLmOyRIiS0FP7Ug==
X-Received: by 2002:a17:907:2d25:b0:abb:b0c0:5b6b with SMTP id a640c23a62f3a-abed0c7a055mr1542926366b.7.1740671614964;
        Thu, 27 Feb 2025 07:53:34 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:4215])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c7c18a3sm139766066b.185.2025.02.27.07.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 07:53:34 -0800 (PST)
Message-ID: <844f45ac-e36e-4784-9f8d-528b022dff9c@gmail.com>
Date: Thu, 27 Feb 2025 15:54:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 2/6] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-3-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250226182102.2631321-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 18:20, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide an interface for the kernel to leverage the existing
> pre-registered buffers that io_uring provides. User space can reference
> these later to achieve zero-copy IO.
> 
> User space must register an empty fixed buffer table with io_uring in
> order for the kernel to make use of it.

Can you also fail rw.c:loop_rw_iter()? Something like:

loop_rw_iter() {
	if ((req->flags & REQ_F_BUF_NODE) &&
	    req->buf_node->buf->release)
		return -EFAULT;
}

-- 
Pavel Begunkov


