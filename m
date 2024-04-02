Return-Path: <io-uring+bounces-1370-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F3F895CCC
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 21:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FD28283971
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 19:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FF715B971;
	Tue,  2 Apr 2024 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="doFtRcng"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D4A15CD62
	for <io-uring@vger.kernel.org>; Tue,  2 Apr 2024 19:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086625; cv=none; b=FL9cuGSL4yyN6TI/fzRdbBvkO9oZmGoEysFUSu68BMJ9fMX68ziTlsnew/beejAHfo8ge4x9LCHrjgcdYlM2wkJkcaLZyFjPhHHV9qsheMvnUfmoSVutp56QQXuBAq0T4AnxZTZy4jpu3V2nxCAgLAPzAxdUKsahzWMubUWvWpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086625; c=relaxed/simple;
	bh=Ajif/9j7M/zsqMVNXdBm2tkQBVeG6jrR2PglV/6xi7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jk/WkEBsIRE1v/PBraVr8t4u8Sv4qZAXF5wMNeUQArA5CC1hUCjT54LSuEKs5gzbSOBgPf2LpOHHNLuk5kKoapLRXm/hQpcyn6phhLMlxdluiVkPuLfiuLQSaHNQRUIlDDurvo19wCZGTZKY6Oqtj++eONCD4HRrnEubc05C2Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=doFtRcng; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7c8e4c0412dso34068339f.1
        for <io-uring@vger.kernel.org>; Tue, 02 Apr 2024 12:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712086622; x=1712691422; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ffbeIo6yT2gnuWj86yFH3HoV79Ov5Gn0g1nar2qmPdk=;
        b=doFtRcng8oTWK4yn9UwrGli5ObSWYplTcOTOMP59wx1LzGy0Rz3yB2p35J8WIdbBQa
         ENhXwMHtoZr6aJf0V5iP/F/ztlZGqj9MrRcTSpyOoytd6oH8OA9uhui1dSZ42sPR1AN3
         iSr25HYnmF2lj39ksGldqWNPjyWJmfFYfoasOSZ1jrdnRXOMzhZrvS+SRh4TMgeTBWO9
         kQmmXFpV7IfZYutKwXl4MLtFsz6I4Z6+Exey+bLz1T4PEXSubKFrpQfooX1M0qAPAaSN
         5i0N5mDrgIGRP6N3rzKl+X6kmnks/DbR2SJFeHss64H/aepkW1Wo1x1ed8u5zS7O8mNh
         qpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712086622; x=1712691422;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffbeIo6yT2gnuWj86yFH3HoV79Ov5Gn0g1nar2qmPdk=;
        b=SY1aJZvMiAW/pu+Esz4XcvBGaHWUWjTRcIH8RKIvoIX21RCJUPLpAFnVgaX2Y6IymV
         VngeIH6cF2kzbuT761JWIejhDKigl4O4uE6+EfZAmmla5BjS/7l6opgdg3jiDGbnkp8o
         6PWiKAz8R4klW6WXubiq854M2apHfRuGYi4clCh3yClb3vM05bw4gdBIlJbYogs87CFz
         Z0eQ0x8qw+y/jr0p1UBlyo0L/mOPnRBUMKI8Sil0l+ZeaThQSgz385TkXwallqmChdCo
         fOblaXKdK0RV1okZ/PndRG0+4izIYmdQl8xGywb6kReoRyl5D7W23yOWHKU5043VANa0
         Jugw==
X-Forwarded-Encrypted: i=1; AJvYcCVsdD4RTUoYsZDuESurEmUEwVEq98FymCRV6zLCdbQrMAbOlaLJIHvA6Th7oiwVe+W5wuQVGNpKygJNMyhMvv4prZNW50vCPHE=
X-Gm-Message-State: AOJu0Yxd2H9meKveg0yWI6a6ezognBe6Y5tSQV5RY1cisPKFVLYQg9mo
	0FP5lK183FFe6gV8nbjX6DgPAirRAHViTHAHWfrE7nHvEE4/gOGt7AYXHgeSOaA=
X-Google-Smtp-Source: AGHT+IGlZji5c+voS0iWi3tL6QWEFiSfH4FfzhrhAh/F/fIWxonP9cijm1OoH4nm8mwagUEKj9TIrw==
X-Received: by 2002:a92:dccd:0:b0:368:80b8:36fa with SMTP id b13-20020a92dccd000000b0036880b836famr10857144ilr.2.1712086621861;
        Tue, 02 Apr 2024 12:37:01 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l5-20020a92d8c5000000b003688003d036sm291713ilo.61.2024.04.02.12.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 12:37:01 -0700 (PDT)
Message-ID: <eefce877-ce0e-45e6-b877-a1579c5833b0@kernel.dk>
Date: Tue, 2 Apr 2024 13:37:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] kernel BUG in __io_remove_buffers
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 syzbot <syzbot+beb5226eef6218124e9d@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <000000000000f3f1ef061520cb6e@google.com>
 <6816efda-dc85-4625-a396-1fa6c523db2e@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6816efda-dc85-4625-a396-1fa6c523db2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux.git for-6.10/io_uring

-- 
Jens Axboe


