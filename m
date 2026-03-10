Return-Path: <io-uring+bounces-12616-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAYVE6gzsGl2hAIAu9opvQ
	(envelope-from <io-uring+bounces-12616-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:07:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B15F252DD8
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6DEDD3497869
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 14:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424792F6911;
	Tue, 10 Mar 2026 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W6D8FnIA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138B62E7F3E
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154529; cv=none; b=LuOTvhZBkdcA7PXd89U3HKssotIC+SFFbMA8PJFP4RHYpaQYl+9OVlPBUcpPGjqtflANrHTl9UQ0q9Jp+OmET56cHsRtcL24wScewPLmkUDA9Ci3spiQZZIgA8GCM8oacBK0RhmYNLwadyAoNeWjPE4MvV291LAcWwa4nvMd/Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154529; c=relaxed/simple;
	bh=1Ym9xPY2npmW4bg19KEGGdZOwqOM62U5QkLPmj7uTR4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hUSUmk6yZrM1z3bZw0N1xWhAhdZxeyU2DT/A3rtVhIn68p1a6MhcH3bj/q/vQbRWnnQVxAHQ3xf2BcFZ9AkN74rfsRu9deZsZcCCiWUQnhUyt84r7wkmDGphrB+eTDGrr/59rCRI+BCwUcoq69M31YimKVRZYel/AdN2gYLOStw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W6D8FnIA; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4670464029eso1418564b6e.2
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 07:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773154525; x=1773759325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dLaDJ9PP1dQE1LKW3SCDQF8TUjTvPTboimLR85bx4qU=;
        b=W6D8FnIAWYGJUQmF/daoG6zW0uE/r+fxMSizwarcl519vI4D+B7wZZkcHxDRWJi6xR
         jZsXl4qv5ZKDKFa/5vyuuIAaPCece3a5RBhcShxHy1O7L7D38V0oyMUHMBvP9lo81KQQ
         iQKI7g3hAVt38HfYAgt0OAWY/5n1yGfrEk5/bPTpSvFFtmo3nistr7QA5tMx/Vnb7YgN
         THM7oE55FkIMEAGXHfqvZfMOvx9Q6Mqt3PMNPfUSu8sL5UwoU386NXv5PJC+6JDl0bD5
         +Ma4m3CDKCiVMcnEIR+wI7hc6kLGMjYqwRY5gu5evcY0pyUQa+rIXkVmRlhSGPa/Wm6a
         hwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773154525; x=1773759325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLaDJ9PP1dQE1LKW3SCDQF8TUjTvPTboimLR85bx4qU=;
        b=PqlvkBG3duFnqB4cGemTr6qcfgSdemHUKC6QLSzGGcFUFPabplt8it6Pi5Ppmh//JR
         xwNM1dxJs+x1T+DwsBeA8gyLxSOlJuNBSN2Bacy5jNfoFSPRtzSZuGSKMCzsSg4u5xmA
         hf+VP/d+Dzdac5+z8m29yS2Ed/FsepOeGW4LL3b8BZEXPRMPNBE6mjePAi7F2I3smYqH
         wyB+IfSGJYAGBi/NuPZmXkRcP83zQrDrUi4AEI6Iod59IFpd7Rmx5ZlVruiRjYaC7viF
         JuIejv1kRUQd+Uot7SMiOsQJoarPl9/DwM3GzkGCZV7dpcnecQz0VkvaQCTkli1YvBbY
         2gTQ==
X-Gm-Message-State: AOJu0Yx3iWaDKZYHuTGJEpkSh6n4xcMT5VdbgUo0L3ajiUN+5H6lYkLa
	VHDRFP6nmjLr4kA2thtKzXomS5TEv4GdyjKnA85Q5CVrzzDvmwSUTgo/qvOK56XkrV44vGZ41fx
	SV58cWnw=
X-Gm-Gg: ATEYQzzOs+hEduPdaSUzUXRpGYqBTKvh/I6BcPCY9MMehBu/1nHMz+Fsh1U/c9T227L
	f3Q3QZtdGMZneY5BGvHt75LWR4l7b5rtjiR8JnVMAIIL527A8jCd2mOEIwmqA2+eyvLrlteVCPE
	ZalCJfPHI7+vbRgOuAqJYITCGQiVaAa6ya9aC0qj7rZ3ZpJ/9wVnJyNaYK8XOxTDVEtGZw9olSp
	kJKP2cp67YtmgHANmLAPcEJfsmIaav0nf8z8G4bJXjK0FRR5ye0r3XsfLiofDtc0kRmdZpvHDug
	+CeMk3mfSWynfCrVHfnB+khfyoebspF3HB98NL3WOlPsy9opRvA9QIecWPObZqq3bRvc/G8rZlA
	VoDorx7knuNeD07XgAOuMsixpmrAw+zWNMd/PRy96DXnlVY4aDx9FnITfzf4S77biF8KmGhdWiS
	oteF2Y2zoyb3h+3PkvSV+J2UMHDQ7QcyGj9U9zCBYSfdKVLmHZ9Mvtw7Yo3BTvFQrTSxGJ
X-Received: by 2002:a05:6808:13c1:b0:467:19fa:19f2 with SMTP id 5614622812f47-46719fa32d5mr2241448b6e.25.1773154525613;
        Tue, 10 Mar 2026 07:55:25 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-466f429c7fcsm5786865b6e.9.2026.03.10.07.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 07:55:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	naup96721@gmail.com
Subject: [PATCHSET 0/2] Fix DEFER_TASKRUN ring resize flag manipulation
Date: Tue, 10 Mar 2026 08:45:47 -0600
Message-ID: <20260310145521.68268-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B15F252DD8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12616-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:mid]
X-Rspamd-Action: no action

Hi,

Two patches here:

1) Fix adding local task_work during ring resize. There's a tiny gap
   where a NULL pointer would be used.

2) Same issue exists in the eventfd handling, so apply the same kind of
   fix there.

Thanks to Hao-Yu Yang for the report and initial fix attempt, and Pavel
for a good suggestion on how best to handle this.

-- 
Jens Axboe


