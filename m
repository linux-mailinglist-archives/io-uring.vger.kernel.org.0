Return-Path: <io-uring+bounces-13346-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KO8HDvT9BmoeqgIAu9opvQ
	(envelope-from <io-uring+bounces-13346-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 13:05:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 36EEF54E054
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 13:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C2F9E31BD8C3
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 10:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78383D1AA0;
	Fri, 15 May 2026 10:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bL/Ss4/f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF253D0BEC
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 10:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840787; cv=none; b=KMy9igobdRHbIYYKqHmYakdMpQ168ZKSf6xix6SHNtpCE7R2/mk+Mnn0DW/2SHWZ84OmATTX9CzXnKWp9qHOsV9lXlEOvegtxMTy0O2Nn2vFbhChluVk8hJPhvmR7d84w0ac/9qXJGZxVGsKVvoYf7MjaVONf+HaBzvcLP+KbNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840787; c=relaxed/simple;
	bh=n6/8XoyOcyWPTIe28ELVeszjm9hAAv6mm4s2tszqSTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mu4a/mEmCRo8OuYRdSWjoJq0DvPVKGDhOi2Wts7xePkCW0hEq04fFltwSYiNPTrkhVf4Rrkcvx8EBz/8RyW3PVjT9nsnhWZ6bG8ut5jGvzREYBEpgNfowIGQpONdlCMEcs7NFU+RtJvEwXwiVhs5e0GOPTQhC/yrf1JhI8hPAA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bL/Ss4/f; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48d102471a4so88166345e9.2
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 03:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778840784; x=1779445584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m8javZePBSomMzDxRk4JOXFkifBGHMbX/5UYzJMP8uo=;
        b=bL/Ss4/fi2wuAEq6gu8KB/BY6SkHIqMeOlOpNGxCJywHG4CY04waiCNaePT+VfEAbf
         syeVpHDuy4pRy/UvU3OLclME0o0jkab8irQLYXWcIWcPguieJhmIpCFdzuzAMz2kxnoe
         6HOVNSdHcK8PluZorhVtshQZC0HB0J9XWKb/8+YVbfI5+pJ4pFH1DAc6E4ouxbdSg8Nc
         HvEJbMBivEOhkf3NNiIq0BxHVHG7ksdIyfbkiw3MNptlldqgEe7robZ+kdo4W7pwGI5b
         4apCGRBY74bhYAUsBtLV0c77pYjCDOeCUj7Bn8SJOqzlut/qAbHkRpWXPlxdmIeArN9C
         KWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778840784; x=1779445584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m8javZePBSomMzDxRk4JOXFkifBGHMbX/5UYzJMP8uo=;
        b=GBsBExxYWtoeHVuLpWJ7wt9xU7tUy5lYqMITkPrw2FdCHcB8RXTBhF6UQGlxaKoeSQ
         MKbufJXsX/JOtlvnWRhchliTd/IDJgN9JoP2fpgE+U/qQiSuLBAdG5z+KnnPCgAP5Fhx
         ACtmYdZufTj1KkcEKUQBFyFMomjk4SF5U+8otg9bNZoZ5RgVWCj2hZmhFn/0vrDrah98
         tkYzq6Yk15xUuIWF/r3iRHbm9ktn2QIGvtOyDmw/QFbQCYrCndIvC4knOJPswQZGvhWP
         3Vk0dXc+IB03q7kfxwv9sz9/s24MyqwPwy6f7wXbUnE7621SAJpE+irRHmh6cQNeVHHa
         cQAg==
X-Forwarded-Encrypted: i=1; AFNElJ86HGbd3eqfamiDT1Gt9CmSAMZa6/BbcoY/AEIu5SarhJSIwvHynijm3iFKICceTmC/bAzdBcJo/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxf/oIUDZIptSNZ5zsS6gqEYH9I/UsVMOMrGYWIMwmM3Yh4YPW
	hf3Sn9rpmUC0x6j0hWU4GsosiHU6yOwyY971JKDMMinVVXF7m638Hi0O
X-Gm-Gg: Acq92OHXZYH865Tk/N2bNtSCkUShzcysfSPwXveYBm0dsyOi2BAzpzdIIxgfgSFHed5
	XtzwTnwOKEYauVZQOyytDA/usuB/fM73joUU9HyyTtBhe1Q7bYM91ro80dofXbaPlMqcUAFhH0H
	zFjra8RrCk/nDMJvTJzHLs7CyKMEYS6ZYaHlAYM32d5quhoEno4iTEPQrpREMT7V8ry/yuvgbzm
	Cke/4GkZGrfWHRVoNkmA7TFeseZdfGVDn3i0dCbdydEXRYCkckzLlSZDmSGsQqDso538FacLKMg
	nffbk11GvraG0No/1pY0s7W3Jd6FEBj7T+5Ly+pq7sT0zJCYVCvV6+R6PyOoj+X7TlaR1oIFpko
	/GGb5h7/qAWjDCsamp2Oj8TB0F7/XdRsiigjFMe1RXO0RP9wb4IZ/isOsDzyuM8gBee6cA5pTS+
	QEd+1PaHKJPtVXf1PwELz1kLye7ujicn6Msv6Z++bxBokIDJEkm/uUjpjiI9zhEv0ItuaXnraXR
	JOYSZNt2SDglybbhsBNathKxePKh1g2FJD9HeCnxmyaLrqipZtDJp9zJVY=
X-Received: by 2002:a05:600c:2d09:b0:48f:e1ac:c96d with SMTP id 5b1f17b1804b1-48fe61f2bcemr24840585e9.20.1778840784159;
        Fri, 15 May 2026 03:26:24 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5f66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe6b60csm14137405e9.6.2026.05.15.03.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 03:26:23 -0700 (PDT)
Message-ID: <9732fdae-5e0d-4373-90a6-251d270eae16@gmail.com>
Date: Fri, 15 May 2026 11:26:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] io_uring/zcrx: notify user when out of buffers
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>,
 io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Vishwanath Seshagiri <vishs@fb.com>,
 Vishwanath Seshagiri <vishs@meta.com>
References: <20260422112522.3316660-1-cleger@meta.com>
 <20260422112522.3316660-2-cleger@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260422112522.3316660-2-cleger@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36EEF54E054
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13346-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 4/22/26 12:25, Clément Léger wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
...>   static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
>   {
>   	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
> @@ -531,6 +541,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
>   
>   	ifq->if_rxq = -1;
>   	spin_lock_init(&ifq->rq.lock);
> +	spin_lock_init(&ifq->ctx_lock);
>   	mutex_init(&ifq->pp_lock);
>   	refcount_set(&ifq->refs, 1);
>   	refcount_set(&ifq->user_refs, 1);
> @@ -585,6 +596,11 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
>   	if (ifq->dev)
>   		put_device(ifq->dev);
>   
> +	scoped_guard(spinlock_bh, &ifq->ctx_lock) {
> +		if (ifq->master_ctx)
> +			percpu_ref_put(&ifq->master_ctx->refs);
> +	}
> +

Something very odd happened here. It's not my patch but rather an edited
squash of two other patches. This particular hunk creates a circular
dependency, i.e. io_uring waits for this reference to be put down before
destroying the zcrx instance that triggers io_zcrx_ifq_free.

-- 
Pavel Begunkov


