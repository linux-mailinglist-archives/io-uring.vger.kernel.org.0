Return-Path: <io-uring+bounces-12494-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEjIHRw7pGlnawUAu9opvQ
	(envelope-from <io-uring+bounces-12494-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:11:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D91741CFC77
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5ADB73014C5A
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 13:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8078D3242D5;
	Sun,  1 Mar 2026 13:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yKgm3ITo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521002773EE
	for <io-uring@vger.kernel.org>; Sun,  1 Mar 2026 13:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772370711; cv=none; b=T5/iOOTpQPCsugeBmVBF1oWAHzLWyKWu/Fn7fhK9i2W19UZ1u24aMuigRwjXx0Bkp+lyCg9yY7+0Z9umXJo1w6i7xAkrBk07SefD7Sqepf37KGfvu0tlbZoXyJdaIl+e+TpxTxNMShepeo0bK3u0IYZqrNE20pqm9i8tRkPRJI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772370711; c=relaxed/simple;
	bh=gNPl+CytbDfcTGcrtIVKvy+8SaLX+/Viq3b8/m4t5Jw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjgs2pAwgo1q7AhyygVeI/RaT6lITbL8F5B/M8FSMf3i18//oww6UFpZRF1gCkYJ3W67GnscApHseBrAzm+SmUvxafyFpiEhTb01G5s4GTfkp66uMzKmjOAV3oDqU4xTCHnIJeniVvab2UEPNeFJTdfwnLbAB0OWqTx5twcpPFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yKgm3ITo; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7d4c7d04890so3286934a34.3
        for <io-uring@vger.kernel.org>; Sun, 01 Mar 2026 05:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772370708; x=1772975508; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uBnlKavVO/IBWG8rXXLbV/3NfGhe2CzEeysb+jALimo=;
        b=yKgm3IToDM+O1nI+RKSeOoSGtmSGbUAcypvd33HCLKKSdcIAs7ozLeCi+m/WXNQGX4
         vynyYFkJPp+LhbA8gkfRFQghdwwQiTnsf6pOEIyhLEtfxSb4J307mF00/2GgO4DOlbY2
         3Ah1y3aznvHf6oDKv1qzT7+SY0FtqO/1e5QuHgO47u5oEk/oQrYuKJz4FclR3u/kFsQJ
         tKBz0GrIb2cv/rcgdff3waQ7UBVvbTX0wQ558RvEVsBKUYm1HSS4n9sFSUJYS0tPuZdU
         m4ekmzN5PvLvf5Ja1ku9G9T51tnBmDPDeBPZ6hdxwsEQoOuUpsy45mmNw5KBieBSSC3c
         RAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772370708; x=1772975508;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uBnlKavVO/IBWG8rXXLbV/3NfGhe2CzEeysb+jALimo=;
        b=pngnpk6Z+guRG1hRkAdyVC5DosMQHc58FpuWebeKnPaC9jPeCBRTjS1KMhtBJhDwFy
         GCUaqRUZzCDJaPgqAz079m+CvJMgIEPcYA+qN4CG8QuxNWgroaCrhe9Q+ffm2aPZ01z/
         VoMszxKV32T28Bw2dJorOlfQQXfN7VQC17sDJNmvJ1iMGmViJHtUScnm3FE/cnN7BLck
         I03M58CuRhPHZUyuhUWWge4aA17x3FfVuiB9b7kf3hqxNMwLjf7z2iYQwAG+73U7SZI4
         0yy7gQwZN5uxhauL7xoHcKiELWzM0mzlo2yYZ+5uVirQffJcpmVwbUiyvPEA9dOau66K
         JaSQ==
X-Gm-Message-State: AOJu0YyNKa/3xkF4XLcnyK2AwUaVAu6O4uLnlKAMr39y7TB1SqSsGCoc
	wflYXCKDmb+z2Wmq9iS0m+vJP9v3jY/1QvCqIwHTlahXvPbv7yTyi74ugysWRS9iJOs=
X-Gm-Gg: ATEYQzxJfypYGWd3Mf1haLPysI/tcSjIFhsOwPClesB3lj8WzAlYfHeYJ4sGr+dyZh1
	pKjDUsialqiXgSZlZs0MwB3JxZMNJhGojz2VqDg2P3qMDbBO4ixIrhI0gMXXibsg+Pjq0DFJFkR
	NAVirhUDOp9AZXTCmxAoNs+yUr+0jmn05w2fVBRMCA6HA0cgh1RFTTgK8WqRpCwcaULoKkv1bbY
	GtW4RDFD8SJXAPD3n64mH2KyK6n8hzz4JqA4BgMFyAxE9g7WftgitxeQw6asJmytWQwPV/6lCSu
	5sF/LTNjNqbNb6sGepFwx77LSBBeHO59uMlKjuhiiTbjmqbIxZIks+C8UnWJrf1Lusu+iK/uGxs
	bkn20lKtkJHwEL67Zekqlcj/kf0ImfbyMnmN7NdQwVVjRN7b2oMB9r0ykmbryc7UHHsjixUJaoZ
	5oyB1iwSohiBpv0nxkq7Ap11J8hmrw4p4UqltM6HyS3dw52u15DNcXzjyQu3SC3uDrAfXvA8/Bm
	sFEituFYw==
X-Received: by 2002:a05:6830:828b:b0:7d5:1101:91b9 with SMTP id 46e09a7af769-7d591b1b8b5mr4875661a34.2.1772370707983;
        Sun, 01 Mar 2026 05:11:47 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5998bc31asm4541150a34.23.2026.03.01.05.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 05:11:47 -0800 (PST)
Message-ID: <39cb425d-f456-4278-b868-591a76fc87c9@kernel.dk>
Date: Sun, 1 Mar 2026 06:11:46 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FAILED: Patch "io_uring/net: don't continue send bundle if poll
 was required for retry" failed to apply to 6.12-stable tree
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: io-uring@vger.kernel.org
References: <20260301012409.1680931-1-sashal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260301012409.1680931-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12494-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D91741CFC77
X-Rspamd-Action: no action

On 2/28/26 6:24 PM, Sasha Levin wrote:
> The patch below does not apply to the 6.12-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This picks cleanly... I think there's something wrong on your end.

-- 
Jens Axboe


