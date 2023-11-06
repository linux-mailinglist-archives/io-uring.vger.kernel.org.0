Return-Path: <io-uring+bounces-30-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E077E2777
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:46:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9F5D1C20B3D
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 14:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D65F28DAD;
	Mon,  6 Nov 2023 14:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QzAZ8EIQ"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456DD19BA3
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 14:46:23 +0000 (UTC)
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3112E184
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 06:46:22 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-3574c225c14so6174225ab.0
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 06:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699281981; x=1699886781; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UtzVA1OxednGbppk4stDp0Hk53ldls7rs/Iz1xfAT6o=;
        b=QzAZ8EIQreJHFCt4Gj9/fU2uSoR7YyVujNqsZpxmGM5BwuuWbmBjCKWpprBYDK8WA5
         52zHG1u7RRM/OpVjPlH/OAnbVODkO/h3cboCoOhG55BvlNXtEFW/EmNIhk3xUdvOwTMZ
         qwbrUiy69yHrW5alscPy64HJnxSsHmFByfmrc32b4ZqGYA5o88nBfJ0QLaqWGa/jbeP6
         M2mtDxygMoeDPoK0YY9Ybkiv53AF2TtCZUOE5nGfXYrg2qYItbs9dcF6S+FfN1EF82XG
         t45oDtv4LVEf7BubX7lF9O+cEz22MtolY8a7/VhSDc8e6dylYD9YMvZ2LEIZU0BHsInm
         JNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699281981; x=1699886781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UtzVA1OxednGbppk4stDp0Hk53ldls7rs/Iz1xfAT6o=;
        b=sROa5yG6a+27f+3GziTp5Dp5CRI9VUfZapKhc3nJSO7PNNfciJN4YX3OPN3vCJo5VC
         EkzrWyw8paWnbTFYr6/sQ8KVvqXbJQEMKO4g07myCOybfO53POPGY63mehlyNYD7mkAB
         47kA6GKvn3ORgms16I0Z6N/WwCJTBFtv6DyCIRcO8PSttAr/TmhXQQXvuDXC8F1Ha5H9
         5dBt/gK/fnjDcsXnEOhlxfpXoBRY2FVibvJ3ZFq5yhlEB8ZgZi1yyCncd51H3sspmigb
         6y5gFKj6u5mqeTLWWkfJ5ezT8cdlQuWT6XTyzryx8EIN6YbzOqk/0KjDQc5cdxRlo5fd
         A8ew==
X-Gm-Message-State: AOJu0YyZBdKzAXVcj4m2wMiQeN+QzZzpswEukKPk7hXfzlHhgX1DOOrz
	U/dG2iMjcZeE9WbdgK4GHLYC4tqwGOT9WqI1Bttouw==
X-Google-Smtp-Source: AGHT+IH1ezBAXIS6ZeNGM4+i76dY2WybsZXDN2ePMun+cVmfWGir6hWWNvavhYmj/Z1QvuLrrPjhyA==
X-Received: by 2002:a05:6e02:330b:b0:359:a1d7:4e2f with SMTP id bm11-20020a056e02330b00b00359a1d74e2fmr4956103ilb.3.1699281981506;
        Mon, 06 Nov 2023 06:46:21 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y12-20020a92090c000000b00357f3790ab3sm2509082ilg.25.2023.11.06.06.46.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 06:46:21 -0800 (PST)
Message-ID: <b6db6eeb-3940-43ab-8cae-fb81ff109e41@kernel.dk>
Date: Mon, 6 Nov 2023 07:46:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: do not clamp read length for multishot read
Content-Language: en-US
To: Dylan Yudaken <dyudaken@gmail.com>, io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
References: <20231105223008.125563-1-dyudaken@gmail.com>
 <20231105223008.125563-3-dyudaken@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231105223008.125563-3-dyudaken@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/23 3:30 PM, Dylan Yudaken wrote:
> When doing a multishot read, the code path reuses the old read
> paths. However this breaks an assumption built into those paths,
> namely that struct io_rw::len is available for reuse by __io_import_iovec.
> 
> For multishot this results in len being set for the first receive
> call, and then subsequent calls are clamped to that buffer length incorrectly.

Should we just reset this to 0 always in io_read_mshot()? And preferably
with a comment added as well as to why that is necessary to avoid
repeated clamping.

-- 
Jens Axboe


