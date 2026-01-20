Return-Path: <io-uring+bounces-11849-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SH5GL+3Lb2mgMQAAu9opvQ
	(envelope-from <io-uring+bounces-11849-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 19:39:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6934A499A1
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 19:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 03FC27C749C
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 18:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF4344CAE9;
	Tue, 20 Jan 2026 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dr3qN5KX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4CD44B66D
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 18:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932353; cv=none; b=MCHyN3rqBTTJCJJYyvfVDIx+9eCK5jQvcos01klE21CyuIsPdoqOY7m0mY+GGGBDQZh99xinGNTBk6lbZKv2Fdj/3n+3JYefd2f2L0JBEzBVw0bJoXPgm6xdU9pzyOT9TWsnJkdvhGxdItGrOJFmain0aprpniirgycsCroLy1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932353; c=relaxed/simple;
	bh=KLTpUf4YMDljiBb/7cbeOkbyBQ9iYQXYgUIpDpEXLiE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=LShwb7fLnLXTEGpzT5Tpwjh+P3m3npBGlXi21cBr3asX59fghst40zgeblLb+TAEi/kIVghdAG9vojGG6YxvXnIdeVN4vGkwLQ1wXxhy2t+yR2U5ONw145q5oiaTpt5taHkpmnVRLzT68h+gJsMZpBgkBdin+temRQOjjoWVkOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dr3qN5KX; arc=none smtp.client-ip=209.85.167.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-45c7c841904so3241044b6e.3
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 10:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768932349; x=1769537149; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SsG3o0vdNBECz1NN4F5ibAKHduOE3br2Wxx7xnin428=;
        b=Dr3qN5KXUsANbiN0nLO5Dq8bTwzjnOlkQpYuhcPyNiujcAOrysgsIhP/WS0fmi7lON
         KVHLczRoLOfvpDH2+UvvA1ZquzX0s/IPl4vfoGKyZZcSs/dU20U8q8Tp13E9MZ7uq1Mw
         eRnMnS4TePQSUH0AXUxepa4VKBYxgYsFSc1YL/U/mItM4xzNxTjRzNgqMsu9rlFhqnmx
         lGDR+R5DueR9ztETCXixElmX7ZwZf7OK6akG6EijkO04IIlWDa/wkZ6qvoj8P/gZBcd5
         2t5r1UEBPoD8vx88tzBToGCM+BJ9bUOUFdpUcHsXQY7naVgTqFxfQy5Z09iJF+j+GyT3
         Ct3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768932349; x=1769537149;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SsG3o0vdNBECz1NN4F5ibAKHduOE3br2Wxx7xnin428=;
        b=GB78T2NID9WExC9MRo2+Dq6b38umkzdr6IGsrnQYg9h2kWhUa9QHCVyde8Me0q0MKg
         UrswT0LMXrSGWMtu4j8gZxdWIW4veHK9wytGgKFg6g6E4h3sqYVbg9iEYzdjoL951Eyt
         sr7kv7oX4wAE+pVCd96hAeRPvHbi/zuFq8YS23QxKZ1fWEbPF7c7THuvZg3Fg6R2FXeT
         hC0o1OucnMeyOMtxR8j8sPqE+NfaG9wx9D2r3EgbJzrGdwN1YRH19OhwcXqBcijkVHdx
         Zc49H9xg4ei2wu0S6gc0aWX4uGkddrhngqzyzvCkFZrtvf17Q/e9Wt2vklKTee1fwQFG
         JLvw==
X-Forwarded-Encrypted: i=1; AJvYcCVKjVtjNuMHTLD3CGFadVZCQ250ZjZX3s8rVTty+m3sQjE4eTiCIgWFJllcSO8piSoUu3jAC1GB0A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLkNeFc26JyzLgs0Ewf6hmF3QMB94UdVPs0RdeliQIBG2CerFN
	R2hssSD10shhEO8HKIHKcqc7AeZ62SjoQALkbVx/apQzKJML1yVtqi0n/858RWu0aWM=
X-Gm-Gg: AY/fxX5EYlrBqsfe9JfGUEXHNhez8JKZcMx2ZUrn+UdFQTvp1OSN/5yKD4dQ5phDkwJ
	z8USympknUbW5QevUulZKrQAPWpyYqk4kBG71B3YORfhPvDgLHap3zzGzBXe1Th7bA8eYtzRyW4
	ICxvtyxIy+67CAVXQwRCIA8PcUavy7nUS6N/sff5K1duSvOgYIzqY6pKJeW4wwXGai3aoDHxk1j
	O+oduvtb2tGhla0vRPBMH8KE4gSSRyFYp5V4uH250thcju62MU5bg+WvH+9kjxb3dOrQJCWBOLx
	pLa/E4ZSd7NOT56yMFHqe3lVrVyFeoWPA9RyojeEKGlCVC4JxMg53zhTAcJWArMdfnugn0hySau
	/2RR+HCxEXpvDrzDP3z7Zx1M0rS8dfRuhPOslxYZ5+NTxX5elCn9V2n+2UQipqoPzxzPEeSEppE
	M0oN2u9BltleQW3syJ819tcWq8vGa+GYlSSYXVj3H7GtRzb019ziqRpuyUAmCvRtgupwZ6
X-Received: by 2002:a05:6808:d54:b0:441:d05b:abbe with SMTP id 5614622812f47-45c9d70bf78mr6857715b6e.5.1768932348966;
        Tue, 20 Jan 2026 10:05:48 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9e03faa4sm7276704b6e.18.2026.01.20.10.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 10:05:48 -0800 (PST)
Message-ID: <48ccf244-6af6-4a62-b18f-e9fee573b319@kernel.dk>
Date: Tue, 20 Jan 2026 11:05:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
From: Jens Axboe <axboe@kernel.dk>
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
	TAGGED_FROM(0.00)[bounces-11849-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid];
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
X-Rspamd-Queue-Id: 6934A499A1
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

Let's see if syzbot is fixed again:

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest

-- 
Jens Axboe


