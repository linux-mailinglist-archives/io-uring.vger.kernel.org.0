Return-Path: <io-uring+bounces-12924-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2KNGFQZXzWk5cAYAu9opvQ
	(envelope-from <io-uring+bounces-12924-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 19:33:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC0DE37EAF0
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 19:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 037E7301C3EA
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 17:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7728B367F23;
	Wed,  1 Apr 2026 17:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eQlAF//0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAF22BCF46
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 17:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775064413; cv=pass; b=PNgLUnwOmTnd62XYKSKAFegiAB5Nx1izTC3uJhVhsHJHX6WFKUZXzpNOZ8LwKi5aYTcB69b38UQbGVGNSQk5lh2GS91Bpj2KdaNwgaSKipg+KoxNPR/y+p8Su6IEdvGFylTHiApFMjwFGs9qoSufbS9Qpl8yu3NTabpXWDmcZk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775064413; c=relaxed/simple;
	bh=Wbz+7uTTVbwJZUbleqQrbhdLlvf4BWc+3GlN51I4jZ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Li2kkyYPuNLwf8RMlJ04YS2RQpH/I/twEQJM9NoX5tXiJB+3ETNddgyDe/1/ldRAaONBwv+FcptGc7hRK+Q5lq2nSUYt4W+cGgI6CAjP7RcmnwncCPim/zoPcP4JQqwgzV0EP2zBQu6jwT7kja6H4gQxOb7Vn2wetvnFehOTROE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eQlAF//0; arc=pass smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-486ff3a0fc1so66158925e9.2
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 10:26:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775064410; cv=none;
        d=google.com; s=arc-20240605;
        b=QP7MDKd6Oc/gqw0o2CPySPepyw3p1rj4X+Zl8sYxLUZfEW7fHXGhQmJXCm/ZwX/82j
         qqR1SVs4XN+SHEMS3PCg+zNMHxTfx1Md2DziVevRxb0b7HWLF2nvjozzEADNMmzfKbrg
         e7F0CvZeUmPNulCkS6PDL7qmvpPAmKNRzL6YzwuUsOT74+v9/N4zb4IENhyFIgy9Du/8
         2bVfA3EXDH7KdgSv6sShxeh+PdE2YsiyxsnprMFp+pVjlG+1hF80CckaNtbHLWtp26p7
         vrXeNBoyOYNS356T0FrMn+DwdBkWLAd8MfN2A7AYV5nBomtYw+4whbcsARD8knmYNLh/
         TICQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wbz+7uTTVbwJZUbleqQrbhdLlvf4BWc+3GlN51I4jZ4=;
        fh=XNI6sMYQyOe31XTOsyVe89wBtmgamBY62NFRjZsnRig=;
        b=IsliivpxrZiolj8XhPd44719wDOjLUNDuOG3+50ikpha97OdiQFSsLB2NSGZXPC4Zq
         SxqJaUh8ZkSjnhZObsf1znzpPybn7y93kYkGa7eduxW0eqkLJVkKJpkYmPn5HBPaVGGx
         439xy/IQpGw37SdK64MdYTyxLMSUYJoPdxtY6eXGXBxuMFVgKdAugFddC1omaoT7qDsU
         cpD1AQpidDAtphujTH+GcaVgC+N2P/O7bK3wBDg1Ypx+GmF4KW7n9tjtAtfsi0S8aZwH
         AL6Da8G/0BlCXeSMIPh1GzLM9ehYIE8ooVpej6iPtA/uRPkgWtixj86D6fQsAYNabrOV
         etFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775064410; x=1775669210; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wbz+7uTTVbwJZUbleqQrbhdLlvf4BWc+3GlN51I4jZ4=;
        b=eQlAF//0YDkbR2757HqNvXt4R44gsC7xyWSZbSzGbT+Shpm4mm3FoLqBFtiuqzpuG9
         Y+l3s48HF7RLteWvlTVOTntiKSpHSMmCLdm6AxFLndfJ41AnLukCsTmo3YkZpfreOgTm
         19+UX+WW7ic8JJnhaoeJM8x1PVkEQh5yOJSqDQh4fMB6L3bhiYvijWsZB2Xhk1Jz4CCF
         TTaRC7HXVi2ACJwh0g5cegTehh2DEgruFsI2SSLhjJBL2PxsRKQ0YyBPYiWQSeBPNHZZ
         UISbdZ8oqCn1/JQTXyh/uap+U0UAazS0TtYFDtSuASjZd2jIB3edGsu5JHyS//kFm+9S
         26Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775064410; x=1775669210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wbz+7uTTVbwJZUbleqQrbhdLlvf4BWc+3GlN51I4jZ4=;
        b=kqY5rBX+/Fz15vjRmrTIMM/oAVTpfOvshoHIkc/P+XDjTLtdqqGv27csDk6RuzSU/1
         VuSGjgSyDsBbyL6Ihby6gEUFEPo3iDsTiuGk29a9hTWQ+LWHxjCo4CRpeDzHxq5mf7vv
         7A6KUyI9KCkbhGWQYSAFxtaLe/VNOBgTCOIJXzJ/xWWl3LFIrEaW4gJqfqGnph7k3Y+B
         HgWWjHvSlWnWq5zuwpDrBdv//WE4/PsIBV4M2FzudQOMFmMEXzFMBvxV4I5VOYMOT8aY
         bKn/pjdKEUXOEmtaZgzyVszDLJOotyVc6erdJU191MQ0+j9ecJLea/9htI/YOEacd1oi
         rPgA==
X-Forwarded-Encrypted: i=1; AJvYcCXEXqzPT3QSjn9BjmU69DVU6tXNp0S2puLLELVVTEKR82L3g8dvBmiyDTjKNaXs95le1vvU64Z2mg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxaaJCVpfMApJTpgl7WGIgOm8fkYf+//VdrIrtT5SRmf1KuEZNj
	ojh6jca5FfVMcshIdT+yY/H+5AukVzS2vLxUbSjNmaHGRWa1jP8L4Ma+uY6CKoCZ7bKEci7UTIH
	iQxV/+Eaga9R1lPrjI3akzWP9LUaHhpo=
X-Gm-Gg: ATEYQzw837RL4nIVPEK1XryclhAMPj6IpEKNa4CUPYQhcXY58E/kVMTtk3PQXy5J1+A
	KTen7edx3LSSA1IWlExwzOaVyfQDMp56JZxxLV0u2uZedekg0f+AaRe8qUMp5d58vF8hEMa8h8t
	pbPzl55JISnCxeK1F0b8g26pNWoyy7EgA7w7pUFKVL+aO/xh0LvZfNTsQvBuo/jCnhAzx4tDwK1
	nE0VCG8g5BQQHkOY1DMHqnRvonywelZMkYMNS8AE3ppvWTUmbA0bbdE8zVLOnJkp5/GIQl+mhxI
	vBA3NA==
X-Received: by 2002:a05:600c:4f08:b0:487:1826:d89b with SMTP id
 5b1f17b1804b1-4888b6f7f8emr1925585e9.9.1775064410081; Wed, 01 Apr 2026
 10:26:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260327172631.3380702-1-joannelkoong@gmail.com> <20260327172631.3380702-6-joannelkoong@gmail.com>
In-Reply-To: <20260327172631.3380702-6-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 1 Apr 2026 10:26:37 -0700
X-Gm-Features: AQROBzBExYURQigg5KyADcLWpJZIINgKSu-9no1u30eSqgdFJcSORc0EaJHhO3o
Message-ID: <CAJnrk1b9xyL_qaK224WR530Yd+_42EdbHHx+KwcyvBZgiczPpw@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] io_uring/rsrc: add io_uring_registered_mem_region_get()
To: axboe@kernel.dk
Cc: csander@purestorage.com, asml.silence@gmail.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12924-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AC0DE37EAF0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 27, 2026 at 10:27=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> Add io_uring_registered_mem_region_get() helper to allow io_uring
> command handlers to retrieve the ring's registered memory region info
> (the vmapped pointer to the region's pages and the size of the region).
> The info is returned in a struct io_uring_mem_region_info. If no region
> was registered, a zeroed struct is returned. This provides a way for
> uring cmd implementations to directly access pre-registered memory for
> passing data.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

This patch is no longer needed for fuse zero-copy and will be dropped.
The prior 4 patches are the only ones necessary.

Thanks,
Joanne

