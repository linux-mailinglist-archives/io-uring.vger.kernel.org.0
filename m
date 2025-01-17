Return-Path: <io-uring+bounces-5959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF25FA14830
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 03:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60E703AB787
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2633B1E1C09;
	Fri, 17 Jan 2025 02:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Ngw2H7bj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D9A7DA73
	for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 02:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737080257; cv=none; b=CqXh95MT5jNqGW6Dlj/dPgoYXV2m79HuoJdPROUpdEexQZ5brmccwlLoV2D+VLf3wT705kMdiLUlj2yTeyUWZFSQDVwgEcf2F0i3x0dwZHUkOKqtVeY9f4o3TvzQHFS+QcXGF9HirL84mxfFvQ8a0HowtOVBuOu8XVKMx6AhwZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737080257; c=relaxed/simple;
	bh=3m/FrXZDTAyAWeSkN4gKvMb83gnoTmYBJ5PoCqaJPBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7uOpTz1/mn1wdUsyAavX6FmS97sIyBlalHgPsV/Jj7KDVE7ar23vGNDBl7wsMr2Oyn77pDNYQBjMdUDEYuyp9H9K2HRExfoR/eIaX9gcVCIXr9HGU3FUUrUZNakUs1BNl6Vn6q4Q4ebJOETjw4g8EGlsI7siQdggxe/ZPuuZpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Ngw2H7bj; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-216426b0865so27920485ad.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 18:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737080255; x=1737685055; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=miBHI/awUJGjxSBVIbXN+cKjr09MpAjHeZ0pzpQ1XKk=;
        b=Ngw2H7bjHE6kMnASq4YBU39Q3GycVwiwjaSNS0Su0LgABjprXCdz04FWrBE0/LPuB6
         33432RcSnvuAXoqUYaqDy2vXO3g2OC2QQHjv7pPNS2h0RWyRWqgKkOcm6m3pCybpxHAY
         ySXhS6T37AuAVTb8PSpm9noeJ8bWO0fVL4alhoxYqEHbpC/N57uC96vNet0UIZogOmgb
         qt0OCyp6QRZY7fBNRQBscesPhoFUaon92Y0WBmfFft0CHCNRx6CAN5WKq2TW9D36dhAV
         VnlTUTDoVYXEh5WI9KWomIZo4BUmn6yReHhHuvhDZkUcmd3JPKNA4ei6HthSVipLraQn
         R8wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737080255; x=1737685055;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=miBHI/awUJGjxSBVIbXN+cKjr09MpAjHeZ0pzpQ1XKk=;
        b=XJk4OGvaPKIwmBtG8aO1ofdtrXLNfSPseQgb3GzbJHKNeLj3eO8okg3qaRCtP3g0YW
         KYO9xxc4kr8tl/sUyQr1wT4ZA3XCpU8/DZpfkHla9EzzhywOYzOk1zMa2IvuYBvzvzTk
         pJvXSMeHjbaYnHmv58bqh7wVTkDVcu/lHJiWGRt1uGqOUJMk5VHbjVzZO+zbeD1IMNw0
         zWifIhafSW2jzAbF2d6W4v9TbZP5lCb4MaIPJluSYsTb13nJkBVqOEFttqoJhAIg2Ukz
         C+7/qT+3kZS/WaXedD59nNFgAEgUZApRdz9M7FQiBmyTzF/k1kebgKRk4IOKB0o60Zbb
         ab/A==
X-Gm-Message-State: AOJu0Yx7GDRQgh+d1pr+M0r3w30o7CQ+64dUpwATjLXJla6t6asyK1Cw
	rnPEJ6jvmzqTV/8guZ71UEwBpkS73cssElHoVrSZi9fuztJ4tzZcui4eTQxyafM=
X-Gm-Gg: ASbGncugnHVXUzY2eZYlSOILW8mOy73QPlE5EzU06W+77xAbTZizIoeDCl70t+eE+1C
	h2NggmbUa3Dx/HOLhOFMb96WpRt7lxlfdZajRV4kz2lF/BiYjG3wFbHvFHUMWO1T5qYc2DDtMZN
	VrLUz/ersbap0AyrFJ/+qK8KuMZXCW9eTNoxVZDD0ShUAvWQpkW9BvMm7ialiAvXbq3S3KKAaZ7
	DhxjuK+hgrygOqKub/JBWKNnqaPb74WNDUFjxqlkWb9boFVNpwZuKD14P2PEGHKsvPSbdDDG9eu
	+MbJMlGhBPGFyFAAZg==
X-Google-Smtp-Source: AGHT+IEZ6x3fVj78RCuO0ppzn/afHK5Zc/Yxld78Pqth6r/PPg2Qn6CyA/nHBoOswyU2z/12NVF6tw==
X-Received: by 2002:a17:902:f64b:b0:215:b087:5d62 with SMTP id d9443c01a7336-21c355b5684mr16995125ad.36.1737080255145;
        Thu, 16 Jan 2025 18:17:35 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:cf1:8047:5c7b:abf4? ([2620:10d:c090:500::4:b8ed])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2cea2e94sm6337345ad.28.2025.01.16.18.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 18:17:34 -0800 (PST)
Message-ID: <bca59c3c-0105-4bb9-811e-a8334b066751@davidwei.uk>
Date: Thu, 16 Jan 2025 18:17:33 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 14/21] io_uring/zcrx: implement zerocopy
 receive pp memory provider
Content-Language: en-GB
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <20250116231704.2402455-15-dw@davidwei.uk>
 <20250116180723.21a4e637@kernel.org>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20250116180723.21a4e637@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-01-16 18:07, Jakub Kicinski wrote:
> On Thu, 16 Jan 2025 15:16:56 -0800 David Wei wrote:
>> +	type = rxq ? NETDEV_A_QUEUE_IO_URING : NETDEV_A_PAGE_POOL_IO_URING;
>> +	nest = nla_nest_start(rsp, type);
>> +	nla_nest_end(rsp, nest);
> 
> nla_nest_start() can fail, you should return -EMSGSIZE if it does

Thanks, will fix.

