Return-Path: <io-uring+bounces-5494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 257EE9F17E2
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 22:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DCE4161274
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 21:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C58518732E;
	Fri, 13 Dec 2024 21:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUV3I9mm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EDA1DA5F;
	Fri, 13 Dec 2024 21:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734124670; cv=none; b=T9/Idt7iiVfL0mLfiRMUpSR9g9lNaXd7YQBA2inKsAoylxbcE2/Jv0E6AL0Gbm+zrnCMmYBPoJQZearKMxEqUkukNsln6poJjNCii1Zt6Da8T3o9cG2DCHuCMmrqnNdJcVx1gZ1tc3o+lPiJToqd5B3t+lg1bjV4xfI1soITIwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734124670; c=relaxed/simple;
	bh=ByWggM+nBdx6gq2xFBTsHny1auAtvnYvuFpRcNXyA1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tQd3otIjRR8UbdilJIjlWq2hgI1Z5Yl6QKw/E65uePSVbAD5HR87YsQFqvLRB0zDhXUIJL+jnIlDQtIwavFPl961MNyxOgw0l9qK6pR039OkiqWzPgh72F1f29OpOAXW9I+K1nE04drry3bKAIMFcMbjew5/66J3RzcvubZnRWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PUV3I9mm; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-386329da1d9so1093387f8f.1;
        Fri, 13 Dec 2024 13:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734124667; x=1734729467; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vg91zCjx0115oENZyTJKw9zJolYBbt7DJoNxdpwvtAU=;
        b=PUV3I9mmRLxFQqGcW9ihR64oEKia8UM/n9dUD9i2nmciY5XVZklQAu+sFuWno90c2J
         mjjOVp9EiEje3J4WZ/e6aHX2XaH9vy4MADDUojzPto9OEimWJt8RauqRHHfcS3MyIHhN
         SSMeHkaXvDi0AjKnLmlZCThzMSfDmtlXt0fAC16WxOQ1lT/pFUkiTqozjwVUwOg4W0do
         29h81IoKRCDPoQoVz2+WdicI+czq9Djeg/mIh92EsYImdQIX2jiKpGZkBEjviEkvSjXw
         edVVS15taLserlGAbx76afKdXL8cPX7lcGEE4CDf4A7WrpKu3+6RlB0eDSgZ3H5K9T3Z
         Ty8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734124667; x=1734729467;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vg91zCjx0115oENZyTJKw9zJolYBbt7DJoNxdpwvtAU=;
        b=buzQhVXDpyLHROriFmHMC6S4etd8s8n9/yslYuKoKsy6bE7cP3jbxugdNAfH2hqINA
         n9+YxJR3WghWvrz6X1trCipwsRALnDEIep8w4S3doSH6jIb6mIV5j0lXO3lpivsfDAai
         ZaAc3oxIw5BCBi7N9xpLXn72jvqBzfeWpep0HqxCH3o1TwJS+BrpddcevxmICTrDieRL
         00f41uiPxH+aY90g1uQwbhM3vTSr5m+R4BLMJIgGi12PUo0WuZLeCUvviv6GD2Raoj4H
         2HAH4XbAUdsSOtCyA1DHUTnEgo7pimKSFgBwUyjXl7DNxsm8FopGV2u6j61K65RpG9We
         YUEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp57P8V4lX4TkTabX3XSko7lA9ihioqlSW2dEMp4/87GfR7JjGvHkAoaGP0suwzgGzXZlI5aC3Xg==@vger.kernel.org, AJvYcCXbot0w0WukcO8k3CvzIPqPacN9veS43Ey/xNPiiSI3G7YOfov/loPv9ylndHOo9OClC7ZBVO+j2bAvvIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YysAdn55Hu60n8uXmPkuvZ7Vy46fGS2RPoRP++FMk+RiUAvOTgO
	V+KMZ6vG5kEXFU+0k4vWF60NqsbQRQQNyzNXDkA/EK37mSp/p5Xg
X-Gm-Gg: ASbGncvkZAjRUpW5tKTqIvIxQcLLWWVJa2f/Yh1C4bKYFFK93UQIr5dcPqIsQejR68p
	LXdO7JxYe9uR/OYnimVV8Vrh1Znvw9nmEs9S51hfBL3B9fzlqCs0cbodhR9pyHWq2965p0Le5yy
	cSiP7xMfi9CDthjufUaMZ9P6lq9cFnoVd/Ite/lfdd+UZed3I4Tgcu8L7eh0LjL/M0lWACQ7QEI
	CyFjon6vVdiXvKtFP1UEL2m6Nx3OA4j8xvfCpkhYhgGR0HoiKGhhmQeRg2h6LVWQ9ym
X-Google-Smtp-Source: AGHT+IH/CdjM75BffEEu3+J2jsO9roR0UawpTpogmFwyp3WOXyBzyPrathNXzEeM9SFfy5ZSj+ADpw==
X-Received: by 2002:a05:6000:2ad:b0:385:f19f:5a8f with SMTP id ffacd0b85a97d-38880ac6108mr3406238f8f.4.1734124666626;
        Fri, 13 Dec 2024 13:17:46 -0800 (PST)
Received: from [192.168.42.175] ([148.252.147.237])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c80120dcsm578030f8f.8.2024.12.13.13.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 13:17:46 -0800 (PST)
Message-ID: <ec983a95-3e7c-46c8-b381-625fe7bd88e5@gmail.com>
Date: Fri, 13 Dec 2024 21:18:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] btrfs: don't read from userspace twice in
 btrfs_uring_encoded_read()
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20241213184444.2112559-1-maharmstone@fb.com>
 <20241213184444.2112559-3-maharmstone@fb.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241213184444.2112559-3-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 18:44, Mark Harmstone wrote:
> If we return -EAGAIN the first time because we need to block,
> btrfs_uring_encoded_read() will get called twice. Take a copy of args
> the first time, to prevent userspace from messing around with it.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
> Refactored slightly from the first version, in order to eliminate the
> need_copy variable.
> 
>   fs/btrfs/ioctl.c | 75 +++++++++++++++++++++++++++++++-----------------
>   1 file changed, 49 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index dc5faa89cdba..684c1541105e 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4882,7 +4882,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>   {
>   	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args, flags);
>   	size_t copy_end;
> -	struct btrfs_ioctl_encoded_io_args args = { 0 };
> +	struct btrfs_ioctl_encoded_io_args *args;
>   	int ret;
>   	u64 disk_bytenr, disk_io_size;
>   	struct file *file;
> @@ -4897,6 +4897,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>   	struct extent_state *cached_state = NULL;
>   	u64 start, lockend;
>   	void __user *sqe_addr;
> +	struct io_kiocb *req = cmd_to_io_kiocb(cmd);

Oh no, please don't. In general cmd implementations should never
use helpers that are not explicitly given to them in
include/linux/io_uring/*

> +	struct io_uring_cmd_data *data = req->async_data;

Just add a helper to io_uring/cmd.h,

>   
>   	if (!capable(CAP_SYS_ADMIN)) {
>   		ret = -EPERM;
...

-- 
Pavel Begunkov


