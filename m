Return-Path: <io-uring+bounces-5481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2BD79F1042
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 16:06:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A2F6163817
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 15:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632F41E22E2;
	Fri, 13 Dec 2024 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bq85RUsv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D4A1E25E8;
	Fri, 13 Dec 2024 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734102275; cv=none; b=MSysxI2qCi+r5Vpo4+eG9nOiYjzcxHiYi2R/VYNPLWYSmZ1Xjjt3yH5R2ioju6ndXNLjo7xt/9vmQX+N7MhVGxkf5h76L5R5iorYbM209c9/DqL8pm0NoiYtl+w2iaMzfj6SG32pW4sz2OPS+iZ18uP1dCF4lZFkk1YUoWK+C74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734102275; c=relaxed/simple;
	bh=yMlrH29miE1wyo6/4IW6nFiwZP5tbE0MMnG5AaauYJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TkiFk6W3yaTxbZAAC63xao1ZUPLxMtmXC2ZEhVrlNR5npdsYemaU9lgqH0lxgYYt2pathlHi2kgITgjMmFjjmdA1XBy74RSBNIEfeHXASLGh2FOedDAseAZywALMYgFXmMitQLF3Ub8Oa6HIGevo4b+lsKffdXxAHzgupWha5e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bq85RUsv; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa66ead88b3so349221066b.0;
        Fri, 13 Dec 2024 07:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734102272; x=1734707072; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pJMWaXTxiiTBFXLhsso9+ETfwCzvm5PKqO/a4uxPLXI=;
        b=bq85RUsvn+BoEfk1uD8yyUtlSGAZtDwflgmtubu3XJEs58phQZP0GsXcRSYFdLtNc3
         VsUjVjXdQlcUkuLAPTg2RXp0w01QC4M7H9yAFmmJBOO4863zLV97L3DJoOemhWfTlEJX
         We9Bv/Jw1d9ogZnK3Ts9wgRgbw6J3pEoyMXfpUzcvnHWAC2Ix/N6eY77VwRcqc/EVQhP
         v1JNNirQTXEA1G10YDRcWW1+/dzm9vr+4L01vdrP4Xoap23EwcOAT5t8dmxnRvqUH+ys
         n3JqGhtu3GEtLSNhXNXBD6jgXBihWg9ZqGF77R7ZclGirsFzHsYcjxongvRE4vLWMBEj
         fMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734102272; x=1734707072;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pJMWaXTxiiTBFXLhsso9+ETfwCzvm5PKqO/a4uxPLXI=;
        b=e9q8gP2ZtPBmOzTj/mDwybDtFlcyAKwFj+6fw990xrjsI+E+DHFkCZ/J2A6T1zOfvm
         gIm0F2j4JV4kDCzlkV3onPuzrwNaJ0EFy1V3UGRTm+JvULfmUuKJ+AJjQa9qZu2AGFhF
         w21ih0KL5AP+2EQeV6H8Pp0QhpuJUxO/DtX+8gI2ZTJb0wXfSomKm3NtxO9R50SuXHqI
         XSGYgPlnWtNEIS3lwdps/b7ZHkjanCGtVfVvw+aD0fjnihqDzVVcbtJdTgpskxTZ0jJD
         jHon3155WyDTyTuGMPhLrDhvWOg+JYP5RotScFYHb7RN4ekWGgHsCMmab9RjEgE4A1GT
         lXIQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9STf/FbfrpzTo+vU+InZuaQcnEeveK1TUvYpJhDefvwZRs3IBZdIlo522DOnGYnmOSawjL6RRYBZ1Zr/i7g==@vger.kernel.org, AJvYcCXU3JGRWhG8/lTiRmWApGiPtgi+gdjCuNOf+hx3mch/oBlDKgTiTZgd4656HLJx/gs9z5uiZ/czNw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqArhGGTyNK2QBiv3dhbTaBKUXZPi9nEL0pnO1QdLHvqefW+/b
	kvSp+CRFEGKEeJr0aOk+9fibYImp6DLtag8YeNQu7JMzyiiNLpCF5nHb5g==
X-Gm-Gg: ASbGncujvmdfZLYqHUavSFmIbWR/15YmMTpbwd2NOTj95R+yzKFrKJpmtqCEk+oIoGG
	sBaPFjZzr2uxINT5V5BPzs8I62fGFYSb+mFfBvMFmbKDrZFIWHwpugjrx2S480/KqSywNsXwaJb
	/KOzI4eBj60OMLhCy440zPunFjTeCzcYCQWbAhbFB5Lwcmr5JV5mAGbNI2gqlb0YLkrq52lhUvw
	5YxaoX30tInx8KVFRWviPmCcCjz6xcqipdC/CGU3BHX9dzj/hsM91qJKDxYjWVS+kU=
X-Google-Smtp-Source: AGHT+IFS5KzpanP8903sVa7dDVSrc/ZQmlpmZ9SmaObU3lK0uw9P8Iiaps68dZ0/sLmLwUqYX3bHdQ==
X-Received: by 2002:a17:906:4ad6:b0:aa6:aedb:6030 with SMTP id a640c23a62f3a-aab77eaf351mr272126866b.52.1734102270989;
        Fri, 13 Dec 2024 07:04:30 -0800 (PST)
Received: from [192.168.42.94] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa650ea7369sm943877466b.74.2024.12.13.07.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 07:04:30 -0800 (PST)
Message-ID: <3adcb83a-96f6-415f-9b70-b961bbd8344d@gmail.com>
Date: Fri, 13 Dec 2024 15:05:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
 <20241209-fuse-uring-for-6-10-rfc4-v8-15-d9f9f2642be3@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-15-d9f9f2642be3@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/24 14:56, Bernd Schubert wrote:
> When the fuse-server terminates while the fuse-client or kernel
> still has queued URING_CMDs, these commands retain references
> to the struct file used by the fuse connection. This prevents
> fuse_dev_release() from being invoked, resulting in a hung mount
> point.
> 
> This patch addresses the issue by making queued URING_CMDs
> cancelable, allowing fuse_dev_release() to proceed as expected
> and preventing the mount point from hanging.

io_uring bits look good

> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   fs/fuse/dev_uring.c   | 87 ++++++++++++++++++++++++++++++++++++++++++---------
>   fs/fuse/dev_uring_i.h | 12 +++++++
>   2 files changed, 85 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 8bdfb6fcfa51976cd121bee7f2e8dec1ff9aa916..be7eaf7cc569ff77f8ebdff323634b84ea0a3f63 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
...
> @@ -294,24 +302,27 @@ static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
>   /*
>    * Release a request/entry on connection tear down
>    */
> -static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
> -					 bool need_cmd_done)
> +static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
>   {
> -	/*
> -	 * fuse_request_end() might take other locks like fi->lock and
> -	 * can lead to lock ordering issues
> -	 */
> -	lockdep_assert_not_held(&ent->queue->lock);
> +	struct fuse_ring_queue *queue = ent->queue;
>   
> -	if (need_cmd_done)
> +	if (ent->need_cmd_done)
>   		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
>   				  IO_URING_F_UNLOCKED);

nit: might be better to pair all io_uring_cmd_done() with

ent->cmd = NULL;

since after the call the request is released and can't be used
by fuse anymore.

>   
>   	if (ent->fuse_req)
>   		fuse_uring_stop_fuse_req_end(ent);
>   
> -	list_del_init(&ent->list);
> -	kfree(ent);
> +	/*
> +	 * The entry must not be freed immediately, due to access of direct
> +	 * pointer access of entries through IO_URING_F_CANCEL - there is a risk
> +	 * of race between daemon termination (which triggers IO_URING_F_CANCEL
> +	 * and accesses entries without checking the list state first
> +	 */
> +	spin_lock(&queue->lock);
> +	list_move(&ent->list, &queue->ent_released);
> +	ent->state = FRRS_RELEASED;
> +	spin_unlock(&queue->lock);
...
> + * Handle IO_URING_F_CANCEL, typically should come on daemon termination.
> + *
> + * Releasing the last entry should trigger fuse_dev_release() if
> + * the daemon was terminated
> + */
> +static int fuse_uring_cancel(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	struct fuse_ring_ent *ent = fuse_uring_cmd_to_ring_ent(cmd);
> +	struct fuse_ring_queue *queue;
> +	bool need_cmd_done = false;
> +	int ret = 0;
> +
> +	/*
> +	 * direct access on ent - it must not be destructed as long as
> +	 * IO_URING_F_CANCEL might come up
> +	 */
> +	queue = ent->queue;
> +	spin_lock(&queue->lock);
> +	if (ent->state == FRRS_WAIT) {
> +		ent->state = FRRS_USERSPACE;
> +		list_move(&ent->list, &queue->ent_in_userspace);
> +		need_cmd_done = true;
> +	}
> +	spin_unlock(&queue->lock);
> +
> +	if (need_cmd_done) {
> +		io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
> +	} else {
> +		/* io-uring handles resending */
> +		ret = -EAGAIN;

FWIW, apparently io_uring ignores error codes returned from here.
It only cares if the request is removed from a list via
io_uring_cmd_done() or not.


> +	}
> +
> +	return ret;
> +}
> +
> +static void fuse_uring_prepare_cancel(struct io_uring_cmd *cmd, int issue_flags,
> +				      struct fuse_ring_ent *ring_ent)
> +{
> +	fuse_uring_cmd_set_ring_ent(cmd, ring_ent);
> +	io_uring_cmd_mark_cancelable(cmd, issue_flags);
> +}
> +


-- 
Pavel Begunkov


