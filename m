Return-Path: <io-uring+bounces-7795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EEDFAA540D
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 20:47:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C85231741C1
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 18:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4013D21930B;
	Wed, 30 Apr 2025 18:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EAnOselr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EBD1CEACB
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746038814; cv=none; b=o7aV4yvmpqrsVSNoSuHNld86em723wUXU/jbgx02mT2G6mtGoH27IgfvM02nxnJXLSl0jyaj9eIaYmUFAi/g8nfQf5QG4zBILTwTFTmHLY/fnEDinV+0c8trzSXWV+lik3d+rGoLX/SoLimP5m/VHDdTqSRMyQZH0vlPK9Yyusc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746038814; c=relaxed/simple;
	bh=RvF1X27KOJYjwejPDZCh6K7rbDJ0POirQIB/j3wwUOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qX0GDW0vidLAHzpSrSWksWDmv7PRQmu2ziELDr2Zpo1a17JFsc9ylouWy3723w4BJhaTE5YS02Qs3CF2XR1qz32NIWVauaCxG/O82fWWTznrYpOqCu5K5d4E+zu/gxo9EHHQnQtZ5NED2t+PKqT1GNCQX18s5R9/eTbi7VV4nl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EAnOselr; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac7bd86f637so242537666b.1
        for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 11:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746038811; x=1746643611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TFgt/+IOftp6W7Vful+Y7kcOEFanRHBagi/KJfW/KTs=;
        b=EAnOselr2PEPjPRD14m96nQxOgf3GatM/BwDddvWV6UEeBV3OfgsGyXSI8aq3juUwT
         FDeCtYSB7sJhGIRfCx67JY7dgnMis0Eh1t0YcJbsi+Vo/QvpG4EeEU4ryZgRMtgE56+B
         3St37zbS3MrxgJxnNJs5jDTRpT7Og2N8pW2AUQpFW+5ZAvj/JIrOw24blSSDJcglcCss
         BGXS+zg6GZWabpmQ3ahr+tJt5ZWoc8GzEdEDzP/HUxq8gkDnZtkAYZdUcO0VGy8S0cSv
         oiErdOtzY4Zt9obiIvd1kMIjQyWiySn78pRhqiaUvokUtgOIZysfrbZLHtpZJUAkkqDx
         b8Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746038811; x=1746643611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TFgt/+IOftp6W7Vful+Y7kcOEFanRHBagi/KJfW/KTs=;
        b=WGyFDuKkRUgX9j8Kefkj2LOWTRE/NhXhUyOo38YYpGN6nzATqndGHcp2yycUSdvWeK
         UhXtIiJNSO5NhZtdjUR9WggDArx0aT5MM0KbBQCGKSXJMCbcQVryVV/CErwtG9omCEM8
         VKyss2OsCs08PvoBLFb4FxZ44KAf/HtD8B7d8PQRLj4IL23MO5Jd+MlPAQjNGeX2aHu9
         ian/Z/5V1cYliV6v1A4sXYsHRvyk9T44OwNybSrptmJFn4GiTY7Egb0lTiqQOSrbVuPF
         PjlE4Pvqfp+D/BXjMfDn9A8jrA8Q5m15XTvyHWXVK4W+wOh4EIU3LgBYM2N4xOzljt5z
         caig==
X-Forwarded-Encrypted: i=1; AJvYcCWgX1KRhPoTexnJgFfectQzudN7HOgLnZQ9rl/LTGzA14kGgUZ72STH1LlL3IVLvV3tYxDGiYKWCA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwxldyCEwFpWBkkmXPu0RMk5XjDjkjuzkAB6uMqnHDNIPuA3Ee
	VcfJtNb9ntQp9kjH00ikUSoLhbBxZzmU83NhIjdr+DxJ5N3fiLRQmPYw/A==
X-Gm-Gg: ASbGncuoQlL3/BeffjiWwPoYIwM3BoNusMf608vflFADDomHdVumv1cq8YjWZjjqf6i
	rE+TId0tCTyOcwjnPuGWz6eM4VjXMggZNX8Esmy75lG03OEN/sLSQYdFcHMM48STWTKZIg4lxs9
	5HOP56v5YUtkuUSpKT1QUW57SdfxVOK+fHY+CDb0h5znBkTDjpC0nxk4kup7mNaZ+V4cgQyhrYm
	nciv/IfyNyYNqWHnpUJ1eHrNJuxIJAEIsVPOfMkh2pVfTA91cAxhIJICDgLXtjZrQBCzYdurjxL
	pRziScAy4ugloDXtK6nCLBJEGNnCghs6qOsEkjLCrNS2G3b66OIQhJfwNl0E
X-Google-Smtp-Source: AGHT+IH8wVTib/pOYcL58ail77r4YneFWzSmrfzpTyRBOhdOb0cFw+U/gV/7eafmJu7AHqS48Ck3pw==
X-Received: by 2002:a17:906:6a26:b0:ac7:b231:9554 with SMTP id a640c23a62f3a-acef2762289mr64860366b.11.1746038810354;
        Wed, 30 Apr 2025 11:46:50 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.129.38])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6ecf7397sm974302366b.92.2025.04.30.11.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:46:49 -0700 (PDT)
Message-ID: <3738954c-d6fb-4071-be4c-0673f69863e3@gmail.com>
Date: Wed, 30 Apr 2025 19:47:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: A write to a TCP-stream overtook another write
To: Andreas Wagner <andreasw3756@gmail.com>, io-uring@vger.kernel.org
References: <edf639304e2401047a791b2de7254f7613a390a1.camel@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <edf639304e2401047a791b2de7254f7613a390a1.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 16:33, Andreas Wagner wrote:
> Dear everyone,
> 
> during development of an HTTP-server, I ran into a problem: A write to
> a TCP-stream overtook another write to the same stream.

Requests can be reordered in many ways, you can't submit two requests
to a tcp socket and expect that they'll get executed in order. It was
mentioned many times before, for example, look through this thread:

https://github.com/axboe/liburing/issues/1359

-- 
Pavel Begunkov


