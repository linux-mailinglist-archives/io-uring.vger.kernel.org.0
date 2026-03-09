Return-Path: <io-uring+bounces-12592-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OLEPDNzLrmnEIwIAu9opvQ
	(envelope-from <io-uring+bounces-12592-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:32:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A00F239C83
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AC5E830072A4
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E16142571A0;
	Mon,  9 Mar 2026 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ScT2o5Na"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013D21917F1
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063124; cv=none; b=Ig2rUmsiZPpQ53AdcVeaa6/m5UwCWUWwnGTwd61SV9AuvloiSdl4qlM9+596RSzBrc/Glm7DGCsEbwZM/eUzMi6d6n0ivLROyCgRyWOmGijHLe2d5WE/QAnOHoJAR6zo0iNfKGjnT8KD0zK2GliYUMCCDRZpgqkLVI4gFS1CzzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063124; c=relaxed/simple;
	bh=PbALbg1Lql9/BrfktmSJLhF4xYjDe4iV6f+5npldWCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=THvvjumNGBvWYLI4szfxVE2tODfOJZ/TfMVtoyLs1zyH3Npe2NC8bbu6X98DxP6Ey/H+92yH1oF4cD/x4WJgU3d55U/X9ffNqscvi3AdAyxtlF39aXpu7f6jko6C/HUwXO6EjlKnyubAUVhBr4SW7ep3hgbl/U2O2TGDyzEm/Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ScT2o5Na; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89a44a4baf1so17883746d6.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773063122; x=1773667922; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0AXNRXGpDpPzUbs9vGGdSlr+/LahlD2PC5FFSGu0Flg=;
        b=ScT2o5Na0Yd3r8NHxv9gRjSS1f5OV6Rszt+UUibYBlLkpBRKvFlYID0r5lai5oJOCx
         UURFY1ngCL+zdc7tTkhQGJVPjIAbaMLbTDtk71YQG0vM9exfSqDsUUiOA+4EPIs+iznB
         E8KhrtePF3aFSjzsKiJAMn5zEEfsu8g2APGNTIlUnFo3Tb58Hwnn5W/oM5wLmoVcEv/K
         oUH8C4raU/nobNPyd91lrDkceAQ4+Mpni6YUdeb8mbX9/OjYvirQqg/RjtgYyx2vQLOl
         PO0GXf7zLrQxg5Rjnr3V3ySAzxdon5ZZDoqZ8NRE0mbzAl1HR+WYnW9oxpDzPdPkoahJ
         EeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773063122; x=1773667922;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0AXNRXGpDpPzUbs9vGGdSlr+/LahlD2PC5FFSGu0Flg=;
        b=PkT6uhDVYmSyRuqdOQWd4Mtiy7g0oAe4kGKZhnmkUrsRLvIGuyw2IFoZc8yY0UY5Df
         /1PVeLX8vm6V+btqzw2Hvi06ndw3PjANAbM3UYsflSQnXkL8xFcTsjcOtqpui7/5t6s7
         ZZN+QKvsM9qETNnpSWRsp2lKT+K8vYIJ0lRmhhODyvzbx/yQk1TgXJsgpoSLnu/nW1y3
         FeAG2uoEL7K1IckFdX7poaecT0qIhHoe17N+749vbFPegjkjAluJtNIDYdYYda3gylH3
         26NiB+wbGcTOgdnSIKpHUDj8cg/FehgoRWOxrv6ehUUqTv+RYvpDFcyTvY04JVWO2sdL
         1Bgw==
X-Forwarded-Encrypted: i=1; AJvYcCU0xxBFK8SxjDSn8X58E0I7od7poLgdtT774kr+R8DcQgrhRqbXHJxG4wLlRKRA7/tE8YUWOUuCNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwyP8ZiNYjmUwRBvaaNV3ImG1RHrlVlJmwwg9pVZn6nPd06PsxQ
	xCGWYUJ1Z3lqNzjFWoW8xO5VOyW2+hT67hNMVKr6Qy+umS2AFPkrdSf+cytDd1b/I9E=
X-Gm-Gg: ATEYQzy6v7oaSYcSc45UECaoP6qAkFV1Mg0MmdotCsA6sEbkG1cmpG1hzWPeRft+i4x
	u8ldSymy9LJgkfStMvXEQnlXv7zL4jjk/F3b2MpEo3BU5zbkXkjofMJlSq9ZNqF6ad/dXM7Nxsn
	rcrIiPHNlpj+F49bXAZsrF2aDFTJevoikSp/heR6phfnAHst62eY0xSMVo/dk+ZWI6onAWGARW9
	rLhSJV8nZTCrM4P1IJy1dXo9Q0Q9GMQdxx0BqTeoyHxdRvBiCKe9S7uKtdDr3wlY1Qrd4vtnboe
	bTqyS9x6c6JH2e21K5z6M4kXJgCPFJbUXA1bCHPyPD00UHrD4KLVGcCSQ/jGUxC7OAuO+JP7mzt
	uZRZ9jIPK5LSwdDE6O7WK8Qp3g2iouqJT9tp68R0TPb8iBqvgHIuQSFa7/cbL37U9Xuqfulmi8y
	QHbT0TYIobcn0VM+k5yeHE7nWrTkZ+dYO9VkKUumfFmRK8Jt1LjA==
X-Received: by 2002:a05:6214:f67:b0:899:fb77:a1de with SMTP id 6a1803df08f44-89a30a2a5c4mr159567726d6.5.1773063121877;
        Mon, 09 Mar 2026 06:32:01 -0700 (PDT)
Received: from [172.19.0.48] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a316da714sm73406876d6.24.2026.03.09.06.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 06:32:01 -0700 (PDT)
Message-ID: <7890871e-dd12-4100-b306-83cf4b3f9b61@kernel.dk>
Date: Mon, 9 Mar 2026 07:31:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/net: allow vectorised regbuf send zc
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c151f006cbac6eb51863881d338b101186740cc1.1772493339.git.asml.silence@gmail.com>
 <14f88099-6c27-4dd9-8868-f7e61ce68474@gmail.com>
 <c7efb1af-3270-4959-ba40-98c315e6bdc6@kernel.dk>
 <4c53fa3e-e2f3-46e1-bf70-e3a63d330d55@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4c53fa3e-e2f3-46e1-bf70-e3a63d330d55@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2A00F239C83
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12592-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.970];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/26 7:26 AM, Pavel Begunkov wrote:
> On 3/9/26 13:21, Jens Axboe wrote:
>> On 3/9/26 7:17 AM, Pavel Begunkov wrote:
>>> On 3/3/26 12:32, Pavel Begunkov wrote:
>>>> Enable IORING_SEND_VECTORIZED with registered buffers for
>>>> IORING_OP_SEND_ZC. Set IORING_SEND_VECTORIZED for all msg send requests
>>>> to differentiate if the vectorised version is expected.
>>>
>>> Any comments for this patch?
>>
>> Looks fine, but it depends on the patch that just landed in -rc3, so
>> need that first for staging for 7.1.
> 
> Ah, forgot about that. Let me know if I need to do anything
> here, otherwise I assume you'll be considering it after you
> rebase for-next on top of rc3

Yep, I applied it now, did the rebase for -rc3 just now and
pushed them out.

-- 
Jens Axboe


