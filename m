Return-Path: <io-uring+bounces-13421-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yL05BMgtDGq0XwUAu9opvQ
	(envelope-from <io-uring+bounces-13421-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 11:30:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7674757B53C
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 11:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D62E630942E1
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 09:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF41F3F787B;
	Tue, 19 May 2026 09:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TXpWbKTo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D07C3F6C4E
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 09:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779182517; cv=none; b=hMiA0o/TmKpcuPB/eX8eQf9j7c6Drhok4PBDV7L6DVMKDnZQE92Ku4GmX1novapbo4VS3x46XcWlPspS5ixHTEuBr4lE7MstVNHv6n/Iybb3sEjwgysIvkv9P2yUVb5912oHvJA9I/+80ev1tmsPJyDYG6l3ks/Bhp7h445zC9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779182517; c=relaxed/simple;
	bh=wSz4n6ZHAULGvzhTDNuqX4TTX95Vfl31WZE4J82fus8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cj8g0FFCq7kkWnXtDuvuljq2pU8aFV/jhsvNHyMmQ0XBdQk3DG+/t2DBA3+vhjPEF5cHqM1K+fi+xtONPSGu2mEbl5rK6MulLzL5YP5mbRA8qPRMi7StdxsnXTTgy3yGr7ObLszryH10Pcr2hKEJcW7I7CEp8JeOr46+9lUYsTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TXpWbKTo; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48896199cbaso26069605e9.1
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 02:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779182511; x=1779787311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QoHvwM4p61ukSgPZjfDBcRJdrzaBcrrvLVu02xCIKiI=;
        b=TXpWbKTojEsG/x9DQwsk/0H+XskySEyrX0rBufagIM5coaGZbN4GMMyWHMx4wOTKnO
         6nM1l2EQGpvGlehe2RC3T4ZBB1WXsj5Rf1E3MrufZxH1mcHQuV2DAjr18FBVYOUqYjgc
         +6y1OM/nUF90Z8+DA5+FZSGWcJgji8lL/IivBQGcVB2VBugHWaXZs3DvHHfOHbKVJOLc
         vV+FsJBSqOSx/H3aGa+CQ0UCZvTUjL0to9I1RZpRrMVSq0L1BHC0/CMKYJEwpHBcmjhf
         OXkr4+d8/+ve/13fJL8u6Pr2sBaon2BIZEsoQmRkPYR4psV5RmARGkuLDY7jOuB2fCFu
         Dd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779182511; x=1779787311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QoHvwM4p61ukSgPZjfDBcRJdrzaBcrrvLVu02xCIKiI=;
        b=Iok4KRt4OLL4JQPY0aak58MwlUvljacn/k5JZ0UKLDHCaZVSWlF2mwnzgM9oWYt8f2
         PXTNyl7vIxkBJabXAO1h1nTKzm4o4HENraEIR9i37H5zH8Yei0eZeLxaqGe+3ihkzg67
         Fn2qU6L9haLgcTVsZX+uons3Am1dpWVVb32q1E3lycmnvIkGaB8MFc5u75guNsHLSel1
         NUoPAP6Tpesow1TBo6H/bnLePN55yDtmGpQdwRm9MpLqhHI7Ns6rRUmeBWpYqIqJhjan
         3pFPtkMWDhypjRYVG9DVzgAyHIBBoHyu2dtoGMQuspBpmrZ21uAilicB7oeRAXQBTQA+
         llqQ==
X-Forwarded-Encrypted: i=1; AFNElJ9WODlrjVnuXrXJquTJxKpvW+0yWLiSrc0RolPfoCepjueIvoTRTlUo5ZBxHVhaAWjPBOddZvDcaA==@vger.kernel.org
X-Gm-Message-State: AOJu0YytKRH3VcvBZd0a5YWC70PQjBY0CZ/dzikM6Z1YNSmfBGae1CWl
	04bcphZ9omgWg9ETrQvPHf2SqhYt6r+dR76rLJDFBo+Rv8n/riv+nxkx
X-Gm-Gg: Acq92OHkmR9INf+mf8+5BdJibIMp2krlQrPNBjxtT9OdEdq6BmEdtAodJXr5F4bkyat
	E1d35DNMjDXMp+CZ20mt2xS/9SpJ0tx5LA1NeGAdNoqIiirp3BBcCDuAuirYxzLg0pMGkLWqHDV
	y7rW33LrFxws5zKYhyUjOC+2KxgTIuazecteSPvbJ1CDri/DwMjMmfFj1qwEFL6+GmNRmwx4Rpg
	Pvy2Xg1Jg9Xv7uB0+oeB2HpdT3Ha7GtDA1BARo2OWVYwHPXnHreHGahyiGuP2zzPjEDvenLhpwi
	Pa799TRAHkAyK+7XM628m9XTpPHXIl2SFZ+SDM5NjMTRYndF2OmHHL2L6+AsdLT2Fw93pN+/XlV
	8PhnWECaaPW3iElnDFYLkk+Mc4Ny74bPMkDa0dWs5qBup3xBXBEQzuaBRQU+cuYdfp7cPLSgpCb
	jsgXN/xI/z5+o5rv4a+S5DD0mJ5c7PqHYl8w2tnXNhMgCZgQh9b6sbiJOfPlH7MSeKQIwTZHf5d
	oM=
X-Received: by 2002:a05:600c:4f13:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-48fe6328bb7mr321111245e9.21.1779182510799;
        Tue, 19 May 2026 02:21:50 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48feab2a23dsm102576065e9.5.2026.05.19.02.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 02:21:50 -0700 (PDT)
Date: Tue, 19 May 2026 10:21:48 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith
 Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, Nitesh
 Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, Anuj
 Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 04/10] block: introduce dma map backed bio type
Message-ID: <20260519102148.21d42afc@pumpkin>
In-Reply-To: <24833f76-2289-4859-86d1-9215b11a1258@gmail.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
	<646ecd6fde8d9e146cb051efb514deb27ce3883e.1777475843.git.asml.silence@gmail.com>
	<20260513081929.GD5477@lst.de>
	<24833f76-2289-4859-86d1-9215b11a1258@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13421-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 7674757B53C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 18 May 2026 11:29:54 +0100
Pavel Begunkov <asml.silence@gmail.com> wrote:

> On 5/13/26 09:19, Christoph Hellwig wrote:
> >> +	if (!bio_flagged(bio_src, BIO_DMABUF_MAP)) {
> >> +		bio->bi_io_vec = bio_src->bi_io_vec;
> >> +	} else {
> >> +		bio->dmabuf_map = bio_src->dmabuf_map;
> >> +		bio_set_flag(bio, BIO_DMABUF_MAP);
> >> +	}  
> > 
> > This is backwards, please avoid pointless negations:  
> 
> I can flip it, but compilers tend to prefer the true branch. E.g. this
> 
> if (cond) A; else B;
> C;
> 
> can get compiled into:
> 
> jmpcc cond B
> A: ...
> C:
> return;
> B: ...
> jmp C;

I'm pretty sure gcc completely ignores the order.
Some very old compilers didn't - to the extreme of generating a short
conditional branch around a long unconditional branch to get past a
large 'true' code block.

likely() and unlikely() can change things, they are definitely useful
comments to a human (or Human) reader.

I'm not sure you can rely on the branch predictor to do anything sensible
outside of a loop.

-- David

