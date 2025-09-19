Return-Path: <io-uring+bounces-9842-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E306B89375
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 13:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18A35175E33
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 11:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5572153D2;
	Fri, 19 Sep 2025 11:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hiBWD3bT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698B21990C7
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 11:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758280597; cv=none; b=h1SlGwGS6isNWloDYMFn9bdNpg2cdyIS2xeSVFjkDI2VHOnUg3i5g2tUgOQFzUXsdOzhbJ6SYv2zXn1Ak/fNVEbEBPvZ6LjKyxseCnsm+OhUZXzY2Yni1IatTK+vqDjNvKlh2X6dBpT+ne8xPx2lxU1Pd8V6Y/FRmN5oAFMe7B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758280597; c=relaxed/simple;
	bh=uFcO57Pk0WrbpZ0nBTxEDIGUVql8VJVjCEBVFYx6iMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=krAmClEarj369zOucKzaCR4BFSj9mH7xwVtH3O6v4/kPiHxTNzPfuSruL97JJle0mWVXKlQu8VTfLsDcoqRrTyiXaQkf88Vf0VmewT9a03EY0/i4rFnGUZgyhkj0FY7GxuPWGoacmRpLrEIw5RreAaJKvgI1P34jZv5k3CXVV3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hiBWD3bT; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3c46686d1e6so1282877f8f.3
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 04:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758280594; x=1758885394; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U8J9tiDvGThtAwSiN1bv+7LHC/o/pv73LV1hgNLEMd8=;
        b=hiBWD3bTn6xIr9X8chM7FuCaUX5XWo6blyv37KdCxW0uHqF9AZPwUeDJKxa6ZRkO30
         Dmgm+ALNKoZLo0jjFHHRZEodXH8lu6Cohm55adKt8S8Q3S2S1Q0LoNU5r4wucy6EjXzb
         h9ckCxfhtzuEVZfusbZF2Euk9piqjxb5KmeRYs8RvCObo1pWB12AqJefy3TuOVPqbzZF
         OIPk0CF+rI7GkuFD/n8ovuDPSIQRKBZKu5r1q94GnCp3BHaDSurf0BsPW9AaL5Kgv95y
         WYrrW0uAQu8XRR5ZA83QSoxUhhzGLVq0NqpVT9qPJdRSBEPWeABvAhnPYT5ezhFTTubx
         I1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758280594; x=1758885394;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U8J9tiDvGThtAwSiN1bv+7LHC/o/pv73LV1hgNLEMd8=;
        b=omO7azE6VZC8Mm5ywvi3sq0PEOYnhSGXYdorafyFJoA75YQ12YuFnTudtWFxnRKT25
         kDGYcGyZvDFjPi8XML7zsZOic9lq82glPUS9qvite3w9lH9MqlS2MSuRpETeWrhsE4n/
         BbyRQzAW+Q1CId0slSqdYBUaML9iqZftAdZ2W3TPFrQomuiYG9i3/9ePmiCGYMv2zAat
         dQB7lVzkgpQ5G50SMxwdE0Zwi6w4vEVjpO05znimMIOsmdmmqn3dozgmn7K46T4MkXsd
         n/d8s1xy1yEDo5R/rCGf5WX0MK/KiBMJNUSvFZQi9TOokQvJd+2f5+ps9cmns3LuoejY
         c8dw==
X-Gm-Message-State: AOJu0YwDDpb5J4k7Sqd/1ArtSAaokr6Wlbargpvr598Lq3XuiUNzZx3F
	FhDhbpcur8U1tpXI5/SVCq4lC/1e6l30yuhydg8gIXgCRKuTQTzJKwVgWk3kFA==
X-Gm-Gg: ASbGncuge1qYTRq5JJw/3VRho8a4K4aq38+To2nFN6KL+T+kEQMTbBc6xy3sww28Avo
	dwocAqYqOcO8h439a2wfSEgl18ayFluA7CA1R+erW32PbJcei/wHH1BdgVPsIZxtULBRzYax/Ut
	bIrJE4I8VFa3cJuWIJe/9SZPbLG/nFszOJ53mzqfBAuDZaI340Ug/HdJlSmgz3inSiZDmU+mLVC
	ChmiEKRnk/8hrbP1WDsa8ZdkVYbCgQ4dtAMkoW8tKl6lGfIo8eWNxfLJU3cHfVQRIOGphLjiBOT
	F/EeSKJ/nrmvLk6Shwn6n+qnoUOiv+KrK4ojSxS3m4LdXr57OF8F/9niouyDByTmgl/kUpv2pZJ
	lvVhVc1UaRmbNbk8zsjIboKF5rMrDhxJqgLesBvIIFcVlnLS679XeuxY=
X-Google-Smtp-Source: AGHT+IGu/SIetYZnGLaq+bxDcQmz/74fPrTovjJaXk705o6ldrvzR3WoKlnzxwpvZ3II1OmiqcTcpg==
X-Received: by 2002:a05:6000:22c7:b0:3dc:1473:18bd with SMTP id ffacd0b85a97d-3ee7c55291fmr2149382f8f.3.1758280593497;
        Fri, 19 Sep 2025 04:16:33 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:a294])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbf1ad6sm7167043f8f.54.2025.09.19.04.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 04:16:32 -0700 (PDT)
Message-ID: <152d553e-de56-4758-ab34-ba9b9cb08714@gmail.com>
Date: Fri, 19 Sep 2025 12:18:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix incorrect io_kiocb reference in io_link_skb
To: Yang Xiuwei <yangxiuwei2025@163.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, Yang Xiuwei <yangxiuwei@kylinos.cn>
References: <20250919090352.2725950-1-yangxiuwei2025@163.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250919090352.2725950-1-yangxiuwei2025@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/25 10:03, Yang Xiuwei wrote:
> From: Yang Xiuwei <yangxiuwei@kylinos.cn>
> 
> In io_link_skb function, there is a bug where prev_notif is incorrectly
> assigned using 'nd' instead of 'prev_nd'. This causes the context
> validation check to compare the current notification with itself instead
> of comparing it with the previous notification.
> 
> Fix by using the correct prev_nd parameter when obtaining prev_notif.

Good catch,

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Fixes: 6fe4220912d19 ("io_uring/notif: implement notification stacking")
Cc: stable@vger.kernel.org


> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> 
> diff --git a/io_uring/notif.c b/io_uring/notif.c
> index 9a6f6e92d742..ea9c0116cec2 100644
> --- a/io_uring/notif.c
> +++ b/io_uring/notif.c
> @@ -85,7 +85,7 @@ static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
>   		return -EEXIST;
>   
>   	prev_nd = container_of(prev_uarg, struct io_notif_data, uarg);
> -	prev_notif = cmd_to_io_kiocb(nd);
> +	prev_notif = cmd_to_io_kiocb(prev_nd);
>   
>   	/* make sure all noifications can be finished in the same task_work */
>   	if (unlikely(notif->ctx != prev_notif->ctx ||

-- 
Pavel Begunkov


