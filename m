Return-Path: <io-uring+bounces-7971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 359BBAB5E24
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 22:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CE241B611DB
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 20:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CE81F2B83;
	Tue, 13 May 2025 20:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QiVVz702"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685D61E7C03
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 20:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747169252; cv=none; b=rQOeHDEPbGChVrNoezEKR8hH8+K5In4wUAdIBcRzKlnkHigZW4o3kmEPmJMv4KhOMwH/M+j55HQylWdGdDyHirY7TuElwqPgo6XRz4J1DkDNN+I6HumsQKrC/02jNI51ZjYirVHI/AEBJQlslIMJsRcK7VRVs0cLwGDumHCmvc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747169252; c=relaxed/simple;
	bh=mMppYl1J6cR+CIjDGX70jq0KeqfYdT+abNx3b6CQQvU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=k0zqON+yuu3OMVNu07leFxMU0tyi8SFu0XCbpy5jblPDOcP8UyXRom76UvNb/sWOY49ZEn8IJA9CN8zOatilnw1zFKavlgtwcNRHFFqrDIT8DX0ae8U0BYm0kbKNg8AnrJ4eoCX+la1Ebhz8JvZODXMXxLTI4jxYOJ6t9FsGlvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QiVVz702; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-85dac9729c3so601754739f.2
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 13:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747169249; x=1747774049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Z5nW3JF/y8WwrALUrcM63tyqr4WDjFCMpUX6JZNzu4=;
        b=QiVVz702Y/RSW/6B7vTjVg9+AFd9r2Q6reGOkaAGhOBZPInIncptWvAl8XQJR/lPjM
         skp9nzXvLrWFBjawA/2voAmPrI6E++1VMkDWGMvMfvjyXT23L5TTM3jInCbJDfDKN4ol
         hzoLyDDUvPyBceT4S45SrlbGV5JDo95JYyckflgS8y0HsP0tO660Tffh2MivnUUw/pOc
         j7RVYiDIndh2482f4br2RkmYL5CSiXKmNS68JnqU0yeycf7b1XagGUlNBPQeGuGFQYvt
         OCNAtP2lsE7GB8o7LK0kxnY5GjUIF0ExOPx07ma9cosOIoBvBbeiEtygkQz15ahkBE/8
         ImzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747169249; x=1747774049;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Z5nW3JF/y8WwrALUrcM63tyqr4WDjFCMpUX6JZNzu4=;
        b=RTgQPS5Pt131yyboLZ26n4KCTOVWORK4WtBBnNALFFaTwMmDvy4m+gxNlOX3UPRQy0
         RrI60+htVbz2cvFHyEbgL7KF5a5Wgy9TXZZ06vwkBjGbKR8aTEDLA9I0lszUrzsI6z5i
         aNKFCZiOHcSq9YpIY/Jjizz/Qdc+80kcnOSmDouVX31ryRnQMwWtClh4KCeh4opooKPn
         0l6323OitPYbkw04v0Kw1pEqNLfEWikCf/ntEePg5yF4Hg5aWeflbvON2/ySFy7VOFu/
         5kHbSZlj1xndbeUlr0tTEAJ3juUHUbVsD7TRJk41iS/1aF6zzd5APk3NLwXlnkzTDiFt
         rLcg==
X-Gm-Message-State: AOJu0Yw0bZjbmrgDFe6Itw/f9OQIVoK1p0Tw3wj2gGsxnNOr6/n5Y4SK
	nlB4gnP51l01HAShoS/enXe/uZonhLUN3RW+RzP2I4n/NSwg2yH3lTWm6UH74meUR2weEdG2+Oy
	O
X-Gm-Gg: ASbGncuKfPGZsokINQh6LGguTR6wUJkyXk8yFjpbg0QLqwryPKaCRkPDqNinb/658t9
	SAdkzcr+0+GMvMPjUaSsxI2VZ2uBlxL/FMRBGn4o+zkJra0ucwqynOmYNnH2E232yaoA5ZUXgbY
	eKT4w1wYgbm0SUpSYuLr+lnP95mVVpofPVMHFWLyYyshlboXub4cU3sovLwfwQxKLhQjlMIFjnR
	2DoPq/Wgak9x22KU2irFCtK2YRgqkBF/oMqurbvWtJCd68GvZaAdi3oyPYYyrrAV9Psrkpw1uT7
	ZLTC0UC7O4vHEO1vPBhepGu/DOnvh95f4jorwx8K7A==
X-Google-Smtp-Source: AGHT+IEOoSWWxWDKfzqeVnXto7LQos5nu23Zo047dx04TMaHx42HAmb61sBm0FfjYk6x7IGk2sYGaQ==
X-Received: by 2002:a05:6602:7216:b0:867:3e9e:89db with SMTP id ca18e2360f4ac-86a08de885amr115042339f.8.1747169248983;
        Tue, 13 May 2025 13:47:28 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86763570018sm240731639f.1.2025.05.13.13.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 13:47:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1747150490.git.asml.silence@gmail.com>
References: <cover.1747150490.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/6] provided buffer cleanups
Message-Id: <174716924776.10749.10704969319503979053.b4-ty@kernel.dk>
Date: Tue, 13 May 2025 14:47:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 13 May 2025 18:26:45 +0100, Pavel Begunkov wrote:
> Random small improvements for provided buffers [un]registration,
> with Patch 6 deduplicating and shrinking legacy pbuf buffer
> management opcodes.
> 
> Pavel Begunkov (6):
>   io_uring/kbuf: account ring io_buffer_list memory
>   io_uring/kbuf: use mem_is_zero()
>   io_uring/kbuf: drop extra vars in io_register_pbuf_ring
>   io_uring/kbuf: don't compute size twice on prep
>   io_uring/kbuf: refactor __io_remove_buffers
>   io_uring/kbuf: unify legacy buf provision and removal
> 
> [...]

Applied, thanks!

[1/6] io_uring/kbuf: account ring io_buffer_list memory
      commit: 475a8d30371604a6363da8e304a608a5959afc40
[2/6] io_uring/kbuf: use mem_is_zero()
      commit: 1724849072854a66861d461b298b04612702d685
[3/6] io_uring/kbuf: drop extra vars in io_register_pbuf_ring
      commit: 4e9fda29d66b06caf5c81b8acbe0a504effc73fb
[4/6] io_uring/kbuf: don't compute size twice on prep
      commit: 52a05d0cf8f3b4569c525153132a90661c32fe11
[5/6] io_uring/kbuf: refactor __io_remove_buffers
      commit: c724e801239ffc3714afe65cf6e721ddd04199d0
[6/6] io_uring/kbuf: unify legacy buf provision and removal
      commit: 2b61bb1d9aa601ec393054a61be0a707a5bea928

Best regards,
-- 
Jens Axboe




