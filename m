Return-Path: <io-uring+bounces-7932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57709AB16A8
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 16:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AC011675CC
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 14:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876012949F2;
	Fri,  9 May 2025 13:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cBVcA/kh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439652900AE
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746799082; cv=none; b=FV3B7gFYt5Yd9srfD1CTx65zY5HGA4U69yYGG5k3d9EEPFSfefI8dyhOCwtj0NxFuJfumcgaxDOyQF6xSG82yNCGp51f//ZIT762V3iFKcCMLn3JEkTAOKCQopkAD0L6aVs8ejWTgo2Jbiev3LUIEFMNygeYOBVWXMLO/vn4arg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746799082; c=relaxed/simple;
	bh=8YdkcLYTzFwFPRytQ8umZ1QkLnqyDQ65attWrzXqloc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rrojOugS6QhnDYrGvmgfm35//cgxqXBkv+iFrV5V9Z4yD17p1Ryej4TAH/Zh6rWPmtDgD7HTFMLnoD+hYzquh6hW4EWxudJMIu51qKOpgudGiF3+UMs8cAGXJcBSRbsCiBTiY6+ny9vzf3S7VCIBaq3E2KxG2wojW97JZh1r5bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cBVcA/kh; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d91db4f0c3so11283465ab.3
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 06:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746799076; x=1747403876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMdYJosOtf1rJfXtyOmunTmdsXAeZAZ6syPOULijIfc=;
        b=cBVcA/kh7IeU7mvxWywa49NtawURvwg1/S9/Fh9NjQhA8ZaS68ibSSzUUByLf/x1ut
         6ufEIxxcQNNrrpXqgO8ytRQT2V2NmQdBvnFdBBUB8IqaRXizEIqoLwHkdMHIebnoy1H3
         DfTkKKaPn8F3hZaFTyEL4JydehyKOvTwlwt/YhtGJtNW0/NL2Hz+9tkqjgLHy8syyVf3
         dmc1dusXJ4MDddLCwwwDIvhDa0mCTKTCz8Z2z6KAhhGrv4etX5Jp/G65Q++qjFnRqXk9
         1yQUbzHEnuugChvYJz74hZ4SC2MasLxhFk3EyUvxfGeL5ISOv9Y+cqTrengMh4IXfs7B
         eGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746799076; x=1747403876;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BMdYJosOtf1rJfXtyOmunTmdsXAeZAZ6syPOULijIfc=;
        b=kVhh45AJC2XL9sA8LYbR2s4ZzejXrR1rVITeKuQ6gsk0GAou2ShAA4g6T7KiNLfQ/o
         b+doqb1nt3gUYkj0nXsp2TZDNJ1bhSeqiM3mRW4s5fkhWOfBJNx5wPzPi1aWDzu/HPPj
         PbXfAMECCTCuiAYWqLTIdDyH3entyCsNy76HyOOphzvbQLou/vPHtPjbMGGUp+NrtxZS
         zZ1Lust07x4KGLCM78j1xSDSWDTFpRTTwVX4q4EedltSjCuPs30cgPr43yfaN1WufHE7
         bBGiiJFW/YrONn1KAApsjqLKQ/cjYzD0KOWYgtEEcYTiLxu9iUDVe0u8WAEQZI6kJR/1
         mqbA==
X-Gm-Message-State: AOJu0YylrAdi1lQXTdFZuyG7SB2qS3+Lqg9MuCHODvl0K34uCZOn9HWo
	Bf4c+lNFK2rZ43SERzf4hBYuL+dGKFr7u3KOdG5CzfzirxrC1WaWeZTpCCutrif6EZ1rHJVfjUM
	p
X-Gm-Gg: ASbGncv+jRhSRhC4DsAGXPGRd+ufHpBOLRaojFlxTCxuSUVOlJm+PpV2BFlswGYac2M
	kAqUXvknx5GGL02uYBnGbRcwzBohQpykOrHR0w2BfwB6xCpPsn1vA4/q8B1k4MjPWi4bqmjkCw/
	BjTvttliSk/5ZlDb5bZkVgU9ZrKeBbQH+q1ciekgq23Zf6j9tA9zF7rxybDrxHcUDTn4zqvk+1S
	Zl9dCXw0oSV/Xz6sME6SlhOJGmq553b9lpBJvGxFlDxWTi2UvLsl/39cWxAoy7WnqK7a/YtQUwx
	r+knCGIkh9WnRmqjTuF4JCI9lv6w7/k=
X-Google-Smtp-Source: AGHT+IHaj/WA2jlPbP3mnvY7WhTeuAba4sZF3BJYg4YqJz1ml2sG5NfLlAX+vwmc/tRs21cICK4u9A==
X-Received: by 2002:a05:6e02:178d:b0:3d5:890b:8ee with SMTP id e9e14a558f8ab-3da7e1e2417mr41863815ab.2.1746799076404;
        Fri, 09 May 2025 06:57:56 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da7e158bfcsm5455985ab.58.2025.05.09.06.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 06:57:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20250508181203.3785544-1-krisman@suse.de>
References: <20250508181203.3785544-1-krisman@suse.de>
Subject: Re: [PATCH] io_uring/sqpoll: Increase task_work submission batch
 size
Message-Id: <174679907531.93446.7646054037339322559.b4-ty@kernel.dk>
Date: Fri, 09 May 2025 07:57:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 08 May 2025 14:12:03 -0400, Gabriel Krisman Bertazi wrote:
> Our QA team reported a 10%-23%, throughput reduction on an io_uring
> sqpoll testcase doing IO to a null_blk, that I traced back to a
> reduction of the device submission queue depth utilization. It turns out
> that, after commit af5d68f8892f ("io_uring/sqpoll: manage task_work
> privately"), we capped the number of task_work entries that can be
> completed from a single spin of sqpoll to only 8 entries, before the
> sqpoll goes around to (potentially) sleep.  While this cap doesn't drive
> the submission side directly, it impacts the completion behavior, which
> affects the number of IO queued by fio per sqpoll cycle on the
> submission side, and io_uring ends up seeing less ios per sqpoll cycle.
> As a result, block layer plugging is less effective, and we see more
> time spent inside the block layer in profilings charts, and increased
> submission latency measured by fio.
> 
> [...]

Applied, thanks!

[1/1] io_uring/sqpoll: Increase task_work submission batch size
      (no commit info)

Best regards,
-- 
Jens Axboe




