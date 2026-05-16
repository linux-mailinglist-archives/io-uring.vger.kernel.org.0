Return-Path: <io-uring+bounces-13370-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oBqhEju3CGqr2QMAu9opvQ
	(envelope-from <io-uring+bounces-13370-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 20:28:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D586955D1DD
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 20:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2948A300646B
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 18:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB9631F993;
	Sat, 16 May 2026 18:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="nsGdIo2P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307E2325716
	for <io-uring@vger.kernel.org>; Sat, 16 May 2026 18:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778956087; cv=none; b=fKprswimSR+mB4ZWyN+xqYbiz1lnrEBpo2SMxp9Nj+WyA1596eqOU/4ehbT5t0UTO0i0mipOFcYcwt6rsNKtMFGZqg4xlhwV6BeyQ906Lrd+7q1eue/0/H7aCOhPFsss3Tm4q0r9jaeXWYVqasXM1vWNhnFkjBI9DGifiyNiSp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778956087; c=relaxed/simple;
	bh=F+tFCCj1ZUASDFOKR7I8bBpir/zeZ7QG7dX/1D9JTrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H+3xV48tabWA71LVO2WSLaX/o0JP91XngvFLOdGryclHn9YYZCe6MmjYx9Sg3udeAjv1QljjoA8imXqojekicKO87iPpSZ82vdcEuVZ0VBJwLTfpbdjMy5GqQJ0k42tpkCK+st/TG237A6q7U9TdKM++BYgLd43SiUZrW0Qxr5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=nsGdIo2P; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-479aa2dbea2so424549b6e.0
        for <io-uring@vger.kernel.org>; Sat, 16 May 2026 11:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778956084; x=1779560884; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PrcpfbJobIdct6+JEgRgRPDSXujlfopahqsyylurpXg=;
        b=nsGdIo2PNTYWPjbbvuCBM8h5LPFLhYSGM61vUE26bNQ0cPMUCZFS8Di9nhaocECpZX
         6pgDRHA7llwtz70b4zMt98iuMnNoKIm11JzQFuMH3fRshDtUKK5N+xwBerwIdbJcQutd
         OhMbYIGLc84itiBDWL/ENHHzsZ36LGetK7zix3Fse/8fYosmem2v/jUW48WKJU+CbCrv
         vVoelSFxU05K3iZYz6UsNoStRALJJQrx+xUCijFtTuQ9C3Ac0tezPFtR48EouaWnuTos
         pp3+3b93tl/icvtjOK7heurzvZbdlYQv4pHYnuEKa/GsOKQFidgDRA3GK9OatLLbOdac
         p49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778956084; x=1779560884;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PrcpfbJobIdct6+JEgRgRPDSXujlfopahqsyylurpXg=;
        b=dhEI+Iqhsz9apFf6ImxD8/MvHXbt87cVxfbWQAQcI/XDScBHVJneaxAKUlXQFolami
         RoCxxUu16n5EGmNh2MT/ppcDh3tBhmV06mamD93VXNm3EMbI0v/81LsaTTb4wRFv4YeN
         5+xdDkTvKP2CRF1AXr8COfBOUpOjyXV/s9FCwnVelPIHFJA5k3H2KbzGKDawnIGF+AmD
         vv6xoAXbKNV99F9dcOXkfeTk+2j/Mkdi50K7Hu7HmEz2c6SDocbMq/yo+5s6816cC/BI
         ZEZSYJ5gZdbv7qmRSvSoVS0PHgyWWMZHQs2UTGMqJGnGTVQKAAhFwMmOLe/BCyddPMRe
         Iauw==
X-Forwarded-Encrypted: i=1; AFNElJ+2RrfMBoB76k4LpdOIZlLrvLicQBctRdUWmvSHagaEYPlmc/oJLY/yDdeOSzAeuk1PfBl+Data7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKAEBuOO2FNIgYOZVai2euLx3V58IoR4JAXokGk6ldiC84fBCi
	J6ql7jhNZkALmyQmByZkmxj+KJ14YXZKXpqPkTkMIKeU4X88y/nhSKdMutYHP5zs70I=
X-Gm-Gg: Acq92OF14GCm8kGzx5C2NU+oSW4cT8zG/jOS9YI68pzRFHw9+EbVbzO4v7b/0+RbnWo
	tknXy71wLnw3cLhJBObnQDdraWs6vBVTLJRUynXqTEw5EfzYvCVOic7vA7zWrvvzqKhKGH0duR4
	ykR2g5MTLwPUx4hr3qdzNw8XSJVPtYRh45uMNmg/V3qPANLAPdGELKEA7L2Mkui73qABXu8IuKi
	C0dNdLD2u1ymEPE8EoELEx8IDmtV9YyfhUji6HrH+X8ht+tcwmiVvQ8hzmYRdIlr/YF2wjofGDh
	5eX1Z7h8Hph20vecbMD6EtPJv2xFXV6z7gNFZ0SEZYi3je/1rCs1IhCIDjbAgilcShtT1YD+wz6
	4yZZvvrZ+E8kqkN9AnJ1bu5ti7RUBf22rPwpPwk5EfovofiSkdTe9nwfIbjPO3YlYMz+QIBKUY6
	LkoHBys/mqni+RWZoUUTdDM15I9MR/gdgplAP1IE559UGqvez288yFs01MiujW6iOilqroElJtz
	88Xmylnjg==
X-Received: by 2002:a05:6808:1204:b0:480:77a1:c839 with SMTP id 5614622812f47-482e591ba1dmr5503907b6e.36.1778956083824;
        Sat, 16 May 2026 11:28:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc53f2acsm7139967fac.14.2026.05.16.11.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 11:28:03 -0700 (PDT)
Message-ID: <6a23b132-35bd-425a-b957-c63dc5cbba49@kernel.dk>
Date: Sat, 16 May 2026 12:28:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/waitid: clear waitid info before copying it to
 userspace
To: =?UTF-8?B?6rCV7Z2s7LCs?= <gganji11@naver.com>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <656b27a69e38857237c82fe0c5d11fba@cweb018.nm>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <656b27a69e38857237c82fe0c5d11fba@cweb018.nm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D586955D1DD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13370-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[naver.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,naver.com:email,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 5/16/26 12:24 PM, 강희찬 wrote:
> 
> IORING_OP_WAITID stores its result fields in struct io_waitid::info and
> later copies them to userspace siginfo. The prep path initializes the
> request arguments, but it does not initialize info itself.
> 
> If the wait operation completes without reporting a child event, the common
> wait code can return without writing wo_info. In that case io_waitid_finish()
> still copies iw->info to userspace, exposing stale bytes from the reused
> io_kiocb command storage.
> 
> Clear the result storage during prep so the io_uring path matches the
> regular waitid syscall, which uses a zero-initialized struct waitid_info.
> 
> Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
> Cc: stable@vger.kernel.org # 6.7+
> Signed-off-by: Heechan Kang <gganji11@naver.com>
> ---
>  io_uring/waitid.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/io_uring/waitid.c b/io_uring/waitid.c
> index d25d60aed6a..32f68fd7fcd 100644
> --- a/io_uring/waitid.c
> +++ b/io_uring/waitid.c
> @@ -275,6 +275,7 @@int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>     iw->options = READ_ONCE(sqe->file_index);
>     iw->head = NULL;
>     iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +   memset(&iw->info, 0, sizeof(iw->info));
>     return 0;
>  }

Patch looks fine, but you can't send html formatted stuff - it won't make
it to the list, and it also corrupts the patch so it can't get applied.
Send everything plain/text.

-- 
Jens Axboe


