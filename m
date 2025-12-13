Return-Path: <io-uring+bounces-11038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC81CBA775
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 10:14:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E04D13009C0F
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 09:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422482C15B1;
	Sat, 13 Dec 2025 09:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E5c3RCCh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2DB2C15AE
	for <io-uring@vger.kernel.org>; Sat, 13 Dec 2025 09:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765617292; cv=none; b=hiQWAAviLHoDtvAhrs4jf8ObFexL/9RjBxh6YVYvv5zUCFmjOFHD2Lb1e+FzSUW1s4yR75Ep4u9qNgNY0IPMNhYa1eLdmv1HFnioFTt7NqNnxPsglahzAyuPYBviCEuUA+vG8wE3ETx4vEEYY5k+lx7/lKPdiwsL2uXzAuUY3Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765617292; c=relaxed/simple;
	bh=asZ/YhjPvgmoF1XFoCb+Rxl3uFXzu3wNy2myGMNpSrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwBehMmMC8EmkmKUrJlvhWvpqnKfJCE3Cj0MW5Ca/VG29UqJhj+DOq7T+ke8vTXZuE86aKMtaOw2bGJRf8gcortIFR010GnYWa71kFv/Rv9WeiBor6XJBKlBILoYV9w3KeAvl8KCzyrDT768H2O1xPGxv/ZWHAvviG4vPY1/BAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E5c3RCCh; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-598efcf3a89so1920468e87.1
        for <io-uring@vger.kernel.org>; Sat, 13 Dec 2025 01:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765617288; x=1766222088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JOzoCCfsiPYQ8ZOhpke3HRGzaSr9kbEG3AtWeuyrAUA=;
        b=E5c3RCChKq2SfUOZz1hbuf/v7d5/7HbfamtAHEoESu8NnXjffK2rCf5VSemmYj+CGN
         S0SyJGxLsOUJ6VYoqDR0GFNst1h/vFQniD3K1FXsnOCnBQRW6H3fyxysMeE0aOuisYV5
         j8i7IdMURJ19zry1MnrVhiGR7IBV+WCvDaMPsqVzBBKx/ae1JTqJ3mpkBP2SbMepQPtL
         zlo3aLzP5uauWoImOmwlwDNizsuOs/p6EkZEtuJFVvD12iyd8KDQAtX4Pzcz2ZKqGrHH
         aF21kQOdEKp87PWe/gIZk1Iwyn5sOBx1PTFvfdooC+DptJDt3wpcy679XdqAnsKIADFo
         Pf6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765617288; x=1766222088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JOzoCCfsiPYQ8ZOhpke3HRGzaSr9kbEG3AtWeuyrAUA=;
        b=jywbKsXKXVtITntWAM9UtGyhuWAefE7bCL0oaBniXMj1dIIDze+mAP1UzQtO85Kwlm
         8euy2XuTZoTENXpVzKSarlN1xBiPm0hT0qocAv5EBDew4w7NjDrWwnJ579/J2xo2kl5u
         aPlksuo/9+v+6d3pU3r2CfmXPri98Inww17rv9kp78IDejNmDVh4Az2kDV1zHBv3pL+d
         XR8DcdPDneEAJ7DoWnIKSI7Dps2NzugA/3ysUCJyWKH1iO3ORw5ZJcnEoiEgPaG7NCN0
         JvwGNJmLHm+Y1ED9/k7/kkpfwnEwv4RBlmYk4BNEIcj9ry3Fysn3yFGeMt4h9EjsW5cf
         DjIQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4WzwtEwXtIApkgSXH5PKxbAse+qFbkin6Rzn1QFZfrIPlIcQ5WJJD50tT5RMp98VKNUJHyPZPwg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzA1BvkOMjCqZYcMCuiAcFolY1FNrFY9rxyspTqcqtHH0h0UPDm
	4FeKptOcme0a9U0gKSsv0Ex94L8j4RMyq1/y0JxxKfUfevbT+kCfQecF
X-Gm-Gg: AY/fxX5vK5kG2Dy9i9vi3oaOK3WIBdzeOPBVNYBVvFoCnBqhzTyNtqDlMr4gOwkzV5j
	aIE2L0xkX2NKcKEMhgkZxCriStTLe3SPunLuqsCwKmHDhrH6YIcAmCLmvy16s2yNp4EDgRTYWxc
	wPmNJH0Y9jBRhbvLBIaW8e+bUsmye7V7Sbql3MVe5NDl7Iz3gRNqT2QPqgSPcn+ZSe+pzMiBE6I
	4m5KvFobFmuPYTjBNH2Q3s3TG3kQKmkIwLqsRalI4U5j1WGgzCJJkLyMW7WwycPMuU/gFKgRCVt
	u2esD/xzVRBQ7GOogctlUsFCBQJeBSZYK6g4bsiGGTY+8evamkjEEWe2VwUYFZWykVNW0iSbNfD
	mM0MJ86zap2CNmKg3+SAsrgHXwfN7RcGC6wx2gPLA9vIYA7IPvzhXNkJ0ddArFFMQ+rBlFiSxTI
	dHDnnzC4y2BiVbW3o+VVc=
X-Google-Smtp-Source: AGHT+IHRKDvFg/tTnqhwSmPqFWyXuAOrWGsunJucfknCCG6aQ4R95tKqD3zYIlyk7oY908iNTYaEbQ==
X-Received: by 2002:a05:6512:3f26:b0:595:91dc:727e with SMTP id 2adb3069b0e04-598faa593a5mr1553747e87.22.1765617288092;
        Sat, 13 Dec 2025 01:14:48 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-598f319517esm2777579e87.81.2025.12.13.01.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Dec 2025 01:14:47 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: joannelkoong@gmail.com
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	bschubert@ddn.com,
	csander@purestorage.com,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	miklos@szeredi.hu,
	xiaobing.li@samsung.com
Subject: Re: [PATCH v1 00/30] fuse/io-uring: add kernel-managed buffer rings and zero-copy
Date: Sat, 13 Dec 2025 12:14:37 +0300
Message-ID: <20251213091437.298874-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Joanne Koong <joannelkoong@gmail.com>:
> This series adds buffer ring and zero-copy capabilities to fuse over io-uring.

So this is superior modern io-uring-based zero-copy for fuse? I. e. modern alternative
to splice fuse hacks here:
https://elixir.bootlin.com/linux/v6.18-rc6/source/fs/fuse/dev.c#L979
https://elixir.bootlin.com/linux/v6.18-rc6/source/fs/fuse/dev.c#L2291
?

If so, then may I remove that fuse splice special-casing?

I assume that splice for fuse is not that fast anyway despite that special-casing
linked above. So code linked above introduce complexity to the kernel without
giving any actual benefits. As opposed to truly fast modern uring interfaces.

Fuse is the only user of "pipe_buf_confirm" outside of fs/pipe.c and fs/splice.c:
https://elixir.bootlin.com/linux/v6.18-rc6/C/ident/pipe_buf_confirm

It is the only user of "PIPE_BUF_FLAG_LRU" outside of fs/splice.c:
https://elixir.bootlin.com/linux/v6.18-rc6/C/ident/PIPE_BUF_FLAG_LRU .

It is the only user of "PIPE_BUF_FLAG_GIFT" outside of fs/splice.c:
https://elixir.bootlin.com/linux/v6.18-rc6/C/ident/PIPE_BUF_FLAG_GIFT .

It is one of the few users of "SPLICE_F_MOVE":
https://elixir.bootlin.com/linux/v6.18-rc6/C/ident/SPLICE_F_MOVE .

It is one of two callers of "pipe_buf_try_steal":
https://elixir.bootlin.com/linux/v6.18-rc6/C/ident/pipe_buf_try_steal
(the other is virtio-console).

(Side note: Linus on pipe_buf_try_steal/SPLICE_F_GIFT: "Now, I would
actually not disagree with removing that part. It's
scary. But I think we don't really have any users (ok, fuse and some
random console driver?)"
- https://lore.kernel.org/all/CAHk-=whYWEUU69nY6k4j1_EQnQDNPy4TqAMvpf1UA111UDdmYg@mail.gmail.com/
)

So, removing special handling of splice in fuse will lead to simplifications
in core pipe/splice code. And I think that we need to do this, because
splice is not fast anyway, compared to uring.

Also from Linus:
> Side note: maybe I should clarify. I have grown to pretty much hate
> splice() over the years, just because it's been a constant source of
> sorrow in so many ways.
...
> It's just that it was never as lovely and as useful as it promised to
> be. So I'd actually be more than happy to just say "let's decommission
> splice entirely, just keeping the interfaces alive for backwards
> compatibility"
...
> I'd be willing to *simplify* splice() by just
> saying "it was all a mistake", and just turning it into wrappers
> around read/write. But those patches would have to be radical
> simplifications, not adding yet more crud on top of the pain that is
> splice().
>
> Because it will hurt performance. And I'm ok with that as long as it
> comes with huge simplifications. What I'm *not* ok with is "I mis-used
> splice, now I want splice to act differently, so let's make it even
> more complicated".
- https://lore.kernel.org/all/CAHk-=wgG_2cmHgZwKjydi7=iimyHyN8aessnbM9XQ9ufbaUz9g@mail.gmail.com/
- https://lore.kernel.org/all/CAHk-=wjixHw6n_R5TQWW1r0a+GgFAPGw21KMj6obkzr3qXXbYA@mail.gmail.com/

For all these reasons, may I remove fuse splice special casing?

-- 
Askar Safin

