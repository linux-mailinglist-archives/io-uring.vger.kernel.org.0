Return-Path: <io-uring+bounces-13831-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id lGK1OiDnO2pofAgAu9opvQ
	(envelope-from <io-uring+bounces-13831-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 16:18:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4EC6BF059
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 16:18:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=WclpVzuV;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13831-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13831-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 184063004211
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 14:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5C73C062C;
	Wed, 24 Jun 2026 14:16:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCBE3BFAE7
	for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 14:16:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782310578; cv=none; b=nEnXKgJG2aQreHGqvPnSdCRXQTpkw10e5cpJ87XNIS1parG+UR7IuRjcovvcrK/QxLA3cbuwzfWrNjrGj9X35TEVJZ+5daShE1C9fQCewhhv0VyhjUcYF854Bp9m3jVctEdLOt0BsT6IHySaXrBfWoLzIsO2Quvv8SQRNYIPvRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782310578; c=relaxed/simple;
	bh=2NdA5/p72KfjEyqZ3DiqJDmRDrPEAvTM4rSY2HekhWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ApfH7ejAkOy7JP6VIaXbznCmCH/iuWSp2+BhMEZOGDcaKat1yKh1cxJeqccWWhEoR1HHQ9SANIJ599KFGiy04lUfD9XhKN5m4iLbffrnAb2/3Xdb4kUFW9c7naVrrdOMOZUnl2TBXro6SuRC62pSGIcCwedg1cOFzzFFKLhUFj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=WclpVzuV; arc=none smtp.client-ip=209.85.167.178
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-489f3611e0cso890619b6e.1
        for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 07:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782310576; x=1782915376; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PgTfczseYi6ugKvk0bDuzHtGtJY7ftHoZLCYxr2ha8s=;
        b=WclpVzuV47o0asJtiwcpTGNFdnHbFZ3lDeHJ/ufklcVAcRfTX6Tj0WX/ZCvye6ZGqa
         qXIIuIWI8G92XCXRomPo0R2n12e1dAqh8QNwOC/zJxtamPX67BzfD5Ua22C+kvDJv0vR
         dqIinaaDHXopa8MYAIvknbXQ8H8XKATtzQ0dGjHIbeMT6JtxGktabxCfnLe1uJ7/RdD4
         QKtSeohAcnWcVA+OPjRBDRKa6Btuu9dlAALvnsHBQj9gpqmRT4eCarvD2GLxD2q03Oa1
         TSALIhf1fKbPNsU9ag5L9jGpI6PwUNG47e/osA+6E+hS3KFIi3OuvwvhYwzHuvFYHqIE
         MT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782310576; x=1782915376;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PgTfczseYi6ugKvk0bDuzHtGtJY7ftHoZLCYxr2ha8s=;
        b=pxzDAEkgrrA8EsWXvhXeeJetGXo53VlZw04MxlT/JJUUm0m3TSKT62pzvBkhU54thJ
         C8qVqs9B7h0NPEEHYnADmymCJ4WSalc9i9bKEhEHZB1pQg9wIt/iqE8jbkAfVqygnxcN
         MMbJptEoTO99gwLzjZ+Zl4p/GUmZx6/NOpcL0GGXF3eZj767qOIcweuewkhE2lFHFdfz
         5tLUC9grDQf4vq0hXvCIpZu5lNL6uCGbutOOUNP+x1WbGk7QfF1vQFXf7OSUVvFPUm/D
         6yI8cSPAtyQQU2Y5GAJ4SWe+yi/bLDLlEBr/83ODnGvutu8lMrA3y2b82DM8hxVM6rM6
         uL5A==
X-Gm-Message-State: AOJu0Yy84zKSZQO/E3ghTEHolKSYdEX6yodvnNTsufzZXiJOMqLAO8Yr
	Ljppp4vZq1p8RZ9ail22X0OwXHLDqtZJumpMhqC+XIVomKGUc1J4gon2ZLujpvxky8KZh4pggCp
	dBvs0KAs=
X-Gm-Gg: AfdE7cmnN15wcRer6YJAt9BxfSHGJ50il7kPM3UkBHjOHs2Uu7QGQjdlrTlGIAmmbIO
	PvXR8vm/kcpNNF0ZexYmjTxedk48JRBonZmUDwxA22TILPVdSdOTV0/q+HdgAReavYQMfuxCfed
	1FzC+x3UU7EnfrAFSYfXI8X2cd2QFw0l7TkmSsL1L/+W3c4dwQp10jTEL1/BxD5N2JzzVRBBynR
	+jRNlLPXSkFBVPr60/o2GHn3j87cNuXEj50qnd33IiwFnuBeQtIribPQyxD12a7u3i5RlP7AvR6
	/MzrhlB2colvg005l7foPBCXtrOsnb2v7W/j5hTbs6BHBVvUvX7kjwn/h6xRlDUPXPk6WBMe+ye
	wfLLbUw8vqearwad1346VTERcjweQZ1GHJuAD5KgxkEiBCXteE0XkL4V9KKWdYxJUN4K/v1LDwx
	mP2ynKmzixebHMb0s/GxK7PpYhHSj1ZlABB8kB7cOM3JIDkki8pxCMUih5VrXpv7Q5/DIzS8o=
X-Received: by 2002:a05:6808:229f:b0:467:27d2:96a7 with SMTP id 5614622812f47-490773911f2mr2306023b6e.15.1782310575712;
        Wed, 24 Jun 2026 07:16:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48aedf25c05sm8591897b6e.10.2026.06.24.07.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 07:16:14 -0700 (PDT)
Message-ID: <15170077-5975-46d4-b2f4-6cf47ee8151f@kernel.dk>
Date: Wed, 24 Jun 2026 08:16:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring: annotate remote tasks for kcoverage
To: Jann Horn <jannh@google.com>, robert@fmmr.tech
Cc: io-uring@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, kasan-dev@googlegroups.com
References: <CA+fCnZeE6-8NFXjguJJKc_=UuF-Puw8BdtiFcUhOd23y9pAKOw@mail.gmail.com>
 <20260526164948.831543-2-robert@fmmr.tech>
 <CAG48ez02Sio8ZENVK3gUWM+8j6NgG9LxtnDV=v+FSqsqs_KfnA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez02Sio8ZENVK3gUWM+8j6NgG9LxtnDV=v+FSqsqs_KfnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13831-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:jannh@google.com,m:robert@fmmr.tech,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:andreyknvl@gmail.com,m:kasan-dev@googlegroups.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,gmail.com,googlegroups.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fmmr.tech:email,vger.kernel.org:from_smtp,kernel.dk:mid,kernel.dk:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3B4EC6BF059

On 6/23/26 10:37 AM, Jann Horn wrote:
> On Tue, May 26, 2026 at 6:49 PM Robert Femmer <robert@fmmr.tech> wrote:
>> Fuzzers use coverage information to guide generation of test cases
>> towards new or interesting code paths. Syzkaller, specifically, makes
>> use kcoverage (CONFIG_KCOV). Coverage information is not collected for
>> kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop.
>> This patch annotates io-uring's work queue and sqpoll tasks.
> 
> I think this is a useful change overall.

Agree, mostly waiting on Andrey and Robert to hash out the details and
we can get this landed for 7.3. On vacation the next weeks, not much
going on on my end, work wise.

-- 
Jens Axboe


