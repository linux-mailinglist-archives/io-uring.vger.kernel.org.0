Return-Path: <io-uring+bounces-13274-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPQKIX70AmrpywEAu9opvQ
	(envelope-from <io-uring+bounces-13274-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 11:35:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF25551DD73
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 11:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 627CB30A3460
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 09:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511584ADD92;
	Tue, 12 May 2026 09:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WHcEIjXa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA66626E6F3
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 09:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778578241; cv=none; b=umIsvIT0b8/qBRH1v3vpXjExkO9/OqPjq4pXjd8m0nC2Z7IzPbsg3bwOEhHUA74XAmFTU26vzz/6o2MqwOs2hhEgdZngNB4JCBr0W/kVf6TQnD/5dki3tKg8xt7AeJMXIlD7bCTI3czXYogOuQkWN+z4dLOxyP2V8+otCJhON6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778578241; c=relaxed/simple;
	bh=AmxHQti+Cn5C3pCrdSnBlqV6BaHV+iBm0oydG8MleKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K+oBMdgL953teDw9ggAoir6fPDh9We10M9+y3N+spHlOv8PxpwPmdc/nxdzxplcYsWf9sYYWlY8QGzQ/uGEXjF9bARf2GLkZNp6IWToe+BkipGNofSYH+VSFiqX0jF8ShZkppAqILLj757yNxB4lVdB8bx8mR/5S5a03lUnX8tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WHcEIjXa; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67c1e0229acso8135955a12.1
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 02:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778578238; x=1779183038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1i6gK0r7rGWa5W/9WTpQ/H0vww/+AQmB17cNctDGbjU=;
        b=WHcEIjXadNkPFUtxZjibbIycxST9iPZAoiAmYMM+LukrN41+AEMZMMUijkA9iID3PE
         xg4pwXQf1Jf28htElNpnJC22niTXyfKF2ymcgg/R2KWT8wuJf7+q2BzapkmyoHtiZ9yp
         ZeXZ3dQBvv9XhLemLk6KoEUkaMeUy6581GgCbmz5Bl7y6+kbR3Wnh6/jD6M/cDn9kMfZ
         8AT9zIXP9OC7N3eldFmoe4xsIW/dvKGuw497uGm9lfr9q33CRajDdp+P2QckaO8WZZWu
         SK3l7wPIIMsdE2Ht4/8hyulcplC4t6peIu+13WnT+be/vVykhbBCd5Kgo5tQ7Kxl6IsG
         JtHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778578238; x=1779183038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1i6gK0r7rGWa5W/9WTpQ/H0vww/+AQmB17cNctDGbjU=;
        b=MumY7MzANhDt9Ch9o39qcndl/y/pYkzh/c1I/BUauJyMFEdFwEcbIbq8IX19eTOL8U
         Zqzklbc2GV26csN6ZQy7MSUJ9EuOIdN5bANYgDT4605zHYyaco+mxHm9RqmfX/b6rXXn
         yojSTCKXRWDIb7nWIPk4+6AVl+PPugl38RWcWrMpHXI5HvwHtkHqea1kUHI3s6kHzXzB
         d+DuvNISV6d3fJX6nMIT2NeXKMKUOjelMzyHiVoWBSr2oMEkFPelA0wz4L1GPq4+WOA0
         ooX7foYx2Ep66+gGACaQNR/c10/CX58ySUNzvzEot8xbG8lb7ip+cltR+W9G4pDCs8FR
         pZ0A==
X-Forwarded-Encrypted: i=1; AFNElJ+IrB0NBsKi16nkZGSYd2zjQQ2pMxkHEkVozDyq2fU3VMEacE3C/l332hfSKHX89y7XgknmWloX/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwscQLo7SlOoIKK4yeKwCb+62BaYzvaS3tFQ/txFDx2LD1cuKvf
	iqb1dvqtcvEVKe+fUJEa+2sqwuEf8OOD2ZsgIFc7BqRHeMdSMcES1b0Q
X-Gm-Gg: Acq92OH0kn9TkOHIdsBqoUP/kgyuxJiqTB5pNs1/cRtO/otQJniz1iB+SQ3tgfMB/Zd
	2W+CGcRlIcd6ZSnAvLC6tGyF5CXpMw1J0VSadVZKRREC0KQqzGOpshcvEZjzd4v6sK/MnhdqKbS
	72yOtEpj4LAjjHQATylpmygmCT374aiDZ4QEO/TgI6QypK1KG0SX60Ol2kD0oOtRkCviCoM4tQu
	ooXamqxFc0ljA5Az1/JLV9TyKLUZxWPVQktrlCeZOkPcA+YSq3CvkOJtZExNdQQoEOx+gwVfi9O
	E1Zbu1gttHbMpBmRpZcjSqGtAFnFc1sinlSKT/HuSQlCmy/2464iiknMmwJQZN0fpGA473jywb7
	FTrO8pPXJWlkjR0/Vn/rcOsbQWAiWBtMgghCqliIeXMIlFierkYkpJFdoC9H7YFWtPUNztDpP87
	WtNKCog6j56uhrLjug87cpWQ73CiWKADfB+7B8J/dao059uNfIawWegl4g/dgOkzYk5Akf4rLRP
	+b63epZHqNnjN/PvL19/hkVBUZ/NCkNcO27W0NKamm8pp70YQ==
X-Received: by 2002:a17:907:97d0:b0:bc2:1dab:3ea0 with SMTP id a640c23a62f3a-bd28de036d4mr114881866b.8.1778578237873;
        Tue, 12 May 2026 02:30:37 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::372? ([2620:10d:c092:600::1:8c90])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcfb7b17d1fsm303492866b.41.2026.05.12.02.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 02:30:37 -0700 (PDT)
Message-ID: <24cc68b2-c432-4623-92eb-b56b76850c35@gmail.com>
Date: Tue, 12 May 2026 10:30:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] Add dmabuf read/write via io_uring
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <afi7c-VUJWOLlC1m@fedora> <6873d617-c904-45f3-bad9-e1ae39cfecd2@gmail.com>
 <afxgc4hizusnAA26@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <afxgc4hizusnAA26@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EF25551DD73
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13274-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/7/26 10:50, Ming Lei wrote:
...
>>> BTW, inspired by this approach, I adds similar feature to ublk via UBLK_IO_F_SHMEM_ZC
>>> which can maintain long-term vfio dma mapping over registered user-place aligned buffer.
>>
>> Interesting, just too a glance, and it looks like what David Wei
>> was thinking to add to fuse, but IIUC he gave up exactly because the
>> client will need to cooperate and that could be troublesome.
> 
> Here the cooperation is minimized, maybe one shmem/hugetlb path, or memfd,
> and it is one optimization and opt-in, and fallback to normal path
> if application doesn't cooperate.

My point is that with widely enough adopted interface the user will be
able to opportunistically use it without knowledge about the file, i.e.
not knowing whether it's ublk or something else. But as you mentioned
below, it'd be cooperative interface in either case.
>> Should we try to push everything under the same interface instead of
>> keeping a ublk specific one? Again to the point that it requires
> 
> If generic interface can be figured out, it shouldn't be a big deal for
> ublk to switch to it, and the usage is simple actually.

Sure, you'd just need to maintain both as there is a mismatch between
interfaces.

> So far, ublk supports both FS and nvme block device.
> 
> And cooperation can't be avoided for this usage no matter if generic or
> driver specific implementation is taken, for both fuse & ublk.
-- 
Pavel Begunkov


