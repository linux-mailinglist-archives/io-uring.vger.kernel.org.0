Return-Path: <io-uring+bounces-11863-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SBFtLx0vcWmcfAAAu9opvQ
	(envelope-from <io-uring+bounces-11863-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:55:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A6FE5CA20
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7C7E0806EE3
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 17:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D83840B6C7;
	Wed, 21 Jan 2026 17:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bK4dhh4E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC0C3D6467
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769017286; cv=none; b=K5btrIdolDdU+7uEkr2AHMlReKTsComuPxNTZjx8tdPaS/MAMdyOIESB1azUL3oS7uvBhnFB+cnIeujFMkjV4xI+5Ru+/R4siBAmJFCZixoiBU5ESvhiwpt4w0Lsb9eAURlxNThQiCh43QF2KHrsMObXVhYivMyR+9rhIwJRACw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769017286; c=relaxed/simple;
	bh=ng3YYG1mFw4mzT0r770RjNHUXRD50M08l7zKz6iqzNY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=NYCtXcc/+3LEcflj8gJXu69WzST1i8oPcqM27AOJDTlCaqzaWUO1wftffQZu0KuL5j3HRfIYHLyx2E8JebhRSML6DwpajEGQfPvuK9YkOL6JTP6vV4DZtCasLR7aHWaRmSDLBxS76E+uIo9TH2cRrGNgIZbasrBi3jW3sJ6Iuqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bK4dhh4E; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d148ddbb91so62804a34.1
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 09:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769017276; x=1769622076; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ju97w9v70KbcmYPTQs00t/qPQsFwm/LMevN79ftATQs=;
        b=bK4dhh4EE4LlSuUgWtaZpmC3zzrjgAvwXmdOP0Xo/RlLYXaJJM4NcxV+YEN9h2fhQW
         kcfmGQdh0G/0cN6AN3KAYEkmJDL7Gt9NQXL7fAWeP45+ork1DaZt3rXKCC/jCmk/9nkB
         KR/veF4M/fd6k3HopH5xwbJzipA6xeCLFy5epLDrtWjsVowmNtdQzJIIxEX3u/n+Uy/l
         P/0uF5MaAfDCJPpdQYMHEvyaBxKJjBMe3SaMJ3prfVeUQuteNz/OhaNJEoTGoW0NTNtS
         koO+uuNOdiigk4pNBKwUOsY5P7uz6TmxKyE7g2QGKBU3a882K+kYNSrpJ+WRB/xJp/jG
         EsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769017276; x=1769622076;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ju97w9v70KbcmYPTQs00t/qPQsFwm/LMevN79ftATQs=;
        b=V15Do1eMqUD9xzvgKLkUb7+ZKoINbtHgC7GmEO5RTD9ifbFlUdazCaQDfgnyFXSkWW
         vGk3oZ4gPZFWDZvpC2TP81n+hzDxafZGJ3/yuBKyv3/EX+r53Soml5RtAAj/hA/ZShLL
         bPD+JQtIQMbFiDdyxJsEqy/K6tdTxEDl87juaTvL7WV258H7vMPbM25Ks/sgWxzEEbND
         s0ImpAq3V7mifOXZo/+yrcyfwQqpnMiPkIuJ5l2nK7paUqMz5aWjibuuTQ6Fif9L5GeI
         AIa7u1txbKj6UkpfRZH7CF7V3wsjqn870AAyGp+GV33biQM3mhD5KnO38NtUnJndYowI
         rpJg==
X-Forwarded-Encrypted: i=1; AJvYcCW99FdU10Z00WvGJP4IsjPE1EMtKTqKf0op6SWGOO9VzejUCSOU9ePIGlFWLPqf+kiq6wuXKjl3iw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy49Xslbq55zaHdEkEgyTxaLamp+Ga2mVLxaBwSK4/OTX8Rfm4q
	RdQ+1BEq4bXSt+lM7eWLQiu1G/taZuD1MZjmsSPh5UdpRKeNeMCSSe2P4aPo8pz05rA=
X-Gm-Gg: AZuq6aJjueW4NfU6LN3EfKPkzOM2UYJJ/FR/DLW8BSY/bfkoTnrTGxkqEbPIja0u16c
	QHX6F1P+X3Zy4mKTy4Qed92tF/1LTCAZ3b20ascHgZ9uuMhUtTN5go6xydZdqe6WUcHo0MyXq5W
	ryMyR0bHKWxPCVZBPuOqyx+AUUS+WgNM5/DILEFrN7Trae4XkTk3sxDIAfC0zcJgf8g7Gbm+7TR
	jsVoAdyne62ks+miEj9zU+h+xHw2qRNEoYggduvBigbwoJIW3EsPxPy03rV6aff7PDX9lozYbLZ
	1coood5J60TNtXSJ5F8j34qVKBxcLg7QMK6wwIYCmhTyS7xc8u9xxOFMllWFzJ29ZpPiHMofiBo
	ahV/D5wL4/GP+R2kwNiXQFCwN2xkStBC6/xVTJPUzEtvdhwNdamFS5+bJgt6nce4Yflw2OdDMYT
	M5NYVoeR7tiyO1kjIu1o05boncR6LmbZ9HhneGWKOqL2XdWA5rzwIKGf/u9WEOosy3R/mZ
X-Received: by 2002:a05:6830:82ae:b0:7cf:d53f:bbf7 with SMTP id 46e09a7af769-7d140ab6d02mr3664449a34.24.1769017275976;
        Wed, 21 Jan 2026 09:41:15 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a696esm10730191a34.21.2026.01.21.09.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 09:41:15 -0800 (PST)
Message-ID: <b5482f88-8bd6-4683-bc1e-31eb3995ce26@kernel.dk>
Date: Wed, 21 Jan 2026 10:41:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
To: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68a2decc.050a0220.e29e5.0099.GAE@google.com>
 <7aa47c41-df51-4a9a-b021-866ea1bacb7b@kernel.dk>
Content-Language: en-US
In-Reply-To: <7aa47c41-df51-4a9a-b021-866ea1bacb7b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-11863-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring,4eb282331cab6d5b6588];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 6A6FE5CA20
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/26 8:04 AM, Jens Axboe wrote:
> Just to wrap this one up - there's a fairly lengthy explanation posted
> here:
> 
> https://lore.kernel.org/io-uring/937c3e38-368e-43eb-9d7e-2dcc0697799f@kernel.dk/
> 
> which details why this isn't really a bug, it's just slow exit due to
> the odd huge reads (and number of them) syzbot queues up with io_uring
> before exiting.

Let's try the syzbot special work-around:

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest

-- 
Jens Axboe


