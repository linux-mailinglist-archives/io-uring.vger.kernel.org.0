Return-Path: <io-uring+bounces-13635-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id U7NMFrj/JWpoQQIAu9opvQ
	(envelope-from <io-uring+bounces-13635-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 01:33:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9466651EA6
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 01:33:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="o/d7uPqX";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13635-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13635-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B3D4300EF94
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 23:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143FA20010A;
	Sun,  7 Jun 2026 23:31:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E648327FD6D
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 23:31:02 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780875064; cv=pass; b=j5ducMhxiU3Gfw5Zr7JUwjedo7bfwwPtysWLamU3XkGPXakdfBV5Yt4A8Vj/MSMutelHQAO8VaG4NGgsxcSTRzCC/9ZHY+URhrWK7wQ9wWF/81X3OoRuET5/d75T6TzkHOTWgAdNQGtoId9rvtmAqC2Sf9l4wGOngaoLAPqu7hQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780875064; c=relaxed/simple;
	bh=zGg/cwPFS5eTJjEY8Rb+S0ERIuwj6yveOPT1+k7Y2Rs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=XSUibgUAtAOEgUa6SZzfAyrmkLeHFaDkO191LClD+Wxb2YNDW1Hs4566sfqUxW2+M+Ppz52Oz+Mfvz5JoGWkyxHiQSlXn2oleLon8hTMrCE7QrIRAJnNkMmq2m+Jzzb3Nzd9QGdFeOXgXEDX9v0g0wGHgxqyh1aoCfH4vhguceU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o/d7uPqX; arc=pass smtp.client-ip=209.85.161.44
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-69de9bc590aso2780274eaf.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 16:31:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780875062; cv=none;
        d=google.com; s=arc-20240605;
        b=feHIkM9ATpiz7AnIBxgdDuveCMl1OzNHsVu2ZKVSHCEgD3kysZhMX7AkrG9b5rv733
         ApjpJGJJ89X0J/fQuBDuX7a8YiZ7Y7UgDbv69BH4ZcDVUQTEwa/RxFoTEdFXP8cPhbBd
         xZPcmnqA2U75h67sBAu7qx6w+V4ZsXV7DopuMwG372usfdma5Nx8AT5jjFsoc2l834I/
         8J9mzkLRAwp6ES3jVTy8fGsju+F8blUe19bHR+lxTw2XUMTaZJte8uktX5ehJrqgsZ/w
         pTt664qUsJwLnKuCHk4nZi3nBblsBqBcdfT3dHe3yY82iH1FYFlZqrRL2AZ1nRm+9UJh
         +sZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=zGg/cwPFS5eTJjEY8Rb+S0ERIuwj6yveOPT1+k7Y2Rs=;
        fh=s7l7ejypG0fCLBTHpkyOy56YfIDqS6MmRBH66Fif1CA=;
        b=DQce5hr82PNuZGhWcvP3Pn9L95eOs1orN2IUuNxfDv/9ZWhfr6rjduyhUaeREcvON/
         UT9FXKw27DAq0tEJb8yBK1uPChY04C+HM6f7rx6gxPTfmdJZpf5dUgXRv+7+dTqksqLB
         UcmQYhwJh2VQC6+AEjbBbwrW6cUJy+4OPcpjoZhqg6RUShIxSENjUp3MuWA1q1Fm7FFb
         m+Vazre+adFZn7+lf4mg3tYVWoHDVhFt4s8blo3AKlskm1m8PJzYTmqF7CeRn06Mcw0U
         FTDOsgeRuXUAx6vOK1DA7eRZIt4nmkZvLJSCC61K+0AWRz0qa8TFqTjfZWOff4XmJLxq
         2Pyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780875062; x=1781479862; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGg/cwPFS5eTJjEY8Rb+S0ERIuwj6yveOPT1+k7Y2Rs=;
        b=o/d7uPqXQP3OdUAVA/hCvLH/C00LhPytUfsv1txkNt+uM1VXJPNbVyQrWWBA1BmSHx
         aFL1JDtKqj4bk23kXpC4ydVY+RXGli5FdmVEOwpe53GbyNpra8p+zOIw1Arj58zGhXCQ
         QeUJGM0TrpQkp6bxe7nuE2xZTSCB5XN21fekPoGaIBrOfjrH5UGRSthYsDiWV2pt6Dl8
         VATZkpdluqcDKfHZwZbzHPTKamWXB/9SanDTwOdDq9++S6UM+jAviytq0IdC3NfPCjIj
         mTc6T59T1crlNl9Es8bUpILm9sTH8rqzyYIKZsB25naBhjnPRS+95HI2l6lqNlbq/iQx
         4C6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780875062; x=1781479862;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGg/cwPFS5eTJjEY8Rb+S0ERIuwj6yveOPT1+k7Y2Rs=;
        b=UlnzvD6oct16gklSMGjJmofarLPbWc09tbTnHXBGrG76uSx0TD+FiK06/onoL/XJyz
         NIzX6it0BgmXg2ugDWA8nXsRkR7eTo9gCnEmRmPkDK1i5XIRIXrJMU1a1Vsig5GeadN+
         S9Rhsv4o3zYEwnveiFYGHwLUW0n/+bvE3QFPkxCJWVljWBNhTXOCyeTE2mW6WbkvQNij
         CGhrMCh+IesKwqMZafVsNBKVn76nLoG1M6byJDgkA7Q+khDlt1qPc3cwLCyJjtjM4vaM
         gCU0G7IAIDjrVjrI/Yyew2nuQ7JDdoR2ytIUVxvmVH6my4bKwQ++JNHpDYPoKRTkY7hG
         UDPg==
X-Forwarded-Encrypted: i=1; AFNElJ+kofLFCHoW5BxeGJm6p3h+f4xyTsUjBJB34Gcv/z1/0cl6j6Gna5of/sJOokFrkPvKntdjdvuKcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOhGCyfypi5q6z5mCxYkvdpFh0bJxHpMdsZI+TcQRcIgnS/Af9
	9cZifZw8Tqzo7/WUvirGK+tz1Myuz3OXS4cG4c6IuDaSRfL9fqNRDftFcttWGGYfjke2GCAMk/g
	xVK1ub5NQcwy7FjoT/MnjIMh05BInSFCOhQo4
X-Gm-Gg: Acq92OGDWwvScWv8aQp/McQoWeGpzn7L/4GZ58t/ntFD3nH6qRpuBwqosdGaVQ7Q65u
	wFhqvLMvYyqKIqsrnP8eHqzFCCNHj+VY/tJ8G9KD4Du1b8qcyuSPeBfkUoeU2/5y5leuHNYZQFY
	MEJJpDIpr/1RIEz2eFOxHFwhtn0vgtSVhqLpe0/7q45jl5cr02QoHxobMnOSdLrEKVnFcPXrWxj
	hJx3FWHnPBypkdRZ9VewVH8o80mA05Sn7Uv9PL88BwH5jwwDiOgpjOb8kOxMZIJvZ/N9MMpJrgn
	w5CjeNoJGmOO7KcNCeC+FDUSEx9x73tDVtI3BbQA3tbGQOeLdZACTZ3qIIxk1N+TxmuWHquBzfH
	59bR4ASoCanHrl6XQHynL0P5wIQ2J
X-Received: by 2002:a05:6820:138c:b0:696:924d:295c with SMTP id
 006d021491bc7-69e68b1b87cmr6989615eaf.9.1780875062058; Sun, 07 Jun 2026
 16:31:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260601095853.3670199-1-ming.lei@redhat.com>
In-Reply-To: <20260601095853.3670199-1-ming.lei@redhat.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Mon, 8 Jun 2026 07:30:52 +0800
X-Gm-Features: AVVi8CeCvz-QNQ6O-B46xMk6QLk15SScoAGQelySaXIsZhtQfRlclCHySHo-0t0
Message-ID: <CACVXFVNFgEgW6iTS=R1OtC+s3v+28BdhApANF6G2YBrkQCaDPQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] io_uring/net: support registered buffer for plain
 send and recv
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	TAGGED_FROM(0.00)[bounces-13635-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A9466651EA6

Hello Jens,

Ping...

Thanks,
Ming

