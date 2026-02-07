Return-Path: <io-uring+bounces-12090-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMOeFMFkh2k6XgQAu9opvQ
	(envelope-from <io-uring+bounces-12090-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 07 Feb 2026 17:13:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6FC1067B1
	for <lists+io-uring@lfdr.de>; Sat, 07 Feb 2026 17:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8F5B03014692
	for <lists+io-uring@lfdr.de>; Sat,  7 Feb 2026 16:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553F533291F;
	Sat,  7 Feb 2026 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ab5eK39g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C1626A1A4
	for <io-uring@vger.kernel.org>; Sat,  7 Feb 2026 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770480828; cv=pass; b=KCnZQcmi02zUiNoRw6C/Ihx3lxiTZFSap48ndc/7Op6is9ibPWcGw6fh7rMGVdxTvWxB4yI6IRK0hjH9nLSH3aIqF3P/dXMzei+jSVyVGs7dPTlz648bXjbYiUGfyEjKJ2jbW5Vv96nOvU+/2St9lhX3ZriEsbQ4y1yjH2pPqoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770480828; c=relaxed/simple;
	bh=DbFyM9F0Ova3xSH/8Zz9pHOVhyi25IeRYLEPEnQ9r/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mMKnfE4T1DAi+6VM/Zn+9YHrvykJrWqKJFW7n4Gpgk7NT8P3uGBCClpiH7oIOO14vbHgnl+CJRp6eG/YTVzhp2AO1dwF9O2LOUvsC222zLEOaK6+XFoNdShOpKrebwwrntBosMmtqHe9xCAvD2unOtWSteb69I6Mt2ygl9zIbjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ab5eK39g; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-64a28af2f4cso2422713d50.1
        for <io-uring@vger.kernel.org>; Sat, 07 Feb 2026 08:13:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770480827; cv=none;
        d=google.com; s=arc-20240605;
        b=XzC6d36kEu32ZNErP6uRW4RJVO5gDF7ZReSHGkOsyo4Cozrf43WJSJhR7SHknQ7HAp
         zPVi+hNcL454535sGsvvagPOmLfy7A8vLkyJnr+UiE618h6kchPqNNYqPWHkOUUbW48S
         /7IuI5FXOJ7O9cr5fIJ2SmQq4W5yVev2vBm7YRzXpn6zpKKJMMA4dH8naIfd/FD8YlcB
         d45UGw3nKsO+xbbAptbWl2PWY0d9j+SXilv90D80mpRVlB0SBnbyqytGuTLiHlLem0+p
         CMLt9kGGwDFtCKsfKSwAfkebBMBMXA0JIrrJ84ULqh/JS7W71H48niXt+2VJm2w1q87Z
         JpKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DbFyM9F0Ova3xSH/8Zz9pHOVhyi25IeRYLEPEnQ9r/I=;
        fh=tj3Br0LXz7BaVmfIT94YBd4Q6Oeg0H8s09e0Of58hdI=;
        b=Ap9NZnhqXGcsttndTr9bo9oWeeiYhkuELeuPk4vNDYfa7fL6aEf2E5/grFpWm2fJDs
         LMLghQT6vJw2899ljN2EEYEnMBz0YNexjLJvAWEy+mhImhSu7wbPYlNIcKW2tKPEiZzJ
         4n8big9N7Jy7790gvWgrirFrk3zsQY0RwQAMsNlKIqM4lXOF330jt5Y0WiXIkdI4JJF0
         d43+xWkX2FZLPhOG/3LR/eheeuFGIQ6m8F5ut0afqWk0btXKiakrQ9TDfVdtc3z0e4fN
         71zh+/OEQzeCJDVukz5eWey7aLseBHLWGHonQ7eAuHVr6akn8ic6hzNsOu9lAgaDTnsJ
         O+rA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770480827; x=1771085627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbFyM9F0Ova3xSH/8Zz9pHOVhyi25IeRYLEPEnQ9r/I=;
        b=ab5eK39gU8QTQCQjdqN+WKcnl1R7brm0WxMtkNGL1umbZ3kJucTvK1UM+/c3e4jXQz
         ZzpOch36YVe4hfiNxwuNK1XWVTW+culgTaR2t6v2e8IqCDYerxJa4QZQ3nuiYr4bRt9G
         9Vu+OUwYA/gQqNZFh9u21Rg5blhTJ1s6Lr+rZ/+UytHOj4/mNoLIFywmNVpgdGAQdoFN
         GIOkL0hNWE2u9gi5BGhrHPXjibc0HYBwaMOOAsa0rla+KZXFN0eysOi0c0fXPJBiTv9b
         q5pKZH5tQyXCw8nLfe0W1fQl66OEz9A7HyPB4Ik8Hq10/qZoWH19FGIRIN9uSIkJwh1q
         TotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770480827; x=1771085627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DbFyM9F0Ova3xSH/8Zz9pHOVhyi25IeRYLEPEnQ9r/I=;
        b=phm8Xxc5C5Bh3wFBHMQ9qLB0q5C+92ugOYu1kw0gTpLabJfLLhiWZNCgyPqLi4/HX8
         IqP0cSKL0sgb6S47Iz/0wGuz59CFDJEpz3zkvX7CWSPc8FTZt3olxJ1vruNNQbKZbM6s
         CG4ytgGISyh9Rsl2q+B+ErmgbnC2pRAqiEYpfOmgYo9ypS+udYsPWnxLsWCPZOMXlYIe
         gyBya+keSsJ8oVNC9GlhEszA+1w9b8X3Ihxzft02rCc1eGJhxwOEg22cb7aCrXc2SzMs
         P5Jx9N4/y006BAFYdM+c61ssPswL+da6Crke/I6MXCuL2DOt75LlKdkPiMQ1Yqy2A1LU
         NkCA==
X-Forwarded-Encrypted: i=1; AJvYcCUJvnDMszeK+D93jToUsuv2safAGE/tB1fJy2NaEcOzGRyDePR79aD572F/Z2tkixglfuxis/sE+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfmmRt3uEnqO7YJKRx42rcMlV8ncy77nox8xGsBrWoppHHwoRE
	zbpR96VCAXqxg/rfGsh8u6MXWX79hfZEjLbVemnoKBkUbpuyToQ350K83Xb29/qmKdGtKBXplOl
	l125+NcTurT61UhHWOIDFK1QsFX+M9Sc=
X-Gm-Gg: AZuq6aJDe60vb5Xn6A4ovn6DesOcCY8wrQel9WslFgMhyLGdcqHGw+00jGhi+Yr9Zbk
	Cq5kWxlQu7AvTMND1iksYHiEW3uKexupUAAJMB6uc0DwuwST5DOR93gMftPa1e17IJYvWJQx9sO
	u8e0Cx7nA2ogjEObb8RPp15nrhaQwqdAo8UO6vM1ODhYC0POQA6zWjHwC5NuyxZ+cyDHMuuuJLY
	KAr8I6J7lUilWDl81wasvkn479zFFjGLAml2o9qY0DLpWdgxIntls6u/4oYqpg5qy73QRI=
X-Received: by 2002:a53:ac92:0:b0:64a:cd13:71bf with SMTP id
 956f58d0204a3-64acd137441mr4362558d50.20.1770480826891; Sat, 07 Feb 2026
 08:13:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-4-joannelkoong@gmail.com>
 <20260206133950.3133771-1-safinaskar@gmail.com> <CAJnrk1YEw2CJb5Vv__BX7DaZXmZMfTsH3WYtQ2s4RGDWNRW4_A@mail.gmail.com>
In-Reply-To: <CAJnrk1YEw2CJb5Vv__BX7DaZXmZMfTsH3WYtQ2s4RGDWNRW4_A@mail.gmail.com>
From: Askar Safin <safinaskar@gmail.com>
Date: Sat, 7 Feb 2026 19:13:10 +0300
X-Gm-Features: AZwV_QgxIemzygJR1-WscAENyJ1BOl1fzhPCwisptJ7ninyK_TCUKCeB4-vDv6U
Message-ID: <CAPnZJGCPNHS=R9s2dW4ebA2vtW5AQOmX7RLUtEiC2QOHKUdBmQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/25] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, bschubert@ddn.com, 
	csander@purestorage.com, io-uring@vger.kernel.org, krisman@suse.de, 
	linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org, 
	xiaobing.li@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12090-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,ddn.com,purestorage.com,vger.kernel.org,suse.de,szeredi.hu,infradead.org,samsung.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-0.996];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[safinaskar@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: AE6FC1067B1
X-Rspamd-Action: no action

On Sat, Feb 7, 2026 at 4:22=E2=80=AFAM Joanne Koong <joannelkoong@gmail.com=
> wrote:
> I don't think this is related to kmbufs. Zero-copying is done through
> registered buffers (eg userspace registers sparse buffers for the ring

Thank you for your answer.

Please, don't CC me when sending future versions of this patchset.

--=20
Askar Safin

