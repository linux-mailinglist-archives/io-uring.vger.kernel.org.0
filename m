Return-Path: <io-uring+bounces-13791-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id daPoCt8ANWqTlwYAu9opvQ
	(envelope-from <io-uring+bounces-13791-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 10:42:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A05E06A4AA3
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 10:42:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oTIPckd0;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13791-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13791-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 29CB23135C01
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 08:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE0C368D50;
	Fri, 19 Jun 2026 08:37:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BF93655C2
	for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 08:37:33 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781858254; cv=none; b=nZBeYFw67Isj7ZeBhy20Wv13zf+8ELgCeDjZt/3+KSJnYZgc7sMqBICzCGfeSaSgmFv3DI/voeKFnUUp+M2PeKP3VHI2ayKB5+q9c2qLhPb9ZvCZ3+Tr1Ep5OgXH9JhqR5ukcGUqFr3VRuuNoXAf+Be5ijCH/K9+HFLEXD/eYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781858254; c=relaxed/simple;
	bh=0ty+Q6y2K4AOlKlFOiFT8i7899skXamuEaYYI+wd4D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6SrKqxf8NCTufYjJwjCR1UYZsO1Hll2LcEoGSNzXBmUeaPobLxrYHJfuOYAyKtqrLHQY0Pa6PuNzoLYm8H1+snbQN2YihRjaaNLFMKlNCVfIBqDHX0Cv+qhTJhVqiKzi9pvKAEBALTbuFDGQqyL5Z8DcU/eoR8HUTjp6fqXG18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oTIPckd0; arc=none smtp.client-ip=209.85.214.170
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bf3781ca51so18041075ad.0
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 01:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781858252; x=1782463052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7oBvsxwpB7sjLLEIxbyXWYTpyIVbexYFG53kv8U23U=;
        b=oTIPckd06QtlRvkH4OBVCEpTJmHWvMRUduzVMxxKKdCIzlyGDZJLbWsy/mPV110tqG
         IRLBWC34Yq+E3JiqNxXvQqXpEKg8g8HoCgdgtaPiqM+byWiMTGUbRqQyI+Clu+qsfXHh
         ZPv2tEPSaa9iujD0a+AfhRVh3xawxOMzdiqwUnyKC6rCAFr5fZsAp+32rdOtpir/B3dQ
         N7GkiHyYL9b86dpwmn/MDx3aR4jbuTUf5X+2YGlbQQP76v/Upxx9fBiYvv+HGgueh44q
         WziYtki7sy+vZBUF+mtlAoH3tcC8PWqDNOffE+9hmPk9+0zTM1uvzkyOd5+hs2SuJ+VC
         qgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781858252; x=1782463052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+7oBvsxwpB7sjLLEIxbyXWYTpyIVbexYFG53kv8U23U=;
        b=Uj0IOfC5huu6RgPgqZScRjHyXNBPPro9trGTBQ3a5podhiUCQj4DUVhyOxHIOgFHKE
         6KTYxuzl7ozdF7k4//2zMxIBQgma3C0VSDzQ2SECnql32Tcaf/wTxmDI/Pq6o+CgfImg
         zWL0L+d19FuIvF1Mq+4ALQdrGYZVqkxW+X0eo8inaLB7OTXS+wPkL43y6qBPBupeR87g
         kcZiOK1Iz3BccAqvSNOp+g7dXqgCRY6/WjKeLGqOUEtvIAt1FBlEnPr3vkRuWXAEPagS
         XTGW+x+4XexeUbWlU+y/L/wKuL7JpPOsJ/2VN0wVmpkFhbQfJakpg+ztdk5T060jLgoQ
         +uMw==
X-Forwarded-Encrypted: i=1; AFNElJ99zXixWCi2ImjkLNhlG9GFOEDuEHr9hb0sWyvrfaYGACcQ69TFUXrgM7VlFsAAYDV8LgkWA4FDKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOdyELngMtn3oXJFnAC8mgpt9aPS+ucMONINnndX2jPMFYs8QV
	RmMijW4NAUkXgxjkXhUn34CB4Xo3BZQcq/z4+TQFG7Lh1MqghF270I3O
X-Gm-Gg: AfdE7cm/b87PgRvjqRa7F3h5PHy7HusQHg4P/c9liL6WpSFEixOPQ0Q2LdfhJ8tuHnn
	hf5ckdyXnsU8Edff+jYPE7Ck+wXIYCe2CRectW5kBYlzt/VSnpoq6774msq3UqXcMpk++cTkaHL
	kSgWox97zwLhg0Fh81g1gWv6F62r2Ud2cAKVCoa/fblIoDSw2tHRgOZo9Vo5px5cHPnuZ31cmbA
	A5NGDfEJS/id8DJxX5hcB22/csTpU6M6S+XD+snULkeZJDR6qN1x6NUhfJjfKY7iq+RU6Zw57Sw
	WLGew35aHIWUKBat3FKb5fK754zXnMBkzoWBhsfncbY5lSR00/kmd51L9GLxFmev1ErOb/v0Xz5
	Rx9dk6vpLdPuSAEKofnlRTpu5G6N/+MosVxJNiZQcA7XaOXyUsGjn9dVba10vDR63BIVR50Ss/Z
	Iz9w5uXSQnvMECWAEa4LpIQHXyS+jCFXi5HD+zdKO7TvL81Q==
X-Received: by 2002:a17:903:1d0:b0:2c0:d8ee:7d66 with SMTP id d9443c01a7336-2c718f6ac02mr31636825ad.36.1781858252636;
        Fri, 19 Jun 2026 01:37:32 -0700 (PDT)
Received: from Athena ([58.146.97.175])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7208d67cbsm16498145ad.26.2026.06.19.01.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 01:37:32 -0700 (PDT)
From: Harshal Chavan <harshal24.chavan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: axboe@kernel.dk,
	gustavoars@kernel.org,
	harshal24.chavan@gmail.com,
	io-uring@vger.kernel.org,
	kees@kernel.org,
	krisman@kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] io_uring/register: add IORING_REGISTER_CLONE_FILES opcode
Date: Fri, 19 Jun 2026 14:07:16 +0530
Message-ID: <20260619083716.18776-1-harshal24.chavan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <2026061902-clerk-common-4c84@gregkh>
References: <2026061902-clerk-common-4c84@gregkh>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,gmail.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13791-lists,io-uring=lfdr.de];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:gregkh@linuxfoundation.org,m:axboe@kernel.dk,m:gustavoars@kernel.org,m:harshal24.chavan@gmail.com,m:io-uring@vger.kernel.org,m:kees@kernel.org,m:krisman@kernel.org,m:linux-hardening@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A05E06A4AA3

On 2026-06-19  7:54, Greg Kroah-Hartman wrote:
> Needs to be a name, not an email alias, and above the --- line.
>
> thanks,
>
> greg k-h

Thank you for catching this. I have updated my git config to use my real 
name and ensured the Signed-off-by is part of the actual commit message 
above the `---` line. I'll send out v4 shortly.

