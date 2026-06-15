Return-Path: <io-uring+bounces-13729-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id FYMIM1AkMGoeOwUAu9opvQ
	(envelope-from <io-uring+bounces-13729-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 18:12:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F5C6882A0
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 18:11:59 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=I5Ja138o;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13729-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13729-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CDF6A300860F
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 16:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8D540861A;
	Mon, 15 Jun 2026 16:08:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E941140803A
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 16:08:42 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539724; cv=none; b=uM58tFkMobrAjfFTCA9TPDiiNsaU1Ur98aEQ+fHFsHpDN6CUOUmN2h3jWB/+92lERsZ6qsl6wC0s/5JDueIPU5wVj4d7+p7EC+hTbwl21Xj310axSRLd+5urP2N9wsUK1cQdgnFKtMZ6qSPZNuUcubDAFSYk3e1J3Zt3Hhw+yGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539724; c=relaxed/simple;
	bh=Hfxvv8VvollwCzgQ8mwXbmf3jKiokcz79KMZdsgWMt4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LbuK+P/pIvw97bZaibmeyhDLueyvGjWLKRFfqIYmPtmSgjwu8/oP7/+W4Uyqsbr0gKknvHzv2CvTpHkrwlVp6UgM877rs3xUDx1Ou8bO77/VKbdfx484nfRfdhUq4BJM6iix9zA8+CVMVlJQqFsWaE0SIj7K8ZQAxc/JCk1FB0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=I5Ja138o; arc=none smtp.client-ip=209.85.167.182
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-48662d16d08so1368646b6e.2
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 09:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781539722; x=1782144522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T23o0+sf1e9K96svSYSuxvi1MC7tdYg4hej2+16FDh4=;
        b=I5Ja138oPlBYMScFmPEjkHFPUmZCON6J1bkAnWM+sXllm7/TvxqzTzjczqRzMDCb7v
         stbAz/bYqZCyp+YMkW/xXtwSQPlIvaeO4JKkbDExMkK6eHgOAtxGgHsFXcrztvssg9uZ
         7UYetGT1znBtRxSdzuVMm9/hb4I0obbhIqWokpWVLmN8U/JWbjM/Crm1GYcXI6J0j0KL
         u1sSHPI6kgvO0vhhuCkfmRfmoGNbunUGUudHgjhRlkBX7NtG8c+pO4cIZ+OuhURVE5R0
         Zv18djv/DwtAbtG/hkmd0JwJ/ef4m4o0fG7gmYAtXvjjGe6kOBMnocLTjKtfEjWJbQsD
         V9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781539722; x=1782144522;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T23o0+sf1e9K96svSYSuxvi1MC7tdYg4hej2+16FDh4=;
        b=WesMEotQIrvcm69bP2YTXtYCXQBPr8luNxzMvHaYx5D+ZF+O2WUeHzaTGNeWkhU83H
         w9dj8B+5aPI2gCqF5JYHHRfNPeOpxYBmSY295Kqjal7iMSSTCvEx2lmVCOT+p1Rc8FJ1
         OGqE9O0pxNXbfgQ/wV90Ozb/5tJ397bpM8ueBfzWY6MyQBaaIXoyGY1qTWdijLzBwhAd
         xW4kCNkr9ydvje3c38fisozfE7Vg3DbV11ExS4tSgIMktAdGZKIP1TDl0IW3BdDUyEy8
         9+AC0xN1SPCg65tbN/s8WsjF4Tm0Ogr0/T3rLdZvLYwxVfLosmj6U+/bNQnB+6CxKA9y
         avPw==
X-Gm-Message-State: AOJu0Yz72zXTMK2dKzpzDbnGJkHBXE7RFYEPtpb90L/jrn61EYVUZBWZ
	5F1PHI6UhHTnH7UGksHK2JsIZ+FQhTgfI4U4rXsx0oiKb8e7Js0HVcQwlTdRngOk+5E=
X-Gm-Gg: Acq92OGLf6ZNFDYJGl7dUzawZrv5aQEG5M871vwfPV93HlkejC9Gq7anDQtANEaX6ll
	Sh7UXl5VJGOWvbFug8jqRd87WFGJ7n6XygAADar7b8f5R+w+9Plkk6yZ557XfKBn6W5arYNqBeP
	LpHJKmMv2Y1koM50jbnkA+W/rge2vmnnnNRsFbZyshwCywx9iFuwv7a6R8qBIIbt76SuvyCNsFo
	G/sqBlyLJAWK7u018/3oi0EXXhka7AEyuxIVMKmmt3uN4XCF4hDd40o42awRJKsIhByAC/4g+ed
	zN1nBctVy8Gbv1qD22Gs3tToaDS/ynj2GWsV9mWJ1Wk97XcQUM228Yxbsx43tVuzcMy0vRmS5Ke
	K5NKRL/Nm/EH6EgfTo0v8Lh5eyFeDRdRGjK9oq7uT/ixYtjNB1eUK7ileB49iCNqM516HI97D7e
	4F1S92xkbd8jTCxuQi9L+1xJezGqMZfh76MOsapfBPvaOPzSjhgDNU5xRW1oRcT+ZaicnCAU/W4
	R0=
X-Received: by 2002:a05:6809:c1:20b0:487:4dba:c3c with SMTP id 5614622812f47-4874dba0cb7mr3955041b6e.28.1781539721924;
        Mon, 15 Jun 2026 09:08:41 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4875df8284asm2947934b6e.11.2026.06.15.09.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 09:08:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Vasileios Almpanis <vasilisalmpanis@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260615144619.482749-1-vasilisalmpanis@gmail.com>
References: <20260615144619.482749-1-vasilisalmpanis@gmail.com>
Subject: Re: [PATCH] io_uring/nop: fix file reference leak with
 IOSQE_FIXED_FILE
Message-Id: <178153972075.2072617.12006728320657055033.b4-ty@b4>
Date: Mon, 15 Jun 2026 10:08:40 -0600
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:vasilisalmpanis@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13729-lists,io-uring=lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C4F5C6882A0


On Mon, 15 Jun 2026 16:45:57 +0200, Vasileios Almpanis wrote:
> NOP file-acquisition support choses between a fixed (registered) file and
> a normal fget()'d file based on its own IORING_NOP_FIXED_FILE flag in
> sqe->nop_flags. However, a request's REQ_F_FIXED_FILE is set
> independently from the generic IOSQE_FIXED_FILE sqe flag during request
> init, before the issue handler runs.
> 
> If a NOP is submitted with IOSQE_FIXED_FILE set (so REQ_F_FIXED_FILE is
> set) but without IORING_NOP_FIXED_FILE, io_nop() takes the normal path
> and grabs a real reference via io_file_get_normal(). On completion,
> io_put_file() only drops the reference when REQ_F_FIXED_FILE is clear,
> so the fget()'d file is never released and leaks:
> 
> [...]

Applied, thanks!

[1/1] io_uring/nop: fix file reference leak with IOSQE_FIXED_FILE
      commit: 571999ce5d657440f22e7f97c21ba86886fa987b

Best regards,
-- 
Jens Axboe




