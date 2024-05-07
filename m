Return-Path: <io-uring+bounces-1806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C1C08BE707
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 17:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C3951C2325E
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 15:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B111B1635D5;
	Tue,  7 May 2024 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sv8TdImZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6551635C2
	for <io-uring@vger.kernel.org>; Tue,  7 May 2024 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715094575; cv=none; b=TVsP4BLKz2mw47Tcw6YDDMEAdfDEdg69a9XivNDwiUO17DSc+KnLKTrR3JZb13Eau9Ittjz7sbJDFg7Mo1dcDmn2Y5nQbHwBSKTn7rH3zelEckZyekX0A3Mu9eNWLg6/WWkn8JQ1xCcfKUeM85nBGWf0lEXIqIY2xVRA6TueP+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715094575; c=relaxed/simple;
	bh=eQZdBa//GiiwWU5saLscyQ/eNFxlEase1Y9Rz4G07L0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e8G+ZJbwsKNM6G6GAfCd0SydzK7jASuxuGlK2RziTg78qkXTs11FjnPdmrRJzouWwHWvm79K2+wHDENT0MbrWx7E2PkxMJN+c0g/vkR2ev9RbShBxRrb4cA0bqvYKM1t4AyGO0qY2CNGp7l+dNmDWy0WK3RRwke7sMbwBFi+SGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sv8TdImZ; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7e186367651so6214939f.1
        for <io-uring@vger.kernel.org>; Tue, 07 May 2024 08:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715094572; x=1715699372; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E3D/yzAnQonQm6YpOqNskMzHHJ7JMLgQ77zwyP/bNEI=;
        b=sv8TdImZqS6aZsCrKHrNTlU7Fe+I6yid9cgMoyhGjULwNIrBIa3xpBG3I872GA88Qt
         WthjiA9yRZ5G7cIQ0PI7Z3EEsIjYR+HHRe1MCYTB7eFOhxrEy+L720ggO27rJ5PdU6Uo
         LFsHRA2Cn9D3U9XLCZUFoKAxSw4Cg9arTbVyy5+EaBrO/WUd8RjfqaLzcJogT5X+GBcq
         X2kGH9/8FKXl/2tAwQEr7EhvgdBJY+iV3nPiEbnNQYGNzF0opdz9NMaYwd0ELtsV+6Fw
         bljQ/wRGHsS9bGllkPlgKhDwjgR5UmaKCe/cwM6TLNE+ip8u0TxK50Q89KOKBDX+heDE
         l1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715094572; x=1715699372;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E3D/yzAnQonQm6YpOqNskMzHHJ7JMLgQ77zwyP/bNEI=;
        b=H3vfIZvtAhU/TyzxffGHCMLMDEUql3v16hNmNymnVXbAYyEZiCs03rQutpjIwKDbfr
         dL6kc2RkwkZmc3lHu5vGUioNwnYwr/emnuHALD3DrWY9xvLQp8XSQfeQ/0TP3K677RPW
         CNpIuw4oORfS45JnubgJdxpWV86jGLBcTVOZgb3AQ+/0++rKIF41xkddczT1nBzRNAIA
         IT+OrEphAJzG+U2eYiJhojp8SvhrMq+orZWCEOubgJXWBe+uvQF7ZLV4yfrS8fOQFtWv
         PXpjrHZ/jeYMQyrfrfobVdQTUgKFejkUG6iMYW0hXFc8hEfNxfbjCBeF8nDRvRqQ5rIq
         cItw==
X-Forwarded-Encrypted: i=1; AJvYcCWdhxaoYUXDTmz8dIvukWDiXalYRHpIqMdMuz/Lpi4RFWYaUUxSRzuIK6gY9IZCqPFMzAdwPSmQ8WamINqQnhBaQe+en8esJho=
X-Gm-Message-State: AOJu0YxCC7OGr8MRVgVNXQvT3ffuHFLBVk5+Tr3JdMKHEKXAqkmLmT33
	QfEUnm1D1gmslyr2eRgWaFfHhlzRGiGXeVjdPK98Dal1dKmXroElN5q1GRG5mnI=
X-Google-Smtp-Source: AGHT+IH/xpJNOj9b9GueLYwJ09ytVaIiUnOPLZsziqVJEzXxE/krpfrw37GQ1qd29ae0cQaKRTT7Tw==
X-Received: by 2002:a05:6602:3f48:b0:7e1:8bc8:8228 with SMTP id en8-20020a0566023f4800b007e18bc88228mr963919iob.0.1715094571886;
        Tue, 07 May 2024 08:09:31 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r20-20020a056638131400b00488609cd945sm1915683jad.20.2024.05.07.08.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 08:09:31 -0700 (PDT)
Message-ID: <d7d87db7-af34-4d48-8e26-ac13b5abced9@kernel.dk>
Date: Tue, 7 May 2024 09:09:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/io-wq: Use set_bit() and test_bit() at
 worker->flags
To: Breno Leitao <leitao@debian.org>, Pavel Begunkov <asml.silence@gmail.com>
Cc: christophe.jaillet@wanadoo.fr,
 "open list:IO_URING" <io-uring@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20240507150506.1748059-1-leitao@debian.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240507150506.1748059-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/24 9:05 AM, Breno Leitao wrote:
> @@ -631,7 +631,7 @@ static int io_wq_worker(void *data)
>  	bool exit_mask = false, last_timeout = false;
>  	char buf[TASK_COMM_LEN];
>  
> -	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
> +	set_mask_bits(&worker->flags, 0, IO_WORKER_F_UP | IO_WORKER_F_RUNNING);

This takes a mask, no? I think this should be:

set_mask_bits(&worker->flags, 0, BIT(IO_WORKER_F_UP) | BIT(IO_WORKER_F_RUNNING);

Hmm?

-- 
Jens Axboe


