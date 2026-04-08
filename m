Return-Path: <io-uring+bounces-12999-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YEM2DQxo1mnIEwgAu9opvQ
	(envelope-from <io-uring+bounces-12999-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:37:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A58883BDBEE
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F381F3046040
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 14:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4389F3D34BE;
	Wed,  8 Apr 2026 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFnm3kHg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F209D3AF653
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 14:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775658711; cv=pass; b=FNqnFJJzuve8vXcOn5WkpUyjSp5MtI/mthAxvgMvHME6arXF6kOpyl8igPiRHTljcVJjaJigJ1zrjenFQdvkycjBH1PaHY8bHKzgJCSRNqETLbN5oSSwayGX2DlTijrEM0hSNEksyBbWwXlIbHL6hTxMQTiJRP5cbS3S1h45Ago=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775658711; c=relaxed/simple;
	bh=TQBsLmh3rgmOUhdZGxCwn27jDO2LbVyXuzSkdOqA+DQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hUZGcWvI/5ofxDSevlBPSzaea2yBm4ro/djD5aRNwlndHVoExVthTVf9hPrGRqegU5tiKpNNLxfDj0jPE7s6KSaWKp6fsQF9ByFMWu7pXSol9AJ/eilpVBqYdZ+h1cLCDqgTWe0wDOhaSyIEx3iwaOvwrZN/U1pv5w7Snk7UbWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RFnm3kHg; arc=pass smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2b8095668ebso617248eec.2
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 07:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775658709; cv=none;
        d=google.com; s=arc-20240605;
        b=d0FeFkNtQGcVWYcNknrQDjAjoOKJxz2w+0G/ijzhlycp+2K3EXoLGUeh8o2/90xQFU
         t9z6o8q1lCbmnCq9DZhtSbG9rm1tRvSIpE3xNm9IpUTHasoDga2oSuXSL+ysrvu51Xsm
         h7QdOU7DgorUAFJfW74Vs4dXDryZ7jiw9r0xWgZUZknte87osexfWPUkD7AwkAhvMKdj
         tXaWe8OQXeY/w1W4ya2p9c13QOPZDxNBIK7W3MXAaakCC7EbBMu++rpzxKlAbD0mtb0l
         ltttDWOS17nwbl8cTTSDCflq+s/pVRPqQVacgVJsXhL7nmgDr7J5Lbqce5nlAkxnpJ+s
         Shsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TQBsLmh3rgmOUhdZGxCwn27jDO2LbVyXuzSkdOqA+DQ=;
        fh=0mUo9MOREMlrkSborPwzw8QWlSLTdq2t2vLYLA0fUKs=;
        b=j3cYyKSpbGLeHB94n2V+gDuLtG2c8gyMBJjxJS0AHMXT/MmOlvnffyEhlqpgOV3P/D
         nOwEjFudOG/RdaMDH++Up/wh2UzFapjz74ltMqJETZUBaVI5MZoO7CEvwoG4eA12YscZ
         EyWtkaGnFX/D7rg3yZ0k1Dr3oELrQcmdIt+XdQ46s+XgcYmKXm7vwlox23WaS58iSAnG
         SohkpUYh3blTLgtac3tBY8qgA7e4d8OplomcsV4s68K8nlm1FCI7zSyv/Q+RatFyf4Xn
         zyRQPXEdGGK0hHuWEO2jNz7rr1Wk+QaDSgtSNqZ1pmpJ6uTQigyZVk+WZH6mEG6RhQhy
         ab0w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775658709; x=1776263509; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQBsLmh3rgmOUhdZGxCwn27jDO2LbVyXuzSkdOqA+DQ=;
        b=RFnm3kHg50Vd+hZn/CvJzhszYSTzv5NOB5a098YAx0/D9mvNVp1JONuKX2HNutS070
         A+BlHxegwW+i2brc9l78SIinEz0ErU0seyjTaLOcQm+D5IJswqtKnxahuypb3Ixu6Tqd
         86q4kAC8W/qFdkDmlfPrJUKipt+LNM+hiwgTCA7Tr2BwLhYAtMuzxgKie+zyVsu6zo4y
         NTjdPTfxRPyVYVlieXoaNjP5ozAqu98nEOGBDM+lmNgjTJ+SByj/zVx+7ubZdsRe/H7/
         rgPI+lu8gTK88g8dpUwuYI9LcKsi3gLSHKTGHBmYZIB7RfpEUiKTAcqYY+almEsid/Dy
         hcwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775658709; x=1776263509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TQBsLmh3rgmOUhdZGxCwn27jDO2LbVyXuzSkdOqA+DQ=;
        b=nfh3qMHHKuWD3pci+wG+Pqb2tjjr1xjUidNpnvkZHC1FDZFQuDv9lEASNpQT3iWyno
         aVuQSKND9Ijxb9XwyO95Eqc6yzoOtQXZXI+bZ7pJj1f/AhpcEGfDgJsg/vXFmcop7S79
         KuDrXGoZSFEJ/6t0cHiNC4h4Qq/OuROa+yWHDTJ69Dfk5mqvL2IWfvqnwcM4XXKkV93J
         imL3SlhqmTMl+oTeFFK38K/q45ihPBsRQEEHg9kY0SBxQ0H/XSClk8qKEFN5+YkOYV08
         52vnWhVHSmxR/TEadr4GwR9Oz5y01BV5RzGhuqB7uNKtuRAm08GSy0zP9CqD8YP9ja4U
         1tqA==
X-Forwarded-Encrypted: i=1; AJvYcCV+h8OQtv4uNSQo2y6Af58o2t4uDDAHM78PRCv334IDU7/tcXPxMVM0VAds9HuEnViAyRlgUNG0xQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwX3cWR28LRDZNjhbP1zDT+0Ni1Yjs3yq/Br4Z0y2/49BaIz+rf
	Xqt2SnbpWHfJITp7s1ySEgTKIHzr9C5lT2WtDEi752tSwqFxY9+BedJc+1vrNYTjztdYN1UkyL7
	lr8aeWOhW4YQbUkFV8k3qjxpqgoKrEoU=
X-Gm-Gg: AeBDiesaal4Bnq+SW8jndodjQRBwUVode/zAoFoWLRtrdAo33n4EFdyrTSEog4SNcIP
	rrRBX6icZOxPI7pPX5oR6aZlv8Qp9+0XMraaSbW4xJJNNmU4reOIjs640UiTDVyzEKXHp6/lucm
	0F8n6RxmQztxDt5IrFaHPcR7pfneEOIqaU3W9tYbgK401zMT7ymtwO2dbI6trobQByvgAYgnfdW
	byQ0tg9yzORI+xc9wZLA3KRUROeh8GEb5XW41ZGkN+2rUYBmovzp5UFnT4sbj+vEjqXiicR6l6C
	UJushIYF7Kvmt0Y2H7iNoe3k6Y7K+ZWUb5uK+v5RI3uMvImjV3YW8aY8PofOz8KGbFlXKPmDcBn
	uZkRHSuycg5/BS8cF0lHBEHk=
X-Received: by 2002:a05:7300:a484:b0:2c7:2cac:814c with SMTP id
 5a478bee46e88-2cbfc16e687mr3714292eec.3.1775658708837; Wed, 08 Apr 2026
 07:31:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260408140007.8401-1-sidong.yang@furiosa.ai> <20260408140007.8401-2-sidong.yang@furiosa.ai>
In-Reply-To: <20260408140007.8401-2-sidong.yang@furiosa.ai>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 8 Apr 2026 16:31:35 +0200
X-Gm-Features: AQROBzAf-kiI8Xxr0IXJpWmj_aQGbOJ9Psm4chEl2_TiG3P4EQCU4R8zrRcOQt4
Message-ID: <CANiq72n2h5Vj4-_wfPWXf9HO9UouaKtVKmoTGQeE-g+N-MYUPA@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] rust: bindings: add io_uring headers in bindings_helper.h
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Caleb Sander Mateos <csander@purestorage.com>, Benno Lossin <lossin@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12999-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[miguelojedasandonis@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,furiosa.ai:email]
X-Rspamd-Queue-Id: A58883BDBEE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 8, 2026 at 4:00=E2=80=AFPM Sidong Yang <sidong.yang@furiosa.ai>=
 wrote:
>
> This patch adds two headers io_uring.h io_uring/cmd.h in bindings_helper
> for implementing rust io_uring abstraction.
>
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>

If there is a reason for putting it at the bottom, then please note it
in the commit message.

Thanks!

Cheers,
Miguel

