Return-Path: <io-uring+bounces-12953-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wDdLOs8H0GnB2gYAu9opvQ
	(envelope-from <io-uring+bounces-12953-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 20:32:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 26CC6397527
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 20:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6619A3023513
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 18:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BEA33C19E;
	Fri,  3 Apr 2026 18:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="GyVmSfvN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCA12D781E
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 18:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775241072; cv=none; b=j7Y1XSHHLzCFumiJ8bZEXqDeuMkgw6t+jaq+TptCOIj4vBxc+7wv3xw46HxjQb1attyPKcwSOVu5R8q16CcBEdaZoLaqs44t0PkeNmM6Eb8jyfXOsucz1J5Xh2innRtbz9IFbyjs11ybdKxP5UkDPPiQuhHPHPtlPweGWuvNVmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775241072; c=relaxed/simple;
	bh=dYuC27v4Lkh38NJFwk9bFTmBqVUJ/nTRpbzau988TSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tydds0DhvjYQrBfoSAQuC0ARwYJ+uClQvUUmOoPEq/lHDk3kXya3PvaTLpnC3jrm9eYHswju62aMA0f5TQUYIwQYwWqHcpNcMsrlc3kgNKeuLQ3SUVazCMhatztrl/kInXJN8+0I+vH/MVBgnG+fVZIHb0rC5j1LrkHn2tBNOJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=GyVmSfvN; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d750eeaec3so984773a34.0
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 11:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775241068; x=1775845868; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ofETq7sHwOc9Mu1huoO9QM3sbIhKg8bM9VYK61ir04g=;
        b=GyVmSfvNQu/pVJMZF33jb3SByAGrZOo5eYKMBhqvNbEKpOshyibkh84//Q8vFVZZ1D
         RdnjVlzFM4C3M5AoA+Gh4sk6xUVObayRXCoXOYzVVyQBospLrpms22cluASatfySqjx+
         mvvWFZ561/VGA3Dfr26OYCGHkXqwn0HmNRDXiYTY7lD7GX40HjolDnugRmWr8yryiTba
         x06CysLUo72d/4J0cYcRMW9xl4X4A2ovkQx/yizTbeouc11RR84NJkQc+q34Js2sFHbn
         F3Y2wq6JeEUfsnlGH1X0yzGhGDt7cdBfXC/kCoUGnzrIAo3BK9NxAyNZYGb+K7yFYENE
         mTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775241068; x=1775845868;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ofETq7sHwOc9Mu1huoO9QM3sbIhKg8bM9VYK61ir04g=;
        b=XYkkpdkE9uixXAfHIgk8vvIg0kA/FRvK6YvBQ+zpnawrsj8bP8hiG/I5ZWA8rIxPsx
         TmLIZFbCeXtqLJyeg2uyjQvYSAxfjnDeV85z48ZME3onCsmcC11yM+0UlUf2/XuiiHKu
         cQo1FXbUUCuqLaSkIJEd+Pa1BsFfb4Hs+L/SAwv+1DOH6DhH++fUDmZP33bHb4IW81nx
         3MdDFPNnkDYi6yHl0O8KAoZiHkW+7JaEN6bbI0DpwJS7hABit0q2j3VU436W8W/1HI8r
         O33XsogWOo0mdYaS9NdHacKQXJVcq6Wfc1hqBUFxuufgB9Kzz41yQdA6/YCL5JSsecmb
         csbg==
X-Forwarded-Encrypted: i=1; AJvYcCVq+GMbO0d96cJxU63Zx2qkILLOVvj6BzL/R7hEAJiex1/1pA/4JuatoXiBwAV8idUa+63MctbaUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnoVL1+CjjjEv8xcLMhOUFOPB3Fw74meGN+DqwkNCWWlwJIwpM
	cmjlFVFcZrMMcaFPq2dG3Yxxumn4WHm20lIYddKZqfwbB/zs0fFt2ZnRUJq4cQnCpVo=
X-Gm-Gg: ATEYQzys89A/HO/ruFNlzuK68jVJE7He7eeApF1MHlIs8lxLQJ/0qiSh/tqsUjG1zbw
	vg+O+ho01mYljuhrr+bauNZfb/Abq0mguKTXiAs91cNhc9PWeFe5UK9HvkGV0tKwXu7QFET/5FP
	z1dKCeP5MeJfGtjkv/BMEn+8Qdj/gmXCbFFWKje255kdw1MBA33zLHpaGXjCWohJQWxb0CHZHFR
	ivPUZe/MpI9FuEAWHFRrV0NATqeAp+NyM24OCGPvWKYcbbdlT9xxvafy5iQZ1x+rBYUi5euOooA
	wDbaz+XnegpwB3YKsNlx1U01IZ5gY54uRPhYr0eqp9HXzbsXmxRjbRP3/xR/yVFw0d+cqXWAxEm
	78A4kdqJb/x0pJQTG3BiKtx/RGMW+fx9NnOkM+GxvqAevx1rGCYAccVnIYpQkcQJywrPKu+UpX9
	Y0imrMGZZCJSZK4vLW8iGrprp4CF39xIxHEcXTqGCQcJWG0xY4uSXiSIg0skwaOJRCtZOdYGsQV
	pZaNchw
X-Received: by 2002:a05:6830:4112:b0:7d7:d702:401c with SMTP id 46e09a7af769-7dbb73530demr2454328a34.32.1775241068435;
        Fri, 03 Apr 2026 11:31:08 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba73d8126sm4712645a34.27.2026.04.03.11.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2026 11:31:07 -0700 (PDT)
Message-ID: <83e2f358-8be3-45c0-b877-03088ff9b516@kernel.dk>
Date: Fri, 3 Apr 2026 12:31:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] io_uring: extend bvec registration
To: Joanne Koong <joannelkoong@gmail.com>
Cc: csander@purestorage.com, io-uring@vger.kernel.org
References: <20260402160929.2749744-1-joannelkoong@gmail.com>
 <789726e1-c896-4073-b712-e4d03cce5133@kernel.dk>
 <CAJnrk1b2_nW5YvEn2YmfiJ_+kuOLypFFYd47Gch-=a9rQ2NFbQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJnrk1b2_nW5YvEn2YmfiJ_+kuOLypFFYd47Gch-=a9rQ2NFbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12953-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Queue-Id: 26CC6397527
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/3/26 11:30 AM, Joanne Koong wrote:
> On Fri, Apr 3, 2026 at 9:21 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/2/26 10:09 AM, Joanne Koong wrote:
>>> This series refactors and extends the io_uring registered buffers
>>> infrastructure to allow external subsystems to register pre-existing bvec
>>> arrays directly.
>>>
>>> The motivation for the patches in this series is to make fuse zero-copy
>>> possible. These patches are split out from a previous larger
>>> fuse-over-io_uring series [1]. The fuse zero-copy work that builds on top of
>>> this is in [2].
>>>
>>> Thanks,
>>> Joanne
>>>
>>> [1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/
>>> [2] https://lore.kernel.org/linux-fsdevel/20260324224532.3733468-9-joannelkoong@gmail.com/
>>>
>>> Changelog:
>>> v4: https://lore.kernel.org/io-uring/20260327172631.3380702-1-joannelkoong@gmail.com/
>>> v4 -> v5:
>>> * rebase to origin/for-7.1/io_uring
>>> * drop the io_uring_registered_mem_region_get() patch
>>
>> Series looks good to me, but I don't think you used the right base? It
>> does not seem to apply to for-7.1/io_uring, patch 1 runs into issues on
>> the ublk part.
>>
>> Since this touches both and applies to neither right now, maybe do a
>> respin and just base it on my for-next. Then I'll setup a
>> for-7.1/io_uring-fuse branch that is just for-7.1/io_uring and
>> for-7.1/block merged together.
> 
> Ahh that's weird, it applies cleanly to for-7.1/io_uring on my end (on
> top of commit f847bf6d2930) but I do see some merge conflicts with
> for-next for the ublk commit 24d4c90286b9.

Right, sorry I wasn't clear, does apply to for-7.1/io_uring, but you
end up with non-trivial merge conflicts. It's always a bit tricky as
the ublk changes generally take the block route, not the io_uring
route, as it's more closely tied to that side.

> I'll rebase this to for-next and send that out.

Thanks!

-- 
Jens Axboe


