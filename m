Return-Path: <io-uring+bounces-12222-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0N3UMc5EkmlysgEAu9opvQ
	(envelope-from <io-uring+bounces-12222-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:12:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2B513FDE2
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 61C153003BC5
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C1F261B9B;
	Sun, 15 Feb 2026 22:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CLWai54D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391A821FF2A
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 22:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771193545; cv=none; b=BUSy7W7AaB0L0fWEs671H+rgS95uAuSL3BXXEekBQALEK38F736bkX7WP2XD4D8JKpNp1L0nsrWrukyd/WAkFIAlxjNFiABnnpxgt5/pIIWl9rJPGkNE8aMwfu3AKU+AqKFEZ74qi6bsPgwfcD7kSPk3TYJ8+NHDTa9/oO3frDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771193545; c=relaxed/simple;
	bh=jrZWx74s9eJM1hNivdKvcX5FeJluzjG+bTD1PJu2ZwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4H45yY0h1J0g8S0gv8uiAjIpdebAD79fxEm8F3YZx4wGCldvTzNt/oQAznRh28MubStbXFDa0nBX0IS90khKlaT81o9bGiUtRPheGsz/eawxJ7uBCJGJr28rVWATxrYQGyCSB0XPkopi3mwXbqU7pQMZO9fEaygHSUmETQ5TQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CLWai54D; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7d4c4b494fcso1397232a34.3
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 14:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771193543; x=1771798343; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LdfF/mSpmNSdFACtU7pdQYMC26crbr8eUshUQcoQ/2w=;
        b=CLWai54DR5n10t/rWooGIyqQuPMKw3E1UnQjsDnE3qK9TyIMNRRWctTnd0CIj/5bQe
         owuybW7/zEDf4enFfEdedusyGe/C0oier3k+M/2OMIfb+DJXKiv8dN0Nx+efYyz0rVJ7
         xSXrfOtJMy0NlixG3QmmQ8JiVhYAwW2inah0VvepKb8Bqpd3F8Zbcr9G4c9aE4M606TO
         bNLhJT4nuopxyVNPb3H6vraNh4YFiPJiL26XFNTm1fHKLy3jP8YpPGnTkp0fRnbYvyWV
         QotzL7wTDE6sjvtkFxM31ZyyazXWa0nVrC9tITjskQ29SMPYQ2roYhHFEnEcYTUohU7D
         R85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771193543; x=1771798343;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LdfF/mSpmNSdFACtU7pdQYMC26crbr8eUshUQcoQ/2w=;
        b=LqbticohW8MCIJIY1FekNFUCm3luH9sGMeFu7wgvE7RVSFCIn9+gmjnNthPumfWc8J
         txljqzQ3Qv761OsfMKSz96rXBCtUKYQ8bfRe9icRhqHWDOFf1IG7FSP8597Lgp5cRMVQ
         NMaiwKpckh+4ajNNinirRN2MHh7U7ibNQA1qU3oHNq9Jyg7MIfgAundJMehKQza9FyiT
         7h9Zwz9HCB5bTUjMZIXYfl0+iXQpMXmBRNfCweOB0qUI90jPVxzVP1Xl/OI/xs8RU+Vv
         k2afRvc/JqWeBJDGnFvLLvN2M6tpSiEgFnbGawkgmwmtnkF/LrguFFkK+ttcVI+5YpMd
         fnpA==
X-Forwarded-Encrypted: i=1; AJvYcCVPmfcXST9R7Fl1HQhERPwuVp/xyM+H5byXGqfpaIfRP2NMolw887FUOxuw7gVsfjfWI07/dzu0vQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIZPwHJC1hWWlfxRhbnFC8Tei6N5JOIYVpB88VAgW+5QXzMYYk
	0i+U9FE4dOj6e8Zzd8c/nwO2gUgkxtpPbU6DUnAFBwhYkJCVaKHuQ77FjfN6NTFVTBc=
X-Gm-Gg: AZuq6aJ7Jk4u9TPHX2K8IMtbfAw9GEUHFE/Tuv2gpBsdTl2tCHXMX/XSlZpJT3Yn81z
	jVqcoQ5sfQ75tS5uL3NJ4SKtsB8V7VSygkjKXkiSpEgRRdu5NzQIZn2L7ptHJXhTYFfW9cv0FbV
	8DwerwmtH1PJNn/VWmJ9eJ2S3NkPeqDuexloshAPru499HFzqUNjdCizG8dUVeDbNQGJm9IZA5X
	s1M0HW/aGlHCSU6kuTTokjf5rwWYC1qdfrVrhuKcOUjrEEerfOtcVY06sawoUmNvfQDx+9s+BoA
	YcOQ8S4S2ydXwq0nHuspiGH3k5+V3EfGAfvGh+tsFIJTVmbKe68ykgcLcfbvER9v4sQPfS7kib4
	TivyplVtocOJdVY+QKdaDxIHT0VmRs+uDpQyjYrtl/bURN4KgYVzrtQ79LZo+UqS9IyWQawn2vZ
	rE51Qhe0qc+XWiD7cIUN13J2unh0OGS/pSEUoWAjwBCvky/XGJ2opUuhrQzNI+E4xg/W6bOdh+S
	ez14dLAHw==
X-Received: by 2002:a05:6830:631a:b0:7d4:c224:3405 with SMTP id 46e09a7af769-7d4d0c6e689mr3846240a34.34.1771193543192;
        Sun, 15 Feb 2026 14:12:23 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a76e1b0csm11177038a34.14.2026.02.15.14.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 14:12:22 -0800 (PST)
Message-ID: <13b4de9a-cb8b-40a8-9e56-6996adf96f9a@kernel.dk>
Date: Sun, 15 Feb 2026 15:12:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.0] io_uring/query: return support for custom rx
 page size
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <2e8280467c93ead0c61ed3d68c036d6a0474bb78.1771188227.git.asml.silence@gmail.com>
 <b9c6eea4-cc66-43ae-bf87-907b35db9c8e@kernel.dk>
 <611435d8-0f3e-4c43-bd37-9e74d8512de3@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <611435d8-0f3e-4c43-bd37-9e74d8512de3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12222-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BA2B513FDE2
X-Rspamd-Action: no action

On 2/15/26 3:11 PM, Pavel Begunkov wrote:
> On 2/15/26 22:06, Jens Axboe wrote:
>> On 2/15/26 2:34 PM, Pavel Begunkov wrote:
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index fc473af6feb4..6750c383a2ab 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -1090,6 +1090,14 @@ enum zcrx_reg_flags {
>>>       ZCRX_REG_IMPORT    = 1,
>>>   };
>>>   +enum zcrx_features {
>>> +    /*
>>> +     * The user can ask for the desired rx page size by passing the
>>> +     * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
>>> +     */
>>> +    ZCRX_FEATURE_RX_PAGE_SIZE    = 1 << 0,
>>> +};
>>
>> Well I guess one comment - supposedly ->rx_buf_len is going to be added
>> in the future? Because right now it's not there.
> 
> # git blame include/uapi/linux/io_uring.h | grep rx_buf_len
> 795663b4d160b (Pavel Begunkov          2026-01-24 10:36:17 +0000 1115)  __u32   rx_buf_len;
> 
> commit 795663b4d160ba652959f1a46381c5e8b1342a53 (tag: for-7.0/io_uring-zcrx-large-buffers-20260206, axboe2/for-7.0/io_uring-zcrx-large-buffers)
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Sat Jan 24 10:36:17 2026 +0000
> 
>     io_uring/zcrx: implement large rx buffer support
> 
> 
> You should've already forwarded it to Linus with
> "[GIT PULL] Large buffer support for zcrx".

Ah this is why, io_uring-7.0 is behind master as the large buffer
support got merged post the netdev PR. OK all good then, it'll be fine
once merged!

-- 
Jens Axboe

