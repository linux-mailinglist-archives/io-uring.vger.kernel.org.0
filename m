Return-Path: <io-uring+bounces-6052-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 962C3A19BB2
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 01:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA32B16C326
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 00:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777925234;
	Thu, 23 Jan 2025 00:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tVRj6pJf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E6C4A23
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 00:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737591507; cv=none; b=MLepHvM0Day2g/eNk4fjzWugRA8mUJgGHpVyh7O0SxInIod2u+a4yazI1/3oS4Q7hB1/UNySYz2/nYmWhemIyTPQYICmx2mIM60zkRJvJM3AnwB3hl9sMZHqra/mdPeh7yK3MVothYpu7LbzzuUXmKoNR0gReZ9lGryI1F1HH/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737591507; c=relaxed/simple;
	bh=6W+WNzRah0V35ES67v4N7FTqoq0BxLFzygPAkKUbCfI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=p0VQEap596l7ZUGZiioFrGe0epoQU82ih7pHVItoCLSbVKrLxnNKy/Qhp+WUw8VATqiO+epqQnTcbhApaHWhutsSL5LV+DT61RQrM0tdn/Fhw8+mdjhrC/sbyEkzz4F4Ux18D82CHM1owwCaxaPKT+ea9A3Nj3fFPsdBthU0TQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tVRj6pJf; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-844bff5ba1dso30391839f.1
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 16:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737591504; x=1738196304; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rhqMed5pQ4/FtO6tNneVZWHVKqox+Fgjl2KlQGIPBMY=;
        b=tVRj6pJfrhDioCzfXVYrUrkvXecfv+kYZrl4Ej7aP8G0WMBREOrXmUpzUL6QDqR0UX
         59BpWd+mA7dLvARVyKjvhF6kOYbJO1/5OG2TdlXZr5BH1XRNuzb+dT0YNUkYjsoYpgon
         ybHt+D7+N8v5WNn+z9ZA4dIkuTg8aGyTmqWBC0zBJArd/4edMhJk0vtpxnxGBZhRbZ9x
         e1pbGdlRpBtOXgTs+RaftGATUyr9GDs6029exFI3IYp9yf77SFOZTrA/sHka98HybEcD
         dUHPnVBr1mC9qwwD4GG/JwlwylwXVCme8SNo6MFYVhqIg5HgKrWd/K1TNmFlt3GJbcBN
         z4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737591504; x=1738196304;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rhqMed5pQ4/FtO6tNneVZWHVKqox+Fgjl2KlQGIPBMY=;
        b=tMEAG/4pNlWxx5YxXUGt9z5Xt3oq73UkBkS2WOVySbbDRIDRIeXihNZfyZRORCZzEi
         wL+qoO/o6xvIpDSb8OxqYx3bm1GQRTTIiZfIGOrQ6Hmgh+2Uq5eFXsKbQ4ltJEl+k4EW
         r9vA+rqNuDJZvHKK2pkIjy39PddnNjc1HHghwteQgwJDWcBhtcCZJkLYuW5kBYjeI8L5
         qVmkoQpeAUELzvt5wj+OBGMgGOlcjPa4w7884OpvYVBH/v2eHvLW5zpgRMpvkm6orJKJ
         iOPt2FlAQAaoRjTP7Y57r5XPmpmdbt3gb7MEDIWGB1SUnlVR/tC39J4ABp4fSQE9BUN2
         kMjg==
X-Gm-Message-State: AOJu0YwEKVw+HVYIfRn4jk5dTztLll7mnecysqFkcmPwwH2nHzxAEv5x
	996PJy+FLcC2+OqJ+ArDFRSffB0dIw08LCGNkrEQfRphUnHKWp0iiIBM8RmrxoY=
X-Gm-Gg: ASbGncuoC5ZvfVPJ+3ZW+HLcBjyBSOYoEA5zNJZESP/zv6uDSlxaoBjgN2gfsj9X8F7
	erOowh3fboWJkG+ujnnFyllIqSp4BRsjDThHk7Ea1Wg7uKZsTwOig8eRwMj9aLkI3ue8fwS7qlz
	05UvX8tMuQC97+Zgs3VvN2sUWMmGW7WgWjSASxen4xbWZ+u8Di6zyIGIEoZDSeSDVvlftye1pXP
	q35oSHxtPLRxSP+1wTvKqdv9BDmlqGh8yDfcuya2voUJhUv6UYXJHtR6VOQiyVY6+A=
X-Google-Smtp-Source: AGHT+IFUWr/JOlNhnlW1g31QWBVk2XlbFHQ39HcJT/O0rDZgJQ6A4RYWKKkOqtCjzEGkAyjJSda5Uw==
X-Received: by 2002:a05:6602:6402:b0:83a:b188:7a4d with SMTP id ca18e2360f4ac-851b6035b93mr1937132539f.0.1737591504380;
        Wed, 22 Jan 2025 16:18:24 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b03ee2fbsm403354339f.37.2025.01.22.16.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 16:18:23 -0800 (PST)
Message-ID: <4bf7e5d1-4e66-496d-a503-5dc349efe398@kernel.dk>
Date: Wed, 22 Jan 2025 17:18:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: add missing READ_ONCE() on shared
 memory read
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250121-uring-sockcmd-fix-v1-1-add742802a29@google.com>
 <173757472950.267317.14676213787840454554.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <173757472950.267317.14676213787840454554.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/22/25 12:38 PM, Jens Axboe wrote:
> 
> On Tue, 21 Jan 2025 17:09:59 +0100, Jann Horn wrote:
>> cmd->sqe seems to point to shared memory here; so values should only be
>> read from it with READ_ONCE(). To ensure that the compiler won't generate
>> code that assumes the value in memory will stay constant, add a
>> READ_ONCE().
>> The callees io_uring_cmd_getsockopt() and io_uring_cmd_setsockopt() already
>> do this correctly.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring/uring_cmd: add missing READ_ONCE() on shared memory read
>       commit: 0963dba3dc006b454c54fd019bbbdb931e7a7c70

I took a closer look and this isn't necessary. Either ->sqe is a full
copy at this point. Should probably be renamed as such... If we want to
make this clearer, then we should do:

-       switch (cmd->sqe->cmd_op) {
+       switch (cmd->cmd_op) {

instead.

I'll drop this one.

-- 
Jens Axboe


