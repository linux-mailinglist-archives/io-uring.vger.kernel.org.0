Return-Path: <io-uring+bounces-12946-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8HRuE8bsz2lF1wYAu9opvQ
	(envelope-from <io-uring+bounces-12946-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 18:37:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B79B396822
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 18:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E57A30C07B6
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 16:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0080D37F8BC;
	Fri,  3 Apr 2026 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Uicdt+c9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC61A2F746D
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775233316; cv=none; b=QwKi9GkTNpggAc4bc23kFZGxaG7q2wzy1dqAKt2g/8vAT3gS6cRb0B/Q+AcwOOZstiXoI8/ogHc8YzmwkO6Ri0yx9CL1kclTWUM9S9tywQ+ibId73wTgbB5C9laI1gvyRI5YHJs+v3f3Od2CDdnl8K7LDGJHeebu2bkZUMxXdQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775233316; c=relaxed/simple;
	bh=dPSQrKJAbbctHYrc+Bdqm3FE5/Kn30hhJvK+QotsBQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tRs7/R8j/TELAgUaf6yv8mXCOAa48kafCNEiYPwN+/G1UnIMpYvf+6gSfgNIBQKQ15eVuZh23sJ37EsMH5jnwYsj1LnLrSRRTeDEWk295Pa6pKLecrsGmm258mqOY7DDb9wg/L9S4oZ8MBSmzkBkDSyGfXHjJ+htZ+EQNPQEzSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Uicdt+c9; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7d9e22176a7so1035976a34.1
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 09:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775233314; x=1775838114; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rX9yK2a+s1gR6nOy7D9OY01uaDcSY3q9xhmTadj+94M=;
        b=Uicdt+c99QyaoPcSOO1j5+YOKo8jhUR/rAmIFHd6062KwOjdJik722EtinfljMJVnv
         bbLxXhmAxEWOg+gn+z5CwJtIvvrYIxoWaK5I4TDRKH67WteRQuOIcrxZjexdhTslP4BJ
         DojrfyEAVf/qoJLi6rDKRh/J9DLgiVcXDqa0MPsZnARmfch+f3OxdLw/zMD+47GraAiT
         cBAx4FpmqkaTsCiGxEjI+OOjvwV3btdd9JX5rCTJsLnNCX16jgmclVszmI0gXVyu1089
         v7ulH0kRcoCtQuB5WilmZGQjs/rbcsiyozgm2C1D2VZHam2TvE1TVCJtIIM4xk8jNGGC
         BIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775233314; x=1775838114;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rX9yK2a+s1gR6nOy7D9OY01uaDcSY3q9xhmTadj+94M=;
        b=ngHwxwcsTGM57MgDxntt/AA9PnXCBggSsa5GtYDcuJG/Aej3Wkld0ZPgsJelQNhgME
         tadpwAm5D//LIeLxJNVusZq1Hjqbx9or/nWjKI8QKwRcAyTLHVl8DS3ijhCIGTceR4WB
         7rgYdXZJdqwmMsVsxyEeWX5vM/YM1V1V58J9E8IZGon7cqMrLN0oGCEL7ACv0SMNh4E4
         TogEz7HJY6U5MndVksFVWzQwBp+NUqKs39CXCPAYhVplwm/9SdLNPVqW0DF05HOdvjQQ
         oULhre6EuF53dXY5Ie7VL0q9CaxjyL7eg8Vkg+bKfOzia3dwW8NG/rPcGLexRMKSkh2p
         0y+g==
X-Forwarded-Encrypted: i=1; AJvYcCU45VFTgqf7nkbG4irNAEg0RrtidDg2VSLWW5g0nRXn64Dc9p8rFtroDhjtzZYWOMj2otcnIrkP1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSULZxD1Q+GU8lrXp/qc+XcCVGa/dC3sbbIyIN9Cj1yRS1IovE
	tfrdkg2pfkDw8RF3spoPn1TMjLXeOqSKvH1PX9A14Arob7/N+RjyE8OsJBk7hTbuTNc=
X-Gm-Gg: ATEYQzy/9P7Bw2+enww9A3ecFAdEjT71UcxnekALFIW3O0aQJcKYaNmS65lg43UOay5
	h6L9+gFF/ZqFAK1G+zeceyCqeQFtZzyEuGH8yCH1a+Zd7P7UyuhqoqOh3AzbiAmGBsV0l7breG/
	SwyALuHH48kIF9quC1k9MB9ayyp0m9Fd85oZE9klRg5Qu8z/77K7RMm4oYtHJ87Btrw7JzCEW+v
	tQMEJw6TIl7RKvsKYn3xlEBEVdiz5CgQx7WaeXuyJ2rc532OCdq7PpeunxaVKbHEPDQb0i0fhRx
	bdl7d3cp/AIe2A/Bck3IcRbNT4qCdZjcC1BhjhLdyXhGjuP3H76jj2EDe/voNgr6yxXwR1wM1E0
	NTTDCc+cd8c1BlyksDLF8570Yj46q3NKISvZlL485Kflb/Ny5jMJYo/UTYrSL65nI4VDIYGs9YY
	AtfihaDc/oJoLEwldzOt7sxKS6psLR5zCVzjCRD4TXjiBEsuCfnylUwGtm+Ce+Z4cPFWiBcI/9/
	wLfr+Zr
X-Received: by 2002:a05:6830:64c8:b0:7d7:d1e1:69b8 with SMTP id 46e09a7af769-7dbb751784cmr2248459a34.16.1775233313634;
        Fri, 03 Apr 2026 09:21:53 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba7183dfesm4861662a34.9.2026.04.03.09.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2026 09:21:53 -0700 (PDT)
Message-ID: <789726e1-c896-4073-b712-e4d03cce5133@kernel.dk>
Date: Fri, 3 Apr 2026 10:21:52 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260402160929.2749744-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12946-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 9B79B396822
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/2/26 10:09 AM, Joanne Koong wrote:
> This series refactors and extends the io_uring registered buffers
> infrastructure to allow external subsystems to register pre-existing bvec
> arrays directly.
> 
> The motivation for the patches in this series is to make fuse zero-copy
> possible. These patches are split out from a previous larger
> fuse-over-io_uring series [1]. The fuse zero-copy work that builds on top of
> this is in [2].
> 
> Thanks,
> Joanne
> 
> [1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/
> [2] https://lore.kernel.org/linux-fsdevel/20260324224532.3733468-9-joannelkoong@gmail.com/
> 
> Changelog:
> v4: https://lore.kernel.org/io-uring/20260327172631.3380702-1-joannelkoong@gmail.com/
> v4 -> v5:
> * rebase to origin/for-7.1/io_uring 
> * drop the io_uring_registered_mem_region_get() patch

Series looks good to me, but I don't think you used the right base? It
does not seem to apply to for-7.1/io_uring, patch 1 runs into issues on
the ublk part.

Since this touches both and applies to neither right now, maybe do a
respin and just base it on my for-next. Then I'll setup a
for-7.1/io_uring-fuse branch that is just for-7.1/io_uring and
for-7.1/block merged together.

-- 
Jens Axboe

