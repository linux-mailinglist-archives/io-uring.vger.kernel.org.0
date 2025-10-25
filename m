Return-Path: <io-uring+bounces-10207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 020BEC090D2
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 15:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 776DA4E5324
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 13:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4E22E92D4;
	Sat, 25 Oct 2025 13:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q7YymhDY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5363E2066F7
	for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761398863; cv=none; b=NBfERsRgM3Oy5kSQJARYzmXleLCbmBTdOS/mT4vi1AbD7xUkpAVDJowYOaxme8l0qhUzCv7g6k9NdGTkIFxx2HgXGulX/Lq6VdVCfZUyPPXkEsO86y9Ei8rgVt04/AEOmf5zSKau4f7FoCt6F1zl82iHg9AXnTZwEQuOJQehFZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761398863; c=relaxed/simple;
	bh=i3aR6XG7SCZKLYqvuLJClAEOhq3SLQqddyDbw2SSnPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iHfPh7zetE6PiceeExMa5UhZLQvLUZzImY/3BcAauBRulfTeFrR3RcSYhwKS0SVb2JGz1D/SUZbcq7c0dFp2iL2AzRyjYPw0roVSWhKbK/CfHjmx3sx5o/h+o5YSbgtykfZEX9CUy2trVgZcMgLfWlvykVYuvKahQzcZZ24bJFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q7YymhDY; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-9379a062ca8so128341739f.2
        for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 06:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761398859; x=1762003659; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HXr/4gmeQBCobcp1e59rIPiZ2OM+tq/HT4CMRTfBtng=;
        b=Q7YymhDYF4uDwtwyMkr960KOs3U3famiaMCG/Q+j5pBGj2inciD2CdHtH/W5KrzQx4
         LiUoTDOs7/cb3bfAY0/EsR5NDAKpYS1Xg8CEXFUswimYvOnCAbxuKGWC+lv3uTMl7gS9
         6Vhr8AVLma8GYKuDT/zHFKSd+VbxPJ/WowNnQRko77+UMQ3H7hgOhWQTr6RObfYCh2d1
         7z1USsQm9IIM0nFozTqpvEhEUUGlvJnGqPB7A0yAAHnKbURx22LOuTUUOQtLwABIZHli
         fiPAO0DNyiw9GEytnbnl9FeocU2YQtydU8DBRogTHYjJdpvoYGpEVaUSnMQuOsLQ1CG9
         sF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761398859; x=1762003659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HXr/4gmeQBCobcp1e59rIPiZ2OM+tq/HT4CMRTfBtng=;
        b=Ey7JB+J6b+mgayH+AcSRdfMTxj4HKJbFtdgLo8cohaZC0geVx1OoBMBfJPMLygX1ub
         WhnOJNIK7U6dXbeyFFwspAIkAR00GU4/SJlfpmIXBUvecxB0WYWhg1dJrVQSqo5UsQDo
         ihX18FEB9mWqhNtUkmRpvL+YiTvCIdzLpcBmwz6x6/Hhiz1GlC378UCOhD9kMy7FZlV/
         k42v8GdOC5BoAZ//0pzq7Ur2sL5oDDW9s6lgkYxwO6iHzpENsn5xEgqMq21qj6wYyVya
         IT31om0FDA4d7P4Et90QWOlbL0s95+0OuXZ6nPUuYgsYcJ8o8AMlrNw8dT+1rQlfkB37
         fT+g==
X-Forwarded-Encrypted: i=1; AJvYcCV6zePKCV7OYud3BW3Z9VXXN4ZhJgFCH3mM9LtAcSHu+UeqSsTz9BvExfpMtlz2tfepspLd+jVOWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZMoQ8E7ZCTTQgM0dF1NmGQghh0tmRvwLbnDqf8iNFwtJAkIH7
	OQ0HuhsfoIAQX4fL2ev0LTognxM51phQImdEFxszOeJGXyZGhDYw1hKRn7mfQmNgTiY=
X-Gm-Gg: ASbGnctQOvk7V60UzbcU7Q6zJWVpK5cBBuT4QHpFr/4DusEtbfn8JXmLLlzYBpP/b2B
	d4jZx81tfox8BRDjBA4Ca5ZrsgWknaFNJf2Ty1lzQAk9Vg/3twG6PzZxFTBD/CBsefJAD4kMJtX
	bly4ZJK8ldjC6BLHcouCpBrYuzFeydyqfwTr2sKHYFHxJFzpU3H3ykBAHwFCJ+22DkE9sYtlWYX
	i8bdskUmiwBqaEWDLpavHkRQR+xEyDa9KjR+UWm6e2g+xUsr2uulSWi1WSe7iZw9LdprfNQY9zw
	wJWHQRKIp3h45GfPddoTZ+rm634iF5NpXZ87Jqy0HhGiw3iGn/T4KVxGx+36J2TxVeZQoKRZi+C
	1R5ibQLMJrOFtp5SWSzVgwm4SUq9bNKEzFgW1zgpGvthWTDa4AiXPUnaMOSmVKOWPAqTG/HjrRr
	af/NgA7OoA
X-Google-Smtp-Source: AGHT+IG4Y2HZ0MyC30nUKDZ+xtNAM0kFpk2+Pw7r1CzWuz5LJp3/Q4U/QRnl0mYnHV6GLCYfZXOvaw==
X-Received: by 2002:a05:6602:6015:b0:93f:c5a3:2ad7 with SMTP id ca18e2360f4ac-93fc5a32d96mr3801899039f.6.1761398859503;
        Sat, 25 Oct 2025 06:27:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94359f324b3sm69240539f.21.2025.10.25.06.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Oct 2025 06:27:38 -0700 (PDT)
Message-ID: <c344d845-99ba-4c3c-9382-cf401712a689@kernel.dk>
Date: Sat, 25 Oct 2025 07:27:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Introduce getsockname io_uring_cmd
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>
References: <20251024154901.797262-1-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251024154901.797262-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/25 9:48 AM, Gabriel Krisman Bertazi wrote:
> 
> This feature has been requested a few times in the liburing repository
> and Discord channels, such as in [1,2].  If anything, it also helps
> solve a long standing issue in the bind-listen test that results in
> occasional test failures.
> 
> The patchset is divided in three parts: Patch 1 merges the getpeername
> and getsockname implementation in the network layer, making further
> patches easier; Patch 2 splits out a helper used by io_uring, like done
> for other network commands; Finally, patch 3 plumbs the new command in
> io_uring.
> 
> The syscall path was tested by booting a Linux distro, which does all
> sorts of getsockname/getpeername syscalls.  The io_uring side was tested
> with a couple of new liburing subtests available at:
> 
>    https://github.com/krisman/liburing.git -b socket
> 
> Based on top of Jens' for-next.
> 
> [1] https://github.com/axboe/liburing/issues/1356
> [2] https://discord.com/channels/1241076672589991966/1241076672589991970/1429975797912830074

Looks good to me, and it's not often you can add a new feature and
have:

>  5 files changed, 52 insertions(+), 52 deletions(-)

a net zero diffstat! Nice.

-- 
Jens Axboe


