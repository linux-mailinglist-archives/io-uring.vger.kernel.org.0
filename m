Return-Path: <io-uring+bounces-13893-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id CB5eD9DxS2rkdQEAu9opvQ
	(envelope-from <io-uring+bounces-13893-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:20:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A64D7146B5
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:19:59 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=iqijyg+d;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13893-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13893-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8AAC13020A71
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 16:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EB4431486;
	Mon,  6 Jul 2026 16:19:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F23A3845BC
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 16:19:12 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783354756; cv=none; b=DsOFWe+i6DXFRD0aDtyNpp5jpODNorgrlyf3RqxRSy/YanPRYBUqXKZ+TdfK0hxW52hN5EEqZLy547o44bDHjzih3U7Qi7ouFF+v3FMqj83Iw+bYDCG39MJZz6wtBc1fEWJpC1tE2oMASvpMcYE63gGjXOp8mOzJszoqtR8j12s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783354756; c=relaxed/simple;
	bh=ssvRO6jMnGeaRiu4x2lSzEERsO3AmmgRBP6Vs0ecJbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T7LqmxZmMVLQSBbk/HvCVFbS+JExgfnkVnIDd8IthTbcs61aGZb0crm+iznl1IujBYP7oYjpCYpmKE9qsvzEegpgDFFVNCX1kWEXSVZewWx+DIv12yzh11LlXgfIZxrZrBOHdVUylAJ1jvfaWQgBJI76KIGYwUPSAP6i/mfboPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=iqijyg+d; arc=none smtp.client-ip=209.85.167.178
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-48a0ca07c38so1982264b6e.2
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 09:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783354752; x=1783959552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OZieThL6xFbK+7WTQYnXcVxN0RWEharUP4VPdRgu1oQ=;
        b=iqijyg+dEOgyNzQuVhppekI813O5kHdn20MfFWRFKKAaED37fH+F0Egh4PBzXx8Z8k
         QEq+W8dNeJgbMUYmLYjD8XI/53aYLL+H8HRg4SFXqtcIDJjzodCSaqy9htpd/jkjGuxH
         6Ty4H3yXRUeSUYQ4jBzuHgkl6xmwMK92K5gz8trXKnh3DPOJIkCpHvZXtv7hCqg4xvh/
         9Ornv5BgTMCVUDMgHf2M2GHQu35IZDvd9VMcUeyJEQddobI5X+pMXD5nBgE8m5+db80Z
         03H8j5YR0duhJY02oPAwoDV+65MzsIU4stZfnBxw9FqyZ2WytiD6W3PafyuB4Nik5Y8M
         xeNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783354752; x=1783959552;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OZieThL6xFbK+7WTQYnXcVxN0RWEharUP4VPdRgu1oQ=;
        b=dzoE0bRALYW3jU6CC8Ishxug5YsD9jVNTylXBMnMtvDp6zLVdG0/Jj1LWXuOcyLC8o
         pb3RMJed9msgCUNf0HxjfuOPVHMnZDnX9Vwv3wBH/k6QxCcNLpHBt+fRQ1I8+Tcw3bNa
         BNSgU0pp4cOxD3U00v+SpSP4p8WIwNU10rUm26SxH9afSNxE6WzC+N+vIvt2SlsDwhmT
         EJ0D9k6SErHxkbL418UIder3E4y6Gj7N/XBIUxY+AFpCVQWi/sVK6l8ZpcfO8djsr6dr
         HYUIZ/wipOLukkKZc6OqTpKPpkAlx2/IAYiRC6udI62iyHj3eqbr9io87GEBoQu2rYTe
         GBGw==
X-Gm-Message-State: AOJu0YzSZPa0mXAEGAKkdajcsvnibRgVVHPCN3xBDdJmS64B1fHFUjZ+
	Dy2KeHVbPHgIXQFglFbfGPYg+6a56li3bPk8d/RDV7woy2uZHRc/HBFWFZ1hCsbyXSw=
X-Gm-Gg: AfdE7cnpyOamzJGOu2fQ8Fuc2spG3E7SWmdW+6oruGiJt80OkKHspTpg1kwED6sEdeZ
	YgHh2k2nBo7A6tKY0lKTrsdrpRU1dksbhRTl+VUyHVPRmlKVM6Z9h0qP6/1tyYVlxdgCviGTOjT
	6cCOEvXRXmXx60naXZjK9Wh9wxEdBcxQEpoMZgL1fhDRaWuV9r0VB25JB966eqzMMGInpjCQXeN
	753fG2z853yyO803A82ORrkQRmGlzBVnJhnORkhy9QRFQ2TchNSDSDtYW7M7zT6C5I1IeOTVXXm
	ovYKqzcwR+V2nEhh2PqwndRjbYlls+hXl79GWOxHI4BnYdWNx6E1nD93eVtKlGzCnbjO2xCPAq0
	TDUsbpw9RQNLPpRYBBARFTjJmViPrBFe1yQQoqBRXKOtI3bWrDRs+Rz3yc2Gs5ayC8/gvGXycg3
	CXXJqu+pE/UCyAunoJOf8y6YV5GIJIrsS8H6v/j2BdEl2d7SftVfecoqW4F812s3en+3M2OSk=
X-Received: by 2002:a05:6808:1910:b0:48c:3b4:2b95 with SMTP id 5614622812f47-49fddfdba4dmr935812b6e.29.1783354751608;
        Mon, 06 Jul 2026 09:19:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-49b9efa1b01sm4410359b6e.1.2026.07.06.09.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 09:19:11 -0700 (PDT)
Message-ID: <717fd2f3-6493-4dc5-ba83-c8d2af278639@kernel.dk>
Date: Mon, 6 Jul 2026 10:19:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring: fix dangling iovec after provided-buffer
 bundle grow failure
To: Hao-Yu Yang <naup96721@gmail.com>, linux-kernel@vger.kernel.org
Cc: io-uring@vger.kernel.org
References: <20260705234534.768138-1-naup96721@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260705234534.768138-1-naup96721@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13893-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:naup96721@gmail.com,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8A64D7146B5

On 7/5/26 5:45 PM, Hao-Yu Yang wrote:
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 3cd29477fff2..4055173e0c48 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -256,6 +256,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>  	struct io_uring_buf_ring *br = bl->buf_ring;
>  	struct iovec *org_iovs = arg->iovs;
>  	struct iovec *iov = arg->iovs;
> +	struct iovec *old = NULL;
>  	int nr_iovs = arg->nr_iovs;
>  	__u16 nr_avail, tail, head;
>  	struct io_uring_buf *buf;
> @@ -288,7 +289,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>  		if (unlikely(!iov))
>  			return -ENOMEM;
>  		if (arg->mode & KBUF_MODE_FREE)
> -			kfree(arg->iovs);
> +			old = arg->iovs;
>  		arg->iovs = iov;
>  		nr_iovs = nr_avail;
>  	} else if (nr_avail < nr_iovs) {
> @@ -318,6 +319,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>  		if (unlikely(!access_ok(iov->iov_base, len))) {
>  			if (arg->iovs != org_iovs)
>  				kfree(arg->iovs);
> +			/* hand the still-live cached vec back to the owner */
> +			arg->iovs = org_iovs;
>  			return -EFAULT;
>  		}
>  		iov++;
> @@ -330,6 +333,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>  		buf = io_ring_head_to_buf(br, ++head, bl->mask);
>  	} while (--nr_iovs);
>  
> +	kfree(old);
> +
>  	if (head == tail)
>  		req->flags |= REQ_F_BL_EMPTY;

Can't we just do the below, that seems a lot simpler?

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3cd29477fff2..3bb24d20c890 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -287,8 +287,6 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		iov = kmalloc_objs(struct iovec, nr_avail);
 		if (unlikely(!iov))
 			return -ENOMEM;
-		if (arg->mode & KBUF_MODE_FREE)
-			kfree(arg->iovs);
 		arg->iovs = iov;
 		nr_iovs = nr_avail;
 	} else if (nr_avail < nr_iovs) {
@@ -330,6 +328,9 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		buf = io_ring_head_to_buf(br, ++head, bl->mask);
 	} while (--nr_iovs);
 
+	if (arg->mode & KBUF_MODE_FREE)
+		kfree(org_iovs);
+
 	if (head == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 


-- 
Jens Axboe

