Return-Path: <io-uring+bounces-13157-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPmbDrKo8GltWwEAu9opvQ
	(envelope-from <io-uring+bounces-13157-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 14:31:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D493E484DD9
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 14:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 142583003602
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 12:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F12C42315F;
	Tue, 28 Apr 2026 12:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6hTD5OZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADBD429802
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 12:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777379287; cv=none; b=YLRipk3qeO2OgqPTwxi/leE2/fbFNNmOvqsbmRu+hpGQME9u692t27+GNvWZrh2lQfH+UdSVZPpwD493lxmWZ6qLib0UOdkeakPO5v8ff0UXPFzgH52Gku0WkJ2S/VYIX4dKo7pknBVF/mKdvKNqwYgAA+ahCUFY4SHV+z1LuVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777379287; c=relaxed/simple;
	bh=axrlIxIuxTEsXZ7wio4u3xZBJSfyfUTrX6gg+Uvji5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k21NJPEXjQ/ZITEh1gIwO8jMgOPWjrvyxthMCzZv8km0XjRjFAGbm4KzgHwthcHHX9V0C07E1YwpSL0EY1h7lLevRJH155/9dhsdhFqRmuiAnOCNWGvG94MGVDwT19Piq0+IM5w2crYFyUWZS+CWlpdL3SR8S5s5UufKhTMSdN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6hTD5OZ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b240d753ceso21908575ad.3
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 05:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777379275; x=1777984075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZfgJnvYoUvxq0q/MkQFxA8UDXvcv6I3ujjENf6W6vc=;
        b=C6hTD5OZSP7ssJGz/Yx4Df8Az+f/XtdTeKkl1XOH5fSpucCwK+ZUfA85OOZTTd5iuH
         KXagxGCQ9xsMnSIV7DKPU3GHI8kutEgmGXiu0D/EsEjL0Hv4P97/1wD35qpDBsgjzDHP
         EiolhzrYRtwglmyLWxlrmKWZNSv88EE2qClb6VKxmD1QniBu4a6rlKAvH6PNCavOxz8Z
         /tf4m23Olrl0jJN+KtfGxWoVFl4n61lEFLiQ5bX1qsN9wZLrirLhpyVHsDI57gHzzVMK
         ZFuyc2283Xj+nJwRx6NcGToR995CgM2NV5MJYPG3CrIWv2g/YgyUj123R9PDlCSauqz7
         ng9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777379275; x=1777984075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SZfgJnvYoUvxq0q/MkQFxA8UDXvcv6I3ujjENf6W6vc=;
        b=fPDfQIOEcBUfdxXjPfa252K5YJe8uqQPiTF2kWiqxiZxdwG0VhsFaNrGoJgUJrVRho
         uESlBFSd8THpfaMcW2ahGpYxo51JKz2FqcAMZMQM5ArtsQTKizKEpqWulzYlTsLSod7K
         3A/o+yj+YkTgQzEs/kpIkXmEhNeyeVJhUJh49Y44CVGkMSyhonTBpppwo27qoFM884eB
         LaZxZjUUskIJBF19wk+Ps5Ok05MvrSROW+pcsXYUEQPgHIfncAWy+hkY880dGGdkYPYl
         2CEjrq6vYHNqdNf0vr8o3UXIMhiIIYPidEhN84U8FrIN0hjKP3zFgKyfyPmCsxNwtXpb
         S8TQ==
X-Gm-Message-State: AOJu0YwyIVDQyUMpIzA9pWTUdo6W3XD/7zYU5+9GoDtTqnXgZSvP6jii
	T/DOMS6oxUuvO7c/+u3i6rARPEhc12C3LBsfeoPaOnqEu0lwUlZrsbI57ZXsRhSt
X-Gm-Gg: AeBDieu/CiLii5boBYoS2U6qmSPEzCLcZFlt67Q+MRaAR7Ud8jzx1y8cjiJHlwYAtzE
	WPUPiAf2pso7sjurwjLEJK0JZpzYOaPMvKsbsbkZhTU40wh/oZZIZA0cjPuMbOUyawUI2mrgCxH
	uoiXTgXESVUcmIq6Uij8osIAlXcuhhvGy+ozkjBVM2IBEAdR2eqcyEvP7LWW4x8e6Tb/N/5q3ZD
	5nZwhxbdiadJUb1lZJAe9IhMNBCVvLqEhN2qvk6pLrr+N3V6Lw8Orhhbkx981nQwWEvTyPRvx94
	XwYtY+G7jrKfNdznUWPgKhFi24LQm5VEqqhGIPAT2KxT9UYgWAO/Gxa6bY7davHNBrT0CIGNS6V
	u/uYkBvy9IB4WZpxLrynKbPSpg0jhoL05PwPf8nyamGvlgcNgrK4yIMf8FSVP8AKgFZikj613rT
	npjJTTP1AZuTiwOJPzGsirodtXSvbK6CniUUUSTw==
X-Received: by 2002:a05:6a00:148e:b0:834:e09b:de73 with SMTP id d2e1a72fcca58-834e09bea09mr1362042b3a.7.1777379275198;
        Tue, 28 Apr 2026 05:27:55 -0700 (PDT)
Received: from LAP-0337.. ([182.176.170.188])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834daf69240sm2461036b3a.48.2026.04.28.05.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 05:27:54 -0700 (PDT)
From: Ali Raza <elirazamumtaz@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Ali Raza <elirazamumtaz@gmail.com>
Subject: [PATCH v3] io_uring: add submitter_task consistency check to io_install_bpf()
Date: Tue, 28 Apr 2026 17:27:39 +0500
Message-ID: <20260428122740.553193-1-elirazamumtaz@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <12c2bec8-ffb9-4b01-8bea-819c6ec77c5e@gmail.com>
References: <12c2bec8-ffb9-4b01-8bea-819c6ec77c5e@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D493E484DD9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,suse.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13157-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[elirazamumtaz@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

io_uring_register() already guards against a different task touching
a SINGLE_ISSUER ring (register.c:733):

    if (ctx->submitter_task && ctx->submitter_task != current)
        return -EEXIST;

bpf_io_reg() calls io_install_bpf() without an equivalent guard.  Add
the same check for consistency.

Note: io_install_bpf() is called directly from the BPF syscall path,
so `current` is the task invoking BPF_LINK_CREATE.  If BPF link
registration were ever deferred to a worker thread, this check would
need revisiting.

Signed-off-by: Ali Raza <elirazamumtaz@gmail.com>
---
v3: Dropped redundant IORING_SETUP_SINGLE_ISSUER gate per Gabriel
    (submitter_task can only be set with SINGLE_ISSUER, so the check
    is implicit).  Now matches register.c:733 exactly.
v2: Added IORING_SETUP_SINGLE_ISSUER gate; changed -EPERM to -EEXIST
    to match register.c:733; removed security/exploit framing from
    commit message.

 io_uring/bpf-ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index 937e48bef40b..0eabbd1fe24d 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -162,6 +162,8 @@ static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_bpf_ops *ops)
 		return -EOPNOTSUPP;
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
 		return -EOPNOTSUPP;
+	if (ctx->submitter_task && ctx->submitter_task != current)
+		return -EEXIST;

 	if (ctx->bpf_ops)
 		return -EBUSY;
--
2.43.0

