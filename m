Return-Path: <io-uring+bounces-6367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1099A32E49
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 19:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DC23188A6C9
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 18:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F1725E452;
	Wed, 12 Feb 2025 18:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IEwFdSHJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F83260A3E
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739384207; cv=none; b=mB2AWrxPcND+E+VuYKvtmZ6LaLscKDBG/2lu78I0qylYQssiixj6uEAfhUOikB6Eq4vr3dYv3dAsEyJoX21rrCNoSlKbZYpT+jDecX/9EPyxyqC8NXq2vC2EeJU3onSatfTQpK5kCb0F+wGQQNGE72FQ+0X+D2oR2ZtF2BX3Zgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739384207; c=relaxed/simple;
	bh=nxaghZtbV8iPMZqQbj0tMPrqCnay/4K4HwCIcKOe/Xg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EUHVYS8Zg/hqw+89qkUYQrKE1RaDQ0rX7LKWZbScaFsMYpY1xr/bL2Z463hTEedheTDJkX8cDLLn4Zage0A+Sb51jGFMu4bP07ND9myu3CRYGmG9z56Qu45ThZByEFXF5M7pHs9dUFNe6j5K6XpbmY7Cokhol46DkjKuogSQgiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IEwFdSHJ; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8552a15462bso772839f.0
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739384204; x=1739989004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bh1w2AkubS48pkWRnoVHrva30bRn2+neydxUc1lOTos=;
        b=IEwFdSHJSQhmZC3K0QWLQHUS2LC+/25+za3ktod/wrRo+hA2xHEadNnMtnt8t6d9Hg
         x5hPdzzhezUM5X1O1dj/Cdn/rtsB8g7sWcbDsasPrsh2UpLRmItaQs9RNq9vUJ9EpmTA
         ueEYuSZmmt1FUXWOtvfBLagFdvBmOB4T7fvDKxz1v/DVaIvEKm+EXzRh8uwRH9o9Xqp4
         L4YbTlFp5o5QZY3fNc5q43bDRM/dsI0QFq9MNKa9ofKtg7o/yjnzUfzjZvEKzT9UxPFm
         HudUI+0fRUSg8DSSqxlBFgzX8BH6EBCZYFHyZMOY31sPLZW7khxanYHh9TJHg7Mt1QeJ
         OmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739384204; x=1739989004;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bh1w2AkubS48pkWRnoVHrva30bRn2+neydxUc1lOTos=;
        b=pqC35O+R3qM97B4mlcixP/lEBQsIhnLBamWZamnCocBFukSU5LVVpl/yp+aUiw2OBr
         4km25J+RCCjTjBDbN9AYX95deUXCw7WLQCM3c2JBLKQFXEHjbmHfcbGQ6lCv0JPlSjVf
         3Sjqx5AVtANsxrMx0wVTntHaydzyUTphiYcWWoM/CuO9SOmdJybUcmaYb+wtLaPZow4Y
         Z6q1FQsc+zElN7qZS5/ji7dJ8CWCInUnD8S/G50hfn8CvgAm9Zm3GrjWeED17GoYf1Hz
         qwTgkkxPY9furz2pA7m8VCog6L+mC5hJG49hP+h6Lq9Ai6SM1qtBDIP04S8Nhmf9y5Z1
         haDw==
X-Gm-Message-State: AOJu0YwL6pOS0hzOjakQWvy+qxF+TtU3mjI48fSrtCFs9X04XHKklJqJ
	vCmHZj/d+3GI8heZSrXOq3Vik+3rILsXs2gn8Zu6XyzkF/DicBb6id08zv/H8d+xoX11GkHDtHf
	v
X-Gm-Gg: ASbGncvEAsAoCCdoZyom08sEFtcnt3Wd4vNBAitbIiwvp69uzZrlpG3fHMZf0ij1+Q+
	B83A5CmnfpOF4RivusozxaDfWE9RRq5DfQeuC9nZBnlaJbUiCWML4nATlCBceMC/iepG8mCbkb1
	yUk9oPfCee8aYEBnHg0LGX7p9dAEl47Lot2WsnnIHTBAVYYxDYfpjIlMq2NvhKaUNr8UMIVPXZ4
	lftY/7b9AMJq2glL+H1pULEkiS+wX6QQXgwd5mBG73j57bBkYNLVChyraI5NptiTFoJH8E5w4YJ
	TRazIw==
X-Google-Smtp-Source: AGHT+IGwl3dQNpzDSqvnGXuUMLAOcppzXS11R5szrRHNzSQcgYf151afWBfFZyDrC3S06SX3T1C4Ig==
X-Received: by 2002:a05:6602:3f84:b0:844:b6bd:4b35 with SMTP id ca18e2360f4ac-855577946f3mr345091239f.0.1739384204692;
        Wed, 12 Feb 2025 10:16:44 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854f666ba26sm328049439f.14.2025.02.12.10.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:16:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250211202002.3316324-1-csander@purestorage.com>
References: <20250211202002.3316324-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring: use IO_REQ_LINK_FLAGS more
Message-Id: <173938420370.36938.9943547252583287992.b4-ty@kernel.dk>
Date: Wed, 12 Feb 2025 11:16:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Tue, 11 Feb 2025 13:19:56 -0700, Caleb Sander Mateos wrote:
> Replace the 2 instances of REQ_F_LINK | REQ_F_HARDLINK with
> the more commonly used IO_REQ_LINK_FLAGS.
> 
> 

Applied, thanks!

[1/1] io_uring: use IO_REQ_LINK_FLAGS more
      commit: fddceb353d686cf377d8b630ff6e3cdcb69ef4fb

Best regards,
-- 
Jens Axboe




