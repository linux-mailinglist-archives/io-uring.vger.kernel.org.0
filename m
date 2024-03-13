Return-Path: <io-uring+bounces-935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7EC87B3FB
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 22:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B03A21C22E62
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0337E55E6E;
	Wed, 13 Mar 2024 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hsR2TRDB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693A955C13
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 21:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710366988; cv=none; b=FLr4PX2Gq/BM+ClwoSveHmUT2CdNlByawSk44bq91KT9cdn0yfT5Tt1BDhZi50YmHEqc0/Bjqza5NuuM1qDF9VWpWulyJ5d+5yrgjoLLAk7gD30ZIIc5hsidpIc0OwjMjB5YVwszt/J8qw8+CziCgoYpLy6d7OzYgRFxuJRSouA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710366988; c=relaxed/simple;
	bh=DhJq/gSiVVKv/GKH5X2EYavCs3/0A7pdasLyPSf/olo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tjuzmdCCzNC59ZTbY2Nx00D0Q50DAWzQAnBpCv0hORVxr4sqjlWvgYeDkDk1xukvrTVHZC6rTgu8ap/BI83rOgbRrJq53Ztm9ubCkHI5QEpTE+LbMTp0PEcjOCN8egNOODZBCe0JOkLpvx0G8AZ07Eny7NR1barl1seUv28lSrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hsR2TRDB; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3663903844bso562665ab.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 14:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710366985; x=1710971785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJ/XoWSOo9AsD5L9BQdnIPO8fYYl7LCdXj4BmFJwPrQ=;
        b=hsR2TRDBvX9phGJgvbYKWqpfGRcwKnjpiGCIxUYptYb1A4rWBErywRKB/Ex7uL7lMW
         V+fVsBMWaUmEN5WK4i/gR67yfvizsuJS2dLDA7ulsMaCaRBDiwLUCi33icDMkXyqMZyM
         iX2beEw2fB11xCec1xcpp15DtYE2pFo7UjIZhSrZFl+T/dnhZqlhQrEp1wpfdZibeHYy
         TgomJAam91nYNAVwJJfseRhK4ltXCT0zRH1ShxwFyXnISSFedn/jqMrow6o2e5Q16xRc
         i3Jd7KCOFEgS7uGqZp7sOMxYjVj4Hh+aDbqIKqN1v/1BWyw9ZSigGRqJuxP6apENDxNE
         BkwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710366985; x=1710971785;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KJ/XoWSOo9AsD5L9BQdnIPO8fYYl7LCdXj4BmFJwPrQ=;
        b=Yj86NktecAqelpjY6QEH9uCUWGmLkSroKjW+lvZ8gYRjMq4tvsdg8JNx1x6lbcZQ8L
         JCEZyLaZ78K3qxjPjW+PdiZQ1uBnO5gKDoAEfS37RZ1bEC8MOkBUejtkCrd3QxRrI1nt
         7rDT2hcwsOuo49TehUzOgD1scF6jxmH3XNZ0I/4i+V1GV73an/fxlzErmLvuSzJaeH7k
         aajmmz43u3ood0eeLrJpjkiJERaqMLCofcOjY7JfZIoyWh0eoziD/9uS9Ze1Es+cTXq6
         +Oa2zU3sSMDkD4NX71yHu64evGAsgY52gHuNzll3tdpEFYmM0RLZQfFNlO2/kofVJj00
         l8Pw==
X-Gm-Message-State: AOJu0YxJcta8UpeYZnfM4ZlFnhwKsOMvcb4QmY0tsILunWaHjKY3wkU4
	LFvBdTqP6LunFqlmOHLuXIxR9oz81zQFP57tlN1b/ytAtqya53oq0Q7nS4Gj2rw=
X-Google-Smtp-Source: AGHT+IEwnP25jOK5sl+hfwFygq9e91avQQ0XNjhC2vQme7wid1uPqdLfCsHSxdGrtGFd9Vj/CPIBpQ==
X-Received: by 2002:a05:6e02:1c89:b0:365:4e45:33ad with SMTP id w9-20020a056e021c8900b003654e4533admr6854449ill.1.1710366985264;
        Wed, 13 Mar 2024 14:56:25 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q3-20020a056e02096300b0036426373792sm56959ilt.87.2024.03.13.14.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 14:56:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240313213912.1920-1-krisman@suse.de>
References: <20240313213912.1920-1-krisman@suse.de>
Subject: Re: [PATCH] io_uring: Fix release of pinned pages when
 __io_uaddr_map fails
Message-Id: <171036698448.360413.17779836666401821434.b4-ty@kernel.dk>
Date: Wed, 13 Mar 2024 15:56:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 13 Mar 2024 17:39:12 -0400, Gabriel Krisman Bertazi wrote:
> Looking at the error path of __io_uaddr_map, if we fail after pinning
> the pages for any reasons, ret will be set to -EINVAL and the error
> handler won't properly release the pinned pages.
> 
> I didn't manage to trigger it without forcing a failure, but it can
> happen in real life when memory is heavily fragmented.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Fix release of pinned pages when __io_uaddr_map fails
      (no commit info)

Best regards,
-- 
Jens Axboe




