Return-Path: <io-uring+bounces-8066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B281DABF81E
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 16:45:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 299B21BC1C49
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 14:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C875817C21B;
	Wed, 21 May 2025 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xf9KWzkM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82451D63C2
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747838734; cv=none; b=AIkUYEcLie+7aIIsSjNNkmfglTs6GFjuazn56sKiQbrL6mZxZDyVj8GTNOh5oGj79JlUyUWpoCNkunXIXIwPBYMVehgCAYZeqzZlxLy7dlqZWOBKsL48vFp9nTYfFTh114JKJcgLslxFmJOx2JaNKyvZlh805Qc9RXTfzf0nzSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747838734; c=relaxed/simple;
	bh=aL/7sQ/QJbReO3PjL4UtZRoZ8YAERXAj5Pu1G3nz/tk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s1Ka59exRY9jP8eK0aoOqSZ6N69r1DIBadMdsYbT91ypD+PsVuW4Tzi6SqF9HtaCSehbKU9OYiA+LUedgHCkhz3k0pwKwmN5PbjbbEkwgodaNt6H41qtyycqwDt+9jlovRwjMlM9KfY9rwOzWXbCVMeR6fe2qIfsfqgZH+6p8ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xf9KWzkM; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-601f1914993so5458499a12.0
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 07:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747838731; x=1748443531; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mWQT9JaO5oNKeDVfAaVXx0hL97dh3GiEuPQlU7I8Lcs=;
        b=Xf9KWzkMcsSOr3mO36n72lWjnhisbUgTu0cnKkZreIhd8mwNfcMO+6uZUpixKmwRUa
         xChZkZ++mffQEAZfGWjYcsrKeLqOBwznDZ+bBQwgvfVQjpllFWsKfKgQCis2Ue+pAv7h
         OjhUxpF8RDrNVGv/DPlhzuRhIO5jsUfZlg81V1NKEzCnC0wGcGyWy6z6ooBEW3baiT3h
         3buvfRypD95/UAaS5gPYOm95UH39jRTKrAKW9zGvOFgLRzyYVWt8pJ207WQJvmgByNip
         BaCKpRvHUgaOF92gyrwEgbAB5KwtNJjLnG66ASqatuMcemuGiPSvvFpKybG/xN+vQj2y
         9ZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747838731; x=1748443531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mWQT9JaO5oNKeDVfAaVXx0hL97dh3GiEuPQlU7I8Lcs=;
        b=JEHvuQGRJSh3enoJZeBUp2XpIJ95hWpn5Stqkl7kiEjI0nIwjn8xD+pNaBSiUdoYDK
         RIZ3Fadk4OZDvQVFv0cbIYtRUuivg+fXXIqgo2fLksKjnGvUX5qhVixQAITquWBKt04t
         YXG4v2gwb4UJtmVGUsX9bIWJHtkM6+guFaN36ZkwGcD80FMtrr3ygtDhkPsCxY/2Uq0r
         s/Fq9vtC+NhIFgZFY8hopAI76KtXj0SQCmcxCx/2tH/3ku9Tb4+DK6TD6c9qd/1Jje+U
         U3IkZcz9/Sp22wPJNMaqumlryTeFemtMrYnZpmwZblxnua2/xgkPoBRla58fYp5pmdKI
         vv2g==
X-Forwarded-Encrypted: i=1; AJvYcCW0c6zUTROY7RlVGBEUrbT3BcTFvjUNKT6E950vpHLxs+dr8QnqDhU5SXxyKIDU28qy+pcx8Pzeyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZYY9Ca3xD+yTz6rU/d4c6j0Dxxb/p0aImHxGXDodn6n8DXsBE
	FT8ZpZOOzWChJkl+OUXIdatrP4ZhoNySttjjXjSRb17ztOOhK4yy+4oZ
X-Gm-Gg: ASbGncssGfcKJ2wPeaqoECx17LPouI6tGztZTGrIWdycbRb2EsTBnPLwbLs6BXDM8PW
	xOwRaBAxoe994RyBjQj+8oB6TXcO9iPQhvfxauCefv3K4Ll8n0HlTwBpL25RBfHF5UdezsSdNy9
	+S/K0ynwlqpR7xCtlFXXIWvWHeH20ckxEMsl6olxPbTcUSeGhVk0HI0JzU0q2oFs3+U+/VKfxkM
	1F64Y1uk5A/PcM5+P/hbyqIiKLB7zTXk8tRSDoWP4Wt9++72pL/wLiSX2NbYxEGaf35WM9CbMPW
	8E3D7463ljZn5YUwrx9JBZE5Og7FeTxnC83T23+zWt/zBO4M36oX0+igxvBx
X-Google-Smtp-Source: AGHT+IFlM+NbstWxfc/pg1S26F0PpxYfkG0pdYQYzMehcZiG9t4Ec8XqFXe5gMS3x7CGj8HvY1Cc1A==
X-Received: by 2002:a17:907:94ce:b0:ad5:1d16:27e2 with SMTP id a640c23a62f3a-ad536bdf283mr1972790166b.31.1747838730767;
        Wed, 21 May 2025 07:45:30 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d439639sm920382566b.104.2025.05.21.07.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 07:45:29 -0700 (PDT)
Message-ID: <5ec492a2-082d-4797-b231-088564d763a0@gmail.com>
Date: Wed, 21 May 2025 15:46:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for vectored
 fixed-buffers
To: Jens Axboe <axboe@kernel.dk>, Anuj gupta <anuj1072538@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, io-uring@vger.kernel.org,
 joshi.k@samsung.com
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com>
 <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
 <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com>
 <48319c53-9556-4a97-97b3-3530247b6046@gmail.com>
 <b4f0d0ef-b05f-4f40-bace-e7632293fbb6@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b4f0d0ef-b05f-4f40-bace-e7632293fbb6@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/21/25 15:14, Jens Axboe wrote:
> On 5/21/25 8:05 AM, Pavel Begunkov wrote:
>>> About the use of io_uring_prep_read/write*() helpers ? you're right,
>>> they don?t really add much here since the passthrough command handles
>>> the fields directly. I?ll work on a cleanup patch to remove those and
>>> simplify the submission code.
>>
>> I don't care about the test itself much, but it means there
>> are lots of unused fields for the nvme commands that are not
>> checked by the kernel and hence can't be reused in the future.
>> That's not great
> 
> It's still a pretty recent addition, no reason we can't add the checks
> and get them back to stable as well. At least that would open the door
> for more easy future expansion.

nvme passthrough? It has been around for a while

commit 456cba386e94f22fa1b1426303fdcac9e66b1417
Author: Kanchan Joshi <joshi.k@samsung.com>
Date:   Wed May 11 11:17:48 2022 +0530

     nvme: wire-up uring-cmd support for io-passthru on char-device.


and if people followed the test for initialising sqes, it'll start
failing for them.

-- 
Pavel Begunkov


