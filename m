Return-Path: <io-uring+bounces-11868-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CGiRAxNIcWn2fgAAu9opvQ
	(envelope-from <io-uring+bounces-11868-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 22:41:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4595E2B7
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 22:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C1B174FFE2D
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 21:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F4735957;
	Wed, 21 Jan 2026 21:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="p2TK2PRg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962B8436364
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 21:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769031687; cv=none; b=GYsHUC9rt/Y2yQ7puiOEIs3PBZ9MbhrVJM0jGWeHyxsQ/UYkXsrwLy30SN4rxK7SpTFheG9nBeg0AmhI0MCYpx4qmVEzn9ZxY+0wl/MYg3jtdwPw1GO37pRh4aAoHW21/+/MMDEKM0Yfp5dKqjAtER+ktqLKeqvnSVpACufF/yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769031687; c=relaxed/simple;
	bh=inv+qIu55eVT7U6a5+f+mWZPEOTvxQJYWfICgkfMZPQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=tCGXyoPpvzz4OiOUbKNT+Q4/bAztDpvYlez71guCqUCJzo7N5+ndRJUVXljDH9CMYwC8KoebVdZuSJ6URweuYHnDM/V964sDlgTwrrH++OQFE6rEH/IN3uzn+uaduT/ZIYLC9wwSBCB2gVSWu1lDyqvPB226yTthzrtCRLsFOu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=p2TK2PRg; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45c889aba0dso716019b6e.0
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 13:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769031682; x=1769636482; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nQ5PVGmReZLYfJNU3P39jknkseF3WKiui6NWDv/fopI=;
        b=p2TK2PRgIq5z1lx3mkLVgunaNjTWYIPoMmHQHw41XNpnfQkVMpqJwuajW6yyuwaQlq
         pBKrbLelATm2HmdGwexmBUofG3mxDK2CzQ9JUzO0wVc1ZUgaiHBn4SGRljYwLiEAR2ij
         ugyKI+LYEynnOSrtrowdxgGcdAYIKaa7VLTFntP/m1xxDFPUxlPSLEen+dblm+bA6UoV
         b3/OI5myBLZEeQikPsM3ZIjV/V42k7TBaM9Yoivz6Usm2zRoNujjrCR4prpnAnZgpCNS
         azs1BnpIo/OEGi34KgB5ZYsSq9mtRzYO2kpjwJqrzEIWwnvF+OcRUYxKXNXe3Pg7at9d
         77Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769031682; x=1769636482;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nQ5PVGmReZLYfJNU3P39jknkseF3WKiui6NWDv/fopI=;
        b=PP2qsKsAH24y0t2rGyAX0FUDvUKMqy6oj7ygKuxzwruqTA1Y20SZ5R896LDRib5hUn
         0MhmLeP2N9yWaasleMmkPTFLSJVsZ4XCRpMs+vof/f4D8a8riyPBVp3ULwkEPDr4IyaL
         tyEtmg9zkb5IzYR4xv8ThkZuK9dEYP9br6SXfQ/hegwv6S67d41hoNbUBOaA/AdWsXfL
         P4Yn9GsxkSq2wT6qmwLQF8AQyzCZHy/MtzL7jYFgTCu5/VknNt2HgJ423tFUiaxl/6UL
         8dgtQxjX5+XdCekASs6WPpfatVGfU3U4aLWr1PdSDkwmCPsakNwxJ9Ejyjbl9V+VekGb
         9hJg==
X-Forwarded-Encrypted: i=1; AJvYcCXciasD65h/CfRHEj65BN/tfkWF/P5v4ygIk/WNdnwzvSkrrrHQsP9VGJ1rcjpQLIWZzv7t+9DpOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLGPyZnienZcc5tg8FnNP/X0mVcUBoxDoEn47/SOh8wFOb7Lcc
	HwbX8+vxha5ynd8pb81Wr9gzyH2B4P89OnGIYGkkYLgldDsP9dF9USWJKnLzfsAQzc1t8A144jv
	+WeI0mLs=
X-Gm-Gg: AZuq6aL+kw2XFa2zk2MIg/j2VsaS2nOxcQuFbGJ+fD2/jHy3IYbRxcETI7iPlo6x4I4
	eiww5SQDe0KfuF7ItBu40tOCyOMwdmqgtGksRgRmtqsP7b9LpslH02dAZZfznrgriMOVGGgkfYP
	JtXUjsxhlYetAYWMpLv43aXSBbTGDo3wEOD52bxA/YVqhERTTZN1AoB8WHF4fmkPdVL5yk8Vq7K
	0wqObia6INxDZzqLj7MxjotEaLIZR1NJZu/QuAfOSCG18dL5vbnD0eUjJ2AmcxmC8NscSiXR9sr
	M3Jdopk5xrPIEOVk7waiONycDMKexBLJD7yqmmeFVRERiBGoJ8GH3tPFnc/wBwA2u3Az0Nu6j4w
	hlILIH1/CIckxbb3IztHzfehPIVZ7S3to6rU6PCPUZydw6UzISd5t+VX4iFtzdS6Zkyrsh0o5/0
	ejREqWGH0ISpxIiKHbJmUWUsW2cl6mXiZBdpUvN4aoPPw4lRzWsk0zwJz5ykE+bTCE8edv
X-Received: by 2002:a05:6808:118a:b0:45c:8708:4d0c with SMTP id 5614622812f47-45ea3de819bmr516528b6e.29.1769031682043;
        Wed, 21 Jan 2026 13:41:22 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9decac58sm9062047b6e.5.2026.01.21.13.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 13:41:21 -0800 (PST)
Message-ID: <7c397414-ca45-4fca-acb6-15556974da6b@kernel.dk>
Date: Wed, 21 Jan 2026 14:41:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
To: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68a2decc.050a0220.e29e5.0099.GAE@google.com>
 <7aa47c41-df51-4a9a-b021-866ea1bacb7b@kernel.dk>
Content-Language: en-US
In-Reply-To: <7aa47c41-df51-4a9a-b021-866ea1bacb7b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-11868-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring,4eb282331cab6d5b6588];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: BF4595E2B7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/26 8:04 AM, Jens Axboe wrote:
> Just to wrap this one up - there's a fairly lengthy explanation posted
> here:
> 
> https://lore.kernel.org/io-uring/937c3e38-368e-43eb-9d7e-2dcc0697799f@kernel.dk/
> 
> which details why this isn't really a bug, it's just slow exit due to
> the odd huge reads (and number of them) syzbot queues up with io_uring
> before exiting.

Let's try the syzbot special work-around, hoping that syzbot has
unborked itself again:

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest

-- 
Jens Axboe


