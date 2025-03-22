Return-Path: <io-uring+bounces-7202-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A71A6CA9E
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 15:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A3913B4B8B
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 14:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F101F9F51;
	Sat, 22 Mar 2025 14:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CclBIuiJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0781AF0BB
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742654144; cv=none; b=DYI3AVsj/is2R7Zl8egSLFSjD1b+DrDOao0SZUKpOwmrnD1QLdb9uJUo7bS2mtrEBazv+BmIXkgIKwwcEPWbBrBftB64YjJro60IWGpS2HtZu694KJPfhlkqQgvJZaD6Q3kLxlbyUg25mFKvNlft4UrSJRrKbLkCMRhWydBQy/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742654144; c=relaxed/simple;
	bh=8bswrlHYWAtlmO0k+GWN89U1q94odgL4FqmhRmjtdWQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KlHS9V8TzpRq+URJjnQQZK0BNbtZ6b2GJcNiapDi2p+jMm+I4QFpVRimHNrR4kS9vEfzs6e6vypdz4+KL/IT4KBCYQyh9BHZgx4bHuil3FqDTlBgLSATnOaE7epBcaTItThUm6e0Je3X6eD8Gt1qMwRXAhOTBJdjyf0WuzROvOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CclBIuiJ; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-85afd2b9106so303874739f.0
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 07:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742654138; x=1743258938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SXf+uabkagdbwIM40um5bBvmMq9x4C6G5OQ3fFxje5g=;
        b=CclBIuiJKWPaBuyVPf/nYpCzYfPqbb67jhvny+vkWeAQRV6lzMB3UcQPcumfEEdLb3
         D/j+CqZvQtVE8ge7l1BM58rhVAc/8uFEQwxLtUAc8L1f2fSQ+lJoyud4AOnEPV8wzqyU
         AhYST0JBEOczBBnTwmqA8S5Is/xrK5yUUKjBwNPD0kor7+BZ59mNTn8+zfoTZ4/DsYya
         +5DGfF2kgSy9pz2b8hNeWImsb+tXTUz13yDjSseb2BqOIqOvALd6+9+plmTIN/d/iJ5s
         HLtjSbp1563m0ehy/0UH3xm/3QYtsMQgG8KnG6Kgkr4Scu/RRBS7Q40gGN35ylIOsP78
         QaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742654138; x=1743258938;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SXf+uabkagdbwIM40um5bBvmMq9x4C6G5OQ3fFxje5g=;
        b=SOodDzG5o7Ka8vAnrTRrWBem4IFcW/HAIdXZz67upkiN00uKi5RRPpqoF28WaebLMZ
         8JxZ+5rH6Po/h8XExOvIhM93dXiWpAYBNlZJ/UOF4+YoSJelkEK8i3jmyJribkv7tRpN
         Pum6ywyUALaJmKxQvFidYNhXIzMppQ2RsTx8bvyV3DfwafI68P53KAP2ACmCv3/Hs0cl
         zHlh5uhxC+n775vQOLuR0MCNl+Sjj7I/WtQDS0AMiHokj+WQy4ABlS9ySKGmjrrWDPes
         TRvGGn5qdHK0Eo7NYrEsLk402cz2eeHc+5i6UiBbmH7vWy//ASSUcd/RcGwEOsSbPP5c
         od0A==
X-Gm-Message-State: AOJu0YwwCd2SvYJppUbd1lgaVnV+gW09ORQ/O2SXtxIoxFOP2Y7TEYR3
	HrjDYRCaO39DfRKIVk9QaYarpzUl9qQrp8uw/zYjQuus96aKugVfTxQbTBv6dc/ZJUyNPSoDG7h
	Q
X-Gm-Gg: ASbGncseh/l+AjA1olyrENcBoJoUQEc/DifRDh3DsycbMiRB61Iz4+0bq82G2y7JX9n
	3GSsIf0Md5HAvnFHR6d02eiXIVHfxsMynLrYNt7/YQ3gXncqO8j3xCskHVSLYHBH/NhV8oMKO9E
	/RpK9zigK9gBYsDqs9QIi3wX9Pki86+H+X8UFAeUN7NOEiMiBAvryYKjBpTeI8zMupq9IbjB5Iu
	cD70rXbXCzYTcNUZdIN5jXlHbBsNpJuPHIAgp9g/YrbxSg1/jtktHIdCDskQbU8IbqyTUO8cCMC
	T3u2wYUxY7mfkbFSpwLppqCjDZI04oHBQXL/
X-Google-Smtp-Source: AGHT+IFZq1HVrkvLkIk2GnvpUJamAot1yG2gGaQr10tMyg7zFC9/d5rkfuAUEEhFcITNbaoffilRdQ==
X-Received: by 2002:a05:6602:3a08:b0:85d:9ea6:59a6 with SMTP id ca18e2360f4ac-85e2ca63fe8mr744710539f.5.1742654138744;
        Sat, 22 Mar 2025 07:35:38 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85e2bc273acsm85798139f.16.2025.03.22.07.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 07:35:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e1306007458b8891c88c4f20c966a17595f766b0.1742643795.git.asml.silence@gmail.com>
References: <e1306007458b8891c88c4f20c966a17595f766b0.1742643795.git.asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/net: fix sendzc double notif flush
Message-Id: <174265413772.771654.8140235260115879684.b4-ty@kernel.dk>
Date: Sat, 22 Mar 2025 08:35:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 22 Mar 2025 11:47:27 +0000, Pavel Begunkov wrote:
> refcount_t: underflow; use-after-free.
> WARNING: CPU: 0 PID: 5823 at lib/refcount.c:28 refcount_warn_saturate+0x15a/0x1d0 lib/refcount.c:28
> RIP: 0010:refcount_warn_saturate+0x15a/0x1d0 lib/refcount.c:28
> Call Trace:
>  <TASK>
>  io_notif_flush io_uring/notif.h:40 [inline]
>  io_send_zc_cleanup+0x121/0x170 io_uring/net.c:1222
>  io_clean_op+0x58c/0x9a0 io_uring/io_uring.c:406
>  io_free_batch_list io_uring/io_uring.c:1429 [inline]
>  __io_submit_flush_completions+0xc16/0xd20 io_uring/io_uring.c:1470
>  io_submit_flush_completions io_uring/io_uring.h:159 [inline]
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: fix sendzc double notif flush
      (no commit info)

Best regards,
-- 
Jens Axboe




