Return-Path: <io-uring+bounces-7393-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF76A7BFBE
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FCE01B61C8B
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 14:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F021F3D5D;
	Fri,  4 Apr 2025 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DWNL9RTk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6081F3FD3
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743777496; cv=none; b=kpJYzJ7dr7DOLpHDKLAe5pUGgA5yO55ZYyw1KkU7fuR+cgwPx8iWtLOiAmhzgX4rwuJNCIfgurNUOO3y62Y/Vpiq8rTJjNEHpx7VNIszBlUpDcgzdUc7vlPz8Cp02+KAAnTkyxH+WcaZ3qsbm6e29bBE3cNbAOvV+DWfBZN1hyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743777496; c=relaxed/simple;
	bh=w3Zcd4b7LQv7NoXLvjWziV+SjvRQEL6q9fP89YzCXyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HIFTTOeaeROxlz+Yy7vImsSZLv/jGdf9zRbK9QWirYEaE3aFYlI9RJIsmcEthGJCsUZAyxi8O9sq43HyEgO/vDduXj1UWfN9WZil47M74sBFMtoyhqsz+cxscdmdaZy6+a83I01HnKKHqUanYP2u2mFvv2Bmb9CoxBjOykOiPjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DWNL9RTk; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d45503af24so18856995ab.2
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 07:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743777491; x=1744382291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0/yAMyBSIPT+ZHxbw1ld6p9ro4e0+6cORvShCnbRowQ=;
        b=DWNL9RTkAD0NjJGgXaf0ZMpdpn/rlCL5kve8R+myDhljKUxRTnVUU1/fAZtpjHu5Tj
         1NfMAHzkkF8xZCzwNYn73vKQ2h+68OS+0ZHRxOiESU+lww8FIjEeiWDmDS0h12KOizwi
         MVSrk9ehi9W3ZPxq7VK8unmQV9iVWWbebfLrJkQrVZ9iFBjxPB8/f0lhu5EWVR3bsihv
         GGrdRzrdP/+1UE05VCDGEcDh2Img5s40ryNjDZwDWVJC1aHcH1CQsVD112IBP1TTxePd
         8372wRKsCA5o+/BWozVb/IHhEVygvHgukvLk8QoEBbA/tjPvEcwGCWAuwJRdgPlxKGbF
         3/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743777491; x=1744382291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0/yAMyBSIPT+ZHxbw1ld6p9ro4e0+6cORvShCnbRowQ=;
        b=Mn2AZ5ZN+7hSWHC2MQ/ZbocmRJ1NJXSrCoKVBEWpeilE1Tezkmgj6LuhWJIDe40Avm
         wVBw1QNOKMse0K/nw8hDnPWVBernPHKYl7XJCFnMocQYh9fVmkduBfeRPPDYQqYoMJC7
         mPDOIlZLf4CO270XzTNBAiTLiVu716mFtIN+LuF8Qftg3vaHTo6xPNZNo+S4jVGAUKX4
         gP6ecU4j/CNvDlOfo1sSQOraMyGDKhk9LOhlwjGsrdymi0XxJ4fbrfbkAfDVnkfKQBJy
         kxkeQYX1rrMHN82Fyt9mFOqtL8Xu/UcjMbW6Zn3uSWNihtb/+dTrY9zS/oJmO1Ad9vKo
         14HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWt6IZPOvoAP4AYQbcgswciMFbJQBP0feazsVR39tL+rnk467F0cx8UFnZlZAz1gl6qoD46MPlg4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi3fq3Wj2UV6i7SdQ9QbR7sZHZbAR2p4i3eHNjmwNlVFhYnRxI
	UW5tc6aLQiXGgBNjAUbJfNyEtLWWJKzKmDDu+6nKL/17bu6TaJcuQ1DMbc5vtwoEAyqCRXt+dnK
	A
X-Gm-Gg: ASbGncv92d+3dUOmko/1+jGjRvZdXPvgsjqhQCIhShJ5qvbsKUsipA3JrusmJ4LC1pL
	lEOr4ItH8blCzNJ5692rez5u5ysF3gm7h4NK5bme9mfrEJZdDH+xwbx0fDpQqQsDswQynKFkHJe
	B1UoyNhYnCYs2Bdqq3a4fhv0qgggxcttuDpi0uyQjNFkpNNsBT1ohududnBiQ+D82un4Pe4+195
	3wvOw9CK47UumOYnYVfyVtGO1Ujt29O79ZL1rZzWLpx35yTnwfPCkGuTFXa2v3jtETKa/0XKLxA
	iFmUFxH8niZ9iZB5PLqyqGSH8FcCECHv+vOVDxqV
X-Google-Smtp-Source: AGHT+IHbc5GYTT6znvNG0gGtpIi85apOYYqUl7NqtuQPkJ/aCzLHbwqp3QV58iCmpuZeHLTQ9CLbiQ==
X-Received: by 2002:a05:6e02:219b:b0:3d6:d147:81c9 with SMTP id e9e14a558f8ab-3d6e3f19692mr42285755ab.12.1743777491250;
        Fri, 04 Apr 2025 07:38:11 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d6de79f24dsm8168085ab.5.2025.04.04.07.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 07:38:10 -0700 (PDT)
Message-ID: <d5192911-f98c-4b08-a507-4a1fe0100cc3@kernel.dk>
Date: Fri, 4 Apr 2025 08:38:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: fix typo in io_uring.h header
To: Jonas Bonn <jonas@norrbonn.se>, io-uring@vger.kernel.org
References: <20250404060858.539426-1-jonas@norrbonn.se>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250404060858.539426-1-jonas@norrbonn.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/4/25 12:08 AM, Jonas Bonn wrote:
> Comment incorrectly implies that flags are mutually exclusive; in
> reality, IORING_SETUP_TASKRUN_FLAG requires IORING_SETUP_COOP_TASKRUN.
> 
> Fixes: ef060ea9e4fd ("io_uring: add IORING_SETUP_TASKRUN_FLAG")
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
>  include/uapi/linux/io_uring.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index ed2beb4def3f6..e6637d693fa23 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -183,7 +183,7 @@ enum io_uring_sqe_flags_bit {
>  /*
>   * If COOP_TASKRUN is set, get notified if task work is available for
>   * running and a kernel transition would be needed to run it. This sets
> - * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
> + * IORING_SQ_TASKRUN in the sq ring flags. Not valid without COOP_TASKRUN.
>   */

IORING_SETUP_TASKRUN_FLAG is not valid if either COOP_TASKRUN or
DEFER_TASKRUN are used. It's not exclusive to COOP_TASKRUN. I do agree
the comment is currently wonky, but we should mention DEFER_TASKRUN as
well when correcting it.

-- 
Jens Axboe

