Return-Path: <io-uring+bounces-8561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E06C0AF0352
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 21:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A83CE4847D3
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 19:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306E827FB30;
	Tue,  1 Jul 2025 19:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="T9frOHSD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCB7245029
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 19:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751396762; cv=none; b=DawTtaWr+ZhfnXvh001cR1xWRnAeYLGmk0P+loA5IHH9EYxQ1WOSiBaNcXTc0uHMUBT+fftDTwTBdZiQ8Lejf4/i1sG80MxYoVFB/LrDqR8xsKod8TEZOQJNmJX6NBt+qSKF1QEU0HL6+cKhN/Mo/98aFPAJvGHDPEctTekRy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751396762; c=relaxed/simple;
	bh=3yZbjzxDVDYQJwaaKXh5NfwJopR6odWrswC4Uexz3EE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fTOPJP7Y3tZ6rZVjVKFjO2VJYMcYBtd6dT6DWxwgZk7Ri7Q0sWFLOetzobrNjFm9m7iQGaJOhLjjaa0Nd1NKOE0cdzeQ9EsknJTILVxi8GjbjRDtrKqYBAoBbNG1B/6XLEMLyuK5UHfBA4V9/BJC4ipizrxEu3Bmx+enmVtTAbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=T9frOHSD; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86d01686196so180955339f.1
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 12:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751396759; x=1752001559; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v/rCw+Zb9Mvts9DJelBmRopD1r8plgjJIjK44R7yOGU=;
        b=T9frOHSDOBCdAFJt1kmzXMDr/CXARB7S5lSdR+xvIha5y/TYEBrFK723FcvjGejiYe
         iq08Cb1NQfaF0zVkYkJjP/ajgD48CSOd+dVt0z3FO2pkkE37fQ0I35G92skzGjJrhNvY
         2o5qCDF2PqQ9Tq/JfZGiGyf9uPHxSEpqjgIhmFFQPcAMIx+06veheny05JFIWqvaDQOc
         DaMRz1NJlxIS0ctvTjZm8pcfFqqVUBc7vngAZcVgPXojK84eoziDh79SR8gk/ZdNqr94
         xhT6Gl1XfwRg0LYNtOsvJSauZAJkpL81uyTQNwnfcPj8YDlbikgkQw8l0/8NqlIksJl7
         LKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751396759; x=1752001559;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v/rCw+Zb9Mvts9DJelBmRopD1r8plgjJIjK44R7yOGU=;
        b=TtsTrgiClZPHtwFDHImN+3LzLsDoMCaBVm4cLiH8Mg1H2i+YDkE9HFpdm58h8UZoQY
         vP/UIroKTHco6noY9KjQRbsvikqRVb870elIn8jHEYaCCNOOiS9tNnnroRukVjUIkTBj
         9FQomtVDJvkfMSe9m4iZABeueF2Vp2Wichuxe+2gEFcCMxydAchbpBoT2+J8NAqVahHy
         Z+/ZuDVeN1KpTw7JFyppK06db5If+56zC6L0P02CL/v8CFsfZicM9VuUzLBlC9pDbd6L
         upqFCv6plQxmq7EieDF/yApEHLIyzx8PKFYum9dSGvjAOSYIB1S5qp1DBy3bfKN2d7Bg
         ixsw==
X-Forwarded-Encrypted: i=1; AJvYcCWptcpu0vn/iESQKFei3bsbsJd/BXCYipoIWoIUi72wd/DxW0GScmi/L9OGEVl9hneW9SuvqTrXCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YytBHUvj6BAENEu6lQylIUdRxhrXGpQtyXceuIWCqM3B4mUjyn5
	xaEsFrDqeZEF/OkKyTOIxCYzTesekeZ+AljdZAKXU4asqwYP8tbFr4tk3q4o/h8Qk50=
X-Gm-Gg: ASbGncuQfAUNK3Jis2LBRvlUF77gVw+F6gwb2kCmt4d26yS8hhRfU2oLk0YkEbeBwsg
	zM0kMCiUGxJELxMbVy1ZEvnKxugKdCgJfYmalf3GyTpZbIRIQIEUDBF79T/AM0lld45W9eCbGIG
	yOiGvv5b9utMu94KPKDU2XeoVVfogYvF9jZXL2ttW1bMzOGxMxoHG3xiQifwNHxW4aKOwOcCA4F
	hRz3B6346xy9iA9w3TdCajjVogKECodnrvMlNvriTdupS32hO9krmfnKcRmS7kvd9GHuBQ04VxZ
	lmyiIBrzCl1c5yE2yS5EDXZRXXGk5HDD0v8FvVGXqIkTe/3H0j5f9E66ZA==
X-Google-Smtp-Source: AGHT+IGRWjQOhmtHj++QwKNWgHf7AHpn02TWL1X53w/dyXCPPx9y3hHFUywI0EXa9hDdgpHBFStmXA==
X-Received: by 2002:a05:6e02:3805:b0:3dc:8423:5440 with SMTP id e9e14a558f8ab-3e05485c170mr2894785ab.0.1751396759152;
        Tue, 01 Jul 2025 12:05:59 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3df49fd4f86sm29817955ab.5.2025.07.01.12.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 12:05:58 -0700 (PDT)
Message-ID: <c83a2cb6-3486-4977-9e1e-abda015a4dad@kernel.dk>
Date: Tue, 1 Jul 2025 13:05:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] btrfs/ioctl: store btrfs_uring_encoded_data in
 io_btrfs_cmd
To: Caleb Sander Mateos <csander@purestorage.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Cc: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250619192748.3602122-1-csander@purestorage.com>
 <20250619192748.3602122-4-csander@purestorage.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250619192748.3602122-4-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> @@ -4811,11 +4813,15 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>  	loff_t pos;
>  	struct kiocb kiocb;
>  	struct extent_state *cached_state = NULL;
>  	u64 start, lockend;
>  	void __user *sqe_addr;
> -	struct btrfs_uring_encoded_data *data = io_uring_cmd_get_async_data(cmd)->op_data;
> +	struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
> +	struct btrfs_uring_encoded_data *data = NULL;
> +
> +	if (cmd->flags & IORING_URING_CMD_REISSUE)
> +		data = bc->data;

Can this be a btrfs io_btrfs_cmd specific flag? Doesn't seem like it
would need to be io_uring wide.

-- 
Jens Axboe

