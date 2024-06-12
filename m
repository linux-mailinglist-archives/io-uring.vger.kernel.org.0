Return-Path: <io-uring+bounces-2169-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6249990482C
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 03:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 870111C21AD8
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 01:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC8D10F2;
	Wed, 12 Jun 2024 01:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hRWsWdkD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0873815C9;
	Wed, 12 Jun 2024 01:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718154794; cv=none; b=ja9Lrvt8vdXnRuPSm9LIxM9L/hAjpQ6QxFvbTbQpHG74n2PuTlb+GacaXAbnJRB5NFjk0NoQv3Hj1WNT/uU93YutXYYN+vqMwil7tQEjQK4hS37zRbkomUo3Me/7FO3sIeNct5Oe8DFJ/nUKYeh2IP8yrbAPSaUxY6HT78Us1/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718154794; c=relaxed/simple;
	bh=WQP8adOHOMBycO36PYr1DBqXAe4KHksD/RBNZZYwm+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Gbi9ebcGsv2jbJsIvKdQnG3k0ftlnWvqidtHdYkljKo51KtN+XPVzidzHfTxd7bYyvbe52cFrOUfy38B0HrYdPLemwD6lox1k715X7vVGQLTF4hlaGcb7EDy72dDR0gUNVhpMbVKkNH3uwuSzuQG1o2o0piqy73Xt34M6QkOR10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hRWsWdkD; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4217c7eb6b4so30282245e9.2;
        Tue, 11 Jun 2024 18:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718154791; x=1718759591; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=glFWUd99bSnGarHsf2S+9+G5OWlPRanKdN6Sno7yino=;
        b=hRWsWdkD4CRxsDmC0KThV+6zkJKlrfXZHoLBdpU8YMwEw8r6s0efYXTKtoj7E94Mss
         HXkWp2exht55Srbyycu14A+/NoOEJ+CRR+qHFS7FmsXcg6oEf4L/ciJDJzc/FtMGXnCP
         GTgPBQFSPtelb8vIeT2eYVykIFG302UXa5ShRuqXYGoHI68oKQDmFgxgku9Evkb9nxdK
         fnhGIaCS+ME6GFlcE17+U2ocTY9qVgP7h5Xju50nnU0otNAAR0RL8Hby8S21ATcvJInW
         J9bWf17RKHdCoozqPYepkFgiUmWVmnDXVpGw3nBVq+rFc75V5L1F/Zq8sRDOIS+ybBqJ
         y01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718154791; x=1718759591;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=glFWUd99bSnGarHsf2S+9+G5OWlPRanKdN6Sno7yino=;
        b=wS9NZ0qwU7oqP6eykpUwQStIunNYl/GqseOXDGKDgHZDD7QcZYQM3tyUaQ6UeEOeLe
         /I2hkqnPblqkO3MpzKKmW3HWUBcJeQcnPCOj+d0gx2SlYjmHg+tnDT7LkGV8bHSaK60P
         hlErYdX8Uhny9spSv3xIZrBcPCnLbQrbx1cXdN/O/IcGgO3cSfwtx+YTO4z+bd5m8X4a
         YGfVPEXOKuQ9ueO8J+rmHI3dEV6UfJxxdWtyI3354bPDHw8/29mnunnglFCX+t+jI6lp
         XZlOHoaro+Q6j5bn9EWqbUoY0jzrcR4lJ5rt9OSnv9xnVw6E1Da6FeY29lgHC5Ee3k+O
         f+8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXiLA4uWogC9XNU77oPNj7Q43EAZNwqKCmtLtCC2V8zjZZDZBVaRB7/nklYpEncmXEnTuZqISTN7wX5Yh9R8Vg60nAFveMfjqBn3aCVQfiUG5KCFDQCzD7aggf261ANAr/6D016/FA=
X-Gm-Message-State: AOJu0YyjD9rXOzAMWfiGqqttI45BhcLcmWzZVxMhRxLnU/oqRL3A9Eg+
	5WQcQer3wR5GQ8CyIS59xYx7ufYz4tNHtpMonhV/HWtk8kOi0jJQ
X-Google-Smtp-Source: AGHT+IF+PIbKxuVU1Xy1037c53DCFhKwHXKjA1hiFDQ0+evJgCKlFjqWI1BVmNQMRCevumQumnJfnw==
X-Received: by 2002:a05:600c:3108:b0:421:7f23:8c5c with SMTP id 5b1f17b1804b1-422866c0c13mr5764425e9.28.1718154791134;
        Tue, 11 Jun 2024 18:13:11 -0700 (PDT)
Received: from [192.168.42.217] ([85.255.235.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42286fe919bsm5446445e9.19.2024.06.11.18.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jun 2024 18:13:10 -0700 (PDT)
Message-ID: <e0c76f8a-68c1-472c-a2f9-2e1557be26ff@gmail.com>
Date: Wed, 12 Jun 2024 02:13:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] WARNING in io_rsrc_ref_quiesce
To: chase xd <sl1589472800@gmail.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADZouDSJRVEHUK1dMQF-guuDh_EcMJE55uLYRR23M0a0gvkd=w@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADZouDSJRVEHUK1dMQF-guuDh_EcMJE55uLYRR23M0a0gvkd=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/24 18:11, chase xd wrote:
> Dear Linux kernel maintainers,
> 
> Syzkaller reports this previously unknown bug on Linux
> 6.8.0-rc3-00043-ga69d20885494-dirty #4. Seems like the bug was
> silently or unintendedly fixed in the latest version.

Thanks for reports, this one looks legit. I'll fix
it up. Do you have a name I can put as "reported-by"?


-- 
Pavel Begunkov

