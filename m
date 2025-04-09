Return-Path: <io-uring+bounces-7444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 070DFA82696
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 15:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 659421BC0383
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 13:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 114E426461B;
	Wed,  9 Apr 2025 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lEKMfWgX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8D72641C6
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206305; cv=none; b=vDXeqDZe1qACqDlQexDcBy6CpmgKRO2twMqptCqCKXa85SqF7QAayFmVDZKnNF/2LgWiAd9p2hDT40g2K20jO9/WjtKZCRlzk7nmeh9saB7tM8O+vgW8maS0ocnihLGvtYg1fNmnrAy/hSBw+x8o32z512sEU5jiJJsb78Sn1co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206305; c=relaxed/simple;
	bh=I0+RkMN85mLtSYpn1afHjnlNUq1mA5OPkEK8ne+Tgj4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=D50K9fU9uYO03bIKKZq6PbBN8fikCZdCwDeTdpT5RvTKbKow5y8X3sIYuVojaK0PpCQOhZUmkkxodWL0Qo5QvOjXQ0CGMkKxATsfjU4imox9q3SPLAhgp9wmw1PZkpUrc01ZMcWaB+2teDGbsnDAAgnq+NMcGCZutu5ReEqXrgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lEKMfWgX; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-85e73562577so553506839f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 06:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744206302; x=1744811102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lVgzzpMBFlGdxRBoNghs4H/d3+gYDrQBdvcm+IYNDYk=;
        b=lEKMfWgXFjzqxCaRnP4y8KHCcRbljlCqZQC2fpjT3seuyPlrhAFngTfTghzqANDmcT
         6LE08aBABuhLzUCJ89frcw7qGP8/nzV+PMdO51jcWFFt4lVqL4xw8RfNRDTawCBadjXn
         ltoXg6jLAUE0rqVZiasWrhBO5Sa8HxobF4HgIjHX6VCdwnaYGehRsFTGS5sPiqwWGVGo
         Wdb++bNTYRmEXfQwCXCJsXQNj2enYiehsOQvGhd+c5JVx7zeJ1FKC4dYTBVYKTO8EfKA
         5w+ljPUDjGKbMXs1Mo9KZpjfsZOBaY6P/R0SLCQWILNho0c1HxUtvum93zbdBPykv1zH
         db/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744206302; x=1744811102;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lVgzzpMBFlGdxRBoNghs4H/d3+gYDrQBdvcm+IYNDYk=;
        b=Krq8A5K6b7nzNkw/GJkhM1g+QCMbUQvl56WGjO3nyf6CyY+iP3tBWQLNvjBRjVl6jH
         8ZnG5m037P8a7Dk7xET7QI2rzrgjnPFxPmrmoEd3KQr8GR9XVi4m7SaY6pFYXaKY1Xjp
         8W4Sswh82RBYCO+bddNcqvuUeuUFuGHg3MdNwmEyCpeTXLfrpLubuMXwMxcOYlZnWD5p
         DicDzEGqcOp+xNDv/SxHsVRdLojRZDmheKqCxIWGiPmYEuovztthUZrX4nr/Lai9isfu
         oKzzh3GsDqXJl9HLvPCVAMP2oM5Yw4UD76c3gAqsHUUxRcAkIA765DadRy4lOgwEOKnX
         NSNQ==
X-Gm-Message-State: AOJu0Yx5A/betoQfKbdR/kOMnR7uc+YAY3BgZWQ+bgRwVmQmxRYAmd6D
	g7YvcvZt7pSb7/tjJDGnSMYcQOTDbPhsLNZhB4oU67UVz6r9ch2H0KNcgHgX+24=
X-Gm-Gg: ASbGncujwQZkCOW9Eqqw7kMLCeNkK7ovZDqMSADNpj1zpo6EkV9+r6dovkqJd6K1B21
	wLbQ8pImvjJjKHJ6Rb7MDvCIg10dow4sSkbPxLvWxDDDz/maDCei3EnbYBDhc7BdsZJwIa12kKi
	T0uIvoX3NPoaCKoYZ5wKgqkzT85mRtRxKVaLgdUhmSLV5T2daVFhHnoObUzyaD8oMPnQJpbdYMg
	0K6a/cI2vJE0c7hIWPZY3Z2leSD7iRgzEI1So4KJ1EJRREN0BeqPXcq5X6mjZ+6lDL5Clk4ILpc
	kLI+UKfuYCJOEOr/vTYnaZS21GbW6YQ=
X-Google-Smtp-Source: AGHT+IFiTW744yQR31UY0rhpGBto1naECUovuYuYXpJIOIkaQppiCgLI21VqIG2/qV/aXwqGxRoauA==
X-Received: by 2002:a05:6e02:2788:b0:3d4:6fb7:3a36 with SMTP id e9e14a558f8ab-3d77c2cbf3amr30048055ab.20.1744206302605;
        Wed, 09 Apr 2025 06:45:02 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2cbfesm240104173.105.2025.04.09.06.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 06:45:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6d1f598e27d623c07fc49d6baee13089a9b1216c.1743848241.git.asml.silence@gmail.com>
References: <6d1f598e27d623c07fc49d6baee13089a9b1216c.1743848241.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: put refill data into separate cache
 line
Message-Id: <174420630174.200173.3793649620674054176.b4-ty@kernel.dk>
Date: Wed, 09 Apr 2025 07:45:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 05 Apr 2025 11:17:49 +0100, Pavel Begunkov wrote:
> Refill queue lock and other bits are only used from the allocation path
> on the rx softirq side, but it shares the cache line with other fields
> like ctx that are used also in the "syscall" path, which causes cache
> bouncing when softirq runs on a different CPU.
> 
> Separate them into different cache lines. The first one now contains
> constant fields used by both contextx, followed by a line responsible
> for refill queue data.
> 
> [...]

Applied, thanks!

[1/1] io_uring/zcrx: put refill data into separate cache line
      (no commit info)

Best regards,
-- 
Jens Axboe




