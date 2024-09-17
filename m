Return-Path: <io-uring+bounces-3217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B90B97AA70
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 05:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9177F1C21E44
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 03:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012B61E504;
	Tue, 17 Sep 2024 03:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2vnvFEnf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DB415AF6
	for <io-uring@vger.kernel.org>; Tue, 17 Sep 2024 03:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726542823; cv=none; b=q76tg7uUVI5qoPitSbj5DFgm9Ne9URKKShrms4nAR6foX0Zrmjk10RVU948r/CfBnjvVq7YtsmkAkaFoYoBYBTCKnIsurlVPz61+LcT1/y6P+66Qdv8Mmb/OT60LeiUVZiQWdVLWx0SsG6yOO1xXVav0mdlS6MVt3S5vhp539c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726542823; c=relaxed/simple;
	bh=ISAZvpnUunz1bdqRI8uUSiDnumcy6OCZZq7V1IadfSc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kDvlv6jjZUL/VIY07sLN/Cw/b7WzL6I2dCIvMMTd/FzqUj60dBEJ1MCp0dZl6/JdlFv8hI24hcaDF17Od3yxxQk+7nB7ghKNhPo4aeCeDFhY3sEpBDQb/l0QWLl1PUMNzRBNEOh55qxnQ1KqNtyyMMRAeRlKc/Mv/oPnoVe5JjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2vnvFEnf; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42cae102702so32221715e9.0
        for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 20:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726542820; x=1727147620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cdkUb2KUe0CMyfMMx1GHTBSO/dyeH3VfUVSyE+VE6eE=;
        b=2vnvFEnfe10W4zho8g1vOkZu9ZgRqJQpIAFqtm6ghVQPPZLazQU6WVWXbnGrhKqtX4
         +0X58Ys/3tJHwqPbqHuZe4KmcUTZMSW0VwK1kdWf8U9KOGMPQxfaSdQSq51GmEsvJGbr
         gwwDgtyxNJIHvjlfLnS+UNRHxIgtA1NyEb9tGtUOWTo50OEdn4iKFFBzsjcmGU/dshRB
         zXj/e5vPHcpm/R5bmtO1FCblb7B5Zj8lc6x2yjM98OQ/2hir5wJlbyreoY50NntBksfk
         lKnvwGdICsc+TOF40q3VriB7CFGV4RZaShbabhT1bO+vqxT/MBEF2IVmstYMrDh/GmDG
         VaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726542820; x=1727147620;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdkUb2KUe0CMyfMMx1GHTBSO/dyeH3VfUVSyE+VE6eE=;
        b=TLlzKSWXEtv9MiwQejMmEiE5zsuUUmIJGISXdKWFT833MT5M7zK2oGcsoXz2gzgPuX
         Fot3UJkxMj/2j44dfuoMmuNTZ0JbTGZ1zzKJA04TG7A1i5zO/JsRHiKBxGK/jBm83WcA
         QhITgchn4UY/elBhC+VNnKJrePfFJP06B4o8qF2L0tyHguv2J19Yd8/lLY1E0awe31HO
         F8v3n2xIEL9CUcrVN30YxpLm+4H6m4y15QPA4gxu6kC8mNg9h2DGkcpGJcexMSubeFnS
         8ke2HTEtNP4qn75s/Q7nNumvyD+z0PHbVomgq6S7Dtri4XDDyg96+gHJxQbNz+1F6DC8
         NgQA==
X-Forwarded-Encrypted: i=1; AJvYcCWZuzCTNimWdX3yZjSRgm5vu0XmU9ZSfwRnQnhigcgOvSgUK0+pdJXGjuhbPzrvUt3bQZYW4TcLGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKiCTboGKRZkfzKTpIjH/Q5B20gB9fP1TCVMEmx9tc+Y0uo9Bh
	xFIHQxvUoaQH2C/r2p9dzeFFC74X5On68RhUntYBI6CRb1AwmSWdT7MkcWVJWpq5fhguE/i9sUt
	ZdWoPDHjW
X-Google-Smtp-Source: AGHT+IFsz2QtqfK13RqEhXmFmNi4W2ilFciOHpaNJk1zaat25e+/3Pqmb7ucZW+AbN7PhIsr4nplnQ==
X-Received: by 2002:a05:600c:3b11:b0:426:5440:8541 with SMTP id 5b1f17b1804b1-42e5c0b6cc1mr41117735e9.27.1726542819578;
        Mon, 16 Sep 2024 20:13:39 -0700 (PDT)
Received: from [127.0.0.1] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e72e49bfsm8441122f8f.21.2024.09.16.20.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 20:13:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Olivier Langlois <olivier@trillion01.com>
In-Reply-To: <de7679adf1249446bd47426db01d82b9603b7224.1726161831.git.olivier@trillion01.com>
References: <de7679adf1249446bd47426db01d82b9603b7224.1726161831.git.olivier@trillion01.com>
Subject: Re: [PATCH v3 RESEND] io_uring: do the sqpoll napi busy poll
 outside the submission block
Message-Id: <172654281869.102466.15156736891986504174.b4-ty@kernel.dk>
Date: Mon, 16 Sep 2024 21:13:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Mon, 16 Sep 2024 15:17:56 -0400, Olivier Langlois wrote:
> there are many small reasons justifying this change.
> 
> 1. busy poll must be performed even on rings that have no iopoll and no
>    new sqe. It is quite possible that a ring configured for inbound
>    traffic with multishot be several hours without receiving new request
>    submissions
> 2. NAPI busy poll does not perform any credential validation
> 3. If the thread is awaken by task work, processing the task work is
>    prioritary over NAPI busy loop. This is why a second loop has been
>    created after the io_sq_tw() call instead of doing the busy loop in
>    __io_sq_thread() outside its credential acquisition block.
> 
> [...]

Applied, thanks!

[1/1] io_uring: do the sqpoll napi busy poll outside the submission block
      commit: 53d69bdd5b19bb17602cb224e01aeed730ff3289

Best regards,
-- 
Jens Axboe




