Return-Path: <io-uring+bounces-12332-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBxUNg0Tl2n7uAIAu9opvQ
	(envelope-from <io-uring+bounces-12332-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:41:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8536515F2D7
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E826F300669C
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 13:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EFE1DE4E0;
	Thu, 19 Feb 2026 13:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z0/Exdgo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80712EE611
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771508491; cv=pass; b=dQzzQ4AA8wtN/CG9sItnWgsMZYkvVyXS0WbTdSURDRf73VUQymLXjuwww7Wdj8csxhCwoPKpS6iVDizZwCiGv0gayp14uPyaQ89LV+IXC38K+mTc3VTj6bqFJO6EZ19gNf5Rp45bz6sFomtd9lKTR/OY0bDG2g9XwrCFQrmFdIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771508491; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uUOEuXY6RpPbWvSYKpvHgTWEBZfk+Bc5qSyTXTNdMUoofEplebbU7MriOOIdu69waxoF351GK2hHClyI+TP33+zZ41kbgctCzr0b22IY0s8ghhovx2lArg9uZy39PFrOxjbPKB60Wnt/H5HCy1EqaCumKaQHNDDArjgzpq0JExY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z0/Exdgo; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8f8f2106f1so142504266b.2
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 05:41:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771508489; cv=none;
        d=google.com; s=arc-20240605;
        b=UOtR0UmsUzQN5+1eqvXXQb315COc0MXMCG09aT5CmYvnSSYZMlgG8PLtEi0J4eCGFP
         UH/GPxsQ5C7ui+bKHeKrsJahI9Rgj69QBMxYX+WLkmtvnlMiHf4aT/S2cUYmM4C09mdO
         vGvnKcfSVF/UzwPyi0a7/uwnibS6vKH1Ei3X9vCfYbQ1QVVSuomqsx7rxrqrk+s0rehw
         twLjhZp0S4j1XVZbPl0Q4BfBYjy/mj68HmFr0zYk7jq4i7l1m2q6v2SEks8EmdNyue+I
         wDqjzdH7cmLaHJI6fHRpYf5XUGL48ic2UJL+IQ62KYU2/G339ZBKgMbxV9yKpmbWRLq3
         kTRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=AGyDX59TfYxDB7bL/4xt4YlVBEQE6I9t6fMqj3zqWyM=;
        b=ecVGIte78yjiSWU4q+TCIkjR9xgdHMJLS7TAgO0rjFQCPBnBpqVivfNlqhHvnar+q2
         qczAUlHEj7VcAu+I+/kxa5popb4PfcUfSJnCXk2qlyhb2D5Ka4gedUpCp8URDyXRg7Hi
         mK+82N17QIf19Z46GNi2twyHE8eJPiHm1+wHZuQSaLRIIzd66AmBGRI8pR1trfNbDm0N
         1nq+Vgw5RAMZT6GjoUs3Mzr4q3GopsLCh6H5eAv6UzoiwK2ybdjcDFNGQZVfBdoI1m2n
         mpXm95qSS3AqZtI74zhg2c1aUm5DIZLacElqr+ChfnTu9Bi7YUczTjtO3r41u/1l95o1
         DPGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771508489; x=1772113289; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=Z0/Exdgojg5z2vRfhkA8JRqA31bFCL8fROGQ1pjxWe+FdqqEHnsKQ758BqyDgToF7/
         IdOcY1rV74ZwTDLSeoSuCEteZag6B/+usE0dFJ7rbGSRvmJBHRO7kiQfGjYOwBrYU5xt
         w0uQSUUq3SHfCv7vzkeL9qwNeiEiA+vkVwOQYei1T4h3aDdt6/D05uEZJ5icQsKRp5w0
         S5ZRfwE52BiP7y3oEpD6Rfy6MIHyhf9k1w98TexuFFmGa6WH21yNA4hUhw8e1XcjvuRO
         x6xUWO9e/dd5jxJCeLygMnxWDbhk5y+M0AoCpwik7aRT39Xz0aiQ/yvOAJc1dfI1SVKm
         eGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771508489; x=1772113289;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=u+iGBQp764iakk6nqimwk2OBO5Wg/CUE0jf8GGD2UPVuE3DEmoT0oBfLyXoKOlEerT
         nbAAfkADeDKgoLf6TNKtbHYIQXUTWNweOV/aVf7ScpwzITygktqM4WgCBLLrvw0Hn2g3
         lKfYNYHzYV5OY3mpID3gEx6m2qeACGa+t4SnMoKjn0n0HaK9mOC2Q8P9fwED0CTnCvWv
         us3p5HRg6FvrKA5hTZy9k2Tmct1AYPchkqpi2wXHpWdUwKe2RbQdjCWUN+PxVgEzuto5
         T9Wwx4c8K1x28jIRTWwHsOh56CY948GLtShZLdb3evXFwkO3fKlDJB+jgTJZWB4+y0oC
         pDsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXZ2qlW+yo+b6UILIffShHg2GOtWnEWMKjpAoJDxezACr5UVI1vqfghuSR513AXbuH1uXe0uYdKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YysPg2IxqdPU4zayTIYJXATRR16znyIMAXGZU6jlKYZ454Kdu9t
	8G9T7EkrEYq8kWQBPREWC9QMrkxCdbqAXAUVtUyRdsNZoRGoIEQwlGtHU2nBd/8vQRN9LpuPw8F
	T1COHc6YqtJbYnfG0BnyRFmULwXHjfA==
X-Gm-Gg: AZuq6aKTo3G2O6zCMr48BAomm7DzXa/ZedTzUgBJlkqrCUGy+P2Vl8dD1zVG7jybPpK
	Ju97Ce2nS6L0pxE9CQf+0AILhSQZJY5ZeJHcOgUuW33StthePefIVTs0yBnkkhPn36gWuI8ImVC
	B4SOSlDM0dbBzwqP/2HmpH35LNV6wOpqidaYVwuIcJYnmiM6FepNgAiu71JZNdxq6BLxlykdz/H
	invsyDkzRVz1i2bXFoyx1sriTt7Xew68KPiICzuNCrs5GvCsQpIgEUpThOP5d2965yFG8DyuIQm
	yK6pYYttXnJMO6/1SQYaLkLa5GnFY/PZOvj7HsUMsp4YFXV+E5c7qDCr6ttRU0mxICI=
X-Received: by 2002:a17:907:9703:b0:b8a:f7fb:4f4d with SMTP id
 a640c23a62f3a-b8fc3a3a04fmr1048564066b.16.1771508488842; Thu, 19 Feb 2026
 05:41:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219013534.4140776-1-csander@purestorage.com>
In-Reply-To: <20260219013534.4140776-1-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 19 Feb 2026 19:10:51 +0530
X-Gm-Features: AaiRm50i9CBgUa1hfeQ1dyMgIMqF_o-qDfC_tGWoJu6sGGxZLT9Q0oBmEohoSuA
Message-ID: <CACzX3Av38GK2MRU1=aMpoAQR06sg+pJRFqdgLtC+zi+hgGfCDw@mail.gmail.com>
Subject: Re: [PATCH] io_uring: add IORING_OP_URING_CMD128 to opcode checks
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12332-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anuj1072538@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 8536515F2D7
X-Rspamd-Action: no action

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

