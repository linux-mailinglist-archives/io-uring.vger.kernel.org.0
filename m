Return-Path: <io-uring+bounces-10178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A360C03FA0
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 02:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7EDD24EB527
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 00:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD4913D503;
	Fri, 24 Oct 2025 00:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rXCYDNrM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D508635C
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 00:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761266985; cv=none; b=Ln1tVAVfFsaErmDGgBOvBJwI2vsDXMlvvtYRqSGRw/ix5oVOcPSSLOhtCcABj5P8MSn3h3o6AWTJS6aX346HYkChpPRectzCGWy+8OU4tomne6b3oDAVe2eIRoTK9ljsT/gXyLN6WkLxbZQM36QXFUu7okF8qOMRd6E8/YsvIa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761266985; c=relaxed/simple;
	bh=7u+IjDwO6+F7DI7uchGCYv5muBEp0ShcxZa0CbC1aiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Of0SA8iFWZo5CHbcNvC/XC3Ktn2wM/40d01l4TIcplbdQ+5Y54YaD3PuuF1OvLAU2phpU3Lm4Svysyy5jpPUq/jlwZIUuQ2N6ygGzijfpRqJuI60fWqvprxGN97JyQmWaBHHSsmIZ57N+9XFNM67KpR1en/GC0RwsAqv1rWmJo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rXCYDNrM; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-93e7ece3025so59978839f.1
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 17:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761266981; x=1761871781; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ot+UoxjARjoK5fUaxnFU+2GwMHtgeInG0/YoXF7TxQ8=;
        b=rXCYDNrMYFCw9u0WghcoDsLKCv/4E5b4qvWM/pFPeOaGu4IW0ZXFaJJO7ugBzUuqUO
         k3HN3Wr57Vd8+55BiPXzXar8H++dPsA2NVyeik05IV0E9KLRTkN8noUjnq9i46JMbQSJ
         Re+HTiGJHQPzHodwJOVh80fhCg8/bZMOstMvuIn+20uOINwJOIftsAOY4o0Xv0NnOnUQ
         Xxj6fYu33ZuvyxTiLL5EhoPoCnn9cAxBpoFbjXkssU9W2AXI+mZHNLT3DhJdY7Go1sKf
         yPCMIFlS3LtB4n0nS6Hart8bjVFLzuBP37B/zNX6U3sndRFQxn5q8JJSrfEk8xAfZBYz
         LOSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761266981; x=1761871781;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ot+UoxjARjoK5fUaxnFU+2GwMHtgeInG0/YoXF7TxQ8=;
        b=Lw5iU/VShLVDW3OrBwoMbyx8FPer7tuo6JXapbHwUXZsZP4IhCLGgaOPIjmd49ebCK
         p60c9WU0eb44w/H29sBcSdZABPzY7eRuJjj+NIkznu5M8FpbyyEMKHK+3k3wb7QpFrIR
         vTgoJCxn0qZUAr9YxUqHl22l1QVU3bh46r4Oh/y7Jw3jjobZ4Na/JHRnBZxzx3fLNUO3
         EytWJe1J2A1nS7mbEndrV0GmExr7t8fKpfl3n5wYhQEsuve0whwJqpxCs3/S9VESYzTz
         y16D0l8Q5TIeIxb6rhrtbZhc7HaXoOevy0OF/wPUKczQ7wdia2ZOgLO+TGm0XkHgpk26
         kynQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGKnicG3Onel4IT2h8J/ohr919aLYDy1kHJl+SAIZ6evzNzzjSQQocNhY+Bg1mnKmk/6nZ8B044w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiTyaH/oocUaGWN9QdiPd2bTAPfJn58RFJHVKzaLUQtAGbTS8l
	JdxGI8CdU1ITcEjM7iR0ItvF/LhU2Q3JA/g53AQAJDbc9ABSjsVGMKdjOmquLg06jcI=
X-Gm-Gg: ASbGncsYmCGkNOxuTX5q0ghtFe39JC2yGbNGeJ9z4HK6/pi2BbQG+p6q0euRMLw3LX0
	tWWE53LxPF2DBffOs6Zj+OfbFBlHxXOTcDz6Rp8qFPe14E4Jo9EhGFmh8HaDjs6cgNVAMQQ2LQj
	4B8g5ZhT4m35Ox2T4szBbpJRFVVfqlYphitbDlNGDA86qo0+Ic5e8xw9sJP6AixLwyGc4iA8jSl
	UF9DcNn5yzpeGChlZNApUG6miidFi0z+4Wa4CpmtseHgURERTFUDKUoFJ4DUmYeDlUelUcTdztW
	OEPo/4O9QJ0+DBk3y9XdIQkdcxs/RG2tDrmIpNuZ9lC1urr+xpHhnB8y4ySLgrvdqYMFadnVnrB
	2X3w1gw5o46iaCF+9tk0v/rGD3+ut5bbiNRurHM5w7XAW0PYf4SIo87LQIGhWmeWm878QB8yuTu
	+8QynjDDaW
X-Google-Smtp-Source: AGHT+IGgigrSLGkxt4zqVhLYINQi5KhGC+zpYsJYbgrYE1F3EibqxIYRXytZsIarOnG4dRBIH9FH3w==
X-Received: by 2002:a05:6e02:220f:b0:431:d685:a32a with SMTP id e9e14a558f8ab-431eb624025mr12439245ab.6.1761266981533;
        Thu, 23 Oct 2025 17:49:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431dbc8540esm15916115ab.29.2025.10.23.17.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 17:49:40 -0700 (PDT)
Message-ID: <3cc96d17-f77d-4163-a018-eeaff2e8ebd0@kernel.dk>
Date: Thu, 23 Oct 2025 18:49:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_uring_show_fdinfo (4)
To: syzbot <syzbot+a77f64386b3e1b2ebb51@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, kbusch@kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68fa9c5e.a70a0220.3bf6c6.00c9.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68fa9c5e.a70a0220.3bf6c6.00c9.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz invalid

-- 
Jens Axboe


