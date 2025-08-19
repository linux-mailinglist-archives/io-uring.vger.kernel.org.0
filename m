Return-Path: <io-uring+bounces-9061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39CECB2C6AB
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64E69188A575
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 14:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EF9218AC1;
	Tue, 19 Aug 2025 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="c7EnwLD0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF78A223324
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755612690; cv=none; b=Zk9xv1axEmxrAVw0cY6t7JzmBwWh6CJA/TkNOJeBWDQZOb2vgmLUpc3UGBukYadlHpxpsma8NzcGMwBZqZxiOsWn30L/EVUUKhKlh9z+E7/XkB2PaTLfihviKR89YQ3jjuy1m7xnjp0iswTlQ0rpinXcb8mGhJVTEYPJW6RjW7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755612690; c=relaxed/simple;
	bh=xRadathRlnR3y7oFncqx3Y2FizCMiMTCt0JMEaizNuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rKGrvM8Vkt2NkTo/uKAx2Coe/Cyg5It7kSqrLw+W7+NzlWjWnxHLHnSz5C+LoJ6+BPFnLqiwPbDpbiFSYCgESlI0f2taLB6NdyzRnVeXgfdhWJqb6eeQ8g9IgN/0RAUKYEfKg3+ibKBeHQ/SAoB1hOE4u8CCrmfoHjXguvm8ksg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=c7EnwLD0; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3e584a51a3fso18001505ab.2
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 07:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755612685; x=1756217485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s5wo75Qw7RXQn8p3CqyeYBywD9fyldl5fJo0flLfoaA=;
        b=c7EnwLD04iG1zd8GRSs3vScZ3bEMyioTQjl1xZJOFZADF8ImN7WuRhjfRAtc3pddPa
         5JOuwMkZvvH0me990AY2onbwDJuUSTE/zkIIjgbH/+0XkKcyVWW0KOskgYmFaAUkXcqV
         oBWlHTDQzbbwfyL0oymiEQJ1aMakqm6K+b12id14WpJDrngI5IVBK7JYbQAW3NUvWhGn
         o72CaQYRZUeB+LkZBGJ+RTaan6hs2ZlaK/6sdN4l4e34TjWwximn40LRBGIfNFzYuzkE
         S+sgSjvSAGh1Z/d15CC1BdrFgb9lidQck/xhAZKHlUHb07tKAxIrBaFWqO4Bpm8RhKtB
         MA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755612685; x=1756217485;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s5wo75Qw7RXQn8p3CqyeYBywD9fyldl5fJo0flLfoaA=;
        b=br102RCY2Rcl/eP5/DYO+ygNlLts1cmmpYlNMkO5gBF/l4pOp7Ic8RPCH5cwhYKGoq
         cNrMUyOsK+ENT0eYtjpdURDfIkif8Hj5CeEB15eADq8cVlxcwtVVxce4r4bDRVC8qWAy
         FrLsj6VXvr/FxBKrtez+ccd0JuD6cb69j4n/eVSWLp08Anqqgp7fIEBL3+C0pr5SXg3r
         ODru1ffuGC/if5vgIPFHaJBV+PhMD01oQN9WU8GZeGZYBwktJ1qu4eSZRv2fr0ETbmdX
         m3CIzfMsWRcajc2hSiV/eI9FRIhvSh93YfOc/b92r2DbBlorYsVlyuVxnxZTVHpdkbVW
         XynA==
X-Forwarded-Encrypted: i=1; AJvYcCWY9cCQJCuYJq7B3RNTmT2k/Q0YGw5ZKHgYdUL8zC85MXq+rksg8nSz84nrvkccSRsvxowsVRjonw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2x5qHaqf1RfMYUecZUv1DO06biAlNESDZMfPiAaBUv6tcG1H4
	fWnHY9K4nA4AoSX4MFf74xXDDioslpr7Q2fL6hQrC6f21WE92mNBT5W2GEjQpePq5I0=
X-Gm-Gg: ASbGnct7E1qE4Z4HTalvRU5BdHFB8SsvpbK6DVS+W5mtR5KR7AKckuuWpg8cfvYOr49
	kLyDIHwi6hg67OG1u663l4khIjsfVm/yv1nU/TsoscJHgfV0gfbWoXz25De4Z09+fgEtanGyEZe
	xDscKkXyp9JQENIlI+GnyiJ4W+m0JU03spjzPyQgAO2sLy0l1h30QR++odci4gk9SlL/NhOMsyG
	N6yd5mTzA1sNonsNBajhkhGyuJAKIjXex4mwcXIggZkVazD5pwG7FX/MgL0EQ45Hp47lPpNRspi
	WkBsVWXJi2S0aQHj5q/t4zP2+8C4uF9KQeBBfXXicGdAugHfboQ75duKCinM2NhrUtKQDZQEDUs
	bgCtYlg2X/JLD2ZSR7a+6FVfb4H9vnQ==
X-Google-Smtp-Source: AGHT+IFWge0On2LK+NpXhpR6Lafh0Ln8LTKiiLxHwFM7MBmPBeh+CXhIqEdiLLvZ2Eom917N1UAo6w==
X-Received: by 2002:a05:6e02:1a48:b0:3e5:7281:eb6b with SMTP id e9e14a558f8ab-3e676664b53mr49336905ab.23.1755612684711;
        Tue, 19 Aug 2025 07:11:24 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e66d085b4bsm19143415ab.21.2025.08.19.07.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 07:11:24 -0700 (PDT)
Message-ID: <9290b8d7-d982-4356-ac7f-e9fd0caea042@kernel.dk>
Date: Tue, 19 Aug 2025 08:11:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: uring_cmd: add multishot support
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20250819114532.959011-1-ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250819114532.959011-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Added a comment on v1, but outside of that, do where's the ublk patch
utilizing this? Would be nice to see that, too.

-- 
Jens Axboe

