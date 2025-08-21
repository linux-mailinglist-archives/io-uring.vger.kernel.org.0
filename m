Return-Path: <io-uring+bounces-9157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81165B2F6F5
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 13:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F67C5E3441
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 11:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02E430DD36;
	Thu, 21 Aug 2025 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W+AwMt5+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B65B30E82A
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 11:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755776686; cv=none; b=fehLfYVnQeIR+8nbYrDPk+lFOy1vFA1cQPOAhSlN+Eikws1Cirjblxa7V2hXBaWG4Ot9N6im3yR6v5HwIKJaM/BhSKM5NkjUSEdBnDQuNWzoHq4xCLY9EYLdyxU4yt2057qxNRITuLlMtk+Wz8iUZ4Wz10jNwHUdlQLWBdYKJeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755776686; c=relaxed/simple;
	bh=HT4Mn1QWXRQRQVs+Ca0afLiODtMfE4lFoJtGD6pFCyk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gu+/OspCfawe3dFPqrMw7D/HDi8iy4oznpcUrGU8GMijf8pqY9w2S9vPMmTkj8gG/vKgk+fnAzUcW9l7XKp5iY9y4NpD7AV13VgYR9qg0Wudlgidw4sDYJPZ8SWn607fNyoASklHUUmLO7D5o2QRp7mydi5y9PZDxf7Cn1hgd4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W+AwMt5+; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76e1fc69f86so1467242b3a.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 04:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755776683; x=1756381483; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fmZvwabWo/ztYTgVE3IcUX0n8JPV0HZa8VWAYOcBsZk=;
        b=W+AwMt5+NelfNw/PdlQwFXX0PU42dzk8Sr9hy3npvSVOdjnmLW+D7Tv3vxFlm21u9C
         KNMIWW6GVjN1aEkPLHwIs1ZQPPjxojY5wsjiOhFPE1BnpXE1IXt93ztLCx2btQPPV5qx
         J1g9GeSc+m1qFkso9FqGt29QaB3kS2eBtmNEojVITl+zu3ak8Ip5Z46RgAC0msEHsnne
         NwQx/SePYoAQ5xuoHZSBKEVHWJZ21AtJTFkHfY+fb3X5VPaU3aYUxmb68L35y3gYhjz5
         gNWOkj30TnVNY5GOkzZgUx8Z0gjf+A+jcOT+pf46Yx3BbdutK0/o+UhF4YBnDppaWssQ
         J9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755776683; x=1756381483;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fmZvwabWo/ztYTgVE3IcUX0n8JPV0HZa8VWAYOcBsZk=;
        b=TFjnlOTAXnURh2nckX4wXxR7fm+P3iRXyI9NYFYUvGBjuzBlKY24gAqpMLMrz5VMaZ
         SdzJfseD1gJDwIJJn6T3xQh/PQ0f8EMbUhtQEdHtphDp0aNJOoANcLkaM/pKxrig2qGc
         +uxlFULBZcFdgKCU5fbRiK4rygdc3NSXkDWWPg6P4o9kYBm1Grpw0z4Fo0fdgMFWjy5Z
         FR1Dforv6pWlUbElFzls55SSbnpyDcDXSmFYXg23AcEpD0bCqS/m6cDQaV3/cQ3TGinj
         7TTMENutsNlMeOq/qaTmxnxcvpuNgXqaHHLqv7HHCfDvvX4PLS2ssx0nuGvZMimXodz5
         I3VA==
X-Gm-Message-State: AOJu0Yyk/j21+p6wdjPcdfN9EBNYvrHRQMy3rXFYmVwOlEl+CxlI8ftN
	PqZEQ7atYPrLDRvNPeewJy5U5wY7ofLgU2M6duMb2qtuBNbvAF76KJI45xEULznXUWpuwQemiQm
	yYoMw
X-Gm-Gg: ASbGncsuY1D9lBupXQFjWQAhQbSExgtbQfJli+xsP9DBsXa1oIBDUMJzU2wfdfL1yqG
	waPP4JgwHOv00BHiC2kSiymXwOv+NnhPD1WjVWzMW126WVWNs2AI5gzGKjBSgXeaFdtF5JY58R0
	c1mMaS+eDA9XfK3PFPdf6RNoqtraihIx/nWM0l00hlluoJ1ismqzwzC50pNiwfOowJRblwLZAdm
	drN+0sKx8bIYWbX8z79VmOKGpJXdA7mdkyE+WFACl/UKTM1pw92K5xZviDGS3FjSHVkxZOakjRR
	o+k0PpWEDsnrKWGpFe3GT0qOg/aokQ+g3i1yN4Sz4exONoD4fj99fmZKiYexJkdpXryEwdKmlCK
	qEKbpe9xX50WycYq5EQzi
X-Google-Smtp-Source: AGHT+IGOHaqwplOmzWxObKJ7b2p9gnRaE0SSvaB64XqzXxjTNw6oDSDE9OXbEi1k4lM1TjXX7Af1Xg==
X-Received: by 2002:a17:902:e54b:b0:23f:f39b:eae4 with SMTP id d9443c01a7336-246061dff20mr21473495ad.9.1755776682685;
        Thu, 21 Aug 2025 04:44:42 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2462580d76asm43965ad.127.2025.08.21.04.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 04:44:42 -0700 (PDT)
Message-ID: <e8f2f467-9e22-4cea-ae0e-0d9b6f1f1eec@kernel.dk>
Date: Thu, 21 Aug 2025 05:44:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 0/2] io_uring: uring_cmd: add multishot support with
 provided buffer
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Ming Lei <ming.lei@redhat.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20250821040210.1152145-1-ming.lei@redhat.com>
 <175577650998.615255.10824296654269741369.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <175577650998.615255.10824296654269741369.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 5:41 AM, Jens Axboe wrote:
> 
> On Thu, 21 Aug 2025 12:02:05 +0800, Ming Lei wrote:
>> This patchset adds multishot support with provided buffer, see details in
>> commit log of patch 2.
>>
>> Thanks,
>> Ming
>>
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/2] io-uring: move `struct io_br_sel` into io_uring_types.h
>       commit: 1a8ceff033519eac7bb5ab1d910e9b0340835c0d
> [2/2] io_uring: uring_cmd: add multishot support
>       commit: 55dc643dd2ad15e755a706980692a374de1bb7a8

I did notice an issue with !CONFIG_IO_URING, but figured I could just
fix it up as it should not need a respin for that. Below is the
incremental I applied while committing this.


diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 856d343b8e2a..be0e29b72669 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -117,12 +117,11 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 }
-static inline int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
-				unsigned buf_group,
-				void **buf, size_t *len,
-				unsigned int issue_flags)
+static inline struct io_br_sel
+io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd, unsigned buf_group,
+			   size_t *len, unsigned int issue_flags);
 {
-	return -EOPNOTSUPP;
+	return (struct io_br_sel) { .val = -EOPNOTSUPP };
 }
 static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 				ssize_t ret, unsigned int issue_flags)


-- 
Jens Axboe

