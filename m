Return-Path: <io-uring+bounces-12258-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANsfFIFEk2kP3AEAu9opvQ
	(envelope-from <io-uring+bounces-12258-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:23:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F8B146136
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:23:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2001C3005A95
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B244D332916;
	Mon, 16 Feb 2026 16:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CCpu+HHV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com [209.85.210.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DE8330B23
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771259005; cv=none; b=OsFseCJ8cm2m/8ZEJNKQUtA8CxKuOscGOqhkd4q6DxroLYDAzoTUGrqaL2nraTzgyoXTYPuTdDdPBNPwlKbm70ieQsqQ92sozrBbBcTr3TzlTdaqcmwVcg8hPR+Xr55p3GnxooUsONNb+GuuwjSYP7wVMNAq8S6qq81taC4BZ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771259005; c=relaxed/simple;
	bh=m1nloMRnM0oeo+x9sv3aM6i4zG5u+strVh2tZOECEJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l9rS/RWfYU3RM9tW/++QvUPCnrrRdrNlewVigsol9AAbnM/3eXkCI9OW48bAahYm7yykwwjr7tVaEVSr7uMv6K+mpgFY8lvM92tVx2MX2r9JPgiw0QA9T4eEJkUoszMK6jJ068DFHMdLfuA2lmQpG8neU7RoAMBQ6YIDqVPAF5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CCpu+HHV; arc=none smtp.client-ip=209.85.210.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f67.google.com with SMTP id 46e09a7af769-7d19bfe1190so2433908a34.1
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 08:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771259002; x=1771863802; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TjWL5sM0G1FQ+jMC+mkklTprfYYIjUggdeiLyXbAUok=;
        b=CCpu+HHVDG1WcD+GIRMNP+FINavLUoWzTNGQcm8DmiT5HPTIfLgKuC0NM+nI09Yxld
         ikn4y1NAy/foDDxloAVCm64TlyEpQeXxTxeulwSvAFwRjvZyUw2h6ihqjXUiQk6Mc1lG
         3sB4r6ULNgrv6OWv9H116BsV4vSs2nFB+OjHD8MXtd+uB+LZxCzhCAUOkDPVvvG3uKB1
         DD1/PbUyTDCxHo67g/mLxSuIoj/pA0nQb8PIekhglhPaujCzDPeux9EM31gK3bcM51Uf
         wT+VnaQj5tX/Pjvz5EI/xhAi0i65A5tLQfWVPJ/8FmpbViWzcbkF701UFD4LZEzvBxhO
         5eNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771259002; x=1771863802;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TjWL5sM0G1FQ+jMC+mkklTprfYYIjUggdeiLyXbAUok=;
        b=Em++vkeYct8lRWgrFWA3oZrDWFQn1HkN2Rr/kvvTNnYnPyOEOjwd5En366QvRhRlv0
         5NArlM+JiinSSd6wa62UbKCQN+CndYYpH+ORJcbF0uaYi/NYc4zA4fP0bkwTE91r/LQh
         U5jsX7TMkq81wZOi4WCZcGoYKAMHUV8BZpL04J2xrMZO+q49eDK5Lu2Ax3ttdeP78CMl
         3a52aD9hegTIZB2rSLWTAnCLilORUANbbp9YXFiWXz0AmfjRhbo1CaasrU4bug0wN3x2
         B2GW8Tg2Mp9aKWF+VL2c/EYx+hslbSNyt2VI01FpPAmsKzTNoSv6eM5tNU2aMqnx4LwU
         2+dg==
X-Forwarded-Encrypted: i=1; AJvYcCVomJ11+kUq3Hww1ChMLtsgkrw+f8jTMG7jZwcWQ35j0fqBAeVnoE3x4W2atU7/hd/X5b96gr/VyQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVpjgakfxL6ERumoX8VqePVCo6LiDNqmqddqvjkrayoxVOUghh
	qQTmSJ2s3duSpwQeYHa6x7+gUbmkqeEjbpQLKGaXBeern7CsIKT8Cru5JKwwtsFOv3RbR6rO2NG
	VKMVBo0yfuA==
X-Gm-Gg: AZuq6aJKi/Hl6NhUrYKBBHYvioIWwRldZeH9pvfO9RMLfEqd0JZnrfCQquHx5RtQ+JN
	DOBRuUVHBv4SOSwYBIthQUGtyb3n/ebsQuLMJsplYScQ4zFyP3OXgMAxEeTEElXykO+t5M/r2os
	RU30RfH+nNTiUgh5XEoDHoE0rGMGPtookUPuVE23yE2lp/qCSkTnAkDQIUZ39+277dHRJNwgbAk
	hUOWwdlv6uAn720IACD/1yw4jrIogriPqH+b9fwSMq2cb1bOrvYIJ3Jay3/DXmQ7+lsVqGDr4YX
	bzr5uVHh9l7DGcWtcECeZPICIK1ma90q30h1NvK8WlcAh3VlC2lX4OBnHjKg5rXOMCsbBPaVahS
	EHRv1TWvtMYPXEN7mBHmiLaCv82f+ZOelaigDe41ME8gaML/aEbKuY6MAEvQGCTK0ddVnuNPAgb
	k58MLjwaBwc/xXbG3CxG0NmFxB7CCVknrBf/b/5q/gOssk/Y90YbdsuAydTaFiouGXeYZgvnyhU
	VPcA4Fv+Q==
X-Received: by 2002:a05:6830:f91:b0:7d1:4f4c:532a with SMTP id 46e09a7af769-7d4c4ab0431mr6737889a34.20.1771259002102;
        Mon, 16 Feb 2026 08:23:22 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a75309bcsm13026533a34.1.2026.02.16.08.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 08:23:21 -0800 (PST)
Message-ID: <d63ef500-f6ae-46b6-ae3d-03e3c2ec9778@kernel.dk>
Date: Mon, 16 Feb 2026 09:23:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: document advise SQE field reuse for 64-bit
 lengths
To: redacherkaoui <redacherkaoui67@gmail.com>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260216161426.10810-1-redacherkaoui67@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260216161426.10810-1-redacherkaoui67@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12258-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: D6F8B146136
X-Rspamd-Action: no action

On 2/16/26 9:14 AM, redacherkaoui wrote:
> IORING_OP_FADVISE and IORING_OP_MADVISE reuse SQE fields to
> support 64-bit lengths without extending struct io_uring_sqe.
> 
> For IORING_OP_FADVISE, the length is carried in sqe->addr when
> non-zero, with sqe->len providing legacy fallback.
> 
> For IORING_OP_MADVISE, the length is carried in sqe->off when
> non-zero, with sqe->len providing legacy fallback.
> 
> This differs from the more common addr/off/len interpretation
> used by many other opcodes and can be confusing when constructing
> SQEs manually.
> 
> Document the field mapping in the UAPI header to clarify the
> intended behavior and reduce the risk of misuse.

Like I asked you before, what on earth is this patch against?
Stop re-sending the same stuff without answering the question.

-- 
Jens Axboe


