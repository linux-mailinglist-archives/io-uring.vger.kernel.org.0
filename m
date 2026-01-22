Return-Path: <io-uring+bounces-11892-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4GcDMtKrcmkkogAAu9opvQ
	(envelope-from <io-uring+bounces-11892-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 23:59:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id F17D96E591
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 23:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 94EE03007229
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 22:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9EA3D9055;
	Thu, 22 Jan 2026 22:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="T7HKBza8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BAC388863
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769122765; cv=none; b=S/vl0cej1th+Tc2rNHUCvYX8xKWiUPTOLCVaFUYS/GtA3i8io9gpX7kHK3yZ4kEY8+qNohVBQczSb8o6/jUJtrXN4nmp5fvycO+fS+QBtiVChZuwdyPKsR25Kd4aQDfDBcAYQZCQqDzbkO2JWb/CGRvELjcH0x1M5WzTNWojkew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769122765; c=relaxed/simple;
	bh=JYJ47g6zJv9NYJZHcOhfg/2XWfdaoAK9Kbz2/5Njwvs=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lv0sIf0xOVr16QscsYBiIIuTY7qLqpA5ectAUP8L47GXGq12fRh5Rx0V90xA1K3Q8ezVknZMPoIfMjpNJVJ0GHG07KMq1LXmd2p3C1SKZcgLb3shms9T8n0CP1uyrCGiuuHJxa9hEOhuQJ133bNn3BaEz26L660gKfj70sXvqk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=T7HKBza8; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40439fb8584so1869418fac.0
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 14:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769122752; x=1769727552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZL9IwoihS3pYVQCFPhDjkCA5SD9ojjApRellNIcrMGI=;
        b=T7HKBza8TpB6c3VY8h+1EmRbHUbe5hHGpvbTL8+4aT65LzushfpPjVnHJAkabKkGqv
         Bk75rEGXv/v79E2CeaFNROuraagSt2ziISVxphr1w1ypnchIa3WxV24/+2sE11TYqyrf
         6SdOhQ2nAQbIJX3ISObvHPdr/dQxBK6D4ZGmqYsNY/nOibmiagsIDmIrt+Sbe6Ms9EEs
         03sN/3EdKFSqmfgQJZuCIBHxgCHsHW147wmaeAfUAcvoYiOM6qufaj7B45+l8FOk+t6y
         ADSqthi3Umf28VduTGDA18fUvIZs0DqW5NmbE+qh1l+lp3TLi2lnyG6fjA6+XQ6ixIJN
         Eb4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769122752; x=1769727552;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZL9IwoihS3pYVQCFPhDjkCA5SD9ojjApRellNIcrMGI=;
        b=SHvlKki9Tu5jyyf5X5lw1oS0yX06U9s8dZh6I/xQgZWlapIY1jpF+d20odJTvr+Bzt
         fHm+uiPfLF6+O5XG5ytXN//8xhTfN6oomtf0BusCT3c7HtGb1kvj/8VnYcUWNXZxOHRs
         Ok6VshfdCu2ix7eN3cy+ZbiW2Y55GgZnItTd9/AMzgSG9x7/xrdER2GBd2ak7SD4voTg
         H8GjkX/jJh1WxADBQ9KuI6/vIQLlUaZ+W5eNwUowCk1DeWZEtL92VkU5bkw8fcYLpkI9
         JsJAZhyy3CDzc7JXdMU6GfeSzs1zLJX6OGwHFEQ8F33FGmyif9lfEcJaNZSpcj6JlzXh
         HWUQ==
X-Gm-Message-State: AOJu0YxC2OGwIz9OKqbmEidQ+7r77mj/U5aGsYvKB5GZAjR6aFAApSU/
	Nq/opGH7CcCyGszlhAOPgZ1ckRJfBtANUqe8Il5XjeziFgasVY2gWALelBD+c7Z1Z5Q=
X-Gm-Gg: AZuq6aKyi4Bt9VsH6editP/nHSgKpC+thEYtHgjMcqxQaaLtWdzyNZePeq0myxc85Qr
	xi9FBdUzpA51nEJxsy182s8M/huJHVIcdSPUQOvz5NmyWrbdtYP3r+OU+sb8whMTTlphuMd0LtY
	wo6VxuXFTDkYPNuC9Zfilrvt2XpMBNaPcJf5q0EnqW15RLAehJKlxd9xR+JTQo5uwFMME34AJ5D
	35njxpL1loiia7ZHgs8tCneYQUGcim0F33eydS7q6ODP3ZYQErkSol1LBqpb14V1px9Hdo2kOsf
	4V0P/S9f8nHGZfS7tBQvA8MAoPOBcMttvk7GC3vLbvkYJ2pdHwCesQHujZHxPmacvO4s0F2vATz
	kUGdwpY8hGJfEoqKv0NNYAWcPMSaNev+jeb7+emcDYDGPFjFgkop2tGQ59Bxxgh5Ry8VN9kN2iK
	TzNwOZ0ENxDfv4Mf1rdl5+LM6LHCveH1JPICbGKd6WclAyG/O8G6G2l864SdRAvNDg
X-Received: by 2002:a05:6870:8883:b0:404:1843:e5bf with SMTP id 586e51a60fabf-408ac51a164mr587824fac.18.1769122752056;
        Thu, 22 Jan 2026 14:59:12 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-408afc0397csm388888fac.17.2026.01.22.14.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 14:59:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1769034107.git.asml.silence@gmail.com>
References: <cover.1769034107.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/2] Add support for IORING_SETUP_SQ_REWIND
Message-Id: <176912275112.522897.5400530813917730862.b4-ty@kernel.dk>
Date: Thu, 22 Jan 2026 15:59:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-11892-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: F17D96E591
X-Rspamd-Action: no action


On Wed, 21 Jan 2026 22:23:20 +0000, Pavel Begunkov wrote:
> Add liburing support and tests for IORING_SETUP_SQ_REWIND.
> 
> Pavel Begunkov (2):
>   src/queue: Add support for non circular SQ
>   tests: add SETUP_SQ_REWIND tests
> 
> src/include/liburing.h          |  5 ++++-
>  src/include/liburing/io_uring.h | 12 ++++++++++++
>  src/queue.c                     |  5 +++++
>  test/test.h                     |  2 ++
>  4 files changed, 23 insertions(+), 1 deletion(-)
> 
> [...]

Applied, thanks!

[1/2] src/queue: Add support for non circular SQ
      commit: c22129cf0b8c936eb478d920ef84e53d89c6a5cc
[2/2] tests: add SETUP_SQ_REWIND tests
      commit: 346c063d16bda52f02d00feb744aafe35b4002a9

Best regards,
-- 
Jens Axboe




