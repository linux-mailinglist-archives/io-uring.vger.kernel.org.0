Return-Path: <io-uring+bounces-5181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 051F19E1C6A
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0D2FB46B5E
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F541E6DFF;
	Tue,  3 Dec 2024 12:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UM1tDujk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075231E6316;
	Tue,  3 Dec 2024 12:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733228393; cv=none; b=TMbOAeORCeUGpBZa+HiuQw6Jc8LrVLVfw2QJJ+5BgNxCCJt8pYceauWCTPmNyjSMur7rVq+qWkWZZMSsh0wwoNTeU6bV2KDwhFw/W3x5kj1D0rGNxd5z6r+FFb9v/5cFfFndXN5bfAdv1ttOtB27ZdNINxuFdJKzE436J4e4Jqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733228393; c=relaxed/simple;
	bh=IGwm2D/me6pcC/vplzWFVNabGn59oNffIdZ7KonCnug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNNpaS2CAxXj3rLk8RZKNqUjZW4eskxBxnMlUphvts9Txk3aie7eVfvynmkacjTKUHIPB/yNIWsdZu1AJmO5SJhxm8MZVgZ4NLPStiwTWcvhc6y/jQPZZVv5Y0EzGMbhyTE/vdauPOnz0+B+P7JTA2RWotGHFZB1iKeElyWbBXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UM1tDujk; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9ec267b879so873606466b.2;
        Tue, 03 Dec 2024 04:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733228390; x=1733833190; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LHKSjx+nPuzyuKBU++hCtGleQ510hn/H+H8jhotbHDU=;
        b=UM1tDujk0v8g1AvuX4dNh2pt7wZtxXzyrK3iHFCXFBbNPewG9OwG01Wuj9Sy8y3qTp
         Nw8jV9xWty9KSrlcCeB8yPtI+TLgZDo3LrxOJlOVde/nrjHEOLOkDB0ZQPVA3yaBZwO+
         yKEOlZAuFfE/ija9iro0wSGnKhQxhb4ybBBtB6+B+qlUpTMnRA4tUSuEBoC7T3VQ+fUF
         DfwUh/nOIC57lZZwjv3CQSQAL8lER+XoNiPv5fXKmRwF2g8Z5kUuninlRbEE1PTO7qeS
         EqLDSJMvGRpPficacKpSjIRdriTsyC9aVCM8zUxvGIfCWjKXH2EXS9huKVA9ftsVsBS3
         eVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733228390; x=1733833190;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LHKSjx+nPuzyuKBU++hCtGleQ510hn/H+H8jhotbHDU=;
        b=kOmH0NabBWznYj72hseLp5mjaeEDDVB+vjeEuie0WZ6DsQUzZ6WcKLfditP13VJb7r
         yUjff4TbbZtvtwD5xMf+loXsTdSz3aYuvQYxG4hrE7BhV5OV2Or1j6N5R34j5SuC7B+D
         4vH4cTsyglb94lYNrrMcZjaypFGZEP63zcX1vjnPoJQIY8KOqdidWOeR6NyjxdkkfmyH
         xXhzkZL4B5fgQAfpUYfmFvLvG4sMOok2hklYdvotuxBRy8nyVLH8PjQ5dtu5U56wS8bD
         HUWc/5GuhDVBKRgHcq/DYRF9tddl3yI2Pyue746ajx9reFf/GSq210hIf3MspivuR+AK
         b/8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQMATlIUcv9hFMiQRn6DGG0WdwopTpLdwxTqArx9mXtYzzIeerPRN1mYz8YtJxVF3zzUnNDm2Ec3xyfIu1mg==@vger.kernel.org, AJvYcCVTHLkl0obIHRBV8wMYUGE0RD8tsPKYG5CL2EbR2SGdmHGy9VVlmMeoReWf9BZtrsENKlcf/XRONA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx37b/PJ5BRkxZroiehonlrq1q6a7+koUh1wU3qCujzOuHvSura
	ymQGrq3AVb5JJ+ZiORHXFdGl7u5mC1S7UpAi/tXyUh4vEeugOjnR+nbi5g==
X-Gm-Gg: ASbGncubPFZ4DTr9jqyigG6WIpgCZvz8nVsNUv5h6KvDtG1OXZ6k4CVkVBAkLXmoJjW
	0k/buPSSaQiD6VFyy7dbQfp3TeKgx8Ao97OKlE3DhHgJnm0Uo7P/p+AaM6DTu6PuyxcAdMlDTpY
	X/9eoPLcfqOoBRWD0XzQUAb6lfYJ+OOXM+eO2U8CdofkWDXsWRHzXJbSzQuLKCEWW2gadwMBxK9
	OPKqtXnkL17KCJkN0jlCCt7t+AaMrLtw2x92f+9XwjjNHRhWjfkdSS8LqQKmA==
X-Google-Smtp-Source: AGHT+IFdVM4LNUBcZPjiSK+jr1UYk3ej/eunUbyBs9o9kafkibLGcXF8tZV4DXHYH4lT62KN27puZA==
X-Received: by 2002:a17:907:7703:b0:aa5:1a75:dcd9 with SMTP id a640c23a62f3a-aa5f7f1ad71mr204358366b.48.1733228390054;
        Tue, 03 Dec 2024 04:19:50 -0800 (PST)
Received: from [192.168.42.213] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa59994b837sm604636666b.176.2024.12.03.04.19.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 04:19:49 -0800 (PST)
Message-ID: <4c80c376-a8bd-4807-8816-7c465c06f33b@gmail.com>
Date: Tue, 3 Dec 2024 12:20:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 14/16] fuse: {uring} Handle IO_URING_F_TASK_DEAD
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-14-934b3a69baca@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-14-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 13:40, Bernd Schubert wrote:
> The ring task is terminating, it not safe to still access
> its resources. Also no need for further actions.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   fs/fuse/dev_uring.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 66addb5d00c36d84a0d8d1f470f5ae10d8ee3f6f..94dc3f56d4ab604eb4b87d3b9731567e3a214b0a 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -1056,16 +1056,22 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
>   
>   	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
>   
> +	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
> +		err = -ECANCELED;
> +		goto terminating;
> +	}

Can you just fix up the patch that added the function? Patch 11, I
assume. No need to keep a bug for a couple of commits when you can
avoid introducing it in the first place.

-- 
Pavel Begunkov


