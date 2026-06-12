Return-Path: <io-uring+bounces-13711-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id iUTdASh9LGoVRgQAu9opvQ
	(envelope-from <io-uring+bounces-13711-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 23:42:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8629F67C8C4
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 23:41:59 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=es+QnVaY;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13711-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13711-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 01FFA3006836
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 21:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A476369219;
	Fri, 12 Jun 2026 21:41:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E756733123D
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 21:41:53 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781300516; cv=none; b=pXfxq3S2qLhyGfS08fY2qFI/+xwnfHmbNM6ctlDf8t1VGGt4gEb/0cZ2doL63tAmTQsXlXKvlDr7BDTv1xMcP4Oaf/sz0dQSkfLmLmuq6V0Qna5Oi+pr21Vtg1hS9CbfZ8+pDkrfK6c43iIx3lTMm6212v8rbbS60y8M3JTGbMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781300516; c=relaxed/simple;
	bh=HmGlUw01d8c+gDCWZsDFuE8skRwALgajdhYQnHuCHZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V0w7HgrALuK6Abs4TD4l6Nulew1a90GKH+hLRSnzQavtQdCyDrzwTr6fbnWlQiSuF8/gzY3u7tBbCPKF0GosJM3CMYnwBVfTavbLEAB2U66LpJyzOMx2czdmmD2uQwPbyBqMcCojgWBfqAMUc95okfpY1BmaybLgq0uxMFKyy28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=es+QnVaY; arc=none smtp.client-ip=209.85.161.48
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69ec2ebec61so1008689eaf.3
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 14:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781300513; x=1781905313; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iDl8p/pkBDYizYLuyGTjAvbwOmu/piT0UF7Mw/fR+3w=;
        b=es+QnVaYSbg7nGiUyXQsnGhYSs31OnIxgYHFEXzR7BAPVs71tQc+MYKIQMC6PUZyB1
         xBMDDG79LfBtAnyRtBvTGEBPH5U1shDervrBD1lNw491WX5RzVmeriqvadxvfgz3mn6V
         WvYR4I1FK0CGr6ybQEOAtkB8AbBAjHdyCwkDL103Oyal+3Bj7cALRp7HqCfbyQ6O0d5S
         JSQ4ORapn37yb3x1eSqUrHZ4dLvO7FTQGDIpD9omnVjb+AT4Mg00DOghTSxN6Uwh2YVD
         BM/o2UAroyJzbBSLw0h1YcvJlDXgmPkiQRaERXSsyG6Qxa5C+MFlmDV5uoZxctUpGroq
         I4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781300513; x=1781905313;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iDl8p/pkBDYizYLuyGTjAvbwOmu/piT0UF7Mw/fR+3w=;
        b=V0F5RPhy3XZYaaXsolFcgoEJCRHbZ5zrLsgha72+ltFjPHNqz9Rsgq3egAHT6B3pJR
         Cm3VB7jToecmfI07uQGCvgHSdDF6v5smakV1SNzYfkBD/oIAGw7Vxh2r7Gr1VvJET4fy
         gYu58wYVG0eEzVGHrdZd/+85kncehXqtTIH70zvRkOgbLgOzl4hUv7HjQlsr/i3jUhg3
         xfYtw0wbsVr1BvGsjOIm5CJEWxlrxikL6ouALTt2tkE6w/h0V9WcqyoyBGouU6yBjCvy
         1QeaoP2xIGxwaTJVxxt8M8/rKZX2mjJvCQqoHwMoHPjBFMt2vzoG3N7VlhEMX/+m7hht
         jgog==
X-Gm-Message-State: AOJu0YxReFFtd0BhEJaPA9zFv8uzwbr9jYT+DtmL52N40FSWUIn9P+/d
	R/S0t+d/XJ1UsqfmqYtbqNkaZCstHIuOTZndFWCMrdfjDFSplm2cSQJcHaZ7NbZGstPCEMqyjbx
	/dX2aIpc=
X-Gm-Gg: Acq92OHFjAyQOSzBBHZmmeoyhGYSlpH09DoqkIFFtEjzHUKu2sc966PvE7V51kUdHZX
	/0ihciVmIos95ar2iPWsYqvx5ry8WbNkUHL5+J14qYSpqyar7KtoUD/UZFBIV1jyZ1TCO4L8KVL
	BckEwXo+2odbQK+CqYnJ9/D51JjdonGcOR27/7qW1qM2eF/VFT1b+V0N31ADoryug2VloE5agzY
	sxLpAYlvTATaz92HXOxkbw+FUxLQCGYYhSWDjy0xlQD5yOjI305Ezp3Wwu94QofyMr+q7FNDw63
	lubJ6QeY9LN1UTwTtldURKicgBFxkugdZX67plL2cn75Enm2b+CKY+ABOuKdzUKWpUHjGt2aDBn
	O4QXQurcDNJiLfkPi9SUQ9jLf/18W9MOHY7NgwJN37euIFGdzjEbPJ8w2kSFxd8b0slowLQ0GdZ
	IXuE1m5N7E+eg20evh4HUbMgbyJ0WTGi9SVL7ZgyB4z20u5IkpcBUoqCuZoqOLDLPIjkEuEqAbP
	YddvG//XA==
X-Received: by 2002:a05:6820:221c:b0:69e:3567:d7b6 with SMTP id 006d021491bc7-69edc6ea12cmr2890967eaf.30.1781300512747;
        Fri, 12 Jun 2026 14:41:52 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4426ab0f03bsm2916411fac.4.2026.06.12.14.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 14:41:52 -0700 (PDT)
Message-ID: <058acf71-4d45-42ff-8dba-1ad478c68c56@kernel.dk>
Date: Fri, 12 Jun 2026 15:41:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/rw: fix link failure on successful pipe
 short reads
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
References: <20260611012236.3020181-1-yangxiuwei@kylinos.cn>
 <20260611012236.3020181-2-yangxiuwei@kylinos.cn>
 <d75fe34f-dc14-455c-8d80-04d341a9744d@kernel.dk>
 <20260612005902.1369063-1-yangxiuwei@kylinos.cn>
 <20260612062944.1968425-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260612062944.1968425-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:yangxiuwei@kylinos.cn,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13711-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8629F67C8C4

On 6/12/26 12:29 AM, Yang Xiuwei wrote:
> Hi Jens,
> 
> Following up on my note below.
> 
> Patch 1/2 was motivated by __io_read() returning short reads on pipes
> and sockets without retrying, while __io_complete_rw_common() still
> failed the link chain. I had not fully understood IOSQE_IO_LINK at the
> time. When a chain depends on reading a full buffer from a pipe or
> socket, a short read means that dependency is not met and the chain
> should fail. IOSQE_IO_HARDLINK is the right option when later requests
> must still run despite a short read. Sorry for the confusion. I will
> drop patch 1/2.

All good.

> Regarding patch 2/2: the current code does not handle TIMEOUT_REMOVE
> against pending link timeouts on ltimeout_list, while
> IORING_LINK_TIMEOUT_UPDATE already has a separate path for them. Was
> leaving ltimeout_list out of the remove/cancel path intentional, or
> simply an oversight? If the current behaviour is intended, I will drop
> patch 2/2 as well.

I think that one could get done, even if it is a special kind of
timeout. But the devil is in the details, easy to get that wrong.

I'll take a look at this, but it'll be post the 7.2 slated changes
as the merge window is just about to open.

-- 
Jens Axboe


