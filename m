Return-Path: <io-uring+bounces-12910-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCWTKA6szGnNVAYAu9opvQ
	(envelope-from <io-uring+bounces-12910-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 07:24:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2241C374E01
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 07:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E771530162BB
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 05:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4863735CBCB;
	Wed,  1 Apr 2026 05:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DeT1lXym"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CAB337BA1
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 05:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775021068; cv=pass; b=VG4EpKg9x991UD+4/2wgCl6Kvxmzt12W6HBoLAaCaGTJ3onMps0Yeu5ml+CzkHiOgxHc5EfN01WUwoQWU96vboXmfg05HPICgDz9Nq1EouHBZac/oEO3LwexDEDuP7y5bfAA9/wLjnE7RTEYcyI8JNxeniVFDlL1W6MjL+kPMAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775021068; c=relaxed/simple;
	bh=YlSRS1nO9+lqg9q1OR5BUcnBEBtdIZppKEYRHrGTz2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ini41GO+i9U8Efn9ShfG+MNvYEl5FMiDiWXMh0Kodv+6nsyukmR1dkxaoEl+kptBu6JKD/xpzkNJZxHdYjbCU9Rl86HjDUFCE1Op7rznwn+R8QXBJJ2iv0uBMfx9Ry1bIMk/C2JAgSXWMHUSbuGV//LDE8AGfWjWU3MB56QKLl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DeT1lXym; arc=pass smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c757a9251faso2518599a12.1
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 22:24:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775021066; cv=none;
        d=google.com; s=arc-20240605;
        b=GJtHOFzYB/7Ck0gPz790MHI/3opsrruz4Z7swq3XVN75+EYl2zLrW6gKaz51gjZzta
         0cJAQ2zgcZUKUU7rM+rjFfTZEk4vFGdYyCC8un8UFujdSQAckkoII3YXsauF7mn9c2Tz
         H02man8BcP/AxKQWcOEVdfgti3ydsu4viT4CE1aF0pBnrlslD674rNemRF4aqvuIfTdZ
         qDpk3i8NiMgUYf7UvZrB8YASY2+S1kxaoHN2iUiaJJKPEejFdM2CWVtVygYxTIZtSpSy
         u21Tjh9Di+XOr1IoWipvyTWmRVj11odVPGvVeYkIhaf+wJ/qfx8IKamu04Xl5eRGyUqI
         abXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YlSRS1nO9+lqg9q1OR5BUcnBEBtdIZppKEYRHrGTz2k=;
        fh=hP6gzvHX0iO8FWcil0k7yvBEPlkfHPxmAiiNdBipR8c=;
        b=eUtgAby3gcpxw0oxbYzql+uf+UHerxuhhjakl7X9GuqUVk/1Gy+Eh6QZiLe6DDLWxq
         Bbnbhl8Km2gaZhU4YoHugEPfkBsOvR//4HfZzhM87QoeUuOstFwP9CGicaolI+5muPUs
         GUf1vkfr0tM48lJWA3SIIglq01vHJxSigu2sFSEmZsyvlnXBOlTP6arS+YtWS5g9wi0H
         b6NxeiWt+8sCAbHME0713fhHtHnHgnZBHBVsBXHyzN3XnJdA2LMr6/xcu0kQC6vizfu7
         Q2W7LL0sr/cSS/MxBrnyiSJIP/Y+BcKDQ+tw4NZmb1saq+Qg9brgt7O0sHiY6BQ7i1Um
         eGBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775021066; x=1775625866; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YlSRS1nO9+lqg9q1OR5BUcnBEBtdIZppKEYRHrGTz2k=;
        b=DeT1lXym1oe4R6jDMvLY+Dy8C2AHO/yPV8gi8T/SkfuXZaMpMErHwCJfCihaV01Crh
         lS5ra/E4CjWInyBOfgLdSz2aNCwaHHpNNIcY+rS2dGlpBNXK2GPkNady6CpuNetLz1Xn
         gC5o3iDpNQiV0Dy1sr0I04ihC96Ie5AJSMKuQ/rMxPH4HHrqV5bSa5M8gRtWBLRI78eT
         a9n2k3SjI2TuEHpXbKOAWR0u6V3BkQ/FLx6mTG0xul/7YyVCd17dtuh6YkDW7SboodOG
         IlzDvvHn7mEJS0ivErTPGf7Nzsng022MY2L76/1msax7fJEFA8G2Xo3qSK0BLGr1H22l
         wM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775021066; x=1775625866;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YlSRS1nO9+lqg9q1OR5BUcnBEBtdIZppKEYRHrGTz2k=;
        b=XEItxr6SkO/vofNPyZT+9uRwxTw9QQEUOxuqKP/iRw6sj4KRDXjnxQrkHmmWX7NJHb
         1E89hrt8QPeRMPyqerfqF3wFJ7lCfyyfOm5lJwxVFHtZuz87HP8EoaepS69Nlz1/dVW4
         ZGKSQperall1/JFQY75PxLBpQCEspWMcM9z3UBt4U0rG/vvObNmUAgMeZpGVapimCeTT
         9kXcxeRSGFyLRN61edQDtmAXRGM4icH47bQP+XscIicTugvEmVnoR9j1Le4bV21qFvT6
         db9ZMqMKJt3TMIM261IlXd3q8J9rCW2QIZhTN1e3MiqHjInGyM3svsMqkhlhBtS4+bIz
         NIoA==
X-Forwarded-Encrypted: i=1; AJvYcCX3Gj+IxhLI2633iEGbqjVDscG1yUlU/K8aNm3YRqJEJ4nkD3t6DzCS+TKgXAOS5mYwpsNC4qHNHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeKMzveq96aVn7JXcEZ05rclrWbvbJE/dBVzqUNvOmENHwlHzU
	1d+Wdf8pJzdBXojpNPkiF4F3LVI/XrvaWnJ8DyDSKJBmGRMivhtYVUR5WxukvJOSLegUHwRN7oh
	bxp8QlcJ13Hy3qNCCsO2daey5abukPofiH950
X-Gm-Gg: ATEYQzxBZNsB8l/05HVFtvkRaGOVnql1WvMQf7gGp5mk5heDDSkNRgd634eh4mTeeM3
	J6Wu5hgzxkES36+g5KLqAcqgOnoHEztjIDUUkUhkQKL2lEBzWtyI7HKUf5mthThmkwgrF3DVqcq
	FzC9KHyFcSS2P+vaVSUYoe7QyAJjWmf0plDVSQmWufQvgg28mYazBLyZ3U/lLCmeGdLaUrxKH32
	rpmRwHK/xNyUmMla4JLbc/zGVRvJ1l+GQK6QO8VbdnaFyV3UI3j53b3xfHbMdVoUPS/OUoZElx3
	NjrSiciz
X-Received: by 2002:a05:6a20:9144:b0:398:a5c7:3dc9 with SMTP id
 adf61e73a8af0-39ef773e827mr2282558637.49.1775021066293; Tue, 31 Mar 2026
 22:24:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2915e619-06ec-414b-9458-92745c76e6f1@kernel.dk>
In-Reply-To: <2915e619-06ec-414b-9458-92745c76e6f1@kernel.dk>
From: junxi qian <qjx1298677004@gmail.com>
Date: Wed, 1 Apr 2026 13:24:16 +0800
X-Gm-Features: AQROBzC0-jcGweqp3rSlNTbo4B3AEEcIXr06tIxrQxAav39CO6-0_6ZiRA8-344
Message-ID: <CAAkLyHTws=36DYYf3df=qrbM8a_WY2zAX0amKZutadpaWQuAbQ@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: protect remaining lockless ctx->rings
 accesses with RCU
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: lkp@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12910-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[qjx1298677004@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2241C374E01
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Jens,

The kernel test robot reported sparse warnings on your commit (9d0a7bda72c5):

io_uring/wait.c:309:49: sparse: cast removes address space '__rcu' of expression
io_uring/wait.c:319:16: sparse: cast removes address space '__rcu' of expression
io_uring/wait.c:319:54: sparse: cast removes address space '__rcu' of expression

The issue is that wait.c lines 309 and 319 access ctx->rings_rcu directly
without going through rcu_dereference(), which sparse flags as an __rcu
address space violation.

The fix would be to replace the raw ctx->rings_rcu dereferences with
io_get_rings(ctx), e.g.:

READ_ONCE(ctx->rings_rcu->cq.tail)

READ_ONCE(io_get_rings(ctx)->cq.tail)

Apologies for not catching this during my review of v2.

Junxi Qian

