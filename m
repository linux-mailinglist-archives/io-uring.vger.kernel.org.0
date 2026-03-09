Return-Path: <io-uring+bounces-12586-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +KXaNpTKrmnEIwIAu9opvQ
	(envelope-from <io-uring+bounces-12586-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:26:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC4B239B84
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 269AC30488FD
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE603AE6E2;
	Mon,  9 Mar 2026 13:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tlp69bVd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997ED3A6EE4
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773062513; cv=none; b=u/a7/w1qY60FecIDisa36GOlEkgp3HV1bz2Vrz6jwW5G4AxX+7hyff+1CpGl7LpnShu4f4c6DM+mEQfgRPy9xRa53ZdOHQHRauABeC/EPk9fQwgoeRHrGZcy7MTi0xl0V/0rjV6qBzEfW8GSzjMy4YT98plHMp/WLEVbNekQ44U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773062513; c=relaxed/simple;
	bh=4tqUjcfRQPJetFjNIltTIYaebWFupUXZC3YMUi3f2Ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VYieRYUbZF98z7H4qIITpX7Dl1PU5jg04GfwhI7NTpscI2/wZENyyccXXUWsfHMHzcpcHDihJfG2SLBL2eZOUopONkXUyKEt+/FUG9L850Wh5IC5qet2Ba+Q7BFjDKyOaT64kis1M8xPvQeJXEXDAjrUMz5W6a0bwZgbUrlsKjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tlp69bVd; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cd77786e97so208427485a.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773062509; x=1773667309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KFtjd6N+TJFsNa+LkO4JaJPTN5yrpGdyp9QOuD/D3Ng=;
        b=tlp69bVd/P4F/IYwyMjAs+ujwzLntO90kBacSip1FgNAHrbdBLS/1HcXh7j+nSdp1Z
         8Yeo+Ub7rTYq4tLem8JH8gsUdROyFv51CeeZLrOdW7mw7WmtUcS5tuRr3bEPigq/sPOb
         0+AQpiy2L6p3vWpDxstE52an/ufO5Hs9/vJaHlM1Km5n5DVPs6sN4YSZ3RiZYHht3xlV
         0IHiKfLTV4Nr9p3cFHNXWt+Kirile18Nt/WRdEkxljxq2AxdX4as73l9LEq/mQHLNgEV
         1Pv3+smLjeYi94gCkdFd+1ouSVUwebCigrvCXHy3XQkX3v9S/qGTerz/twFBTrefg9tJ
         2yFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062509; x=1773667309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KFtjd6N+TJFsNa+LkO4JaJPTN5yrpGdyp9QOuD/D3Ng=;
        b=oFwf1llft/RHC+FYF4ms0I0Iy0KULLZ8u3FmtTrQIJwier+5Y8v9rAS3g9v5UTmFMi
         QC5J6lU+1x7ORO7B44Pkp6Xj6wO/iGzBG3uS8N5OTNiZh875Ez27YlaX9j+M4Fvsu1uf
         P9evXTWbcIwgTUMXpogeud7RBT33a2aEBHeM9tUJH0A3V94ChBoALhqEXRvGSo8S7s00
         6eIwcxJKcG+zTYNiIoN9FwLASYE7XSNpwK7/R4ymDqy+AO8FpeJz4BgAFZp3iFOqNHT2
         aCs7Ai//lrA1podddpEOoTtmLgMVtFaqFF2DtT9lEKOl9hjdjaMtAOTjx9fpG+03onxm
         0zkg==
X-Forwarded-Encrypted: i=1; AJvYcCWuODAQ3CjZ99JDLNO7GLe7q/Dsyb8Esg9J6Cslxz1kSGJCAAtny/i/HJFIr2zL6I6HB+j0C+IjTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9YBaJJ9AyukV1eufOypind2pjMnmH+jOHeM4zTMIV/Dwa8Ksd
	AQSr+JskLNFPkp6rZcWpNaY678fW7ybUpgzcR+0POmKA0ZC9fyWWa6+PLGHZGjC80XnDoZC44Xo
	Dyx6agSw=
X-Gm-Gg: ATEYQzx/uu8I+r7+y5v6nzcvM12eBjsKXqmgk5cqISyJHV+rX4jy96wWe6XtrMkmbaW
	r6b5UY7ct1u3rq+yBy9PiCi9onB8G3qOoeQiE+rPCOqbvZ8Cj6GkHuOsjgiDxD3+259V5laYCX1
	ja5/iRmu3u5fX1QECbYfFrs6MJf8VRNAiRm3HDVVRIoGKIB9VxZgAzGOEO+fpxQgEFNJ51LvgN/
	4qtwnx/gzaXvaapR7rQ2t3OBnJkTvjc0suEP9jOZQfa478OhMeotN+N7JYSmsMwNrp8fu5jocso
	RV0tGsJ7AgoYo2sKyc4K7FYkJGlWoiYfWFAT+IyQ6eUXAHVhOPTyVdf+JxG/w5BDL1ZCgt2RyRK
	hipsARePfsVkEhmlnTrf1xmSBiZjbCN9biVoAFdHCBQ67JZVRi8JFdF4doBSVh+kAwGIqePekp0
	JzW0a/jhraoz1C+UCW/BL/Vp0b+ssnV7OKU4BfDptg2uDG7riJKw==
X-Received: by 2002:a05:620a:44c2:b0:8cb:4066:7acc with SMTP id af79cd13be357-8cd6d438485mr1325835585a.50.1773062509479;
        Mon, 09 Mar 2026 06:21:49 -0700 (PDT)
Received: from [172.19.0.48] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a3140d9edsm74063326d6.7.2026.03.09.06.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 06:21:48 -0700 (PDT)
Message-ID: <c7efb1af-3270-4959-ba40-98c315e6bdc6@kernel.dk>
Date: Mon, 9 Mar 2026 07:21:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/net: allow vectorised regbuf send zc
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c151f006cbac6eb51863881d338b101186740cc1.1772493339.git.asml.silence@gmail.com>
 <14f88099-6c27-4dd9-8868-f7e61ce68474@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <14f88099-6c27-4dd9-8868-f7e61ce68474@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3BC4B239B84
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12586-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.971];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/26 7:17 AM, Pavel Begunkov wrote:
> On 3/3/26 12:32, Pavel Begunkov wrote:
>> Enable IORING_SEND_VECTORIZED with registered buffers for
>> IORING_OP_SEND_ZC. Set IORING_SEND_VECTORIZED for all msg send requests
>> to differentiate if the vectorised version is expected.
> 
> Any comments for this patch?

Looks fine, but it depends on the patch that just landed in -rc3, so
need that first for staging for 7.1.

-- 
Jens Axboe


