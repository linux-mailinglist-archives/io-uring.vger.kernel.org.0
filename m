Return-Path: <io-uring+bounces-5965-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCDEA14E2A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 12:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A070C167D75
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 11:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358D61FBE83;
	Fri, 17 Jan 2025 11:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aP3AAYdq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A88F1F5611;
	Fri, 17 Jan 2025 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737111940; cv=none; b=PPwOy2fR7GsZtywoU3x+iRpigSe7yA5RVIUZSmmxOjPSAejA3ylV+h2NqMajIb6RmLZ7y8+sp7msh+ZaCtsx1YAZHcPHoA5LtccYSlEm1vFq2AQMN5H5nhrcKkAOtOWMUOVc+JqMeIAQhen5LMsiKHFT/ovoKUDy0o9BEbt3RQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737111940; c=relaxed/simple;
	bh=YOZz3IgXUs2EuZWMb1pYCuuhHK4x6y/poH91AtxASEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LanQi7eLs2karqVV8lK1WYDnrtD5l9Miyf/G40XO/PQ/yk8Vof53tGI4Zgn5pupXPaAxTXnP4NNQmY2B6GFW2UvrBEb/NV0jZEXY30tzE4vXESopWQ/AeE/d1CrQwEs8NmBpnh5NlugblCHon5Cr2hERZkZqa520Mmyf+kc5RMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aP3AAYdq; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aaeecbb7309so375530566b.0;
        Fri, 17 Jan 2025 03:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737111937; x=1737716737; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ms3e9UaPCo0oXvp9jW3ZUh8jVD8UI+qB1Kwt/7AFmTs=;
        b=aP3AAYdqR5vzulxGU4LfpIIDmAU/2jCDohnS9T8ZqT+wI7DoMUfTPWfWFkYTF5vxIa
         9mbjUu+gu2gvbTl5d+WdOnc/4lFRVIXVwnSNp0iVCweXjT+mwU0oRyza4MXlurjBc6Oc
         WLmoz0DUhQA88iHEKKOunpw1v6fYx7YCTGynEZ6aUwvsJw/PxvJESLZJkEd5yHzdXQTh
         x76Veg2OwrBTUMO9QyzuZuO7DKkPQDALGnXRDHj1qzkO52MOHVZv9SDKDoizWAnE1qao
         sWjWOi6iTT1YliaUYjEjZydCd+Dc4VvgArqHfF/DiVqfG7uYsowcvPi609YECeFFeCaq
         isVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737111937; x=1737716737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ms3e9UaPCo0oXvp9jW3ZUh8jVD8UI+qB1Kwt/7AFmTs=;
        b=Jr4wkxpZUiyQRf2a+lsrcDTSZQxJdihKJwln7LNm/tLf4+xvwgmIgSG4pvZhXsDHsZ
         z+agw6KRFBKtAhheKNztHFVo+McnCZelVNq71C4/HnuSABY6yTFGFTxbdlId4RuUhwup
         NnvPm9rayTDuNsu753Gy6X2NJPPP3ifcwfC+VHhMIpYWdO8O6gD3zko8oAwHMbZ5U+o0
         or2mQTiRsDj04YgVPoqLNXTKbNRb2ylwtBkxVa0W6ZbSX1qmrsN0WAFvXY/QBmPhDVSw
         DQ0mmjHp3L5FMFtLTmdPpp48HbmfWE0wEIi2y2vhr/wnLGwJ1eda75bNOQnNpc2hxXVv
         tyCg==
X-Forwarded-Encrypted: i=1; AJvYcCU1LB/ztP20E3kHjSP1BAF/tCftNYls8aY5kLfcYqFExxHLvmMriOOoN/bD4u6AU6EOZJV/bBAyDg==@vger.kernel.org, AJvYcCXKn5hVb1Abtk0LvjdznX/MV17jF8pFE97CPAGWrlSi871ue3t8KRFOtW+4C6lvx3llJfuUFzWrf4Kl3B1jHw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpR2MYTzivBCXoRFpS71UntGV5rcJrnN0Wpvi7vsXa/NCrBs8b
	6Mo9lWcTRm0OFceta/tvDh1npxeCmdac0WYrzWmmUcRTjN35s5bn
X-Gm-Gg: ASbGnctWV7LaBZgWpHR0dQeSfV/ULw+5eBzykXhbHSOzeYnNcAYrQqQNK7eT3OTQAWQ
	DcXFMBnrnroXd7Bd4FTMcoR1i+c+BnxW6iGMPU469KOntvnyZH2IalCAQSO+T/nZvJaHVHdgjkF
	MOILl+QNVYJKbED3f2CTH9wE3safaGK73Uudhgfw8vlMtFqmVFc0OgZivRgFSVa1pOggCVnPeau
	Tc/tQwXHPa3Q2oso6lkmM+EQXSOw6lmkqBZJEmm3UwlpJxCN34lcMBlg0ib0ElcU4o=
X-Google-Smtp-Source: AGHT+IGXHPQTbz07t9g0ay8oGApipvFSIPg8lb8cbhQ1gVeGb4pERIRN6ozQqjSpzuaE1U152GD0PQ==
X-Received: by 2002:a17:906:7955:b0:ab2:f816:c5e1 with SMTP id a640c23a62f3a-ab38b1b4659mr266023066b.1.1737111936337;
        Fri, 17 Jan 2025 03:05:36 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f87d7bsm150385966b.128.2025.01.17.03.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 03:05:35 -0800 (PST)
Message-ID: <a57cc911-9df2-40a9-9ccd-247388d20462@gmail.com>
Date: Fri, 17 Jan 2025 11:06:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/17] fuse: {io-uring} Handle SQEs - register commands
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-6-9c786f9a7a9d@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-6-9c786f9a7a9d@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/25 00:25, Bernd Schubert wrote:
> This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
> For now only FUSE_IO_URING_CMD_REGISTER is handled to register queue
> entries.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
...

Apart from mentioned by others and the comment below lgtm

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..b44ba4033615e01041313c040035b6da6af0ee17
> --- /dev/null
> +++ b/fs/fuse/dev_uring.c
> @@ -0,0 +1,333 @@
...> +/* Register header and payload buffer with the kernel and fetch a request */
> +static int fuse_uring_register(struct io_uring_cmd *cmd,
> +			       unsigned int issue_flags, struct fuse_conn *fc)
> +{
> +	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
> +	struct fuse_ring *ring = fc->ring;
> +	struct fuse_ring_queue *queue;
> +	struct fuse_ring_ent *ring_ent;
> +	int err;
> +	struct iovec iov[FUSE_URING_IOV_SEGS];
> +	unsigned int qid = READ_ONCE(cmd_req->qid);
> +
> +	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);

Looks like leftovers? Not used, and it's repeated in
fuse_uring_create_ring_ent().


> +	if (err) {
> +		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
> +				    err);
> +		return err;
> +	}
...

-- 
Pavel Begunkov


