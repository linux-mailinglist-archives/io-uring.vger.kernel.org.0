Return-Path: <io-uring+bounces-9558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2927AB42D77
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 01:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B235417963F
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 23:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04852E9EB9;
	Wed,  3 Sep 2025 23:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aZPtmu3P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5561C27FB2E
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 23:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756942579; cv=none; b=H1KEVkOsvPv+4BPWCzrW3f9MXq330DhXYG5j/ShmGFpDfrjScs7WX9FDOYmqWrzFJo8+38rZMm9rjx3hAEprPzFTsxXoYuyaCvPYMyxYCuJ3+iC72wri8IMy/yJ3S2VpOTKKuBNOJPxF4SNtzmQb6BekPNZ9egxMaOxs1i62efc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756942579; c=relaxed/simple;
	bh=/t6Z8H3NwIy8+S6CNXWoHvLmbi8OygDmjfDTRxG96hw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pwaMqHdxNzXW3mqaKLsX4Ruv0zYcrgtiAoqj8JtPtFh03q118VI0TCCC96K53nlmF07L2Rilr+QiIQtrOyoQvLbx4dVp0kHOrJzJLqrtQaEK1xkKNiTwhdCsi64MzFkw5OojIOSHU2uC2YtX55QStj+yd/3LjhWGS6QmtzqxvRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aZPtmu3P; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3f2da50ad46so3025515ab.3
        for <io-uring@vger.kernel.org>; Wed, 03 Sep 2025 16:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756942575; x=1757547375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cKyoKyOWhMjBIlCVXOKYQHN7v5fEeRS1w1QnVRDSW80=;
        b=aZPtmu3PciXWGAMTCMVrMWOpMoUMOG8BXZbOh4iha/CG+S5mZaX7VZ75ZS/l6+iknZ
         qWpMOGd1nyPxo1LXSiRNF5XeMJM2nGkiIRELHSZqjj9NfbwiF+nOhxDtU/pKLBeb45aP
         4KG/No/NHyhz/b/1opnnQ22R6fEkzdOFC+cXx5zbt1nB0SKIYusTd9oSFyABDX2rmvVv
         79EpublwtDTA3RKA3NxGYDGa+zijrl+BuP4mpZDpkyfU01IS7Hkzll1oTuWrxxQZFmAA
         KJuQQ6R+JciYgFJCcRMb3e6QHrtXk7AwMl6H4Zgvi8bsVV2lf8Ttftg41OHKdIDsbBhI
         VJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756942575; x=1757547375;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cKyoKyOWhMjBIlCVXOKYQHN7v5fEeRS1w1QnVRDSW80=;
        b=giil102wiMpTfpog4OdImU2TVdSJ0yYhL5XUM59Ou9sQ8eNgyhXXi53Uc4YFw1bFoB
         blr5ZZwDj0QlYEpspigzXDFGaZI39w89o/5ur8ZX5Wu5YEH6aB+CGkiNBk2Q/AcsurPf
         NnBLkBf5JkwzB/T5ByBkfiBJBkF0yP5F/Uwks6k8+g1CGPDuvJFMTg3Mj8M3cRYUDZEz
         X3spfUARZxfxEbzaIrSlWCZYzJwHjPUJD4FCpbR+NlJKfQceDqmvHa9y7IwODSqsbmr6
         zdDhKYVH8DtmHQZW2r5oJFlrqnSf9asw6BbfYn/eSrgL/6cf8iqnQ+2qdhmrwT4I2Nmt
         OdiA==
X-Gm-Message-State: AOJu0YxRggfkCbKcVbEpCzhQZ/TY0x2p7y+B8lxHqRkP/g4Gib4/QiAH
	cfaD4DJz7xVaqoj8jMiLrBt9mRjT9S/iFambkGfrkrvgYXk3Y0uWTuvHAu1DP5lXfxU=
X-Gm-Gg: ASbGncuSBhrnhBIo02bFTMzJnHTWpCFvvuJGI7152gaT5ONIhm4ZeMffv4YswMb2yo2
	Xru0FdGQ8dgei7V3nCiY0qBk/1JhLS7GdJm1rYwDf2qNNOQw3eeoljK8SMoObhiiJMmkTyAcWyz
	+7pWaiJvk3VKHN2vtA973ZVzI1tIUPoPhqA4/kL/2BG+0zV4mzpipmNKHreZzTV4LgWc8NZw7PS
	oYC5z9mWLUbdpdM5cekyeKRHoDy/+Og5+5Wf9szrHTmSb4XJzknS/RHaJrOomIlO3gxjFcAW2df
	kIGJmlojNT/F5DYaT+mom4k+v0Kk0NjXMc0eFt9VqDH0jrKkPsQM5Y3jAkLZp++M+A+OXtsJsH/
	uZYFlxTkh5cyoQ4w=
X-Google-Smtp-Source: AGHT+IF6+G6saPF9kCuvMbjVeIKCT3IGhTmPxGde3S/UR//Q0XlxEXkXnUpIensCY1zh9nCpxhW8AQ==
X-Received: by 2002:a05:6e02:2165:b0:3e5:51bb:9cd9 with SMTP id e9e14a558f8ab-3f400674ac2mr320132505ab.8.1756942575459;
        Wed, 03 Sep 2025 16:36:15 -0700 (PDT)
Received: from [127.0.0.1] ([70.88.81.106])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f65d1ef2c7sm18736855ab.5.2025.09.03.16.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 16:36:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250902012609.1513123-1-csander@purestorage.com>
References: <20250902012609.1513123-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/uring_cmd: correct io_uring_cmd_done() ret
 type
Message-Id: <175694257428.217330.16494503569202102693.b4-ty@kernel.dk>
Date: Wed, 03 Sep 2025 17:36:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Mon, 01 Sep 2025 19:26:07 -0600, Caleb Sander Mateos wrote:
> io_uring_cmd_done() takes the result code for the CQE as a ssize_t ret
> argument. However, the CQE res field is a s32 value, as is the argument
> to io_req_set_res(). To clarify that only s32 values can be faithfully
> represented without truncation, change io_uring_cmd_done()'s ret
> argument type to s32.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/uring_cmd: correct io_uring_cmd_done() ret type
      commit: dd386b0d5e61556927189cd7b59a628d22cb6851

Best regards,
-- 
Jens Axboe




