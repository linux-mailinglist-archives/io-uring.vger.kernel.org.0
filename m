Return-Path: <io-uring+bounces-10703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA4DC76313
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 21:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0C8A04E2405
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 20:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E082F691B;
	Thu, 20 Nov 2025 20:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="A74ZIPdT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730AE30FF03
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 20:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763670228; cv=none; b=E0uosl6Oc5ahR4kVgsigYZnog8xRj7miQTLUunmFOXbfwanhM3cu0NzIAaO6xCaZFdZJBLaMVRLgMnR1vK4cq1Jz0c5bKMCZDwW5Sh1bO15Iu1VKcHiPLf5ktdqeJPcS7wWJbFaUi2JdwpcjY5a5d/p0bmJLS0DkpBig49tPDms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763670228; c=relaxed/simple;
	bh=NNg09FykL2dTL4kTarF75LmLr+ZYxyMKt6mYTWzpwm4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gy/ZlFDMyFOD66yvLKpd1DAvLjUH11n/NC7VKC4h17X1orvoCSqLnO3pKpIcQXUEH/jM8rt6UEHTUHccfJMqFuYd6Mf4qW9Wrd998uZ4mPynzAXuUJMg4OK1e3voGinew8mD2FUplOOhRy5WUsDrO8bIe2HE6LHZJ9b9s4D2NOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=A74ZIPdT; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-948c58fe8c2so51707239f.1
        for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 12:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763670224; x=1764275024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6xJCzUGCk5w0gHrxpDgcLm+4CBGrJBZuZff2cyoD2I=;
        b=A74ZIPdT+MDPdOsjZLLzEIHut975I9BfUxdGOKuDMtu1ibGWE7xFPK403RoFlAH58H
         4zQJl/nzgCx5qFcFYZzBatZ3c2XKI7f2ZqK3FkjSYwO69StJK8UC1eBfBfZy8ah+/pnT
         HePunyqrGyD5U7hMkI1nDBZDyZYcjNFd6rJHOQvsHR2fXaLJYxDaZ3mFxbZSpzk24rSi
         rC5HYeYqaaVkNY9k0eOWEM5TdhMzYfMZdemV05DPeDXyJI5AnjcydNgZG7WvdnJRqwRi
         tkKEhLLmRVAcYMgLyTGwACxsRTNOw9WF8EFOU3dvzpOmdTI+rFSNIuUedswlgb9p14u8
         8XXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763670224; x=1764275024;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/6xJCzUGCk5w0gHrxpDgcLm+4CBGrJBZuZff2cyoD2I=;
        b=TgLlJb6GIWXQUAmG0+mAsy0RSmLco8p1g2FNo2SFZNudw7s+lh01yp20ku7+247h0m
         NgkFIA61r6ObHe2YU0nGD1Zz0nOHdww993i4XE6JVzAWa7yIkPjQt04u7bWPZ9f0C8t2
         1NDKFJ/Hz58PMdMaRI92daOmgvgUCsVGJOYeXyRQcHSzldgburoltOCvNsAN79fK8S2s
         uyCwN6mx4zB+RV66BCoUJhUd70qcY4HzeTCdsB/PKUQ1EcsFIaP+ggT//oKs70wpOQ/7
         zhX+Ab6y4Yjxm7ZJVWscQt3vh9D9DxJ3drLzQBcsKI8byupWafI5oEu7snJDUfffqCef
         iChA==
X-Forwarded-Encrypted: i=1; AJvYcCWzziMShBDUANF7ctQBeo+ikGQ0+yIeW/k1I1evbJRX72zd2R1i3AcPQMLmkyIMVewPPJUi3ZV0sg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv6udCrFPm5v3/JI70AmU8uWHj5WKc4WayGIdyg4zFpu32Xd6k
	dR+x2wZM6BmQsaYzDKJl8n4HhOWIkaIINbRk4V2X8u7a/bUiVK3gPLhRcQ9qLGLaFGIo5ShT0Jj
	9fHuh
X-Gm-Gg: ASbGncvivi45UgqTvB1g99ihT8fGgFxLYKIxOSNv9Sa0pYbixqGuOayzZ85ySlhNP8i
	fnsGbQIZYEIVxzqP/dnncs4nFGsDt34urGKEhe3eMWzMeMitpOsP8tiB/faIcS/UBdKMwjKfdyE
	mqLGFoy2wkPtnKUlKLlD2wdWsrwOpwW1rlunfRXJ4Bpp9P3btczRwWTN4KGQv3fdfxfdzkVm5lb
	Kf0B3+bEVkp+dfC86i7UVvdKdNqWzRor2ppc57KBUGG+DdyViVDmYEf1K8Bi57uJnac4WFDI5Fw
	wdYtAoWpMM2cxssfUNq4rP7/w5tQtC+VNZ/iP8DhE9jIlCIf5XDU9CSbIOfVWnuGQhPFbvgT0Wl
	uVtbDvGdE+6q8ngqZcTdvtEi2dmKGNVyy5MqhZGehl0l8qGyf6IBtP5JzVkx6CUknVmW2JwBe6P
	v5RF+fRDv6PqyB
X-Google-Smtp-Source: AGHT+IGEfwlIgsPN2fZDv5SXo/Z/hHWnXPS8hFMYFpEc8LcYGtZ6p25J7Oj3qGXhxVQbnsENaTnoeA==
X-Received: by 2002:a05:6638:c714:20b0:5b7:3de1:e1a5 with SMTP id 8926c6da1cb9f-5b958b5a762mr1941824173.1.1763670224181;
        Thu, 20 Nov 2025 12:23:44 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954a0dbaasm1333842173.4.2025.11.20.12.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 12:23:43 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <20251120191556.3100976-1-joannelkoong@gmail.com>
References: <20251120191556.3100976-1-joannelkoong@gmail.com>
Subject: Re: [PATCH v1] io_uring/kbuf: remove obsolete buf_nr_pages and
 update comments
Message-Id: <176367022337.632015.7469866373466220671.b4-ty@kernel.dk>
Date: Thu, 20 Nov 2025 13:23:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 20 Nov 2025 11:15:56 -0800, Joanne Koong wrote:
> The buf_nr_pages field in io_buffer_list was previously used to
> determine whether the buffer list uses ring-provided buffers or classic
> provided buffers. This is now determined by checking the IOBL_BUF_RING
> flag.
> 
> Remove the buf_nr_pages field and update related comments.
> 
> [...]

Applied, thanks!

[1/1] io_uring/kbuf: remove obsolete buf_nr_pages and update comments
      commit: 84692a1519b32d61ff882cf24a9eda900961acad

Best regards,
-- 
Jens Axboe




