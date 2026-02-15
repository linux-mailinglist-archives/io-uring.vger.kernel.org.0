Return-Path: <io-uring+bounces-12219-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kNNGFGtDkmlXsgEAu9opvQ
	(envelope-from <io-uring+bounces-12219-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:06:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B80EE13FDB3
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:06:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 641F93010252
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323D42E9757;
	Sun, 15 Feb 2026 22:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DHv8+wQj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B096223D297
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 22:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771193192; cv=none; b=Gi8DEUzrG5pTGlz0vzcP4HTLtXs0BX27s+08Nwq/P5jMsqtEhI8+tGbC/iJu9H744ZigAxm5XPxhO8JtFZ9fAwyxnyihVWju00+Su7kyMlUqpOYnVZ1Ih3UHQR6Lz1lJjbkAnu9sC3H0T/tERaxmVuGcwwZx1y04XyX5ZiHXN/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771193192; c=relaxed/simple;
	bh=U1AjVNwMu/te1d9My1Mfcw/XYWeECisqD2NJXnhTCK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pv1y+OvlBIu3EyQuRHMLh5CCF7tDoD/PHFPQjafS9YSfvcLb6gxx4z2FDMv7T+qMH/kdulwOewqmQ0wfJeFQDsTiFjO1yiG8Ry1d4XfY+U29n/p5oLWGOYs9vr/XFDKJhC6DgmSOwdeygVdSCQIvnJQNZxoeYGihuGqHNowLMjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DHv8+wQj; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45f053b7b90so1738024b6e.0
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 14:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771193189; x=1771797989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GQsTkVXWNw2lGAiVrI25BUR4VE82mzfjXec+uQAYTEc=;
        b=DHv8+wQjKpG2B5M5TSYIfiCUFp3mFy6NE/24AuKH6GaWWLg2gX/RCeNWEopsbcLXqI
         JRZl/ehiacYrzekwpoaTuxK30ytRGB/Ph76U+FpF0tJdvAWN2OBlL8c000n/UEs7rVq/
         JCa+0KMj4paYKRVqchfEptVirETG5Fha9eH49CBjpf7tHXRJ1h/Hlx87aRc4+XkNBg0O
         zFyVVjneH9T2tRbGf2qXTwUtlwOXILUQUJ/8m0LnfdHm4KOEbB0j79ZhVh8QxbCf5OdK
         aeXJhIo+dh0+pXBhUmnHM6fzcfB8/tu591bAW3K8P2F9nCwRJKDmJmMwiWDTgoT0T52T
         gv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771193189; x=1771797989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GQsTkVXWNw2lGAiVrI25BUR4VE82mzfjXec+uQAYTEc=;
        b=OKlYXIk8a6Fh5iqezWTtp4FB6x9Jdpj/DqA3nASSDB+TMtesAKjCpP+SmyGL8nFj9R
         SrIyy4Jkz4rRJJIHzHULxdFanKoNX32zEi1PVJLhKdg/sduwfbhCtSGT33ji6ZxvmdRz
         kzhIL3ycOXkIif4oI/OWvy13NwV1JxusTDkwFVC0Y2sW/CbziHOTj9zKoaBglqq3nZEs
         fbyx2kgW6h6QC5e2BtNes+XERDvTjOCPcWjqEaSk54QBHE9371cP1VPr2STJdRylFCMW
         xAkF3pgIuwnvdiIJsYWa4+5kNIb/KGMLBBQCnq8A54uJF8huhiq3sEEh+geoVT+nFmRk
         KVFA==
X-Forwarded-Encrypted: i=1; AJvYcCXGK/qsVxf1GnThUN0GkhPBWYXd2omr2fLMC3jphiTnRdXBhF7NG0efn+Y4pAbKCHfQRNp+0fgyzw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvqr1k+b54TM/P9rMUhr17Ogp/vEfMCByRMXAGIJ4gphrw+8Sc
	pKCT1svVsklbZNbmXSJOtJ85HQv81XDfVV291+kpPvc0WkHZiM/MAVD+GBUt9wI+R20=
X-Gm-Gg: AZuq6aJo5waySER6v/sSV4nRYgmANLBto3G8W1pPR9GYfPCvWbTnLQylcLm3+xyA74T
	/TF1JDJEX2p76fNxLGoxRuDBLONx7ZvzzWHDLMR+nC8+RxREDUbkKmQdM70JDnQiy2fIwYC3f52
	jCr1veyby6He6QtTx24NlT6XRZOdfycdy4+89RmeLtxpgl24l795AnEEeVeB8I3gAF5TgIys4gb
	9IFivK11pGVaYsjc6qnE81ozCbUHsclKeti8PQwo5jsVxHIlLgtOYnzDDEuNzzinWtOPveyqvgs
	8Vb5jdQgXcmfmIQL+C0NXJPtZ8vVbw3huzDiRLZQBB1J3mLYTqkNrCpTv5DJeTJQKdCRhkL2pH5
	gUVU11i4yOHYmqHp8UCRJPTu6DCyzlM43v55M9d3A+PmKll3iBEOQ+s0GRS1ZUlfzIqefEMUyP0
	rnmA3aQfOsSvUBOS9EeLWhQdLKb7wgyOsQDfeH1Nr3mDkyGW33h0Ne4M9K1dd9jJ/SZioYzpvvO
	CgmrI0rGQ==
X-Received: by 2002:a05:6808:181d:b0:45e:e1e7:625d with SMTP id 5614622812f47-4639f235c46mr4158734b6e.54.1771193189584;
        Sun, 15 Feb 2026 14:06:29 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-463c07225a6sm3149003b6e.18.2026.02.15.14.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 14:06:28 -0800 (PST)
Message-ID: <b9c6eea4-cc66-43ae-bf87-907b35db9c8e@kernel.dk>
Date: Sun, 15 Feb 2026 15:06:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.0] io_uring/query: return support for custom rx
 page size
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <2e8280467c93ead0c61ed3d68c036d6a0474bb78.1771188227.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2e8280467c93ead0c61ed3d68c036d6a0474bb78.1771188227.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12219-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B80EE13FDB3
X-Rspamd-Action: no action

On 2/15/26 2:34 PM, Pavel Begunkov wrote:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index fc473af6feb4..6750c383a2ab 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -1090,6 +1090,14 @@ enum zcrx_reg_flags {
>  	ZCRX_REG_IMPORT	= 1,
>  };
>  
> +enum zcrx_features {
> +	/*
> +	 * The user can ask for the desired rx page size by passing the
> +	 * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
> +	 */
> +	ZCRX_FEATURE_RX_PAGE_SIZE	= 1 << 0,
> +};

Well I guess one comment - supposedly ->rx_buf_len is going to be added
in the future? Because right now it's not there.

-- 
Jens Axboe

