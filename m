Return-Path: <io-uring+bounces-11227-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A07CCE62C
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 04:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DF19030101C4
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 03:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F67D19539F;
	Fri, 19 Dec 2025 03:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NGlnuaYr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE2E481DD
	for <io-uring@vger.kernel.org>; Fri, 19 Dec 2025 03:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116031; cv=none; b=P4QnTmY1XxBUSrCuIxs4uK37pmvYFhyLnj6IXAFIBfYQBxSuIruosz+PLz5KUGuwdA2Tro7vGCgJ6N6LKfCv8QifejUuJsuZKtmf7Z3ibEQqu63Dfk2BUuA+VaFSkfsLfgyaNLHFeFLemuos9Y1RxJgeD0/4pkxSlM74CA9S1NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116031; c=relaxed/simple;
	bh=xlbezVprLRARG1VxqoS1KbCospQUC5PqclLctHIt2D0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=VByuWQfkgi6jzLtciE78bzAvo8f1RAfct9rShbe/YrpxMOe+2Unqb2EqHSNhidXo4ruftI7TIUHlSKkumkIgppIRDIFH4VoMWde6mgsq/lzQP6vZiPxUFHCw8T46SzA3pvU65LFeSTAje0isb8gUeQ8Chffj//2TqwamV0/nemE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NGlnuaYr; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c7bfba3996so774446a34.0
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 19:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766116024; x=1766720824; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RORKdINs7yB6oK/bXMkeQd3B5TFlsukrHduNWEYYCjQ=;
        b=NGlnuaYrMCCMpEL+lVLkHkvQqgytJKCKjcX+Il6TDRHVMGIlwgsAVHJFkXzWCVXF1p
         igVy/Dyey5bW9BHX9TJiPFsB4cVoeH3lMxopNRMcKGCPdv5VAFskjn35vYyxJTiwW+dN
         mOzKwkeApBjGay53RZdw3EiZiS5btCxpDl7vutBEBqT4W45PWGw632DTIM43/IuxTAul
         ejD8VPbtRXTF6lmhYDaBh78poVBWvED7aMcJ5vHYTVLSrQvJTNBnc+bBVxjkJFP/sNHf
         CfNv2TxCumbMUFvBLYflfkNQZKQAjQiShPO6i0TOOMXoqdOHvSZadQR77hRhak/gSgrr
         sUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116024; x=1766720824;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RORKdINs7yB6oK/bXMkeQd3B5TFlsukrHduNWEYYCjQ=;
        b=Ocp9CL0vpZ794aYwct2qSHnWD7bKlBiATY2gqgtI44N1MSkF0TlXbrQSH/8boseK6C
         gzdabxIGe8Ub3UCgvZkxJUudb4v8BUIexPRZ8m5/m/sjxFzqKuVGjdjJtLBjiaLfLawy
         DTpxl567VQhiTdSKdZdZ0PWTj8PLYY07N2u9VHsR2+xbzaSh86Dp95OHqY70TZxSCKtB
         /L2X5YmEOE4FkPNDQqVgqtXS01RXlVhLeAehOP6NCZAyFGjLk5mpMPhkZf8O0bB+iCUz
         eWCU6gUUOt7SaICSfKH+OmT6iMe1zVc8vDaHMzhkhg1yUVhKpFnSPMdBRPL+i6RLhWlE
         DYfg==
X-Gm-Message-State: AOJu0YwQ8vmJkThP+dp7/Ik6R3aPTYBDffl1bhNBYQ0Zv612IGwZAat5
	oh053rOOkjr5bywXNwjYV4olQaxeWI+d53HdDpYfMhnOoc2fc1zn7hhtKiepgGoT0TMXI6uFX0I
	f32d2Lng=
X-Gm-Gg: AY/fxX6IwizjYtVEN6/DU9NlFOMQwDtTki2Zi6GW/NdLu0JruI/gQcX/DRL5phVlMUN
	IXpO+Ek4ga3oEKws/ZRalrYW2d1oE0i4liwP2nGXJ7gr2xFEiWN9uMX14EV6kQk1cgXe/ACOH/7
	qW/MYNijSuiLtTl0YVwcF2Q+2p2BoC/Kz/AqXfNTaAlY63JFTfHv6rCMICqU7u3xm+nI9zZoWSV
	XEKnNTtw5iU6Vg5I8gKlXHAsqICXx+FXwcTNCWckQmUBBNwgXi4VU5Zn7o2tDsEqX1fe/368QSA
	d+4wJy8vawxH9K8VW7NoiHHchvuG5Svh9sVRnh+OiTMo7pXvW8jWUfNWwCf1piJEG8LmQ0kmcTr
	T2CDeCQsUL1tn6dmg8fsBm9R1frmikbX2wUpU0jcipB3euu5PjKffdikk2brv+s0RJfruJnePJR
	W+ATj7yZ4=
X-Google-Smtp-Source: AGHT+IGHvYbviNGRdX8KX3LLGGA3tcLrX/G9aY5mnrAn+BLLxbZ9/jwaOWjij+EAf3p/Bb5dHN7BKA==
X-Received: by 2002:a05:6830:34a8:b0:7c7:3402:7d74 with SMTP id 46e09a7af769-7cc66a7f741mr959009a34.18.1766116024653;
        Thu, 18 Dec 2025 19:47:04 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc6680e5bfsm993717a34.31.2025.12.18.19.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 19:47:04 -0800 (PST)
Message-ID: <4298564b-41fa-4f34-96d3-5988d6a9c9b7@kernel.dk>
Date: Thu, 18 Dec 2025 20:47:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.19-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix this week, for an issue with the calculation of the
number of segments off the ublk kbuf import path. Please pull!


The following changes since commit e15cb2200b934e507273510ba6bc747d5cde24a3:

  io_uring: fix min_wait wakeups for SQPOLL (2025-12-09 16:54:12 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251218

for you to fetch changes up to 114ea9bbaf7681c4d363e13b7916e6fef6a4963a:

  io_uring: fix nr_segs calculation in io_import_kbuf (2025-12-17 07:35:42 -0700)

----------------------------------------------------------------
io_uring-6.19-20251218

----------------------------------------------------------------
huang-jl (1):
      io_uring: fix nr_segs calculation in io_import_kbuf

 io_uring/rsrc.c | 1 +
 1 file changed, 1 insertion(+)
-- 
Jens Axboe


