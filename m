Return-Path: <io-uring+bounces-7015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A84A56E14
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D92911889841
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2CE23F40D;
	Fri,  7 Mar 2025 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oeRJez1k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA46E23CEF9
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 16:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365610; cv=none; b=vCpdpFkxhF6ft7FRPnu6EtLiBd/EUj9juuxnjgaFHLDUGNE5El8DkFTnEIVog9eWT3GZoKUg4i9jwjIi63OEM8QFtuSMmKvgHxMWDS4HpgZEkYM3iJ5ARi5y/4aVzRFckkTL7TawbWoWdEL/njbS8uwhHeOkB6NWeyLXOvCny+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365610; c=relaxed/simple;
	bh=y8+qISmzBg953gQccIuE6IvNLoCbPJ/cyLPymi/H0BE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=au+6+0eIFpVnkdMZ5srsMzd4lIwcVuB3qhzTGgNdTIi5E2Z9NVzFxHp/Gt/KlxvjC0RDrfcxqFX+PyzT/50sfW3ipUMwpmUByOEuKWaS1/HxbueG8PtYp1eRSgkTosOKH+v+mndPPWeP8Dr0rTXxnyQkTK6pVAYUwEPkDGqOp7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oeRJez1k; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-854a68f5afcso51834039f.0
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 08:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741365607; x=1741970407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cT4RtZmBXuMVY5GqwGTSavnje2E8EM9Uv3LSfA73KcQ=;
        b=oeRJez1kqyy5RV1T38+xpk19ZsNGeDQQziLshd9a8s05PwuSjG2Or2Kr9xQgbSP23J
         Sf3U6tReMtI1D9MAxBcUEMyUGTDQptqY1YTIrFMtdOCKNlfChAaSntgtRwGKeK+Q0whf
         Xb4Wb2LWiBYxEdVkeNqdkRRNykwq6y7rRGaAk5QmuIzkp6T63IP2F1qsc8seGnE42Z0R
         PQx3y+FeU+qxB2wOxOo0J95ciwPwJjR9etJrhQn/QFX28M4I9SiA2KbcOR7eH5eat06M
         WS5TIMxXNCsTBB3QN2IoPPdg+/ztuTT6cV8rVtEt12WPjmDd7+TfRP3DNjHzSgNiVb3k
         Jg4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741365607; x=1741970407;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cT4RtZmBXuMVY5GqwGTSavnje2E8EM9Uv3LSfA73KcQ=;
        b=wmIjuOVHsHoaDbDCEGGCCXu21GdcnD1amBNBpcjMZW6h4JGbT/yITbVb4gYznXaxlO
         6ask+saYeujH1ETlpaS0uofPVFJ5MBV1QvVmuJt1Hr/M/Z1/E6a/1xD6qnqKTX4voyOk
         T+PSIgVoCMCvgLUBIYdZriX02V7tFchXXDXei/TEBCOwE5KvcRxVPp4WoqYo73WDwqDn
         5cV4vwRGmLuuC/MB/ZH0QoHSqByQeVhiE8+CrPH+HjthIaNpD/wlgOiGevlmAJYFZY84
         j8nFWX/i4fwc/xmz0ZgQoJm1laNvIUFVBAtBhDcW+4kE9g+cdL6Gi0NY8fSff4GW6r/H
         svPg==
X-Gm-Message-State: AOJu0YzJozCmW+aGdu15i+nWbtfcE7rfgIVjjIALln0qPS3k9w6pJ3nD
	2u09b9eEw8WER00MgZ+z8As9pnkfSw+chZsMs6iW2MFtJ+Q+GBbs/p/4F+YJ1Mh6osr+pDFwF2y
	k
X-Gm-Gg: ASbGncu+P0ses5GwAZNws5y5QueEYytg1R8+6Md1QC9R6L8nIhxSPjIcO8gl5A51fkX
	7jAc+/cEY2HTMHj0biP+lYweUR52zG2e8bpMeOLWqeX+z9YkR8qEbHkfxT2lpbXFz0BFIIgEM2z
	sSAzQAnRPp9KPB73/J17p/h4f1//AYREcX+n2+3f18/gF5qaSiCWmu48dsmpWzUxHF8P7jhbsiV
	jafjkjcJmg3Dh99xmwXtjZXiraFu8mD1P9cIo0tFczrIumEf3/FlZVapnmuEnFVGLxy7fvyQtWh
	HEdsHIJ8XdVYccgjYgRNf5K5uCe0NzDJOAY=
X-Google-Smtp-Source: AGHT+IGJaLhykor6koqQSjKB6XrEeWMwo4gtVfuoEioQYqX7spnOrG0Hfxfm6JePi86UlAYnE/Fkbw==
X-Received: by 2002:a05:6602:400c:b0:85a:db0e:ff7c with SMTP id ca18e2360f4ac-85b1d01c793mr592641439f.7.1741365607247;
        Fri, 07 Mar 2025 08:40:07 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b11986899sm86157539f.10.2025.03.07.08.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:40:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1741362889.git.asml.silence@gmail.com>
References: <cover.1741362889.git.asml.silence@gmail.com>
Subject: Re: [PATCH v4 0/9] Add support for vectored registered buffers
Message-Id: <174136560593.394257.3485449892877220935.b4-ty@kernel.dk>
Date: Fri, 07 Mar 2025 09:40:05 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 07 Mar 2025 16:00:28 +0000, Pavel Begunkov wrote:
> Add registered buffer support for vectored io_uring operations. That
> allows to pass an iovec, all entries of which must belong to and
> point into the same registered buffer specified by sqe->buf_index.
> 
> The series covers zerocopy sendmsg and reads / writes. Reads and
> writes are implemented as new opcodes, while zerocopy sendmsg
> reuses IORING_RECVSEND_FIXED_BUF for the user API.
> 
> [...]

Applied, thanks!

[1/9] io_uring: introduce struct iou_vec
      commit: e1d499590977a492ae120d9263bd55076aabd460
[2/9] io_uring: add infra for importing vectored reg buffers
      commit: 9ef4cbbcb4ac3786a1a4164507511b76b2a572c5
[3/9] io_uring/rw: implement vectored registered rw
      commit: bdabba04bb1023e0327998b1eb0be096079bde65
[4/9] io_uring/rw: defer reg buf vec import
      commit: 835c4bdf95d5c71fd5b41f77f2343b695b4494aa
[5/9] io_uring/net: combine msghdr copy
      commit: 7fc9b27f8ee940ebb4035957e15225732e106d09
[6/9] io_uring/net: pull vec alloc out of msghdr import
      commit: ae89ab8845288c751a3cc7f3215cb44ec6a900f7
[7/9] io_uring/net: convert to struct iou_vec
      commit: 8066b67a8a0c4fdf93c043698c36474cc1fc0ff7
[8/9] io_uring/net: implement vectored reg bufs for zctx
      commit: c983552d59531792533191186def14ea34d80590
[9/9] io_uring: cap cached iovec/bvec size
      commit: 89176d5837668a429d862c9aff392226026ae7b3

Best regards,
-- 
Jens Axboe




