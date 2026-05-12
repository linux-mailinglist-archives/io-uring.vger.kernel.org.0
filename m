Return-Path: <io-uring+bounces-13273-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KyBDGD0AmrpywEAu9opvQ
	(envelope-from <io-uring+bounces-13273-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 11:35:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B62C51DD56
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 11:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A51C1300BD8A
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 09:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A394A33F1;
	Tue, 12 May 2026 09:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h2CAUCIc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D494ADD85
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 09:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778578233; cv=none; b=Dsa0dHXTQ37Cc2WFpgf9mRzT5bFS/44ERW7IqKrnAD53QZyuTNX51gUKZaf6C8y9aWmC8kPdUBpgXZLt9zyy8/uQlzk2DH0xgyphtIWA5hbuM0cus9QJeypyF5bta6H8fLahdBv6Ke2FX9VAXj5C2LRn3gdTIAShrDU9v1ezQwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778578233; c=relaxed/simple;
	bh=9ZVEYWiJ8mfJhHSDmdYoWsnzgviWs338ieiJcp1NW8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/rz5zkX8do9ewyp8cGJxwKIPRjgDtUwNy/6cBBOs5NrKhYev7oz/mr+7g+Y0S5pMJiLP0NVdI96pRwIT+fO8GlZ7j1mtc7BSHuQYVJyGdEiZnuBrmH2N5XWR77OzOhYSx1K7w/k37Hobnm5hHI0JG+WQk2drzhfQytEnNPyxPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h2CAUCIc; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8f97c626aaso48074966b.2
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 02:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778578231; x=1779183031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VGZAkcM+ym8AsbVGOAJ6+xeqYSrWcyKvdgdcKQ4eIYE=;
        b=h2CAUCIcRb1DusSV3M0DsVMKaSnFMzQWB6BN488Z0jBqWbmUCtiTejmJ++7kPmu9az
         GBKb0ygNhV2hiSnqxDsOYc4Z4bZoFQNS0sIGhGkJOhwnEXt056MHvrdx/cJoM0ub2HUN
         NOvpioQrJODvqUNhlzDTfCE7DGx/rnVg27HjOsNWBMVHOWkKkLp3exAhuEciaqbO6r9F
         qRqgLy8MESUqxlcORPoWtDDbcIV9/tbZe41qBYHOUhIsPqYoAtcBornYvNJbQBmrrmQa
         gyfnctFEo/U/XYK9lRLVL/m9QMQM7poAmGO/UeuMf4Zlfs09jO9HRptcF0fqlDrExe9g
         iAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778578231; x=1779183031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VGZAkcM+ym8AsbVGOAJ6+xeqYSrWcyKvdgdcKQ4eIYE=;
        b=a0/38wk5SEYfGiRkMn53Vqi7K/UFwK8RCeMLv1WWHosmxyURq4LLnfM3hId8VFhPPe
         6zuK4nlqmmIMaaq4HD24DzeAdrtv2ai2x+cMAaqCQiFD++cfbDxZlWLcvae1Mczbu/vl
         KbdJqquOF8yfO7LhSDAtLtpYVjoHjJ9epNTugVTm13Dl33xlm06wkcH/XbQ1XbR/ajak
         w8WHZ/zAaSC78As5nPtStzjH6yhafYcpFOLQiJ8Mhl5aTmz8O79VyLjbfOxVMHIpe1PY
         aamyCJjWtqc599a6UXXA6pW5LfWk+++CAs02dqJbNaVdTRKbKfPTAoN3Mr+SufM/Cio+
         IPaQ==
X-Forwarded-Encrypted: i=1; AFNElJ9a8p7+Yl/E+z7p7xHDAM3450uz/1VHKMfq40fiCY5xllUdMsM3K0TsirMxksgjShpaTeceA/b6LQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ9tLH8H/tLLCiiN+KrZZFxdu010QTdGFAT3JiErIOlbh3TtbE
	/+kQtSsuTYRVduR4QQzU2q4Vi9perbnE/C+5Q3ZkO2OBmAX5rm6aExmv
X-Gm-Gg: Acq92OGdddVboEvp4JcUyrfky4MFiGQSnLk8aRpiIp7Gy9fsMKxcb5v9BULDGiyIZUd
	xoqLaC46A8u8kMAnzj4YuLcFodAo0ETNheerstSWns+BGW7tZUKpclxZfKBfzSKxjkyLFV88GnC
	T7J4XhVBszZnVKIkbQy/YXThZtQULUBqtQ1xo1Y1vutvNSCLd1XaPkszT+ZPeGwhvQjmvP09dGq
	khf4LEjnD5p6gduT6x7UP2IUOSSF7O2r1tALQKJWqP54FZfyAkmxj+jwPv3+gcFF+BMmt+me3/o
	KLSnnm5/X8M3Nl0UMluoBlBZVsl3WZbB776P7LhQxLbc9r0colzUNTdEoNPjMI8Xzr8z8Oe289w
	DSdLCjd2YRBnX4Knqocygq0JXgvixaEPMruOEaz7L5xhDpP6UQ8/ngYQp3PFo4FXEmblSS7Y+Uk
	Q0CmfVmx27HmKXhrVc3XEWdXLFEPftJ7N2IPzbYz4ZVaAmw60C800O0cX/Vm/dHMFGS0S7E5WyJ
	5NSi7TyvRW4QwPMWxfv8rOpLWChorG/vshq5i4s23Lw4x8OTw==
X-Received: by 2002:a17:906:99c3:b0:bc4:f3ef:e43c with SMTP id a640c23a62f3a-bcaad52246cmr973369766b.45.1778578230560;
        Tue, 12 May 2026 02:30:30 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::372? ([2620:10d:c092:600::1:8c90])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcfb7b17d1fsm303492866b.41.2026.05.12.02.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 02:30:30 -0700 (PDT)
Message-ID: <a4748a29-8aa1-44c1-a1e4-b82f4f191d4a@gmail.com>
Date: Tue, 12 May 2026 10:30:27 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] Add dmabuf read/write via io_uring
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
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
 <20260512070045.GA32030@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260512070045.GA32030@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8B62C51DD56
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13273-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/12/26 08:00, Christoph Hellwig wrote:
> What tree is this against?  I can't apply it against the usual
> candidates, even accounting for the time lag in getting to it.

It should've been a Jens' for-next

> Can you provide a git tree?

git: https://github.com/isilence/linux.git rw-dmabuf-v4
url: https://github.com/isilence/linux/tree/rw-dmabuf-v4

It's a wip branch, for now it's just v3 + 2 fixes.

-- 
Pavel Begunkov


