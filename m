Return-Path: <io-uring+bounces-12747-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CGPDIYD3umlwdwIAu9opvQ
	(envelope-from <io-uring+bounces-12747-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 20:05:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E16112C1C5F
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 20:05:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9213D306B17C
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 19:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3313E9F73;
	Wed, 18 Mar 2026 19:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="divQgxFH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4876D21576E
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 19:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773860670; cv=none; b=u+9YvMWEP/OsAoEQuvvEXM/ln8Cd13ceZcH7fO/DFdYvgOZyOuDxwAXwKzVxJxi4qsY0ZMspSaDy4YhsPiMdBM1s0pJit/cyCaBeQHHfhowcJ6U/XANe9AH1TWQyZhg1v0kJGWOibwtt9PsMaVhpxSg0460uljk97t6mIkLayj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773860670; c=relaxed/simple;
	bh=d/tn1Ju/dVrWv+otD/IJJ49VzaLwb+j1I3QHxMmbao0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RlhDnEuZBi4XfXSyD4ly75hSdIrOl7/ukmJ/sxsbwcVI1OJ4UY3WVP6CELmed1xbNDbIy33rttMnixNY/aRV/cQ8ymYV0dmnRZPOQzNF/zVxPi9D/HbpEJvBHjLxRQpS1V1pL7zFsvERWuCtALWo7iN2AvPlPh2ZaByhferC0dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=divQgxFH; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-464ba2bb3aeso104636b6e.1
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 12:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773860667; x=1774465467; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mfyHY74T8Tt7gMVZPyTzWlpjYTltOWKyQHjEma9jUEM=;
        b=divQgxFHiwD4Wrb07Qym00p4dGvYfVsSvn5Hb81qMdHMrWTE3kXWLK+kikw7VeUEdS
         UzEhATshAVzrvDDkkCf+/ggnM7QVdEypow1fVQ2uqrTCdMuLhwX3Pcy9whnjsM+Odm0Z
         ZKZqhrLICuqMr/g7V4ZbeUq0JYfNmc1kFRktOswU0WQRgog/CO4I2UxS9XDVcKGlZiP3
         Ea0V/YNgje0JtJDAj3pHptKmT3BqESmOmte7yzo9n7cxDYxSjVwIATyzzzOtswlSm0LF
         a+TcCy5sUvlwoSoV9pXYwI3U+7XIN1mzHFSPub0qNxj44KIKhipoxx1g6+lBUlNNknVT
         95mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773860667; x=1774465467;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mfyHY74T8Tt7gMVZPyTzWlpjYTltOWKyQHjEma9jUEM=;
        b=gdbSwsf1DD6LE4psmZJisZLNx2+Nqm3EublPD3vXrpScLywWAo5LYmGhUI2Xnt1f8a
         3mzCdWK1h3jBF75rM75l2z67aViEpOCatRQg6L+vhzI4BEbE0YIcu0a96Cfu6Huh7gbu
         gtrThl/plCMA78XUL60D8Hz+TfH3nhG/kNm06Gzerecd4a+HkynMJvxqoCVUqrQAqZZT
         JOt9JeDnhQ+ikkMNzzkt3t9rR09xa8Ujzt5wqrF/H2+bwaWkrgt0z0pP35N7/BbtylM0
         FLP4mA13+ztHPkQOrc+gdfzvwpmtmVRoUWc9vVjHq8LyQNbAo7ngKbqOtaN1Pnn+qQaD
         w1hw==
X-Gm-Message-State: AOJu0YzGyAmnr/u4sr8JYU6AdBECeBK7qP9ADZKy6nEjY7oEn6Aavx4a
	RgMdYlyBEGZY4C/bTVmmsHWlOOXUFeDMueSFWkDFlybsr/BwGxZ2W3qqxhfw7NRnJ48bOdKGUJm
	KtXHW3l8=
X-Gm-Gg: ATEYQzwdrZvhv2l3p4a9Y8ikOw3HaDO6JjRtw9s2EWLpEWLBYtpzqAKghhp9DbjtM1D
	duXof+SC9V1xS3hTC/kkbVAYQwaRcMR9UJrPh93rvHRGXr2VyebwF61bprr1MJDUZqAr4bjC73E
	ZhyGlAZa89sMF0xw64KUsKnn4M46J+41KYDgbfTPmQpTtCNXRQW16oUu9EmgdKtZRSULDlTbT3V
	S3Lktcu7EZdqxfiQlZesu2CPgMadEhqX6hW+onGVP9SJqzBV5itLdBdirzmYoijqdOm9cOABPnK
	ele5mCjCPS6D5lCMnsbvFnoH4nSDU+oAfk/fk9o1C1uXvf/aOb529eZIHb73hNCnT4JkL5InMw/
	1HOOEpywJBMHqEvWmNjVlYda4E7Cnq3QmuFIWL9cBbFuMqorA/fkhm5ZtRqc/BzckZQnGqzuKn4
	4RRH+ODzKKUUpLzxAFq7P2g+eBEAVSUkp/mr89ffa1qCUCHDTqZwNaJPXxU2fY7RC3u1VqExhQv
	OFsxvHh
X-Received: by 2002:a05:6808:4f5f:b0:453:58dc:c006 with SMTP id 5614622812f47-467cd53c16dmr485940b6e.3.1773860667161;
        Wed, 18 Mar 2026 12:04:27 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467ba88efb2sm2300090b6e.3.2026.03.18.12.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 12:04:25 -0700 (PDT)
Message-ID: <8dc16ad6-f329-40de-b7f8-6bf051df3d35@kernel.dk>
Date: Wed, 18 Mar 2026 13:04:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/13] io_uring: add IORING_OP_BPF for extending
 io_uring
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Stefan Metzmacher <metze@samba.org>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12747-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,purestorage.com,samba.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.992];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: E16112C1C5F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/6/26 3:11 AM, Ming Lei wrote:
> Hello,
> 
> Add IORING_OP_BPF for extending io_uring operations, follows typical cases:
> 
> - buffer registered zero copy [1]
> 
> Also there are some RAID like ublk servers which needs to generate data
> parity in case of ublk zero copy
> 
> - extend io_uring operations from application
> 
> Easy to add one new syscall with IORING_OP_BPF
> 
> - extend 64 byte SQE
> 
> bpf map can store IO data conveniently
> 
> - communicate in IO chain
> 
> IORING_OP_BPF can be used for communicate among IOs seamlessly without requiring
> extra syscall
> 
> - pretty handy to inject error for test purpose
> 
> Any comments & feedback are welcome!

Ming, can you respin your series against the current tree?

-- 
Jens Axboe


