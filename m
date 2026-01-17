Return-Path: <io-uring+bounces-11794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C446D38BF8
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 04:50:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31F38302858D
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 03:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA7428030E;
	Sat, 17 Jan 2026 03:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1te7Qgs2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9BE29D273
	for <io-uring@vger.kernel.org>; Sat, 17 Jan 2026 03:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768621840; cv=none; b=cVnz7RKy3XxZiGNAn7XGaLIO0q4zvLwoCkjTAGzLt7a/0tBUZ9AfS6MRaqLdu+IlXCdVhUznfxiJthpzHDPPIVBHuEKyxjTNgKsbeJld5f5qqtVs89UBm5Ti9A9+0BXaOwhGQmLJDWDkdb7+HcZ2qdbpd/VXBmcx8DVxX33bVM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768621840; c=relaxed/simple;
	bh=+QKhiBXRe7qm87a7KZbu+s+PpzGMGtPzYucdel0CheA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=YSWC0vEwBhQCUs9OPIE3uAr6TbbdxhcbRy7fDEczLySlD5HoG7X/CnuEiBtzVt7eDMZBuwqEno4pfDldgO3xivTxFWHdmjXahnM89stJEyqFD2jWgWyNp2ig38FZaV0NkmjCbcL8m4NLn+PIWacTNQ/Wx41af849faWVyB9dz1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1te7Qgs2; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-3ec47e4c20eso2360694fac.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 19:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768621837; x=1769226637; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSpST2Vurk/rI/BmErx6HNaHnzQJfGWr89dueeot/Lg=;
        b=1te7Qgs2aMO23xmZ9487xV7yxyXG6mljXLIrbq7cQYl4SRNMXsjCeXQZzlmB/dXSOx
         b6mhs0GaG/5Fp+wAvUurAoytgYJzRWugTurebhOIusubiGpjklxsJCnpKLMMI6jVbjC9
         H5qjUgM++jLAlbnLg08UgZ8ZLbUxYRzubXJt1gvEnYB06T0hW5r8tDeGHRDrJ5vnlb8x
         Jhd1N5U517MSWdZ9ifp48sC76fCWQkNy6wH5GIGlBylTEklnfXjQFudjPPFMSk/qAdxI
         se582tcfe5QpBPLu4qOrWBtVCOt8OnflM1ONC5nTMRx57RTopBuvTjIWUlCe+3v22CQ8
         BLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768621837; x=1769226637;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wSpST2Vurk/rI/BmErx6HNaHnzQJfGWr89dueeot/Lg=;
        b=OmhhyjBvCpSWbqvVS2JsNV5MFe3hfoLcPJ+dr4q1txEqyTmruJQbq+G6OLERvNwuez
         Yd477WZ0APOL39ajgdY3IUsv96TlZVz0cLA/knGAVcgzAeH7KEPr6JFMT1NZbtMkbzlF
         gyu08Fj7/phzrsPUsBK16ICns5R9euObx3+IrZw/EXyc9PsAP1QLzMdetmp82khsFy2h
         FD92cgM1e6k9BGX64hCtuqgJJc+vg+N3PGYY120OAYLbofo7L+LNEcLw+TCP/IL+Toqb
         A4evKXfsD5hfOM986UtnHJUK6NUranMNe8BIXm4Dj6GFNGCwQSZ4koL9TfuLlemfWK1t
         n7iw==
X-Gm-Message-State: AOJu0Yx+uO2th7xXvUyKP3fanz7sOwI4kbqZVqJR4aoYT0igCeNMooJv
	VrPZWSF0qJz0u+0Ue7uc+UXcFPngci7587CkNZD5AOpyZRz7QY8OKzLw6OUYWJ0zQ+gtC+/4fjn
	uOnHw
X-Gm-Gg: AY/fxX76N2+9Sb9OFDbJTVa+BHJuVRmD1t5a5Jo4yoHmzeTCRZTGHzNuABkK619yti1
	nTyls4U93q5E9wIHTEbW2vYDwzWWKAfz/6unSFcfd3qxwrNeE7nEPynG7gVYUb/jvpyC6LA3L3n
	5dr0jiPpUQHk+Lg7KgHRADHviwMi+qZr5ldo17pHaieiuLVe3abr01pqmEkfmG1z70tqNvG/sMO
	V0mdmRolj7mCwhlNoSF7VosXGmEw2bDmxbZTUi/MqJt2pTE6U/GDkZNZOBXGQ83cJRUDjfj18uM
	zPoes7OQvJpkz7BVYuLSrdlu2BK7ftsuLrIMlssrr1b3NDvxGjoWz3Zs1GgepReAEZG4WDtus8/
	UrSg7wqUhCKL84h5yiFskQBLppF5ZuwvS5qufGpG/JdoeCStRtICK5bkMUN5S33aLYyUi7Ax3xw
	VjziXGuY3nmaogO3SWgIVA5hqnnX9F22TKKsMkdqtnkO5bqFi94CSZOMuCquMexZd+BDDbKQ==
X-Received: by 2002:a05:6820:22aa:b0:659:9a49:8fdd with SMTP id 006d021491bc7-6611793dd6fmr2468081eaf.10.1768621836977;
        Fri, 16 Jan 2026 19:50:36 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-661187820a5sm2049088eaf.10.2026.01.16.19.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 19:50:36 -0800 (PST)
Message-ID: <ab5cffa7-4799-4e34-a340-be1a8ff7fd61@kernel.dk>
Date: Fri, 16 Jan 2026 20:50:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.19-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix moving local task_work inside the cancelation loop,
rather than only before cancelations. If any cancelations generate
task_work, we do need to re-run it.

Please pull!


The following changes since commit e4fdbca2dc774366aca6532b57bfcdaae29aaf63:

  io_uring/io-wq: remove io_wq_for_each_worker() return value (2026-01-05 15:39:20 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260116

for you to fetch changes up to da579f05ef0faada3559e7faddf761c75cdf85e1:

  io_uring: move local task_work in exit cancel loop (2026-01-14 10:18:19 -0700)

----------------------------------------------------------------
io_uring-6.19-20260116

----------------------------------------------------------------
Ming Lei (1):
      io_uring: move local task_work in exit cancel loop

 io_uring/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
Jens Axboe


