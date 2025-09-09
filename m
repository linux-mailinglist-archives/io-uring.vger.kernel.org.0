Return-Path: <io-uring+bounces-9664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7ED1B4FD7C
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 15:39:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1E3F16DDA5
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 13:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08466343210;
	Tue,  9 Sep 2025 13:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="t/q64CUl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADD13375AE
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 13:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757424912; cv=none; b=eWrImsL3f+RHJIsgce+9nuix1NcasLk7m+8L9BU2G+ueIwAYURkakoYdVx7svnaHzV4e+/ND/V3hZ+8FFT9oSbQ6sZMletn83UDDbG2z5ED7gy0CgWOYTD63qU5ea1m+eR80hIxSWVUxf3nuCxigUNcWEiEIuIr64MpcZ8eszc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757424912; c=relaxed/simple;
	bh=0GySI8s0uwrV1hGtS7+LpGdYoB33k/6ufezuMNnALcc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YVX6/JMvmu3UekSjjKdF8yi2KCAtOFnrNXlXaiMn2F56ownY2xBXtTrM8lDd8Jv6GzXRXNgVLnx6GpqFDGFzJmbzOoBzigggJGgXLTDCxW3KoE2+5F0DC4pCjqML+/LNwRnxK5GiPg7Qlp/YSMdzy3lf5G2rjPkalN537ysqt0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=t/q64CUl; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-8877677dbaeso70335539f.0
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 06:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757424910; x=1758029710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91VEMk1sFfOijh/hYnCmgtoVp/4AL0xjKu6h1vpW3GI=;
        b=t/q64CUltJgiwgcP3jHR/mLdhQ3s2R0XmqtXjwhmw89RSJqBOCLTGUdDPR0iq3SIq9
         O9GygxbYw/bJRHAfjQokyKt+xC/ADyM6vNDTSJQCN63B/o4EN01Gvw6yJR7cN0G3+KVp
         y8Z/kryUFcJoqIUsbOI4+L9adDHT8/A/5GzXkBAAdpJ1l8uOIIFd83W379if/Yp3RQ0F
         R6psk88p5iMUNMNrE0xdE/LnTqylLWWCUGImQxx/2QmwwAlOxX192K3jcFV8XfTDZk3D
         VWqS2uZNeJULSeYPPBPrenUWQJgxD6Y43L/pBE5N38tVn4njGS9qtUkO+N50+vcFXkdP
         5m+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757424910; x=1758029710;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=91VEMk1sFfOijh/hYnCmgtoVp/4AL0xjKu6h1vpW3GI=;
        b=GITcJ4CPx+BRGQTKX2qiia9NMS9j/afuijH2yTyNagIj4Mc9MzeQfIktGVQvbC60Ra
         L6a7Gg+UcX8XNpfsBDXCpVJgpXkMOUwJFjp3C9rsUxjQE97bHBcItMLk+CusWQrpiVKp
         6aneJ3ksKzUk26Xt5k/Jd+TWjKLyUOGAb7mn5un+J3JQQxQeB0um0K9cwST3a++Ksfah
         3vBTJ6okRHDbxXRd499RMXFlMurV6WiWnxFDpe47MTZfb77s7VK5WwZIseYEfeP8Gm0i
         OeZysnaNlD+v/L6l/lFFEqHyT1eWTjw64MMpwEk8R8hT/D1OvDz16cfIPWfipSqqXV7U
         n8Fg==
X-Gm-Message-State: AOJu0YyvUSovjhEJVPqo75BRGmoInfj3bZviECWHhxUVzmnkLSC+C1MK
	PmWmELe6IO8BG7JmYya0hsaB4GmQfUa0olrgg0n0U5GtYz5kxc5r++8ZaPqiX5PiUzA=
X-Gm-Gg: ASbGncsHkxQbsWRJJCjWng7I/NjLYBPFjKyCAMmmxxHAES54W+JwqH5wu53+lNV/8qo
	ntZ9dwSmgQGrGsFj+XGz5X4p+7os+y78sTxlJvtFopRdDti2d3M1s4OtoW0S8Zxd/IKYr7HsyOb
	AKSw0jka1HDOo1lWlWzUDIIwDGO9y7F6VAurCK4oF9DCacqjNuTSPhdSb2mSjQlUfxsxvB+S3Mf
	Ceb6YD5lrpVxYGoTmhxOL+znnhIFyOjU9vWIRAWOvR+JUowf81ReGVhZbQB2FVKOmNScpLV8PoZ
	lPei7XMmSWBNSUbSEB5mGs8YoWfTVCs7Ra1NuCARFKsSVKrEKzu2MuZrentICybMj7gbh9zoYg+
	YkgJwnc+NrnP95ub4Te3ZyDaX
X-Google-Smtp-Source: AGHT+IFBZSrPB2kXk+dHxClCODH7SV3vFFWuaBjUmLycLqklhqrG1sLBrZU038RkcnSLpfJJElR64A==
X-Received: by 2002:a05:6e02:218d:b0:40e:de9f:28ea with SMTP id e9e14a558f8ab-40ede9f2ad6mr42285195ab.19.1757424910342;
        Tue, 09 Sep 2025 06:35:10 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f31cc59sm9880910173.48.2025.09.09.06.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 06:35:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250904170902.2624135-1-csander@purestorage.com>
References: <20250904170902.2624135-1-csander@purestorage.com>
Subject: Re: [PATCH v2 0/5] io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
Message-Id: <175742490970.76494.10067269818248850302.b4-ty@kernel.dk>
Date: Tue, 09 Sep 2025 07:35:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Thu, 04 Sep 2025 11:08:57 -0600, Caleb Sander Mateos wrote:
> As far as I can tell, setting IORING_SETUP_SINGLE_ISSUER when creating
> an io_uring doesn't actually enable any additional optimizations (aside
> from being a requirement for IORING_SETUP_DEFER_TASKRUN). This series
> leverages IORING_SETUP_SINGLE_ISSUER's guarantee that only one task
> submits SQEs to skip taking the uring_lock mutex in the submission and
> task work paths.
> 
> [...]

Applied, thanks!

[1/5] io_uring: don't include filetable.h in io_uring.h
      commit: 5d4c52bfa8cdc1dc1ff701246e662be3f43a3fe1
[2/5] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
      commit: 2f076a453f75de691a081c89bce31b530153d53b
[3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
      commit: 6f5a203998fcf43df1d43f60657d264d1918cdcd
[4/5] io_uring: factor out uring_lock helpers
      commit: 7940a4f3394a6af801af3f2bcd1d491a71a7631d
[5/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
      commit: 4cc292a0faf1f0755935aebc9b288ce578d0ced2

Best regards,
-- 
Jens Axboe




