Return-Path: <io-uring+bounces-446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3940983738B
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 21:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF11F28AD0E
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 20:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A23F3DB86;
	Mon, 22 Jan 2024 20:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YxYz0toK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1236405EA
	for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 20:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954341; cv=none; b=LMB+AGe10nBHHcg+A+JnM+dkFikTKF8gaUJdCpExAs3S01RZuJgctSqfQgLaxmkvxRn/ED/P4rIYZH8/xINLhwZaFHBxIQOQIDclcCSdZlrlchHV2V1sjDQc+ShaiCLMbp1DGB+U5sPm0z4NZuZzXq6vFYjPim5CsInzkcJEChg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954341; c=relaxed/simple;
	bh=t1nBhVq2IDL2N4hcOU5eZj1KxPIxSVm54rEcINAxnWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hbXVjOkMJRhPtOcTNG3A4Bm2angehsgziWTUoAYdQGNMVeaf2x8eIw60HQNEYUjsAMSL+gUJ+xNa7pPHvIglJWaWMI0ezvv8w1EI2FigTcaY9bNEyzz/I5EgeCUHujzP3Gcyf+IwY/IlxUBi36LLHgfJitW+cmhZr0Oxoba65kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YxYz0toK; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso47963539f.0
        for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 12:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705954338; x=1706559138; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BEXMIKaKtxEGDX+WFPy84qGg6lPtHwfAO0gsQI2DvYg=;
        b=YxYz0toKw+whOSEc1o6M4gdm9bM43MWrlmE8Y50fNaH58GAdPbr/PoMelPYELYJVnb
         zNaOPX8Zj5HgClsd3+JBVi7BqkkfmAmbl1tWJezCAiN/v9lHKnN2DLgrrDdhmH102aF8
         l/fkaLimZYN0B0izF4PiNF1CIryjMlBQifkhzfNTEOBd9itBMjlyqXqVnvD/pkmNIqVg
         MnexWu4AuijOi3nqDt1OobKe2wpyDTPC2pl9cObDWbeDacO145e3G8tEBdi6O+d43jQd
         SCnQUqCY1D29K0h4v5JF/ms6dn1YDmN9aD/5a6sYVSIW/sWD1IfTq+mEC8iRGHbKui+M
         Dn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705954338; x=1706559138;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BEXMIKaKtxEGDX+WFPy84qGg6lPtHwfAO0gsQI2DvYg=;
        b=CEb/Vy9B7Jy6gpEcOlWvnsmlLYq5Pct2QWrwIKa5lVJWMuyI2XQZ631rLPpPVhEvXw
         Qm1FL2gu1ntnBN5idhChbOLcHqJNWhbzd0rrIEN+OJpt5p5mwkRflxIARGG+kUqUO7pn
         octxzIrbUTNut+/eA00AnXfVbEmAg/CWUvBnCLrA3psJ2KOFehOsyxjCOz4SWLOhWTTg
         VgHEGi+N5eocLfJ66GWiB3hRugqpha//1XREpcbwDKb//173hgPKwWo1JM6sfhHa8Ehe
         jTPQ/xieXeDY8HHHXlLIET2cl2yBErNZIwnLlzhszK3hGWiZSCKRS0bicOOjcpTDEKdt
         MNJg==
X-Gm-Message-State: AOJu0YwQcoWsEASUIf03Hxb7ZWxHCjDiv+ghWfuf4Zk3TBweJ61nD5mY
	Z4+1E4WnMQrL3+RtXFLHs758EYM5nsFiqyhmknXnWEr0A6fUxEth5/jSrws+bhE=
X-Google-Smtp-Source: AGHT+IEH8zyivauoHVUtOrNkuPo+RhTPCsLyB6CF2jPiM46WixR27snqQya1a+SYoz6g5AK5DDpY0w==
X-Received: by 2002:a5d:9304:0:b0:7be:e376:fc44 with SMTP id l4-20020a5d9304000000b007bee376fc44mr6887975ion.2.1705954338113;
        Mon, 22 Jan 2024 12:12:18 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id s2-20020a02c502000000b0046df6e19b9csm3177871jam.34.2024.01.22.12.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jan 2024 12:12:17 -0800 (PST)
Message-ID: <f731fb7b-4da9-4250-ac9f-20c7678732fd@kernel.dk>
Date: Mon, 22 Jan 2024 13:12:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: add support for ftruncate
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
References: <20240122193732.23217-1-tony.solomonik@gmail.com>
 <20240122193732.23217-2-tony.solomonik@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240122193732.23217-2-tony.solomonik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> +int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
> +	int ret;
> +
> +	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
> +
> +	ret = do_sys_ftruncate(ft->dfd, ft->len, 1);

This needs a __do_ftruncate() or something helper that takes a struct
file, that should be done as a prep patch. Then do_sys_ftruncate() can
call that helper as well, once it's done the fget.

With that, you also then remove the restriction you currently have that
it can't work on fixed files, there's no reason for that restriction to
be there.

Same comments on len vs offset, and the CLEANUP part. Both need to get
done here as well.

-- 
Jens Axboe



