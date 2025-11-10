Return-Path: <io-uring+bounces-10511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B9CDDC4978A
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 23:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 65F3734B21D
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 22:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C80273D81;
	Mon, 10 Nov 2025 22:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="c076YN7M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B892652AF
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 22:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762812179; cv=none; b=nE0fXC9V6fMUUx+NKfOt2MCdq2tXhOQ0o4mM0LgDvZPyxEqZsU5C8pje2l/50wD+5bVS6sy8gN+7qof1gP8pNN7lfjCAOyoKcwF0zI5VcFL8qGgO1itLQqtIymPHacnHr3/n7iFNfAiBY4LFHPOI32qVj3/HWuwAxRU8mGR7/CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762812179; c=relaxed/simple;
	bh=FFw3lZIu1w2wkV1g0OKVpYdIn1AYoJ3FvNySVx67vEg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f3bU1o3AkW81sxWtY+ytQjZLgPepb1u8E4s2RA19NC6B4rqEJs1bD1BG3ibZgLh8b+Ma7TNP2mRU9LCKkIYLv2+fcai85kmc2Dat//ecDQjRQn5rK+XRHh9kKQDNwJzKAAGaGpBB0HmoXiSV+m6uOLZuXUJVsPHY1R2LaXZXIiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=c076YN7M; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-4336f492d75so11556865ab.1
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 14:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762812176; x=1763416976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kc3EB6tSLfv1L3nVOvYG7YyksXJmrbSjAkt0/XLmkT0=;
        b=c076YN7MmPtDtn6h9JffMDt020nSgHYhS/iqClbDEpkc4wlrZgQvlMPM7reOJ5J51B
         e7g2iC/PhoVTtgNmOItvysoovzsAkzIlo8IJAOp8uHh8UeyfmNNdXPr1vtg1sQdCNGSq
         LDoJZ2Iwu/MSyb00d5oWUOi4IYzt4lnSaexnkHgnFeOi04RkiwvIT/7nRGS2sGGeQMon
         iq18SBK8YIdPQj1C+8/mH7VJZGl6f7Hxv8cbEIKwGVQZnJtjarhSJXUYKsXz640+XPTJ
         Ph7nUXocXugHQXtaGaPBzlEMR/o3681huR6ioeygzuk6gk7n9dLmEKz/G4ba1QwPSGcK
         zxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762812176; x=1763416976;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kc3EB6tSLfv1L3nVOvYG7YyksXJmrbSjAkt0/XLmkT0=;
        b=VTkmC+m9iZ73GsyuQ9t/N7Xrke6gkox9e8dvUCUQmbeTz3kiHdLXzKI4hpUz6ihpMj
         myhfuZJdSO48hldCeJYFLGlNCmTZvZJs7XMVYbMZ2A+qsy5+qow5OvP/OwP1K1C5I7j0
         eHEPmFOS9m5PKI6qcr+GkbN6p/l5jceg8EUBEwGdo7C8xNCnVZIEmgQ7KXvb0HLUIrcV
         teZrmpt2QWHWlrkd5LKiXZdRdSaQhRTpSOLA+tFxbfs355UhwIbqtGvTu6tFkFtkdw04
         ZClQwoh5k7jJxJXaL2OoSbFri6MdUl+8vDU3zNuESe7dIJRS7gwPWIaPb+jxcTXIP2gK
         kcWA==
X-Gm-Message-State: AOJu0Yys2Tr90w4w/Y8OQJ/UCkK+ljoknCaPPmXmkkUE+/gCCAPpEvGa
	SNz2nrJEYevcxIuo+R0is29S9b+D10bFOdpS4aY92Ktx03OMGJ0LNiA3ENIdTiUZKNyzyF/hsQP
	2pBoB
X-Gm-Gg: ASbGnct3ic2MRTw8rnyApaYlruZXhj47+W5eNAqn7vya8lkv0wgbBP2B7/Z2Rr2AHgk
	nZ+LwK1XGPfPm3/OFxRqz1k5P+uFyYo5Knf3QfwhXvqqX5WHjWRQahKfx1kZidKV80vEspTooYG
	LUj5QGSU/e34zq6xfbmjiAgAQXuNEqVC8rYqJwkEz1bZZmqTmwMkAH0wR28+tOSc601RjaD9X5d
	NkDgl7tpuSwZLOZPQOKi5wPlXlii9rZxa/IzvmkfahdH/crmMc13cvCdfn+Wie6AeDJEZQ4ljUn
	BELWpoBxpU4BHFlyrcwkRshgqo8BoclbTyXr4eEgFbsNTlSj5EZ7aY+Sd5IBeuHXa0nk5ufFA2J
	997bOp+2PyriCUMXxRboG/vIOhzTeJKGMTiJAY98zJNBRKrD+7O7P8NZ+44GyvwccXxiM1zS4kV
	IG76AVS3Z9Acna
X-Google-Smtp-Source: AGHT+IExORnf6hehliFUEnQsPsR56J1O1jfxm9adHb9QEUrnzKJnRluBe2ycdhYASp5QZ4gaoVWFrw==
X-Received: by 2002:a92:c243:0:b0:433:305c:179d with SMTP id e9e14a558f8ab-43367e7a665mr122509435ab.28.1762812176633;
        Mon, 10 Nov 2025 14:02:56 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43370b87d55sm31873485ab.14.2025.11.10.14.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 14:02:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1762701490.git.asml.silence@gmail.com>
References: <cover.1762701490.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/4] random setup cleanups
Message-Id: <176281217347.84022.9948094859559271006.b4-ty@kernel.dk>
Date: Mon, 10 Nov 2025 15:02:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 10 Nov 2025 13:04:48 +0000, Pavel Begunkov wrote:
> Simple cleanups extracted from another series. Nothing noteworthy
> apart from that I needed Patch 1 in a couple of places already,
> but it's still a good follow up to recent fixes.
> 
> Pavel Begunkov (4):
>   io_uring: add helper calculating region byte size
>   io_uring: pass sq entires in the params struct
>   io_uring: use mem_is_zero to check ring params
>   io_uring: move flags check to io_uring_sanitise_params
> 
> [...]

Applied, thanks!

[1/4] io_uring: add helper calculating region byte size
      commit: c5b09a6d1dfab3ac97230cc91a32d19a8f692232
[2/4] io_uring: pass sq entires in the params struct
      (no commit info)
[3/4] io_uring: use mem_is_zero to check ring params
      commit: 44d5ba73f6147b36316c713094ef56a7d93e5076
[4/4] io_uring: move flags check to io_uring_sanitise_params
      commit: 4d7352becf5609047112f91883071a289c44e221

Best regards,
-- 
Jens Axboe




