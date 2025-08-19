Return-Path: <io-uring+bounces-9070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F1AB2C838
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 17:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68E2056065B
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 15:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3621527FB32;
	Tue, 19 Aug 2025 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CCEsgIa7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A734263C7F
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755616294; cv=none; b=qw8R4Aq1iJk8ShoTDNlFi5TtuTSeptLPeKZrjgH6fGsSf8ZpIdbwUN6AMbQnZraut9Q2mhueCiv1Ks0Oq+yQo9NBYY+5c+EgrmVEwPwfGIJNdw3YcK2zEqpiy9w/1Ywn8fPsxEHdD+Cv24Z/8z/0yDpRseo0hduVAg+84NSsCew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755616294; c=relaxed/simple;
	bh=QycJOek0v5nhJbP+MM3OL5pORRB5+KjDcuVnGbqGgEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oP0D4lPPmgrWckfdLjvmSe4uC7/n1HugZElqFk3O3SDD3zWcvURdRLz52JEojBkMLfAVdftswCLGTIZRcNlKrI0Bm+Lb+Ou6KsvsoZqT/mN1t/Ov50ejOb8SA59wYYgN/yxarcQ4F9GJc8HE8LwZ5u971NkvFR1AaU+KLtepEXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CCEsgIa7; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-88432e31bdbso388107939f.2
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 08:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755616290; x=1756221090; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XJa+KTXC3mY3I1CFmfiLeW6ge9cWEkwQYxycSXbruFw=;
        b=CCEsgIa7xYOHvvlqiCVHe4ie/qZUUblJzn4Nn4zr3bH3GFuHl14BSH8r8ga/rpLdWY
         q+9cjg1h2aSWmnK4CDPyuhgk2wkY7ieSwu97m4qzPsgBicZVkwrRbzCaCzYYYEGJfzLY
         bZl8+bxAt/qLxqOADPEg8gJZf2nEB29m6nCr7Z00ty7EbEpSQjfGHxG5R8Oc+32sF1tF
         /IuUaeuRPP7IhkBc+vPbBR+hPPB+oGXsG85wQ6YXiud3Y8MKTuUV9P5SpdqIUNOKD8pb
         VI7Uw+eQxcjWL1lvRtp98o7hcBZwcaqzACXpjBMCXv+1Wzejtq9ohnbmg8LAaUK0AN08
         Lzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755616290; x=1756221090;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XJa+KTXC3mY3I1CFmfiLeW6ge9cWEkwQYxycSXbruFw=;
        b=u9LOpXkdLG9hM54FkmOxLvkHyjxycTaTeRTM1Ga0qHTGyGWGT9aXAapGvyWbuPxv/k
         XJRYsAHF49KndNoI6GYqs+kIF6vtTmkljUDFZlY6OUygHxnIFPgOa/GrfhDWVKs4x9e1
         fWJMkZNo6moEZIo1gA7L9afONc6OFt51CI65w0wKqR0ubHbIIUYr8yl55v/31tMPZrAI
         GDuClVjRmzE1QeBtqDsCjpZYjt022gutLYkQo1XmQ9pM/SDDuAaPTxw5HlfD7V3j4U0h
         PMrctuLoYywtBIuQi5B3FQ4A23TSdTYrcRA6rwz3wBRTAhRdnlPeiH9eX5odSmf391Hr
         Wy4A==
X-Forwarded-Encrypted: i=1; AJvYcCUUZvXa1+rUFoP5CSEjnDDZodDB9rKYXeDdkzm13TkBQ9cQ4mVnLBoxzgipGlRDew7cGeuD/vAuYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJln20TetvyUoYnmelGoz5kpY0ikCnqkBUr5biqhaNExlM1c9Q
	4LMKt+NHJYMc9jSEcyDlvArb2Qhi+z0TayPuWkCVMnJs2jtD5pnaV43UdG9G0XRBTc8ZLOG7MCA
	o4hn/
X-Gm-Gg: ASbGncurXmYVN4U9bMsKDEC08EDsGV/83U0qUtp2mn6AhiueWkV7kfdqoxHmhBig2ZU
	zzcjejfuwNVzmxtRDYzuCuqBArJxEMdNXzurDdqYu04yC5THknzm07aDkXndImvxZ7KgRJDB6AG
	YNwyDdjs51BLhM0Fgf52h6rAUZE5Hy9VkPzeweIAp3EmcIm0+G9CXYRaQWR0KIGqiqxq6h0C0AE
	tg/MNIAA3Wy5p2FO1IbBycu8W35Cgh39j25qTcOc5RztL4ubKl6opEH6Khp/ixaqJGz7O5HRF4M
	Pci/Rt+m20GHEluGGD379m+gOZbES+kq4IxLOyf34M5tgPMzexaI3AWZyAxQiP051WS8GTFwYHt
	3ie/rV/Uoo0HcskXrnB4uZyMPYMxQ6w==
X-Google-Smtp-Source: AGHT+IFY0exKSpm0+f6H/wzlf9xavbPn8hy9QGoJ0cK7LCW8RzIzjH4Cjwh92XwtseArqsfz0PbY1w==
X-Received: by 2002:a05:6e02:1549:b0:3e5:262b:8303 with SMTP id e9e14a558f8ab-3e67665cad6mr49090925ab.20.1755616290212;
        Tue, 19 Aug 2025 08:11:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e58398cce3sm38224325ab.19.2025.08.19.08.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 08:11:29 -0700 (PDT)
Message-ID: <e914d653-a1b6-477d-8afa-0680a703d68f@kernel.dk>
Date: Tue, 19 Aug 2025 09:11:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET RFC 0/6] add support for name_to, open_by_handle_at(2)
 to io_uring
To: Thomas Bertschinger <tahbertschinger@gmail.com>,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250814235431.995876-1-tahbertschinger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I'll take a look at this, but wanted to mention that I dabbled in this
too a while ago, here's what I had:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-handle

Probably pretty incomplete, but I did try and handle some of the
cases that won't block to avoid spurious -EAGAIN and io-wq usage.

Anyway, take a look at that too, and I'll take a look at your probably
more complete set.

-- 
Jens Axboe


