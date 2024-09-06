Return-Path: <io-uring+bounces-3070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44D7596F839
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 17:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7067B1C2207F
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8CA81CEAB8;
	Fri,  6 Sep 2024 15:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPZKp6Vb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B611CEAB9;
	Fri,  6 Sep 2024 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725636771; cv=none; b=Nc/as9g5km+7Qt4BUSEyBthzP/MywSdn4af6mho+NYNC8tL+Bpotkzk1QAoSBhrVbhFstetiXGlnC5GIjR+aQcIA1i2zlsnvWD3zPJKBNBX4ORErtagBCkPSfJg/Tnd5utgGKPgM9zP70GimFNUsIFU3mO5Gd/p8UswtSRqddfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725636771; c=relaxed/simple;
	bh=xeovkNnnSLmrya64GpJqoUYmgTuKAmSAgs24yKZ4C08=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=s8xiythmvuvBtPnKTefz+Wtv8JI4WxTGkvHFt5EIjQeIr/F+HNQFy5YG2nnEGozNnIGoiEggjmBVI9+qdQg4I8eGOntxowPbBtB8HRnTXfb3ETk5Xj9809eQ4lk36lbDQPPKZHi4uPMJmQZv03xqvhmFDf56LXaBN1Js3uCqeRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YPZKp6Vb; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8d0d0aea3cso47716066b.3;
        Fri, 06 Sep 2024 08:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725636768; x=1726241568; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S2+/frcoEfUGkfiJP2n/QBxPH7SGG59G5awXviqtM7w=;
        b=YPZKp6VbyeujXclRaPm99Jzezc9H0o6y+MKKjME2PPEHJmIhYPOVoOtlfbSHIQ7+yW
         WpkBcL51e/UohMJ0PGMay/VQiRDSpVGLQqEz9hf6ob7LTKLI2C93y68XYZQdTsrz4sfP
         LD8Ob7DXKN1sBLMcKpe6ozM+n53JqknWi4i8wkvABSO8UoZs2UX2uHKlR33/ETzLQLyZ
         Pf8buoMVEfCQGL3rrCMOq2WpHUA0z6OARq89iNVMFvQXi+EmMNm4W5DUuZourGxt6+EK
         lMbdPP/9e1XJkeRZ/4Jm0+9Q3wTB5efeX46Hb0L0A0hlAE2+g1oCG0sZLo3jCfX/3JwQ
         G4HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725636768; x=1726241568;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S2+/frcoEfUGkfiJP2n/QBxPH7SGG59G5awXviqtM7w=;
        b=BHbHDMWmGVNoh2uoPQFzD7wIjVZ928vfBtMGpBC2YFHsMjWtTudrVn3Px0JluSzH/z
         nYB3j06fmzqzi8f2CXOHJdPo3SvxjS9bmTmQeaQx1vijZ+R/139x0vnTsTAB114F9Pt3
         Xo2STTbvjdoiNY+nVsnZOTqo1ZTF6jJoZpV+LdGft2E+XEhymCPsPQa6On9uAN1gqdVE
         sT6HSvQuaDbyCwAsWlOhYTkBYllMxLo883qLgzQrmAq0UOUn2Z5qjsrBFuqTmb2qIT3t
         Eh7tkxRpvrJbZ1hTPO8J+nNuyKrnPV+c6xLk70KBz1IHvoMmiC02Qo+0Z5WqUqPmjhCi
         Ii1w==
X-Forwarded-Encrypted: i=1; AJvYcCUpeoOCzvGOeowbBbq6E5n72++v/Y0XwQmZBdL5DCkGtWhdDGNPHCzYZiTdOgCoe+gqsYI3mIc+AA==@vger.kernel.org, AJvYcCW0Zbcymj9iDdIjZUzxy9YiUrPbrjlzAwCIs9uvq8AJ8nYjhVD88PG9TJiZm6f4o9jheaMQPMDbSBh+v1k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqOry/wW0XxWFs7ryCh6LHKBmMdBOV2hYbhpyvca7+wcbYj3HY
	MAa9vaJftRNOiV2qAOJaa1AHvpLDhCOr/UOcVStg8TyqH3tK5cJRACAiWJn5
X-Google-Smtp-Source: AGHT+IFQIcRf/qbe5K5BhxpTsj5bwt0b3v40/2hbYV8m29zDQaIECDAmxbUhyX/QHd9QYLVnUCxAPQ==
X-Received: by 2002:a17:907:97c5:b0:a8a:6e20:761e with SMTP id a640c23a62f3a-a8a887e5fc0mr194781366b.48.1725636768422;
        Fri, 06 Sep 2024 08:32:48 -0700 (PDT)
Received: from [192.168.42.54] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a75504ed4sm221697466b.158.2024.09.06.08.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 08:32:47 -0700 (PDT)
Message-ID: <d8ac29a6-06fa-4624-b17d-36e37db11e83@gmail.com>
Date: Fri, 6 Sep 2024 16:33:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] btrfs: add io_uring interface for encoded reads
To: Mark Harmstone <maharmstone@fb.com>, io-uring@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20240823162810.1668399-1-maharmstone@fb.com>
 <20240823162810.1668399-7-maharmstone@fb.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240823162810.1668399-7-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 17:27, Mark Harmstone wrote:
> Adds an io_uring interface for asynchronous encoded reads, using the
> same interface as for the ioctl. To use this you would use an SQE opcode
> of IORING_OP_URING_CMD, the cmd_op would be BTRFS_IOC_ENCODED_READ, and
> addr would point to the userspace address of the
> btrfs_ioctl_encoded_io_args struct. As with the ioctl, you need to have
> CAP_SYS_ADMIN for this to work.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
...
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1bd4c74e8c51..e4458168c340 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -34,6 +34,7 @@
>   #include <linux/iomap.h>
>   #include <asm/unaligned.h>
>   #include <linux/fsverity.h>
> +#include <linux/io_uring/cmd.h>
>   #include "misc.h"
>   #include "ctree.h"
>   #include "disk-io.h"
> @@ -9078,7 +9079,7 @@ static ssize_t btrfs_encoded_read_inline(
>   	return ret;
>   }
>   
> -static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
> +static void btrfs_encoded_read_ioctl_endio(struct btrfs_bio *bbio)
>   {
>   	struct btrfs_encoded_read_private *priv = bbio->private;
>   
> @@ -9098,6 +9099,47 @@ static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
>   	bio_put(&bbio->bio);
>   }
>   
> +static inline struct btrfs_encoded_read_private *btrfs_uring_encoded_read_pdu(
> +		struct io_uring_cmd *cmd)
> +{
> +	return *(struct btrfs_encoded_read_private **)cmd->pdu;
> +}
> +static void btrfs_finish_uring_encoded_read(struct io_uring_cmd *cmd,
> +					    unsigned int issue_flags)
> +{
> +	struct btrfs_encoded_read_private *priv;
> +	ssize_t ret;
> +
> +	priv = btrfs_uring_encoded_read_pdu(cmd);
> +	ret = btrfs_encoded_read_finish(priv, -EIOCBQUEUED);

tw callback -> btrfs_encoded_read_finish() -> copy_to_user()

That's usually fine except cases when the task and/or io_uring are dying
and the callback executes not from a user task context. Same problem as
with fuse, we can pass a flag from io_uring into the callback telling
btrfs that it should terminate the request and not rely on mm or any
other task related pieces.


> +
> +	io_uring_cmd_done(priv->cmd, ret, 0, priv->issue_flags);
> +
> +	kfree(priv);
> +}
> +

...

-- 
Pavel Begunkov

