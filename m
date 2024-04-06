Return-Path: <io-uring+bounces-1434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F7589AD0F
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 23:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9896D1C20AF7
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 21:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ABF84E1A8;
	Sat,  6 Apr 2024 21:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JsZ4Lwxy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916574EB30;
	Sat,  6 Apr 2024 21:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712439020; cv=none; b=p3VPj4qSM+GBWN1rmhitSWluexs7AR2LGj+g7mZmFNSf+rJVGyE3Jw+DExGBTS+B7y+CKZWelBWIDWF1ga2DzjMS/gSdQowXGPvbV4/W6xhCvOc2EESkcCPn9BPW94kRTtue9xGrTquA2qXik25gQxwlLeeTOc62ZhBZzwAz3Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712439020; c=relaxed/simple;
	bh=gE8QXUTcAU95JaKhAz6GjZQUEQvZOUdnKji+PWbIoNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l5b0OV4WSANOeD4rTsoIt2gPbN13kjFkYdDxj7mtaef0B5xg28bAFeT8z02RI6XICJ+vDzQp2E+3rBAPlqW9LMjpoG1a3uhSy/XBIIGezJfp6V3v+Xpup0FTzx6HXme0tKQJoR/NfbLPBGCnNfkkYGIImZ8X2yMxJ9M9N5lk/cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JsZ4Lwxy; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4162b8cb3e9so27635635e9.0;
        Sat, 06 Apr 2024 14:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712439017; x=1713043817; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wKpcpPv1lK3LzZaQcQrqOSQ11z+Fhw8LrnSVgjRyaT4=;
        b=JsZ4LwxyekUMPGLARLevaFEGBSBXzZii+B5EDqmVYasFAp/P4ax2VyX/l2+sXlnoPn
         3Ax4w6e84yRp5cwIMnaXlp5XLyiyrt+2/+ZotUOSgJ57WuiZzb/3nGjiy6/IeV4Qt1G2
         JBufr8aBYBG3N5UcG8JW2DtrXU96LuQGmMBCDV7FFJNAaSTCP6XJMUc4G8RPF3oTPqIK
         Fkd72LRjuVRPS3ddnNvssmQCdyDgspYBKDzxtfP8k9LLmLnQbT86rzNyjaf01eb29Cvt
         SPnVUiWpfjqH3WuTUGKhwfIUvfqPcOjJ/LpCv68zZrVKqBVaOQ7cjxilXOzRnb/I81hv
         Vplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712439017; x=1713043817;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wKpcpPv1lK3LzZaQcQrqOSQ11z+Fhw8LrnSVgjRyaT4=;
        b=aCT1Nyr0UyeEl/pse4FXuVXZgKFC3LfSrjb2pM+s3GOfj0J40LHIAVNoS6/ibGuKko
         q6WpyTurLiDWrTZRWM5+3EOyb1/YrTqJ85eLO5LIJjQg6o2j+Nb/zBBeeyW58lTG/wBx
         A1QuHTVcu307ua2CygsEXxTFIAmaEFFfqVG12Npeo8WUzgI3S7KlJjp9hs7Nlm3vnrsD
         0YsafGmvtzZ/lFFBGt4DOJYjloEJFs0BTfjn7nJ10mlpOoAF4cYaOgXBUEz0iNBIlTdB
         V82aPq7WePNjovn+n7xdQ847GGev7OvhQ6hgE/vmagsIXTQ4l4eBSYnna1FQbYSaDR2g
         DbnA==
X-Forwarded-Encrypted: i=1; AJvYcCW5/PNt1g4F8A+5lx0WtnCvS/Ll6GjI9Ynxmybh/TfAHkoTYyR61mh+VkX8rfXqFxI8vm6D1W4lqjfV6cdOFU4ZONHxgEcvOULYSiI=
X-Gm-Message-State: AOJu0Yy/I5hlhfaS/QgbfQCN/5RbEiNb7xqz/JjdAZ4KmAV3fWuuwZzb
	n3Lwx8Pv9e4qjV6ic9LkuY56a89cyro/CYorD+gZUzmWDb1pTXvS
X-Google-Smtp-Source: AGHT+IGAAGGfB+wLUu/cMB4L/QZLuRtzEsm3qcKB3dPyrVmxwWSWw+hxeupk4TPuD5NpErD2Tztpxw==
X-Received: by 2002:a05:600c:3c88:b0:416:2f05:41d with SMTP id bg8-20020a05600c3c8800b004162f05041dmr5153130wmb.18.1712439016884;
        Sat, 06 Apr 2024 14:30:16 -0700 (PDT)
Received: from [192.168.42.178] ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id s11-20020a05600c45cb00b004162d06768bsm8489305wmo.21.2024.04.06.14.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Apr 2024 14:30:16 -0700 (PDT)
Message-ID: <0c8f64b3-8ca7-4424-ac50-08222f6401c1@gmail.com>
Date: Sat, 6 Apr 2024 22:30:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] Read/Write with meta buffer
To: Kanchan Joshi <joshi.k@samsung.com>, martin.petersen@oracle.com,
 axboe@kernel.dk, kbusch@kernel.org, hch@lst.de
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 anuj1072538@gmail.com
References: <CGME20240322185729epcas5p350c5054b5b519a6aa9d1b35ba3709563@epcas5p3.samsung.com>
 <20240322185023.131697-1-joshi.k@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240322185023.131697-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/22/24 18:50, Kanchan Joshi wrote:
> This patchset is aimed at getting the feedback on a new io_uring
> interface that userspace can use to exchange meta buffer along with
> read/write.
> 
> Two new opcodes for that: IORING_OP_READ_META and IORING_OP_WRITE_META.
> The leftover space in the SQE is used to send meta buffer pointer
> and its length. Patch #2 for this.

I do remember there were back and forth design discussions about that
back when some other guy attempted to implement it, but have you tried
to do it not as a separate opcode?

It reads like all read/write opcodes might benefit from it, and it'd
be unfortunate to then be adding IORING_OP_READ_META_FIXED and
multiplicatively all other variants.

> The interface is supported for block direct IO. Patch #4 for this.
> Other two are prep patches.
> 
> It has been tried not to touch the hot read/write path, as much as
> possible. Performance for non-meta IO is same after the patches [2].
> There is some code in the cold path (worker-based async)
> though.
> 
> Moderately tested by modifying the fio [1] to use this interface
> (only for NVMe block devices)
> 
> [1] https://github.com/OpenMPDK/fio/tree/feat/test-meta
> 
> [2]
> without this:
> 
> taskset -c 2,5 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
> submitter=1, tid=2453, file=/dev/nvme1n1, node=-1
> submitter=0, tid=2452, file=/dev/nvme0n1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=10.02M, BW=4.89GiB/s, IOS/call=31/31
> IOPS=10.04M, BW=4.90GiB/s, IOS/call=31/31
> 
> With this:
> taskset -c 2,5 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
> submitter=1, tid=2453, file=/dev/nvme1n1, node=-1
> submitter=0, tid=2452, file=/dev/nvme0n1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=10.02M, BW=4.89GiB/s, IOS/call=31/31
> IOPS=10.04M, BW=4.90GiB/s, IOS/call=31/31
> 
> Anuj Gupta (3):
>    io_uring/rw: Get rid of flags field in struct io_rw
>    io_uring/rw: support read/write with metadata
>    block: modify bio_integrity_map_user to accept iov_iter as argument
> 
> Kanchan Joshi (1):
>    block: add support to pass the meta buffer
> 
>   block/bio-integrity.c         |  27 ++++++---
>   block/fops.c                  |   9 +++
>   block/t10-pi.c                |   6 ++
>   drivers/nvme/host/ioctl.c     |  11 +++-
>   include/linux/bio.h           |  13 +++-
>   include/linux/fs.h            |   1 +
>   include/uapi/linux/io_uring.h |   6 ++
>   io_uring/io_uring.c           |   2 +
>   io_uring/opdef.c              |  29 +++++++++
>   io_uring/rw.c                 | 108 +++++++++++++++++++++++++++++-----
>   io_uring/rw.h                 |   8 +++
>   11 files changed, 193 insertions(+), 27 deletions(-)
> 
> 
> base-commit: 6f0974eccbf78baead1735722c4f1ee3eb9422cd

-- 
Pavel Begunkov

