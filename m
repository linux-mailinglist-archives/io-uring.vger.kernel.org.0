Return-Path: <io-uring+bounces-5599-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 507289FB5F0
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 21:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E4501885C67
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 20:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772D11AE01E;
	Mon, 23 Dec 2024 20:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F9RmjoM/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112C71D5CC1
	for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 20:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734987332; cv=none; b=qWSmu83R7AD5lKxs9U92i6+e4fkVPu2kL1QdCDuCwuPf1Sttdn70XG1NSYRSOZVgMHEHnQkVw1Kijob+jYucqfGHufd5Dtw9nRXlgHtJcYEEu1fd22Wyyg7MM1kFrjDLh7qAJR+2LW4NF3TyAuJREj08UjnHiB4bUbMli/mBtOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734987332; c=relaxed/simple;
	bh=VSPoKX7WwLzga4Nf5YGkeN3wuogJrbCdSBNajadGbMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MUE0nU9/G9nTVSXy9bHuQbNyWAWxLCXGnj0UqSw2LGkfFO2SPVFvCiTABzHuNTQfYUjqV4Ay02gQAfAMNGB36T+RjdKBefT0zhp8QJbqKqQW1QuEYeY5gcFqv1sIQ3D+efl+KNDn7r4Tkn8ujCGQaPfRV0l4j4zSivDd1WIsnzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F9RmjoM/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2167141dfa1so41390425ad.1
        for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 12:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734987330; x=1735592130; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j5J3/RmK37VMndJ+ng5woBQlhZld9vGGJhdS8VQxeTU=;
        b=F9RmjoM/2ub5ixLRrI91C1TJUjGUIzSiOrgeKah9iw6KHZpvie4b9Bjh/j/bzgFRF1
         d5Ze+k1T/KZyXq123tDu5m/zzpKGrtXRsPAAsZcTWIebEi8qPm//jOqUW3MJiJq46NCx
         NPsrn5aJLgVJTzja7Jok5tcFKNzGmdkNXeHtxtRmFaUoypprkmco4KcbKu+YSkPQZIeJ
         96ns0U0TZvl1GxcDprd/+0c1RELr5fgSOCfnpa74X4A2mcSPWNqPcs1xb6cYXilOpjUU
         LNaNYUf8jcHQUrCGX3y1hdb/gSp+oYNLYFqR7qXqOi/r7aakySIHUad4JPuDf5J7h8TF
         +fYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734987330; x=1735592130;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5J3/RmK37VMndJ+ng5woBQlhZld9vGGJhdS8VQxeTU=;
        b=hBUNDtafbrhqrK51v/6MZJBM89UsFDFG6aZ+tC/ceVAhfxv1wUTB+VsJzY+5dNjMx5
         ZQ4FyTkBanE1p7MmgVUXf1u6iORNgwMnfa5R0ewyqHlzrewv7hMTDQIZFZjF9AwfgxPF
         iGDCtaLdh6EClTmIyqmk0Gx1+gVd2vx48Svl3meiJjhvmWNlQl8KpjE5C1X0k3KbpR/6
         HjS39uFI6mzB9OW9WYFx8mVs/It2zpl23eJr2yH9CQBawUs+Y0BsDgTS3ZaYMrAU/uLM
         IQ0uGoPpBtxt3YU+ha9QbGbS2XGZKH/Dd/+804z6duuwT/5ERLFRCmjLKiX3OfZvhKLG
         UtLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcwPQvYaDZRMwHn9/4tZAlUajPkfnVzsTqqkM4ybaRJhfBD8oRwk0xe2xmfuROU5qQovZhDeOM0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyGRjkeR3jVOiWe/IuYM6KAthrwDzl+/7Tazhp62r77g17sfPql
	Jf3X/uAQB3qPmzWtch0tqY8l0nGSPljgP2Rbh8lenbngTvlFeVzsbzvoXj8YSek=
X-Gm-Gg: ASbGncv7QW23gQpenXJf+NV1NureQiagA7AZCg6rz4O22FGKLBQjiIYTBTluiT5DK4M
	d2xT8Qzo46cFEZsVhNqWabXbcjI1GQ2oZc5femMMgYLqmG9q6QCK4bjRElFtGCsR2nXWUG8U/+D
	vEwSc2P/1VsTNEfRq/8SQgQ5K/VU1GGmZ0FAKr0mWFAnRMuCpSz8OGdNp1BCB22J54ZJyRNpzuv
	hIzwwMtANJZnC54+x6rEpWzUt060DFnkWalslSUt047xIJT6H2ssQ==
X-Google-Smtp-Source: AGHT+IEWgE+EhGuszPyZ3kVvfPYlZaWJ44Btw4stqijwKKKrA6aoF9URRe9k4cpnxjeiI1InxNPI2Q==
X-Received: by 2002:a17:903:320a:b0:215:4f99:4ef5 with SMTP id d9443c01a7336-219e6d6cc31mr220176655ad.28.1734987330428;
        Mon, 23 Dec 2024 12:55:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f7d83sm77971375ad.226.2024.12.23.12.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2024 12:55:29 -0800 (PST)
Message-ID: <ea8b4924-e397-4ff2-85b5-9efbe63a9e0e@kernel.dk>
Date: Mon, 23 Dec 2024 13:55:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in percpu_ref_put_many
To: Caleb Sander <csander@purestorage.com>
Cc: syzbot <syzbot+3dcac84cc1d50f43ed31@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
References: <6769bf7b.050a0220.226966.0041.GAE@google.com>
 <2f80272f-6cab-489d-ba2b-c1d545ac3485@kernel.dk>
 <CADUfDZqtiT8B_LvTRuzT9QB+7z+7pNqYJd_n2gQYK1d8cKkxqA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZqtiT8B_LvTRuzT9QB+7z+7pNqYJd_n2gQYK1d8cKkxqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/23/24 1:52 PM, Caleb Sander wrote:
> This is probably the same bug that is being addressed by
> https://lore.kernel.org/lkml/20241218185000.17920-2-leocstone@gmail.com/T/

Yep that looks highly plausible. We should get this queued for 6.12 and
marked for stable, it's missing the cc stable tag.

-- 
Jens Axboe


