Return-Path: <io-uring+bounces-13109-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gMBCItEh6GmjFgIAu9opvQ
	(envelope-from <io-uring+bounces-13109-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 03:18:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 886244410E0
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 03:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 28B183004637
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 01:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5030E2741B6;
	Wed, 22 Apr 2026 01:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="tKQgzwgR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6422475F7
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 01:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776820682; cv=none; b=NeB8JK8Ky1nNsNp0+QxPhMwZOYHbM398DLIBbiSEfqszkd4UiJ5u3pZLmUNi2gzTYNCKtrZHHdthqu58l4iZrtIVzmS8XvJZM7rv2bIpqmDTOFd2jeKOTfGXMg69kWlY18pXuxigQIUKp3QhmuuRp5q0rfloVo6iQdKlC/bPrLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776820682; c=relaxed/simple;
	bh=xkh0EB9JtR9Rspvy75oI5J5YnXDWRLgVwbmZQL2fvK4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=o4OL46xKR88pi2sJ+KzCtTerStWhoVwZ6Fd5O9gwa7ISB+WotRRVQiDDxao5H4TpbGKhidRvXIeYdSl/sIUnl52KaJaEztQgea3Mv2jIoZ/IXjHiZpkYG4giEiIV9fY+IFwuI++rv+zaOAjpzBvWXHY9LWLDy3pb6o4oGOOUWmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=tKQgzwgR; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7dcdca9dd6cso1029971a34.3
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 18:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776820678; x=1777425478; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YY1AfpykqB6/8ZSZ4dOuiz3qCfysQmFzkgR1J6eWrSI=;
        b=tKQgzwgRel3eGEoZoSkaVdfgBHKCo5ebse5v13tS27tTLYkzn7g9rQuZTuz75TES9V
         ZcfyF2ddJr23a1xV8wzze8eR4tpG4HBwpyFDNeT2pb/n518LQ4ooz3FVY2ryzYE/iYxK
         5fkVfAfdvHopdNqvF1Aj7Ae7dld8s/iiBXaIM5bX8z5F8fGOvv9okT3DOcGYdlqOVzfz
         2c8eEtUixBt9E4sZx5z8Kt+OfIiCvezWa+qLkW/bReIQyYRpoFp2YWiJIVEqjCvkoZsV
         kow/Jsw3QJ8EJNqtTgfcCxBHfjnIaVBPyCMXbu8O+wvka+NbwpG3LqeiJb2WPT67HaiZ
         1mGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776820678; x=1777425478;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YY1AfpykqB6/8ZSZ4dOuiz3qCfysQmFzkgR1J6eWrSI=;
        b=cdCdASg2249hiSLrEzJrZdnbhm5TbQNwdnV4F9f7GAR8Ye389AHMOBd0TZCieSw1vC
         yuubUbcOPWS2zIb62eBFH8UtxnOebL+kQPUIj/fFATGZzUlmg3T1x7R2EZIURvPQxqYE
         lDjr5g0pV1Z5OsPu5npOtJBOkIgQ7IU8gawp7IzX8q8a1Mm3crV6NYjxkdDTsS6/8tHq
         N6Hc7wxzqnMywHrtGT/DJ4rqczgqo0oYTIZ8d2ghVJyx6xeYQsVv87ske3rzBfml/Z9X
         M8u2gNv4mGzGNz4gAyByZ4kYM9bWj1FXzf+KDobjqAcRUqg/wZdWXdUCGBeJn/rZtSqJ
         y8Rg==
X-Gm-Message-State: AOJu0YzfeXY/ZjIYdvCmDp0jUnSrK5caBQDJbMmhk8M+gN6vcigKywza
	Uj1BIlfeYr7afbco6cNJ3VR7AAiqExLyOOPvohRY0PYO7IEyoKOkwiudtN+Gygl19CQEHMoB+Hx
	4qF9veAA=
X-Gm-Gg: AeBDietfd31Heolckbi8lS3UT2v/xY+aE5BxKAetpkbEKqJ65SPfo+ZDz7NOX+oRrCE
	PIIt1MCHJDEnc+QSO5S0qYSNsrFmM5CI664DJSJgynk/uWSiQuKL717ycoIPLmYtdb014lpqIUS
	cQZ5T3edhy8QsxxhcTJh+58vK63LAxuhOBZYoaI53IMVr370gMvQNOMUW88/qPqd0gPcISHYYUj
	IQsPcn75kQrcdAN0tZPfW9ukGtPAOXXcAtWxRkbhKcNm0aXTaImp1OZWYTkT0iOHB5O4uhntLf7
	PaCsKdoTYWldy2xQDbUCNOlk7WIRN/o49gSkM3zEMrGGvpthrOndl2ItlpALYuCo27mfwdlr1t0
	l0MiAbrHTLi7L8fZpUT6skcEnyZMv6e9LtDanAaqCTSQo+tNnp9nikrGex472jvbGglVEn7kKGV
	KuyiisqdPH8EcKCwe3+pEEBtKMGZQB6WPbwEe7QTloCmo5WOwy/gqEiG44R4dOI9gzH/PhCTnp4
	9H+3jergKnAxnQ9jVfl
X-Received: by 2002:a05:6830:439f:b0:7dc:da80:42be with SMTP id 46e09a7af769-7dcda80470bmr3338986a34.21.1776820678417;
        Tue, 21 Apr 2026 18:17:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dce20ff8c3sm1731771a34.22.2026.04.21.18.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 18:17:57 -0700 (PDT)
Message-ID: <dec29d85-9e79-42df-ae3d-9af65134283c@kernel.dk>
Date: Tue, 21 Apr 2026 19:17:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <2026042115-body-attention-d15b@gregkh>
 <177679318887.642042.703437019420919449.b4-ty@b4>
Content-Language: en-US
In-Reply-To: <177679318887.642042.703437019420919449.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13109-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 886244410E0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 11:39 AM, Jens Axboe wrote:
> 
> On Tue, 21 Apr 2026 15:46:16 +0200, Greg Kroah-Hartman wrote:
>> Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
>> virtual address of the io_mapped_region's backing pages directly;
>> the user's VMA aliases the kernel allocation. io_uring_mmap() then
>> just returns 0 -- it takes no page references.
>>
>> The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
>> each inserted page.  Those references are released when the VMA is torn
>> down (zap_pte_range -> put_page). io_free_region() -> release_pages()
>> drops the io_uring-side references, but the pages survive until munmap
>> drops the VMA-side references.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring: take page references for NOMMU pbuf_ring mmaps
>       commit: d9b7b3d9c5286a786c7fe8220c55a6e012088c2e

Actually, I take that back - what prevents the io_mmap_get_region()
in the newly added io_uring_nommu_vm_close() from getting the same
region that we initially referenced the pages from in the nommu
variant of io_uring_mmap()?

-- 
Jens Axboe


