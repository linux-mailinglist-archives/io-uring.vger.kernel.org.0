Return-Path: <io-uring+bounces-7415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A20A7C8F3
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 13:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7AB0188F23C
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 11:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0A51DC070;
	Sat,  5 Apr 2025 11:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gpxvxE6N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A38622097
	for <io-uring@vger.kernel.org>; Sat,  5 Apr 2025 11:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743853585; cv=none; b=QMg6UfRXT7uC5qwZ4Ki6TBe/NYzccTL3hBbk/aOP85MlM+zDmBKg5u2+4Bp1vAR82eXnfPnCr1TNiEsKwpS+LlOrxix67XKxEUg+IPrc2oJJh4pUgbO/Hcr2eaX0S8v4q2T0tKZ0vY8hoATDHIMT+C813DVuC+kPrUWLDBp4YZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743853585; c=relaxed/simple;
	bh=E3cJzFO09HHlBuLQngMYyTEI3wsR9XGMgQn5Osybd8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UkiUMLsNhGS3KFq0qitdyzwQkTGjqk0efULItn/FnKXYXRwtAujCZOVYCw9fowsXFyZn/onOiwaKhgnQ11VVzUHJ8QuRmOqSVUldXGqcNu622eu2ueh6hyxFI0ryQecmyHgqPdW2AkhvfCw07L3ehgG08tZxT14SjeCbGhQ3rAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gpxvxE6N; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d442a77a03so8399695ab.1
        for <io-uring@vger.kernel.org>; Sat, 05 Apr 2025 04:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743853580; x=1744458380; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dHH9C4N5IBPt5oRyziyD2Fv2/x4KMGs0avXPaT06lvw=;
        b=gpxvxE6NN9k6hxgcy9R1XtP3QqcAlPUBAG/v6HI7Apy73VZNbziBjjSs82oO0kHoe5
         GiB28JMDNiBTuLj9UguxL6+cVVH84MCvzTQpOml3nqu2IPonJoJ0RVKXdsot5xvU2myF
         tZvCTD3wJ/x8938grP0BG7y1I/hcmxVnE2qzs+3GaHzc7DvCQ7/1xX8MeCyIlKJxnjuN
         JCqk0P/RR1B4EI6S+GaSXiI0nkSBc/zc7rECDAxBeK+mSrHW4Wk2P7I1je/q7sAGEk99
         lHVv96kiE87DaN1p9YfAc5HGYoDUOoGJxH4zQXBz6kieiHmR4l2BT2sVk9zv72BFDi2O
         DhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743853580; x=1744458380;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dHH9C4N5IBPt5oRyziyD2Fv2/x4KMGs0avXPaT06lvw=;
        b=xDKziv3c//fBedRdBmRz0vq99SqHvA2DdnG5haQHxVJKpZYcnAS9E5/Y0lq4VWAK6K
         qym+BH1KZwU7LhIej45Xyj7Uh5GTsM7J3gsMG6UM/ELolUhOX06lv6EilQhx8ulcDkqh
         b9Gqy8ly/9takuvlCke/g/ZEUdO5yLJTg3ofB4IGwzxvRj+Ccil+1U3kRwDHZpB4QDs+
         0CnX66fYAML3c5arZdOK+8EuRvR3CUSa92ZFJRBa2e2zfd9Drv5mqIXpwVmlDHkw5GXt
         fliuaZNCU3q5xh/2a78tNU9GyDtUZ7uDP+r/Z7p8Z1snco2tQVEAea5Qhl8MkC+Mb5xj
         IvaQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4RlmvgqaXc4A4hJQUnIM+dYeJvtHJPERVaFBMdfzw7iXPuexs9PWUwcPfaEj3cAjIyVTv/2yH/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqeKioHG+sbt7tDvaM5htzfQNaKMecK0Z1b59CDJG3jf6ncKmb
	fF+UlCoXEcvHXIrj2KMW4K+UHxoNkMcuEx4apA7nq6TvS90sEv8SU1FF+eNCMHU=
X-Gm-Gg: ASbGncu+2wJRSUCHG+rCVLnuJGuvalWF+pyK84chNAvb8/nrLd51h6uk5JDjpmshLPs
	j77WMR2osJm4CZVbuez9VkkuJv4iGr29p5tWfdWp7wiNckB9nAbSsUN//Zbonfe0NA2fKZx1aWB
	XbqRUqIs5OztB+/fRqdmXiTRRV5nPM9HrEBMQCSzUPROOXY96hYu22xqn7fEFyCEwblLOHFbGOi
	LgvilydQjFOZCHunEcqcsRCVRp6UBdX7TnVAWIquQMpsbYjPp37XYWcLVFUAA3GES9ZBSPpHi3G
	u2KuyLemaSr7smIvjOYZIjZI1pPXOkbTRWHIHqIS2Q==
X-Google-Smtp-Source: AGHT+IEz7a+AUeoKGFZJv6A4BD3/TV3i+nexKQiCSL2XlPf9+gyFp+g4JfLTGFfUvvHvAzp0z8yiKg==
X-Received: by 2002:a05:6e02:152a:b0:3d3:d994:e92e with SMTP id e9e14a558f8ab-3d6e5876fa9mr59647335ab.17.1743853580162;
        Sat, 05 Apr 2025 04:46:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5c2e0a8sm1286698173.14.2025.04.05.04.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Apr 2025 04:46:19 -0700 (PDT)
Message-ID: <67159ae6-3dd9-4d40-a6b1-643d18e8b3a1@kernel.dk>
Date: Sat, 5 Apr 2025 05:46:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
To: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67f06309.050a0220.0a13.0226.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67f06309.050a0220.0a13.0226.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/4/25 4:54 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> unregister_netdevice: waiting for DEV to become free
> 
> unregister_netdevice: waiting for batadv0 to become free. Usage count = 3

Guess there's some mainline issue causing these failures... Let's try
on a 6.14 base:

#syz test: git://git.kernel.dk/linux.git syztest

-- 
Jens Axboe


