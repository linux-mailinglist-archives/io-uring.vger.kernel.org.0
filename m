Return-Path: <io-uring+bounces-8120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5DEAC5C3B
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 23:33:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A50F81BA17BD
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 21:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E7512B93;
	Tue, 27 May 2025 21:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S7Gg1j4Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADD51FCF7C
	for <io-uring@vger.kernel.org>; Tue, 27 May 2025 21:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748381622; cv=none; b=iZRt9g5fhdv6owOGUF1AmAZF+ZmNo4dEeo2cHNAAT16uiqikyWrhP3tVNsz0Q3zmwwUq9eHKitgzDFU/N7XUv6ronlEiDjJ/57UbA+xcH5XvH4nCGriRC2TA+KYWKAn9n5j7/PLKAq52FBA5oTvmMpa0P64jXEesNrok051jahs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748381622; c=relaxed/simple;
	bh=I48a7DkZIna+YTKIJ/XRWdsEJvl09+6Kylb/YxYKCys=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=k5bHeiRnqLcNcRtTrEn+033Ub7tgdTSCOL3/zu2dcZdnlo0JSoCBWjQxz8BcC41K1utlowD0MR51Px6GTAD55o8G53EIArtN0ASw1uOuJGmQgnkEL8mxxD236DvB3R7dytm14AHf81GXyHtFG+ZQrPElS3P6O+ObEGTRbdeii/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S7Gg1j4Y; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3dd81f9ce2eso1031725ab.1
        for <io-uring@vger.kernel.org>; Tue, 27 May 2025 14:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748381619; x=1748986419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rpr4IzVmA6Oq7C9YVos+KElXKBzlwH4LQarJIe4GWlw=;
        b=S7Gg1j4YD6b6qZ+fC9DOC4rGmTS9nDcie0cJf4U0/86jqqOP99Tc4uhDguac0hPPSV
         CGKGwyX4Qf4YFnPQzLWC3IvNpCL0GLhYicNxb+MEpoWIA8BtDaIcrrKEsmZQzf0tEMXW
         b8n1iPv3MZJrrnOBxTaXBPI8s6ITWaWS9uK+MNYAwqut1TxdIQoRQSKaJz4PtDbHA5nD
         dMp3FbB5FNqF2i9htx7/0pNdn6j/ylR+cU8JY+yJytgZUeK2OOcmVgz+afdvPhEi3k8q
         IeNhZC6c2jMk/aXs4eMUxgaUBXt0mm+ytUjLuMPLy+LWfCd10t9pErYJbOBwaV/VfEFa
         IhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748381619; x=1748986419;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rpr4IzVmA6Oq7C9YVos+KElXKBzlwH4LQarJIe4GWlw=;
        b=sUtlQQFoeMdLhJ9Q+WjCod0fM0joyb6wvlDigRPnF1LEXkRDePxpWk27/Nbb3yS6T9
         yczvyNwUhkisftNR7V10Igs/etsr+AGEQDrNEL+54kGhwoXGbEJhhjAroxZ+TOzBgGvC
         f7wi0cDm9TZKCbbBktX2qH1yPp7ETkLXBX8QeWc7rb35AV9avhOKcAQzZqSJSTGnXypJ
         FQa84zh1FQYO0PRmivn6rr4+i9GudSSiBmvrjwXZxuqvYptZH9K+72D/LCfD/ZLjVbKf
         u3w5IjZtLKwkE0CsJtJFzfXZjC7GtR3H7+etzl3D+zZ9jjz7tXcHubWuhj4EDP1f7gfi
         QvwA==
X-Gm-Message-State: AOJu0YygO2oi6NAf5QFvmG9/kcoRo7AzchnwTJ3x7S5Fb4W7xIJiiOYX
	vsZxV7VacfFPg9EwofJgX+qREr2X4+ICFBtuv3SyQGssq0znWMOa13ajxF//5+e8WeGCGV2DLBS
	0EBe3
X-Gm-Gg: ASbGncv7FY0iuc1GMMVnr+HucPXckoKYj8eoXbRWbuENs5U5hm8yIMbzQk5RAo6Wyvp
	xnuO52ftulObZRpvDbR4j+9kSstn7xLWlD4k9FGSkPIhOG/5SdmKtyQlAUbI4TqDE9+7NidCglo
	cy8txkhd1UjtQeYYFHBxKJNgtU3Ut+sOX2d/RJMt5Vx7K4T2LJS/gy8obqF+bE0WF1QhzUtGPpr
	NT5pmbHCZN2QOsZIbAth229TBRw/9GXVroigV41irOxcZi19Gxhhr1xeZOyYMsNprDNd7UFXvUz
	O+kgawJnvo99fiwPPaP91WSiI8yiVHvgfsqTlQRx3AdhIxwurRtNNg==
X-Google-Smtp-Source: AGHT+IHLyBIinED2iQF5/F0sLPIfCzufzLP+sGl9zQENrcgFp6xaScI7gN2AbLBpZ4bhh1Fcp9C0ug==
X-Received: by 2002:a92:cb50:0:b0:3dc:9b89:6a3b with SMTP id e9e14a558f8ab-3dd8767decbmr20998525ab.8.1748381619085;
        Tue, 27 May 2025 14:33:39 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdba6aad3csm51105173.109.2025.05.27.14.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 14:33:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bc02878678a5fec28bc77d33355cdba735418484.1748365640.git.asml.silence@gmail.com>
References: <bc02878678a5fec28bc77d33355cdba735418484.1748365640.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix area release on registration
 failure
Message-Id: <174838161798.591887.10954975649074067213.b4-ty@kernel.dk>
Date: Tue, 27 May 2025 15:33:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 27 May 2025 18:07:33 +0100, Pavel Begunkov wrote:
> On area registration failure there might be no ifq set and it's not safe
> to access area->ifq in the release path without checking it first.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: fix area release on registration failure
      (no commit info)

Best regards,
-- 
Jens Axboe




