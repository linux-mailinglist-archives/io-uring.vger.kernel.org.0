Return-Path: <io-uring+bounces-7725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05265A9CD63
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 17:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A8B03B95C7
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 15:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A30C2749C3;
	Fri, 25 Apr 2025 15:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Hp5KynKb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8232F218ADE
	for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 15:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745595766; cv=none; b=UEYtauI9UDu4wTD/DASrB+qOPdYiNUZQG/oy6SPfWUBwKKj7oKqAtQAMxC7cNxlD6XS3/sDye3VLzDx3mjAY9K+9hIrddmUiLAJ5m/2Tzmw517kZeatJrehMrqP61lUVBm7Y6puaJHkwt1q1Ad5eYet6yeEhC/4Z9YHZPXTgmsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745595766; c=relaxed/simple;
	bh=GyHfItGL7Ds0CrzaoT6F2gf8vA1EY8GHXq3XRF0VFn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LWTMyMHK3B7Od+ytpG7bJnBBMYIJGKh0HfM/7CA69TQZYeIJXq0zl2K1MCE0Z1Kw02QEujZTCo75zyzltcX8+S08f5YDw7dZWI9kCAB8KL5PApgi3VzeqFdPwRnBKXxAUsuxS7nUussdo3fTpWgQXbRnrLYmSH07NTd1XnXF3Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Hp5KynKb; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-306b78ae2d1so2032143a91.3
        for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 08:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1745595764; x=1746200564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UEUpO6503+r1WNIXaZnk6oxZUVB2nImlfKYJ8cHFtvM=;
        b=Hp5KynKb8k5XG7Wjq2SGXpEzfLLgfyMDX80qXkssd9NdzLbL2aGVu+7R1KyZCazg4C
         84NpsbjDeSUwWKmMjR2romelbM/Obto0arqsh/sib0leZgl/J4+lPmkHs71fFiT+jEDN
         PFPrQ4Wm2QlFa/x+Tp6bztvhNeUiZsF3MLt0m8OezvA6XIVdN/IZo6TxNQMspqa8e7me
         +uvqkPqRLE4wa+KTFSBhLl5zxafBjuPHrtMIhmS64FFydpoERb1tVbNv/frfOblyZ9+y
         ttmUIvX3RxB5zcM1f75yNgLzAjOAQdtTa0cm4sAkFUwCsK4BIDGr65snu43+FK6NwnwO
         3B4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745595764; x=1746200564;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UEUpO6503+r1WNIXaZnk6oxZUVB2nImlfKYJ8cHFtvM=;
        b=r6DaQQ209iYS2QkLxC/nPGbq4HlZDuITKbzE9nFfGu/gRjhLpBHYMFlBEbZqNvluz7
         6Rpa1CxysjCn+bR3HD1fTjxw9Lpd/YLXu2/QM74pkJzOcfD9d4ibf7r8FYIFBE8vKqFX
         ni8U9YcO7ULCcT+rcNNCabkZYzChRFvhXTiLQ6KE1zO4B/LpF31JR1y9K0obas6LDtvb
         wJwNlOsJt1g8LE4BbZ5+XbxKwPYPC5Gj3JRkMn19mgVdbysBgAtEHfzoMxHcZdvP3G4R
         OCuTKM4TPt+ZqRgjJfbVlLfLUtEQN1GX7w+FWy5DMY5aSdtwCEPyV1IIpxw+KYCZcppt
         PG9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXfYq22x7kRGT3RFrDUL0vy4zFfyQyUH1ngQKTJucuGyswnkalwAEI18m34pbUrju1qJTkAUfyczw==@vger.kernel.org
X-Gm-Message-State: AOJu0YywbFCtoSO/nQJTMeMIAmqgCjJtSJPB1ye+KuLVQjVtfaaCiOv9
	hQQ5S1GBys7wtvQEet4n1QBNV9YxfBaIj2jZpMYWCmN4y1C3xUx/MakezvriHIsurC08ZDf70hF
	N
X-Gm-Gg: ASbGncsL5Zx2/FSb94up3idHSUpKgse6ft1CEjTGwp1Umt+ZKwEk5djQ/29V/06+x+H
	BPzusHKr0ueziqp9qMjt66gnoxLEaGSTN/WlpWDo37qUziyau799X3DTfga23a0mgGagHh5gLUg
	SmJ2J5jkHBkVsdHcpsSj0f+lUBaaSqJHXiYXlhJYR2i9mrZjJPjQ0rv2z6H0fNg4rdnq+6PH8iK
	YA020ekhjR21rRpMjo/5ssIMBlhEjweg82/61P1Nw97ifKhFcccn8srT6owVhNLCYMGsA/wDrBc
	kigtRzwV0SqjIUEsfGBE/atspoILfQVo00I1mrCNGyho3SAJnuqGrNZd9xpxvD+/bLqJacohU/0
	tvy532rrS
X-Google-Smtp-Source: AGHT+IGQVJM1OQQzn/xc81+5ALABqE3K4axNSH7bjBxlk5aPQslc5HOUf76hgKn8LvaT43exGk203Q==
X-Received: by 2002:a17:90b:2681:b0:2ff:5e4e:864 with SMTP id 98e67ed59e1d1-30a013995dcmr54742a91.25.1745595763645;
        Fri, 25 Apr 2025 08:42:43 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::7:f8d6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309f77371e4sm1799061a91.7.2025.04.25.08.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 08:42:43 -0700 (PDT)
Message-ID: <a803071f-01c9-4e2a-8a1a-d110b031b32b@davidwei.uk>
Date: Fri, 25 Apr 2025 08:42:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] preparation for zcrx with huge pages
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1745328503.git.asml.silence@gmail.com>
 <b8bcb087-21c8-4304-812c-ecaaf2b2c643@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <b8bcb087-21c8-4304-812c-ecaaf2b2c643@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-25 07:01, Pavel Begunkov wrote:
> On 4/22/25 15:44, Pavel Begunkov wrote:
>> Add barebone support for huge pages for zcrx, with the only real
>> effect is shrinking the page array. However, it's a prerequisite
>> for other huge page optimisations, like improved dma mappings and
>> large page pool allocation sizes.
> 
> I'm going to resend the series later with more changes.
> 

Thanks Pavel, sorry for the lack of responses this week. I will look at
the v2.

