Return-Path: <io-uring+bounces-6699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6136A42CE5
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 714EA189C2D9
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9DB2054E9;
	Mon, 24 Feb 2025 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lf4YjzaY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D171F3D45
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426189; cv=none; b=kTs+taf1zuzZBav7dVWO9/RVtbFzGeapQLJMqBXJUbj7P0dY64pVS+h1VsyRTj2Xehk5rLTkQiAUvPABYuEXgPKqrYIi2/3nBwkaNvnvOhg6XKBg+a8dTS5NYet58Qk+YoIr+cNdFf7qN8dq6nmnpnNG118DsBMFDZf9ZhLlkxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426189; c=relaxed/simple;
	bh=x/9cnjdW0EZpfv+CjzLgM6JPlNpQyby7679ihti7vTM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uiV3V6v/nnXcZDIUxLAghm0tVBUqCFK+YK//fXm+fw//dYouDvZtt3K4DfNaMj5Pc69lvx01PLBIjzh6N3Lw6RnrZcPPHZXI8TnLEtFTUB8OTjcmaBpPv9PrDyI4TppJ5k/4dKpTYjU2v9eXl4efOdrShmN5Cs0qWxLEXyr9nbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lf4YjzaY; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43994ef3872so29329955e9.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740426186; x=1741030986; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+N9qpz8bM1ZRH5zqc+f4OquHKYgMaspsBcc2CEBq2kE=;
        b=Lf4YjzaYEp+ErKgIQPyej6il661AbF9VWAmQgcM8VmGnMZThZ0YWvpgmQ9HDY4qkRl
         eUAIbIZS6xNxcBxCAT/+I4lzTh35QopvOq6BIKXwABkdyraSh6dR27NKhCFXELh93REF
         t5kGmao2ZBL2D7Y6yZlAWZ3+p9LH8/npZSBebykfwf8K3gqaI1ewZkF9nlCn9S002TGg
         Xmzfa+QtPS3bV4dykrKNaqgHJ6r41Abr+AuEy9BUwOtxSfRuHJeh7qPn1n3fNCfNBCky
         iwCYpVpKT4fCKd6nPV8ohizDSCRZy6uRz4HmBUmwOEbW3tixcgmu7JCbYSsGHz0gZ/2P
         g7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740426186; x=1741030986;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+N9qpz8bM1ZRH5zqc+f4OquHKYgMaspsBcc2CEBq2kE=;
        b=v6GiT8XyLZ8SPStG6Hp8Up7cv883Qvi2xfIc1zWTHPnmyfspaip3BdrHl5Dby+OA6B
         LJwc8gT+pSZKVx+auakLC1zLVo8g/sbyrxxeETlyZHNBYGuU/6MUhLhztv77akhcoPr8
         5Z93SDDomKriY5iV5UywRCq0yO73fZzMzvkH5eCnKrPufCAsNd8Bmn9oLrftjPFV7ELH
         IhEfu507D717OtoOXE7VMyhBf1YGXuNw1e4MTOGhyLqVgTjJKqhbxdFPPg4Li6WJ2PSk
         ++qbBYQVwAS9F2s2CTRScGtq2m5+tO03BCFgY4Yq4xpxngwu1ggAbTrssIgDfhTBurvK
         m/Fg==
X-Gm-Message-State: AOJu0Yzy6hnQ5GXdmF+YOchQvp9sG3SDbvbxf4xIrnnVp0lVZYqZUBOE
	fbAWA7u9hGZCvTgx9l/iCvM+gArCmjeI/Dpqu2WeHs0wjNeVjL2L
X-Gm-Gg: ASbGncvxlKxwfGRjz6cGKkwrWYk76JJgonSGT3HEQu51baZ8ABFN8ENyr9G4qJOeNAY
	RAQMYRZkLOax/IXOOxyVbi5BAak455EUCCX+s+QGM4hS3pD1UBU/fv4YA275WFIT7/VIYQnQ4aZ
	X0m+oFiFjaXPO+cOA24eBmVOo0ssKAapNv2te3nhDI5Kk14K795TfhOXrJikLgg+HVxRRREzspe
	0Rj9/HlVAHlrrvLp1nQQ8BgvIVZcXqN9aB9NFlR2rmfL2zgRz0R0icnvWp+qYIlNVyi1oKvGFjK
	6eIOZzVEfPGUfwya0ck4QxrpLZEX6vY7Zfs=
X-Google-Smtp-Source: AGHT+IFlALmBNDYn8eMtD2qAWsXvAuOxZn0u6H6cTR5en4qDQ5to6A2F7dy+HubeGzthcCh1TzLl2Q==
X-Received: by 2002:a05:600c:1989:b0:439:a6db:1824 with SMTP id 5b1f17b1804b1-43ab0f4271cmr6274795e9.16.1740426186150;
        Mon, 24 Feb 2025 11:43:06 -0800 (PST)
Received: from [192.168.8.100] ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab156a0f5sm934135e9.34.2025.02.24.11.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 11:43:05 -0800 (PST)
Message-ID: <9a67be7f-2a64-4890-8c63-7586ba1ce5b4@gmail.com>
Date: Mon, 24 Feb 2025 19:44:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] io_uring/rw: allocate async data in io_prep_rw()
From: Pavel Begunkov <asml.silence@gmail.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <cover.1740412523.git.asml.silence@gmail.com>
 <2bedcfe941cd2b594c4ee1658276f5c1b008feb8.1740412523.git.asml.silence@gmail.com>
 <CADUfDZp7SWy_pcL+GL9SbFY-qMaNV+gja+gRiY=XeefDoZjnDQ@mail.gmail.com>
 <c359d152-d541-4305-bc05-1259be924670@gmail.com>
Content-Language: en-US
In-Reply-To: <c359d152-d541-4305-bc05-1259be924670@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/24/25 19:21, Pavel Begunkov wrote:
> On 2/24/25 16:52, Caleb Sander Mateos wrote:
>> On Mon, Feb 24, 2025 at 8:07 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> io_prep_rw() relies on async_data being allocated in io_prep_rw_setup().
>>> Be a bit more explicit and move the allocation earlier into io_prep_rw()
>>> and don't hide it in a call chain.
>>
>> Hmm, where is async_data currently used in io_prep_rw()? I don't see
> 
> It calls io_prep_rw_pi(), which uses it inside, that's the "relies"
> part.
> 
>> any reference to async_data in io_prep_rw() until your patch 4,
>> "io_uring/rw: open code io_prep_rw_setup()". Would it make sense to
>> combine the 2 patches?
> 
> Sure, if it rebases cleanly.

It doesn't... I'd rather prefer to keep it as is then.

-- 
Pavel Begunkov


