Return-Path: <io-uring+bounces-6742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9198EA4407B
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEEB93BFBA8
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 13:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6695268FDB;
	Tue, 25 Feb 2025 13:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gx3WgeNN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134801EBFE6;
	Tue, 25 Feb 2025 13:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740489200; cv=none; b=gUBsbi8nkqCGm8Q9judZIQ8ohodc+eqmMLGXfXRpDBQPXOLavxmwm9xvuKw4CrjvBW5o1VAO5cnU9Z9Mu1GsBnsACh1iPe3JhD70ssB6AewT3xA3di/VI0jodS21OwOLLJhsUopdcoHyJA8MMr8r2c4HzRXF23ADS4nXcHCRkSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740489200; c=relaxed/simple;
	bh=LkcvZBBAVGIN2IfjJ9Db4YSurQjzKxThJfqQ1RPTeKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dg936M/iyjkAWqXf8fAAqlAbd7iuZNZFN4wOl5f3hKuXUn1g94y5wTtyKYvYpguBMBEiCNC4U+lziSl7Ynz9Vl3OhVd7jSgyTir75Z+d8L4ZIasbhqmt7gb7AFf5iPyBXbELGqKeLqDeutMj3spmH1Y6O9T/BZew+oqm8qByRxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gx3WgeNN; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-abb7a6ee2deso859011166b.0;
        Tue, 25 Feb 2025 05:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740489197; x=1741093997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7PBK3O3tdSRhcOkt0ha8iyCtRnojRmo1gdiyiZtDdyw=;
        b=gx3WgeNNG1PNg/0a4lVgKF7cgNn5z/rxwycQzaWXX6C8VNA4Yu0qqKur5JTtGuNwRb
         yzuAkmqz5t88Xt3Ha3Pn0/nZpNjA1DLHtJN8kLKCgx5dTBFf42weXMqsIvICWmcc/OXW
         PkxmoJ2eK2Rf6i3BbBFq9CpXByqGvj+jqQWjRrLqDMrLkoXXwfvyjX0TXYeEsZSrwn4o
         ITS2jZj2Fo/jFd/lBpr4Tl68t3zHr0X2umxe7/I6zZUhCT03SfwoVz43vR4yM7G+XYPC
         hSSxnBXmHcDfem9ZBX5HUuV6FQKwPTN16UC11dCjk1maQotsN1F2NoczAUmzSza5HbAJ
         oqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740489197; x=1741093997;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7PBK3O3tdSRhcOkt0ha8iyCtRnojRmo1gdiyiZtDdyw=;
        b=Do9G6+nsRnhJFZHHGDYTx/S56ffd+TpBJtAPjdJiWGitod5QPn7R7b58aq8t5I1obI
         PbLiT8vKgz2omXpustvfF0MEuRbWKTRpeqH4Um0FA9uHyBg2FsL2BXbA1DdkFhX5Siax
         FmkIIpb1OQrTJ/UyQBgMASyphSn9gE8JuTpSY9tx784wjcEIwoOWqf6qsfV4ApwEPWx+
         5x0orgXa187qzwubEkOqztPo5d3cbi5y6SGwA9uSfpsQMX6gQnieWQS0D8fQC/tdZPAY
         X6IbaLIfFpNBYj/8e7FuWpw2VD0IjM490NLmu2F9GMPkjdejj+AI0pavGLL1FjYvQslB
         Aa3g==
X-Forwarded-Encrypted: i=1; AJvYcCVq3LJLkje470SgRJImI25whMQS1g7W9tQBuEo8RjU/QcjyS5dE2mMfoOpQqrrzzKuVvgC4d8+pVg==@vger.kernel.org, AJvYcCWwPi+DtxPBx3RU/vjlUKzHaA+y3TWYME33o1H/tEenxAd32At7K1Ox8abOBDm6o70HIrnJ4CXeIY8d/7E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+F2yvoDIsXwCd5bJZvD04CnskU4xo1F+byTSFB04tIkD/sSGM
	GUhRUnpMc/N9id+Hysnzv1blpQ2Kf33Zc0klseP72u2JSPMAjVCt
X-Gm-Gg: ASbGncsOezzUaF7pg3ro4QAmTrj10/Wh2uc1G3TPjdzOaViBtBlVO2U4ypkK9KUcG5h
	FnrXylq4UdAQje7IkHmGv7lFlC5oLX5yn70crGWJngd1ddFB4n9mZX9SMLE/4GfG4vL6n8fFO2s
	ftip+U9JamxQXvN7J00b2Bs3PFzRysE3DTs4MMLKw5adk0wGxwkd5Bs9RgTeEMsGZDGvq0v4mhe
	o7GvvZbyL8em7+SC2ZNvN0yzkCBktddgAXe0NbVkFAjVkOIJR0AhbQiyAytx7LkqgHW3cOHIf98
	ZRyMJEi8NNRN3HAHwYSOwgNaRJUanvjBJtX/E5TD2SQcdQ/MPjXQXSFTTCc=
X-Google-Smtp-Source: AGHT+IEk/Svcb7oxFdmEELdjnsskkGG5uZYkkA9xFmFG+K5GR0VwsYCVaZ0bRM07b+Fg/bVWJQm+wQ==
X-Received: by 2002:a17:907:7254:b0:ab7:bcf9:34f with SMTP id a640c23a62f3a-abc09a4c539mr1827299866b.15.1740489197091;
        Tue, 25 Feb 2025 05:13:17 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1da2ef0sm139599966b.81.2025.02.25.05.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 05:13:16 -0800 (PST)
Message-ID: <94476efd-0565-4331-9cf4-989307c6b4ce@gmail.com>
Date: Tue, 25 Feb 2025 13:14:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 03/11] io_uring/net: reuse req->buf_index for sendzc
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-4-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224213116.3509093-4-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:31, Keith Busch wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> There is already a field in io_kiocb that can store a registered buffer
> index, use that instead of stashing the value into struct io_sr_msg.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/net.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 173546415ed17..fa35a6b58d472 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -76,7 +76,6 @@ struct io_sr_msg {
>   	u16				flags;
>   	/* initialised and used only by !msg send variants */
>   	u16				buf_group;
> -	u16				buf_index;
>   	bool				retry;
>   	void __user			*msg_control;
>   	/* used only for send zerocopy */
> @@ -1371,7 +1370,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   
>   	zc->len = READ_ONCE(sqe->len);
>   	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCOPY;
> -	zc->buf_index = READ_ONCE(sqe->buf_index);
> +	req->buf_index = READ_ONCE(sqe->buf_index);
>   	if (zc->msg_flags & MSG_DONTWAIT)
>   		req->flags |= REQ_F_NOWAIT;
>   
> @@ -1447,7 +1446,7 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
>   
>   		ret = -EFAULT;
>   		io_ring_submit_lock(ctx, issue_flags);
> -		node = io_rsrc_node_lookup(&ctx->buf_table, sr->buf_index);
> +		node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
>   		if (node) {
>   			io_req_assign_buf_node(sr->notif, node);
>   			ret = 0;

-- 
Pavel Begunkov


