Return-Path: <io-uring+bounces-7356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A90A78301
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 21:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 728BC3A3CBB
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 19:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C261C8610;
	Tue,  1 Apr 2025 19:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ymqlzxid"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD50149C7D
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 19:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743537571; cv=none; b=c4u+3C/tq55Cre8uHEdXQeyQe+rq71kCxcqKgVZv/tAOxr/Vkjs+VX4F4yKACSBY0aL0kM1SjbhHi4f0VQbXYEq5ewlSFkJTCQWwyLgSMtpjRYNn2tft2qRnAoTxqf2udRuJbTLWcyyJp8+4N4cgKC7Qe6GAdxUJzCjD8oUK9UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743537571; c=relaxed/simple;
	bh=xJNNSNEJoUa6nKuEOKaqM5rXjYkd1L6C00YgTJp1SuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dB8VNSXKnVErn9ZXa2uaTHuT/Gxn9DAA6zjQn4HMrjEvE8jbzAhnDbF1mt3E9Tk7LnVBQT6NlgTlLcbmMQGKp5hXAJd3J7hWqvihcHR8PMeS4XJ8sRUCtb2NoOUs0webM/J/XHfypiu5/ljgs0zJ9HvgBws0v5fw7Qmvc94g2tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ymqlzxid; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-85da5a3667bso137420339f.1
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 12:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743537566; x=1744142366; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mhCuS7ISjcPpMJ2FcsER/U7giMJ3dPgsLgM2nE9sUEc=;
        b=ymqlzxidv2yrwt3mU/crLmhrTQ9jrk7WIj6exaNsdL3KqwnFAF3kpLsB9rJIgCgalP
         KsbzC6YHNDMDahzWlnrRO8sH+kmdrCHdFk1at50vDGhEeq9OGmzvunXkRz/vRUD+uQOq
         E9gQKL/HT6EfV9UXdqMs8fMOvgRND9y1beav7gc7/1TW6RPj3A546Tu1yGqo6XWv8jAb
         HirqsYT9eiZphEcjVws9W4yXHff19P+lu54RWarNaX7sUsu3fBRViyCdx6OjQVSVyO5f
         x77HGFIek6251k/jZcIPggMNuzkHpZre4JDxFK1ffHHgZTmf1tl0yRRhiEyX1DzbuEtA
         k8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743537566; x=1744142366;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mhCuS7ISjcPpMJ2FcsER/U7giMJ3dPgsLgM2nE9sUEc=;
        b=msuqlaMW7qkGspEHVDnhmfZTnzfL6LYdp245YLIErr/iDd7h25naSnq/AncPeH0zUy
         1H2vngwT/vQoSCt3K7O7KX4PfIn4mUmI9/C8JIowmA8YkQVsfmSoBaDCAUzTTJ7vKcIC
         Du7IF+QMHwwZOTEtzwfZIF37fcTpoAwVMfIbtrA0zW1t6mQCPh/iDjPK4z9w3cTfbPpM
         rpJN8X9G+aGSZkt1rSk9CxZsD6AfOQB3asobj02pa2Aao7EkqlnPN431pproZRHvcLnS
         ZkXTaIPwH7L0sfyfaxm0lXmm5gcMU1SSui/VA+6lIK17YbRwb+XUqjcrPJNeNTJSQA79
         t7qg==
X-Forwarded-Encrypted: i=1; AJvYcCXOh13/j5LVNyrtImyI1Ab2j8n6QB4JSGOANmoTAqICMUX99yGwfE1/LEsGw+ElOnEhWouwXImeAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxexL0hwdIe+HRCskazExx5b6453wRXJKMTmxmDyHVYH3r6EXgD
	VLkcCoyEG6GmtAIBZtuZsYhyz1BdlDz+V84gLr16u24p9iVIzSI80f25aCzWObfIRrXrLbz2LoY
	n
X-Gm-Gg: ASbGncuKcdoTfbBgP+CxDuQqrT3VKfqD3T3DskkGidND8g7rrDkou/Dv/bJtyb8zW1j
	LP+GP+StdTW9iucSIvpzjUu9K05kAX8DxvdnmCXO7H0AKzoVzms1nTj59QFTsk+IeteCdrmbG8A
	OiIiBD3mK+JCra5CfWtDod4ec2kOUCqDjSjKbrVZAi1q9XaiXWHmGg8ApeeKaymV1Pc3qi/FfpK
	yOtqZYJmb7nfytiw1o6gRDYizIf4A0VwpEASkpsUwJmV+wgNLBrkIEI12dr34dnngRq7OFLZudx
	trLZFq8iD8BkImn2j1HMstWRc69vQyWjW9KhMgpkiw==
X-Google-Smtp-Source: AGHT+IGmuFub+jNPL89r/ZzNRM1WuoEij2kdTy+LK2HwzTBK2ClVQVPdUaAleOdXBb249JkHv9iQdw==
X-Received: by 2002:a05:6e02:4518:20b0:3d6:d0e1:73eb with SMTP id e9e14a558f8ab-3d6d0e175a5mr23053685ab.7.1743537565974;
        Tue, 01 Apr 2025 12:59:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f464874cadsm2543693173.100.2025.04.01.12.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 12:59:25 -0700 (PDT)
Message-ID: <3d64246c-e907-44bd-b098-a5373740347b@kernel.dk>
Date: Tue, 1 Apr 2025 13:59:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/zcrx: return early from io_zcrx_recv_skb if
 readlen is 0
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250401195355.1613813-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250401195355.1613813-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/25 1:53 PM, David Wei wrote:
> When readlen is set for a recvzc request, tcp_read_sock() will call
> io_zcrx_recv_skb() one final time with len == desc->count == 0. This is
> caused by the !desc->count check happening too late. The offset + 1 !=
> skb->len happens earlier and causes the while loop to continue.
> 
> Fix this in io_zcrx_recv_skb() instead of tcp_read_sock(). Return early
> if len is 0 i.e. the read is done.
> 
> Changes in v2:
> --------------
> * Add Fixes tag
> * Return 0 directly
> * Add comment explaining why the !len check is needed
> 
> Fixes: 6699ec9a23f8 ("io_uring/zcrx: add a read limit to recvzc requests")
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  io_uring/zcrx.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 9c95b5b6ec4e..2c8b29c745c5 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -818,6 +818,13 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>  	int ret = 0;
>  
>  	len = min_t(size_t, len, desc->count);
> +	/* __tcp_read_sock() always calls io_zcrx_recv_skb one last time, even
> +	 * if desc->count is already 0. This is caused by the if (offset + 1 !=
> +	 * skb->len) check. Return early in this case to break out of
> +	 * __tcp_read_sock().
> +	 */
> +	if (!len)
> +		return 0;
>  	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
>  		return -EAGAIN;

Bad comment format, but I can fix it up while applying. Thanks!

-- 
Jens Axboe


