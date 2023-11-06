Return-Path: <io-uring+bounces-29-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B53E7E26D6
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28A862814B2
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 14:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51DE28DA0;
	Mon,  6 Nov 2023 14:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JY/n4hll"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9C928DA5
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 14:32:26 +0000 (UTC)
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D5991
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 06:32:25 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-357bc05f94dso2502785ab.1
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 06:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699281144; x=1699885944; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jWW3upZ1+/xhdcraGegrbgtDuCuQuyQwbzh8Cqw1Fh8=;
        b=JY/n4hllJ1eQKuw0BgPUby86yRAW67w8XUcUpSzPK8T0aomv2jWNEAIZ3W9ETjmqaT
         /FKXSox9GaoTBVrrTePd28AZu51m/m8QVB9eDeT8QnBIWkhAjV7WGFolC/Bd49q5z551
         xkgIm6EZPqlQj+mAblU7HGsyl7bidlYsHr5ypu40ThcEnPT/3Cn7cyWl1Zcua/x8zf9Y
         61hZHLP4R4qVGdaPfwCayiy7agHbeOJfEjVlqbj2HyXydK0AGAeCxBftZqqB89y+oMjO
         7yu+d4+p8mth+9d9IQtI5kp97flORmkSmcr946Y0IKj6iXXpeHCkNThkLZgKZBB3mxtA
         idjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699281144; x=1699885944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jWW3upZ1+/xhdcraGegrbgtDuCuQuyQwbzh8Cqw1Fh8=;
        b=cdo+0Z+YyTRVVl86Dlzkh/EDOh8uNuNzGfJ2t3C4sMGwioyS1R4nY7ol++iY8M3fan
         cuvPKvwRdrNOkpKdMNahMiMd6bgteh5um9Ll4gyE4lcoWuJuAQZsEJ5lKsu78tZ3ZwqL
         0IewS/kd1/CudaleM48iQrHzoWYkJhI9apOfYHzuZv0fd3kCzd3B7zvYAcikaLJh2KqK
         QNqYWRNlHHL2SMd6YuAsG4ceSAyLWQ0JVxQrz9i1IxeuyvBibuPN3lVa9W2nh63OuYIw
         435IjfJHNYVC+IUorkoIImAcoDWeaQfL6fIDcDPJuGRSl9wKynZPIxiwCcM6ZoFtDixZ
         0ryg==
X-Gm-Message-State: AOJu0YxyiyIbyKaNKx4BbeQahDxj/uj5tXPka1bfEOUrRO1uqYmxHA3V
	nqg4l8bo9yu7HvLx5yRQI8SLHQ==
X-Google-Smtp-Source: AGHT+IEqpKHh8EH0jvkngS+HnPsVQZNeKc2uIpx/0O90teiaF1xZnCFPqaC0bRyQhjSCY4lRmo53Fg==
X-Received: by 2002:a5d:9ec9:0:b0:7a5:cd6b:7581 with SMTP id a9-20020a5d9ec9000000b007a5cd6b7581mr30820496ioe.2.1699281144406;
        Mon, 06 Nov 2023 06:32:24 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t15-20020a056602180f00b0078647b08ab0sm2355842ioh.6.2023.11.06.06.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 06:32:23 -0800 (PST)
Message-ID: <d6cbb872-b1fc-4e91-96f9-46d814a94974@kernel.dk>
Date: Mon, 6 Nov 2023 07:32:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: do not allow multishot read to set addr or
 len
To: Dylan Yudaken <dyudaken@gmail.com>, io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
References: <20231105223008.125563-1-dyudaken@gmail.com>
 <20231105223008.125563-2-dyudaken@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231105223008.125563-2-dyudaken@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/23 3:30 PM, Dylan Yudaken wrote:
> For addr: this field is not used, since buffer select is forced. But by forcing
> it to be zero it leaves open future uses of the field.
> 
> len is actually usable, you could imagine that you want to receive
> multishot up to a certain length.
> However right now this is not how it is implemented, and it seems
> safer to force this to be zero.
> 
> Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
> Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
> ---
>  io_uring/rw.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 1c76de483ef6..ea86498d8769 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -111,6 +111,13 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	rw->len = READ_ONCE(sqe->len);
>  	rw->flags = READ_ONCE(sqe->rw_flags);
>  
> +	if (req->opcode == IORING_OP_READ_MULTISHOT) {
> +		if (rw->addr)
> +			return -EINVAL;
> +		if (rw->len)
> +			return -EINVAL;
> +	}

Should we just put these in io_read_mshot_prep() instead? Ala the below.
In general I think it'd be nice to have a core prep_rw, and then each
variant will have its own prep. Then we can get away from random opcode
checking in there.

I do agree with the change in general, just think we can tweak it a bit
to make it a bit cleaner.

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1c76de483ef6..635a1bf5df70 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -129,6 +129,7 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  */
 int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	int ret;
 
 	/* must be used with provided buffers */
@@ -139,6 +140,9 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(ret))
 		return ret;
 
+	if (rw->addr || rw->len)
+		return -EINVAL;
+
 	req->flags |= REQ_F_APOLL_MULTISHOT;
 	return 0;
 }

-- 
Jens Axboe


