Return-Path: <io-uring+bounces-5727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B57E9A04298
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 15:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB57816107A
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 14:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A14D1494C3;
	Tue,  7 Jan 2025 14:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wwSm6y20"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5CD1F190E
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 14:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736260327; cv=none; b=nYDCcyR1jaZvhM72HhcsJkWKoZiQ1iVdscEVjNgSCvBdQhzvOD+gbvGJh+1zd6NbnaAM89Afnw0xJo0Hpv3xSVyNaWr9PoRllB0Cw3XyhlPdtD6HrIdkHRXn4N79slMy1z3Yai1cfsPwn2bQbUHFChxLIwoOjsBBciz723kI04s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736260327; c=relaxed/simple;
	bh=EwTI9gcVnuBMZMmwgi4Qg+kgB3qukr0/Je7Jwlw1doc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pWdktxtpE1j8nFQ8j7EaBoWK0Uyk/ZuCgFYisn6Okd7KC1G0PFW/0cbQLUwqGp89of/xj0wkWmOFUss0MkfM6jbt/XQZgDaGO3f0GzeNeVhVefJaaXx8EAMWUtrl5MONXCEgC+4JHfwcwwBzVVJM1zdhFrLSV779GqBhPd1mAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wwSm6y20; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-844bff5ba1dso1232350039f.1
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 06:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736260320; x=1736865120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wFdIjs9ss266RZaJ9NRZ2i+XZujTSffS+OMUY6hkEI=;
        b=wwSm6y20Lzt2fk94m3FYcZ/xZsETST1oMLD+yIcYCUu5+myeEV0Wq0Q0yDNPOkDsmv
         F16hrZN1FcGI9/JD64K8xhUB57fc/ji4ogc7eEsLApvXEhmaVGWUOwKbEEv7udFqndl8
         LP0m12vT43lLCVXSdtz2BAJABls4YELmnCVRVkATJXF4oyKLEWCAthkQJVQj31uJq0E4
         ammJAY65kR9hVKk5OkXybxHADX8TEi3VC+NX/pDUA42icI00sFlhaBRl+zZWS27eFBlY
         iX0mf2sRVKd8F/F9vLv3TUDB+T0beVKNESkvxbrlbu70HUL0Aqkzqhe3CvbARYvJ1Sep
         IhyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736260320; x=1736865120;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8wFdIjs9ss266RZaJ9NRZ2i+XZujTSffS+OMUY6hkEI=;
        b=ADkrE4iQOMtWSkzljDWF1Uj8d9YwPxuUhq2oSoSVmYli97b/ztxa3rJfPCNFXr4i1s
         dvzCrWpUzGVeCwlJ1eGyHQEVqwdHDlGCA0K8E9WKKTeMy4xOBx8jB7bjcEP3xIQa1W1u
         SjtTrydRiGIhT7o88YLQEOWlVU/T1KJSAHo8jNtnNPicJYWrsChLIRMIGhVpNiofcgKL
         bgdg6kxxBV2ibP0yZ7RqOcfBcPcQsQ9CrNBmngByv2am0Wgg511rtZdNv0T9uch9UEAT
         9TzV5KC5Vg8cV1JxFcX889wQn4wy2U810cWGh4wJ2fPDxtxPyER/i8FwdorOacW2Eqbn
         HK1A==
X-Gm-Message-State: AOJu0YwRnRoA157J3OYawD8X6VDGjRTEl5zVCu9EzrC/R93W7dQT6pNU
	lJd2QUEmtDDvqwxmxvYwdflNqUSQJrFiMW+Kty57rLsOAVpXRs/qQOH8+8SN6l4=
X-Gm-Gg: ASbGncsBzhnrqP9fYI28nGvAjnfYnURIptC/dNSNRIApgCHAhxMFg1gy1rOzNSaX2RW
	d8JVYWds7dsd3XyFec/0Y/+DxRE083NWCJ2gmkY/RqTN/p0hiuNB2dbG2byc/zMZDRh8z5+tTtO
	tojx3TWO96iXXcfNXLSnYsjI8VWhqWyzqeFNGp8ENiSE9Kgbtgq7Nz1K/4HlkCMdoCAStpdKpQa
	QcCVNbxGohC9LhftGjMzIxtIzL4O73SNbAmEkNqXfD6pGc=
X-Google-Smtp-Source: AGHT+IGCtMXxekydrpOk/VqzXWBKg5FMV9YEm2pbiVRjMODEFeZQ5qVM+JK/bPh74TR3lgfmipb30w==
X-Received: by 2002:a05:6e02:1c8d:b0:3a7:e0e6:65a5 with SMTP id e9e14a558f8ab-3c2d1f753e4mr531830485ab.6.1736260319962;
        Tue, 07 Jan 2025 06:31:59 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68c1e332dsm9973069173.140.2025.01.07.06.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 06:31:59 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com
In-Reply-To: <7e5f68281acb0f081f65fde435833c68a3b7e02f.1736257837.git.asml.silence@gmail.com>
References: <7e5f68281acb0f081f65fde435833c68a3b7e02f.1736257837.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: silence false positive warnings
Message-Id: <173626031901.181565.11287557073803698265.b4-ty@kernel.dk>
Date: Tue, 07 Jan 2025 07:31:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Tue, 07 Jan 2025 14:11:32 +0000, Pavel Begunkov wrote:
> If we kill a ring and then immediately exit the task, we'll get
> cancellattion running by the task and a kthread in io_ring_exit_work.
> For DEFER_TASKRUN, we do want to limit it to only one entity executing
> it, however it's currently not an issue as it's protected by uring_lock.
> 
> Silence lockdep assertions for now, we'll return to it later.
> 
> [...]

Applied, thanks!

[1/1] io_uring: silence false positive warnings
      commit: 60495b08cf7a6920035c5172a22655ca2001270b

Best regards,
-- 
Jens Axboe




