Return-Path: <io-uring+bounces-13368-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGQuA95VB2p7zAIAu9opvQ
	(envelope-from <io-uring+bounces-13368-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 19:20:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B75554DB0
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 19:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B8FF53036810
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84363380FE0;
	Fri, 15 May 2026 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="YidpeQFQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C031380FEA
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864620; cv=none; b=earlUj2IbjqIooplqVADvZ52hvxlme2q8ciHRyMvzTZzazjjRE3iCXiNIDCdJ1T3nfuQnIK/pRpizNNCHsmq03foA8EkPN2XrvE6gKZYUIjKJw58UWayQ7mXiVoQZ/J32KmXX6WVozhsC++c0sX1yP3DluW2HaC/GsuXSAwn9vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864620; c=relaxed/simple;
	bh=rLTKzZVhye9aNwzw4sNzYuzutUlYuMHTHxaM0dO4onw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dJFP9uanjA/F14WmkNNjt37QscRd1IWyAOhCLJJUmIyhnss76Klh6FGyuv3oMBAs6wg3QghrE3RgO2+5s1QgYI7wv6wuG+7+TECB5xcc0kh2Am+CQbzyRYXqiNj9qWECWJcZufsg/x8+BTUYEYLHL9bRq0FidLHtLswAva8AKAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=YidpeQFQ; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dcd9061b1aso8359450a34.2
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 10:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778864617; x=1779469417; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cSYA6i9OVNuXyeF0Y/1q1RjhAOomJQGRoEh8/Q//wNA=;
        b=YidpeQFQ9VaCiAwS+XAmT24a7CMdE8cLO3Zy70w0G1Xt6pM2r9LqlbzLCO8kat6baq
         iftklhhKYnRewetjJiaiRqcNjgQL/3Ynq/j71fqJGeivppdijcXy2bq08qYdAKx93Kia
         0MNXTELMiTW6ZCJoL6h76Z1xlxjntCastUAE7DncQtWpr0wMgluqgiIgQRw8hSZtsTrW
         n5KISoC596zQh7gXHTEOaWCfgEK2wZYyFlE0Ik/stMLJD8cOaOU0+fgvsE3hSQK/N9Ka
         xwaOZYyQOjGVAr6sYg1N4a2AN0cyFHu7nE6ZIvXQgsiiHLQspJnh3It8aKkGJRECgT96
         nSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778864617; x=1779469417;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cSYA6i9OVNuXyeF0Y/1q1RjhAOomJQGRoEh8/Q//wNA=;
        b=JR93eFIQZW+mz2Tqt3kd4qFU8P/cIeQJWw7DzdV+i50U/9VAJDaRYhew9v1dPM6F+r
         x3vi568BxlqHvzDulEkNktr2STDTpGblKk2gI/Q2gW74vhhsynQnuzbTBzXA71QZkiL4
         Ou4Rq/Xofrq07juKu7NdeRBP8mW8jXBBXcQNSewpkRCDBM3Uvcf7hOhJ3HRK9QATCD8D
         8j4GFHxUdEo+AdEQNJv3XX9ead3t0BcYlX+IFsMaYQK4yEjaxXm7iVZIMPmAmznrBCb6
         5ryXjLIhNlD7YAC1XF1SW0a4NFtggoTIUDWlDnDkN532k92HIjudJjwUcuXBbsivBLQ7
         9cSA==
X-Gm-Message-State: AOJu0YxwBxPR4Bo1jid9zV5kyx88963FMmbtM7NkZw5qyo6QV3nxdWI6
	2VQDvrCFDX1+vlSg9d00X56WnqDVBJDSI+2WnfISS418EilnFlQHUZTP2i8U0isRMOZ/82cD9nj
	I/qMP
X-Gm-Gg: Acq92OFCdP1a/D0Glsm4S41+BDOwcRrPmL23WHP1iUWjryFw5ZGd1PXJUqdMvQWOUNU
	kOGya+ItZI6L96vk3Pr1QYtdB3B/m2nFnn/G21NFKBN/jYgdK7zbB+FgG+w2IPDaywj5yCvbb/9
	ezEfOEsQZ/sHVXbk+nOuP0NLpD2MziPsrDufr6cH03PXgdlWTqSy76g4A8c18VtoV5BtNLdMEQ0
	+UGsvet75V76jVUQnbfQydnz2DyEAul4SFwuOVP8797fcoFN3sTlKhZXThud1Cu+NOscJyNgiB+
	yoRX8bNuE3kd4iLGgEryYJUmnbfTGNaOr3LlVP766/44zP7qEdGVOunzrtifxBftvQU/7MzGpc/
	dVbnVdNIAcoQDjIdM206HgizpJEn4Q8i6ekWtCYSw5qJ1udSiGiQJsvaMPYmo9qipJnPkdVRV0W
	mnjLXVCKfyIqsLXrgx4GJpJMmaA6hLFDehTtV/eXFxXpBL/E8/PtN4KaikNwudkYVAfQB329NJ6
	kc/ubkuxynLpWM8AnU=
X-Received: by 2002:a05:6830:6588:b0:7dc:e032:9b5f with SMTP id 46e09a7af769-7e4fa0afa06mr3161926a34.25.1778864617103;
        Fri, 15 May 2026 10:03:37 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55b7c68d6sm1670763a34.3.2026.05.15.10.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 10:03:36 -0700 (PDT)
Message-ID: <826bacc4-b863-4af9-a0b3-ba834f9b7c35@kernel.dk>
Date: Fri, 15 May 2026 11:03:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: punt IORING_OP_BIND async if it needs file
 create
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring <io-uring@vger.kernel.org>
References: <37dbe977-6d1f-401e-b1dc-5d448ea27a8c@kernel.dk>
 <875x4o620r.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <875x4o620r.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00B75554DB0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13368-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.de:email,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 5/15/26 11:00 AM, Gabriel Krisman Bertazi wrote:
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 30cd22c0b934..1f5fd8c37a5a 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -4,6 +4,7 @@
>>  #include <linux/file.h>
>>  #include <linux/slab.h>
>>  #include <linux/net.h>
>> +#include <linux/un.h>
>>  #include <linux/compat.h>
>>  #include <net/compat.h>
>>  #include <linux/io_uring.h>
>> @@ -1799,11 +1800,29 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>>  	return IOU_COMPLETE;
>>  }
>>  
>> +/*
>> + * Check if bind request would potentiall end up with filename_create(),
> 
> potentially

thanks, fixed.

>> + * which in turn end up in mnt_want_write() which will grab the fs
>> + * percpu start write sem. This can trigger a lockdep warning.
>> + */
>> +static int io_bind_file_create(const struct io_async_msghdr *io, int addr_len)
>> +{
>> +	const struct sockaddr_un *sun;
>> +
>> +	if (io->addr.ss_family != AF_UNIX)
>> +		return 0;
>> +	if (addr_len <= offsetof(struct sockaddr_un, sun_path))
>> +		return 0;
>> +	sun = (const struct sockaddr_un *) &io->addr;
>> +	return sun->sun_path[0] != '\0';
>> +}
>> +
>>  int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  {
>>  	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
>>  	struct sockaddr __user *uaddr;
>>  	struct io_async_msghdr *io;
>> +	int ret;
>>  
>>  	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
>>  		return -EINVAL;
>> @@ -1814,7 +1833,12 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	io = io_msg_alloc_async(req);
>>  	if (unlikely(!io))
>>  		return -ENOMEM;
>> -	return move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
>> +	ret = move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
>> +	if (unlikely(ret))
>> +		return ret;
>> +	if (io_bind_file_create(io, bind->addr_len))
>> +		req->flags |= REQ_F_FORCE_ASYNC;
>> +	return 0;
>>  }
> 
> Patch looks ok. I will add a TODO to myself to look into the bind call
> getting a flag and returning -EWOULDBLOCK, so we can eventually drop the
> workaround.

That would indeed be better, but probably better darn far down, and it'd
need refactoring to pass down 'flags' or similar as msghdr isn't a thing
there... So not sure it's going to be super viable.

> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Thanks, added!

-- 
Jens Axboe

