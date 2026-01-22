Return-Path: <io-uring+bounces-11883-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NpkMC4acmnrbwAAu9opvQ
	(envelope-from <io-uring+bounces-11883-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 13:38:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0518966B8D
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 13:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3547B8C94D0
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 11:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCF040F8D5;
	Thu, 22 Jan 2026 11:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nljiXZaw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14295362142
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 11:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769082428; cv=none; b=o/u7uMyFlE9unv6YVa54vOjG9XEbhkstcGGOIzRj1PalFgtsJ5/OIMCSymM2xukQo8IpAAP+uOswtXzF5OM2bkfbwx6mKtnXVeUgaV4+w5sdl6x+byBeOgY5KV/yfySdEfO6Fv+LYSCdCktfHUWn5YiLtsPsokaD03S3k+hN7Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769082428; c=relaxed/simple;
	bh=L23kP1MKIlxxrA/vTdHehDXUOocxzJrIy3gu+khhV+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cC+LLKaGWsBogB799VBkXm8oWXIhFVx7zRjGoIjOE9fhXHz3zCkErysCRsQDCHxPMNfbaVg4/dRYdwAvOKLpoEtXXDKdVvExSUPXBSddzIJb2Lloeo4A1X3zZGcRNswqcMOGCCnEHFMe3iViVT+KViTuQouMZd+WS/zSGZ617kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nljiXZaw; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-435903c4040so575570f8f.3
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 03:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769082423; x=1769687223; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/c04FssyRzWAvFZbUZZ5iSwy4KaO1b4NaDQ9GK8JLME=;
        b=nljiXZawh5QxydA4lbo89SOm6Z5RduUhSqUBtra9we1Svfex2VEIf860MZoiYSNwow
         Q7dTem3yaRi1Pm57q/7He6mqWTLV55hH67oAbdm8VybY0K95d/umdKxgRfgJjj/ReFQd
         peOUFEAhJji17Q4l5c9oqDNwEjfRdHuPZ7GJ1rTO6/qCPaCDnmpnF5aQM0HtHerG4Ljv
         ccfpfM37hGbhRqBlN+54iBu05VAD1kreB0csgIgVM+xW3c6rOhHZScVQzYMjU6silAOx
         xWBcUQOsAmsQtVBgbhykOCRtAhr2ioAbGwk207natgOb0+EZLQlj4GIQ94Pjf+6/MvxK
         ccCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769082423; x=1769687223;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/c04FssyRzWAvFZbUZZ5iSwy4KaO1b4NaDQ9GK8JLME=;
        b=vQK7jfi2DKXkHX4iBCnpPBVqRZjE5tzmivajupDbmPE458k8QF63Tq11LtV6zUQq4t
         Hdlytpdf8EWWdrYNSclQeYAiQybrcAl4RAo0rc4t61KMwiYqxyTfJMmVrX2F7Up7ZYKM
         SCuDmFyu8rACvBJ8nphRD/c8Nu+Em7REnEFbTuLh1GDrnamoPdJfUMMAa7CRPMtHBWe4
         GiEdw9pTcynG+UAUup8X5j1jmK8ldZOb7Fjk3tkARdie0Fr5K4vYdtB3sNTjx4JximXb
         80FLVRM0bCt9x8yI4LdAeS3DVYnVeMVkyNQoRoeWD51LLyQzvwFVjWT1KUVWNbpDzVw9
         mcOA==
X-Forwarded-Encrypted: i=1; AJvYcCUPe/1U6zJIWKKJAQ7KCgBv0qLoSofxr6InzMcXIyZ/LorNF7L7VfygNkU3p0VXRhlCxQoHq40aAw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjWvi1C4qeqMLfv87WRaqz4SnTmoxT3zOuY5jsWcHorfabdIWP
	UImg39EpByt2A6DW2BukucZCIMb5S5WJPXVjWOGAVpNrmd4phM+EPE11
X-Gm-Gg: AZuq6aJQeGYZGlOazDNt2HR4zOqSR/ApCUF2DLUweC8E+xgaQmJ/JcYpI8sAp0g454u
	+hSTceQrq6itcBfLhJOQynkKJlUwRdkTYYyAz6dca4W7s2EOYwc2xDB8xhxnRNqwYd+TTvJ0fcH
	noI5vY2oKFXNIJ22Ephkycoe0XlP+OYKerjLVYNywODVKRXHzB0yk0hIVXqoDXDTre3K6dbTi97
	HWsJoz0vWoxMNnQPT794KlJlJ1s7GPxB/XPVRBaKbaMjnf/C/nt+VJfmFgNq6J1Y/ae1WE+exRo
	4r65JRkKtQfJ9sDTSG83KrbK2li4Wj9amFGP+3PE8aEMLWdwTD8xmam1D1kkNW6SMl62C+G/wG5
	RGdLcAIicTt2ftDN02TOUXs4DrwUHADlNVoGoybYZbNK8+SpglkXkjM+aBkroQj89U37CgmQ/OL
	s+h7danxnzPYCqUIQnMljR5E7SX0tUpY+faqJcQdNjNjmsgnMhhbk5O8wkWRVrvEZuVdTzUbk7T
	VJ6TX2rSvilZUMpSQ7XpMbcQegWiZp+UMO3WWl/PA9tEB8=
X-Received: by 2002:a05:6000:144b:b0:435:95ce:836e with SMTP id ffacd0b85a97d-43595ce838amr11818024f8f.55.1769082423045;
        Thu, 22 Jan 2026 03:47:03 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:46c4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4358f138e26sm19447555f8f.17.2026.01.22.03.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 03:47:02 -0800 (PST)
Message-ID: <d3389449-f344-48ae-ab13-697e01d1cc46@gmail.com>
Date: Thu, 22 Jan 2026 11:46:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 05/11] block: add infra to handle dmabuf tokens
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
 <CGME20260121074135epcas5p2eeb621d6acc9b4b73e6d45f5a40c078d@epcas5p2.samsung.com>
 <20260121073724.dja6wyqyf5apkdcx@green245.gost>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260121073724.dja6wyqyf5apkdcx@green245.gost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11883-lists,io-uring=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 0518966B8D
X-Rspamd-Action: no action

On 1/21/26 07:37, Nitesh Shetty wrote:
> On 23/11/25 10:51PM, Pavel Begunkov wrote:
>> Add blk-mq infrastructure to handle dmabuf tokens. There are two main
>> objects. The first is struct blk_mq_dma_token, which is an extension of
>> struct dma_token and passed in an iterator. The second is struct
>> blk_mq_dma_map, which keeps the actual mapping and unlike the token, can
>> be ejected (e.g. by move_notify) and recreated.
>>
>> The token keeps an rcu protected pointer to the mapping, so when it
>> resolves a token into a mapping to pass it to a request, it'll do an rcu
>> protected lookup and get a percpu reference to the mapping.
>>
>> If there is no current mapping attached to a token, it'll need to be
>> created by calling the driver (e.g. nvme) via a new callback. It
>> requires waiting, thefore can't be done for nowait requests and couldn't
>> happen deeper in the stack, e.g. during nvme request submission.
>>
>> The structure split is needed because move_notify can request to
>> invalidate the dma mapping at any moment, and we need a way to
>> concurrently remove it and wait for the inflight requests using the
>> previous mapping to complete.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>> block/Makefile                   |   1 +
>> block/bdev.c                     |  14 ++
>> block/blk-mq-dma-token.c         | 236 +++++++++++++++++++++++++++++++
>> block/blk-mq.c                   |  20 +++
>> block/fops.c                     |   1 +
>> include/linux/blk-mq-dma-token.h |  60 ++++++++
>> include/linux/blk-mq.h           |  21 +++
>> include/linux/blkdev.h           |   3 +
>> 8 files changed, 356 insertions(+)
>> create mode 100644 block/blk-mq-dma-token.c
>> create mode 100644 include/linux/blk-mq-dma-token.h
>>
>> diff --git a/block/Makefile b/block/Makefile
>> index c65f4da93702..0190e5aa9f00 100644
...
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index f2650c97a75e..1ff3a7e3191b 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -29,6 +29,7 @@
>> #include <linux/blk-crypto.h>
>> #include <linux/part_stat.h>
>> #include <linux/sched/isolation.h>
>> +#include <linux/blk-mq-dma-token.h>
>>
>> #include <trace/events/block.h>
>>
>> @@ -439,6 +440,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
>>     rq->nr_integrity_segments = 0;
>>     rq->end_io = NULL;
>>     rq->end_io_data = NULL;
>> +    rq->dma_map = NULL;
>>
>>     blk_crypto_rq_set_defaults(rq);
>>     INIT_LIST_HEAD(&rq->queuelist);
>> @@ -794,6 +796,7 @@ static void __blk_mq_free_request(struct request *rq)
>>     blk_pm_mark_last_busy(rq);
>>     rq->mq_hctx = NULL;
>>
>> +    blk_rq_drop_dma_map(rq);
> blk_rq_drop_dma_map(rq), needs to be added in blk_mq_end_request_batch
> as well[1], otherwise I am seeing we leave with increased reference
> count in dma-buf exporter side.
> 
> Thanks,
> Nitesh
> 
> [1]
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1214,6 +1214,7 @@ void blk_mq_end_request_batch(struct io_comp_batch *iob)
> 
>                   blk_crypto_free_request(rq);
>                   blk_pm_mark_last_busy(rq);
> +               blk_rq_drop_dma_map(rq);

Ah yes, thanks Nitesh

-- 
Pavel Begunkov


