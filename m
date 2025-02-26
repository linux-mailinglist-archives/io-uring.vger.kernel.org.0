Return-Path: <io-uring+bounces-6815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B246A46A18
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FE0716D7AA
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64ED22A7F3;
	Wed, 26 Feb 2025 18:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fVs0vjlf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E72422541C
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 18:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740595724; cv=none; b=lDEArAX0gSVPvc7IwlDDf+Z+GtDhnG6BEdTD/zdZ0NTvBcuwq+S2lWmrNXQ7QU+r/OoFcJ8ukrmTeMvJasW694Vi9Chhh/6a7oqKN5XiaJGPGghLQsH9DUkC6GJ1GtfhOvzEwrhid1nBm6293yoFPnAa6M4ZWFjcehOUXBKmqoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740595724; c=relaxed/simple;
	bh=sjc2QxmWTuIk6Ks+Nl3TvcQUZ93B5W0Id6yJv0HKyh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2BLjwFBFNAXiAqiJibL+Ck+puGlvgZJpvCsouBDx2mFn8ETHLO3iDa73bp6siJdZCvsLda5OaNpzFKYij10lnMDZs5VRl0HtsRVYSZ71PuzlWy+ivo9wCTW5gOJtXeCnIpctz6/kYS0HwVMv4s8P9DZaVBTpNAGwTlJPYvRYiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fVs0vjlf; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d2f5a932f5so573765ab.1
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740595722; x=1741200522; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=29YldXHZZWIENyZLJKA3m9s10qkAwfthBjQ5H8hR+OE=;
        b=fVs0vjlfD2XtpaKApL1zNtdAC94Sdiun5OCQhJiWAsNGJieaes3/4Ftn5yiizyKIlb
         DUSZlnw+saJYPE17w+5GbGepWMPX3RnbheNNMTxlzfr/p18+L/Ak+yw22PGSLqZkPE7c
         ZrUFdVE/Gk1Z+OrTMu3E0bzzOBT2q0L4Q6kf9T1WPoQIRMtFyqG9rmRYwVdzyM/O1xkU
         Qd56E931qf+5796YKEAuAG1JoLB0Uan2GUEPBs1mT3itNYAjtkQIX5Pr0lLdW0GYfiOl
         1SWJP7W9IQyipVmQAmbom0n60L5V4Jyx7prU8TuMswP5BD1VJpYr4XcV05faoc+di0N0
         T25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740595722; x=1741200522;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=29YldXHZZWIENyZLJKA3m9s10qkAwfthBjQ5H8hR+OE=;
        b=ufQvK0pOpUmINZlfYIe/GQUNknQG2LfkI+sx37ZJc1g1tylGwB38C/I2UIVxnXYf6K
         KCCdMU9OrvPFR71+VzUwxDhx5n30I5lINOJOfA/As6VcRwPDedkgCxGFm9hzsiVuDPq5
         fTBDXCY8KHqipMHqgxnXF6Xs29a6UVRn32p5lrPdR/+f9sPtTvedcRT2C68QRsUp1GFa
         4fe/Yu/TjKEMESHZvJ8gBhII/zrNRvd0Tc5jyJxjYMcIuCYA1Y5h4Mm0PPtaWsBrwHYw
         tetvmrNZsRjQzlxUItzU5ZAiTEZjPAcqTvhpYvUbAT3UG356CAaH2R6rw4XcUzbnDU3H
         bAmw==
X-Forwarded-Encrypted: i=1; AJvYcCWERaM7bWT9j1SdVz4HjQDcNEl1KqZ2RBGsiUpdHtl4ZuAdRta0e2ZYuDboipZ5gqdm20FaBRXaOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuHElE5a5BcE4im0QNR8BrEhDcErEYy2TkY6TaW/qw6R4yEQmV
	Pl07ffm4ad8JNIDoLc18d4O2gh+5lRC3Zm0ojhtvZNs6jmdLg40LR0Q7C/H7d7g=
X-Gm-Gg: ASbGncuZrTbqnhO1W9XvTyCQ6sMug+7jV5ffmUZvlPMcyFst5H+26tWJpVQ5wzek86B
	EpkLRD+lxjR6YkSkeclXTgZrD6VZt4mIMxgKBiuR6vm2g7wbBnIZSxQwr/My+VGpGrCmYCEROtn
	t/pTTQTa2Hci1MOO4TQv94q09KFYx7q+KZdt2O7LBRNtmvlMqu9YNzBK+ZGVf92RPf4W0LzLkgL
	Cw6W+sZ3Qum++XJAo3iWLMO42WKzht+xD33w443wsDl0abSvaZYt7AzHdy2YOiZKDRmCoL8l+eP
	AHwEkg5SJ+XSYbjNiddt0Q==
X-Google-Smtp-Source: AGHT+IHf9KJaHriQv0Q3uxkEzFWxGYsTVqpO/qA/s9OvhP8CyXCH/BuNYJCZKyKUkYKaJLxbKZdjlg==
X-Received: by 2002:a05:6e02:1a6e:b0:3d3:d067:73ec with SMTP id e9e14a558f8ab-3d3d1f4ea2cmr38736525ab.11.1740595721727;
        Wed, 26 Feb 2025 10:48:41 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d3cffbaa16sm7134915ab.6.2025.02.26.10.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 10:48:41 -0800 (PST)
Message-ID: <e19190d0-fb60-45c0-aa3e-7d0b61e133ca@kernel.dk>
Date: Wed, 26 Feb 2025 11:48:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 6/6] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
 asml.silence@gmail.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-7-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250226182102.2631321-7-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/25 11:21 AM, Keith Busch wrote:
> @@ -789,7 +856,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>  	}
>  done:
>  	if (ret) {
> -		kvfree(imu);
> +		io_free_imu(ctx, imu);
>  		if (node)
>  			io_put_rsrc_node(ctx, node);
>  		node = ERR_PTR(ret);

'imu' can be NULL here in the error path, which this is. That was fine
before with kvfree(), but it'll bomb now. Best fix is probably just to
check for non-NULL before calling io_free_imu(), as other paths should
be fine.

-- 
Jens Axboe

