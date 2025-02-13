Return-Path: <io-uring+bounces-6403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46986A33552
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 03:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3AFE18893ED
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 02:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BA9BA2D;
	Thu, 13 Feb 2025 02:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G3+U1JaY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEABC13D53B;
	Thu, 13 Feb 2025 02:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739412717; cv=none; b=Q9ot/uqmAHqXbQIwKNF0vTxnU7t1QuOrfx1kbv7IelumyifTeTLHGDl/+eQaJq1ZWn0304wJ0k9rXQQrMCNTrsTzppRKdckDraBhbENIYGja0qKac3PwCu0lXb/JeeHAH29OdVdzpVDwrgtEazGLl+Blr+jm4hbgZVa+mKE2lx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739412717; c=relaxed/simple;
	bh=+H9LgLoRZjxEAjGDJGYN7fWN8wLxbFqAfwvrzyUEhA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AYwYqr9vMawKYvFyI6tawcq4jWawJg6AbAGcyyazYc4tKKD5fFcxrAcY2nJOksbr0TG61eWVqYe7vzyMxHVTeF5/8lie16oi9isMVnm+TYZkgstNZ6TBqAsdPLoUOt4A6QTCl8dAGQ6Xo6L/CeMPVcJmYjFX7q2jJk98V1OQJSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G3+U1JaY; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4395817a7f2so2085045e9.1;
        Wed, 12 Feb 2025 18:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739412714; x=1740017514; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=skYVDgXFqmEuUM4RgZsTMG18T1SoZZZx0KjEqqAoVBo=;
        b=G3+U1JaY/WPX8sCL5aX54DKxdAW7kdF0kf7HzpcbjPjyskAvZGwWWhDFyhYWMdXHuU
         m1DB6k7rGW1AYYCfY6c37ROTgwk7mgkrWPuyGXMpKvY2IN4Y6NU5DyMnaAN2zuiOXWXG
         jOiLokxkL5d/zymdrJ7xRmRBEOANvQ9VVnHv+ntNyW2f8BDJKSXOTxsUCiVAdSvF7NWd
         tNEaPvCrc7B9g8KXDVO+FG/EON30IRGitp5ioTRcWaz7IcDLMiyKcvp8DQ8RZOK9W3OL
         ThKfIvkuT1N6KLDWSwZ/BJXkTcNnryfgbmyXeLiwdJreLz1I0zTn10VDgIZmFwP/jOLj
         /EWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739412714; x=1740017514;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=skYVDgXFqmEuUM4RgZsTMG18T1SoZZZx0KjEqqAoVBo=;
        b=WUZAMJYbgrPZziJ1W98MZB+dUY5a1yXxBjh+Y2x94JT8x0XJyztfEsV94s4wwVfHBD
         V17F4gRZcrqWOds8GaLpsHViSrOcPRYTs0MyQk+HRSmY655bDqZBmLD9dYxx2LmUCq9a
         q7WWN3DGmQPmMUH/t+rheNbUNguEOvxD8CurWSeBIN902neZSJH0S9evSDzqCT6eHmtJ
         syl1wBGe+tteZFchVH4cSV4HJ4upCcByKl2Il1Dn+tiSljn8sweNO6ptl6So5F6C4EmM
         RC6ZBQpTy7wYMw14oS85iB67oshsBYl7c+eUiZ2+DVpFbwgttM7IQQkT/HjtU5bnOJFC
         oIZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFCOwib3qbmSvrOIiOrzd3pW/28AHvsT7VzQh9LiYs42oMLEu3ofxtHDRgckASKZ3fT86P8BxJB4dtC1o=@vger.kernel.org, AJvYcCXMJBMqwdwrK5XQsoKoRYn52kcfeJcqdzKq05OE4+wFxZGkPnde533uPfDbXoAIWG6qr2H9LDmCng==@vger.kernel.org
X-Gm-Message-State: AOJu0YzP08e01GCXtCxL5ywtFuhwu684Rf2sLiCVjTdSY+DdX3p6K1Qc
	dyhy+KwhJQ11L2EWatJ4oOmEXlIFTWLNYXWMzAN36i9dKWH78KaayuD4FA==
X-Gm-Gg: ASbGnctXBAyqS507J7irmCWJVKCtEhAm2rk3gz0Te8X5/iErtztOQNfKPC/PR/P5QC3
	UbglvMW3KKScbFnml8rqjXXSXnjwRxl3Xwd07phtnkyqHqjXUe6XGET2+/QFcW+qB+JJ8K5n5Qx
	dd+U1viQi6mf9J3s+Kt4KqUaey6a96LJOKZ7RfnZnz1mp3G2x13Jk9PDyIsDAWvcB0I5HROG02y
	HY0LY2um8GwqlND7huM/SH+K1Or3k4IlF/uElwZOoFXptflkc42hb752kpcUYI6pIdpfx3gR40c
	MPWCwYWIXFRUa+urZ/SYUj3G
X-Google-Smtp-Source: AGHT+IE42MrX9E7h5krDss9uiNGXJ9ZaV1DUzqaiUa470Szx7gqQ3N/+HT+Aww0F6Rbn6dSGon+4Aw==
X-Received: by 2002:a05:6000:154c:b0:38d:df70:23e7 with SMTP id ffacd0b85a97d-38f245035f5mr1022088f8f.31.1739412713554;
        Wed, 12 Feb 2025 18:11:53 -0800 (PST)
Received: from [192.168.8.100] ([148.252.128.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258fc7ecsm488736f8f.49.2025.02.12.18.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 18:11:51 -0800 (PST)
Message-ID: <7dae57d9-bdc8-4262-a47d-55befe2f4b73@gmail.com>
Date: Thu, 13 Feb 2025 02:12:50 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 4/6] ublk: zc register/unregister bvec
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, Keith Busch <kbusch@kernel.org>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-5-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250211005646.222452-5-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/11/25 00:56, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide new operations for the user to request mapping an active request
> to an io uring instance's buf_table. The user has to provide the index
> it wants to install the buffer.
> 
> A reference count is taken on the request to ensure it can't be
> completed while it is active in a ring's buf_table.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/block/ublk_drv.c      | 145 +++++++++++++++++++++++++---------
>   include/uapi/linux/ublk_cmd.h |   4 +
>   2 files changed, 113 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 529085181f355..ccfda7b2c24da 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -51,6 +51,9 @@
...
> +static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
> +				  struct ublk_queue *ubq, int tag,
> +				  const struct ublksrv_io_cmd *ub_cmd)
> +{
> +	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> +	struct ublk_device *ub = cmd->file->private_data;
> +	int index = (int)ub_cmd->addr;
> +	struct ublk_rq_data *data;
> +	struct request *req;
> +
> +	if (!ub)
> +		return -EPERM;
> +
> +	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
> +	if (!req)
> +		return -EINVAL;
> +
> +	data = blk_mq_rq_to_pdu(req);
> +	if (!test_and_clear_bit(UBLK_ZC_REGISTERED, &data->flags))
> +		return -EINVAL;

Why is it cleared here but not when it's auto removed?
Do you even need it? For example, take the option of not having
UBLK_U_IO_UNREGISTER_IO_BUF and doing all unregistrations the
normal io_uring way. Then you install it, and you know it'll
be released once and no protection needed.

For ublk_unregister_io_buf() it prevents multiple unregistrations,
even though io_uring would tolerate that, and I don't see
anything else meaningful going on here on the ublk side.

Btw, if you do it via ublk like this, then I agree, it's an
additional callback, though it can be made fancier in the
future. E.g. peeking at the {release,priv} and avoid flagging
above, and so on (though maybe flagging helps with ref
overflows).

All that aside, it looks fine in general. The only concern
is ublk going away before all buffers are released, but
maybe it does waits for all its requests to compelte?

> +
> +	io_buffer_unregister_bvec(ctx, index);

Please pass issue_flags into the helper and do conditional
locking inside. I understand that you rely on IO_URING_F_UNLOCKED
checks in ublk, but those are an abuse of io_uring internal
details by ublk. ublk should've never been allowed to interpret
issue_flags.

-- 
Pavel Begunkov


