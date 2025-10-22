Return-Path: <io-uring+bounces-10124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5DEFBFD903
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 479293B4BE6
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D292638B2;
	Wed, 22 Oct 2025 17:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OWyZzCGr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDA825DCE0
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153202; cv=none; b=h5lTRRgP1bwd8ly1Fso6AsJdHQ+Tm43CWbQPqbTHZfkvJ2TYsR/CdpuMjPvzUFqWkdShwZX7h/s2IC9MvynVdd+C5zJDeM7v8GrnrOVHLR8g0LcV9K04fQQBjzW/+FylTFs9qrJqwoosYGdMcesDpq5bRSRU+hwTfq/UgZCg9r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153202; c=relaxed/simple;
	bh=K5uShLiLEykz8ZWlZay13x726gULR/LsHRbq3xY5l1I=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qzHHCXtqIjJ8qV9he9sdgGAUcE+q3b1MUYVOmDRoSvlZUIWv/zPMQTDtifkk5DjAaS3CwEfFyyXSqLPRCB9lJO+v9pbjNXeInEiAEuztv9+8z4kQZ8UENdyDrdvahU92dXQOMAg63BzWeAVr+bqbKeHFsmcGLDrfcl1M45lSUVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OWyZzCGr; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-430c97cbe0eso46293135ab.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761153200; x=1761758000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OIPYiylCWTTPJLg6Xnaq/UnriZ3LghrtGz43pNW8afQ=;
        b=OWyZzCGrzrBeYQ+sT5zCMZx5vdkZqCtSz+iAZdyiBkHLSAKUBF7ZGLXlofY/EguX6O
         kfeR9RdwTjMtHBy+ePGVFdhS7RyV2b0sWczAl47p6mWOSh6p69YsIlsGqlzB3jB+Oh5y
         4oEGGwOo9jF2c+aI0D8XjBb18cq9tx3q/ORgnxcwSCxLc8u7lMuWN1BtH4fFIyNuNY73
         HOV2BlR5yF23tTAVUYc4ZqOVF/p6r5Z8XUjLLZUa646d6iKVzG6yIiJNlgQ3aNiYpq4I
         vrQ00bWiud0P8aIck7jpDdZww3nAUXnVkR/VFWV21oK5h57m6QesK99C6SZsKZPUTyOt
         YCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761153200; x=1761758000;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIPYiylCWTTPJLg6Xnaq/UnriZ3LghrtGz43pNW8afQ=;
        b=HqR2VqTWUlGK60mF7x6Er8zdbZ1KkT3/udWffzqEZvBx0WiieTYL9SO475jVU+rOkS
         /EXHNwk8vktMlUCj65R9K/caP8ZPozSyC1OaK9ncu0fbEFuBqJNfRs8KMtfB1PsCgJDQ
         o6NGzbXV0N8GawZWK7l0LDpxAJZStKCRBf4iN4ahmiBZg6vmXL5PRAsM/VGxWnktNlmD
         yL8Olvzbu/cE7gQbfEUYVww4VUdpvnwx9o8g+22XPWfixdDoJxpx/RU4BrENIlv6mBo2
         /uxUVmzfuKHFvnaENXBGmwfDAqma5XEMPeWVBW/NmZSXYSmyLX3wBMPf9whhr0RpWlsy
         /xSg==
X-Gm-Message-State: AOJu0YzOstkC/BuTU3LanU9vVmktd06kaxEJTCB3F8PaZ/waT14Z23j6
	Gd/pf5sU53Z5s91r/Jxxh5qHLlrkdaWn6bivKzmBccvnKvvQo/urDXctgXV+Zm9xOi4=
X-Gm-Gg: ASbGncvrH7O+4TE+0ulGWvy1s1HnzJguAfhG2xxV5lOCpdR1PFDkLm3mXIPW9JfJvnq
	NpYsaAMp8xhWT064wfIiIQMk2tcPDeLR26HZ8lQF+pMMXBqEWai1rXU8omPDhzh5OeNWJ1XJXB+
	ovIdGanK/lajRpPd+fGU4AlKAurvFTe4us3T8mwvfjxZa/hAjHL1jh8HWKcIXS0n/onz8BRuv7V
	X7G+dmfzadMyIYEudShqTwUOXgQX9CzCyi5H7PjH/Hbkg9u2fCphYeIGIIZEMHY0OQWGJNvIuWL
	usjrEnQhUdQvJizrbwrOplDR35P6/ULam+sLEAAwuCVbs6TRMAg8tT1zlhWD7f95tnrOr/f+rIm
	yr6LzGUhkthA9fXp3Mae8zJbQylRFB6wFeZi+lqsvQA+2uU+Ba57aQhUshh/DShaDMUgozG0U/n
	knPw==
X-Google-Smtp-Source: AGHT+IEISXMgwERNvFri0z2tDbAXXW0YD9VqTA2I5LvUgdjrO1qlhzP3lUcQmvUBW8BdfzZ6EGn4dA==
X-Received: by 2002:a05:6e02:190d:b0:42e:2c30:285b with SMTP id e9e14a558f8ab-430c52becd2mr287340765ab.20.1761153200117;
        Wed, 22 Oct 2025 10:13:20 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a979671esm5205876173.62.2025.10.22.10.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 10:13:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9f43c61b36bc5976e7629663b4558ce439bccc64.1760609826.git.asml.silence@gmail.com>
References: <9f43c61b36bc5976e7629663b4558ce439bccc64.1760609826.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2] io_uring: check for user passing 0 nr_submit
Message-Id: <176115319950.119283.724456454101744276.b4-ty@kernel.dk>
Date: Wed, 22 Oct 2025 11:13:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 16 Oct 2025 12:20:31 +0100, Pavel Begunkov wrote:
> io_submit_sqes() shouldn't be stepping into its main loop when there is
> nothing to submit, i.e. nr=0. Fix 0 submission queue entries checks,
> which should follow after all user input truncations.
> 
> 

Applied, thanks!

[1/1] io_uring: check for user passing 0 nr_submit
      commit: dde92a5026d81df1a146e9c243d09b27d1bf04bf

Best regards,
-- 
Jens Axboe




