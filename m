Return-Path: <io-uring+bounces-6584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7108A3DD54
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 15:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA11117481F
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 14:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26EC51C6F70;
	Thu, 20 Feb 2025 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AwcfAU70"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156851D5CD7
	for <io-uring@vger.kernel.org>; Thu, 20 Feb 2025 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740063097; cv=none; b=cMOpyLLaZBuXKSM3SnxM9BnjoMEsC53Sl8co8Uf12+cy2ffb9CDLEgnTTXXqGheG8G5XnLMLghmfb3A9o6YoWNxzz1Xk4akkQaeOZzbz+vN7sxgx0BRhBp/42ie8PkeraOh+njZbEYkk5N1xIt0JsNBAsQ2L9bpT8uteNW6SthY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740063097; c=relaxed/simple;
	bh=3G1aWoHZCBKxjsr/eEd6Lg2OmBOk8NsGZmoz2Ik3DU4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GZUxgndEdi95nSzRLvuPXPalZN+C1IBfN7Jod422bULGBQx3FMOX+OM7bSkA6HfC7Yd7UgmIhO2pvw6leF87ZD6DQrCdlKHnnCzXSQPyPH7XZuPPgA+vSre/AoQ/0lHsXEduhfZZAZKxgvur5HWeLygWeCh9oJTNg9Mb45KLjns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AwcfAU70; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d191bfeafbso3294465ab.0
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2025 06:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740063093; x=1740667893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8x+B4TU1R/TaOWmXY1vZ9LdmepwMb1xawtC/WEbMOlI=;
        b=AwcfAU70c0WSRfH7dWmFWAoSIjWPRoAHifzuO6EiGhcxD23BejWxn/LlNMElihnmyq
         9hsWnf2w7Z9/uNWSSX8nGzszWXvC8Fi5alXJHIgFRVNm2A/LL/43J/XlrkuhHZNqp/tm
         xadZpi426RrV/FLJ4WEYwblAyj7SpUKGNggyLtV4rM0s8zx5iVY9a/TWEvWWr7Ur9h4i
         51PxLqGcUSGc1V+ov+Dp0s6GqybcPRAp+WcvRtp4miAqb2SdOxkMZHbRQW8KdaBecIw5
         T3fDa9am20FPNvTwxltLbdmHC38Gi053My0a2pUD1xUihUIgrqE7/6DS0g4t/gG9N//T
         In9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740063093; x=1740667893;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8x+B4TU1R/TaOWmXY1vZ9LdmepwMb1xawtC/WEbMOlI=;
        b=LZTwSGDQoeI6BE5CpNNOocQ6aXAO35YY88Hjxvm7e6Fh1wjFvqhCdUbPT02Lyb3YYc
         mIoSLIZe/I9/iOF70tgYyOHiTHBtqUthU7KdZsEyo+6xR5X0a0hXsXnHIN5UefoatwnL
         IFKBh9xNLnV040hCl59sHx0EqbFuNqXwxkWB6J9dvYHZ0JspHF68+RKOS1BG6SHiKzL8
         ooxKYLFaVKvTbHRAX6QC3kOIajv0xMmMGakXEMe7ISVbdmOHGr0gE1HwQ7kd7VcBTSkk
         n190ngvLQZMNQmiyw20imRxMS2pLx4Em6FZnwY19PO/2AcczcmWZUPhd3GytWaVLPF+m
         TUmg==
X-Forwarded-Encrypted: i=1; AJvYcCXa33/d3xLuRujBke1P6SULFT9IT4/FyMjCiCPg7Q+Z/j71RILkQBbJaqgW0NgGRdZ2Us3XVxLyZg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzmpwRWDfZ0/jTirF8+CKgZvuEj3vawKlj1COkqEDM31cs6Zl1e
	X/OMq61E7db5FIXoK+vJxQSxDuy66+oGBum7g5vayKgmntnofs0ckt0m2Z1wTtmbrGKSp4UCCqN
	M
X-Gm-Gg: ASbGncs1ljHZD4zbsSreiJoaSTGX5qeV82Hty5om0/KW782NEmkYkxPit5ITodli3m0
	/BqJcpdG600L95y7D4BEvtGSSuXH7siDgoZW390NvRxtS3qIBAEs9mRr2o1WCec7qdO1EZq6jDq
	IDEPtzIVGQKPdFtEK5QGbtIDVcGzce8A1K6HZq9yYj3zXtI9rc0Az9e6jkrA2Ea5l0/xTtXzleN
	c3AS0rOiKYvvm6aOvnzP+IHq0hcMwuLThnuVFZylXY7nqXHDR3yD8QBcJnXQi0di6IeQppIyPkJ
	ZN7uf5g=
X-Google-Smtp-Source: AGHT+IEYYi1lQn/B+HL15BpZFo+i19+r8C+N661N0XWhxq/TtpuIkLpqZt1StiRfiPzIhrJPwPPndw==
X-Received: by 2002:a05:6e02:1b09:b0:3cf:c7d3:e4b with SMTP id e9e14a558f8ab-3d280919df3mr261797085ab.21.1740063093591;
        Thu, 20 Feb 2025 06:51:33 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d18f9a89a9sm33784445ab.10.2025.02.20.06.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 06:51:32 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>, 
 io-uring Mailing List <io-uring@vger.kernel.org>, 
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
In-Reply-To: <20250220143422.3597245-1-ammarfaizi2@gnuweeb.org>
References: <20250220143422.3597245-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1 0/3] Fix Compilation Error on Android and
 Some Cleanup
Message-Id: <174006309264.1672035.6610273505554694557.b4-ty@kernel.dk>
Date: Thu, 20 Feb 2025 07:51:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Thu, 20 Feb 2025 21:34:19 +0700, Ammar Faizi wrote:
> Another day in the thrilling world of cross-platform compatibility...
> 
> Alviro discovered that some Android versions are missing `aligned_alloc()`
> in `<stdlib.h>`, leading to a compilation error on Termux 0.118.0:
> 
> ```
> cmd-discard.c:383:11: warning: call to undeclared library function \
> 'aligned_alloc' with type 'void *(unsigned long, unsigned long)'; ISO \
> C99 and later do not support implicit function declarations \
> [-Wimplicit-function-declaration]
> 
> [...]

Applied, thanks!

[1/3] liburing.h: Remove redundant double negation
      commit: 1d11475301931478bb35f2573e1741f5d9088132
[2/3] liburing.h: Explain the history of `io_uring_get_sqe()`
      commit: d1c100351ffb3483f5d3fc661b2d41d48062bec1
[3/3] Fix missing `aligned_alloc()` on some Android devices
      commit: 5c788d514b9ed6d1a3624150de8aa6db403c1c65

Best regards,
-- 
Jens Axboe




