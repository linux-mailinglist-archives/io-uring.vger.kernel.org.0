Return-Path: <io-uring+bounces-13874-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id xaqUNqlcRmrTRgsAu9opvQ
	(envelope-from <io-uring+bounces-13874-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 14:42:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C60FB6F7C66
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 14:42:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=yozfMGgp;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13874-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13874-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 05666301C5FA
	for <lists+io-uring@lfdr.de>; Thu,  2 Jul 2026 12:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C73C47ECE8;
	Thu,  2 Jul 2026 12:28:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE6D47D941
	for <io-uring@vger.kernel.org>; Thu,  2 Jul 2026 12:28:43 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782995325; cv=none; b=dIqaliEf+oPsqJMaVB7B+QSBRUA7VBzU2RVHNua0zVe4NExfmoZaFwUqP2rM/LcDMsE+o7ezA8Lbyrz+Y6lKGVQw5g6/hiztYtFSpINqlA5rwteqLSzv/2Z2WHmdYWVYhu7GAxn6x3Reu3YvH+PSKp7TKkxmCLz4aGC2ncXCwNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782995325; c=relaxed/simple;
	bh=0l2LxvDt7UfXZ1hVd9nq/gh9PAiMbcudWaEkfkPGV+Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DoBRafdSM3yGfjRVQEy/ucNQbLu778EAsEUQ1+LIbpfoDsRnUHKjYMqfNGVy5YI+GRkk20sUFWjag7aI67PGlQ/QkEaqj9xwMTnpkRMW+fK93S2pj4QcB52IKKvitK/Uf71ZoPAv2WGffVycWM2npHMce0Y/sakggBTE8+8Nw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=yozfMGgp; arc=none smtp.client-ip=209.85.160.41
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-44192448b56so680558fac.2
        for <io-uring@vger.kernel.org>; Thu, 02 Jul 2026 05:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782995322; x=1783600122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gNHgJiXjQGk+XBhSMuAFFm5pwO6lQ66UvkaQutQL5hA=;
        b=yozfMGgpsCUU9nHrQK8NHuQW08rMSRbcpcW8JXvvWlbyRCjIqPnZsDBGb9uGVyyhwW
         06IRhifl9ZDlYHkPapi/r/TB056XmH0loRv7xTkTCq7tWIh+nTXkxYJ7JEzNUPYl4Jvz
         bn1uvj9rPoIkLaFtlCC+PTwhFtM/HKbAqVPCRBTTHS+/8esq7AHTb22vO9z3sDwo1qhU
         NYcHPgg5+e61ae9/v0DeeycDgYb1nZSglhaDYVhDTmu1A2EvfN+qHWcTDOeZVBw65EEP
         l9V+g1jXoX8zFSB3Lzum08CmfGMRByn0XSrTNqQ2QF/iNNSgix62Xszk7xuSWRC4j/zY
         eUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782995322; x=1783600122;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gNHgJiXjQGk+XBhSMuAFFm5pwO6lQ66UvkaQutQL5hA=;
        b=XtcQGQW1zWTLXw2+DPSDhiLWPQ2i0k5KUHSOUCRtE0HSUvG9XYwuFVS9v6G9qD6g7i
         Y5G1O42N8zuG+VXODPGO0mEWfcyuntfw68R5s+qXTZYo+NcnvMSyhAugZDCX4WggNJE/
         zdLnV0h3PGmJDSztAcPOUTpAmzHgO11Yu+VP13IBdJQxCYP1rz/zX15KyzmDZqfzsRu8
         RgqI8CRVVE4bmbrsUhxdJfbEIckuHDLgtjp5LAo8CD/+HZl6NMfcK14oFxvSvaIKgeMd
         GMrOdonZ7UNdQAAqvsyc1iEJeaaYcO6Dz2iKC8BmO2MTgD8CavMTpNIcONIYaUUYkqOW
         4O2A==
X-Gm-Message-State: AOJu0YzKBLw4YhE9JXvDw0binTYW5dFaLVY0SyrVCfagiQgrQqXgv4kM
	oJVWY+prEohPOuz/WxF7BIsJgXeh5CP4X1oXdWXeBShkJEdiZSJ6rWLXT1gJz5y5IPo7tsvo7Ix
	lVloRAfQ=
X-Gm-Gg: AfdE7clmQaZbB85eY6VlOlKsfBUFYt7P1TcJBODRgrFOh44Aopajw7ngF/PvvpeRXP6
	ObMcG6oI65cDYPBXDMxLZDR93klQ8rNAOm0kChXsU38zSP9yOXV5yukzhq8jbvrHGeP5vUUAthk
	NMqizJj+GcPWX+gH2lTLrzROlo5amN5pdZqx+JBoDF0jkdPMFqCTwGNMQK/xD8zranCwQmU8iPQ
	NTKk5vmfxPRo7KtU/aofsLepxn1z/GSHOo5uA4ffAtfKqT4KZYUPwnDaDhMXvplGSJ1D7y0Q4MM
	ebHODZ3h6MVnwn7MCWfX9woU+ozSUTlvUuT4Lp811nRTF6S1ALDTlTzezXjHyBFR2ZoIAr+LWBB
	d/jaJr165lLGjZuC6hdaXqbXaCzgOpSpWGb2AJXzHmrK2h3l3fNVgaezPbs5ckeJoED/BHMjkXv
	iHxqCfszJiL0Qo+CAx+Mj9zv3KBkwXOs6VsXvTjXhdvfMjK64/QsV+QDwhTVeZVpzjLYcgXJ/xB
	WjC
X-Received: by 2002:a05:6870:a08b:b0:43d:20f3:bc86 with SMTP id 586e51a60fabf-44caab9919dmr3641713fac.0.1782995322334;
        Thu, 02 Jul 2026 05:28:42 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cbe84efefsm2623259fac.2.2026.07.02.05.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 05:28:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20260702082937.3707134-1-yangxiuwei@kylinos.cn>
References: <20260702082937.3707134-1-yangxiuwei@kylinos.cn>
Subject: Re: [PATCH 0/2] io_uring/uring_cmd cleanups
Message-Id: <178299532149.108615.6162973296477000207.b4-ty@b4>
Date: Thu, 02 Jul 2026 06:28:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:yangxiuwei@kylinos.cn,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13874-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RWL_MAILSPIKE_POSSIBLE(0.00)[104.64.211.4:from];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C60FB6F7C66


On Thu, 02 Jul 2026 16:29:35 +0800, Yang Xiuwei wrote:
> Two small io_uring/uring_cmd cleanups:
> 
> - copy the SQE into async data in io_uring_cmd_issue_blocking()
>   before punting to io-wq, as the -EAGAIN and fallback punt paths
>   already do (discussed in May [1])
> - fix comment typos in io_uring_cmd_mark_cancelable() and correct
>   the memory-ordering note in __io_uring_cmd_done()
> 
> [...]

Applied, thanks!

[1/2] io_uring/uring_cmd: copy SQE before issue_blocking punt
      commit: c0da6ecf90e4f54dd8a3afe6ddeed427cb4aa091
[2/2] io_uring/uring_cmd: fix uring_cmd.c comments
      commit: 12dbe5d2476980aa78883b12c9cb90b656f5c50c

Best regards,
-- 
Jens Axboe




