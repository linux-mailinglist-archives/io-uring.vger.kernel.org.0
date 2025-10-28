Return-Path: <io-uring+bounces-10262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EACB2C154C0
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 16:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAA77420729
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 14:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D38F2F616B;
	Tue, 28 Oct 2025 14:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="mR/3megF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E0A226861
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 14:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761663303; cv=none; b=WPyUpwHJcn7DbeRI/xCF16dAbWtCNUwROTLr/qAfv5UtwwUHh+QRn7qFtEGBfKKxc/pTg8dv8AolsOFNYhic0KgSTmuCuJvc17vW7Vzoxta+vvqYqpYBYiVXkqKit5a+4jmoZ0PE7ruH/N472uTcAxqEgENVLu7s7jyJasUGWtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761663303; c=relaxed/simple;
	bh=2PFvZeR6FZ5y/R3/+WHESxKSPwUDsScr1IwZ5KkE4Yo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=raA1PMM7DaGjFs/pokLrySYoIw8bBCg+Zf5xNPwqL0QNEN9K892DVReIW+Uodjz83QjJNqO7ISpw+oBkNcx7ivBGQ4NPx6AOM+t7+Yu277ppcqDe+Rbm8kRPyk1gK/KlNqtnk7ZDCpXb00WDnTqH8r1jSPlwFn/ctldjPDXQlc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=mR/3megF; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7930132f59aso8029406b3a.0
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 07:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761663301; x=1762268101; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r7Xa21oSxQFb3c2s+CxJq7KCyQuGsxMn8gSjW30YCMI=;
        b=mR/3megFe1plV232xR6jXmuEoJmt9vUP88DqOKO6vYQ1M4z24FJh6FmExmzX6fX09j
         O0YXp0AaOlDu67jI8otM2x+1dnOE6dQsb+w8aPO1fi0l+4HAW9P+Xz1SM+ufRmxOkFok
         IqgvghS/seNrT/NXHh3Oo4FnvCtSUG6cyJ/a+Xbv19h/53eyOKkd0HvhI/nvRR5x6Cex
         uTYIJD5EgqQlZqcxqLu0qaB55mm9OMFFkubhtDqG7HBn1mzLw6A9YH51EPj8CCtOxngT
         87mHDEeuGMcwkd+pv9YTAcLR1dihB/l9dPpk/pZfyWzqwJz8VMbjNj88dKHEQsxpU5/1
         x7Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761663301; x=1762268101;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r7Xa21oSxQFb3c2s+CxJq7KCyQuGsxMn8gSjW30YCMI=;
        b=gUq66zGWpDKdhZ1sX9kdzx/hlVwTcaiZpZDTBOqA+PPwpwvlF/kz538gHoLcbH8AbV
         8HJA8sdNdDlIMNq1J8vkzO3yZyvh44LbGoHeIAcuMSuWHGHJRCuCrTxdaZ4PFHTn795q
         YkkWAVu7sAKD30WYXAM7PoR0mbk1hC8uYa+TQfv2vVqFJn6eURSu2hH12mWCGm0pfte/
         1VnZtTdHLYnxaePUmaTM/YFCy48qZpsfpFqiPtGYcqDK3hbx2W1hyMZiIMc83YUlVqi1
         1pvnpyZYqUReTj4k0HfsaKbL1+P4TDU3bvq4bFJnzmuFLuKuT/sPnAsdBlaHAhOwAkt0
         IVTg==
X-Forwarded-Encrypted: i=1; AJvYcCXsnEtQdQO4ENodvdfsGBdGYnYBX/krB/p1LIME7Rr+AoAkZ6d/Ok7y1rIAG26ZaXV6By204/W6jg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxorayRdmqWiaVXvRal0YoPt59JQ3lYrEHZpigOMxfNcNF4FUS5
	khzgEyLZ0XpJIl50gLkPkuMnWIHf2VGSI0s7XtXyZVhW40uXyLDegK6aaN+Zssd4utE=
X-Gm-Gg: ASbGncvdIZFJUx0U5X+iitGWtLVCLgH772Vojn5KTUBUP2haOieqrL6I/pc7oUQkHiN
	wYYo9HRRjjQ7lNas8/LWoFvRmmUtNGml8fOX29nNi5bory8yyUrz5anQlsxu0Sm29nzQozmZ6Jc
	3+gRGlMGjNg/nzZRvDhw8dVPTvGJPdCtbyIv2mpLjpNzNYyPDBJnm5BeYTTWRqlSK23V78cUTqe
	iNu6mdSGRP7NBGxnT/67y44Rvy9LYPaWpnPAa+d/QbqZCw/yOS7xHMmeKFd1ETNFbSKOHrAhMQg
	6y3+B4IbrolndZfCAz6xkXdDOhEWXltW5Mo86Vbspq0NnQV3NiUY1IDRRcoaBwPkhBhgKKal1/s
	FuQDvRnp6Fd5KEypvxOs60Or7dWX78ZFLvc9f4TUrNXxIb9RtmZnq5XDI9ZAKV/vqQjHxgzFNyd
	tXzv1YIXs4oD2/ikQoTIoMXSLAhFLJ+dgDShDyNMlNudQ7z6r2oVCzggeA1a1LhBx63cL4
X-Google-Smtp-Source: AGHT+IERVBWP3CiTECEuDyQSl8za0TIzSRK2W4YtwpnPOl80PRQRDD5vRcY4w8hz6WjAmch11Vxu4w==
X-Received: by 2002:a05:6a20:6a28:b0:2ef:1d19:3d3 with SMTP id adf61e73a8af0-344d228dd62mr5056634637.14.1761663301065;
        Tue, 28 Oct 2025 07:55:01 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:c8f:b917:4342:fa09? ([2620:10d:c090:500::5:1375])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a4140530d3sm12157441b3a.40.2025.10.28.07.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 07:55:00 -0700 (PDT)
Message-ID: <74cac804-27b5-4d25-9055-5e4b85be20d6@davidwei.uk>
Date: Tue, 28 Oct 2025 07:54:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] io_uring/rsrc: rename and export
 io_lock_two_rings()
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251026173434.3669748-1-dw@davidwei.uk>
 <20251026173434.3669748-2-dw@davidwei.uk>
 <c3a45eaa-0936-41a7-92cd-3332fd621f6a@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <c3a45eaa-0936-41a7-92cd-3332fd621f6a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-10-27 03:04, Pavel Begunkov wrote:
> On 10/26/25 17:34, David Wei wrote:
>> Rename lock_two_rings() to io_lock_two_rings() and export. This will be
>> used when sharing a src ifq owned by one ring with another ring. During
>> this process both rings need to be locked in a deterministic order,
>> similar to the current user io_clone_buffers().
> 
> unlock();
> double_lock();
> 
> It's quite a bad pattern just like any temporary unlocks in the
> registration path, it gives a lot of space for exploitation.
> 
> Ideally, it'd be
> 
> lock(ctx1);
> zcrx = grab_zcrx(ctx1, id); // with some refcounting inside
> unlock(ctx1);
> 
> lock(ctx2);
> install(ctx2, zcrx);
> unlock(ctx2);

Thanks, I've refactored this to lock rings in sequence instead of both
rings.

> 
> And as discussed, we need to think about turning it into a temp
> file, bc of sync, and it's also hard to send an io_uring fd.
> Though, that'd need moving bits around to avoid refcounting
> cycles.
> 

My next version of this adds a refcount to ifq and decouple its lifetime
from ring ctx as a first step. Could we defer turning ifq into a file as
a follow up?

