Return-Path: <io-uring+bounces-10123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81CEDBFD73A
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56E3519A4A41
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E26254855;
	Wed, 22 Oct 2025 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qc/EHNnA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B9B35B123
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761152764; cv=none; b=p8rbXu7sv/sHpjzk8hd3DCIikiUfx/jV2JeYKw10aip5Nl7zVoFiex7vQOQqM9P7VzSc3AxFw2VfQj0vRIw2AMn4Lv0gZBpncCFFyJlFPI72iH4vgTXQMmkE8EfpkatCuJgS4utFwDsMWXbkrXMaWIFuzPtjWqWNEaEtAoZDPmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761152764; c=relaxed/simple;
	bh=NgBRi8tUVN5yYh7DPI/U4uS3U973lRB0/wcmFBtzgUQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kjdfUabjPAlLteKUnY0REXkTtjV2Ipx46DNHwm859joHZ0dlht294wwFrxXwxhxCRCLO8GY1oFmnI+g+q/iViF6u0HWK2aVg+JtAiNreZLYYHPJosUZUMFYPYJnaMyegAy7TgeKZfnaKL/9GmqZ/ksXQyI6v3soGy1OFS4tvGbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qc/EHNnA; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-92c781fd73aso701899739f.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761152761; x=1761757561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsD28wm3nsAnGm5Ka75ENH+2h7LDrDV5IjCCCq827ng=;
        b=qc/EHNnAuDZhoj3m+FmjAyUm/IyLGcvd3/LTaZUMbYOkpcdwaKoRMRsV9czkIpzmJy
         EITLN2tTzU7QGvaFi9sCBHhr8BqfehZY7OpXbtGf/Khw99RqPjMluzW1lw2Xa/wQDxN1
         Fu5WKAch1OqWpySXd1mmjEKwvMXVj346LDr3aCiZXLy8uWIrkG28HNkcuGG3zp0IJep+
         ebjHHwBlOFhgggOI44DHXvWB/aOOqjBSh9/eiu6gPmeiTyZ2EksXALI8sHYSkQlfXPWK
         f1ryYxV4kGli0f12PZpr9+u0ygbvTU7TNuIza1h1YhpN/aHcpasLf+cihEIiMzw4ZX4J
         1RwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761152761; x=1761757561;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BsD28wm3nsAnGm5Ka75ENH+2h7LDrDV5IjCCCq827ng=;
        b=osDQ82VPpHDtFtPfBuPwZSNi76n7/qYk//1lAFKbA3OFbEaP+LvFwngVCqUgBuPOqY
         8+tugvnv+0gqAdY89/dmtTIMFdOq+e0jo95ahian3d6mkwWaFEm2QbWsT+ll8yiMEHwm
         aaAtsCWenOthiehdPrrX04rJHt6yhIQIT6n6GgKOd1C42GTB+IxCOjTXWyekQggWu/1r
         NSln5r3JXY87xwm9dlcZ3waMIOO5H1miZUg1OppaAvHop8IktAp+I73Ltq9/QVDsExN5
         6AYOGRazuo5qC2xciZX2h7F3ztvZScHQCYqP3C3+Vd1MhSTAKmQdwxyQLpdaLFpa/QpY
         LGGg==
X-Gm-Message-State: AOJu0YwEiFvzXdtKRw0SfzIWlEck/aZ9vESzirvecl7l/HVlxU/LJoOR
	vwsrTQjlx/RzTV9dNZrB/2qRLwCnPwWrdp85nUkfm7kgdl8dzWcx8/iVlU8+nQEbyO9cy76Cj8t
	h79mF0B8=
X-Gm-Gg: ASbGnctSSeCkkhpojXRdcCcmPWiD2mJWfvMpP3iDEdpy1FC/Es73dZQI7wuZbHnazjV
	qpGwzwhCVc89Vn8XTX2lE48nc2+9c/UfvrjVcF2Q1soWUveHBuTTkSBnaA0OAYMMOBJpui/S4E2
	Fza9g4kNdqXEXSUlDTbQubL44Ql/LbJ9s+jjeEbSlM5G10HyY8gPxA5/8mznR+KcqGzoq3nkMYd
	2jSKVvB3jAOZrQEQMr8YKI2xVDKq62U6pZyz7EzRlx0pROBCGcAxH3U51uWPeMPxGHS42VSr+k4
	pbYN6z/cJzIzrqqGoaGwtBUyrf4J7X9OOj+uBQxTinzubp4vS7bQA2re4W+h2Hwkjxz5eYu4Uq2
	/zFvNJWyTFdO5HNdacqTsRLQSdKUSuLYLHIMUKxeAeHnRYqj/Id1H7/hVnDBGW9xz/apkA+0otw
	hEPA==
X-Google-Smtp-Source: AGHT+IGzRtJE9jnwV9ZF0g1PKAzX6y/BSm0gYBqpWRIwH+Lt9MCz+RMkrUYLZZb8PO74y1TH49X5Xw==
X-Received: by 2002:a92:c265:0:b0:430:af8f:1d28 with SMTP id e9e14a558f8ab-430c5223e4cmr339162185ab.11.1761152761353;
        Wed, 22 Oct 2025 10:06:01 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a9770b1asm5278156173.54.2025.10.22.10.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 10:06:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, 
 Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>
In-Reply-To: <20251021202944.3877502-1-dw@davidwei.uk>
References: <20251021202944.3877502-1-dw@davidwei.uk>
Subject: Re: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
Message-Id: <176115276062.117701.12360717585804633704.b4-ty@kernel.dk>
Date: Wed, 22 Oct 2025 11:06:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 21 Oct 2025 13:29:44 -0700, David Wei wrote:
> Same as [1] but also with netdev@ as an additional mailing list.
> io_uring zero copy receive is of particular interest to netdev
> participants too, given its tight integration to netdev core.
> 
> With this updated entry, folks running get_maintainer.pl on patches that
> touch io_uring/zcrx.* will know to send it to netdev@ as well.
> 
> [...]

Applied, thanks!

[1/1] io_uring zcrx: add MAINTAINERS entry
      commit: 060aa0b0c26c9e88cfc1433fab3d0145700e8247

Best regards,
-- 
Jens Axboe




