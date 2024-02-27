Return-Path: <io-uring+bounces-773-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FDC868504
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 01:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94A6DB207CC
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 00:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC64393;
	Tue, 27 Feb 2024 00:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P548sEsR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA64737E
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 00:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708994143; cv=none; b=CyNra1Mx1kTOsqvW7c7j2QTO4RWVRMHQPaKJV5OPr5es1mxFVNdKCnZ/t4RI2ve7gl5jjgYmmXj/wuhcfI86a8Q9LUqT5RnTurtvWDh0Swd0m5SDa368kx3gZ5JI5mRkSl62ouWRte1fGW3GCMYYuEwrG6YFuyh4yG0ZdIV9an4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708994143; c=relaxed/simple;
	bh=gjVw1t/8cd/pPqL6pKxMdKzVxIgfTnZ8JFtWKzY/YM8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=P70MSgXzArVGQ6t5IBFpq+bAe7dy3Rs81J7RTbP5UAd0663j/Yu7BR6lAqedUkB9alLiQqknMK2/Xpmow5pZo8XpAcu+GZiCdt3pMEu6lgzwAPikIS6BK89fXxf6iWY8thoQcKLkWO7IQ2uR6NjpQclopLGxLhZw58JE0+lNIv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P548sEsR; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d3ae9d1109so5066695ad.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 16:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708994138; x=1709598938; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hSgJ8itubDzzcfStOddtC4Y7MOgr9MfWO6cu6uaw95I=;
        b=P548sEsRBnQhItWBaleBQVYyIzr/12MU9Yup/YW6rQQnnUKLC1yUkJBovfyt5Mx+T9
         Sv254RNIAdnmFJQIcOBnw9PbA3vN9+Xw/LD854h4ey8vsSGbU5dwnwSubjsdvSzBsKOD
         0qZ8CnNZVynJe4Xtpd/Wt5AnHgHG8bDjK/Z90rEFsl8sEARSygOez6ddmhO3C6gzml9o
         9lALujU4nZ4sz8uO9eBLewqqcvyKb+teqTmSMOKT9b+AsU/eTpv6NARHZEp9VpMBfZvm
         UbA7BkfYkVPMjJ9YbXcr/3Ste1SRvqKlXuQx/wuFeA31hqCTaGEp5hSHY+3/x45Tts3C
         34OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708994138; x=1709598938;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hSgJ8itubDzzcfStOddtC4Y7MOgr9MfWO6cu6uaw95I=;
        b=KOWqBAK5r+KyxqQ7is4ty4K4108Ptkws4/PvVR/kcRyaeaCdUzwVcVhenbTefMMioZ
         tiwMRXLavwAJQsMufadotCyx3La4lgS6L16oI3cIXUYHFcgFJAg1lX5HbPOLNtr4WbQS
         xeVw0J+gQexkHimmAMPk12SzUJilflTlBu0TCb/HP4onfSgpkB+unBFSWVTZG6gAlhJ3
         kohjesCy3bAv2xKgpogLs5kD90iwVTtnGgkEAqewPWZxYy2U156HgklED6NSiOT6liSf
         NVxgtSnBoy0Xh5TzOlOhnI0EMul2EPC/i43tTP8LBwML5+D4laz22g7cOBjmxBFL/jYT
         L3Ww==
X-Gm-Message-State: AOJu0YzF0BAr99WtlQelQniPcWrfBDnZ2X10EcwJETvVjNXEMWoMERg7
	Qo6MUWwigy0g6Q/WMcr3RiP04cb2ff7fP9Xj4Fq1ZvCC+GJmSyr6J5vmXL4+UZ/lnmcGYtxyqdH
	y
X-Google-Smtp-Source: AGHT+IH/h3BZnApeZ3gdW8nstXhxhSsMpFu5H2lC8+JOUS11sz5ycvt8AlSex6FdaHsMsm0WHjpD7w==
X-Received: by 2002:a17:902:b184:b0:1dc:96c9:a122 with SMTP id s4-20020a170902b18400b001dc96c9a122mr5372522plr.5.1708994138033;
        Mon, 26 Feb 2024 16:35:38 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id g17-20020a170902c99100b001d6ee9d8957sm259811plc.281.2024.02.26.16.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 16:35:37 -0800 (PST)
Message-ID: <6db10bbb-cf34-4e81-a2ad-d14253d835d4@kernel.dk>
Date: Mon, 26 Feb 2024 17:35:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: improve the usercopy for sendmsg/recvmsg
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: io-uring <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
References: <3cbf09fa-74e6-42f7-ad98-27a48556ba29@kernel.dk>
In-Reply-To: <3cbf09fa-74e6-42f7-ad98-27a48556ba29@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 4:54 PM, Jens Axboe wrote:
> @@ -305,11 +310,13 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
>  			iomsg->fast_iov[0].iov_base = NULL;
>  			iomsg->free_iov = NULL;
>  		} else if (msg.msg_iovlen > 1) {
> -			return -EINVAL;
> +			ret = -EINVAL;
> +			goto uaccess_end;
>  		} else {
> -			if (copy_from_user(iomsg->fast_iov, msg.msg_iov,
> -					   sizeof(*msg.msg_iov)))
> -				return -EFAULT;
> +			unsafe_get_user(iomsg->fast_iov[0].iov_base,
> +					&msg.msg_iov[0].iov_base, uaccess_end);
> +			unsafe_get_user(iomsg->fast_iov[0].iov_len,
> +					&msg.msg_iov[0].iov_len, uaccess_end);
>  			sr->len = iomsg->fast_iov[0].iov_len;
>  			iomsg->free_iov = NULL;

Missed an access_ok() in this section, the committed patch has it:

https://git.kernel.dk/cgit/linux/commit/?h=io_uring-send-queue&id=1a5c271af083bccfed400bad7105d9d06290bbf6

-- 
Jens Axboe


