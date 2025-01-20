Return-Path: <io-uring+bounces-6027-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7CB0A17287
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 19:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 938023A5870
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 18:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40961EC016;
	Mon, 20 Jan 2025 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Br25QNwN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5B01EE010
	for <io-uring@vger.kernel.org>; Mon, 20 Jan 2025 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737396452; cv=none; b=fo8AsjR7I5urH6dsGVVcJNT95ZDq/p9EoSq59hWME3yuKNYMcpeB45exLZBU8dteHtt1CCCZV9CKHGpd660ZCUtVMlEzOfTRcNR1Um2I1sSE1kcb1IuOAzaTDlWPGJ6X/4Z/44VaF8mVlXb8zBaKeruimh65hvvxo3AoRr00plM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737396452; c=relaxed/simple;
	bh=8o1+gDmLzIoy9QcfJXrcR8i/C7txPinz6Gyifob8WPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iJnxMISksUl2Vp4i4PcZycrBC/wHIYAyKjY9BZ1p4huttSLbvKHqT++AQLzNzb7Gkn1g3AQTsKKpOf8DovyhMJIV2ntc3kJ9jHxQuGhuZAS11DYYu+YNA88KPTswf0G0Fi8PdhIf97jn85KZpucLEuU85INlUN8C3nF/npwxroc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Br25QNwN; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-844e7bc6d84so144084639f.0
        for <io-uring@vger.kernel.org>; Mon, 20 Jan 2025 10:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737396449; x=1738001249; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sUE5BSP8rOO/RztouXu4UPmBIQ8Lb41c+zpHn5kWrgI=;
        b=Br25QNwNYPlR4H1V7ulfZ+UzQNieuYxUxQ9ux+zBoFpH7o+nR5RzEo27CTlLXL2Nt8
         /5U5wf6JT9lqWih+4dGgoFgCbfSptPXsAmAXIpE21Zl74mcXa4kTQd4EU83TEtQIMSic
         /J5NVTmAOM4eWGs/3hkHgt2zUfwPRkAX2979hRFWzP28wrhleQucAxzjKwqzfeq6w8jH
         L2s95E5SpoX0V+L77SZirU+4eAO7yKNdQGy7uCVHqR8+QuP19lFXUSn/HjuQVV7Dxxoy
         DwYpR1z1Mq/NEv7Z2JpUyTyqGEUcQgU3duWnnF6ryUipqJpTkmLNSS8EfSYthu69OAEW
         1/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737396449; x=1738001249;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sUE5BSP8rOO/RztouXu4UPmBIQ8Lb41c+zpHn5kWrgI=;
        b=E3076q+h2uoxX+1W701hlnjR3ElDXF0FBBNiNY6TOY6eMAkG19zdr/eBeBabc7HvNi
         eu0nF74M392vuwrb10Ws3wo9CpkLsFoZFKY1LP6mlJ2aZxzT4x2TFHHh8g8NeAJER3CU
         ON2KZczd4EsfXNF5Vh/6UbHypQJkSRlYacOfKBn+QtNF4sRuWDffqfMVOn7Srmqlyk4C
         vojzABYj6RNfkrktEdm8Jn/wBYjxAqqthD7F57qVnM48n4iofOSMy6Ia3BRfOyzesR9a
         O3xJH8iw5Ph/Ltgdh+SKwPqKYpPXh4R/qhcVxM9s2VDttdZ+7hxYHdXl4FgmTEhwCbQw
         Sc9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgjhrXw+iGZDzYzh0uUahdhCRNbYazecSKNHxateEAk4Z1wClWZJaP5QwJgAduGjvwER8+gV9WaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMo/TqOQ9XIXsS1AVLHYbR3yY/kghQLT99o8xYii/maq71NpS3
	mA819fiGYtWO/YP5T2Z8HBUf2IFrJgS3EB6iMAZ7TR/gkTugPtL/TWCK11AnHhs=
X-Gm-Gg: ASbGnctDXW6v2pYACC27Gcox8pUli8ZsFDtooigRADaQelHZqCmX6Py/jfAEppthtGQ
	5KulMfg+wJdQ3XwPLhoj9eFc0eM7+FBlxTrrjSZIqXEFRZzMgR6bbd9clWqtHz2+UQvNT/+X3/s
	hVy8bmyqGw/XTu4YmermUjoMuiGDBeqy115u83CQQLyJKW4jqio9h+7kGuemyg+6b6r1mw2+JKg
	ZCWWc7OtMUVAyUtAFTuPlCjLPv2Ir/BV+iegO72465QOd+BAD/GRSiVKFGyyIrpKzQ=
X-Google-Smtp-Source: AGHT+IHuzO+olop4YQS4jYDZNrpRjwXCk320aAu90Szkp9KUnyMdxROxfVHGVXQCsgBMVDb/BtAMmA==
X-Received: by 2002:a05:6602:3b83:b0:841:ab27:acac with SMTP id ca18e2360f4ac-84f672d4e27mr1558590239f.2.1737396449475;
        Mon, 20 Jan 2025 10:07:29 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea756496fdsm2648910173.98.2025.01.20.10.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 10:07:28 -0800 (PST)
Message-ID: <424c0ea0-fa0b-4d67-91f9-1aaafeba381c@kernel.dk>
Date: Mon, 20 Jan 2025 11:07:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: change 'unsigned' to 'unsigned int'
To: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <o3qnrb2qffnsogqtswyd4nvkgcl4yhjbb57oiduzs7epileol5@narvnqug6uym>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <o3qnrb2qffnsogqtswyd4nvkgcl4yhjbb57oiduzs7epileol5@narvnqug6uym>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/20/25 10:52 AM, Ethan Carter Edwards wrote:
> Prefer 'unsigned int' to bare 'unsigned', as reported by checkpatch.pl:
> WARNING: Prefer 'unsigned int' to bare use of 'unsigned'.

Let's please not, it'll just be a backporting nightmare with absolutely
zero benefit.

-- 
Jens Axboe


