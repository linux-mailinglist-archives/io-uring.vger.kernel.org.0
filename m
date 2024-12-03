Return-Path: <io-uring+bounces-5187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E789E1F12
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 15:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48EFAB2C0FB
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458871F76C7;
	Tue,  3 Dec 2024 13:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oOOtdoCJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254731F6669
	for <io-uring@vger.kernel.org>; Tue,  3 Dec 2024 13:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233334; cv=none; b=ea9PzDqht/AciMI+gk1+j6FvHCZgaLtuEdGuz+khDG/dHJ5qhdTE7825+3luc1rKkRGa6sZr1pgQ54ePxW8+E5m8Hn6zQU9UykaUu8ETfwggvg1AO88j/+DIqZcqiykREccbaInm84PinM1aZUNjf5PPUzu//AVYZMEqJuB/bZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233334; c=relaxed/simple;
	bh=36xPLTAUY/4j3MR36/YfNWQZr3nAE8BYS/fpyZmmhOs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=I0x8Lbx5XXuPO9gQgOcEilIYT9pPgoQgBXdytgpKgS5/HKCMjhquZRmbLxx1wMpChgMWfqdt//nK+evE7BWggr3rgxmBsOoelCnf64xs8rwDo178wzBu3oclJKir53FnapP8meUfuP6r9xifM+CCCFALDBO1MK+2NTiyYyjDYBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oOOtdoCJ; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5f22ea6d645so1819126eaf.2
        for <io-uring@vger.kernel.org>; Tue, 03 Dec 2024 05:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733233329; x=1733838129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w0SvBk5G5le5K/7q79/RVIGjbUUaJmu/spAdFOeFVzc=;
        b=oOOtdoCJmI0Gjl7eP3lzvLOAi3iu1hMCfdWFX1YRRT78Ymtlygy2df+gF6nxJh81Bk
         GTDv/bUEoiVeFvWyLvYy6KguQo04t2KTY5Sv9NAV1yWSM+7vih8E5oxWj0l/Cv5eJSnH
         7Q9/wPWRcbprztBhiu1r47mqghJNRimjdFnP6bVmfXHwVhrIFvjViD5t/5lPVqU5/IQ9
         HlwUHTP9Lg+C7s2RjFXfheHHbjISa1/X3mBhz2UvT3A+mKIamo4PcNvXYZdA+srSJe1B
         OHnuAuqGReLW+v12+KEekHKsYfgkC5ceJQrPO6LGZzIBW3g14LHY+cJOCn6MZdk9MpOB
         4wcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733233329; x=1733838129;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w0SvBk5G5le5K/7q79/RVIGjbUUaJmu/spAdFOeFVzc=;
        b=D8Ewg7yNlGaPqVRj2g0CD4rqRvc0Os5wzA0ktF4vpEKkxEQpmi4hqWM27NFE0FeGMG
         HmRNhkOCQpUrVO8beaHO1cTkMDwPaZG7/9MXJENyWMOxSN7j5N8xR0MzJS4l8Vt+jzWg
         wo2C4qUJyGJpLr4Y0Mw8ag9BlxHDimniZpYHE9zO8L3fM+SWugoSpSU0K3WZXToLpBt9
         GAAyzz+KeQODPIrEGUCtvyoMpMqFS/f4bHispO5wTICizZ76QXqCtAse7gzZZC89pX7S
         xqqp7tuBSEPa5vy5BpRqZWog4OWOa53C9q9gR4s7HQzlZG0PC/ksvkIY4/PabSi1MRtX
         98qQ==
X-Gm-Message-State: AOJu0Yx2ZMwgwOeK41mi8z0FoGJfJV72rlVyvat0U3yDWWHZGGfo6fr0
	EoyW15XVRG/WvcG/pOFtLhCSq6taUUaWKcMBgNFA7PXpvESdM6cpr8auE27bsIqwNH1Y+3k2E6o
	g
X-Gm-Gg: ASbGnctcswqQElt/YnTepgUxwEURhNRqr29iU/t8SnA8Vvl+Hqoq8AlgvWm83aPNDb1
	XLRI/HHLcgDD7YfzaNb1xym7aiKhJX158FDQabJyggqVayWz/TjW+RQEW99+PUdt4GFEyh1jjpk
	QTZxUcQAYb+U/s6+cd3TJYKRPFJFQrgnqo0pKlC/pXeWtBDnjHgu1WxVj3KW7AFTqllMhSeYTxw
	pi/fgpdEqIoLADsYIPg+Nk0gFkcmsomNnWCpN0PzqWWoA==
X-Google-Smtp-Source: AGHT+IHK7p+Wgs7gWgFtwXcFiQ3a7tGFw96+K4ZeLiJyn41akIl/veSD3a0bPNMAPllNfN7Vr8rrPw==
X-Received: by 2002:a05:6820:991:b0:5ee:e899:3654 with SMTP id 006d021491bc7-5f25ad53258mr2698962eaf.2.1733233328925;
        Tue, 03 Dec 2024 05:42:08 -0800 (PST)
Received: from [127.0.0.1] ([130.250.255.163])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f21a4cd86bsm2782124eaf.29.2024.12.03.05.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 05:42:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Kanchan Joshi <joshi.k@samsung.com>, Bernd Schubert <bschubert@ddn.com>
Cc: io-uring@vger.kernel.org, stable@vger.kernel.org, 
 Li Zetao <lizetao1@huawei.com>
In-Reply-To: <20241203-io_uring_cmd_done-res2-as-u64-v2-1-5e59ae617151@ddn.com>
References: <20241203-io_uring_cmd_done-res2-as-u64-v2-1-5e59ae617151@ddn.com>
Subject: Re: [PATCH v2] io_uring: Change res2 parameter type in
 io_uring_cmd_done
Message-Id: <173323332799.59116.14437806909916721347.b4-ty@kernel.dk>
Date: Tue, 03 Dec 2024 06:42:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Tue, 03 Dec 2024 11:31:05 +0100, Bernd Schubert wrote:
> Change the type of the res2 parameter in io_uring_cmd_done from ssize_t
> to u64. This aligns the parameter type with io_req_set_cqe32_extra,
> which expects u64 arguments.
> The change eliminates potential issues on 32-bit architectures where
> ssize_t might be 32-bit.
> 
> Only user of passing res2 is drivers/nvme/host/ioctl.c and it actually
> passes u64.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Change res2 parameter type in io_uring_cmd_done
      (no commit info)

Best regards,
-- 
Jens Axboe




