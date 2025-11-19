Return-Path: <io-uring+bounces-10669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id EC518C71718
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 00:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id 8222829ED1
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 23:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661EF2D0C63;
	Wed, 19 Nov 2025 23:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="isNqOpll"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D991E766E
	for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 23:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763595045; cv=none; b=e2aIbXuLPyl6w2Q3q4tctl14C9IvWlL5cALTHIjq5lI5L12n84tAZlgzqFwrm4zYkEl1dmWuhSt9ZO+Z+EXuRIG5etRDga5M9ddZ60EHVK5nNnIYvU6sXbX+QhUorPmg1Rk4s+9zolEa3wgBF5yG67523wmBqK8KkcUIB6zr03s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763595045; c=relaxed/simple;
	bh=s6qliBbpj3HadloS3LfzfZX2m2178c65fLTr82dFOzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sjtSUybynDVKYiOfjUGyu8AFw/wY02oEmiHG83bun2oxLfCB/clgt+XkFf2czt0E6ofZuWie3ggTqiTqA5QlDta/5gFByFoWD3dJZO+m/jtBBmoeJvorYhAl14E7Ghq31aIfL2uQ8obn8oFhDWIgI4vrvEVuLZe18tN2Bl6NHdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=isNqOpll; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-9486248f01bso11053539f.0
        for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 15:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763595041; x=1764199841; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pvUp7RGUmmjs216+lVxeFp2Csv+aHXWOg5Fjh55n6xY=;
        b=isNqOpllfMTvF074WovwmdGyGKGt/6mrZ0edVAPnfZBR3YSbtSTdLgfsYTXxeUCrLY
         uFrSdTHswFafDSUbwroJs9QtXuMEESRkgsULjBo68SKyCXHliNoODURacLEZt01bVRb3
         xkZFpiwDpeJITHkYK0hddJUSYas+eh7khWrY/V34oZWSLzvRgMmSw06LAhi4PgUbyduI
         8ziGDW00q3gstJUhs6G6he3DPHxjqZFiZafHq6PAWXI0EaSEgr0AQrAB6HKy0pOOLPki
         KBka7hnkP71fMtWFo1eVC432p2GA7kbjgX6nlubVpTNtJyjrQSoG8YiYzTFpyxmgnI4y
         3OXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763595041; x=1764199841;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pvUp7RGUmmjs216+lVxeFp2Csv+aHXWOg5Fjh55n6xY=;
        b=U+9N7SM5JhIHEjiF+dA0WaplvRRDGdEKVx+YLqWFmbJdhphqxGUxt3z4naH8Gh8/FV
         ekyuhASQqGb4pusB1aJ3t3q2lr2ESZpXjCXRomLXi7n9VVEFkpTreykthGfvFkRRetto
         3BJyIs4rzyHAWvwoBU76f3JrMHhdadeds8GsVT5H5sBridltsoBFeGkbSP1a6J+IgXaq
         9ggnP0tK1oBWAOsoEVSiTrmbq7uUVQX0eWLkJ0tBZ2DMZ8EM9KdI+5sTTNuEq9VH1Xg+
         RixZFsNK0BIE1cj3YNlAzZ5jCCQ8mOjhgCTvSHXzQuzYQg8sIGy3FSUgjVO99PQY/aFE
         eovQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPEeDQBnOJbc6+gepQrlKSDB9NRgQOMxc0BMgEiELZmI6zmyJR6Swplfb4eLPDlLn9vTL+Hov5HA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo2/j/y2T8n7oWFcLyAHF43E+/ZR3K3upD7cYzOQ6sr4wIS2q7
	0Yqbi+mmyM4NPElS5j+x9djNyzKysXfmXpArNqVt9t1ZqoJ6zFEvXmJl59sFhW0z+MHeDr9ZEZQ
	WWoku
X-Gm-Gg: ASbGncs2Vtoe7OFSbyy2hHtUNo5ySQxxgxYRrmxZ4uj8UBLQZ/1/rXKZLFp7PRR8GLu
	cKF+7qqLToipKkU2Iia12jeYNXihMx4/nrZ8AMLEe6jtD7eFuM6Cx+6Ylnhtz4h54j0q12eRKTx
	psyhnDIYvrRPK+7dZACtouaAD+2rlpXfiV2S+5hbk5CvAvAl+hUsAwoD2FrqyDCDpAgb2DoVfjW
	bqDBpk65ZLOQ09UNhr5ck4qLPBZFMPQdd4cp1GzZyCiRm6a/t2T9GTThhxI7AvK+9QIUJ5yS9hE
	aPJWPEs8s/rtQej3wzQamQnnjj61bL8l9yLbCBs8K0/mtl/bw3WXcWggk5Wh9UlxiHkvHL9TPf9
	xZkbsn2Tprv08FDgFrfnW9DNqlSdOJ9AygjMCX4Hn4UCPsQB5C+K8+hyGPrgWWQbYtuDC9wpNZg
	uX+bcT+Tjb
X-Google-Smtp-Source: AGHT+IERe15bOQxQuX9smf+xaJao9XmWQ9dJkk7j6R3CpeTHjwtEMaDwQdMNpRp6kWa4xj7sFPC8+Q==
X-Received: by 2002:a05:6602:2c0b:b0:91e:c3a4:537c with SMTP id ca18e2360f4ac-94938adfacbmr86360139f.14.1763595041205;
        Wed, 19 Nov 2025 15:30:41 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-949385c2405sm29374939f.6.2025.11.19.15.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 15:30:40 -0800 (PST)
Message-ID: <8ab727b0-e377-457b-9b3e-2499ea38abc0@kernel.dk>
Date: Wed, 19 Nov 2025 16:30:38 -0700
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

Ping netdev / networking folks on patches 1+2...

-- 
Jens Axboe


