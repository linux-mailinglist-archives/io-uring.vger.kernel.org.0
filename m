Return-Path: <io-uring+bounces-12716-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJ9PEhCmuGkthAEAu9opvQ
	(envelope-from <io-uring+bounces-12716-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 01:53:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE79E2A25B6
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 01:53:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C54703029C3C
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F392417E0;
	Tue, 17 Mar 2026 00:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dJvlaLc3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BBF22A817
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 00:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773708807; cv=none; b=LZmbnuA+gSE9CN9U4Op8fT8c5CyuxCaqTQuoeXNlOaIwF4bofUWjlOq9Pv4alEfENCXYtJmmrTHc0iTTXJRTgDB5th5xnEDXa7Flak0e12nvyV8WRUpc5gnqay5dkZTK9bRd69wNGYfTVF3NTaS+aB2lD+uDxi6bfOk10t2+sSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773708807; c=relaxed/simple;
	bh=vWAZ1QFAxSyf0qkIk8vwXrFSqDQvFFaj1f//Vduptd0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=guO5k8NnKNGKCbdMLVhe31PmdTdF3j7bLIXsGMVQebPlfoOzi/yzmUjGyDrkkZlyN6qp42n2bir4S/KP3sfugBgoTzD/378lSs1yH1qumWL0cfQ63jkEHjg8158cLaenrrpIknHnyJ8GrGna9/EP0W57wi66wy1LYCJFQkVoRJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dJvlaLc3; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d73be007a1so4108496a34.0
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 17:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773708804; x=1774313604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5vcxc1vd1U6vUmsEmz8TRCFcnwOAOh9+NydAA7GnBs=;
        b=dJvlaLc3mdSQO0bv3i5MagEeaxX3OnkyZNwAAEQaT0mJhzINohd06/0fGKMgHJUJHj
         fszqbSL+slSku3B++kw18uL0fF0AyjA7S+q+Bxi0JTl3rBxm7UJBF6ocylj5JIbIbUul
         hVXudC6gwoMCNhNef289gR/NC8gmF1RWX3L2mYrBIqWLrSUa+m+4QLZtvI1n1jTcSjdS
         oGYpeZqn5OVHX6GJoKs99fpZDETXWkIjZSjh148+aZY/g2YXtGMfOujuVkEVHpbbYZPD
         FkI+hpSp9f/85V8JSW5/YQaG/1q6v/i/PCFjLfrzbBh7WBAahcobX5Jhl3Go7UWUCkAP
         ytDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773708804; x=1774313604;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w5vcxc1vd1U6vUmsEmz8TRCFcnwOAOh9+NydAA7GnBs=;
        b=qavBhxhXpJOTGhBs05A/d2dHMbdkh7xrTPE6FtFCxzQGGCl5rwpZ9okekS9pD8WRVE
         Xq9a2gKU5NGBn4ovEJCRVhE8WTs3ryhWEIQa+3DQlRfqlmEZXmVlgJZeN2xdNrdSlnnn
         YDndhFpVgXTnrMcq5W0vieEHMrdOeb17ce4yQVuk5HlnrnfvIgZc56aRBs2U8/aNMWdG
         AGB+FLR29nCzQImV7PI/r1y2p8MXbJTJ6PAL2EY5spj+zKVZc46S+o1GN7a0z3iscGss
         oHFx1XLk4myIlcyMKk7NTgdtm9MxfcXnciwdSYdQW4OXjBKYEkWlxtRD1PdlPnuY94u7
         D35w==
X-Gm-Message-State: AOJu0YwOqWos6/zZJYw9iebqv8ldSSRaWDeh0P1OEw8Y82KMSSiVhnn9
	MkU7NWCX27AEJq/Vzl60XodIyx98UmGdnFPdJCQ31gvxt1Wo+NupjS/Do9tW+/kNNo0=
X-Gm-Gg: ATEYQzzep90SlnEdTu4cI2hY3+vnjK4oH+H4TjYKFr5OJG9Yd17qLltfqAMjH+D+dIP
	V8CkYPfcUsxrc/+ZJcpBiTlJ36YB/LQVkDdz3VkNAAi9W4AnSYj1IrwFruAHpq7KMjpDjkIy8Sf
	dCqUWVJBEkXg9aPDy7bTqv8Yv75w9NYHjgRI7cUEPuSISf8KM6ejKCJJJ8+OtNTC1KqhGOEOOED
	fVUk8hnYW8wwIyKXS52rXfArkfqd4RRNDnyiOgJcdkzr0ZyyP5Lg96EQC6r8EPEhXRA38XXBvki
	Y6bs04lkR37OXpPIGFLGyEzOL0P/exolWVJkVJwXRDSf63SMbJyA/Gpu7gjw3721afBut8sTUy8
	X5zMQPfIPYwsVrKv9tdYv9dCa/OZx8LUxcNVTpf4XXlXlyCQYxvHtZ17ZJI7l8hS1C25xQPqVKC
	VjR3MTqyC9gxJWOtV7VE7/uLrfGMnxh+yDEz62+owt9F2U3Pj2wgw0FL4TyfL8yfvNo/8cH0NAG
	O/G
X-Received: by 2002:a05:6830:488f:b0:7d1:9516:6858 with SMTP id 46e09a7af769-7d7825476e2mr10565548a34.24.1773708804294;
        Mon, 16 Mar 2026 17:53:24 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae68a4bsm13538068a34.19.2026.03.16.17.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 17:53:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9e1d997c5189d438c5d13b03c28412116705815e.1773704793.git.asml.silence@gmail.com>
References: <9e1d997c5189d438c5d13b03c28412116705815e.1773704793.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] Update uapi headers
Message-Id: <177370880314.718582.4536199774359322747.b4-ty@kernel.dk>
Date: Mon, 16 Mar 2026 18:53:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12716-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: AE79E2A25B6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Mon, 16 Mar 2026 23:47:54 +0000, Pavel Begunkov wrote:
> We'll need new zcrx interfaces including zcrx specific query and ctrl
> registeration definitions. Pull them in.
> 
> 

Applied, thanks!

[1/1] Update uapi headers
      commit: cb8cf3b7e146a888aa2206161855cff9f09af762

Best regards,
-- 
Jens Axboe




