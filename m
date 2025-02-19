Return-Path: <io-uring+bounces-6563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B81FA3C5E4
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 18:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B418517A514
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 17:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6E6A214237;
	Wed, 19 Feb 2025 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrnMjsco"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113292144B8;
	Wed, 19 Feb 2025 17:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739985290; cv=none; b=cv88GwAzn16qcPHADjw9mwv9GZec3WzgBenqmne/HgHudELnsQZ4DPDeqaWNhoiSR4zT5R2DGPRVksnBWhDwBVc4Z3YI/pPiSrvSa6ldg7MqqfHDFa8hC1Npo3IxSXn33GZaMR2vfy7iuJlpWWhzxDwHGYKOnsr9pYpbjc1j398=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739985290; c=relaxed/simple;
	bh=GuICquce9sOsiDKX5dTIFHS1DTSt1nUspPv+g2t1pLE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uyP/dbd0ldNijOBVUCScOJKglH9XAgif3hfoUj4L78KeZrnX4oMbB6ea5Xge+a67uCQcbC8/D6cImJwZl6TTdzEB90s1xsV/nmAStgqAPqgb978uW5RszsKqAuEOBi0j3zAkBi6Q8ZXMHRvetoTfcO228bqNFFqQ/aHi5DnvQLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrnMjsco; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-439a2780b44so391855e9.1;
        Wed, 19 Feb 2025 09:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739985287; x=1740590087; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zSthPYJAUlXgKqEcib8jIMqIiH7ofla2ph9JMA88yPQ=;
        b=nrnMjscoNbnwlfYKYn3T6F51qzSmRkVaLoty3dmHtbAFBQeIWx+PonGiQtMzhJpwlK
         ctOrsxzW3Besml6ISsn7HPB7fzdfvY/X39gwkpmN3pC38/fqP7kGWDLUTUwjcfbrhhNh
         jF2tR9wSWbXXSQW51tsvplRVUib+k6YdxzKXSKcYFvoK9o6M3tMX2IFymDLRC8ZaGO3i
         1Bmd5lAwop56TfAxSYmoLeHz8Vq305IchA4WjMPbxQVTuCXt2d7kIE0Qz0JJjf2gzMTj
         tmLegX1ikSwEO7Ujd3zKhV0GGt71K61hnhfPNjpuu+87NfYN+O7mOGhC9m6DqzNvMmnQ
         EHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739985287; x=1740590087;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zSthPYJAUlXgKqEcib8jIMqIiH7ofla2ph9JMA88yPQ=;
        b=Up39mk6EH67/AzG3FcgU6RosUkqGN04mplQNXBBxK1/Wbv1hUZGadaRdWmk7Xi4BvL
         BfaCH4Uw7O51EiB+yrCgMJtMfvkMukvEVMlZOCmZtCK0FiamLc43PoM5/Fmd5WL7RKrK
         DyVfsVWa8sxasRDqLBQPJ3NPgsVEkibYymcbMScELvVYjdsNX4E8oj0P6OzGPkXgN5fZ
         eJVokatMZTfPVHOKJZbKNYTtgUPbBrS4AXZETsQejtOqxxs2GL9fRIQJFqlmk8M5wTvZ
         lrJ7+lsW9Xy0mBhY0+KoQb7hOT7YajFZ+nyzEQ2b6eTDPTksOoEPOJppsQH+qGG/gxuL
         tSFg==
X-Forwarded-Encrypted: i=1; AJvYcCV5vbBmPjjL4LmMj1lMWO13nq3c3TzbghcrLkhg6TdX3v1LQdrHC3sxgHyEKDGza/fUin3hqHFZ93kbsHs=@vger.kernel.org, AJvYcCXPyuZPZs1SPI6SSN1x4vXw4Fn5PZoNfsBm+crPUoEkzAgnCO3/3PcH7ZovDYMYvMkfZ6M6pee4Qg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxL3N04tFMdz5oAOD8m34d27SM+q7WuFGbhJ7+H+nLYBYoBYHpk
	IHVO5EZV8ftfaCtpX9xl45ZXLjAqiiHmA1RSxWF9i8x3bSYQZgQo7LGeKg==
X-Gm-Gg: ASbGnct0YLJ8rCqTRkK0Tv4pGx8Z1yxUrJWU17jrqdkiLqTxJI1riGCxVShVfoc0bev
	+ySW5Z1/nquhXizGaPpidKFOaSKcTl8cchnt0HZL5K1jLp1xSsryKTBDvvXqY13Web9xpcQkARW
	0tpwNvTrwD/x21X/USsnKDbZUUJiopCsUWuEsaeK01EpXtXhzno78TxZfPNS8hlSBKXmNk/gl0k
	nUpsX3CgFa9uNc7IBijQfbZz8HmVSvA5u3bFELwGn2VSvV4UfKnhbFVf5HkdOlpPq2wu+wluLYT
	rC0PdOTZbMPFE/eM7kPpjH8D
X-Google-Smtp-Source: AGHT+IGxYaJhLdtzKIjRy+EQIqJOPe2LCQNYW9GtJZp/f5kcwwZd4ugH131m5vL5Xc9bd8I5/+75Mw==
X-Received: by 2002:a05:600c:46cf:b0:439:88bb:d006 with SMTP id 5b1f17b1804b1-43999d77085mr42635785e9.6.1739985287020;
        Wed, 19 Feb 2025 09:14:47 -0800 (PST)
Received: from [192.168.8.100] ([148.252.145.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43999e5beebsm32634505e9.22.2025.02.19.09.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 09:14:46 -0800 (PST)
Message-ID: <2cb75ecb-32c9-4698-a735-cd63cd8b0ab0@gmail.com>
Date: Wed, 19 Feb 2025 17:15:50 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 1/5] io_uring: move fixed buffer import to issue path
From: Pavel Begunkov <asml.silence@gmail.com>
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-2-kbusch@meta.com>
 <c4a0cdb8-ac99-4a7a-9791-d2c833e45533@gmail.com>
Content-Language: en-US
In-Reply-To: <c4a0cdb8-ac99-4a7a-9791-d2c833e45533@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/19/25 16:48, Pavel Begunkov wrote:
> On 2/18/25 22:42, Keith Busch wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> Similar to the fixed file path, requests may depend on a previous one
>> to set up an index, so we need to allow linking them. The prep callback
>> happens too soon for linked commands, so the lookup needs to be deferred
>> to the issue path. Change the prep callbacks to just set the buf_index
>> and let generic io_uring code handle the fixed buffer node setup, just
>> like it already does for fixed files.
>>
>> Signed-off-by: Keith Busch <kbusch@kernel.org>
> 
> It wasn't great before, and it'd be harder to follow if we shove it
> into the issue path like that. Add additional overhead in the common
> path and that it's not super flexible, like the notification problem
> and what we need out of it for other features.
> 
> We're better to remove the lookup vs import split like below.
> Here is a branch, let's do it on top.
> 
> https://github.com/isilence/linux.git regbuf-import
> 
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index ce0a39972cce..322cf023233a 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1360,24 +1360,10 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
...
> -int io_import_fixed(int ddir, struct iov_iter *iter,
> -               struct io_mapped_ubuf *imu,
> -               u64 buf_addr, size_t len)
> +static int io_import_fixed_imu(int ddir, struct iov_iter *iter,
> +                struct io_mapped_ubuf *imu,
> +                u64 buf_addr, size_t len)
>   {
>       u64 buf_end;
>       size_t offset;
> @@ -919,6 +919,35 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>       return 0;
>   }
> 
> +static inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
> +                            unsigned issue_flags)
> +{
> +    struct io_ring_ctx *ctx = req->ctx;
> +    struct io_rsrc_node *node;
> +
> +    if (req->buf_node)

Seems it should be checking for REQ_F_BUF_NODE instead

> +        return req->buf_node;
> +
> +    io_ring_submit_lock(ctx, issue_flags);
> +    node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
> +    if (node)
> +        io_req_assign_buf_node(req, node);
> +    io_ring_submit_unlock(ctx, issue_flags);
> +    return node;
> +}

-- 
Pavel Begunkov


