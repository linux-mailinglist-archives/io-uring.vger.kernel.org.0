Return-Path: <io-uring+bounces-11232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38317CD1B2F
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 20:56:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62AAA3073163
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 19:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCB22F069E;
	Fri, 19 Dec 2025 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JtJPNfPA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com [209.85.167.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DCA3BB44
	for <io-uring@vger.kernel.org>; Fri, 19 Dec 2025 19:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766174168; cv=none; b=n8l/RHCN0nboMIh/tbjhHa9G3zGRGsse5RPPvNvRHybm8+ofC1mevJD45NHforqEBaCvK8PXI/RFmz0MoicSshqFD4wlDsp/HhbaZZkkdLijxIKQg6tZJGL0RO4NHlZpejBcMM7NBKvUv56fJlbe07J2ubyq+khmFrLolIG6MHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766174168; c=relaxed/simple;
	bh=sjl0+XIeCBQe5ghIO11hweZd5kYgQ6YdOE4DG3SSKc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+dSjxtculQ41cmSHWEX9dRSRsa0centE/55Xm7j+7F4qu+QgHVYZWi7iAYYJ31H6Yy1SObIynocnwWLbj3gj7MrCQb5LtiHjoqlM8BXzdlTEfB1m20JL2na2WZ0HNVJDQsujh8oVnBfm+gF8nAF5m1LSDMVFWcWOyROZ73tgzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JtJPNfPA; arc=none smtp.client-ip=209.85.167.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f195.google.com with SMTP id 5614622812f47-455bef556a8so1375164b6e.1
        for <io-uring@vger.kernel.org>; Fri, 19 Dec 2025 11:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766174160; x=1766778960; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Hm6nkQNYnKJDfhN23z4T+46KIzI4PMKW+EpRlLkSF0=;
        b=JtJPNfPA7/WOzyzZwxar5Njf/OplGXaoErGE7L3YohKvKfMh3kEV2idIVyxcytf7+w
         PIZn1Oo3grOBdvGPYgmEbI179yRCJj7KFE1YrLPRB84NkG02ckmEfYlcgXDtoc/iEtR4
         rfpxqcczptyX6ONahC4KTfdGmDzNod/Adm/0qpD8d+c9yq0JOUte02Qh7ltwllJRRcLD
         p26oglxFBBPA5LUXNZQQM2h0KvqvfT+Hu+4x83dzupTtezu7CpcDp7nbB94jjfyui9pb
         azRzR6++qD0Ykx6Y7SyQiAbzKlPhvHHtLEfTMiy4FC475sQEHhqzD8+rg3RAxy+D3ads
         zzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766174160; x=1766778960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Hm6nkQNYnKJDfhN23z4T+46KIzI4PMKW+EpRlLkSF0=;
        b=wmg/v/9/HDHN57o2WT9e6YpeISM3t86PXvKHFnDF/JRvHBFu6lm152fU4+6T50la83
         J0k6m692ICtSKuFcCRdn4qdyZ32FxmnR5k3jDVwKvBlVsJt8shXucLuMw0q0CILpi8rf
         35gYuO8uGzJnAT+iwQC/yyX1MtZw36PzK3xEjoKXcidK2JcVJNlOAe2+wop4t5dhGSpV
         50peY/UIeaTV7S99jCXQLW3lwaZDMD6U26vNFvkkNZ37kdLakLeTt9scgTM/vT2Q3U75
         +dEO4CmB2GXyJBQgw8y5KiLsyJ9Fxos9TzyXHBIbmQU93vLMMm/UrruevrrbD+lDjpgR
         t7vA==
X-Gm-Message-State: AOJu0YxinaLaQwS7Yfer1ubYd2JXDK0WLe1hbDhuxdbaaUxhPrMAZHVV
	dg01Sty5mi5MI/63kNdaSN6FOu+NZt72l2QzOwbAJohg19QD9r47QkweI5piOU3BaYQ=
X-Gm-Gg: AY/fxX6Pni3neBNUW2gjay+C3snmJ55pqrmodi8j72sY/PnW1KSLyHyBBmVmAfxfdRl
	A7pz6zpjb/VEmuK50nU1vbeDmm4hc6sEYZAu/WZTDM4DICpX4FFn4nLb0t23Q4siNSQymb9Y5+k
	W4sHsltqa4zl3sNq2WO5mhMBWXDuzm80vE68MDwKXohqb7J5iYiLxofV6rSqXsCTXi0puPgcnhu
	GlhmlWj/pjEsKOU9apOa1YcXQzWwJgmuYcw+8e9di+f1kIUP9xYE544WhJVOMoXr763UpBPv6jD
	SujoDgedL06BW7l4ZDybnWb+V7gy+CM5wF3E9Ker1QTfuLwVIktqBXQXQtfdAE1oQ7gJL7pKhpN
	D9jLzGqJtVqGe/F8V2ztEG3e+sJ7Ot6T2HxQ6/oEGOMpLDXbbowVULeljixsjMbJHPdbwO58EJr
	v8soPHbjE=
X-Google-Smtp-Source: AGHT+IHm5acKkwicIn0szUoRUloJtAO/102qG3bI2/0D5LzBeiwIWh6V+d5ppeu0AIUp3FWI15DkfQ==
X-Received: by 2002:a05:6808:c22c:b0:450:d8ef:d804 with SMTP id 5614622812f47-457b20ca13amr1775276b6e.39.1766174159815;
        Fri, 19 Dec 2025 11:55:59 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaa931b0esm2031392fac.8.2025.12.19.11.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 11:55:58 -0800 (PST)
Message-ID: <fe9dbb70-c345-41b2-96d6-2788e2510886@kernel.dk>
Date: Fri, 19 Dec 2025 12:55:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] af_unix: don't post cmsg for SO_INQ unless explicitly
 asked for
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 netdev <netdev@vger.kernel.org>
Cc: io-uring <io-uring@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Julian Orth <ju.orth@gmail.com>
References: <07adc0c2-2c3b-4d08-8af1-1c466a40b6a8@kernel.dk>
 <willemdebruijn.kernel.18e89ba05fbac@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <willemdebruijn.kernel.18e89ba05fbac@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/25 12:02 PM, Willem de Bruijn wrote:
> Jens Axboe wrote:
>> A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but it
>> posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
>> incorrect, as ->msg_get_inq is just the caller asking for the remainder
>> to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
>> original commit states that this is done to make sockets
>> io_uring-friendly", but it's actually incorrect as io_uring doesn't use
>> cmsg headers internally at all, and it's actively wrong as this means
>> that cmsg's are always posted if someone does recvmsg via io_uring.
>>
>> Fix that up by only posting a cmsg if u->recvmsg_inq is set.
>>
>> Additionally, mirror how TCP handles inquiry handling in that it should
>> only be done for a successful return. This makes the logic for the two
>> identical.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
>> Reported-by: Julian Orth <ju.orth@gmail.com>
>> Link: https://github.com/axboe/liburing/issues/1509
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> V2:
>> - Unify logic with tcp
>> - Squash the two patches into one
>>
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index 55cdebfa0da0..a7ca74653d94 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -2904,6 +2904,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>  	unsigned int last_len;
>>  	struct unix_sock *u;
>>  	int copied = 0;
>> +	bool do_cmsg;
>>  	int err = 0;
>>  	long timeo;
>>  	int target;
>> @@ -2929,6 +2930,9 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>  
>>  	u = unix_sk(sk);
>>  
>> +	do_cmsg = READ_ONCE(u->recvmsg_inq);
>> +	if (do_cmsg)
>> +		msg->msg_get_inq = 1;
> 
> I would avoid overwriting user written fields if it's easy to do so.
> 
> In this case it probably is harmless. But we've learned the hard way
> that applications can even get confused by recvmsg setting msg_flags.
> I've seen multiple reports of applications failing to scrub that field
> inbetween calls.
> 
> Also just more similar to tcp:
> 
>        do_cmsg = READ_ONCE(u->recvmsg_inq);
>        if ((do_cmsg || msg->msg_get_inq) && (copied ?: err) >= 0) {

I think you need to look closer, because this is actually what the tcp
path does:

if (tp->recvmsg_inq) {
	[...]
	msg->msg_get_inq = 1;
}

to avoid needing to check two things at the bottom. Which is actually
why I did this for streams too, as the whole point was to unify the two
and make them look the same.

Like I said, I'm happy to give you guys what you want, but you can't
both ask for consistency and then want it different too. I just want the
bug fixed and out of my hair and into a stable release, as it's causing
regressions.

Let me know, and I'll send out a v3 if needed. But then let's please
have that be it and move on.

-- 
Jens Axboe

