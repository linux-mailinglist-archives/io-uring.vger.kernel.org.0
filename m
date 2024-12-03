Return-Path: <io-uring+bounces-5190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7859E1EB6
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 15:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45FBE162CF0
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F70C1F427C;
	Tue,  3 Dec 2024 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtgwvIz5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FE71F4261;
	Tue,  3 Dec 2024 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733234943; cv=none; b=YTMpvpRCbwDj6Egqcc+OZ3zdps1E55/sz5B2Ah4ZJY5v+/NaTxRDCR3wFHOB2UvmrSpfZ9BpudNLCaUzPMlJHAo7Lfqa/Z8NFrCujoh6X0Yo2dmDyBoC/wzGalyqsooxIezS2nhK9Qd6wI1HvGau6jYQw6AuIZ7fo8jm5hpGTWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733234943; c=relaxed/simple;
	bh=S4gu4KfPFGxVbBdupOv1zTwnkwzetiWkP1iFzfNHjvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pkZHFbjcnyeCKBRD8sI6A8ESQkRYb/OB5BqFLcGAsAbDAqudSw7rpNEx1ZAzDvyY3fFfTPix9nSNt+HiZZw4G9v5drBQ0/jmZuiJmU0o53aGNPbMvIXafy14xLXAdaYY5lIRuAPOxEdnuLB5PKq1QZrARt4DCNINjf/qwldFBns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JtgwvIz5; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53dd9e853ccso5901279e87.1;
        Tue, 03 Dec 2024 06:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733234940; x=1733839740; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KDCCoUXxqVtFnrM2w00z7NKGBbRdLRY3uZHXLSTBT7g=;
        b=JtgwvIz5TQE687Q8SbYzMcTHzBUZO+rMyBjLOG58MahHfdypsRwscgN77LEBVNFOAA
         HNJbiy2PxszK0fOQ+C66StLbKkxDWM1VOcCf8VqKGT905IGW0AfsTnNPjRxv2AIQEy50
         EmCcJAuQDGWb4QU5ev+oa3rjkOFyEmQ6CCdF4AUPunG631qZkARhSmT5m/bvUsJlIGnU
         ABl7hlBQdhL4mXeO9nMGcobz+4bUbAODqWPWs0FDbEzUSp/FzMN6c9cOqVPEqk5+LZKF
         832hm20yJCjj0B4aQOPPZUakCHsTAVk2fBsj7k36BsXlVo01NoHS5vKCTjV2fYmhHTh6
         NxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733234940; x=1733839740;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KDCCoUXxqVtFnrM2w00z7NKGBbRdLRY3uZHXLSTBT7g=;
        b=p7H+wZSlizm08s7EmAUG4e1B0Aje7oWth16kqRfxNdTNn9nuaKI/k9YxQIaH5sCooR
         y3919WOy83pM5zAf6HuxNBPrAWolzvcc/aQEMWUDoZGzdvoGIcv42tenFdj3DYgwn+JS
         oQ5i9FulKRXfdaNNicKNNDF2u9DLbGt5kmYlTRjgV8sKWSrKcp7JwcH3DhUG4EdnNwbI
         24SP6EHxFecpv/S7OX9gb90PdfO7hsrMWJiDFVE4qvIwsBnfE9QHZSIWEl4EpviCsns6
         n6w+Oxkm/D2p75El9NFgbw3M8yQRIJ5ZWzXomyt1JT2XEXfUwpkEREnMOn9BQp2tLRxe
         wiGw==
X-Forwarded-Encrypted: i=1; AJvYcCV/s0bBGRfbViJEYfu76pLHZewa6ZRT5dTg+a6HkMwU4TagWac6qcOnZFiT8RFuQpOg2gOmrJ0SIA==@vger.kernel.org, AJvYcCWEEWRITe6nqFObLqJ4ClpTQf2i4QeC4WYN1pHT6fxLijBk+kJVhLAI7ZHq/qN4j+UI0Cs4u63Ge3npgpSPgw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe8yRq+amDX0J37Mgg75TcQY9zw/1oXwVdq1GtQmmNhlWlRDyp
	eUtm065Ff4lqKdIfMRnooxmKpOGzm25H+fSUtxQWQPpk+TsZKRZeEyREnQ==
X-Gm-Gg: ASbGncst4WnXjoUyxmSHGmyOv4CQ8DXeaqRGi8SKWxJPt0Karckhi6ok9VLx82K4q7z
	+Mq3LG+/pmwiUTdeHLkRG/n1yIECYfhBYUdnueRYs7wY0P7vebSSrlCH07p4gITtzAX6D7KWXIb
	fiHUQVh5FjXLmO+lk30KEh3gyU+qygHsJ19MTRqYLeEA+bWq03nSc4B4tf5Do/NsjDCHm2al4Jq
	yxSgTL8ElBgSVCes/NBu5PBijgajU9blnMSsfkcAMs3OsxkpIOH162k/9adxw==
X-Google-Smtp-Source: AGHT+IFy2THbeTfHT7j7RGlD3wBo4Z0wRl2kH2MTFF7POkT8qxme7MkNBSwHzuW9m8sggxXigKKxMg==
X-Received: by 2002:a05:6512:b14:b0:53d:ed4e:e5af with SMTP id 2adb3069b0e04-53e12a0590emr1700097e87.33.1733234939715;
        Tue, 03 Dec 2024 06:08:59 -0800 (PST)
Received: from [192.168.42.182] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa599943614sm616531866b.175.2024.12.03.06.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 06:08:59 -0800 (PST)
Message-ID: <01f65cf0-19a3-4df1-9fcc-6b0fbc18e536@gmail.com>
Date: Tue, 3 Dec 2024 14:09:55 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 11/16] fuse: {uring} Allow to queue fg requests
 through io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-11-934b3a69baca@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-11-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 13:40, Bernd Schubert wrote:
> This prepares queueing and sending foreground requests through
> io-uring.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   fs/fuse/dev.c         |   5 +-
>   fs/fuse/dev_uring.c   | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/fuse/dev_uring_i.h |   8 +++
>   fs/fuse/fuse_dev_i.h  |   5 ++
>   4 files changed, 175 insertions(+), 2 deletions(-)
> 
...
> +
> +/*
> + * This prepares and sends the ring request in fuse-uring task context.
> + * User buffers are not mapped yet - the application does not have permission
> + * to write to it - this has to be executed in ring task context.
> + */
> +static void
> +fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
> +			    unsigned int issue_flags)
> +{
> +	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
> +	struct fuse_ring_ent *ring_ent = pdu->ring_ent;
> +	struct fuse_ring_queue *queue = ring_ent->queue;
> +	int err;
> +
> +	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
> +
> +	err = fuse_uring_prepare_send(ring_ent);
> +	if (err)
> +		goto err;
> +
> +	io_uring_cmd_done(cmd, 0, 0, issue_flags);
> +
> +	spin_lock(&queue->lock);
> +	ring_ent->state = FRRS_USERSPACE;

I haven't followed the cancellation/teardown path well, but don't
you need to set FRRS_USERSPACE before io_uring_cmd_done()?

E.g. while we're just before the spin_lock above here, can
fuse_uring_stop_list_entries() find the request, see that the state
is not FRRS_USERSPACE

bool need_cmd_done = ent->state != FRRS_USERSPACE;

and call io_uring_cmd_done a second time?


-- 
Pavel Begunkov


