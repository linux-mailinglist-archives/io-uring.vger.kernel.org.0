Return-Path: <io-uring+bounces-12269-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gPVJDgVYk2kd3wEAu9opvQ
	(envelope-from <io-uring+bounces-12269-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 18:46:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D550C146C59
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 18:46:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 22A323019F1D
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B5D2D838C;
	Mon, 16 Feb 2026 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3EuPR7Sy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF1D1F3BA4
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 17:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771263986; cv=none; b=tnwrAPzlr7nXvashnbGq/pY0+vf76MLslahX6qGWMYdY4mN//o/6ZspKcMBMTFxqf2D8JNqwoTXB+8YRveilnAk+W9dP4arxaMOkACKnlpHbUwUQlYm1JB9GvK5ue+tMHDg0xRRMDyGfPAD2NWvq/YM+zmRz9Xrp8dWNe1BrcuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771263986; c=relaxed/simple;
	bh=wmnqt6V4EY4UPj2AItJE6IyAcWRvZhvtqbsAZF6mqss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RKPwVzUxc938onVkVz2i/IUQ84p0BeLuLJk+bqEBm27rSCbWiQQIen3wopl+dfCnKJQRX+JUKB2fPsmewi/DeJoFRwOs4gMoQN+NlOBo5mIsbs7JFgNdcc0jms61kaQVDn+rlwgMp4vjzVt5IV4JiOer22+Fm3OSeXD5WupOnJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3EuPR7Sy; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-45efd53148eso1044719b6e.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 09:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771263983; x=1771868783; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7IWxZrWC8Uo3jWvVR17QujSDCQCakB8uC2XQIDGeuSc=;
        b=3EuPR7SypVeKjtAH6fpGCcduXW1AUoBc1kBWC4rEt+h43B8m6Jy9dWF5mqO35La4bB
         Q64Y/fRmHqbwY5YW221HxA0WvqOySPKGBOPIXumogbkuhsOtd800NXCXNxKchTutgcoJ
         onXV26rPsPyY1rcbDc6NQIlzNgZrsysPWHTjxHfbeEEtkmy75F86Jucir1gei24UAZ7Q
         mkAscvTpPL684G+hx1lFWUSTgP1y/BlJUIUHmplV2b9e497ZqEzpRWRpL1dY88X9/7pu
         zTpuAehJqj9ZohOT/xbJJIuILiJJ82Sg3euzTVomrgjsYn7XV9K/mXHxl4MQio5frsGt
         7X+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771263983; x=1771868783;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7IWxZrWC8Uo3jWvVR17QujSDCQCakB8uC2XQIDGeuSc=;
        b=iBv4HcTkrEQ2Zj383ihvGdubfOiPnwTaY/S9BFWDzlscr3Jt9YUsDamLKpzAdNz1g/
         /8dt0bDRJ85xPFOV2GD9duD3rzCmO2ePr/YV3Xi7718Uu3LvcCoZ7ybPE4M0iCCRlh17
         kKjOH2OJCXd4HiN4ErTstKorh88r63noOJVe6QlX5IRq1/80mdQ64TCVWtIbUR8O5MOG
         pJPUykNKQ4jzvU2zvbAIh8o33t6M49tXO43D/XeNhm59q0zB1FrKuu8LSTkEgch6+uFn
         9uO+6KcqXaD2ZYaaE4lVTs1tuHzKfAzN1iWxHNOvXIIBqqZn7+pxyojjHRSLkwnlRJzY
         kpnw==
X-Gm-Message-State: AOJu0YyuWEalKtlNmq3bNcToQlwBcrOcHa+vkW3OjAkNi8AAg8R7TcQr
	PsBFfLQrksPd4wcP1RKS0UBJ7qIU3dlXVBIugpFup/p8Kgfhz5XvfCoUni/NoJZ9IcY=
X-Gm-Gg: AZuq6aIAswXOYEfsX+bnKuSQjGeDYid2VPtXY+FbSySqtIcWnoP7ZiQPXqOHHmmFg/V
	qzBwdQsoIN3wNa4j2+9jACB/KSOgmF3AHL7uzNfQaNeqvJJS1gvCDmrBIloRtWDfrAD3s0lT+ao
	NeKx5vzKEyqe7Vq0jm4yWPa9d6CXZk8fetgXqpqc/QlxAfn14PySezN36IIIEmhbUiaUGFsoXtj
	dM27zGkHyz8Mja4k22EbSgiGXWlLd6At+JIAcg7VPs30vwKYZnpuui+dOw/Y94r2d7Uz4nxbmZv
	hxTJFMe2fWCxVoe6RQm0RPwPVpLqmrwLnVSleaNpmHafNV1V58A1eFK1Y19jwNcMKuV205TpEc3
	C9j/rqrlNTAU4x4jQff7YsZWMyII/9qYC3cOX9Am3+Vf6i8UXUpmCUTB2H1tpD/OWb+zRaNY0vo
	fMlll8VJdR1Lq/pE7tP1pe+Bq7+rcwv9N2jMfngbgBA5T7kgCmXM55KQuqW18tB2CA92E892lso
	ehkp7T1sQ==
X-Received: by 2002:a05:6808:1455:b0:450:d056:e0f0 with SMTP id 5614622812f47-463b3e6749emr4411991b6e.2.1771263983352;
        Mon, 16 Feb 2026 09:46:23 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4636ae901d4sm10773829b6e.2.2026.02.16.09.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 09:46:22 -0800 (PST)
Message-ID: <5bdb3ec3-8b25-4021-9d99-f866c4fd588c@kernel.dk>
Date: Mon, 16 Feb 2026 10:46:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/cmd_net: split ioctl code out of
 io_uring_cmd_sock()
To: =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260216160354.73239-1-ast@fiberby.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260216160354.73239-1-ast@fiberby.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12269-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: D550C146C59
X-Rspamd-Action: no action

On 2/16/26 9:03 AM, Asbjørn Sloth Tønnesen wrote:
> io_uring_cmd_sock() originally supported two ioctl-based cmd_op
> operations. Over time, additional operations were added with tail calls
> to their helpers.
> 
> This approach resulted in the new operations sharing an ioctl check
> with the original operations.
> 
> io_uring_cmd_sock() now supports 6 operations, so let's move the
> implementation of the original two into their own helper, reducing
> io_uring_cmd_sock() to a simple dispatcher.
> 
> Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
> ---
> 
> Jens, I'm used to net -> net-next taking a week, as it only happens
> through Linus' tree.

Looks good to me - since this is just a cleanup, let's defer to 7.1.
I'll kick that off in a week or so, at which point I'll pick this one
up too.

-- 
Jens Axboe


