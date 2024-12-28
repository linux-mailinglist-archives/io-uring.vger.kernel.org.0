Return-Path: <io-uring+bounces-5621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C86B9FDC26
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 21:14:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFB1016102E
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 20:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C9E3595F;
	Sat, 28 Dec 2024 20:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZoI3aOCD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1BE70823
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 20:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735416845; cv=none; b=UU0KNJzAUebJI1xiE1n+3KDcAz2b42rBQijVhUIa8QQVeXZdgnnknwETuPh11yqpvTEm/GDj8JQh8dYsNDb8Ww8vuqN7t5XrOYPHbM2t6bY3bUapsOc54lra1cxwxLnT0yNw5198cfmJP7b0+817KBU1jWRIyF4cWaztmqtm0Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735416845; c=relaxed/simple;
	bh=MTvsTgqTyBBbtyhlVlRVxvhKjKkvNKFKOyIqeuYmSgE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qN3Mms684qAl9yBlRTRS3z6Xud4sDWQekuUexCnZ7lektUrTTuRcmEjZDM1QKVpf0EBrmt9yYGp8feTiQ+w0/sv+YF1FRhWTX7CLPU8JI3y7rPh/yiTmrKLRo3SnI/0lwiqnlzw3a+4ggfRAGdjKkPoMC8bF4Z16hZjRFeZuhoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZoI3aOCD; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2166360285dso103162465ad.1
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 12:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735416841; x=1736021641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SRibZX2FsGiWzULVwiRmYKimyHZVz1dHLjfEjiGh5VY=;
        b=ZoI3aOCDmf0IRZeHk39vB5YpEnnLdszBZ7Skxfa0WYk27NzYw5aFjNgw4WeJ6STY9Q
         RUYFduy8aQAImnw/X3YCGzD8sTtHRLHNzj8yLAkwqrBltyVRULxQgias7HCU9J6EF6fh
         4iFYDvXf4922doIWxh5v9/3FCNRBrWQmc9bdu+yeJ6cqffSPVCYnKdAvj8b/PipVmdmZ
         CrHSGE8/bE5yEMc+wY55Djw1vvPgavE4B+6iihtx8PmdyABbIAhJ09d+Qxp2lwZme1Ww
         5daayQ/qh1rGiQNGE4sBkt8OH/anEDW/4rtkxqbbnpo/xTbirVfeiIrEt1DiylskgJNf
         EgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735416841; x=1736021641;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SRibZX2FsGiWzULVwiRmYKimyHZVz1dHLjfEjiGh5VY=;
        b=cmnzmdUmMl8byAxq/qTwtYMr2dRkt7FP04oo9TufxkqzKV6WplZBPWCFqbjdGadGry
         AYnbhqswjjJFcV1yDb33dQoKoVFIM7JhGpOtD5ev0qBmsEhCmZFMahaibvbOoM9wt1VV
         +qniChU10uXLnFN1ctGUthnsb3uyKcV8dWMDgxsQeXpnVmEoZhRQa19MybqmlnLX0h3n
         Ko8yqj7/hbsRYHhiFxEFG3iRPqWEY0M8Iw9mwOGU4+9QgMN8T3JxSCw8/d2Mj+xYQRbr
         6QLNo6Vx3Df9DBRBuocs/xZQVO7IVm9rX1SdFjH5sgNopXHowXCPODodwmaHAPsdEZS3
         cgAQ==
X-Gm-Message-State: AOJu0YyBS4XUdPfKQrm39Kt50QJaoC8scHjoRj/obRLuYVtg3RIptK4f
	JRllLBl3lqn3nW6Ps1hZBtSSZD/sdCYZX9VDCwlVmh6hJxv6uZKeV8XbOKTQS20=
X-Gm-Gg: ASbGnctSfVZm8VbZM2xW/rif0NIFKgi6VbFJ8B32OSf9WSdvvYwYGCZ8u+trAnOysqY
	zZqN/A1kmSjRuH68EcUjzF09lmukkPCt+H46X25R89gLXzuKv0qJDrGJVa7czeMZzbUrVgGvsk1
	veGDtWCXFnntxKoZPewooWBlnoXsUBY34zjxDhnPguymsNrtYHERPxn+uj915GYPz+0rsjHB+HT
	PftoC719+7YgE+1btK8W3VHqKjNz7pJyDqoqMZItifuH2ag
X-Google-Smtp-Source: AGHT+IGds61T3/6cL0cZenk6zbSO9b1dHCRfbVHY9SHnVUeGroac49Chu7l9bz/7DTsc58ZphvL4nw==
X-Received: by 2002:a17:903:22c3:b0:216:2abc:194f with SMTP id d9443c01a7336-219e6f108famr491204495ad.40.1735416841170;
        Sat, 28 Dec 2024 12:14:01 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dca02e3dsm149562025ad.282.2024.12.28.12.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2024 12:14:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: chase xd <sl1589472800@gmail.com>
In-Reply-To: <c5c8c4a50a882fd581257b81bf52eee260ac29fd.1735407848.git.asml.silence@gmail.com>
References: <c5c8c4a50a882fd581257b81bf52eee260ac29fd.1735407848.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 1/1] io_uring/rw: fix downgraded mshot read
Message-Id: <173541684006.337376.14250384523524172856.b4-ty@kernel.dk>
Date: Sat, 28 Dec 2024 13:14:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Sat, 28 Dec 2024 17:44:52 +0000, Pavel Begunkov wrote:
> The iowq path can downgrade a multishot request to the oneshot mode,
> however io_read_mshot() doesn't handle that and would still post
> multiple CQEs. That's not allowed, because io_req_post_cqe() requires
> stricter context requirements.
> 
> The described can only happen with pollable files that don't support
> FMODE_NOWAIT, which is an odd combination, so if even allowed it should
> be fairly rare.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rw: fix downgraded mshot read
      commit: 38fc96a58ce40257aec79b32e9b310c86907c63c

Best regards,
-- 
Jens Axboe




