Return-Path: <io-uring+bounces-10699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 43351C75195
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 16:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 747194F0760
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 15:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D67F2F0C69;
	Thu, 20 Nov 2025 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1cchHl4z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A0278F4F
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652431; cv=none; b=o2JBNTf68KRWP5YK1fwXfW8ymzEV5OjeOeZFG0yeQl5KprPcRknW/ckqoiwrlZvw9ym/sHCrBnafboVrSx03OwT4gwzUA+lQeWtIbiCTCiQbXEiVgxGjqeKoSSrZYju/Kqx72BHTZEpHQjoNV9EBLzuZfz2tSI5dQYcZSbbXkgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652431; c=relaxed/simple;
	bh=vO8S7CAM4NW3TUCn+2+2RPutoWVDqXZYWN2xNp5LpLg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nmj3GbhdfDKwV5yj3e0r1c9+aLvv8KECC/c5ZqKclA9z7kCBKQ3e160HNPynKEVlZRrDLwj/22nWrWXn76ZXRa7nKGAGJNMAfxNQOsi+1Awh/8wAWYK3Ih8R1gMBxklQKcANCrN8l0Cs0EZwyzwwlkG3yQyw8ObheJGz3V5oQ/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1cchHl4z; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-94903ea3766so36955639f.3
        for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 07:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763652427; x=1764257227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ObN5c0ihie3J51JMKIXx0Z/Dq9nMiHVoUXgShWnvgnQ=;
        b=1cchHl4zhwIRTO0V26MWn/ey39pmN0f+9pokd7ZJJQNkdWCM+GS+4ObyFWCzPL7JIz
         GgbEApjq5a5vRsk+5JfM/M0kSokz1lMSGU8w3KZrwoUMyYA0SJppv6LAU0l+np+LNAxE
         zdOnBmWFtt3H5nSkHCtM1sK6TxZjq7tzENb+OWnrAw9cwXC4oLs5VhDemildGtxNuWpc
         AvkXlNfJartLWWMgiO/FYi4iKaWMx7LvL5TLTYXY0HLPPgmE9KHMhHWRit/guqfZTnE8
         6o4xW+wnO51bUeGR8uUwtDGo+kF9HDo6U5NrLw74wfV6nh/9gJ2iyIc1bcNJTVA3akBP
         +nAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652427; x=1764257227;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ObN5c0ihie3J51JMKIXx0Z/Dq9nMiHVoUXgShWnvgnQ=;
        b=kdwv6USkHmyyyFBysQdVW7VAs5Tlr8c06O4naaUXJ97az0iH63xGgv+G8bzP7fnVsL
         mUySz3N2qJV3Xk2eOVtCn18mLTLiZP6++mjl8gS9NFlWKbtlYrkiCa3+nEyJDIQJMncJ
         pplwTaTUqe/n9Mi6FXk+El2SUS3yvLIVKGvoS5s8Jf8t5BabB1YVSqebnWNRLpjjptzS
         xQqjCWg5JqOkE8WK6PUT/1FalCI0Fks0LyTicFS1DKJDUqjXKlWtzv6bwsYnrYCTVrQF
         aDu8XnhZ2w+kbzqfIo2qXd6gScs5JpWdhKJ9tw7L3s53SBBG9/MYt9nXNIjMDiGhWQ4S
         Piew==
X-Gm-Message-State: AOJu0Ywbsts8wpgIFGbvFoLtdfaCS+gl2dimVUcqRXVbl4lPvmv8bx3f
	V+45AC5UcBTFZma+1ZM2h84+g4llVElR2OnQawmBdi0wu7jw16eZxSlfwCrElxMWuGbruLmth1i
	n4j7s
X-Gm-Gg: ASbGnctApoBtM3uvATvMg/6AW5uFR/UwcTcGyZGIW/MBXkTlnuokvlm5zNPny/2vkVp
	G7JmjrR5Jbvg9J8Emigg6dils2yqbIIKjIMPPggZCiHdEr+poNnUI8tG4ilroci7VByQMK5/8Py
	aUsxvYu9L1lBKbE6xTzYLbNLnLG6purD0sPk8zKR4lecQmpCdYKva4k+x1yA8E4y64fj834eumZ
	vi0GE7yrH+9kv8Qy8fYCOtc/btQnOV524AIGGkXckoco/5/6ElIRYG9yFz80xEBxtwX/hW6m5ka
	8lts5gHc3NWLp4Bgct8cqax1HxzGF4BXq3+GVplScfIEWsvDvDjtXAJkKOdCiXrAxid/KUjPmah
	+6IT9Fh3KG9DTYXyZPz0AgutfOs6hROG20bg3LInmdZkQqTRcmYCu9e2YwXaRmLxRwQPH6srPz/
	mDvw==
X-Google-Smtp-Source: AGHT+IECd2IeVGQbkw4RhzM4aH53Oe7IwwmZLNNGfAY/20LRkz205gIQn4/XR/oZS+iLPfn8Sh3eoA==
X-Received: by 2002:a05:6638:29a9:b0:5b7:d710:6619 with SMTP id 8926c6da1cb9f-5b9541a7569mr2754370173.20.1763652427515;
        Thu, 20 Nov 2025 07:27:07 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954a0de5esm1044983173.6.2025.11.20.07.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:27:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Keith Busch <kbusch@meta.com>
Cc: Keith Busch <kbusch@kernel.org>
In-Reply-To: <20251120152427.452869-1-kbusch@meta.com>
References: <20251120152427.452869-1-kbusch@meta.com>
Subject: Re: [PATCH] liburing: sync pi attributes with kernel uapi
Message-Id: <176365242447.574437.9626064058250918903.b4-ty@kernel.dk>
Date: Thu, 20 Nov 2025 08:27:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 20 Nov 2025 07:24:27 -0800, Keith Busch wrote:
> These were introduced in kernel release 6.13.
> 
> 

Applied, thanks!

[1/1] liburing: sync pi attributes with kernel uapi
      commit: 679b42227999633f67cf0e6183f939495025e95c

Best regards,
-- 
Jens Axboe




