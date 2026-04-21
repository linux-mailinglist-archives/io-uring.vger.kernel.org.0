Return-Path: <io-uring+bounces-13106-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGFoGR7v52mhCwIAu9opvQ
	(envelope-from <io-uring+bounces-13106-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 23:41:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 07C2C43FCE8
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 23:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1564930580BA
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 21:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770DA3DD536;
	Tue, 21 Apr 2026 21:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="lxNdrIwG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FC43DD526
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 21:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776807671; cv=none; b=o8P/WZUA2CBJY9dYFzy6LFn7SwZ8lgrEj3raqkgeBQGgSAKsjsvgQZoUZb1olKkqI3iILVlqPB4El0/hT3yaAXOT1K1srqIPHEWHZGCbkYsxl/RLvXvTzIE3FD8QqaGiiO5fP1Z2CGPknbHZIBs5C6Zcl+d8Re7wp+f13MbFyOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776807671; c=relaxed/simple;
	bh=LX7yapPJ6xKr7LScrpxrYA3OvcspOFlXm8+1a41H7L4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YnACUVfv002dzdiwbKRCdjCI/vnScjIjFFylngOX2u9/KGA7exrWl4euUEoBEjQIYQYWS811mz1UX1W8zYOLFD2TkXL//FSVUD+Hz0Ps+BmnRVYUk6Eyg+gaZdJ36+aUFsD3QuiP7RxZRjFNfjDLE9MlzppJ6mwx9X56jeIQ6N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=lxNdrIwG; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6949831a7bcso644450eaf.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 14:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776807668; x=1777412468; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MxhoGUGUzm4IOZ2KE0Q9pcGCabBoKvgDITfdiTi4ERg=;
        b=lxNdrIwGKa9riY9xb8xvdKaIXIaaoAsBDhjRtilDR2TSaLG/10QFIl0v2kLZXtcvDR
         OClzY+AoLJSJxAqUZh/jaTu1GK3keVVt0q+ZJD6nN+zAMKF7sJbbTjk0FgVhWD69WGTI
         FdiUXbrPwTpxCLpGuiQwaO+pRn4Yvv5D2yZei9/vj3uIjbbte1lm2hMU0CZBT2jqV++6
         iT+SPC5W1yyAZeUoIRQAF6fEQpozWBmw+VmpiXrZDhyf+BVV5sRVQNatvi0gpsD6LQ8e
         YrmGdAKAr1gXoBliIkSHB8DxAFlz0pyTrOz67yDys0CMoFRNF++sNSpxgF7u8Y0wEZ9R
         jh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776807668; x=1777412468;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MxhoGUGUzm4IOZ2KE0Q9pcGCabBoKvgDITfdiTi4ERg=;
        b=e4gjJTRX/v3VOQz2gwZfzbBiYw+pUtCywVbgUD3tNgwFPq8bfGWuLcUUTqOfTU2tvZ
         9om7hvcFwAVxlpxGgQ6t6BTbNDLVPR32J+VFXtn7b0vGmewmqr42RODQSVLu5aTFTso+
         QTLSb6W4qjbdfsFLKcD8X6Y2yZzNmsLPBhxEKveAC358nk5LHtlIVdOoANYW1hQtysEJ
         uf1IMp3vKvKjgwsdR64kYJzyzJ1lDhYkwJEooH6qIWUBPOVX3ucAILjfoXxaxq6l0P9n
         8QcU4E9xF1+oyk2ZklIJS9zBEX/P1NCi0zSRdPV2mGOyfSaOGMVWZNjL+tbr//O5kHxN
         3BWw==
X-Forwarded-Encrypted: i=1; AFNElJ8u7FYBPDlCtRnYSOPZaZKgq8hr0uMpmi/L9pvOrm4QvtguQNyFJgnAewz1X2Xia4iFNI/wprh1tA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFjMFuBDP2xVZ5YYdKBoN5UpfRWxM95g7vQp+smywqelp5P5LV
	oOK6RxLzvoiYSyW6KFl/JZluzplCHviSu3DGaEwrWBz8o8v7nUg508C8PnZhaFeQELk=
X-Gm-Gg: AeBDietRtWz0QfRDY8kG40fQs6zFOKO2OZgVX87Kuy3G2dq9922a1SfdBLndMUYfXhg
	qIyFqdySpK2EyeXJLznf5IwYEzd/KYMb7hEgMoWLBZrUgrqVtm8yTI0P8NO9vzM7wVinrtiC0q9
	9HsA95RlrCQ3TSRfVaRSh750RUnTTyWxee37V8owSI8pQ/HXFuTW0cw29KVf5NtuXwLrkUJR7hU
	LDd7Qmg9ke/Lgm38b8yjxbSpnpf0RsFTPmqIJ7ZkodB08URv6wK8TrrFb0P7YmWO4nt2yQgrq0z
	h4qfTm+5mF49e9nNJUbGEk6g/TKE8f8/+H4Sli4DmRxfhnQtTxJ8+Kvmw4ccTNMwDPHoFy6/xFA
	NymW6jxwuQTW8er63CvlsCKolkU3bULDB1mfNpkLF1UpaNP6iomlAC54THERGUCgJMAz/ZxGKky
	mo0sRZiUiSwJVAbpPOIoDDdK3F609izuRZH1wHbZRlFh+LfFWnqfmw1+1Hjs51bj7mHepMcaZvX
	WgVrKj9yTavfFODLh4Y
X-Received: by 2002:a05:6820:1c9c:b0:694:9861:ec6d with SMTP id 006d021491bc7-6949861f274mr2596837eaf.32.1776807668025;
        Tue, 21 Apr 2026 14:41:08 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42fbe8a0bcbsm637265fac.2.2026.04.21.14.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 14:41:07 -0700 (PDT)
Message-ID: <6c1eaf1c-5c1e-4ca3-a9b6-b0305fcce588@kernel.dk>
Date: Tue, 21 Apr 2026 15:41:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RCU warning off ublk_buf_cleanup() -> mas_for_each()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Ming Lei <tom.leiming@gmail.com>, io-uring <io-uring@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
 <qyob3dbqkicviyjs77q6mmxldtwm6qdpgwznzw6ulipztphlbl@nb4bzctzlsnw>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <qyob3dbqkicviyjs77q6mmxldtwm6qdpgwznzw6ulipztphlbl@nb4bzctzlsnw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13106-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 07C2C43FCE8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 2:28 PM, Liam R. Howlett wrote:
> * Jens Axboe <axboe@kernel.dk> [260421 13:47]:
>> Hi Ming,
>>
>> Ran into the below running tests on the current tree:
>>
>> =============================
>> WARNING: suspicious RCU usage
>> 7.0.0+ #16 Tainted: G                 N 
>> -----------------------------
>> lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!
>>
>> other info that might help us debug this:
>>
>>
>> rcu_scheduler_active = 2, debug_locks = 1
>> 1 lock held by iou-wrk-55535/55536:
>>  #0: ffff800085a451a0 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0xdc/0x2f8
>>
>> stack backtrace:
>> CPU: 4 UID: 0 PID: 55536 Comm: iou-wrk-55535 Tainted: G                 N  7.0.0+ #16 PREEMPT 
>> Tainted: [N]=TEST
>> Hardware name: linux,dummy-virt (DT)
>> Call trace:
>>  show_stack+0x1c/0x30 (C)
>>  dump_stack_lvl+0x68/0x90
>>  dump_stack+0x18/0x20
>>  lockdep_rcu_suspicious+0x170/0x200
>>  mas_walk+0x3f0/0x6a0
>>  mas_find+0x1b4/0x6b0
>>  ublk_buf_cleanup+0xe0/0x240
>>  ublk_cdev_rel+0x34/0x1b0
>>  device_release+0xa4/0x350
>>  kobject_put+0x138/0x250
>>  put_device+0x18/0x30
>>  ublk_put_device+0x18/0x28
>>  ublk_ctrl_del_dev+0x120/0x2f8
>>  ublk_ctrl_uring_cmd+0x598/0x29b8
>>  io_uring_cmd+0x1e0/0x468
>>  __io_issue_sqe+0xa4/0x748
>>  io_issue_sqe+0x80/0xf68
>>  io_wq_submit_work+0x26c/0xdc8
>>  io_worker_handle_work+0x334/0xf20
>>  io_wq_worker+0x278/0x9e8
>>  ret_from_fork+0x10/0x20
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>  ublkb0: unable to read partition table
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>
>> and I briefly looked at it, but then just gave up as a) the maple tree
>> documentation is not that detailed,
> 
> Which documentation is lacking?  I will fix it.
> 
> I have user documentation in the Documentation directory while
> technical details are in the code.

I went into the core-api/ and leafed through that, didn't have anything
on mas_for_each() that pertained to locking. Was hoping I'd find a table
of which parts of the API requires what in terms of locking or RCU.
There arent a whole lot of in-kernel users of it yet, so looking at
other places in the kernel wasn't very useful.

Since this is a merge window regression, I really just passed it to Ming
with you on the CC just in case, and didn't spend any more time on it.
I'm not the one that's supposed to be finding issues like this...

>> and b) other in-tree users also just
>> call mas_for_each() without either a lock held or RCU read side locked.
> 
> mas_for_each() must hold a lock of some type.

That's what I assumed. I missed that the rcu dereference check
checks for an external lock too, which I guess you can register
with the maple tree. Funky... I guess it's just for lockdep
purposes, makes sense then.

Presumably the current use case is fine, as it's serialized
teardown. It just ends up triggering the rcu sanity checks.

-- 
Jens Axboe

