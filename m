Return-Path: <io-uring+bounces-12297-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eCj0KXaTlGl3FgIAu9opvQ
	(envelope-from <io-uring+bounces-12297-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 17:12:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 02EF614DEFA
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 17:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F7E1301778B
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 16:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884EA36D51F;
	Tue, 17 Feb 2026 16:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nIdHg5XN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA589265623
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344753; cv=none; b=ZlFDMUPaskPtyMDBW02MntTA4bfz+CllA9olDAR9lmpnwLnaKrXosIQkcX02wRfb8mzRkXH6hAHJK/+zKc6wnUZwF0g8S7CJUTCs4tivfhl45tQZjPXwuQ7MgP06zkI8lvwEhDhbr++wbJgYQ5617W/hXgetJbW1O6oxzlMtGGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344753; c=relaxed/simple;
	bh=MqxZpUyalWDJNzgo0WngMxHy4eila5HL5zvFR6EvPR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kcQdkNoN/Ufdj2zaJrvDCs+NGE4CP1dgVPiSIKDUPMIjum7oI8VaBo6g8VcmhQ2y8lcJO/S2jPvMZ05tf/3mDVSP9Qkyoq/gKuv2rvQmL9hofsHNdOfFp5D31zPRqi5CyDWETDRxpzPHBCXQ1dZ7h2S+fNJ0j++8mLloEfgHJ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nIdHg5XN; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4638fe85a7eso1019619b6e.2
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 08:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771344750; x=1771949550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T2/5jAjNDtEUE5MD+TZFaHYaNQZZv4r4j1SEEXToQXQ=;
        b=nIdHg5XNwyNwaG1cpQnqF+h2fr3XwOdkIygET+QSYTxAjWHEqwE9s6aeoPjS2pT7Mj
         BS4SKJSPpaxXQwKgTzFVcEKTv2beBTZMKJSFnOqV2bLKWDmZztuWPGRGZa67A78T0fzk
         qRCe7TmdLWu0t+806NP3wOPG4rDiOoLO4aKl8qwkoBuqhjfMaG0IQLHO3R4c8DCWMSA0
         A/HJZDC5sJi34t/c6TUbLEg7TCbzaC9tAdeB8UGCRyuG1yHQqqVuCPidzWHdmmkNSs6M
         LtSV3VocfPZk/l2NrNBzG2v7Nj0pmtWWdwtPJmB8wmQpKpzZm2LvIRkhFrDttI1YbLZ2
         XHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771344750; x=1771949550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T2/5jAjNDtEUE5MD+TZFaHYaNQZZv4r4j1SEEXToQXQ=;
        b=afppo1vkY0W6drFkMa3/n1lxzbL6FdSS2gEeygDJ4Lkjuuy7r+Q7dJPNhkZXRWhFRN
         bDgc+brvTasao81fTmn8vHwtwDCwRuZFTYo0IqRODCOfPmXmVXsOagJL+veFTcGMaI14
         QVV495lP6LgwvBoSQPKnPdpiBGhr6nbc66O9KnL/kVhD8a9B9OFYeLJMWwMZ9U/GB4Nr
         +XnjqiQ5I0zh4a4d7AHwCrQFheYfFhtGh6ZtVu+oMNWBN5RuipqbpDnqG+p+J9My31eu
         AzYjds+cPf3CpWgnW6CaH3Ru9kkt5qzHmUafmRnFaJP57LtoQNFvsr/ER3w8ES7SwK1j
         z0bQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnW7ir5tKV4IxD1xvMeVUg8bJpKo/SW2QmpwGcNuGDdk9SF7LgUvOoEZ619saF48wihvbXXNDuZw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0+k0xbYhb2cdgGM0N7SgefmiJp8404a+1PsGK4M9UbOWu2SkN
	cG9mgZbmA1xS1NzzM8Gr9rohwXVP4gyfVLw66z31Az+V33I7+2ulvt/7pPYZRQ0HSnvl3aXyT1j
	ORJuRkkU=
X-Gm-Gg: AZuq6aKWw/9wnjg6EWNFsZ03yyIroE72u6J1F+62CuGkY51/1h5uEQipcPTOpXt1FVc
	6DDAX69BL+XdCE6O4QVnPJnWDoXkS/S+GzVExxTiP/+Lt1T0CjyA5vxyzy61FoPKPZ4g1ER4BZO
	VjyL/C2rcQ8Vj9KgLNDObg/O0iU27zG4PyLiRI5ve153CUgmaMxcWFHznOkrG8NLBQhOp1pjAkd
	ozL4FAB15hDY+csy+QP8UDaNXOdvf2zUBY10ht63FUXFZQdwsN/UhHbqY+bLux8s/cZPRJtPfWH
	5IMSOyN2uW18ooRc8DDqbo097+5xJrPRPLZ0RXqRseHYap2D6WUyT3aHjvdfUuX6PV1uQ0T3zNf
	1RnsKDjPcpm7uupjHRg4MRKicX/qiF7bDDilHhq9ph3LFQbBf6w8ZrmhRE6TTGzLHpvbfliu8t4
	7kJtMGBheCu1g3GSXd3A3I6ugsExODZLDBfMJ5u0s99rwZhpTD8FtT7B4MEzAfS1g2p9rUwJWAL
	05i+zrc3A==
X-Received: by 2002:a05:6808:158a:b0:462:de55:9d40 with SMTP id 5614622812f47-4639eedbcfamr5290811b6e.3.1771344750493;
        Tue, 17 Feb 2026 08:12:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-463ee1f67f7sm2775988b6e.12.2026.02.17.08.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 08:12:29 -0800 (PST)
Message-ID: <9289e38c-1528-4029-a278-bceba6607697@kernel.dk>
Date: Tue, 17 Feb 2026 09:12:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC io_uring review-only 0/4] zcrx mapping cleanups and
 device-less instances
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <cover.1771325198.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1771325198.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12297-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 02EF614DEFA
X-Rspamd-Action: no action

On 2/17/26 3:58 AM, Pavel Begunkov wrote:
> First two patches move user memory DMA map creation to an earlier point,
> which makes it more uniform among different memory types and easier to
> manage. Patches 3 and 4 introduce device-less zcrx instances
> for testing purposes, which always copy data via the fallback path.
> 
> note, based on two other recently sent patches splitting out a uapi
> file and defining constants in zcrx.h

All look good to me.

-- 
Jens Axboe


