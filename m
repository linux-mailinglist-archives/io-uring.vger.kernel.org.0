Return-Path: <io-uring+bounces-12847-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHBmI7oVw2lCoAQAu9opvQ
	(envelope-from <io-uring+bounces-12847-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:52:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DA6931D817
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8E4A7305ACB6
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 22:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3F036C9D7;
	Tue, 24 Mar 2026 22:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y7pyBPrq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C9B33D6C7
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 22:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774392731; cv=pass; b=Q0/IJd8MnlIGgg9BJu4E9ZZVAVjLo+AmDiIGliEAcdXiGCxLChaneneUDuiSQv7FlDjd35d0ucuujUeGcc+SNL4b1j8f+b4mz7ytcN18dKWMfy+pO+GS8YFRJJhgpT5aNCUBFLfTLwEfm8I6H+oPKRmficBos7J0GCinm536mhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774392731; c=relaxed/simple;
	bh=dqWzWYOXaRjaqKmeLsd4Ky2APWSTrJG+5dy7JmT3QVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTJe7S4//aYpPF0xBVPtz+6Yv7PoBU5lWFMj+4kwmWOjlAfpRQFrDesVw97DfpsDA+DsKAO9z/8QgstiBsG7MROTmh6YaGIOXqJknIgOTFkEEzCMe1QsWDA6nnNWMAxLsUaTu+60dTsLKaRvHaAJ2IIU55rRtLgDuunOoyHdMy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y7pyBPrq; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-439b9b1900bso3065942f8f.1
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 15:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774392728; cv=none;
        d=google.com; s=arc-20240605;
        b=aFmlmkRg2FO6NvzEKGald0DSHVcpX94Q72UiEnnIEPJy/Fp5Nalcw4T8ABC0Qp9Q9x
         Rbzs1Lfw/pQ7ixEsnS4ATqscYQldmYFHvb8G6nPeCGQjEE5wnLoGst3l1oOedgI+WE3v
         8PBQUbSpe+al0UQqzGWmVBIkwjv4XQLdqvq+UTLT8+HC++hzVj+Fg1hID61LRInBGwEX
         MNv1kz1bXlzWQiSgQlCiHz6uOgU5tN0OhOm2vMeDOmpLfq2MWlzzT3kOLGzxKiF6qUaK
         kIw9YTMa//C24g5fl7XhyiVU1oJeRGPP43lj9uzpI25ucDxg8QhbixcyZVOnqKXf20Fy
         a0cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dqWzWYOXaRjaqKmeLsd4Ky2APWSTrJG+5dy7JmT3QVk=;
        fh=ZcEvGnyBAzTbsAbpRSZ/5YvcoUYN0kr85vTJBdzW6Lc=;
        b=jLxGL3n5nzHc9WTQKP/vaXOUh9R1RjWnSBPbsRxFAV6A/gz5B+WGD5OQBPpKgMiTG4
         8r3RBf4aqf/wOUvl4PdOhVkYM8BCyoTwdo98Tf394dobLOQkApycLl46o6sUXab2ERD+
         QGnCTb/DV/I8ICi++mbvR66yrf6KNKBMhmtQGmnMLSJud3+sqUz8v9+1/PwUTmscNEr7
         DgBc2B+/VB3yiKAJFeFw6YJVPhBG3XHdXNdB5EaasKA7Iq/kJsgz5cZCilojaCQesahI
         aElM1/R0mbGUqJqvkmSJ7bQVFyUpNdK44fYR42CharQqcPePYafNNuoasZ/Hp6ggurqA
         hELw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774392728; x=1774997528; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dqWzWYOXaRjaqKmeLsd4Ky2APWSTrJG+5dy7JmT3QVk=;
        b=Y7pyBPrqW0yIMNpc5tPPtsNjTF+XqrCh6ctwpYuZ/9VwrcpOSdvWgOAT+78YaiY4p7
         /w3FzDeNvmmdAnIwLxHZSWDY1nS8SfOpep0/hhBscn4/p9QhOOHqH1qgbaJiQQg9qthm
         aRquk2KmFtnupoFUAvSo1tc3tFKlRtaVSuQnFppl6HA0n9CMlMMBC5Gn2i4MTR/0dSYU
         OaUWkDsheAWBGdTIKNQ77tf+/XNWaqSCxSC40W4a1fktWD8yB6kbegxHFHF7DD0XszHL
         XI5s2MRfvOR90c8v2jBTQTpKDJiDGPlFDNxN96mL2HrxKHxCKu1hMRV3miVEQWYvSxJn
         tvAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774392728; x=1774997528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dqWzWYOXaRjaqKmeLsd4Ky2APWSTrJG+5dy7JmT3QVk=;
        b=n1OZpYHmbzZMilLZeipaY+hnFNpmKwDSRLyAG0kgczq3B6QTkLxsWwApIVxd6E0w1h
         MJjl0+HNj4F2pN1/mCbm9MEe5M7Kyh/I+GqpQQ82XsgLGO/im3Vv2or6P6xTHilGN6jh
         8wuLdrtdWTO/GtmyJepoUNHOTTGn/0B1ai0bs/Pzb/20TLNm7b97dMLBACYF6tIgeUwG
         q+1+AtGRqQ4VF09DTksHVpOe/SBn7gK6HTtm+wHfN6zZsA0sKxs5o71oCiqkGbiCReMp
         ewi54Zw4ffvoWglJIQFtQwPdOlpq8ZwoysYYtxJxZzw+smB9A8ojk/8EVT27zY/Y/RJz
         nYGA==
X-Forwarded-Encrypted: i=1; AJvYcCUMwcFRVoZap+1E3lFTpzxUCthTO3NZc3upWypvpDut7HVJvK8doVWSAYrukIqaTBnYIv/cTQESjA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqx8Y/8tyUjWUCKWhPPggTyv8nMBPGeOICAMsxX4d0lK77vAKg
	SwsU7ngrbjusUiQEPNC1m7+Bns3pCHh7zfssuCYaJYzOlG36mGSAtZxgpS3t65ZOQTfyrMCoYXW
	LaqMjlJ/XUwUNVGYxgGLn9VMnKP2oD4/R8/0kTZc=
X-Gm-Gg: ATEYQzwj40sfRNtvU3yUt5YCvQN7RdAWQs06Nnx6XukxhfgCr683Sddyz+L/RyEkB+w
	iC+3ziymVKhQAmP1IORFzqlogfEI9UpjvEuwgI+f/cKOtCXxLWrp8Kn6aZy7NqW4rNy7Z3cnpaj
	BJfOly8b0rxNeSqtykNYLgOu/SokeuBeAvFjbLyG/ApuezxBOmNlaLo3qYcHU1Dht+j8ttVFB8H
	ivPsZjSe4iH84/PTwZI99+q9MqZijJg2r90K5atxq+Lbyi/OvCqPbSEsbvg+8ssgfy+Y65D4jul
	OiY+WA==
X-Received: by 2002:a05:6000:1841:b0:43b:862d:45d5 with SMTP id
 ffacd0b85a97d-43b889db41fmr1565994f8f.24.1774392728314; Tue, 24 Mar 2026
 15:52:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324221426.3436334-1-joannelkoong@gmail.com>
In-Reply-To: <20260324221426.3436334-1-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 24 Mar 2026 15:51:57 -0700
X-Gm-Features: AQROBzBXntK2caIf0TOMJR3f_4KabuZUBVw01DRnyPAe6mEy2ULBcFFzoQijHFI
Message-ID: <CAJnrk1aaS1ZCX2j3k_GSJ3Sem9zAgrrc8kipqnWi-GNNRQ8sag@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] io_uring: extend bvec registration and add mem
 region lookup
To: axboe@kernel.dk
Cc: csander@purestorage.com, asml.silence@gmail.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12847-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0DA6931D817
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 24, 2026 at 3:15=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> This series refactors and extends the io_uring registered buffers
> infrastructure to allow external subsystems to register pre-existing bvec
> arrays directly and obtain a pointer to the registered memory region.
>
> The motivation for the patches in this series is to make fuse zero-copy
> possible.
>
> These patches are split out from a previous larger fuse-over-io_uring ser=
ies
> [1]. The remaining fuse patches will be submitted separately and linked t=
o.

The fuse patches that build on this series can be found here:
https://lore.kernel.org/linux-fsdevel/20260324224532.3733468-1-joannelkoong=
@gmail.com/

Thanks,
Joanne

