Return-Path: <io-uring+bounces-6948-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B97A4EB06
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 19:17:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9474423875
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 18:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1335B2E3370;
	Tue,  4 Mar 2025 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfQewOIg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4710324EA86;
	Tue,  4 Mar 2025 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741110832; cv=none; b=OaOIJ56Vfrhcdr0AFGGbss1wzFjOsdgwVi0+gzO8v4TD+Bmf6QXr7z8k5c55yMUGinrBr6be4i99kHp/pG04y5+Kh4k9cNEmkEQwDK6LmP+VlfowJWZnP9tI+ibZqkxld1+tRdkr0SsroOYgTdDlijEoM+n+eckd4QXN2Vt8aoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741110832; c=relaxed/simple;
	bh=0LDmePTln+u4axdJ0aOPepEv01zoP0TaGJ87bXJkb8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bazQoQeOwL9kFw6RKsGcJTMPw7FKMKy/A0FAV6XOhKjhwiGkQZSDu9mWwO9oy5QKYykgmF+B7z+Ah0/b5/gyEmLW98V2DV/1km7dOXm7mayqwePMZTF+aY+3aXmW5d2W+V+1HozYlhKQMCzs32Xm7E/iePQmE4FfET4XGCEgGlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfQewOIg; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-390d98ae34dso4796877f8f.3;
        Tue, 04 Mar 2025 09:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741110828; x=1741715628; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I/0aj31QshGP4T78wXyPNtHRWjMSC7Sxol6fL65EPGE=;
        b=VfQewOIglCqMcm+l9/X1Dzt9NUe+hf/I7lfEws71nET6ys8S4p27xpnUkicXKjAJxy
         67h6B/QAWK81O5bP+8woeocHGzn51c3Y2ntP10+l4wWAv8SiIWf1Lc++WLxxtviFwdHF
         zSoy+iHX29lY+3CWPnMAab+ewvwh3V8ja/I/1iHFg5gIkgUlsNYwea+lfVm8gdf8H2xJ
         OgWsaJN3FwN5q/1LnFMP1uqCqVDPtazlCHcYVZs7pGjbMQY06/0D2ts+mPwoTEDyLRwE
         zpuHDphzWZ7DoVRy1S8rjwV0SOF6II/craVezgV1Ptqwg+Zf+i9xseW/N84poJoBnb0g
         LKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741110828; x=1741715628;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I/0aj31QshGP4T78wXyPNtHRWjMSC7Sxol6fL65EPGE=;
        b=e2HkDFn2hWyTOszwamde835F0bJ6CwSSZ/oRKqV+T8GcPW53UdESeZ00B6LA0B5gPs
         4lJBlirYLkxwwmFi5bWzz+PFwS5YW2Ui5wsPrB1mLw84pRHjg/hFzolLLsNj52eTXzCn
         2G8tGV7PzKrLHlYKRTnEdU5kvlJupMvVDNIhNzIoa+iU/Riu5zwehaTtBhIHVPjp5OJ4
         EQwEsL6fvM76jrp3VAMhTXQyw1P/kaxIdJwdoqQiO5Zvgmhi6r2743xiRrc05FeCA3DN
         riI7mvpraLb50uU8/5Ugk4fKribJyG8kb4fDmDTo3PafA1eBdyIWr5lXkyMMqurO87uA
         vkgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXG9MdnnyKW0yO1lmy5aMD3FU3i13ZYKUzXR7iElVq1ClH+DCMp/Q+pD9yYoGgd3OxLxlJRLFbs4sQK@vger.kernel.org, AJvYcCXM910wH2kusQiRI665Sn1B7qrK13oZmpRz8hYPd+Y4zUF5vhLNm+uqf2fAqJxRJ2qIiA4OrSo7pg==@vger.kernel.org, AJvYcCXtw1/lrMQk/0VOa80vA8oSz4egBk/Ltz/9/2bML6nOw4MBd2hiCu7+bv7MQE5Cn9f87SKSrqgaWQFxFS9ntA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIhYyFWggJvr5G3wtVEVGWDekr1mLeB2nTmUqELcg8QWIEhiMX
	SGHdYJXopZboEghLBEyf6Ni2mazvZmW1mzRv2h0zKWzHLcgmou/p
X-Gm-Gg: ASbGncvkIgYwJVuTa57CWwUjApozaO22MikHWzsM4Mu8oXvLNA4mzz8RdYoUF6BcQNH
	R/iDju/C1bSkmahk6iVh9oPb4SwNShX6lH5/qZAz9wO3uK1fT9/TrgXTzvLPKL+2Fh0RJgIpBg5
	PTJT1JLOPLKKlJUrOxMug22J3sHatVta07mOc1WRht+PQ9IqMmVK8cDG+lj/dk5nJ69FH+KVEJ4
	VfooG+HP1Atm2qrOoMaDu7Mz7/xERvZHCXl+UZJ3MdYQGpvzkNZLRSaEeJWu+B8WET9iAhEGKfA
	bqEQzMwnLIiYYzjHybiB7DdGe3Ukaj9UR/1Os7DHfc/wyVcF0bOIqg==
X-Google-Smtp-Source: AGHT+IFX0oebidS7NUhxe0FgEu8LE8CRLLFgT2QQN91OazOCqVX9imk0OrJ2ME3eMMHyHKzUCto+nQ==
X-Received: by 2002:a5d:59ae:0:b0:391:10f9:f3a1 with SMTP id ffacd0b85a97d-39110f9f4ffmr8167306f8f.35.1741110828240;
        Tue, 04 Mar 2025 09:53:48 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e485e045sm18521029f8f.99.2025.03.04.09.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 09:53:46 -0800 (PST)
Message-ID: <8295d4e5-dff7-4e20-80b5-0a8019498257@gmail.com>
Date: Tue, 4 Mar 2025 17:54:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <Z8cxVLEEEwmUigjz@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z8cxVLEEEwmUigjz@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 16:59, Christoph Hellwig wrote:
> On Tue, Mar 04, 2025 at 04:41:40PM +0000, Pavel Begunkov wrote:
>> bio_iov_vecs_to_alloc() can overestimate, i.e. the check might return
>> -EAGAIN in more cases than required but not the other way around,
>> that should be enough for a fix such as this patch. Or did I maybe
>> misunderstood you?
> 
> No you didn;t but we need to do this properly.
> 
>> Assuming you're suggesting to implement that, I can't say I'm excited by
>> the idea of reworking a non trivial chunk of block layer to fix a problem
>> and then porting it up to some 5.x, especially since it was already
>> attempted before by someone and ultimately got reverted.
> 
> Stop whining.  Backporting does not matter for upstream development,
> and I'm pretty sure you'd qualify for a job where you don't have to do
> this if you actually care and don't just like to complain.

That's an interesting choice of words. Dear Christoph, I'm afraid you
don't realise that you're the one whining at a person who actually tries
to fix it. I'd appreciate if you stop this bullshit, especially if you're
not willing to fix it yourself. If you do, please, be my guest and prove
me wrong.

Stable does exist, and people do care about it, and people do care about
problems being fixed and not delayed because your desire for someone else
to do some random grand rework for you. If there are _actual_ problems
with the patch, please let me know. Some of more rare cases being not
as efficient is not a problem.

-- 
Pavel Begunkov


