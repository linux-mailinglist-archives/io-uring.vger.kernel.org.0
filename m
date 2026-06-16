Return-Path: <io-uring+bounces-13758-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6BWCCNzRMWr9qgUAu9opvQ
	(envelope-from <io-uring+bounces-13758-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 00:44:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED67695A32
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 00:44:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=J2yptoET;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13758-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13758-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1ED833168797
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 22:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CD73E5ED8;
	Tue, 16 Jun 2026 22:44:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A1E3E5A2A
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 22:44:37 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781649880; cv=none; b=LawWiSC4tiHOrGIj32KIzUy5NWlMADKD6GacEYVQNpVeh/vnNhL+Ig/JtF+L5DJYOPjDgyPCNnxstG5UvqzMaGiVTU7Gs6aXyDRYmAcXVVQdTBSWQtM3MIw7aEEvbbxVfs7u2YWLDFC+gXIAE9bCkhGgSXD5FasapHV8D9evFic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781649880; c=relaxed/simple;
	bh=bQ/xBnNPVXONk+Sa3+Fn9nKjYvLH4d0sKUM78roDNMI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Boiubqu9ORe8PLeXBlua4Ge+0LnQ1Y1f9MnHFBkK+X96EkUGmzAHgo3+qfB3xg0n0OciLmkspv9tgOsCSVSIPIdhFdIzN/Slai8O+Y0OpePcELfVWpSvFrSCPOE+eDBZVDFxcPpQti6THjuAvwKZ+lIeoncb0gxGQiLOle6DiqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=J2yptoET; arc=none smtp.client-ip=209.85.210.50
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7e701435806so4488863a34.0
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 15:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781649877; x=1782254677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2hbIoUPM1YbEUeEQ8YO+7NC6Nqzg4kcJJxov+PUZGjo=;
        b=J2yptoETeedsBjsFvj4P2jUg1X7YpMkIzJfQ6Z5kKZqdpilDIuhbToPD79SfrNtDGQ
         IE72UYDVyMBxMvU3mIHJrfCUaFKZsVU5WyL/s9v6v1r5sDkuUw7yplUV+98fKqGJ0pTh
         NiQ2HH2iAk0VYelv1sdAbpqE8qqmo8vL+3OV8WElNghnAH2ObQ1cW/DDyFvdWp+CSp0K
         YEwDMGw73Y2NnJSYgu7rYK0ytFmRqr8QknD3CELk2dfZrhQ+fS3o8+Ch4d5SE8AsWWk7
         e2xxmZhhoLovLCpfk75NRpSczqS8NhTctenbUHHY3oKvzsIHGJM+FaWac1jvPt55tjDB
         PPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781649877; x=1782254677;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2hbIoUPM1YbEUeEQ8YO+7NC6Nqzg4kcJJxov+PUZGjo=;
        b=LAbFR1DTc9bvLNRqzFQ+ealSVJvDxawuDjyqiezMjf6UYsMmFtrm+tLJxuZFmTKnpz
         G9CPcXPivDL2d0gz5vxTe/FZt3VEL2cNeZZf+BRrK5kz6yPTAArbqloR02/TyhdtXAUV
         RyH82e8a5TJFnYlQDJgbj3hOreiGMlkP9KQ4Z5lXPERl9UimV2K7b0d/iOjQDdgDey2b
         Mdit/pRf0DWQIjfdFwmymyxItuTQpjRThG4Sem6fM4TUeFnsittJH8jvAnc2Tow7B4V7
         PoI7AUc821cxG4AaGr1WaQCT2OZM2+x3Pfg3zH4P8W5zqtpk5JMxHn/J13TRA1InAlDQ
         DRNg==
X-Gm-Message-State: AOJu0Ywn/54QRuWEE1YFAJPogJCLIjo7KPVVmyFq9X27L4k80uuxsbcg
	IsH4ZZ7KsuIrGlmMdjbhvQ12QXJB30z2ORaQSunr98+uJguQqAoZTK7WcnHf/JuCLF8=
X-Gm-Gg: Acq92OFN68PO2QCCe1wr6xQ2aD/iRTjcHZ5rh1+Dh4J3WWy4HjxfCrFY1qyxAHeJb8F
	c+mhLSprEmKe3goos242Vn7kVtNeScmap5M2uXP1gPsS8nqKesCwFV8FX7XweTu4YicqIGFmdVN
	RSV905FsuR0/InYm9cPY9mvJATeKaSCotwmI+N++Q9VWsMk3YO0biUVYOVHb74/oJxSF8aGjYRo
	KAWAjKyX7w/SxOJ09kUhqWI6zfIGp/rdzQpT08L5hmbLWl3r0C4mhiENehyemdKWUXGvzv6AqXG
	+kYfue3Jbdr8oaXoK6RxlMTOShmQ3itotf2XxAQr7+JHmLBu6+XAI1TEuhMymMkwU5LW1e3hVUp
	s4zS6hvkTc/HwUoCLRYDABVdc1LSSnN3nlnwx/vbVflbgUAsYGesK8/rW7iXPo4EELlIpnpV8sZ
	61R/C9zT/WbNkAmyrGYb0mET1JyKEVyI9hNTTTrMUz3W7Ly801b6MsYMrgp2Lj6e54aWJpHUPR+
	PAa
X-Received: by 2002:a05:6830:680d:b0:7dc:3db6:f02 with SMTP id 46e09a7af769-7e90b2f09e6mr1381521a34.9.1781649877078;
        Tue, 16 Jun 2026 15:44:37 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e79f5a12e4sm8333814a34.6.2026.06.16.15.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 15:44:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Nathan Chancellor <nathan@kernel.org>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260616-io_uring-fix-wq-warning-v1-1-cfc9d934eedb@kernel.org>
References: <20260616-io_uring-fix-wq-warning-v1-1-cfc9d934eedb@kernel.org>
Subject: Re: [PATCH] io_uring: Use system_dfl_wq instead of
 system_unbound_wq to fix warning
Message-Id: <178164987579.2288387.2021227523258385291.b4-ty@b4>
Date: Tue, 16 Jun 2026 16:44:35 -0600
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:nathan@kernel.org,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13758-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5ED67695A32


On Tue, 16 Jun 2026 14:39:02 -0700, Nathan Chancellor wrote:
> Commit de7341ffe49e ("io_uring: switch normal task_work to a mpscq")
> added a use of system_unbound_wq, which is deprecated in favor of
> system_dfl_wq added by commit 128ea9f6ccfb ("workqueue: Add
> system_percpu_wq and system_dfl_wq"). An upcoming warning in the
> workqueue tree flags this with:
> 
>   workqueue: work func io_tctx_fallback_work enqueued on deprecated workqueue. Use system_{percpu|dfl}_wq instead.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Use system_dfl_wq instead of system_unbound_wq to fix warning
      commit: ff3ac1a0bd75400375678c0f81c2b613cbc03e14

Best regards,
-- 
Jens Axboe




