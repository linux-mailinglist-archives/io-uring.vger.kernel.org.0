Return-Path: <io-uring+bounces-12637-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKZmO41qsWnsugIAu9opvQ
	(envelope-from <io-uring+bounces-12637-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:13:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE90264394
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:13:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AEB093014859
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 13:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9816B3033D8;
	Wed, 11 Mar 2026 13:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qnchnYMn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112322FFDE1
	for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 13:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773234824; cv=none; b=a4ukjB/JoimjkmHR0Mhelnrd/4wFFFe79Sd8v+roz60EXMwyho5P1iuy9aOBo1qIhQPyDUUver4VhFBxY9NZhRi1AI1gOacGnY0CFusK1n4lKUR08lilyA9uMs2dcIimM2s03VsRQktxdYfJ6DH51JUo1K3yN0PgUamhBjvdu+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773234824; c=relaxed/simple;
	bh=IxJk+cb0K0wbanr9A+3kFw0ZOHAzNtE/PY5oc0a3tbU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=geJiObEGjBckeHdf+nz7V4mXK32fXKsjjB4zWTFhUaRJVxaAjxfJpiJAd5kYBLjZQZ9Ywh7kT4GNUkMiPgL2EpDh/iCtwq/mwmGz25B8jzSDo5eDrAA219FAlhMkqPdEf/L8kSNW5YmEdM0uBzVooXVMS/hmUv+D4oQBcrp1PqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qnchnYMn; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d75ed779bfso1716021a34.2
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 06:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773234821; x=1773839621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gtm3fDg4lKLJu1muXFMPYE6YwiM8lWicEk90kbwbNMI=;
        b=qnchnYMn2NTBWAd9AaL9q36AX94MzdV3fF7ChjHLwqmi53++JS+x7bMJPuJpgGfVfG
         qYISC46k4Yvy8fUawUKZZ1D9/pOjeiP8CWw6BFI6Hp3VC8Zkdj1ESC6NRLPaIQnRRCq9
         B/q9WwaVePKSp4k2JU1v1naDEvVNn8tu1bMZELtnQB0ZBmBFrp43eyu9rXyc8NsCFpsZ
         YuiwnDSlSjUiyKnmWyeHAuYi+bveh8MdPmMj3sGAqAFx1flXPzxTIlgV3XJQgnMKpyqZ
         tvAoptSkXj9EpVbr8gJFitizGEeYKMAcc1qB6h+ew25lbNPfXKrmnDXU6zP4RhEkH/hV
         PDKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773234821; x=1773839621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtm3fDg4lKLJu1muXFMPYE6YwiM8lWicEk90kbwbNMI=;
        b=xTakbjcqtAm7VoN5/DsN7dzSt7ywEP61GRnO/EP1SOqzwsRFUrgAbUiGm15FcvXH+B
         z+CLNFOomm6T3xI3GCeIPaXTqtwEj/j0j06jsGsgwsiduObQgD0+Quk4e+v5feCEqPvB
         zvLFPI7wqF2fqaA7uy6W9FV5EAWFFo6SNN2duftNlffG022++tucz3c5/oieh2lXJFiM
         9sUNdDwqvsARsrljmtlQ+wDnS5mPPXOhA0+zBvjf+w6dCtcUeSkN32d1OQ74wUQ2tWhp
         N3nEOUnQDtn3Fj9CriCMQI7eAjomK2xk05SizhZ7WHLYQg9f+uWOk852u/O3ntfla69t
         0Sqg==
X-Gm-Message-State: AOJu0Yz+V6VFPb2tfhriuGCwhys9g5wwY2f/ebGTmYfEEQDs2mHl98Pj
	PE88HEFhTZzRlaJsFfNrpr6NbyWuXKR9dmCSrqt82Ryoi5chJmaQBk4TGLVCBDY6xYmPotMw8+c
	9mm3Ayqc=
X-Gm-Gg: ATEYQzxItqse+mL9vN+HiMOJN/kfJp1AhjroSJ/OznTvX13JVPXSaTVlVMH9wszrSTd
	YzD5qsngTwMwz6+ukzAYuL+OoT0npWRamUWtoDLmaW8we+sdgnfc5TihL+o73fA6cvThHfQ3Xey
	xR6f3CENxI+AM95exExDwDxCFuTkvpuU2BIbTi70DLZDMg5W6+2nS35r2QjC2qh9+8vqrHDLSVM
	t8n51aEePTpDQ6h2s8snVqQpALL91de293i0GHjDuQxVArVDIhTFgChvLFgHs6MPbEKQdB318Gj
	qMzO7fltW33R/U4xdGGn0FIYOruvB2G9zr3Ro4qQU3fr2RiuLyHlWwQtc5JVyOkzjnAykP9zTSi
	wx2i78udhF71PKsGpZgGjBuy8LWkAXEYieK97ISkiJV8iW8jnXCl/gH2QPdY8ZWtB2ZGS4Z4K/Q
	VBn/lQ059OqmgymWMf0fnTpHQQFqhgO2Y+QiLVt5EUtDZ8DNLS2+La0G85gP6Vw8zWln/z
X-Received: by 2002:a05:6820:f029:b0:67b:c1f8:a3e8 with SMTP id 006d021491bc7-67bc8a38309mr1474224eaf.66.1773234821485;
        Wed, 11 Mar 2026 06:13:41 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e5e8185sm2286127fac.12.2026.03.11.06.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 06:13:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	naup96721@gmail.com
Subject: [PATCHSET v2] Fix DEFER_TASKRUN ring resize flag manipulation
Date: Wed, 11 Mar 2026 07:11:54 -0600
Message-ID: <20260311131336.197028-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6EE90264394
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12637-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel.dk:mid]
X-Rspamd-Action: no action

Hi,

Two patches here:

1) Fix adding local task_work during ring resize. There's a tiny gap
   where a NULL pointer would be used.

2) Same issue exists in the eventfd handling, so apply the same kind of
   fix there.

Thanks to Hao-Yu Yang for the report and initial fix attempt, and Pavel
for a good suggestion on how best to handle this.

Changes since v1:
- Don't clear -rings_rcu during resize, old rings remain valid until
  post RCU synchronize anyway (Pavel)

-- 
Jens Axboe


