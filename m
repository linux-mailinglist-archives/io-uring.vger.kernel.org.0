Return-Path: <io-uring+bounces-11928-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8A3gMGgbeGnooAEAu9opvQ
	(envelope-from <io-uring+bounces-11928-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 02:56:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 26CD28ED3A
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 02:56:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9DA76301BEFD
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 01:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A786298CAB;
	Tue, 27 Jan 2026 01:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oqudH1fv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD94C1A262A
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 01:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769479012; cv=none; b=CQFta4IpIlnfMyMvW5skEQmRgEXRDzzd8HfhgWyj9PCNg3uenf/0uW03oYru7g5a+Ov+r6RW/fGt3jvTwA5K9jfNUImNwUmEK+WTtUQkaMaomXR3zCW9jPGBh9BeivjnA7c9HamKVKFoIguHw4MxNzStNBNpJd8ASrZ5eXvmUwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769479012; c=relaxed/simple;
	bh=+24gbo4S1EjZC3HB9toJXlva3VfeFOc9jGWnrVUIEdU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VqWDXr9Q8X9H47y3QweTyHa3c9zoI2EzuOvl34EaR12ugLl9OT7i+of4XvdIre0yj+IAyxRaHLuWSKoJNJQxcpsLwlJYPX0teRd7BMulCOt/Qf6N7Um3B1id2mXayFrloMH89za0cHCIrJ9F/9yjr1hKjLf8tsRKHbh3tAh0amg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oqudH1fv; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8c52c67f64cso515697785a.0
        for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 17:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769479008; x=1770083808; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YG6Y4dEoib1AMziMX/9fBjeCRhj9NMapbeE+xpZ3Yzs=;
        b=oqudH1fvvTAX4QkGA6j2+XbyWuleBKcdZzKINauKC0azPyy3YQg0eYb8pvzTtmn6iD
         oj5mESDiqrzvKRFNhERCUDuaG4BcNMS/JAfv24XQrAMxgKKf/VzpGEtV0/n3HjQmvr5G
         bCxl0ivd0sHqMeViucuzfNUYDd1kPAyKjkgg+UZyE9WsMYD0QxxwZXbrCpS4piR4nVMT
         DV9ICEeRA8QogL6IsOGmjMiGVmufxjnKFPaPzUkyDHdrD0xSRB0r34U22R4UYYfSMiv1
         y88j6ZMq8UzzwVfcWcF80OyfZJL89cL6PlRQuw1WeJBxqFKL7mNhBZdi8g6i9UcAMYqW
         UqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769479008; x=1770083808;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YG6Y4dEoib1AMziMX/9fBjeCRhj9NMapbeE+xpZ3Yzs=;
        b=Mf+aUC/GTf8xelh4jDYDwHTN+co1wHNXNkBOSRM/ElZRwPGWhxZcPUzTSrpCyIkp2V
         JNgMPmLMhX9Za+a9SAib7E1ocwy5ABoMgYPt/FDXI6Q1DFtwJ6qz4R/qsK7+IMIA2k7I
         hPDEx0s4RT9MuyLxLjpLC/8FdYNOLgTBWoc5O/V5ENNSHZ3u+NVg0Bwa6JuTcYKu3XA5
         dUvD0tfMbpLGWngZFXtWGxGrRQ97ULUKKnOY/KuhIRgUCxGeGZ3IiVuQLM+Oftt+CM9C
         qMu2NPM/PA0eiEjo7G2eZy7PltunOCFv5OE3jq6ftaWHNNP8kWACbji1Bm4DIM2bVGRd
         OAcQ==
X-Gm-Message-State: AOJu0YwdPvXlVUizq81IcR7hwSnibi+pTtVewxLTVTknmDyx8KICWWq9
	cAERqNyWy9rYHA3pgSJ5FFws7z2uz/DWG4lFAdUhCOniBhwFoNsoEdxX84ALHG3fS0ur+QYMPES
	fykGQtPE=
X-Gm-Gg: AZuq6aLuoJkferi6wjYz02x+3KmVk2mtCaiFkGw1Bv7FspJNHmNr9abCG++YbHQ+Umi
	q+1lD8ulH9YyyKleiX6Bv7GgRdO2srMTIsjO18Id4pxa8swQAQmg31A8iiM2QEJavIuHAXEBZSa
	MyKB1fRwSOugE4VNW4Jn5IPd1Wugon5YfT8gFyXsA7cR1/iNDUXIlZJ7jbaEC8DSurfUAacJvDn
	39sKu7+fJp3DNN3VTsTeQa8U50YH03zkAdeGEV6x4crq03+dyAP1/A0boxKjbdcXcwpYoykY5wP
	vgs5hXJUowkRnD1EBNePpwsBSf5bYl0XhmWMmYvRqNfR/yZHa0rBUOMP1aUteZhA6feKB9t/IaT
	Uf4RL8Z0+DO0tLv/Et6bbreiIbse+H8LpYEHMx18WNfoFu4UhJZ9g2kePx7RjmuSZSNA2yF/y4M
	CzPoQWFJgYatrt6/4+U1r0s2J4hXYYzQzWHp0MeIbUnrL+pfy5M6YKxvLowWbpIS+Y
X-Received: by 2002:a05:620a:7016:b0:8b1:f1e4:a3d2 with SMTP id af79cd13be357-8c70b86a930mr23952385a.24.1769479007868;
        Mon, 26 Jan 2026 17:56:47 -0800 (PST)
Received: from [127.0.0.1] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6e387324asm1082223185a.53.2026.01.26.17.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 17:56:47 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20260127015017.2919925-1-krisman@suse.de>
References: <20260127015017.2919925-1-krisman@suse.de>
Subject: Re: [PATCH liburing] io_uring_prep_cmd_getsockname.3: Deduplicate
 manpage
Message-Id: <176947900678.230880.1415415528334230207.b4-ty@kernel.dk>
Date: Mon, 26 Jan 2026 18:56:46 -0700
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11928-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 26CD28ED3A
X-Rspamd-Action: no action


On Mon, 26 Jan 2026 20:50:17 -0500, Gabriel Krisman Bertazi wrote:
> I committed the op_getsockname man page under the wrong name, because I
> originally wrote the code and manpage as a main io_uring command and then
> converted to a uring_cmd but forgot to update the manpage.  Following
> this, Jens pushed an AI generated version of this page with the correct
> name and almost the same content.
> 
> While the AI version is okay-ish, it is missing relevant details, like
> differences in error codes to the original syscall.  So I'm replacing
> the AI with my version, minus a few corrections. There is no point in
> lingering the wrong named version around, as there is no function
> with that name.
> 
> [...]

Applied, thanks!

[1/1] io_uring_prep_cmd_getsockname.3: Deduplicate manpage
      commit: 18db2ce3dbb09d633002d669aa91de4f8181f114

Best regards,
-- 
Jens Axboe




