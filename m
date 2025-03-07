Return-Path: <io-uring+bounces-7011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD4ADA56DBD
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 037E016C0B5
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98F123C8C6;
	Fri,  7 Mar 2025 16:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vyKWQTtb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB8B21CC71
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 16:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365153; cv=none; b=DKU4thGMpYLmdiuQtwRm061Ls7hAV5MKk6+8/mFeLcZJru9yZ93png7izaJlF7OpbL5rP3MTTj9l2Ms8V3G6GKO2y0Q+CMCfD5m+i4ubPVPv1bW+xjmiYrHvTFxr+56hAdTbox/A7gLzaalqivH+cnagHna315Gcfddm1r0WfNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365153; c=relaxed/simple;
	bh=xaiQsJdBQxlDeOtm+4O7NGV7vcMhAxgto+N2EHIhGcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NVgpibp8BubHcbCAgvwUVUkZlcfHTxZtnknWFoiODgpzxdqT0q8HiqMpLB+bZmiqEGVwp0/BdpJgj5sNuvq25LytQ3DtGlrXcXYRX3MB/kE8d+MuF8r8wJO9lb0chgnDok7sRESedaczwvmWKR0Y4A4k2Hm/Wgh4IJaisKM0k9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vyKWQTtb; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85ad9fafa90so50482039f.3
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 08:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741365151; x=1741969951; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yxZG4GvpT+foDYYOqA5R+bdl7vVryacA7OvSQ2kb2w8=;
        b=vyKWQTtbd+945VUGfTn6XAMQm/6HQ368a4Tj1GmAbPPrQIKUSy5VPauOL1P/JqKwsw
         wrvSvXpPDmCBEwpu4Ys8ioo84qayGxXnWaRuCF5Ji6ZjQ2IXZ6mPH9GghKDzjYIHP86q
         H3pS2bbupyf2c73WUD0nDRp1zhXEEEdHvTOpq3atvXSFxySqaFaVO10gcjAUZ1qzK3tN
         d7TugjBBhF6J57AItd5uIhbIonefOjvl2WHj2ZzAOo9vYy9eVeUxwuIV8mSqw5HFuS9h
         LkPvDd1C5I9bLkAmVqnlaaoYSubpeOegb8IQbRbHqVSPX0HC1aIZ4q7E52VidnLfK9yA
         WN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741365151; x=1741969951;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yxZG4GvpT+foDYYOqA5R+bdl7vVryacA7OvSQ2kb2w8=;
        b=wkGl8rX6fOI4fv7shKfmZmhQK2DDo1j7qOymqsu5I7TM6Pc4htKpk5gHNhgJSdx0G+
         8DZajGOdfxGygQCLgbK6nBv3BRgHIEohQBl7zJX2x1A9BxOyqUH4094MiarKdPXKEiJc
         CGSZEbMbSiiG2x73tFY5cofQo4xPEX4dL7SGNTXWreU31rodQ7YlSzUZWX7Wvuxs8c1r
         HqGxibYCeXdvl0oTnCLe5o4NDhaxrjXd3pII+LRMuI1n2MI7PBpJ9u50JiO9vCdFQYvC
         e0tOszEx6dJYEsAQuEoy1nk7F1YIbiXqlrNNumKpff6kJB68IAhQBdO3Vadt41Hmx7Qe
         hRLA==
X-Forwarded-Encrypted: i=1; AJvYcCXpiUA/VO2u7+qrfBfJp2KH3te34vUMzbBd1Noaoj5/U8fBqlDqH5Icpp9gYeY/04I+BKtn6axDew==@vger.kernel.org
X-Gm-Message-State: AOJu0YyzLsyH8h102zrDWahM6r6dUIidS/q9UxbN8UblrMdsa+ZFwafx
	xC0m4/yvvIVCPmiEUdDo3Ykca8XMxoNPfcJeTcfZjEBNDmbu8dECGJNE3Euj6cc=
X-Gm-Gg: ASbGncsAEqLyOuGAQvyFxF6nCHNatCgNFLM1IeZTAKmYYtZtDeWpzfHt9mMCnJGnK/8
	aiBoj+Wsurii98SR8owRkqvLkcFhHAdAg04bpLIZlvJwsP4luT0i1lbE+1gKfYHyAgxm/mNhVn2
	Lp7WkUMDq8DljGr+tMMPTGxtL+YU7J7GE0eGDNaVbxaRHB7xdTFKBJiH8LBtF+9UJEG99QAgMxN
	2uJe9/+yw4rHpv7SjjLDieiRxe58gH9C0Y7IoILwogp+dupm5Urz3Ykt4HtGe6hLhDyvVVJO81H
	VnUqiordrppGPxE2WR/NUtWTLjqGW2Fv8hccEadY
X-Google-Smtp-Source: AGHT+IHrkCLjuVHj+BJlje4EuU1N2OofbZGNyuXaZNfL0mggj9MLt+HfmyCGFOKlxxG5IOS/M2005w==
X-Received: by 2002:a05:6602:3a09:b0:855:cca0:ed2c with SMTP id ca18e2360f4ac-85b1d0d5b8dmr500795539f.10.1741365151234;
        Fri, 07 Mar 2025 08:32:31 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f20a06a6a7sm995329173.134.2025.03.07.08.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 08:32:30 -0800 (PST)
Message-ID: <5a0ddd31-8df1-40d7-8104-30aa89a35286@kernel.dk>
Date: Fri, 7 Mar 2025 09:32:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: support filename refcount without atomics
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org
References: <20250307161155.760949-1-mjguzik@gmail.com>
 <fa3bbf2c-8079-4bdf-b106-a0641069080b@kernel.dk>
 <CAGudoHGina_OHsbP_oz5UAtXKoKQqhv-tB6Ok63rRQHThPuy+Q@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAGudoHGina_OHsbP_oz5UAtXKoKQqhv-tB6Ok63rRQHThPuy+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/7/25 9:25 AM, Mateusz Guzik wrote:
> On Fri, Mar 7, 2025 at 5:18?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> +static inline void makeatomicname(struct filename *name)
>>> +{
>>> +     VFS_BUG_ON(IS_ERR_OR_NULL(name));
>>> +     /*
>>> +      * The name can legitimately already be atomic if it was cached by audit.
>>> +      * If switching the refcount to atomic, we need not to know we are the
>>> +      * only non-atomic user.
>>> +      */
>>> +     VFS_BUG_ON(name->owner != current && !name->is_atomic);
>>> +     /*
>>> +      * Don't bother branching, this is a store to an already dirtied cacheline.
>>> +      */
>>> +     name->is_atomic = true;
>>> +}
>>
>> Should this not depend on audit being enabled? io_uring without audit is
>> fine.
>>
> 
> I thought about it, but then I got worried about transitions from
> disabled to enabled -- will they suddenly start looking here? Should
> this test for audit_enabled, audit_dummy_context() or something else?
> I did not want to bother analyzing this.

Let me take a look at it, the markings for when to switch atomic are not
accurate - it only really needs to happen for offload situations only,
and if audit is enabled and tracking. So I think we can great improve
upon this patch.

> I'll note though this would be an optimization on top of the current
> code, so I don't think it *blocks* the patch.

Let's not go with something half-done if we can get it right the first
time.

-- 
Jens Axboe

