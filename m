Return-Path: <io-uring+bounces-12482-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNAoJnAfomlMzgQAu9opvQ
	(envelope-from <io-uring+bounces-12482-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:49:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F271BECC2
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B24813067A31
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217BD36920B;
	Fri, 27 Feb 2026 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bjCv3Gyz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CA43191BB
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 22:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772232480; cv=none; b=n/LdT/LydWhcEhraDsbwOXDoPOr9HLovbk19szVz6cZ4vLn9XioB844YRu7SmoUHlmXohaR1QOwHrYg0ZYVFBJMGEpUSzUSTFyQ1KusvJoiPaT/pkoSH66LHSvaHwnJtwcZMO9n0mw0+ClaDz8Uzi1mMGZZ71MO6ZIPtFV6/m9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772232480; c=relaxed/simple;
	bh=lnQZpqgmctWNg+LqxkppyDODDBPLBveXyogsAlKvbNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F5crzh8tzYisWouJJQ8VoMSSPsag3/022+FspQvOBntMKxERI8D6C7/kj4Mknt9sIEZMxyEiypkWXEdW1xbf5ugahEO/8IjQnkhEQy5VooCWVgCFs+PKC4gsrv3xEhBpyx/sI8xcTdEU6dzADHw8wCGcXPm5j12/GKLUaYRk6qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bjCv3Gyz; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-483abed83b6so20823345e9.0
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772232477; x=1772837277; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=md2kHDfOgutbhmtX9eh/0L1fh0fBbbQI3jewLy3TWHQ=;
        b=bjCv3GyzL3FPfaOXoE925ESr+OY7V9eCkYtku5aO67M883LV43tpYNwnScYcwOK81a
         7CrRSbFnyATbE8l3BxgvhUO+yk3YIKObgJUpfSsmLIhbolzB1lTIRQ63XhIykJ0FbBJZ
         rkCwI00KB653iSpCLgAXblSEzI+5d3z/ejBzZtQWbl2YWo0c77kcrnPXJ3d8csMcgL1U
         37nbjJojd+1uD1kZgS3Z15IaUJ7RrB+9ZIzsBxUmHO3AOguXb4n0oUHyH702GIS9DEbR
         K+b3X/m1Afx5x9OBnt2tOInpYO/BF9A6ef17w7T7UZ3egVu+cqTJWkdjClv7l7MQzuvp
         mbAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772232477; x=1772837277;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=md2kHDfOgutbhmtX9eh/0L1fh0fBbbQI3jewLy3TWHQ=;
        b=mRjoV2KMrffmgxqjWMV6Ut+rv9CXWCRQmN4OVBbWkTo3mHjumLx3v14QlMZEWhplh5
         2YCMh9qcnFzUJQ2wk1hl3d+RbkQtUipJvyIgPeA6paIS80/WAmqRXbwc+AU/Advledgw
         axi4JglDb1VnNLmLimgGDKbHI1Y8nutLzBsLCzJIyPHlNtKFjdcBkWVsELdj4amiaP/+
         ypQy/6UfbqRY6UoOdZKFzwHSIll0HQgCpvwaLDSZV5IcfC2BUI9cJHTn3C16K6xjnVmE
         QlO3OEkDgeFVxDU9+fWbSNVbu415anqTe4hxSbZPuRAWXXPZiWm6fzTF+8ZoIrrylAWm
         Ex+w==
X-Forwarded-Encrypted: i=1; AJvYcCX9ncckhAu62cPCmyWEKdZM7w+Jqw9jv6Q0h4syGmAwfVoDMhUqCuJbInR2wk6YUNr3oByFckAx9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/5VSR7G3sjYIAUeF6lADMDAJRItrK22acaetXvCXP6uO1hMbt
	B3aCc8gvUTipmgv9hVjlwsa5295RzmlpxVmNHLOehFRXV2kokcLrexB0
X-Gm-Gg: ATEYQzwVXah5j0wm3WoZZs31x6bRGAWPWUNZuCn4llumMdl8qzQ/N+wNqhXvijHUIVY
	WvxCtGYRmXe6N5ho0lyevmRNE1DUWJdd+JvWtw0tFuok6Pc+aBhhyOOvv8gU4TW1zy+4doNTMo4
	EHutiyta8ImZDu3PHlE9jtfFZ8NiPFhw6pR06hBhJaITIIgyxhFTomPWgJR3Q18yu5Mt8gtx626
	7VveKv9mm9pq/dNKAkPWBEQKGZwkGRPhTG7P03XWORYbI9GWgSHChhB2gDG47McYtzO44RCJM7P
	+GRENSmTnf8FxtbPq/MA3uS9LujP+uKYkdVhGS97N8eYh5JozJ8cpA22PMTlfqOK85fnJnsteEi
	XVTM+PWGoTpmnUQCth9aBO97BErVxwORAo0Qns8akEfrcHFmvM+hvfKNOVnWrGhp7SR1DiOh+ef
	AeC96b0EWxXqC+u3Kv43cdPyJsWadNwYLzFkASpRmtlIJEHqbbcfS/elnQUQ05llg8KyJb4OuMf
	K0FOA4MCSSdPIKsV5i3ssxQs8fMMdtccPvPopcQuQIj/PjSOPFTd9eo56HKgCsJqa6Iec9Gl2no
	8w==
X-Received: by 2002:a05:600c:6812:b0:483:8062:b2f with SMTP id 5b1f17b1804b1-483c9ba3af1mr65188715e9.6.1772232476646;
        Fri, 27 Feb 2026 14:47:56 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3addb3asm142577825e9.0.2026.02.27.14.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 14:47:56 -0800 (PST)
Message-ID: <11058b2c-55b2-4a4f-8d80-7533211b16bf@gmail.com>
Date: Fri, 27 Feb 2026 22:47:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
 <1cd9a071-dc93-48d1-81c9-24b65e65e8bf@kernel.dk>
 <dcb21382-36a6-4d5b-8e79-66290e522f2c@gmail.com>
 <2daa9b01-d989-4922-b892-e7f3f06297ac@kernel.dk>
 <cc9ba4b8-88f1-48c9-8aae-fe30a6b5c282@gmail.com>
 <e834eb01-6cde-4249-a797-ed1fd9f8c713@kernel.dk>
 <2ab205f2-fd87-4fcc-9c0a-0bdebbadeb58@gmail.com>
 <3a8e5738-b417-440a-9851-b8ecc2a82b82@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3a8e5738-b417-440a-9851-b8ecc2a82b82@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12482-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F3F271BECC2
X-Rspamd-Action: no action

On 2/27/26 22:19, Jens Axboe wrote:
...
>> They should be enabled in the same release, but we've been rather
>> discussing the way to do that. I was saying that u64 is enough to
>> pass the abs timeout value, and we can extend it to another u64 if
>> needed in several centuries from now. And it's not a bad option
>> because plain u64 ns makes much much more sense for the relative
>> mode. And even for the abs scenario above, I'd prefer that rather
>> than doing second adjustments every single time.
> 
> ABS makes very little sense as nanoseconds, that's pretty confusing on
> the userspace side. That's the main issue.
> 
> I'm not sure why it's such a big deal to just encode the sec/nsec so
> that userspace can use it directly from a timespec or timeval which is
> most likely what they are querying time from anyway? If you do absolute,
> surely you'd do
> 
> get_time(&t);
> t.tv_sec += 1;

More like +N ms, which would be

t.tv_sec += N / 1000;
t.tv_nsec += (N % 1000) * NS_IN_MS;
if (t.tv_nsec >= NS_IN_SEC) {
	t.tv_nsec -= NS_IN_SEC;
	t.tv_sec++;
}

And then you want to compare them and calculate differences. io_uring
works with __kernel_timespec, but just take a look at liburing
tests/examples, lots of them open code some version of
get_time_[m,u,n]s unless they hard code a specific relative timeout.
It's a self propelling misery.

> now issue timeout for that. That's a hell of a lot more natural to use
> than converting to and from nsecs.

I'd rather convert it to ns once and use that after. And I bet it'll
be nicer with other non Linux specific libraries. e.g. you can get
ns from std c++.

> For relative it's obviously not a huge deal, but it'd be nice to keep
> them consistent.
> 

-- 
Pavel Begunkov


