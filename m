Return-Path: <io-uring+bounces-8254-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F221BAD03FF
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 16:28:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57124189C087
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 14:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B9876026;
	Fri,  6 Jun 2025 14:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bECm3ooN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89943126C02
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 14:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749220095; cv=none; b=TW6w+aX3Z1TN0IxiVClVv76q3pfxXXcPgEQWJCw0z1Mg4hdmWhrwxOedFaQxIAmBfPkiVuxuxohidJfs2koY+pWe4c+DhpvFUOGHKUNQWGiOKNGExv+0tkhXALInHLTlMrrcp8F7VPmCFu0kinwrm6pKBxJ6SwWku/Ws8dkOH0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749220095; c=relaxed/simple;
	bh=yGw2KCsyMGQhD+cV7Xq0jX7AcZgSEZyRWrXunzclL1s=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZWaJV2NmJgWQBEYv3FT8MFS2CT/OLCQaRXdawVCXR0w9q3MWLlm3fRsp2ydue3kIu1k0it/iRzNnRAsXAMQklSIIPFSuJGkoXVu4D98gncjx7uZWA1pCHThoWTpJy8HsnPMb4r3g/irc3EGCS2DXuEJ4edh5dNHA33YmVHgqdvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bECm3ooN; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86d074fc24bso66831939f.1
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 07:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749220092; x=1749824892; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3O04NlGxiolO1CmbKy++35ARtom08d+p1GVLWa2NnfA=;
        b=bECm3ooNqOr7ZBwPRk6qssZuPTq/SvT0mGTHY+CBUFRlVV/URBM25Vj9onOyrZrb+J
         QYqenh/1eLUU/W0kUWtA51gkAlXsFMAoLQHz3rPKi27xp21OwpVr/J5IjVJU2sdG4G1z
         blOw+eSjlymw2z6OjEQxCRUWNLmwst9+4wFxFIjr2bK8ZGezbr9So8eCSpEek0ql0MfF
         o8uxFN5dh/t0jMwI2TWkjLDLHbezOWfr9nOzVEcgS3fhgsl6gvey9xB65c+bwBGA1iOq
         vePUbVswkdHirTXLIYnjNH+bFtUDFiYUOZv1RyWjn3nXWiD95JmybEYWBY6H9jL2aygO
         Mwpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749220092; x=1749824892;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3O04NlGxiolO1CmbKy++35ARtom08d+p1GVLWa2NnfA=;
        b=ttYlvgrdvxyAJAUR+KI3szuQHfAoecUbHAuutBjXXi92T/E50iXDTWYupuvCnsuCMb
         WHXmEQFaQFTeq/4tNtA5MBBjNYdIiDrUDWaN/yLWF24dkNkWpQY7NO0a7Jkqxt+Whtdl
         IiHUukC16hKCAGcBa63jzUda+5Vzi9Jqv+bIu3ceTXcmJ9UouD/fadSg5srg+he5ANg7
         jNBsTBFCgDi8FW3aA7qe0z7n5ttlVruBJFV70ZT4MBrj4PkjipgeeZMzBapfbCyc2IUM
         dptKWDZ2E9AjBRXNCQVHWhVgBmkxofylPQ4NYR1J1HMDs3HKmSgyxjCChoKA9E1WTBbD
         AO/g==
X-Forwarded-Encrypted: i=1; AJvYcCXKCblCrdQXfbb/3Ng4WbzKBb9ddBr/dwan8fXcAS5F2PZyX7AnxFo+e66N0ykltqPMDn0w55M/Jw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdaYCwbwAL9A0KQCI3QEJtRmiJ0bccG59Irfesk0f1gu/TdNgl
	4guzMiPDpjVzxKaLPRVXmYtwEB9369GC3uAySGZF8UxoSFNjGmiylPcLzNFBfcNeM/4=
X-Gm-Gg: ASbGncvHcOfiwsWR1Gcek/NQEHZUHpKqgM7Em4seAuOGid8Hc3+qa5yZlwSdcb3CpnT
	urb+51TpsxLl2gsXoHLDZwgzXJK3zPQSsQCT2x3OmrWM8lOhbss2KTGbx+am2dUYTbWAVyrTPqd
	c4W38anb7orkQbuO6dxH1upRcO1tkHzmCUjUID+WWKg9ZlWa2hBWnJ3N/LXuC7oHcTyD8vceW0t
	P0Bda2X9ebnBnomfJ3PO5Yaj5UJ6yHxGOfW8KqSVIB77IUMi5nm3YqmHjigBVl9FXiK66p80G+q
	fg64CGlnJ5mCtMsEw9koqUvC0RGHeQk9gbYMyxbicx66peQYw8YAAtWKLA==
X-Google-Smtp-Source: AGHT+IEDaUVHOPyyhzFPamWfZwsvgI1rLw4PRNRY6eDRtYy1d7W/lfguqrkX0/AWabqTCYiFnyX3HA==
X-Received: by 2002:a05:6e02:16c8:b0:3dd:b726:cc52 with SMTP id e9e14a558f8ab-3ddce3cd206mr20550835ab.5.1749220092612;
        Fri, 06 Jun 2025 07:28:12 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf1582dfsm4388395ab.23.2025.06.06.07.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 07:28:12 -0700 (PDT)
Message-ID: <f6ae27ea-03b7-4fe9-bb6e-15b988f2a6b8@kernel.dk>
Date: Fri, 6 Jun 2025 08:28:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 2/5] io_uring/bpf: add stubs for bpf struct_ops
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1749214572.git.asml.silence@gmail.com>
 <e2cd83fa47ed6e7e6c4e9207e66204e97371a37c.1749214572.git.asml.silence@gmail.com>
 <783d14e8-0627-492d-b06f-f0adee2064d6@kernel.dk>
Content-Language: en-US
In-Reply-To: <783d14e8-0627-492d-b06f-f0adee2064d6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 8:25 AM, Jens Axboe wrote:
> On 6/6/25 7:57 AM, Pavel Begunkov wrote:
>> diff --git a/io_uring/bpf.h b/io_uring/bpf.h
>> new file mode 100644
>> index 000000000000..a61c489d306b
>> --- /dev/null
>> +++ b/io_uring/bpf.h
>> @@ -0,0 +1,26 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#ifndef IOU_BPF_H
>> +#define IOU_BPF_H
>> +
>> +#include <linux/io_uring_types.h>
>> +#include <linux/bpf.h>
>> +
>> +#include "io_uring.h"
>> +
>> +struct io_uring_ops {
>> +};
>> +
>> +static inline bool io_bpf_attached(struct io_ring_ctx *ctx)
>> +{
>> +	return IS_ENABLED(CONFIG_BPF) && ctx->bpf_ops != NULL;
>> +}
>> +
>> +#ifdef CONFIG_BPF
>> +void io_unregister_bpf_ops(struct io_ring_ctx *ctx);
>> +#else
>> +static inline void io_unregister_bpf_ops(struct io_ring_ctx *ctx)
>> +{
>> +}
>> +#endif
> 
> Should be
> 
> #ifdef IO_URING_BPF
> 
> here.

CONFIG_IO_URING_BPF of course...

-- 
Jens Axboe


