Return-Path: <io-uring+bounces-12402-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPNoKR/vnWncSgQAu9opvQ
	(envelope-from <io-uring+bounces-12402-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 19:34:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 086B418B727
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 19:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC05B317FF61
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 18:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965B5364031;
	Tue, 24 Feb 2026 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LGmSI8NU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14762313534
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 18:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957688; cv=none; b=CCbCrXaXDWXt3GwnZBRafVQE0tSawm6+Wawl9uGsUVSWDLarDbpn24JWYn6aQ+eVuA7khRJk9+id9yujq7+YyabJn6pb3tjwCo4zSaeMB+TpWq1U2yYN6ETSisRDqPIxmaSWlk1TQjdslodhpKMTbFc0QWPzAvp3l7Gfsa4qMCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957688; c=relaxed/simple;
	bh=Ll/Jlmb6aXfKjZcYTyZYyCu9fdMtrN31WfUCtsStL3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KvgcFdzSCz2KKGH46jtkkv5lVOyuK6KUQm/7SJP9JJC7rqtQDfC/zzGG/03Wm3f/m5l06uaRcENS9hDhLjxpa274eHRwn5mABG3htM5iDoKIlH0mtRpfOf1PFWYJuOykgsgwPb4mbxicxggB5Czppw8eB9SjgwmgeCp3aAfao34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LGmSI8NU; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-45f18e8f2f5so4136955b6e.3
        for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 10:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771957685; x=1772562485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wroNY/rKBwbwTfCYYdbsRr3inCV0RQgBggPsPHKHJK4=;
        b=LGmSI8NUQBr5E1/0ny4EaohJApOoBSDBurC/2tbzuxQt66oIM9213PElOM0NYve5FU
         8lND23acO3u0SAe1DowQq8MwJ3kZmaWuJug7P/QRQmNavvmPgJ/ntS0pSnvlckU/Av0L
         faf2sUJwZfK6zLatrI2+FLyXOhSBj8OCjETknbdgJjLILPZi8v9pFo2dV81KMg2/7qIg
         nnkSBD62/z0FQZfFSR0aXcZpLjUs21JItdqxhPD6Xtgvibawh5he+wzkCF7nWkGak7yP
         9UbDzneXTjFSDa3GMjwsVl9nbyqyQyamVNztJFvkfXsYMVn9Jc1TeWqPsXC+Oj7wBCnp
         1Crg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957685; x=1772562485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wroNY/rKBwbwTfCYYdbsRr3inCV0RQgBggPsPHKHJK4=;
        b=bZaqJsq5Ro535iIHoLDQ71Nee6x3/tfor9/JLWAdQ4H2DV4ftYEB2P/OeO2I4bD/Lz
         Rnb9k7NAcgfbEnnpFhW7MSxGOJEhLnCFP9MLIV41bOEr065+cG+wtwvNohSXanytgydE
         uAWSIfXdw0emJw1yMT0+H6iIBkjrIX43DBRNp9BCoNV40exkqAipgLx+4hb+RFeXFbnS
         6dV4mcAk75J2QWkVYf+0RydvNDtN+aLOJ0ZY6Xv/9Vwvw9dv7nQrAweWp7YsGrxUOE44
         PBSOS0IO57JK/C9t4SRvMovm7JDbcjOjoBPDHWuiVyFSIn4FPtsabD/Jsal6Ppe7orp+
         vWlw==
X-Gm-Message-State: AOJu0Yw3sojpr311y+Y6rsmehNISFH2M+LxbeUvfi9jx5suEV+30ejQe
	kzYNKHxHssKney8Ki1qmNV0c5u+M3XSO1AhJNtNrZF2aLoD7agOUUyyws8O27Yf94oNcGxqpNgG
	SmYmkq0A=
X-Gm-Gg: AZuq6aLCjKv3YHCiDjgIVFi9OeVg2mN3Qzbl2HyGlW7+OVvJRzPd2BWYs91ebP6FwWV
	lGvHeN3csKL8vgzS+GLdOcIYZ4dVej0CJCbTENvS+7LjoLNNRJwp/fsbS4OmX4R+vrTDTQ4h8zC
	i1ArzseTVJwJhuqD1R8yH1D2YJJf9O7+uecUChrqbaeXlBL53egGzPdWAJ0gdIn1aNz22ieBUc8
	1KBUtt1ebayZwfbRZhDOEDq+yx2EGWpqtl7fnPmHNzaX77ap2BFFdDnlG8XmOf2cUSdB/rU01uk
	zD+8eMwXMQF+gRVDj+lmuGC16yUyeGGhPoRKL3Valmu7NBXP9EHqc4uwRkoLkjba3O/RX8jFBNh
	CnT9ghXvCBQq9eXVLb7bjol7P9fKkUbszTfnemx9+WwMR/Ogy6tywq1p5TGfMen1dTEbUSQrxB8
	LoJDgNFnYxEBWaA7l66uet3ynydE9tqXPFGacYM2v5XCnoqJVxotOnR1jN6bNUFdp++vFhFCnT6
	uoeXhju2w==
X-Received: by 2002:a05:6808:23d1:b0:462:a915:31aa with SMTP id 5614622812f47-4644640b4c0mr7196120b6e.63.1771957684846;
        Tue, 24 Feb 2026 10:28:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4648a4ecf1fsm605194b6e.12.2026.02.24.10.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 10:28:03 -0800 (PST)
Message-ID: <3aec1803-e148-47f5-bc18-c88e8cc96123@kernel.dk>
Date: Tue, 24 Feb 2026 11:28:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/timeout: READ_ONCE sqe->addr
To: Keith Busch <kbusch@kernel.org>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
References: <cover.1771949518.git.asml.silence@gmail.com>
 <8deca9c11a924888d317b4666c93c6ed2e719cee.1771949518.git.asml.silence@gmail.com>
 <aZ3WH6S7TjyvPd5V@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aZ3WH6S7TjyvPd5V@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12402-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 086B418B727
X-Rspamd-Action: no action

On 2/24/26 9:47 AM, Keith Busch wrote:
> On Tue, Feb 24, 2026 at 04:12:10PM +0000, Pavel Begunkov wrote:
>> @@ -557,7 +557,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
>>  	data->req = req;
>>  	data->flags = flags;
>>  
>> -	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
>> +	if (get_timespec64(&data->ts, u64_to_user_ptr(READ_ONCE(sqe->addr))))
>>  		return -EFAULT;
> 
> Should io_timeout_remove_prep() get the same update? Otherwise looks
> good.

Yep looks like. Just went hunting if we missed this in other spots,
and only other one I can find is in io_uring_cmd_getsockname().

-- 
Jens Axboe


