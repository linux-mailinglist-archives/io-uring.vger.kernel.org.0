Return-Path: <io-uring+bounces-1978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45AA58D2053
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 17:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED3451F23FF6
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 15:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805031E886;
	Tue, 28 May 2024 15:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LuuY1dbq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42B6F9D6
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716910050; cv=none; b=LMLaK3i0mFWpWhVv4uOVS0y+lWZQzYh1ZwohbAOh3e9V1EgkizGCAvX1w4JZueSNXRAbGq6dmAz1bjdkGPrW56SKefQMtsqdCY6BjaAWOmZ6LTisVJTnfN+6IQTShm2GlNjMr45NAKB8i0n6I3Ss0M0dZVUn4mHuX6mRTTQjyfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716910050; c=relaxed/simple;
	bh=gfSmFu1jUiE2fvOxjDFRTKP5cFrXkrQP4v34C+hn32o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=UVShDWQtStWwTwR+oSUvDDPQ9qU0UTGAm9duUrbjvdy7W0ZeJd8uAk4lltAm9Mp6LxdjWo/N3aADLK3znaG6n9MH7pweKIKWshPclhJ4XTpMzSdcwZkpKaqWfwCuLnlPl0Wph46cWomiGrBW8fgRKnoiL6gVrYQXUq38OkM1yPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LuuY1dbq; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3d1d1c65eb8so75089b6e.1
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 08:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716910047; x=1717514847; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lbIwdvt1TQWljYDMg9edWGIp0frJycYEhvQLEx/1YyM=;
        b=LuuY1dbq/tENnnOzxveIi+iEqVOs4q22XCG33mNNvcDvPZalusmq5LKs38NADzGi8y
         omSjhWt++Ss6gUzTNmP20ds0PeCYIfV3yyYgX2gevXi8Kz5a7FCBi5J0rzzuCAFeFiE3
         dCRaZn0/vDGV427r7oLHwZ1dBUjkdfLaX5dHvGtxlpvhiJoNHgmCaRERTZWgSRUjrMKp
         QxtKdc9pYxIgXUnxMH1jDqpM9+1Eseh19gMH0aSmkt51Ru4SSUoMxexQTEuHHl9nf3JL
         WOd3ZtIgA1YfqUFwH8sJXfL87uBithFsRMzHZex9BUAMl6YAMSMEDZ56lFGILj2HSOey
         nDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716910047; x=1717514847;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lbIwdvt1TQWljYDMg9edWGIp0frJycYEhvQLEx/1YyM=;
        b=kAIAsNJ3J1H4rj2YyNS9EzZe1qLQKtx4OOkbtlCoQDbwE0vpU6Y90MXnI3puQJIC4b
         NFpSBsn+fHqIiPePWNKrJaE2RjU9ojWRXrQ+upu6FmCcJC5zoBqx5/6cS+leHKgBkAve
         mmNtYWnKz/JPfcgIyEjAtPe+NAwTmrzsqd9DHTPDoCgcjiQTAA70wbhyEMp2sST+H3xM
         1d8ANP4JgpNP6e8w2lTShlRaabVt6ha1To+F4KrrRqyggZCMYDLex2TZg6PWEYp9PC6b
         z5q+e/StPBwPEY29MQSq16P1PgNkA+6XAM1WWHcjYa0nZMzsxT5d5PzzDv3i8uT0V/82
         bR+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDb0BvnvzkJc7rtisT5lm3qkCG3Dch1xQCcmLKJjHKbc6/gqyPhVOolcK6Srn6frfgW+0FVG8BoOxMoZEdmIi9k/sE71pcJPc=
X-Gm-Message-State: AOJu0Yyhb4MtKgfPY57aSBgGP5vfrtD0NXycGAIvCuvfQftVxuw0hDkQ
	HTZnsB7z0WPBmg2uH8V57KobLK8O7z+IWufbKlmOHWXt0UP7TDh/t78DtJaNVyc=
X-Google-Smtp-Source: AGHT+IE7JyYRcEJqCLG1x8ufyBFTU7zObkVAwRPjyGd9dBiwRuub6Vht72QYcl6mpp3cV5hzvWGALA==
X-Received: by 2002:a05:6870:15c5:b0:24f:e69c:d2a4 with SMTP id 586e51a60fabf-24fe69ce3ddmr8616482fac.2.1716910046660;
        Tue, 28 May 2024 08:27:26 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f8d0de7198sm1992893a34.43.2024.05.28.08.27.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 08:27:25 -0700 (PDT)
Message-ID: <ae80f99b-5c51-489b-9f54-fc4aac389d76@kernel.dk>
Date: Tue, 28 May 2024 09:27:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
 <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
Content-Language: en-US
In-Reply-To: <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 8:34 AM, Jens Axboe wrote:
> Obivously some variation in runs in general, but it's most certainly
> faster in terms of receiving too. This test case is fixed at doing 100K
> messages per second, didn't do any peak testing. But I strongly suspect
> you'll see very nice efficiency gains here too, as doing two TWA_SIGNAL
> task_work is pretty sucky imho.

Example on that same box. Running the same message passer test, sys time
used for a 3 second run varies between 300ms and 850ms on the stock
kernel (with a lot of variance), after it's around ~150ms and pretty
steady.

-- 
Jens Axboe


