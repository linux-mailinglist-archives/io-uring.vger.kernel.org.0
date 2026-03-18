Return-Path: <io-uring+bounces-12752-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHksGZAqu2kcfwIAu9opvQ
	(envelope-from <io-uring+bounces-12752-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 23:43:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AEF12C39AC
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 23:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1CF1230263CE
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 22:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2122D6E7E;
	Wed, 18 Mar 2026 22:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sqgRmJky"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D5B262FC0
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 22:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773873801; cv=none; b=V+IoOxiOaaPsO8OhcvAqEzwIhpS6Z5Rn72zaLynSP2hkcJBmLw19AvJmYJuyje6S4X5V0zWonCQieHjgJ7ULRQOeukumoz9DKXC3hp++/ALTDsVMQ+cjrN53LOwJXZbJt2SxHeLyOBhgwizX6GC1fMOGZ7fCsZhm5kECKfjuNvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773873801; c=relaxed/simple;
	bh=toF13UNgVDCRnrlrM2A+19Y2FBb6kkddiPLetOgpOPE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=I4KepBMV4SZK6feYntsuD4trVxHz860DY5y6S0RKxaBHp+DeFIWT4wk2joutZI6lzd3U78EzjgJdZK6fF+q+4LEFfGiDDAletM+Htjxn+DLdOfdpLqlcz6VtUZN8ZoLDHIkNREuLUo5GGusE2TlnEKAJ+3a10CpOAEFroZV6US8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sqgRmJky; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d73ccee442so371571a34.1
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 15:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773873797; x=1774478597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUly4JGtNq+nryiuePILlo++vYQ2CajtQ/EVa3ciyDw=;
        b=sqgRmJkyUEPrZQ6Z3NpCjWdWh2YvaiJi5+K+h3O88oqQ1LeAxfsibvK9nRw9fem7x/
         4DeAHMLuHVqQlbptBiBHMEfFJAWB2pduP6Yhmfml0BNFPTt9Ftct+wJhxWmCiSp1ymsJ
         vmkPiwFilu3iRq1tSkup5PMtNaY+AuBJpXbJHDUtEiRk3/dpEmUbx5tP1lTsnGekmw52
         /uDYVxn9ktLrlF8iZdz1OgxdKAhNa7kQojhlJRT0xSOEwXob70VP8UWkZUncahVGzpPW
         we5M3vA2LYRZpFQE490ZhiEB1Ev/1i/0xiJSM6x6yfwEXLvALUecUvk8MVHmK2oAaFkd
         APEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873797; x=1774478597;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UUly4JGtNq+nryiuePILlo++vYQ2CajtQ/EVa3ciyDw=;
        b=O+lp9qRPOH2DEEsuQadECKg2y99KJYlr64Rwt1VtZhtUHnb9wQsZnEA5wn0zQnUEmg
         EZ6sfZk2Lo0NCVMv8yBv25wb0CI93P/A6SYznWDeRlljRdvdqAT2dlNuMYWLxKPB8jtI
         fm5D5zBDGWzYZFPC7AoT91xzsS12mSYHPxk6aXcHcydX/Q7dlk77OqwPnam9sdBycJni
         qznVHCrKePewKWV7AioBWxdA1BdCp4nxfDiuFvy+jCUWTdA4l3Aow2wdXz2+Y+sbCXoB
         n3cOEXHlP23X4BnmkufRWki3Be0fNB09XuR+ef7KOyZ0TGW1v712DPw/em4XVQeMDdsQ
         eIaw==
X-Gm-Message-State: AOJu0YxNaxwzCjvfpds9Wck4j5f99culE+ERCimbp2APpNIZJ/5DGIPC
	TYUuYdM74kGdKyKjfUABpheYpHHicMlSZ1pndtuUmNUKUGHCktoJH7PJu+YOG8/RYTQ=
X-Gm-Gg: ATEYQzyTQ3+lFz8hIdCsteo+B/bMCuW4KEvL9BE2neETnALZYTUUpwPd3/JWY2RdnCD
	Ar4BvtRNb0PgRhKChfFHf35xPu2kJK4zJKR4y1Ql6pJ3jEnjzl7IEtwUxU1TJEzilIDGicau2Qv
	FgdKE6qR6vp+Nt2sp9eQtwY7z4KTpd6EYRnIWVH4cMIoIMiKN7TdMa5pinrqs6esMx4ciqVGB9M
	sYaXkhvz7XzyQFkRD4B0g3dVD5DGoglqz5zhJPRW1P4sldW01bqJBAKFkvc6OzkcDFi+M5TzaYT
	EDPPhtHNZApdm/YuP8sJiLbFDjL/SBP8T30DkY4/5FTcsVgJauLGhGRaEedZudZ5qFxAv1Sx4l+
	jBzuKtoZma7BwaAYMY1ndb9+3l9T9gtJ+1SrlyET8JgO/PmgglfJ5RgpuL2B3CABJb4QTWC977Z
	N1t3znAY8iG/8bAqSW2CmOWkyjPGuBtNaJBT46xswvkz1t8OetO0SW4Ob4mAKJj0ThLwKd35yT9
	LkA
X-Received: by 2002:a05:6830:3591:b0:7d7:d30a:a31d with SMTP id 46e09a7af769-7d7d30aacb8mr2155941a34.15.1773873797615;
        Wed, 18 Mar 2026 15:43:17 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7c9950d99sm3151560a34.6.2026.03.18.15.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:43:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <86e1f8328bac2a01af16139d6ef954eb0e1dd4c2.1773867669.git.asml.silence@gmail.com>
References: <86e1f8328bac2a01af16139d6ef954eb0e1dd4c2.1773867669.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v4 1/1] tests: test io_uring bpf ops
Message-Id: <177387379335.14019.5816738194713909639.b4-ty@kernel.dk>
Date: Wed, 18 Mar 2026 16:43:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12752-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 7AEF12C39AC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Wed, 18 Mar 2026 21:01:34 +0000, Pavel Begunkov wrote:
> Add some BPF struct ops io_uring tests/examples, one is issuing nops in
> a loop, the other copies a file.
> 
> 

Applied, thanks!

[1/1] tests: test io_uring bpf ops
      commit: fd8a6e66c739f3d47ee25688fd6f7d969512700a

Best regards,
-- 
Jens Axboe




