Return-Path: <io-uring+bounces-6670-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58DC1A42074
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60192161D8C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB9124BBEC;
	Mon, 24 Feb 2025 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PY7mHiHe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4E5254863
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740403328; cv=none; b=bNsPSWIzmyxUURq4XJGlW64ATn1mLsBDqmUAjiNA7YuHhEJGonMlO4Rh4vHP9ZdZlRl9IcTLFf0CW0boAd8sT62w9e+Iy1WfQCdqiZO9exxusvNmdN+wt0UmKIt0cS0M09BfpbZ4ohCJm4eHE/Ykm2VQYZhJb65tyVNbMVTiOBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740403328; c=relaxed/simple;
	bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=frrI/iN8+hXfVOyrYlIBJakDfUGf4vPGoVMP7X2dIrbBdMiqt0U+0oYNAUD8jogDbBbPd8f8gqAoaoxCEIF7iIpmXWahfXYdeuog6Gh1dFM3GBa0MAXBt03SfyNTPEshNxSwCbmrU3hzEmd8SCclQZaCrSqU29o5WeLbk5jWZsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PY7mHiHe; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-abb7520028bso586439866b.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 05:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740403325; x=1741008125; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=PY7mHiHeAaAvdhSYdSLAZ/h9oxeIBNbei7vpXfZWpET/s72PlMangtie2uo4MFGPMh
         PjAntfGCQ008JW5gNO+ZP8H54RjNaNUmJQfHOdA5uUxYnobJMGY7n3yfaaEBCbwvM0XS
         glOynnIqk6cYMDQ91W43X982aHOuQ50Q1aO74+gQEfK1P+k4ksrfA81rQ9trgv/B4/Ei
         tTi8oaxoO1coOW6aIsQWWJfHXtxlWiNMb/WWzXodtyTbMHCrCVR0r3RiHkkdeL6TdS/o
         SiR3RvXBvj3hYX7NoUcLhzXiTMqS7xcX0rMdhWmyUAuogjNDbEShqI5GiFXtiPIZVpAQ
         ViQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740403325; x=1741008125;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=jpFw3RA8n0S0Nb0fXPUz4SkHJaLXcdzXaMg3qQfqBGYcw62VQSthGh6Bac4Ktp1Ct8
         jmSir2JcdCtTZiLcMzwFsxX+SiSPHDEGINGGYQpdGQKxovgmBgGEqcUllubvRkG7IysZ
         FnJnaSenh1K4UuhmtOduo02z4DH8IC7IXzDY6ewl9sS0ztHj7zW8Odak7n/W5pTRCmuQ
         OMdlgqvPoxFvLx6Ly7LUIt3l0gAwRWzDrMilWMhrbNosgMz07yxdy8MVpc+u4cAvtzku
         UMbabAyWgfoAgIgBiVYAsspbmDCD/WWysppU+IYbb7tfU39H0lma6xjmIj2ZYujON9tO
         PXjw==
X-Gm-Message-State: AOJu0YyoSEefZP/T6HgQ3brRHBO8lskHMcvFvjo2fm69s3KPHKeA4hXX
	3Upu56Ut06eZFy7/U93eGW2sYzagvM71ylHiJ6kvafMcyeyJmDjH7Z7HlYqzG6wCQpcgLqqozyS
	fasEdaLYHa+K3uAn6a3o3K7amdA==
X-Gm-Gg: ASbGncs1Diu5DtnJW2s5ySn/OhYOQv9Kloxjhtt1PY99CH78ChsyYDmmHFjP33yFWUt
	G9dCLjYOUjIceN4rtLeTdT+BRIn5ci7D7crFd+vloQmpB3py93PtDMavSloKAzqz9f8rJOqfAto
	EV0J+pTHk=
X-Google-Smtp-Source: AGHT+IHJDj3AemPfk4qTKAWRJmvffLjlPmX/QNrLAqsjn5gPxNArFR1Ey48ixQIKyu+chdqvuKZ2pywULtTxV0CcyVg=
X-Received: by 2002:a17:907:2d22:b0:ab7:9b86:598d with SMTP id
 a640c23a62f3a-abc09a4b7c6mr1204942866b.17.1740403324454; Mon, 24 Feb 2025
 05:22:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1740400452.git.asml.silence@gmail.com> <f4d74c62d7cbddc386c0a9138ecd2b2ed6d3f146.1740400452.git.asml.silence@gmail.com>
In-Reply-To: <f4d74c62d7cbddc386c0a9138ecd2b2ed6d3f146.1740400452.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 24 Feb 2025 18:51:28 +0530
X-Gm-Features: AWEUYZkrreeHIsH4iu2ls_Ol3gng9IA78vflFa3pN0jUg88IkCLPZ8XePB4xwZE
Message-ID: <CACzX3As=cuF+EyoteRmodv4wkPK4=nj75GFXYk3yWFGo9TayxA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] io_uring/cmd: optimise !CONFIG_COMPAT flags setting
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

Looks good:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

