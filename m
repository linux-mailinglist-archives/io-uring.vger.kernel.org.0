Return-Path: <io-uring+bounces-3678-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA56599D9AE
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 00:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E273B21868
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 22:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDF71D2F40;
	Mon, 14 Oct 2024 22:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fs94FVND"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4171B1D1E79
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728943952; cv=none; b=RZ9jB4jcWOJp/UA8GBGi1+B6r1+mhwv+Rs0EvOziSEBuq7aj167Hf9elHz2r1qAXdr0oRZRVReM/NYlmBbqPtybh0iUKCu6o/7NTXFX0urfiEcYFJxPr7XFIySzPqnpyyDrQ0ZSReOUzLP7IkbtgNI7xHa+pteneFXrDIeGdo34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728943952; c=relaxed/simple;
	bh=CiRkgDwSmyAjE3IthEt1BIyb/50rE3ZhWj5R4qVzhZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KYGH3tG3mV5o3mQFILnubd4DS5v2yOnf+lRJ9mLE68TA3tvV1I4VHYIkDX5zv7/5QVggr8fZGEKJabpuXVdCBMB1swHWnVyNRrEXhsqhlRcFMx6xwtuzuLmpOm0uG5o6FHHOM8ILO0MZD5nFZhai+qtueLQDKGrLaL1KQICo3xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fs94FVND; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7ea7e250c54so990981a12.0
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 15:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728943949; x=1729548749; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aOnb4fmTrZjtto+yykHB48JoHJrPt+fLQEUfS9yjta0=;
        b=fs94FVNDkLNu0fTT4tujCKzCxkJdZAtjHhmaT/03e0WtjAC9bQo/nErDUypHZxk9K9
         SX+b9ygwoLYGbNBFYA1zzxhQ1BoPjkqHALfnUQrXm92saeam8jQBIMchxInwD0ch9UFU
         TaHLFpF6b5EnrA0Po4o+j+SOkRUyBdt0onwX84IgLASikv/RXhC9ZYm6KskPMye3lgLS
         ZzWRx1PvqCOqtDeQeLjvjUK+0nGC2OmlexcegVvUvCaBhFKRSMwcpnq/igM5wr6vG0gb
         Wypw+oa4x9vZAy1mkHd8Joa7Q1IF3vaQ4iXbtXahmkx0aaJ2hxuwbrhuWQFhI36EwPy0
         X75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728943949; x=1729548749;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aOnb4fmTrZjtto+yykHB48JoHJrPt+fLQEUfS9yjta0=;
        b=mH0PdPm/fBNmdD2eLZY444Kxm0ijbuo2r0932YGUG1ODYy+a1MRqgNpnDpaOz205Ly
         J759SNqg4C5jcS7P1Sk+6tURu/OTBLxI8plv91dEykzAAe4UuEmFZ8iY2SXXBJn64xJk
         NA/taT+4qyPxqCRACIzTda0CwPKYUGJZAqbyFVW0NkIJTA0q0NLaN+Vw5m3P9NhKs086
         myDK4O4v3wGzr3VBSs1kwPSL9mBCE8hPI0BCNHhPVFRGw4YEjhH7/b6ARePXr9J4Qt+f
         wMzeFJ03Pq23f+LCCcEklTOWCyN9ieo7pK0bb2SpFbwCdH5yGckZKqVlwzCBmWw/2ygA
         vJmA==
X-Forwarded-Encrypted: i=1; AJvYcCVHioFY2Y4R0lSOx4cLu7Y7d/qtZUZAPvTdzovCiGV6DBjl/FifMQbUsqyxeEGwCpflObMq77Ltvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGKzdX8wXrIdqD16loQjG4NklMuCHiqTVIAmofpecjqeaHe8U9
	kfdSfL2fWXNyPT2V3kHADE6NeNiE8O9JHa+5f2lQOXkuWH9Dj9QZUbG0JJxpmySZKE8Rc8m02BY
	w2c0=
X-Google-Smtp-Source: AGHT+IHQFimetw4/EUxd/x/xM+nGK5AjJurlknmpU+NqmPtkaHofrhHXlRDW8vJl8sJ4og3QB0iecw==
X-Received: by 2002:a05:6a21:3a4b:b0:1c8:b849:c605 with SMTP id adf61e73a8af0-1d8c96c2d21mr14492662637.44.1728943949499;
        Mon, 14 Oct 2024 15:12:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e774ccea9sm15242b3a.150.2024.10.14.15.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 15:12:28 -0700 (PDT)
Message-ID: <1299ba1d-e422-4ec7-af2a-aedca08df705@kernel.dk>
Date: Mon, 14 Oct 2024 16:12:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] btrfs: add nowait parameter to btrfs_encoded_read
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014171838.304953-5-maharmstone@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241014171838.304953-5-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/14/24 11:18 AM, Mark Harmstone wrote:
> Adds a nowait parameter to btrfs_encoded_read, which if it is true
> causes the function to return -EAGAIN rather than sleeping.

Can't we just rely on kiocb->ki_flags & IOCB_NOWAIT for this?
Doesn't really change the patch much, but you do avoid that extra
parameter.

-- 
Jens Axboe


