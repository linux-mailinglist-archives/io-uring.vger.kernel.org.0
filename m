Return-Path: <io-uring+bounces-11309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B2ECDDDF3
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 16:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2B0F300EA06
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 15:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03E11F8755;
	Thu, 25 Dec 2025 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y47mcnct"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1DC189BB0
	for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766675336; cv=none; b=YoZJYfAg02B6N+2u9mmYQPQdnxXMJF5JHn/O2jRhcqGMxx9NmGHPf+uMT9/OCJIvQWNTPe0LOKyG+Iru611mayTHTq+IhiitzqHSYsZsvP3hDSZW5gwJX38c/m7cBIepd+RJ4RuFgpSAlc683Lr7c4dkr7eUJcCx07tMbq59mNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766675336; c=relaxed/simple;
	bh=1a8WVK/5R0u2R7uTPPcpwGnVq8+rcROVcLyIqeUBGAE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kwWLv+fK7b577EARcigw51RmIzQYMty/6aBljDoVCYmMlLRIXgiTzxBQHG9hw1L0rBEKW1LFFhXYqt7ZyPD0XNKEuHM65n4G9LJjrqWCWDMigDpZU/kOluUQ+p5450lZb53zKiX61lnmW7lW+H/DmIUBuYff34+JfQBIT0oGU38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y47mcnct; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-44fe6771b2dso1477357b6e.1
        for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 07:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766675334; x=1767280134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4enrxTcJXMNYO4nBPNY3Xlx1Fas4M0tOaGVZ1+UN1kM=;
        b=y47mcncthDnI769p6rGhLZVqjvRvc+lOVw1hkhnC42UnzCu7Bb9iCYZLMZxbpdFSO9
         jI/nlAsiPGZDvdY7g+cy+CJDn9g2mxe/ygo3QpYZwEsQAW7fUygMmJ5HFvqRINeEUThU
         mUtOXHqHe/erbTMOdVbuQL+X3NHcMoYzH7uWd32jFWiMhc5PGomsc9wOySFTsqn6jHSr
         M/UQbF6GDyiAPb0lEJ6iqYY/aGaTpGaqrM5BfRclKKgQBlO/ZAV+deKzQUbsoTAVMQbJ
         MqrgW8UBPenQTFJazvsjrEr/6d5ssotX6MOTbSVS9aDVIBS2Nr1/sknzo9/cHOO5QkWj
         9u+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766675334; x=1767280134;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4enrxTcJXMNYO4nBPNY3Xlx1Fas4M0tOaGVZ1+UN1kM=;
        b=dHgNiV3EN3vT/vJYpNJp9pvo3b9e/Hzl5VjOzvFZnfqZ5EUU7GxswWIU2m4Xer651X
         iA+IjZ1lzp9cMCvtscxEQSRRc3pHCouuTIbryLLLivE64bq+kASakaJ3t1RVOV5mTc9s
         kIW9p5+nI10PrVj39bao7faa05ssJUEtn4IzOdzOsR+hW4+qQeTbj1oqxitGQOslgMr9
         cyNLXfJ3ml9feAwxdyhum8LQRL+FULbkDUDbwGEzPM9bbaT6w0REDJEhzHLQumv/60ZK
         JSRRZQkQD+9UjbFnE6rq2JRLtz3F8lryip+DkJ5Cd3SqhqnvcuYa2wcX0wezIgS2SgeB
         GMFA==
X-Gm-Message-State: AOJu0YyEjVeRRI2s0Peh2Wf7Cb5ve71yg5xIlzCoHdrPawcSaifaiP1Y
	uhbiUxzKQ3MOftFV8bO7tUbpH28oSiAela6/MN/auh2zXRZ43T1pMGQ/jXVPu5BDBxs=
X-Gm-Gg: AY/fxX4b2gv4yV2Dsqdi9fQp/MRcjR5GgqlWi2DDMQ3YqF20WG76viD8pXMzeDE4V/S
	vrGrgGty667f1K6hk1TZ26y50C7TjSpYUFOGGqa208tz8DbSWRsECQRaUvAMSSZKdeg+0JYmdGF
	uld8bJ7K96vLgEp4B+jO7JoCNFlr5F1NGONEDsvf7t8j45vVfdyYuY32q0QXBXv+WMNCniu1YMO
	eNArWFo+UCsNzLyJ4g+gJGEjQ1yKBnrv3MdCKZNUh+2vMbnCS/jsToyRIVevSpVwhyEZvCqUta9
	ijs/I5yOH2obAe7dE2Uy2CDFouTp/mok8Yglqx35wC41T3LqurxcIoWff8UGDLZgdEEzvkp8Ubw
	LNXwxZDrNJeKNFgVhWoXqzbCHYdY0fQBM9RSG/fRs+d+QptmW01niJqHANPyoXoVwxNKyLY3cZP
	aw4L4=
X-Google-Smtp-Source: AGHT+IHvysv98JjOtrG/XeetHHlKyurM7jKSGEnAoF86eGaByvTJgHoycWQr3WJoF84WobCqIy6E9Q==
X-Received: by 2002:a05:6808:1b1e:b0:450:c9c3:a249 with SMTP id 5614622812f47-457b21cfc2amr10228559b6e.45.1766675333911;
        Thu, 25 Dec 2025 07:08:53 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-457b3edb41fsm9481403b6e.18.2025.12.25.07.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 07:08:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Prithvi Tambewagh <activprithvi@gmail.com>
Cc: io-uring@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
 viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org, 
 syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com, 
 stable@vger.kernel.org
In-Reply-To: <20251225072829.44646-1-activprithvi@gmail.com>
References: <20251225072829.44646-1-activprithvi@gmail.com>
Subject: Re: [PATCH v2] io_uring: fix filename leak in __io_openat_prep()
Message-Id: <176667533028.68806.11770987520631890583.b4-ty@kernel.dk>
Date: Thu, 25 Dec 2025 08:08:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 25 Dec 2025 12:58:29 +0530, Prithvi Tambewagh wrote:
>  __io_openat_prep() allocates a struct filename using getname(). However,
> for the condition of the file being installed in the fixed file table as
> well as having O_CLOEXEC flag set, the function returns early. At that
> point, the request doesn't have REQ_F_NEED_CLEANUP flag set. Due to this,
> the memory for the newly allocated struct filename is not cleaned up,
> causing a memory leak.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix filename leak in __io_openat_prep()
      commit: b14fad555302a2104948feaff70503b64c80ac01

Best regards,
-- 
Jens Axboe




