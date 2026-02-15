Return-Path: <io-uring+bounces-12215-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KWPEkU/kml8sQEAu9opvQ
	(envelope-from <io-uring+bounces-12215-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:48:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1D813FCFB
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A6C8C300A13A
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 21:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0A71494C3;
	Sun, 15 Feb 2026 21:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SvmR+n0k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311CE1C69D
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 21:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771192130; cv=none; b=hTGoS6IN9cfqQJrk0Rsjk3ZbaL9WViJaID0XvU/fJ5zMhKc+jdBf7Rm5AAxUNvPlHzhWe8CgvaL+N/VSpo89WFAONcfmPAN51CPvgZNuusQzT4YddOWTFNVEVJURP76Pf9sCd3l97waPEI3ribAgw1I0KCLMwiYSaI2mdHDUPwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771192130; c=relaxed/simple;
	bh=OXdSedIeUirTHb9A9jeNMDBad9SIwF8JymEKUC9aPZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ot7X0ASOgt5xhHjIu9PZGll5yZcigu/2cTq2xdBoLSVmWnQBHwVSXi8bGG563byPbV6n4lwbx+mONWfoCrQbB6FLDDR891lwU31Kn8/lkLTRWl7bEyJ0XmsZhPDdMzxKtDd7r/0E6XLd2RH0bwwiUkFe/T+6zqyYmuVKKF8MeOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SvmR+n0k; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-463a0e14abfso1286889b6e.2
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 13:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771192127; x=1771796927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I0/c58hNlRGojyTOrlyFA8NH349rGdjY8YsmkpJVkvU=;
        b=SvmR+n0ko0mSJUwTxH0z939My9GKItx8gXDL/EeiZPgZvFfagygjjVb3zNS3GDW8Nb
         s0/ape8+R2V2sjKfyIfQQIh6vdSsmlhRQA0vop1YPKnzhIJ+u27CFllzTWnZ/6Ayovsl
         8ECBHKKVfbaH4hoGkVlM6bPZV7Xs5HSIMyhCZPbRrhRZSoxwrDVeeG3zlo8tvd88o/hw
         8ywkSfbcpVP6Gn0wbdw0igTMYGya6WI12FM8zsT5Py0BG809HDpoOs6IM/yDRWDVv9o0
         120Y307IU/joyypqoM4I7KFQVE2P7omI0gukpLl2MbD/GgIkbBDkLqWb+JhiSChU42Ih
         e2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771192127; x=1771796927;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I0/c58hNlRGojyTOrlyFA8NH349rGdjY8YsmkpJVkvU=;
        b=hhl+6OBdQYmaYdwyasummHR/LUmrhLb9o5/oVFNUVLG1td6FSDNLKMhiUALL4aeacf
         +ty18hCRB0ompygmkauVyPV/SY7l6ty8J6EOoaGkeR5jJpUArZLz0TfBFLXBtaXnOAvq
         +NDF/ioi+CEhqtE5nXWqOS68mDQZKMOcGoCtfACSKX41E1bQFCkcBA9wI5S/mhhIy9vY
         S9VeJGsqFNxPlIAGYgAlPmLcN2o5vKCG30MQgqpggBTe838JcVj85jMBVdCQaLwrcxsk
         iCCxElnD22vBfDem2vR7c1ovsKw80rsS60tbOiv+LrJRdU4pnnVRAyltGN8Huo9cTAvx
         Skqw==
X-Forwarded-Encrypted: i=1; AJvYcCUb1cP3UdsRf1kDfe4YklzJ6n1MNs2NqKKI4aFzPo7VVXJ1hSl65DWM4sIEIzx1w0qmvOPVIBTZoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ6ZKfQDdKmCdIPdnsRbe3WoAUVOtLBcu/AUtLRjaQ2rhRXZbV
	/aVpn0y7fTQPPHPhlynkW4NP9GqnQYb/UqULOO7qDG69BCCLGZ17Dxwy9ayO+Iooxwkf6BOOjtW
	nJBJHuQg=
X-Gm-Gg: AZuq6aL/fhzkzF4YCOjtQMLJvKpllXgZ42zNA2WQ1clrlxziYQQsqUz7fDTjnWrt2wo
	kIwr/65GwxjY7Z1EQnRV8WENgqecUuuuRcqhUoiaq34UprGJBPFLpi03+qrw5bNXztoz+bDCNaX
	53x/u0vFcJSpRBYK8fPlTAgkU0WY2otarZOr+nWIBhwIYSebtaraOT8hvibY0MLjOfi1PjFmIHQ
	8panNHVaZDFAcElr/OZcMwWAjZ17hh0mOB80Rb8Q48o72DTn/6oTBPjaAun/WIA0WdOhujTrsgp
	DRQG7FJxVdK9y1LpdTkqmzAZmO2pg5mPprD5ylB66s+F2MiSVarrWu9YYSC3LPP53wo7ItA2Gin
	oSLEzFB2F4D0pGQ3F9IIKUT5qfYq424e3tbCtS/UAurWMyQ4qwaLPoVMFxzbgamN4MlG72EhneR
	KzhYBHcgbQREUSF7Gb1ORVRU0udzI+2UGx5YQT6M1CkZNIcwsta1ODZu7drRQpICKQWQwyQKfH3
	VB1+D+uPw==
X-Received: by 2002:a05:6808:c175:b0:45a:552f:bb9b with SMTP id 5614622812f47-4639adb5e36mr4280507b6e.31.1771192126773;
        Sun, 15 Feb 2026 13:48:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-463c07225a6sm3126832b6e.18.2026.02.15.13.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 13:48:45 -0800 (PST)
Message-ID: <ed8a3eca-2e97-4ac5-a63e-81563c57546c@kernel.dk>
Date: Sun, 15 Feb 2026 14:48:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: delay sqarray static branch disablement
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <8990bf99bc758c6e033e7a75ea5eb1834dd2f920.1771189395.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8990bf99bc758c6e033e7a75ea5eb1834dd2f920.1771189395.git.asml.silence@gmail.com>
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
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12215-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AD1D813FCFB
X-Rspamd-Action: no action

On 2/15/26 2:29 PM, Pavel Begunkov wrote:
> io_key_has_sqarray static branch can be easily switched
> on/off by the user. Prevent abuse and defer for a bit when it's
> disabled.

Can we get something in here for the reason for why the change
is being made? The commit message really doesn't explain any
of this.

-- 
Jens Axboe


