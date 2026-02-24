Return-Path: <io-uring+bounces-12403-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wDWzBs/unWncSgQAu9opvQ
	(envelope-from <io-uring+bounces-12403-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 19:32:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 21BAD18B6ED
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 19:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AD030304FB92
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 18:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA102D8768;
	Tue, 24 Feb 2026 18:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f4f9p9pY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B522D46A2
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 18:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957865; cv=none; b=Z/gajQkCE1DdahpHyzTuitjejLxe7E7ukW/MevitCaFHQeb82sEsQzmQyq53CLtdvpTLp7hT9ndvAAAraZt+NBmf1GXO00LeRBD7NRAu38qU9DF5VehBiU6WxgFgqx56JGtGg/z9g9bxwi76fnGyYkGE2pdPJ7MovccwRn6aeGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957865; c=relaxed/simple;
	bh=8YbUJy+CEN9OVFY0gTXPSAMR3FFcFpNbC4rYC2pAy/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BkUtq4W2mCgYWlGw1GMOZh8HB4+XEO/62IR5LnV+deIM6wnsG4jbbV2e3usz7XgtiMxtCyG//ih7RElAl3LE1WQ7hHvYr08MJLa8oKrclNgR2v1GY6w+eP2lLTolcd2QT88fKJ8p14SVC26RC5L8JBv4g+jLjRsLGtBCb41z0iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f4f9p9pY; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4638a18efc2so3751453b6e.3
        for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 10:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771957863; x=1772562663; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xJN38yOUGRejA5rXkZTCKQdes/coHaeQyMkQUzTtAuQ=;
        b=f4f9p9pYszx1l4D53cYOjUMJDkPIxoHWZj3rEJy6456Ruri6KNO477wXSM7qKM5THj
         kgUT1f/WoL8MGSq2niisDTXHn9DMCugDqrIBZbPtISBQHHS8ZCaK0iExWXKQ1YpG5A28
         9/Uguc21vFkU0XatSPNtFFqCdWqcaULdBJQ1vbL1mDQrXpCsNAlemz9uPxvk6isFX+eC
         JB6YPNguP3Qqidit5Q90isXoWJe+i96Z7bb90C7C1xncQmve2MtLN49yZJivLYnIJtVA
         +sJuKZgWkONwlP34gv4N8Yf+lP9o2btVK/CClTH5HOT08HPvtLVI7j9UfYAGZJTgMYo7
         1LsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957863; x=1772562663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xJN38yOUGRejA5rXkZTCKQdes/coHaeQyMkQUzTtAuQ=;
        b=cxOHJrxGaJdpnBn96lUGSb4uiCPicpykCYdqMlqv5Y5tWv4WkMOefVqs+k42FZIbks
         AO5pmHy6j+shSMNczIOl9tZMaO1RtBlf2rnC7ZnO7z9+lZrn4jQfOUuCOqd9P6EIy4it
         q1DWDtkEPbGLwSSDzoiSElkctCUonppTRK8vGaEMgKQSc7D7o+3b0d1K7jhVx0T+Ihkh
         2jcPL32+rG0B2p6bQhhzigZJ8EQhkMYMT74wQ1eS1p2lzbnlVWloXc5O0HOkEkmtTJoG
         45EZLw29eKgDb9yYMZe4yc8pGp9KDl8u5tnv5ad1kE3doHOaoBp08xVoqueb3GleqqJ4
         BMoA==
X-Forwarded-Encrypted: i=1; AJvYcCWIn+wQv5qfe22ExiCOD7OJEo14FfybSQTNnlhyY6hqVog19Mykl4iJU7u2YVQ/qSPelimLWpLsrA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv/oZOuZTq20YHspI8WLdBmSI7Xga1fQcWPaIFcCvSj17z7JeO
	qvooE3FeR41IA+n6v3bwOwoCCLd+4mm/wiTfglk4c4ckLLoG0ArXAZ5RF6kMWuDb4AKZS45KX8o
	C2Rpi
X-Gm-Gg: ATEYQzxANr5VA+zVFlKje72h80vQJvVxlTCSQQraazW5pdQpgUkc4kyL/sKpF9Z9ldM
	iAZPXNforl9sYy0zKxZi93B390or3A/Guc8NyYPMvRg9CFzEZajBg3q6oeCA5S4KB0yaP0IGXOp
	RmqWcjA/VUSYUzS5Hj2C27IIU6HR7n9GZS5t3m8RfF8RNqQVOOURVleBG70rd4G4qheXllo1Ds+
	SM+TRNan9PWeEkJW13VZI3HzQh6ZYByJLyrjCs/OV+eQUGKkjkTvozDOv9AvA9DElvzn4oIV9Ec
	5lvZWZIjnf5zxgYovBIx70HIZPkEhjha5t1bVGuzs46ITmNwNLz9sEd2mAnwpHz5ocuW/wUy7dB
	ZBlu9Koh9rLbQFuXtyT466FezGeGmPjZwySkGP8k+GA95aihOTuFn9exShwsUGh4M/Acz3fYY6u
	WgAzulhPvB95EyuT3NZODljucAgbU24OalnOrSDQlNu6/mslQ3/mjmLUNnftIw9K4f0USN3EMiQ
	dc14G5HIg==
X-Received: by 2002:a05:6871:800c:b0:3ec:52d4:bd49 with SMTP id 586e51a60fabf-4157b1ccb8amr7279779fac.48.1771957862755;
        Tue, 24 Feb 2026 10:31:02 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4157d34a4b2sm11070901fac.15.2026.02.24.10.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 10:31:01 -0800 (PST)
Message-ID: <3ad0525b-6635-4d4a-af3d-92f60604da45@kernel.dk>
Date: Tue, 24 Feb 2026 11:31:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/timeout: immediate timeout arg
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1771949518.git.asml.silence@gmail.com>
 <e2382dc6580567e12b892af8bc1b5a0e3fdcf3e2.1771949518.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e2382dc6580567e12b892af8bc1b5a0e3fdcf3e2.1771949518.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12403-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 21BAD18B6ED
X-Rspamd-Action: no action

On 2/24/26 9:12 AM, Pavel Begunkov wrote:
> One the things the user has always keep in mind is that any user
> pointers they put into an SQE is not going to be read by the kernel
> until submission happens, and the user has to ensure the pointee
> stays alive until then. For example, this snippet:
> 
> void prep_timeout(struct io_uring_sqe *sqe) {
> 	struct __kernel_timespec ts = {...};
> 	prep_timeout(sqe, &ts);
> }
> 
> void submit() {
> 	sqe = get_sqe();
> 	prep_timeout(sqe);
> 	io_uring_submit();
> }
> 
> Would lead to UAF for the on stack variable ts. Instead of passing
> the timeout value as a pointer allow to store it immediately in the SQE.
> The user has to set a new flag called IORING_TIMEOUT_IMMEDIATE_ARG,
> in which case sqe->addr will be interpreted as the timeout value in ns.
> It only works with relative timeouts and rejected if set together with
> IORING_TIMEOUT_ABS out of concerns of not having enough range in u64 to
> represent a good long term API.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/uapi/linux/io_uring.h |  5 +++++
>  io_uring/timeout.c            | 11 +++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 6750c383a2ab..8f4de786e6e9 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -340,6 +340,10 @@ enum io_uring_op {
>  
>  /*
>   * sqe->timeout_flags
> + *
> + * IORING_TIMEOUT_IMMEDIATE_ARG:	If set, sqe->addr stores the timeout
> + *					value in nanoseconds instead of
> + *					pointing to a timespec.
>   */
>  #define IORING_TIMEOUT_ABS		(1U << 0)
>  #define IORING_TIMEOUT_UPDATE		(1U << 1)
> @@ -348,6 +352,7 @@ enum io_uring_op {
>  #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
>  #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
>  #define IORING_TIMEOUT_MULTISHOT	(1U << 6)
> +#define IORING_TIMEOUT_IMMEDIATE_ARG	(1U << 7)
>  #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
>  #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
>  /*
> diff --git a/io_uring/timeout.c b/io_uring/timeout.c
> index d97f67d85ea3..e051c8374c1a 100644
> --- a/io_uring/timeout.c
> +++ b/io_uring/timeout.c
> @@ -528,7 +528,8 @@ static int __io_timeout_prep(struct io_kiocb *req,
>  	flags = READ_ONCE(sqe->timeout_flags);
>  	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK |
>  		      IORING_TIMEOUT_ETIME_SUCCESS |
> -		      IORING_TIMEOUT_MULTISHOT))
> +		      IORING_TIMEOUT_MULTISHOT |
> +		      IORING_TIMEOUT_IMMEDIATE_ARG))
>  		return -EINVAL;
>  	/* more than one clock specified is invalid, obviously */
>  	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
> @@ -557,8 +558,14 @@ static int __io_timeout_prep(struct io_kiocb *req,
>  	data->req = req;
>  	data->flags = flags;
>  
> -	if (get_timespec64(&data->ts, u64_to_user_ptr(READ_ONCE(sqe->addr))))
> +	if (flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
> +		if (flags & IORING_TIMEOUT_ABS)
> +			return -EINVAL;
> +		data->ts = ns_to_timespec64(READ_ONCE(sqe->addr));
> +	} else if (get_timespec64(&data->ts,
> +				  u64_to_user_ptr(READ_ONCE(sqe->addr)))) {
>  		return -EFAULT;
> +	}
>  
>  	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
>  		return -EINVAL;

Looks good to me on the feature side, makes sense. But like the 1/2
patch, this one needs to update the remove side as well to support the
immediate arg.

-- 
Jens Axboe

