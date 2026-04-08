Return-Path: <io-uring+bounces-12988-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IKjTBJRP1mm8DQgAu9opvQ
	(envelope-from <io-uring+bounces-12988-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 14:52:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D933BC691
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 14:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C41A0304CE90
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 12:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446CA3C2787;
	Wed,  8 Apr 2026 12:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="nom/Mki1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF463AC0FF
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775652569; cv=none; b=ETu1/FJQ6oQhCMo23V5TkcNWjY4fKGIxVIzFU/9MMpXC515U8nFYFaIp9iyJ3t9cHvyvZ+LNHJfiz8ZUAqYoUgGk/uuQjpOifrbWxpHUjHSDnolAUkJ66lONVAY5zzxNE3v/UFKKEmYrDo4vqUghEpQ+EqKNTdM8mRWShnoXz1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775652569; c=relaxed/simple;
	bh=r1LYepdQB9Z2Xe/tUFbjqlolgHqIMLT7ZtIKUWzmoYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l0xIdMOC73xsGD4Zd90htMTmdBQh3gZZ4ceECfdPZLDndAywbjW581z/37gBKsUvxzRRj9pBu/SNM+3baGzaR723XeIfwNXmh4DOVyKOAfFceZb/I7je7baUhdGsVwD7YwKyO4gexsqHybjqdo0sLNLgn0ioYFv0rhPs1AJ5G28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=nom/Mki1; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7dbd2a0211bso2774253a34.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 05:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775652565; x=1776257365; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qOTZRusPM0XlBluZ7lLKczfT8GqqRhM6XbgwOWUaXAI=;
        b=nom/Mki1GBJxl65xyDv6hyTZfC3EID6jvT1RaA5TrGHHBuwBOkvZ1RciEUE5zQen//
         qf6l5SLXOPB8HIV0tD5xO2Y44YmiX1eQcIhNPWDnp7llV0By5Kpg0Nqd+agZ5ovNORwC
         vM4l6faegtKeZyOsxLwvg4dfXY1ZFFpVDxsnjL9kDOWC5gFu3i0+FYTHfsmt6cH7RsdD
         3XXHL/0RhzkHzsTkhdLCAKXdH7WLo/97+PZ9PLZnPNzNk1RNk81NahG41U8Ptrd2W7xa
         hcVGt6JcZOQA+uUgDjCcJkX4kQwXEVpuw0KdzPC7Vbc4uGZp6TZtPap1Fh4ROUqsanY7
         i/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775652565; x=1776257365;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qOTZRusPM0XlBluZ7lLKczfT8GqqRhM6XbgwOWUaXAI=;
        b=TyVKL/S1isysmil//fS1ndS96XnvcE4cnQFucGqskovb6NBIsOttpbqnsYkFgejtYO
         /Hc/Xuuip8A/7VxsFcttduL4z0QqngiOX+an9ylfSZvAgnfpzvIA08zNNk48c81zt314
         X1MkOjlqkFua0ICbFRYRs8cDojSc996ZgJ+t4AjmRdp0UFHtplvAOnaMfaON7TTUuIWQ
         ZuxUudY3xHR/a7C3hAdEffAV01vGysCcOmSEb3n1hijJTdxNyBhJh+9ZALy23N+jb3NX
         b2PJkC0Fyt37c2yH7WSMMDFc27tc2UOSP0/O20yB0b3NSJjABPU7cxEoxOA8fdIzOtfA
         tL6g==
X-Forwarded-Encrypted: i=1; AJvYcCXh5hUQ7sHJMiQaKFTN2VaEGmpXrV1n73kWwWk8CYdBcjxNTTkQX+3X+KYTIdVsGRaJa42275SFMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUo4sucpCtLLCVjW21Xh+KsmhH8X0hw8BHARhZfWLjbjW9J7qo
	Cmrg6FS3/H1P1ZQ/IyEKaNT2yZBEptNAJXcV6Q0r0YCF8rKnjbTlYS4RtNIWHl9z39Y=
X-Gm-Gg: AeBDiet5YdAsBt7s3wp+opdYY8/v35PbUMbw/2N3ejnnBBlvI/iqA3KrdqVcrKwjzLm
	Ex5rFN1+3mavkcorXr2qG/6hkStd+V+s47Pa5sUniZ1jDiACVD5sA/q54rboyfXo1zXJEwvnNny
	2KD4WOjyvuMznzNajh24LtGb/Mn6GUrC7C17thRcF50IZJLVuy5Z4EepuEw2xrpx3mnKdYm1bom
	/7mnmgjr70UmX6vn2R0eoMP79IrlXJpLkyCLOqXJxrG8xIbi0LYapBk+j+L3fXcxYW+aJtPlxdh
	Gp2SY+WlE5QjIKKph3IX67ks0oXfqgpEEmsQsdpNmGv1owdBKVuXIInWyL/M8ilMf7yyBpMTkV5
	dqHnVdPPqy4Rlxdva4xUUMssUEgA2jKBqiAlMe6HguqUpxEeYTDZ7oJLD9u/6G6AkBm/RjUqvIo
	yRhkYzKsbGs79Ql0ugFnGOIedr7wgoryoUQ4fzWw57w0u4DpBrQbe81InXzdQagKUG9JktP1QHi
	bEZ2Vodjw==
X-Received: by 2002:a05:6830:64c8:b0:7d7:e844:7f4e with SMTP id 46e09a7af769-7dbb7529255mr12204898a34.22.1775652565162;
        Wed, 08 Apr 2026 05:49:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dbf2ddd6c8sm4046122a34.23.2026.04.08.05.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 05:49:24 -0700 (PDT)
Message-ID: <7850ad0e-5124-4165-be96-3c5b4af0b723@kernel.dk>
Date: Wed, 8 Apr 2026 06:49:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/rsrc: use io_cache_free for node in
 io_buffer_register_bvec error path
To: Pavel Begunkov <asml.silence@gmail.com>, KobaK <kobak@nvidia.com>
Cc: Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260408065408.2017967-1-kobak@nvidia.com>
 <20260408065408.2017967-3-kobak@nvidia.com>
 <b3ed9023-3211-4f1f-a264-e71df5ba898b@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b3ed9023-3211-4f1f-a264-e71df5ba898b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12988-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,nvidia.com];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:email,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 67D933BC691
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/8/26 2:35 AM, Pavel Begunkov wrote:
> On 4/8/26 07:54, KobaK wrote:
>> From: Koba Ko <kobak@nvidia.com>
>>
>> io_buffer_register_bvec() allocates the rsrc node via
>> io_rsrc_node_alloc() which pulls from ctx->node_cache. On imu allocation
>> failure, the node is freed with raw kfree() instead of
>> io_cache_free(&ctx->node_cache, node), bypassing the cache return path
>> and wasting a reuse opportunity. Every other error path in this file
>> correctly uses io_cache_free for nodes.
>>
>> Fixes: 27cb27b6d5ea4 ("io_uring: add support for kernel registered bvecs")
>> Signed-off-by: Koba Ko <kobak@nvidia.com>
>> ---
>>   io_uring/rsrc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 1b96ab5e98c99..6f46cf9cd13d7 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -961,7 +961,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
>>        */
>>       imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
>>       if (!imu) {
>> -        kfree(node);
>> +        io_cache_free(&ctx->node_cache, node);
> 
> Looks like it was already patched a week ago

Indeed, and main motivation was to eliminate reports like this, where
(clearly) an LLM spotted the "problem" even if there is none. Guess that
was a good move, just need it to land so that we don't need to waste
time on this again.

Nobody cares about "wasting a reuse opportunity" in an error path, any
human would recognize that.

-- 
Jens Axboe

