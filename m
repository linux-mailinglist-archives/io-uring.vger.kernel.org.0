Return-Path: <io-uring+bounces-12912-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMA4KBkgzWnOaAYAu9opvQ
	(envelope-from <io-uring+bounces-12912-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 15:39:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2091D37B5CE
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 15:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 576DE30954A0
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 13:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBF92BE026;
	Wed,  1 Apr 2026 13:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ds2j+Lzt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A584C295DA6
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 13:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050309; cv=none; b=FoS0DnkgtNbDGD3/jimSYEd+i5MIZgsCxVTmAPuY9bpgqPT+LK8Y5M6BaMVdtX6RRpeDwRJLZwEMorYTv1TL6pM8P7hKuqWAJ7LPYpGkW9lEaefElL8HhXaPXsv1Jru8STUwHj5oWuBYMzmAepqGUvz07PsIkt35vbAWGcoI6bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050309; c=relaxed/simple;
	bh=/YvR7GDcbJWPTi7s8ZHZu2b5qEbr3+GLudlLa1SaZZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l532GvSAel44E3BXh5i3QXKUNTuxAAZZmaUrxxKQmznlhctK17Bd2W3kLBuZzLjyo099dWmSXU3pl4HT+a5Lh+0FpznZDfG6kIJFaV7yg3/JN/7QKLrDq0JuBmDP5yjDkdQb+Q6sP3YLkS+grMnvNmrn5Z352ei45DjyKyxhPoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ds2j+Lzt; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-4043b909ed4so4195363fac.3
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 06:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1775050306; x=1775655106; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zvaeNs5EsKTfCzD+Arjtp4FtaxeHXNFNODmrqr9oRMQ=;
        b=Ds2j+LztqaY2oe9xxAf+H+ntOavN3Un0sULyHK/lgJLmKAqTb5w0MMkRrn0Sf8TuL4
         Hd2WqqNgQAblsVaBlgqFDGx0y0+vRKlV4PY01IFOV8myZ0CzRN4oQNwbB/NPvYdTVmdr
         S7Itg1BOCxR2VwKVhigzrFh07ez3y4FvFSOL7cE9ItdNkFNtlfh6wG1eu/A5kjY/amyU
         6NKt1+f6NHmHq5ST9gip0MlNI0grOaqi/tNVsUteQYhZK+od98VFGN841MKAeT5OtE/q
         uuHvUvRYThBIsaAnpqoqGqZZC0cEKYr46WGrqAaXWfyZWr4bsJyVO5xOFLLq/2U11gqN
         hsrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775050306; x=1775655106;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zvaeNs5EsKTfCzD+Arjtp4FtaxeHXNFNODmrqr9oRMQ=;
        b=mwAdKd4DJ/F5ZUtSYawsyitS8cErLQN7AuEGhcFw8Mz8XPK+ukw4vLS3n70SCQlMRl
         mBpVGMZkQyHJJqIz242xJFozxn5HT/9G4TzkCxHbz+fhLIihkkkbbwFhFj4BSstI8/kf
         VOjWHT2XMqrhLkXiBTGLRbLEsOcubjg0Vjk/8cK828lqyubIWwYlg9cu4iYqDtK6HQXp
         stJcGcMvTCukVckQAaQQmXYPNiGvrF+HUlVh3PfZzif2dtrFzhKU8WgSqaTqehAa6ut9
         7C1ZjathLiST6opkdH3OGRprwCY3ybmk5Lq1vtilvg9MoUkBFSKZo9SS5bN4eC9XF1PQ
         PV5w==
X-Gm-Message-State: AOJu0YxqF6X1DcJSLkbfU9/UVCPjMcTi+GsnL/OcKoMMS8sKrIoVTWCZ
	NmT7+TtjZG7fqdkHCzEI7cTUsaIguDcQXkt6cXt6UNgRj/R7WoyYDaqi3OwSePIcJnY=
X-Gm-Gg: ATEYQzyCI+beJb8gRXh495wml4JJfUh5C9/wjaaxvSVasKGUrav3XUsv5UfyDhZIhEe
	ydXxX3pLAfBvdwwABE91K2tsFwjXpKT0W53Mo0NS/SPqQ62EkYkrSfpmS+390lNcyZp1pSR7r7P
	D6ZMKAwymEM1fSTivga4L4TeFjZMYzY9H0nVMQIG3K2z8OTa9GKIYhmVNR5KQeio1IuFwFlcXxO
	S6N+KERn9npncK+rybYHNkptmAeTqtK3iYW/J9/NiaYs8xwuIRwgW7wEf/7GQO4CH3dh/omFAZy
	QZx5eMpZsRXV6r+gJHgFyMwLPfttu73U/VFyUnxiO1XQy9+mpkrdAxkf99YFiyoqXGB59857LcX
	3nuzUCD8WIdvhe7joKbAPULom9uiqClZnHEFx8igWmE/xvTs2p/kWO87dvqYjJIrruemsyLsNUI
	GW9WHwbyIQvHizoGMLy2yEAjrHbuOCJ2ZMa2U0HjvjdiyU+Js2YK8leO1Xe4+sxr7emedzmk3aN
	H6KEoy8FQ==
X-Received: by 2002:a05:6870:fb8e:b0:408:694d:ff34 with SMTP id 586e51a60fabf-422cfbe83e0mr2194930fac.9.1775050306007;
        Wed, 01 Apr 2026 06:31:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d04d95bcasm9703330fac.17.2026.04.01.06.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 06:31:45 -0700 (PDT)
Message-ID: <f382f1ec-eb32-4b76-ad35-25a8365fe801@kernel.dk>
Date: Wed, 1 Apr 2026 07:31:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/cancel: validate opcode for
 IORING_ASYNC_CANCEL_OP
To: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260331232113.615972-1-a.jahangirzad@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260331232113.615972-1-a.jahangirzad@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12912-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 2091D37B5CE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/31/26 5:21 PM, Amir Mohammad Jahangirzad wrote:
> io_async_cancel_prep() reads the opcode selector from sqe->len and
> stores it in cancel->opcode, which is an 8-bit field. Since sqe->len
> is a 32-bit value, values larger than U8_MAX are implicitly truncated.
> 
> This can cause unintended opcode matches when the truncated value
> corresponds to a valid io_uring opcode. For example, submitting a value
> such as 0x10b will be truncated to 0x0b (IORING_OP_TIMEOUT), allowing a
> cancel request to match operations it did not intend to target.
> Validate the opcode value before assigning it to the 8-bit field and
> reject values outside the valid io_uring opcode range.

Looks fine to me as a cleanup, as it's really the application being
buggy if you set ->len > IORING_OP_LAST and then match some opcode
that just happens to be == ->len & 255. I'll apply this for 7.1.

-- 
Jens Axboe


