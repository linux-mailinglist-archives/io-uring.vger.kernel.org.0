Return-Path: <io-uring+bounces-11844-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iC2INTrNb2mgMQAAu9opvQ
	(envelope-from <io-uring+bounces-11844-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 19:45:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A51649BB1
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 19:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BD4F156F783
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCB7211290;
	Tue, 20 Jan 2026 17:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rjdl+ySX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com [209.85.222.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA354219ED
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768929889; cv=none; b=mlJ6i4vmyv16M/ypsY9AdMBX18jd5kQOqM3yk0y/LhkuyaMqmbUicIvmE8fWiLutIXlHFXDclky6FU1T6hVAPl0+CPJp0PClKkgOlt798v0rBjQ336ITp1N21R7Qse45FgCFsODkaI8FoOp+HCUIhBuuqzVd4OzhiFYhlxAz7lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768929889; c=relaxed/simple;
	bh=HbRg0byu5nrW0iLoW8OhS4h1+C5q2yGKNLxrw3RQCaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o3l/EXyERJGoq60qOJsh8cvGHKJnkBsryptxgnXJW5Ifk8ER5DEOq4f+dJRB1x95o27eQySY0rfw5zNwMYgX6/xpdVGR2eceLf43gjHiP7XFDnnS/9jcT1Xc51NOjIRe+V5eJzPFK41aXd/UtvzKcgCHdE43eStZawlzkeRCLoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rjdl+ySX; arc=none smtp.client-ip=209.85.222.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f195.google.com with SMTP id af79cd13be357-8c6c922850cso144127385a.2
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 09:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768929885; x=1769534685; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dZTH3ZTdAE82r7lemIxd3d7ZZpxLSrkE7KxsaG+oA5s=;
        b=rjdl+ySXVxBZf4BxH7jwJdcDVBioiEjzZTkwel71Aa2BMgKsqh0cVxfUK9mpYDLiZU
         qDbLXnjyFDv9W0KQLrhE0fVvlv5XUfdOcHJ2/3oWAYd5j1pSTsdHVtJm7Fk1Za6tKwJ8
         KHpbdMiqq7+5xOcgd3qxrEp3PhEs4N3YWbr+G4B9A+J1JruW/Lz3Qq/VjyZ8Av5Z/vg+
         p9jpPo7/lNEAs4lV6eFwPCEcHQ3tOOzZCllfDoAaWYjmmvC3LHaWVvmlFN2jX0tOxK4k
         kNbw8Q+NyzF9UMBenak3wknqrOZhDEMNl2xc1pipOUswKbIyFkPqMg1YCWkYCoj2uq1H
         NqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768929885; x=1769534685;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dZTH3ZTdAE82r7lemIxd3d7ZZpxLSrkE7KxsaG+oA5s=;
        b=WKgJ0baSxx9hjDQRR1g7BJ5p7ftI36/crNBR1CSbQSwRRJZ6MFXklQ7YpdAOjrZpnf
         3zuD/8pFFI2sfkKe6Wm0cg585qE01nqsgid67swhXOLe2pneSSMSHZJriUNJ9Ux4VpZM
         vPgxe8wLVvDVXUc4LSldzFmoWqR0LmDKYFjaZY65UYqDPSqjZw4IfE5T/cjNgpDaS9pH
         dEAOuTFAAd6Es7pbgE7fu4FLtFS87HAZn8g5Y5YXg58TLBV6qSHwi3idNAuD6SC2Mit5
         xdT468h3iCKvgiC6YsNYIy89yBnom5DINLsX2aeTdZVODn53B0Mq+iYaUDlnwbccG5Km
         HeuA==
X-Gm-Message-State: AOJu0YwQeMvfqU3/yRTAIi6dGAg/BwK3sd3E69IDI8komjSF54vErN3t
	kLNif/wwF4EuiVwvQY6+BstPN1hlDPudvnigWkzUTr7eFzzjdMtxUMxsXzV6Hwin84w=
X-Gm-Gg: AY/fxX6bEFh6VJdghIaSv7YRwB5uxu+ifhW8dWom6FDdZ+va6HG63VaSN6cz15uQ17W
	6dPcj7g4dCFiOpzpH8AtZ7rGXarKZ8s2OZsMUQo/4mbl7vVsCigEUt42l/LomNt+LzLTsvHChEb
	/Cr2rge5LrGsBeuj9IGGgEv6zkBkdwBdeevIee+p/nIQKmkcKghmS2TMTLRywfn4o+TcDj/79gZ
	IyStSuRq1f6IOC2BvmFB3BfX0f5wnxFUjUQX6ljC1KJGgXEoosjTNEXsuT2+EkERRqRt7TFQNOS
	vgfxd77+T4MIeoSuLgyD/VMxN9D9fXL9FtRQDhGA32Yow54uuYGPsctLa2QXuCZ0q/prmZXiwYR
	igREqE2pvMdX0zl3jwq27vrKzttbktdB6FAZhINV22Fg8S7A7liEm80+ccz2E57i/nX4jboQNXS
	3HCHzkrBZiOoXIRuL2shT1yTx7PF++kCEbhqA4rPS+2uOxGm7veGgVZtKI7n/xjCNdQTHi
X-Received: by 2002:a05:620a:4054:b0:8b1:110a:e14 with SMTP id af79cd13be357-8c6a67648cdmr1965912185a.55.1768929885180;
        Tue, 20 Jan 2026 09:24:45 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6a7248dcfsm1070802285a.25.2026.01.20.09.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 09:24:44 -0800 (PST)
Message-ID: <1b983be6-ae2f-468e-b306-3889d0b78553@kernel.dk>
Date: Tue, 20 Jan 2026 10:24:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] nvme: optimize passthrough IOPOLL completion for
 local ring context
To: Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org
References: <20260116074641.665422-1-ming.lei@redhat.com>
 <aW-2Q9Zv_UNX127Z@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aW-2Q9Zv_UNX127Z@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11844-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 5A51649BB1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/26 10:07 AM, Keith Busch wrote:
> On Fri, Jan 16, 2026 at 03:46:36PM +0800, Ming Lei wrote:
>> Hello,
>>
>> The 1st patch passes `struct io_comp_batch *` to rq_end_io_fn callback.
>>
>> The 2nd patch completes IOPOLL uring_cmd inline in case of local ring
>> context, and improves IOPS by ~10%.
> 
> Looks good to me. It feels a little unfortunate to have to add this
> parameter to the callback just for this one use case, but maybe there'll
> be new uses for it in the future.

Yeah I agree, but the win is large enough that it's warranted. When
I originally did the task_work fix it was on my list to investigate
further, but the bug was such that it was better to get it squashed
first. And then nothing more came of it...

> Reviewed-by: Keith Busch <kbusch@kernel.org>

Thanks!

-- 
Jens Axboe


