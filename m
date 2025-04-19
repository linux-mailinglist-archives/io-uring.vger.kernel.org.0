Return-Path: <io-uring+bounces-7564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E83A9441D
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 17:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 319513AA829
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 15:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A551DC98C;
	Sat, 19 Apr 2025 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aTBzYr02"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E699A47
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 15:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745075579; cv=none; b=Ut+sDAxp2eR3s4QMR388LDk9Dtwc5Z9FyerZFxQuInpXLTqILXhiMBJUBaqiYJLhoyLTuOuvVe8vH6P8ic3tJlzz5flczBsxvnmv0B/iKIdw7m8PDeV5vOPntDGQ4i2wJ1Che3i7k5CSUIPYD/rq8155gUbFx0KvyWB8xCN5n10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745075579; c=relaxed/simple;
	bh=6EiD12aEZR67jTFhFq3Zk8ElKA6aJKlTy0103AxWYos=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C4+KDcCnN1Tv1eoEEMhUl3ajJ1T9H62pFXTMYWTGU1D8CgNFtY+0UJcYqe1lryDsDRurJV94mfj99rKsZzFLzwsFqsQL7AC5i6PjDDunKnyfFeYO5P07w+RwgRSs9LQYsziDI+Ov9doJlWpn77uCAAX+ayMjnQPpUhAMIbx0fEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aTBzYr02; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85de3e8d0adso32884739f.1
        for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 08:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745075574; x=1745680374; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yLI1aYw/QMK1OQZ13sqZOooq+y+oux9ILN8TicNteZo=;
        b=aTBzYr02TMfQMKSuRjt0eKBHNY4U4QIKQIshB70h61Q5ciDelKGT+80Akzwcw5snsv
         tJBHBij1lqlANb2b43dLW2Y7GJeCQ0eHs7BAZj4p4JJ4jD32QnEFMHVLZJglbGU3Y6Fc
         gurzUB4vrNyEl30hErLs6CFw69PpWQAd1t9QEN5/rb35Q64TIcsEPCWWOee3xWe++sOe
         qTZDdt+5phvJjSM6uvLQ6wkVP2KT6nIH3pTnuAAQcRiHgUAZnLm1AgdbjItdhQPIhg7R
         VfHd6w7Cod5LBLe6k0wrzSfaFdPUQWjPV9fDgwcBGveJ/7dvMWKSqAgJ7H4auMYeol2W
         kguA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745075574; x=1745680374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLI1aYw/QMK1OQZ13sqZOooq+y+oux9ILN8TicNteZo=;
        b=DNFUr4TLod/irDsAnIxKVgGDGTtOhFHXpKDtV07tpEbHulsoH7ioJMnR0RVHpJZTWU
         XCLTMCdopZ7LdMcQRCYAtQ9oEnGgWCKTOqEBCBcAtYdS9zrXQzX12yXaBfSsvRsRaAUP
         eiOmQ8d300D/hB51uFctw1qBMgBLYV30xLBrHelRr0u5V49MtCj9/F9JkQfYeYWlDUKZ
         Lv9Pm6V4B1hO+OUAgPEZJp0iINKoLz7iyDsaLTcSCG+BXc1a0avZYWVHRZ3HcQR+sXzr
         mYAfrOANJNIW4GG3ehd5XxKHasOJPzkEKC7fy2waM2YYKvOyi0Soy3mLds2cKgE+TZD5
         l33g==
X-Forwarded-Encrypted: i=1; AJvYcCV3zZe21TLXLikbFkZPJ9nTjsp/fOzLn3z2PhON1HxGbuMLxcQc5NfGqBIF8QJ2SfUdqPWFxqgQug==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4k0/l1pTQnfpxxa1ooL64YeU+Vnjj87OLX7DzRgYfVezGrqtM
	Fs9XdPMefAPwxTC3d+ofvcixky5rHcYP3wQWs6anlw+PVu1t2anbjX5mB2KnNCA=
X-Gm-Gg: ASbGncszlam3fjEw+sGk2yCXHXIx34vJLS170wrIMkgn5Mff6424oczMeVqt3sFItjO
	/igY3xIeuouY7oH8veTkYMwa0V7fOlU+9UD1Pg49TB8DBcAkn8V3Mab5b1BAHxcLuySAY8Xs2Og
	DxOoSbLuNEN2C4HZfln0XGAZ2safqhbz0X7tmu1Lmqi0W+zp050qv1i+TsJ92Yt0cOgQ7dZajwM
	O0XDdV5kYECD2YtFZ/ZEE3H69r/g+RG9bTwkOJUwfbZb2pAz37+kAaQZ+UgcrXjuPQwPqNCpzY5
	O/u78E7YNcnh1kxvXjmdUyaJqd5bnH3+1MHL4g==
X-Google-Smtp-Source: AGHT+IG/Kl5JMKcRv7pze5ulFhqOik2F25VAkFPkWPGyXsUREuYPzVc+ymneGxrZ++b86zZ2guLQeQ==
X-Received: by 2002:a05:6602:3a14:b0:861:6f48:5da5 with SMTP id ca18e2360f4ac-861dbdf40b1mr718500539f.4.1745075574483;
        Sat, 19 Apr 2025 08:12:54 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3806636sm936892173.56.2025.04.19.08.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Apr 2025 08:12:53 -0700 (PDT)
Message-ID: <debd0318-2d0c-4e0e-80c0-b47acbf93987@kernel.dk>
Date: Sat, 19 Apr 2025 09:12:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1] zcrx: Get the page size at runtime
To: Haiyue Wang <haiyuewa@163.com>, io-uring@vger.kernel.org
References: <20250419133819.7633-1-haiyuewa@163.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250419133819.7633-1-haiyuewa@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/19/25 7:38 AM, Haiyue Wang wrote:
> Use the API `sysconf()` to query page size at runtime, instead of using
> hard code number 4096.

This is v2, no? It's customary to include a "changes since the last
version" when posting a v2. JFYI.

> @@ -329,7 +329,13 @@ static void parse_opts(int argc, char **argv)
>  
>  int main(int argc, char **argv)
>  {
> -	parse_opts(argc, argv);
> +	page_size = sysconf(_SC_PAGESIZE);
> +	if (page_size < 0) {
> +		perror("sysconf(_SC_PAGESIZE)");
> +		return 1;
> +	}
> +
> +        parse_opts(argc, argv);

Whitespace damage here, it's using spaces rather than tabs.

Outside of that, I think this looks fine. liburing helpers should
probably have something for this going forward, so every test that uses
the correct page size (or still hardcodes 4096...) would get it right
without needing to know about this. But that's beyond the scope of this
change.

-- 
Jens Axboe

