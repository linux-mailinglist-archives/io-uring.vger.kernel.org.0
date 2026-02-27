Return-Path: <io-uring+bounces-12451-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QKAFBr2yoWmMvgQAu9opvQ
	(envelope-from <io-uring+bounces-12451-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 16:05:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5551B969A
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 16:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D23403020A58
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 15:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5835E42B740;
	Fri, 27 Feb 2026 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pZ75dtIC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A7F41323D
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772204729; cv=none; b=KAml1+h4tlzugEiCHOg65T4Y1DXXSZHXBlvgqxwDOtQ/G0LgWznm3N/mk/9v+2jjIe861NH4i2c+VJsiqt3JYRHO0CEYFmDI1mzt1iiRzsVjmH/GDt7pLRi73ctkJJZoFMRE8xV0N0N/Yyb5vCppJMy33mN1UHLtpzqooTPGzao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772204729; c=relaxed/simple;
	bh=ahIcsQYH29MDgsHsk3aPWZV8+qTIXQ8OvSeLFAM1AJY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XegYezhjMIE/0Pqu/kyW+gIq47KVmmjeS3GjERRG363CDTuUp9kRpferflsXqaRAjNeRsVQ8HwJ2s1tQB8utTELzUSS+LmxBfFjHwj09BkHvkVfSM7/vGOvrDIr/3Mfpdz19pDNCijnrVhXslxtj/4zLGoRUhSPA7HMrkHa7FqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pZ75dtIC; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506a1627a09so12081201cf.1
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 07:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772204725; x=1772809525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t2TzIEhas5vP1+NLR/tpSxa3ebSAkJvatBHwkVZ5SRk=;
        b=pZ75dtICReOsozCpzh6opstKgORGIgcuLecgCWkLDPqTpAZ43WTT8nFkZzKgAyJoJz
         One6UnM6oqawZoqjAI2l0808m1pMGhzblFymtJBsp7RlNBTD+RmfNzVRzzNfLkoJlU7S
         gEA7nR3Kd3FmCU+wtUdkZ4CUarOPNo1WfZVsA5Xkwap5AAaV6VFBzLnqZ0CSXADIoEoo
         OoM+B7hGdRzjdTxvQIGL3FP6bCdG4xtT46N8zVJdGE0j4On1O7vGM9j4q2811bY6HB9m
         ryuGcTLjaLriNF9hjgoQWzA25o86WWLAGlrJlVGGW3OcXkg/EMb+J1zj3aDEHmePB0Da
         //YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772204725; x=1772809525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t2TzIEhas5vP1+NLR/tpSxa3ebSAkJvatBHwkVZ5SRk=;
        b=Q78aYlXS1pGpo9OT2IVcq+qGH3q0AatapHbe1WWKeGy4H+r2Mdt0GMf4KxESHsYpYs
         FmoCDQJTSp4K/EKO84fg5AT93VDmbmL/WGwhldsxNqi/l25KGIPnq10lt/Nk1/NdPJeW
         gTC1DVcq8zS+q+oRjrkxRLu7G6munOxm4ZPK8TwLYdHTc376doKq6ttL572D7eMnskNy
         vN2hc5Bc0aqddF7/GIQotvwhbRMtNpj/49sTo4rDcUhwANpHxGtLkfAF2iKNuZTwV0LR
         kOG3zdW7GkiuoSabZqY0Yuxhbmr5Wp04CROTCA4b+YHmo3W1MloBmem6pFrHMXylt5x5
         si4A==
X-Forwarded-Encrypted: i=1; AJvYcCVjKSfn0DrvUYhKyXY27i7OK7eptd6APuLFy4cJikVySobCdsXTsJSqx3yt5+QYzE+LANnH3ca54Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2010+pMjNoACX+y+ql2bmUCH8Kt5/6HW3QkkpgsYcXZJqGgCy
	TkJQ+kHdoRPTrk1rHp/JkPtrOXrnpIyOHRMVQRWYxQ8sih0Dzqs3Q1A+6zOyZWnTB/yolCgOCtr
	ShWfa
X-Gm-Gg: ATEYQzz69EkVa5w8fUT6u3C3pHLJXryHuJffR+la3sG20tR3V0AfMbS1mTwO+rXJCOD
	g5HklMu+38U6scIR8Hp+zLr7ftg68yGO1z9j1wL4Q1u514v8CdpbfGpZ80i7pF1sLLS/irMiGbb
	LvdD4Kmhxyx2YHC1zLWBOvZM0HkG/zCBxgmxKc9TXZpLIimk7G/gSGcxIlYjf1TE0OWUlLBKUM+
	ye2kqhkNSwf46wdqoSxGxd9bIc/anzSVXW47RMiE4cT/X+4FG7hElsHYxVlxPpCDo7nzPTo7Ewo
	KHLxSKcWlDJCqKr6bPiqUuzuEnj4Kwx8kfpYSxZ8G+ijkwvRk+Ho3eG99XMpMUzoTuZ+jVyeLTD
	kZ+mt+9VhGY4EU/buAVJSCVmWVTy4wn09nUmNrtxBv3ttBWBnxsIVnk2TYpm0BykYBzJ99mdJqK
	7BhUtthXhPlDxEN84eXMMMDbsz9vb1f0TOR1ElaPtTyyUzMHPI5+Qzr9zT8heFMI7+7HUQ/ojOL
	oUoFkX7
X-Received: by 2002:a05:622a:1181:b0:506:bb47:cd15 with SMTP id d75a77b69052e-507529f4f3emr32360151cf.69.1772204725112;
        Fri, 27 Feb 2026 07:05:25 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5074498f6c7sm42755561cf.11.2026.02.27.07.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 07:05:24 -0800 (PST)
Message-ID: <79408230-ee5b-48e6-a111-f76c40f52df5@kernel.dk>
Date: Fri, 27 Feb 2026 08:05:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Stefan Metzmacher <metze@samba.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12451-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[samba.org,gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: AB5551B969A
X-Rspamd-Action: no action

On 2/27/26 7:08 AM, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>       if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>           return -EINVAL;
>> @@ -460,10 +461,20 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>               return -EINVAL;
>>           if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
>>               tr->ltimeout = true;
>> -        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
>> +        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK |
>> +                  IORING_TIMEOUT_ABS |
>> +                  IORING_TIMEOUT_IMMEDIATE_ARG))
>>               return -EINVAL;
>> -        if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
>> +
>> +        arg = READ_ONCE(sqe->addr2);
>> +        if (tr->flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
>> +            if (tr->flags & IORING_TIMEOUT_ABS)
>> +                return -EINVAL;
>> +            tr->ts = ns_to_timespec64(arg);
> 
> I'm wondering if there is enough free space in a small sqe to hold a full timespec?
> So that there is no restriction for IORING_TIMEOUT_ABS...

There's ->addr3 for another 8b value, so yes it should very much be
possible. I quite like that idea, it'll then be the same as the regular
timeout options, except the values are passed directly in the sqe rather
than needing the copy.

-- 
Jens Axboe

