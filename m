Return-Path: <io-uring+bounces-12046-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oBX9KbQvg2kwjAMAu9opvQ
	(envelope-from <io-uring+bounces-12046-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 12:38:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CD6DE5370
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 12:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CA316300DDC9
	for <lists+io-uring@lfdr.de>; Wed,  4 Feb 2026 11:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400413D5259;
	Wed,  4 Feb 2026 11:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="noKMSJ3U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E5E3AE6F5
	for <io-uring@vger.kernel.org>; Wed,  4 Feb 2026 11:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770205093; cv=none; b=RRn8MebTcwmnEbW5fLDX0IRl6i3jreQ2sMGd317tf3k4Yg5R6VRt8DWZYjgxw8cuTkjBkT8L6oHH4cjd0coQoEg7H6eBTc9YS0WgTXSmRF9HsZFmYSGRS7bECKvgzk2OrcRZQ0+rYU0VjmWi6IPuMVwNCuyY0Tba/S+Nu5AI7rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770205093; c=relaxed/simple;
	bh=MF+F0MxmCmAJTtDcC23vc4GxbH150s8obld4ZtpfEJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SWzPso3OAOkU5/p6jIOZ5FQLdX1ylOBed2SFyp49iujr3syZD2FhgFf26p8QW7OGljEBgz4sI3X3ndv1SHOhK/7a6BvyEj6OmfgN2NKXSaYE8PuDqy1JlConJN86qKj79yp8kV1qY4pP458fCr9nMk0rvVc/s0h9FuXDp/VTXfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=noKMSJ3U; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48039fdc8aeso40633955e9.3
        for <io-uring@vger.kernel.org>; Wed, 04 Feb 2026 03:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770205091; x=1770809891; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QHhoGSxKy9vmjCLMZ5KoEcOBQkVZjkB8fx4BIL0Kk8U=;
        b=noKMSJ3U4dU2fl/he3lDjKMtnV7u0OX94T6am+/8gPpWThXEY5yAHoGQdd+EwUZtzQ
         HjaH4kz/Ju9SRqZPwRAG3o+yHg7alWpU3flr4KgHAbvFinumYEmXvgVbBzhT9rYQSWJl
         BrPwNjepVWMf8RBW6pPZk1l0WZnaR/PplPh/GlANKvCB1XHrkLCAQSiYFPw6RZ0CfX5l
         jQxynIC+bIKCRPInetCdd0FvHJwgMj+Mx+JlZa/nxq9JPDO3mxHq+wfKu3k/r4brlvPh
         fsWjO7cUPZ+Rbl9+26AWjdIK42T34QL1IABlXC+qDSRL/KKFmCjTaIo54S8ZT/olrnQJ
         7Y0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770205091; x=1770809891;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QHhoGSxKy9vmjCLMZ5KoEcOBQkVZjkB8fx4BIL0Kk8U=;
        b=RRl2JR8QNr78RWp34LL3C2Eb7rkZ0qp+RRO9kP8KRc/W73v2ZeZaXqlc21J+lv75yB
         eA3IcKoRhyH5LRfGhnmgvk+GeKCe5AtOv0/zYbEQWqjWhwfFrRMAriiXGOekSbuDO8Dl
         jUkHKUGQ5G5HvIEnRaOVlhfDWnKhZmF2NIfTf8Hxpd/HsnwkqcYqN3GYvn21qLZz07Ig
         iSlYr+n5OeJQEeaiIGeXAYnKsGF9EC020g8Rto5oBxiry0iWvUKK6YIAbP0NerRDdFcK
         eq39p3vfxHpCa+fsF4zTCUhM4RXOLzLTH24ew/iyh+C3C/DBULm14tDkncLX+WJVqGjc
         4QOA==
X-Forwarded-Encrypted: i=1; AJvYcCXLwBn9+5NKSmh+hrpDdapfdr9donvn5LBpOTFT6r13v9wMjqY94omLgBvP0El/2yzCvXTHmdeDZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzX7O8Bce1N6KSvsjQDYUY/MNWK4Tn4kCONn7/SLD/eq+h6vp/E
	lPGKbSBvRYXqQIj7y1T3Nary1GPOJ7DbagBhLnC1ymD+Z1cG1de0FSwe
X-Gm-Gg: AZuq6aJS+UjqQ/fC8gm454GBXIy7VOm5GNvXt88fZZYFT9aLgr9uYL8CdPCKyJh0Z2v
	QTOtexmleFO+p9qcZWcQDwCJtuuf3ZPF/XQZj2anQS+UXNSffycJTk7gR+e8KRDPLDt6lApStOC
	V2CVgr7SQqjNbh2zwCWCyKhUm9WFDEI+OKRH8Hl8LaqsuzWBtMUOg8u4Nvh15J+QUECOZXFfJZq
	qOhcLesHcdxOx6AZzNtKupu8muh3zyzkx9SZiBewTmheKJdd3PXIiLiN26cJd14promTu4vyztQ
	mUu9j1Kc1mYxp9bQwsnDs3Hq+bewlb9+MXUEeBz8b9z+7/FqboGAVLrjthRSagE6SZphJ2Bhk6f
	XmhmddS5uTc4QHrHA8/41U2JapH3+TXqVMG3rvM3EYOHBVCkLpIpNmN2xfIs9aAIyXURkiqVWnL
	AE5/gpEqtTWiz7OqhLWSa19liC/I43jUHbKyfrZE43KhtdEKVcp58FN+QBkVH+uaPk6SMFhex1Y
	m8FgsdIvshysEv2gogxu95uLwXZrZvPSojw1+/23Jrf9HY=
X-Received: by 2002:a05:600c:34d1:b0:477:7ab8:aba with SMTP id 5b1f17b1804b1-4830e92a768mr33410685e9.1.1770205091057;
        Wed, 04 Feb 2026 03:38:11 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:d656])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4831089d547sm52311635e9.14.2026.02.04.03.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 03:38:10 -0800 (PST)
Message-ID: <82f0e957-94ef-45d6-971b-951540bce136@gmail.com>
Date: Wed, 4 Feb 2026 11:38:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "Gohad, Tushar" <tushar.gohad@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <aYI5S1puAZ-rPvlC@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aYI5S1puAZ-rPvlC@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12046-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4CD6DE5370
X-Rspamd-Action: no action

On 2/3/26 18:07, Keith Busch wrote:
> On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
>> Good day everyone,
>>
...
>> Tushar was helping and mention he got good numbers for P2P transfers
>> compared to bouncing it via RAM. Anuj, Kanchan and Nitesh also
>> previously reported encouraging results for system memory backed
>> dma-buf for optimising IOMMU overhead, quoting Anuj:
>>
>> - STRICT: before = 570 KIOPS, after = 5.01 MIOPS
>> - LAZY: before = 1.93 MIOPS, after = 5.01 MIOPS
>> - PASSTHROUGH: before = 5.01 MIOPS, after = 5.01 MIOPS
> 
> Thanks for submitting the topic. The performance wins look great, but
> I'm a little surpised passthrough didn't show any difference. We're
> still skipping a bit of transformations with the dmabuf compared to not
> having it, so maybe it's just a matter of crafting the right benchmark
> to show the benefit.

My first thought was that hardware couldn't push more and would
be great to have idle numbers, but Anuj already demystified it.

> Anyway, I look forward to the next version of this feature. I promise to
> have more cycles to review and test the v3.

Thanks! And in general, IMHO at this point waiting for next
version would be more time efficient for reviewers.

-- 
Pavel Begunkov


