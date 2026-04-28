Return-Path: <io-uring+bounces-13168-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KKwfOUL28GnUbQEAu9opvQ
	(envelope-from <io-uring+bounces-13168-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 20:02:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EE848A581
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 20:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AF569301A5EC
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 18:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5518233AD9D;
	Tue, 28 Apr 2026 18:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="PTecsThX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009A1391831
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 18:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777399359; cv=none; b=X0ZexeBjzkcotxzET5R5dCGA2xRhAmp6ElCxNGE4Lh/QWR5K//VVn+QeEfrt0olKcUWhfJFzvqBnSehCrk6e99824dE2EZgPJGAC1xVgkUTp8P2OJaEH71/eW2M2hYrrPqKmWYz5qLQuIyAViKRAjcD3o5asUN8r/8phgS4iGW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777399359; c=relaxed/simple;
	bh=x2yihLcpIcmqqM9XIoPnyRji7UoK1AifKPC36KIU/9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7P/Qa1Mp2O0etAifuwSFFdvr7Il28ZXTRzvG2LXzmR1Q7Uluar4ioY6c2ICLL1imZTiEdOteB+8sQaNzgpYOy2nuq1UFUamqj/TTgjYXmqBkrxWQCZNGJ9O1FasteN0Al4ZYM/SeEjvUIi3T7HAbweg0cIdkNOv++LKIhu8/L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=PTecsThX; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-40946982a78so4316841fac.2
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 11:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777399356; x=1778004156; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nXl/jWJ6vP7SXrXb/xPSu9tku5aOpOrR4mI5dbC5SSY=;
        b=PTecsThXo4w3oYAmGJOorleuLt9IoRH3vQPF94d7ZfCirtcF3wvcSCHSyFECwUbuoO
         kBo21w8jcOn45z2Nfdf7wzVcnT+FKMF3mwohcS4SFUXYWhpDODTPcY2xgJpR4EkuXypC
         IuX4T9H1u2oz2HJEDhAt+mXijieux7HS8Bhzj7YIZ6yljDhlFh1zinaKnZTeffj7aLXn
         5bwW/j2tmC8hNj0Ep6HZx3MbSxdE44dgONEAxtdZcODL4h1rMPNrix2+XsDgl8f2F+tE
         ELaHz9AGy+kpf6q4bpffOdp0dJvEI9mnsJV42gT5TP0bQMG6Arl2y9uGUahHPDJCjFeL
         Kc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777399356; x=1778004156;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nXl/jWJ6vP7SXrXb/xPSu9tku5aOpOrR4mI5dbC5SSY=;
        b=rdZxIB7KAheV7jtYhP2pmodyiHaz1Lqgpb8+NAHel1BXg/9JL8Nm3+8ogCTRStMXQC
         iz4JKpNvVapw7qFW3K0EcXUsh6fMOzzVJsKZoT4iO1+wPN+NoZnwZXf6PpmnEw8iRDUv
         FgTrV8ssWJGUyxOqlfx3A1tMsnrKD3gZUDlVRcuPZZ0cFYgUbZBM8Q9O2gYiOi5LwJdH
         Nyz4KaegFTw9J8GuWpkh3slURKXYi0HsvrbXO06tYheh9WYl8FwmuhtihZgEYhWoOEDW
         TZDguDwQCjr0ClPpNbgEJq5d3nV+6+QN9PVfgbb8PhI4jsW7nLodzOccBy6dH5pjefmg
         g9nQ==
X-Gm-Message-State: AOJu0YxCLqu2Hh1MCbwr+9NY8hm9Q3dy8QwVRFejfjwqDcP4YpA0SCV6
	iBcr0oPHqymkt4Eqi6eYhH0+pSNGTE+yRuoVJT03uKQP8+ksUFsRC2CVTaa2RFjUkneyDstFhfD
	TYt4JZTQ=
X-Gm-Gg: AeBDietHGt0smUJi+KdbtwRRevdmP8NLz0pK0eIhPV1SI9l977sjaP4saoBYjqARZxB
	Iv/0yZxL+2JO4PIsxNj9lMyQD4vWoXpDn216nSc2r1Zzd+bvUlJMGYPT1QX18HIn6kWWuoDMeR8
	28Bg/q80Bw2KzrysxSttiZu7U160amhZHrkZBJ3Di/8ZHlNcnFiqK43pHt206f9SjlYei2nXaP4
	dzXoG3lypYkvlXH6Pwllt4cjRrGLvbsO3Xeue1O6b2Z4lFnBjyapK7JDOGLACyICzO5b3gemphj
	hCQ/MjsTuRMMXLSiteypbazOkWXm3JOPxLe6c/HP/K6STuyvUqVmrZx6ZTpKXQsTTmDFPBydHeE
	siOViblfvuM1fP6OIMutnmXLfC8iOQg3K+b/QyP5bBGH8n2mV2H/FRzcxMA7KGsKcMwswHYlYtp
	semQ+C21nNNYtyo0pXgCcVF0shGahlQrpdYN4qb7X/1JD6hxUFvGnTbwvbHmCm3zOMK00gzlA7I
	yb4euwt6RvlsJ6dzZg=
X-Received: by 2002:a05:6871:ea11:b0:42c:1cbb:5f5b with SMTP id 586e51a60fabf-433f3a530e5mr2162367fac.31.1777399355713;
        Tue, 28 Apr 2026 11:02:35 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4340d4a2cd9sm10250fac.6.2026.04.28.11.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 11:02:35 -0700 (PDT)
Message-ID: <7645db80-8a8a-4ed6-9a3a-f2406cf93322@kernel.dk>
Date: Tue, 28 Apr 2026 12:02:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/kbuf: support min length left for
 incremental buffers
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, Martin Michaelis <code@mgjm.de>,
 stable@vger.kernel.org
References: <20260428154557.2150818-1-axboe@kernel.dk>
 <20260428154557.2150818-3-axboe@kernel.dk>
 <87ik9bj7jt.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87ik9bj7jt.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 60EE848A581
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13168-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On 4/28/26 11:53 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> From: Martin Michaelis <code@mgjm.de>
>>
>> Incrementally consumed buffer rings are generally fully consumed, but
>> it's quite possible that the application has a minimum size it needs to
>> meet to avoid truncation. Currently that minimum limit is 1 byte, but
>> this should be a setting that is the hands of the application. For
>> recvmsg multishot, a prime use case for incrementally consumed buffers,
>> the application may get spurious -EFAULT returned at the end of an
>> incrementally consumed buffer, as less space is available than the
>> headers need.
>>
>> Grab a u32 field in struct io_uring_buf_reg, which the application can
>> use to inform the kernel of the minimum size that should be available
>> in an incrementally consumed buffer. If less than that is available,
>> the current buffer is fully processed and the next one will be picked.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
>> Link: https://github.com/axboe/liburing/issues/1433
>> Signed-off-by: Martin Michaelis <code@mgjm.de>
>> [axboe: write commit message, change io_buffer_list member name]
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/uapi/linux/io_uring.h | 3 ++-
>>  io_uring/kbuf.c               | 8 +++++++-
>>  io_uring/kbuf.h               | 7 +++++++
>>  3 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 17ac1b785440..909fb7aea638 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -905,7 +905,8 @@ struct io_uring_buf_reg {
>>  	__u32	ring_entries;
>>  	__u16	bgid;
>>  	__u16	flags;
>> -	__u64	resv[3];
>> +	__u32	min_left;
>> +	__u32	resv[5];
> 
> Honest question, isn't this a property of the specific operation and/or
> fd being operated, instead of the buffer_reg?

It kind of is, in that some users may not care. But it's not currently
possible to pass this in on a per-op basis, and while I did hack that
up initially, it's almost impossible as you end up with layering
violations. In practice, this is really mostly a recvmsg multishot
issue, because we need to store the headers. Hence the solution to
stuff it in the io_uring_buf_reg instead, and make it a fixed property
of the buffer group. In practice, you may even want a larger min_left
than what the recvmsg requires, as you don't want a tiny truncated
transfer at the end, regardless of what type of recv or read operation
this is. Hence it works generically as well.

Also see the linked GH issue, that's where most of the discussion
around this have happened already.

>>  /* argument for IORING_REGISTER_PBUF_STATUS */
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index 43e4f8615fe8..63061aa1cab9 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -47,7 +47,7 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>>  		this_len = min_t(u32, len, buf_len);
>>  		buf_len -= this_len;
>>  		/* Stop looping for invalid buffer length of 0 */
>> -		if (buf_len || !this_len) {
>> +		if (buf_len > bl->min_left_sub_one || !this_len) {
> 
> Cosmetic, but perhaps store min_left_sub_one instead of min_left itself? the
> buf_len must be >= min_left, and that is easier to read.  (buf_len &&
> buf_len >= min_left || !this_len)

Also see GH issue.

-- 
Jens Axboe


