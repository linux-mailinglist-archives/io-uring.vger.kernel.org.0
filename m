Return-Path: <io-uring+bounces-10379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B01EC35C84
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 14:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 638E54E2C97
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 13:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622A9315764;
	Wed,  5 Nov 2025 13:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kcF+pOuo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5EE2BE05A
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 13:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762348483; cv=none; b=UisMPGQh92Llq6Pb8TOhwULjSf+tOYJEqUE/0J134jereznTydj55Z+aBOCCRBpXOdvn235xns1bK0KkiIzqGeiF1yU2tjsryd/J1T8RU8kaeYyrLdJgn9i/BNEeaWSlzE1k77y8otWmcBycY+uLlOxM0FPHhDyJgha5MkJ/BuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762348483; c=relaxed/simple;
	bh=CXJo9DykMmNNLnl+jjI9mmNo3zoi0NfJI4no0TteQy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Nomi/cLE605UHw5qtqaGYyosw3aJdUR2qXrDabRgnfUYVrkYCZnPvyCcPcgT0YwcMUqzfLfFII7Vj9hJWGJyDhAG9LYkt8Me0EIRwbARo9k6impEZJP+rShle6jcLvFPXqsxCvjFlyvzUIt/JlTREdzkJRfhuJRIsh1zPWo6O3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kcF+pOuo; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47112a73785so43500085e9.3
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 05:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762348480; x=1762953280; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3P5hXFAto1EcxknImPNnR6WarOHnxKs3TnLUf9duizg=;
        b=kcF+pOuoUWG67VAZpeuZMKCoCPzZs0LGRPZhHRx788eeeDUCmnk1ZpEqdLNKvmj/ek
         V2ssQPpgZN8D1T4fB6w3kDG4haUugvYKTQIixDlUjlJwDHWaNGZXbLuKxNIjaysSKs1c
         PxL3ihoxVfnUOa7chXJWN9WwCHI9KQpSAwpUesWWcwvK5hn5HPozPnENp9Au80fOIpug
         L5WPEph2ysv021nu+APcH3sS6loSZ5C/zrOzowXpeapxqGjnOXiNLFNyMsPGsiMFYhrd
         DZ2zR35ghDth4sDmkVOFmGv8HmpR9UPTI6c7Xojk2+gqc4Kn1XiWsVXZHh/8L0zWAUUo
         76RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762348480; x=1762953280;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3P5hXFAto1EcxknImPNnR6WarOHnxKs3TnLUf9duizg=;
        b=It2KLpasHo2NXkZeUOsvnh3YK5ubV1JogJBRZoluFUUJjfZ+lBpq463oZndFzEspT5
         eoq+qfq2b//QRAk7t9L1ctk26sqdlSzAQ83dnNLtGdv7cRHasSckMje6xg7dZVplOy8r
         aQflIXHhN2MiliXrlARvyRhY5qt64Mwc+/o1k7oVWvXYqVQViODUdszX5BStSBpiKdyV
         tsdFmPxpjjQzeeXN6u+SNzpU+JjxQsUfApS6EJkqwx22QqhWglleWcQnC43LTl7GO5kL
         8SGWWgiU4deKRchbd3uUyRGqP1yxfIWPBiMrJlcXHaNr9nTMNQFMMj2umA6eZr6v2gFl
         xgnw==
X-Forwarded-Encrypted: i=1; AJvYcCVZ3IR8opRHOWCCLK+HXC7EVevUa13tiIRfx+7a87icIkllfXP+gJ7F6zDarwkhlaMf5O5BhPIKMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMbyhsoqzYWoyCMWY3cRp02d1N0Pz+j2V+0VkFXY2n6Z9D179j
	DkccVSqLfhhNL57CZxwsIRV8g4ZbSxjvuGKfv+qIvo0mj9oebPRp39M1MfNutw==
X-Gm-Gg: ASbGnctJG96S5Gc8ard5aTl0yyceFb6Ekiuup5fJnelcoTVh78Az53EC0Zf69BxtGz8
	FNcCWIeONTsA37T0KaxD7GCJQGlRBpkDvvdQ2Imfe2EcTTIVLiEDTXydBODhgm110u69wHvBDjX
	/KfE42LpBGSzZNJn3jhL5VDltGwkeTnAjAAbP6IBG/5fAP/DbB5lbNxt/iEc8eioC/BMF21Zy5T
	VmLXU4V/Gs9HO2Gh52N4NyDBdpDcigBXhD5wa5Ezk24AuNufag5XPmFXF0gBHMjrkNCqQMXjoIS
	HfLakgCjErd9jFSLKQAlr1InlhyGkGeSBynjhCPmpaAAzqd3CikssNWSGJgPuNNJfmagF5+kwLH
	r/hIWvW5l0Tb2VKmO0MUbcztYK/PFqVrQz2OMgZrxKXpqM7qaaKKDbzDitfjoR41wj/r+sOQTLX
	l7IT3tWJnU2duFQbvSxOCcJ8SrxF5W5IuqcQMeehQw30ZjI1+2z1k4RDXzFOy5rg==
X-Google-Smtp-Source: AGHT+IFlWGanJtE6SVLZwGK2V7C5AHbsTw7ZYpUL+tX1B3QYiM/6+hGZSyCCYqvVkYUaZszsir416Q==
X-Received: by 2002:a05:600c:a0d:b0:477:1622:7f78 with SMTP id 5b1f17b1804b1-4775ce24859mr29335135e9.40.1762348479567;
        Wed, 05 Nov 2025 05:14:39 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477559305fesm41694845e9.13.2025.11.05.05.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 05:14:37 -0800 (PST)
Message-ID: <91a2627a-d9b0-4c5a-8bfa-53c812a515bd@gmail.com>
Date: Wed, 5 Nov 2025 13:14:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] io_uring/notif: move io_notif_flush() to net.c
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20251103184937.61634-1-axboe@kernel.dk>
 <20251103184937.61634-4-axboe@kernel.dk>
 <7d071bfc-02c1-49b9-9c47-83ec62031530@gmail.com>
 <61d52217-a737-4222-85da-6d2ae15faba9@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <61d52217-a737-4222-85da-6d2ae15faba9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 16:31, Jens Axboe wrote:
> On 11/4/25 6:05 AM, Pavel Begunkov wrote:
>> On 11/3/25 18:48, Jens Axboe wrote:
>>> It's specific to the networking side, move it in there.
>>
>> It's there because notif.[c,h] know about struct io_notif_data
>> internals and net.c in general shouldn't, otherwise it's not
>> any more net specific than anything else notification related.
> 
> I guess the notif stuff is all networking anyway, almost doesn't

Right, that's my point. And separation is not a bad thing
considering that net.c is a bit too fat.

> make sense to have it split out. But as long as we do, we can keep
> that stuff in there. I'll drop this one.
-- 
Pavel Begunkov


