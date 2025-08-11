Return-Path: <io-uring+bounces-8935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B97B21569
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 21:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5382946358A
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 19:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC7022FDFF;
	Mon, 11 Aug 2025 19:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="u2LsIQxp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8611FAC42
	for <io-uring@vger.kernel.org>; Mon, 11 Aug 2025 19:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754940982; cv=none; b=JNF6Uq1Y4QkrcJZH1Ej/1IC+JpMb41m4JjL2d7v/nBMVRzbXVZjAScMQXEmaH29AWNuGNfUV9WAWoypupjcXnek72Ty68q3+o0rHOcjf2qbqbHQpiLzYoeSAmx8zchu1b8TfKXdXhJFj9h0mZzCOaXp524jS2LG9ah/KOIfBBMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754940982; c=relaxed/simple;
	bh=8K73JX6zEP6SRAyan6dWes1ext4gzAa3shsQ068bliA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=utnAKlXqtl94RiFJu0+fLCWOJ6hf4M6U4TwcyOR9RzZG4f3GR7IHPH8UpUFGSONQYRzuXZ5pcW8DiVgHBXrrpL67quQWFk+m+1qJZJoHB2K2g088q6iH0lOU3gWv5gJwXlbLwrNnC/TtltxjNqbQrKyP7kbbpgrKt73a8abTQ4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=u2LsIQxp; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3e5429b9c37so21045245ab.0
        for <io-uring@vger.kernel.org>; Mon, 11 Aug 2025 12:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754940979; x=1755545779; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=72XMIxp5MKX6tXyD3i1bkwM+jKCX1HApq4l+CzM3U/k=;
        b=u2LsIQxptMtm7cO7TOY82mqNFmpD4eKgKsQ4MAEZlYvfRWzr7MwscoMqq+snDXM1jF
         9sT34V+hPHj0RWu9hHqh5qmybotjRObIsVLdWxZRVA0g99kBBZvZVjALowKNfmQqkh+/
         r0meKQ92sv3Xn9dZSC9zZ1/F4N7LqyuEPyuKSr8VfYMcnDe3fahGCzErCfAgtUTP+XcR
         2EnCDwu74K9CMIyPTLi0fDoXEfeG8gGJp9hn3KViECbIPt9GNuE4Hy8TP3KSFNjwIa0R
         vLrAmxactOEDNNBtNdHiawwF7Q4LDyGNygKSVySuF/zBpOorUL9e7ojuVR1lAGSfAURi
         CXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754940979; x=1755545779;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=72XMIxp5MKX6tXyD3i1bkwM+jKCX1HApq4l+CzM3U/k=;
        b=xL0/paqjtkEodcuwQOX3e2iO4Qbn/rtmYcVclq5tBxbxHEgXLrX0PWPAPToNJ4daUK
         n7zGzsbeIoCbaSZP79JPKqc/wMFUKkVmGCgNP5veYg6D0AslbzaEcFDdzez6+XjhxHkK
         5Q8pwZYnMvjwOag8bBwkqzRLtyWJenTXl6ld4f2OCfP00E2mQ84TJoXaOA8Pc5xgFc70
         1vUv45wOx38d/vznOLEqh+f2F02DmG9kMKvzG4pRIDFjYv/qG95Zwkml9VduSegD0spv
         5bbY6XDIH7plvZPUGnO8rGG0BK8oG+4XVmirc21b8bsEV7fc6yux//bR/uBieZyzrnn8
         7mGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOXqWDXSswf6P4l5aE0shKgs7veFLBCoDVNPDmaOTi3RGk1pYPEofr/5VC8Lx22ff+D9fZ9DS/Dw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8TIkMd36t8TJ1kr+ic4lsz4KBGYwpChjtFM7KfgpqXtphLNFJ
	9V5KP0wJK8Ozq3Z8LNs9ANnUu+XdnjsLmzgYFNeYYZzoO7RQElUa2GBogWE0a1/iMwg=
X-Gm-Gg: ASbGncszsmKQ+LBLxqsBBUFxIYhyVPGAxM8ETeAyXzFs3uFDFA81fju567khZIG8+ct
	TlJtlfxRyxpeoGoXXxwpLvomAkETJ25S/akOrVLYO1G4totRCYzBN2M4vTsv1tqnHb6HlUPV/vP
	/7JYAWFNAEsP63/ZUf1SC9i0ffuTbitL4j0sdL/y9g40et4zCr0uRCk7t9AORWExMxdGlwRW9yR
	xe7SuaZXqELeksthE6dzitXyjZ1++R87CWs/x+s0G22IQCpFAFneHde18limQG5GtAoQYJfb3uf
	6EqVT1i8oAfLUYOpG5jrWr2XY7vDDNBJ6u6ZF+Fb0gS+ORzB4qt06ONEQHSE8h8t1dEZI+2CsFD
	VKa3HT9e32pMG1sukPl4=
X-Google-Smtp-Source: AGHT+IFI7bcnv/xozr8FYwjYJ1+aBup0n49ZFQ4pkjS2LiRwJyXw7cO/+sILBX3oZiOsLnPV8ioakg==
X-Received: by 2002:a05:6e02:12e7:b0:3e5:4a07:e6f with SMTP id e9e14a558f8ab-3e55af460bcmr11076985ab.9.1754940979208;
        Mon, 11 Aug 2025 12:36:19 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e53e336735sm27720455ab.16.2025.08.11.12.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 12:36:18 -0700 (PDT)
Message-ID: <8cdcb529-54a9-427f-afd6-108207bbbe0e@kernel.dk>
Date: Mon, 11 Aug 2025 13:36:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in vmap_small_pages_range_noflush
To: syzbot <syzbot+7f04e5b3fea8b6c33d39@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <689a2e53.050a0220.51d73.00a1.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <689a2e53.050a0220.51d73.00a1.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz dup "[syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush"

This is the same issue reported last week, a fix already went into the
current upstream tree (and is in 6.17-rc1).

-- 
Jens Axboe


