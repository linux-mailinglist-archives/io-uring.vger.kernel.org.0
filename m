Return-Path: <io-uring+bounces-12495-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHySG0E7pGlnawUAu9opvQ
	(envelope-from <io-uring+bounces-12495-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:12:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF811CFCDD
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:12:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F1FD03012D0E
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 13:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9D532A3FE;
	Sun,  1 Mar 2026 13:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GHMM1UNv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4242F329C5F
	for <io-uring@vger.kernel.org>; Sun,  1 Mar 2026 13:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772370731; cv=none; b=oZbQpfgcUK407MJNuDR5Jp/8YM6vLIiOsr69nNBTyji6DowjMSVGIs+LsodjkazU1Mi2y7mUfbS7y2tvtunwrtFU4mFL7AGJhkeN3E5dTTGuqpzRRc4xxbTfRYwom4G0QMs37ZiGvO03eBFV7+NqLDedxwPTQj2lWl6g6lZKD8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772370731; c=relaxed/simple;
	bh=MlVygYZYrbscJdDC8HuuuKLYr9scb7+Jq+Fj+Bx62KA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fc5P9CwYvjljN4cchX6XX3JpkP0C2bQLZhJ2D/DcKe22AwXjGFxgBhJ7VZcAouZY7USln60tG7yUboAXF7Kj0ecNHgvvWM1pUr9GLRupuPMh3UXtYNCfnRgr845uN7Gm1Dn7nOXqyQ4V15t4ewjAh5vGlukfhkihwu6WMbLTH80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GHMM1UNv; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-46391e91e16so2494330b6e.3
        for <io-uring@vger.kernel.org>; Sun, 01 Mar 2026 05:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772370729; x=1772975529; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kCvJOMmu2bMgbLp7gSD/8r+xSOB5QJ5BacoeTPG17rI=;
        b=GHMM1UNv9Y1fX+GT8DFK3hWOs9aeyUNLO6hKLq01p59O/ecf1eFrh2gW3bggDiICb3
         DrdEgwGq6/UqKhtOrL6JJojC2rkt/pGQzBAoJvw5zFcKMOhTSDHL96VgOAXUIL1hUvqm
         S9y8oPKhCbFm2kuLfLO3C9uL3KAgFPWsrB0dngKC/0vDVWdcMRdcaxSUu4+zoRHFhCgp
         70vASeNAnQu0huOuLE4ruKB0vE3MDYy71SwDH3Kh5I6wQ9nB0+pxsDF0VX3bRxs4Cpyy
         WEOfh92y2hFIMrP5ig/SdhCeToX3VNo/wHrTLQ/0kjmWqiHJJnDsk7ak5W0Zx3RD4uAZ
         qw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772370729; x=1772975529;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kCvJOMmu2bMgbLp7gSD/8r+xSOB5QJ5BacoeTPG17rI=;
        b=qzbj0aA8fN58qCKZgRMK4rpXAOgNbD257ywOppARyUKmWjJ0QTIl6y2IkJg0RpO/IC
         1MEsY3WU6Qq9eaDUBT3UezYiyWY/ajhNMKUCMuAX4Nrj2mBCPOYygQINwI39xL/EwqeG
         LCgllAjHlq7VCJ6oNjHmWy/OXSNXB8vvvoo4K/QRB5eRwJJePB60DidSoGZUV0sQvTZ1
         /D3LRhsIBRLsPrpbuvsewcfvfaZVQIIUjTGsFSOggsfr9EG+Pd0e85IWRH80vAcSGquv
         CM4784dQ/tQGMN8ETer5zTTzsLVQo6uD2G9g7q5QVyk2YED5j4RiIrcv5pVEAm58vCIx
         ZIvg==
X-Gm-Message-State: AOJu0YwQZfyzylNk2o86QxZKokKIqOV5AoXHdRahOj+DjrprdQv9+ofT
	9wwtzbhuhMlebARju3RxfuxOkUqSdfmuWyV8dTRfwXTh1/JLOYTMsjvhJxweCDxomuE=
X-Gm-Gg: ATEYQzyw6zfYqO019Fh3yg2mn3/XCAONgVAmpdel8TUwRGJWzlIM1M14pCdLbXOCoYu
	u7DQgzTrqwM4Fj3vmvmktSIlcOQE+SudJfWda70m+lDA+CV/AKpgXsO2teof1MenL3u24t0ASpe
	bQ7Glh3SgdRFwmpIHPlN2NrTBS0uVxkprbafvaLBDuFj+8rpOTXoklvyuGHF+VYKPbEnC3JmIbW
	1mFCfD6Sx46ntKobUmUryo8tv63eQuPQwH/LVYsKc18HWTZw/Zh71H3/+MY3FJADUVE7x8iPUen
	NoITPbG7JyXjpJOaRZz1Py+AzBlI5ngAE05oVm/VaSEcvN7sA5KjnZBqdc1BZPz/qj03bsfYglh
	K5zvTvzhtkqLqBsxcNpFvO8K8adiwfX2dqDqztt8uHVV8hlVbUGaIFmRQvwJFMwcBu0VaXXvh6H
	lfdgZLp4o5KYs6CNiBZoOjIzFIqdVJ5/7NBnDC8nBT4fcvumuWj9NNiE7zLq0wS8xkZtc2jKDoo
	UHLHIaSjA==
X-Received: by 2002:a54:468f:0:b0:45c:916b:ef9d with SMTP id 5614622812f47-464bec22928mr4190060b6e.9.1772370729194;
        Sun, 01 Mar 2026 05:12:09 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59b66fsm5691144b6e.10.2026.03.01.05.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 05:12:08 -0800 (PST)
Message-ID: <05974693-8995-4001-a8ab-51835488bf4d@kernel.dk>
Date: Sun, 1 Mar 2026 06:12:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FAILED: Patch "io_uring/filetable: clamp alloc_hint to the
 configured alloc range" failed to apply to 6.12-stable tree
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: io-uring@vger.kernel.org
References: <20260301012807.1685821-1-sashal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260301012807.1685821-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12495-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 1FF811CFCDD
X-Rspamd-Action: no action

On 2/28/26 6:28 PM, Sasha Levin wrote:
> The patch below does not apply to the 6.12-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Same as last one, picks cleanly into current 6.12-stable branch.

-- 
Jens Axboe


