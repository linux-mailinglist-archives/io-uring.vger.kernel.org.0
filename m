Return-Path: <io-uring+bounces-13719-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id fCHKHelOLWocewQAu9opvQ
	(envelope-from <io-uring+bounces-13719-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 14:36:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E276967E8C4
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 14:36:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=MVF5VOtQ;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13719-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13719-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6BEDC3028C90
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 12:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21EA37FF54;
	Sat, 13 Jun 2026 12:36:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD703E559B
	for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 12:36:41 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781354203; cv=none; b=B8D8AJ/jAdhC1TUvPn4n2oSOF3MfnrA1lA4nhLXNlHfLCmcfxoU6rAHG84UFNVuIIKHVdJrw8oCDWjP+NxD8UiVUtBlA792N5TeP96oN1Su7/+7UrQTQeqkJAsYtUtkfCGFCFTBWd+FoCqpM2DKNq0c93Z3QpXakl13UFdGvCUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781354203; c=relaxed/simple;
	bh=Mqr4VTFfD+uiSxX/ZwFIy9PiT8s1CYMech9hpCHOkBw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uco/BC868y/pi+NmxnjaXQ8eQTXmqT+K+D2gz1He6d4IyExsMr1tBAGgyxZViQIQiYx/PBB8Hn7jEzDCieAScuEMmJ4oX+Gj6xc2rdhXNg3UgtREiOrKMEi9dHmKFdroQB+28wGjsQofXW/y3nRTw3RdVPg5gW8G9IFTBhUctXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=MVF5VOtQ; arc=none smtp.client-ip=209.85.167.173
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-48751bd4abeso67850b6e.0
        for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 05:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781354200; x=1781959000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YzPoA9f1CWp8bUUVQEWkuMYx3XnrAFEgAV70047V/mI=;
        b=MVF5VOtQ1ffGvLwl3f/74nHR/JPxFrjTKsMSLO0U424Bhar4FnlUBJA93Wqeypx6wd
         LSJyqEyWkwmorHXboKJSKSZBN5ruOL+ZCv/WyQYzpOfYE5V14NeHPFMcW7PJtQ3Ro7fE
         yq8hWa7Y+Lgdbec2Mn+2r3T+Z20EJOtlQbpo+MSBOPhBmd+zf7xozFtb656mSyjjqS0v
         Qljf7e9yOiML3VFIMmZRrIJ8RRPe1ld2r6HdGNb+XrzUSTILCDv8RKI62KEb4kThhHgA
         8UgjHvg1MOuOxrtSR1vP9RjiF1PZpMMNwVa9o+tDaUH+n/LCBPFYqAhunDUG3uMeXBfj
         IVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781354200; x=1781959000;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YzPoA9f1CWp8bUUVQEWkuMYx3XnrAFEgAV70047V/mI=;
        b=bmM54zWU1SItGzwWuyLK7OvdMKW3eXR8mHVE5gBeIwSf2khKFsVk4IXwmWW1KKNu8o
         HcWIRvsxZmNdfpumEUD1SUiovX7mKBQTXwbMDUfyeUl+m5r8gAiFeECh5W7KsICe/C8k
         RqdPwSJpyrYj7tlrQ8rvRjEK7Ha6hjc9lNYw+kczj2aNzzI+pVUi/629/EtOUpiWXwy8
         w38WxAG76erAI39pDtNUTYpOvTo3uo8c4BG8z/U8FgRbD4ke5363wZ9vkor8uG3WuZJ4
         myM1w4dmqzr0wyFC1fuwS9jmYy69x6wo/CNaLCBrconPxPaf8gAli0QOw+8vSIM/Swac
         q1Bw==
X-Gm-Message-State: AOJu0YyDS2uxbPH8bw2eKlTEXozXS8CbB9gFDcDBahCvIql1ycHwfRrH
	lG94vogPXggtLyJh7rwPM1GPXOyQcfRI7v1oyNSZYQ9Y9Yd9URSihT8XvFW+nDRwuwuwm1oA3GP
	vHFE8XMg=
X-Gm-Gg: Acq92OG7WKA3AYzNPFv4jVB6SlQMfg43liE3ju3WezCvxcxDaapgK3QZgrEnfaE5ftb
	Nu1AWdT6C+G8UvXr3VtEKE8xPKyWbiElY0G4h8hr+cJP5/9F+gXTMIG1WlsayQQWG2pJeiy08Nn
	MZa58BGrgU06+G2lheoy6Z82hM3lDrLK/Mz14hlPWNDAOzjLACQULd99nHjSwoaE/XTyHHnhKUm
	qNX5bKlF/O03T3GAb5h+pWzXVZvAi/IjosssqfUQp9RqlHSKt8mdwZrSV2OWXJyQV8zF4ReFi7X
	UAlq40DkhT3WoMcmVquvZo/6Wo6UTP87SR0pkqW8uZUwQG3IOtpkdqubMHzeZzmC9ggYJ9yyHTL
	NvatnUlKhXq6GyRX0Z8SAEBTXONavofZRVUjhYdfUNYi1giZP9acLd1jTzZ0htplhqvISo5BKan
	CKv5ntTTjOkJ0XJudFWc5NiFF9zM3SkkP73do6xSs+RwD+7xhShtbuMmQo/pbGKSJqW1x/O3Lqh
	wJb
X-Received: by 2002:a05:6808:c3c8:b0:485:7c5a:63b5 with SMTP id 5614622812f47-4872f354248mr4394552b6e.4.1781354200553;
        Sat, 13 Jun 2026 05:36:40 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48731554fb9sm2641107b6e.12.2026.06.13.05.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 05:36:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d89f3b89e77b09a18daa45476fd1a40f2ee253cd.1780930463.git.asml.silence@gmail.com>
References: <d89f3b89e77b09a18daa45476fd1a40f2ee253cd.1780930463.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/bpf-ops: add a separate maintainer entry
Message-Id: <178135419828.1909114.9524860031536892533.b4-ty@b4>
Date: Sat, 13 Jun 2026 06:36:38 -0600
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13719-lists,io-uring=lfdr.de];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E276967E8C4


On Fri, 12 Jun 2026 18:36:22 +0100, Pavel Begunkov wrote:
> Add a maintainer entry for io_uring bpf struct_ops related files.

Applied, thanks!

[1/1] io_uring/bpf-ops: add a separate maintainer entry
      commit: d9b710f683dc68b5c0b7dd0c6c64aeb5d27a1ac4

Best regards,
-- 
Jens Axboe




