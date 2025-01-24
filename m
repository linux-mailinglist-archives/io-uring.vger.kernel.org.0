Return-Path: <io-uring+bounces-6109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 278CBA1AE7E
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 03:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56E3116AFFC
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 02:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0281CCED2;
	Fri, 24 Jan 2025 02:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=charbonnet.com header.i=@charbonnet.com header.b="iyLNbYjF"
X-Original-To: io-uring@vger.kernel.org
Received: from h5.fbrelay.privateemail.com (h5.fbrelay.privateemail.com [162.0.218.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24951E495;
	Fri, 24 Jan 2025 02:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.0.218.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737685429; cv=none; b=Fl2FA7W7Dwo7mdxTxiixiAVDTnxqUDCTT/mrU+pxpIBbOSp8kJvNllOTsjQv1J4DR64voUjlRc/jx2b4g4Mh5Y65z8Kz0LqQuBbDCRZSvtPwBKJZxLa4Te1nmMOiFTBMD64es5420YQbKQ/fUqxAG4/UbmfY8fLw7KqWesT7ge8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737685429; c=relaxed/simple;
	bh=24UfeayJe1CCp+uWofUrj78s9qE5M8t4tx7WrBmfMgs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=RokBBBC4qcBaePRwpskuzhphJo341uKGzhGbmA+Gk5Lpgd6TH3C2faZkny/NxtuOQYDwT8vWObkhFTY683iEE0Q+kGVFVfKRYOT09yOZwwp0PHYaI+dRm/QaMUhPVbUExv74y8K08v69DaXKoVJz3AIVpXBLEn1KT273Qa7hZx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=charbonnet.com; spf=pass smtp.mailfrom=charbonnet.com; dkim=pass (2048-bit key) header.d=charbonnet.com header.i=@charbonnet.com header.b=iyLNbYjF; arc=none smtp.client-ip=162.0.218.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=charbonnet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=charbonnet.com
Received: from MTA-06-4.privateemail.com (mta-06.privateemail.com [198.54.118.213])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by h5.fbrelay.privateemail.com (Postfix) with ESMTPSA id 4YfLrn1l6nz31bv;
	Fri, 24 Jan 2025 02:11:05 +0000 (UTC)
Received: from mta-06.privateemail.com (localhost [127.0.0.1])
	by mta-06.privateemail.com (Postfix) with ESMTP id 4YfLrd12ljz3hhTn;
	Thu, 23 Jan 2025 21:10:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=charbonnet.com;
	s=default; t=1737684657;
	bh=24UfeayJe1CCp+uWofUrj78s9qE5M8t4tx7WrBmfMgs=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=iyLNbYjF7tC/b9OrGZ1j3Hl64IBehGidy//tBx9OITVfHDXWgG71onD8vxNcUPm5m
	 lx3JQb8lHiOCaBBi8FC+m5VRKFVSMxeKhYDDY3NwneEI3Kp0XJ1f9/rIwR7tb5vyFO
	 0XnIKoLTyQ+g4lyfX2eP3mOdzCFMyNzYv0uUtLGKo9eIZFi28AsZGHA/J2bL5PVqEz
	 1IZlir5+miWi4igaRPR7WHmShUBOUcy70MeSZ3LtX7upsJ3+LrbVmNN54oxToWU0/m
	 dyjKTFaWbtxltQPTdjyzAzITUP/AYjmOo1Xv7xjVo83Y1ungAytdFQpdOcuhYtBPY0
	 7B6dKha7x8BLw==
Received: from [192.168.1.91] (2019.charbonnet.com [69.30.239.106])
	by mta-06.privateemail.com (Postfix) with ESMTPA;
	Thu, 23 Jan 2025 21:10:49 -0500 (EST)
Message-ID: <6baae9c9-b296-47b8-a7e2-56368bd7e84a@charbonnet.com>
Date: Thu, 23 Jan 2025 20:10:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Xan Charbonnet <xan@charbonnet.com>
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Pavel Begunkov <asml.silence@gmail.com>,
 Salvatore Bonaccorso <carnil@debian.org>, 1093243@bugs.debian.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Bernhard Schmidt <berni@debian.org>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
Content-Language: en-US
In-Reply-To: <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP

On 1/23/25 20:49, Salvatore Bonaccorso wrote:
> Additionally please try with 6.1.120 and revert this commit
>
> 3ab9326f93ec ("io_uring: wake up optimisations")
>
> (which landed in 6.1.120).
>
> If that solves the problem maybe we miss some prequisites in the 6.1.y
> series here?


I hope I did all this right.  I found this:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=3181e22fb79910c7071e84a43af93ac89e8a7106

and attempted to undo that change in the vanilla 6.1.124 source by 
making the following change to io_uring/io_uring.c:

585,594d584
< static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
<       __releases(ctx->completion_lock)
< {
<       io_commit_cqring(ctx);
<       spin_unlock(&ctx->completion_lock);
<       io_commit_cqring_flush(ctx);
<       if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
<               __io_cqring_wake(ctx);
< }
<
1352c1342
<       __io_cq_unlock_post_flush(ctx);
---
 >         __io_cq_unlock_post(ctx);


I rebooted into the resulting kernel and am happy to report that the 
problem did NOT occur!


