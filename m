Return-Path: <io-uring+bounces-12057-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ePESFVzdhGkV6AMAu9opvQ
	(envelope-from <io-uring+bounces-12057-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 19:11:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 13EB8F65F8
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 19:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5EC85300336F
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 18:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14800305E21;
	Thu,  5 Feb 2026 18:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDCquEHO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9F13016E2
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770315098; cv=none; b=aUWiMFvDHDByJ/wFCqacoM+bebYPV0eHPeluihB07HBjTSoAn4UKj7uTpAAHB3QkeaxSG0ixos+JFNBJ9V+QJBoa8bRCSWA9Yh9R4Dvlrm6AFbMpwpJkfrZWAhDOH1LX7oPlR+BQPqNY8k9+b2VSHg664IHaMF2CvxyjhznFbTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770315098; c=relaxed/simple;
	bh=k7uC/RlL/oG5lA2iDOCd2R0GNgoqJhONAcqqZlqL6/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ur+46D1/IMRsmMDPlmejZKK+cVm8JjPy4+/4p6hWu+TI/PS2ZKwS5odsu7q+msWUVRhXoI7JwJJ+nBoeyUkhst+IaHzs2MYLQcEQ177QKsrh/6RX8YM6hZT1TghjjBWZZon3l+pNyZe1aHYjolfHew6lUkk+3P43TbVo40BAtRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JDCquEHO; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso14391265e9.0
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 10:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770315096; x=1770919896; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=al1lKt7thOK/HhKA4TW6RS6rqej/4zODtjNRFzruESg=;
        b=JDCquEHOsqifxn5OYuZjVCCKf5yLXWGu8o+gNhNWP0s0EPROT/Zeyyr7dsWjMv5WBh
         t+kQn3A76ozi0mhdNOI7AgbwUykMOeRpI7ipVkFzwZujCGm+1Hc70NO5nAp67579OAnO
         3X7GjbCyz1MoxgkkQ++uz9elfRJ5vxT0APPSZPwAsQPeQH8OsAMgMC294Pvl7lOlDoVt
         YJIs0Y7icsHuxha9FOH0ACE+RsH33RcE8ssSfeepJZjqpyY2hPVrqIIwzMPYpxRNupim
         hM4G2v+zYfs7RSnIe5fjwR0hoDlpYMFmFScmgc5GVYS8h8DkmFLEKnERB1KD8nPuD5zZ
         kqKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770315096; x=1770919896;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=al1lKt7thOK/HhKA4TW6RS6rqej/4zODtjNRFzruESg=;
        b=hpRY5Dh2/tqZ4Rc5F6+kgE4ybSiok1LSxvtnABE2kQ+/o3r5N5tGGDuFwux/X2UZI5
         LrU+l41MRI1RMdgoEMVlu1PoIbbZzXHqv1BqsRBNxSC+gVdoQkeIwQDZ9bU1l1VJ7xxX
         +qNwCZgoiMI6nVJ18i3DIN8PPET9IdnBxbShfH9VJK/MBxjsvsIrEl9l3hgrBWS9i40r
         JbabKf64ml+aW7EmdkjOE3yhCeO40y7wTAGe+TWe940fQfeFSxi9DEfQi3om53ecKoOF
         aglIsPE9Bd6vsFkN2Xo3bl1+Ux7WI8/YszmY/TkKg/6R6CwfCEZNaCfnSXlDMmHeH2MG
         8D4g==
X-Forwarded-Encrypted: i=1; AJvYcCU6pd9CBaqcKV1fiBWrVHnKv1MsgepyeUqsgCMhNohXebYGp/Sr3bHrJca2AKBXe25pRD+Tqjg2Sg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLT++smk3GHtS7vexZsapCLI5h33vT55yrHHfDw7xFrXcJsXo0
	RaY6teLH3XM5nm0mLCLI9kw9o9wjyAd3648A0SHYoTvUsqMQj8zQNHaVyZXd1A==
X-Gm-Gg: AZuq6aIdAfTgl4sUGwEhulJ+h4YZNF9ds/iWmE4s0mVvd82f6LQqoaGDjOoEsPHDdPh
	Sv47q7gFSsnoqEWDnrM2CwzmyfjOx4kj5N+hn46HryD9Wtq/cyP0v1LG4hRPhSUj/7kGADkRlsj
	YvlwQdBF7GuW0fJ+Q/6eSXxg1EnVzggJ4wpvfXal0q0vkG9qcjj2WYxmC7IBHVjVs9IBx7BsGOb
	W/LMYVejQNNoBe9oYeHfJYzQtMADzwBcVohA49kE8oUnUTOqSmDJRTpI84bedaBFkApD5+GAGVE
	pzSPDt2cpzm1gfJCewK0JBBIGC3/6lcQ/iyiLeFgrU8wpGjjhHSWxi4o4jCnxBzzSurCkGgVc3L
	qBurAdXPQk4dep427MoOGinrdGv0BCTGJv1ujq5U9clh2F2Y9mMVhxgxkGlQiP7p2j0jyearTGT
	lhzkveKh/zZGD/iiw8dHK6GbHTNigNdjzZt/Grk2fE3NYAqGel+N+1T9GljMg5oSVKFdayseKzI
	HzSug7+LtZxOW9+81avaFSC8+Lgk634ZZhKMAkdYKJg6CmGJl8cZlcxZD5mQnPFLg==
X-Received: by 2002:a05:600c:3f12:b0:477:b734:8c53 with SMTP id 5b1f17b1804b1-483201e476emr4391515e9.12.1770315096049;
        Thu, 05 Feb 2026 10:11:36 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-436180588bfsm15821493f8f.26.2026.02.05.10.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 10:11:35 -0800 (PST)
Message-ID: <1af36abc-4956-4461-9a06-50fd120c04d0@gmail.com>
Date: Thu, 5 Feb 2026 18:11:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/kbuf: fix memory leak if io_buffer_add_list
 fails
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <9f658484-0a25-49a1-ae27-d2ffa0f3132f@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9f658484-0a25-49a1-ae27-d2ffa0f3132f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12057-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 13EB8F65F8
X-Rspamd-Action: no action

On 2/5/26 15:43, Jens Axboe wrote:
> io_register_pbuf_ring() ignores the return value of io_buffer_add_list(),
> which can fail if xa_store() returns an error (e.g., -ENOMEM). When this
> happens, the function returns 0 (success) to the caller, but the
> io_buffer_list structure is neither added to the xarray nor freed.
> 
> In practice this requires failure injection to hit, hence not a real
> issue. But it should get fixed up none the less.
> 
> Fixes: ef62de3c4ad5 ("io_uring/kbuf: use region api for pbuf rings")

Looks like that patch just moved the call, and the tag should be
more like:

c7fb19428d67d ("io_uring: add support for ring mapped supplied buffers")

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 796d131107dd..67d4fe576473 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -669,8 +669,9 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
>   	bl->buf_ring = br;
>   	if (reg.flags & IOU_PBUF_RING_INC)
>   		bl->flags |= IOBL_INC;
> -	io_buffer_add_list(ctx, bl, reg.bgid);
> -	return 0;
> +	ret = io_buffer_add_list(ctx, bl, reg.bgid);
> +	if (!ret)
> +		return 0;
>   fail:
>   	io_free_region(ctx->user, &bl->region);
>   	kfree(bl);
> 

-- 
Pavel Begunkov


