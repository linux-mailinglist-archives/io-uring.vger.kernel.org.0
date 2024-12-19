Return-Path: <io-uring+bounces-5569-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A1F9F71A9
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 02:20:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08EF21685F3
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 01:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49DFC41C72;
	Thu, 19 Dec 2024 01:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NTrMBnPH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2277520326
	for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 01:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734571208; cv=none; b=diTYSRUjeu8WIXDRmPgbToQfKmFXcnV6G5C2IFsjZ1aANkCgpCgtZ2lin06MvaEq4WKsHYGhVSJG7+kWkBrBrpHjL0IbFoM+qQUsd3w9Gnkq5lmrFaFc2jQ/nyYHm9AfxgTuBtG9uCsmiXvxQSV7rX1lQJaeJ0U3zlcVj4E7EV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734571208; c=relaxed/simple;
	bh=75zpHAYNNqaRd8aaNF8sw9oJd2zCUlOTXIKcoWP+MKY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rfDfiEkdia6x1qZig/4UxAx4yIFnNjMhbcDoF1UaK7HbRjWHSKjFjs3cYCzhGKzWq0fzOoS6AiH4KVgw2FQYAW+vq/RM0tNN2is/iP+GNr6S1x37v6EwEvdYJ1tM+/+MwFXpdDMk+teS7tVFXMaIsv8PDUIDDMf1gX7qLSaOcRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NTrMBnPH; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-216395e151bso1922705ad.0
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 17:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734571204; x=1735176004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+DOnah1GMsUpAPjPp+7YAy+E0nqFBMmLEVKuZUZxK4=;
        b=NTrMBnPHOIWmsOm09nwhr00lnrq06ImRmu6l9CdIjNCg1NTUVZefPhTNDGxpUn4lVF
         DvPJRubAa25oe+L19RFw1KcTxU82wLw+6+QfYPheIZwreLeqlO1R7zZLR76JffJ/Txc4
         7MaoaGcZoLKir6yS0TNxO765uM+MHxg1k0mhXK0W2HDlygFya/DK7KhsRF+0EGAHCW42
         /fbtLugfFNA8OqX5FbWbtAJB1R0W3vRWGivHTvQ08QS2C/VOW7LbnyzcKbrv1TZaPd3t
         3iDeYNfYqAaxcE8/6pwOig1mXsCdZsiRPRpXbcVX7YothOsaCIRIiqDP1z6dPeubkYBH
         S4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734571204; x=1735176004;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G+DOnah1GMsUpAPjPp+7YAy+E0nqFBMmLEVKuZUZxK4=;
        b=tXQqPWDZ03fn6EBwPAZo3PwxThzBA3UGamDAd91EcYyavKfgru9wXOBJsrnqMBmOgs
         L6wvaOYZqV66IXz9F3qTWDwJeVV+Vj8cJC4lXNqICarR1f/T/8kPZy+52DeclxXHTkjL
         yLlo+/oyTDstdQX52RwHBZ5memZlgn7Lyu1UrSnce5pwQ8x9Vk6SfEqZzmsb7+X2RW+j
         k+KZrmMNpcKKYEJFXaZi0NrnYvXVh1nxheJe1n+rHt7uTaUh5jbtWQTaLxtpxqLLRXry
         uL7l1MetnOkg5YSP8ex6ROZc6gPQe+bR9xVzVBWFQDcCAIGI902dc+cdegVlhsnPOkVP
         4Xow==
X-Gm-Message-State: AOJu0YwvSdzguaCQuXYBEt8i5JnemDyQAc53kMHBZSrMih5MrakRwmDA
	qqhql3/9hHqrUQqhnt3/eu2S2D6BLYq9nOOssLa2/lqj5JRFr1xKqc7RLQ51lLA=
X-Gm-Gg: ASbGncugAiTEhycXUoeMy75+0DlOEqW1hvDNLyE3QSAKVbKe7zIVrBpUQgBbottct+q
	oz8ghy/vTBse1icVFJcORl5jIPpiDpMhl/+mjfpNLV2p46EGtPte58KDIVHn6ZeJHQJoJPUhVM+
	xZ+V56eu0WitPqCZa8OD+7gQbStp+pcae1YsSX7r+gXTzzYQEbt9h5FaI0iUxwWeFjXxumkRnE9
	e9kjcy2WPLJu8y4FPxssRgYXD0JxF1JercX5Dooq9yBdQiZ
X-Google-Smtp-Source: AGHT+IHTG/+j0zzNohECjV/Ng8Bs7duXDHt4qA34KIIPFKFZVDer3b3BdqIAputJTK5KzycIRQRP8Q==
X-Received: by 2002:a17:903:11c6:b0:215:8847:4377 with SMTP id d9443c01a7336-219da5eb59emr23753595ad.15.1734571204449;
        Wed, 18 Dec 2024 17:20:04 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc972251sm1668765ad.96.2024.12.18.17.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2024 17:20:03 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20241218-uring-reg-ring-cleanup-v1-1-8f63e999045b@google.com>
References: <20241218-uring-reg-ring-cleanup-v1-1-8f63e999045b@google.com>
Subject: Re: [PATCH] io_uring: Fix registered ring file refcount leak
Message-Id: <173457120329.744782.1920271046445831362.b4-ty@kernel.dk>
Date: Wed, 18 Dec 2024 18:20:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Wed, 18 Dec 2024 17:56:25 +0100, Jann Horn wrote:
> Currently, io_uring_unreg_ringfd() (which cleans up registered rings) is
> only called on exit, but __io_uring_free (which frees the tctx in which the
> registered ring pointers are stored) is also called on execve (via
> begin_new_exec -> io_uring_task_cancel -> __io_uring_cancel ->
> io_uring_cancel_generic -> __io_uring_free).
> 
> This means: A process going through execve while having registered rings
> will leak references to the rings' `struct file`.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Fix registered ring file refcount leak
      commit: 12d908116f7efd34f255a482b9afc729d7a5fb78

Best regards,
-- 
Jens Axboe




