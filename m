Return-Path: <io-uring+bounces-12089-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMPgN+iThmnuOwQAu9opvQ
	(envelope-from <io-uring+bounces-12089-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 07 Feb 2026 02:22:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B648104759
	for <lists+io-uring@lfdr.de>; Sat, 07 Feb 2026 02:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DB2DE3004D1C
	for <lists+io-uring@lfdr.de>; Sat,  7 Feb 2026 01:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6F64275B05;
	Sat,  7 Feb 2026 01:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mk2UUZUe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0AB274FE8
	for <io-uring@vger.kernel.org>; Sat,  7 Feb 2026 01:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770427366; cv=pass; b=oXv1qHvoLr9IzdeKESpJSFnYi0rHu4jhf5BQtNhcLt0cpGXHiIeMF+eSnQ3ZJ4CH6xHZZLCVP5mNraAszdBQjjivLTgpUQlEr9MMix1MrTTsW33BuCifwjwsBpkSxw/SQ64FW/+YvuTc7/+Gp78HdW/Nd8zN9tWSQSNLpz9QdVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770427366; c=relaxed/simple;
	bh=w6ehWV/UdsOefVPVO/LSKgkiGRVYbFAtJfDqBHGr9NA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tfgoN58Dv3JsusZuyVamy6NCY9pEWt+0dfJrFHEqs12regF9NlbVvvVQtwYHzaifgnOuC8TGdFqTufsFVnSyeWf+P7FOuG2ZLJkjWwLOl12hAzoQu/eBwlHm8q/1xmTTCRW+qiOakSwi5POxM4CTiSGAPdGBl3rklvt5ZDC/jyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mk2UUZUe; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50145d27b4cso30900071cf.2
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 17:22:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770427365; cv=none;
        d=google.com; s=arc-20240605;
        b=K3AtIfMRQ4HiAWFZfkiJE2GDk7yC8AqRRFd3/lbcpW/jo/BsYzyhOrWp0sPDdCtyZ9
         HzbeiiNmY2lgDHT/rmWh0LfqOEnIqj325gMYHjOa6GS8Oy+nVMky8NgjcGmd1lSQ9QZZ
         aK6lsCp5GVaatBVZHcY1dGGhwpMS87Xgfr8LelZEQk1GSfZufc3ErQCX5Zsi/wQtc7wY
         nA91+IvEIN1IC55xJIeew9qeA+CgQ1xjD9TBqHDzozalWn/P3E9UsZlc/r9VucW5FNlW
         ezaqK2iRAcCt+jhavKqzHSxkcF3Chm4OWp3gwxMjhbCT61EyEwBQfVv8eRuNfMx/HidR
         wlTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w6ehWV/UdsOefVPVO/LSKgkiGRVYbFAtJfDqBHGr9NA=;
        fh=EB6DZX35AKbEdzku3dklha08RKNEzWV8LugbYj3z4NM=;
        b=RuoIcZb0J7YLK+qtFbleZaz4gH4VEjTLGh/qK91am1GwXdyPq29vnayk8Gov3M/Nm2
         rlqQPs7Y8UjPN1BijaqveGFkaxqpt5gc12PHBKE8IT4j0F+vy/yy06/wp+W0GoLFlkUH
         zlpvB5AGALJXDJhsPoewyxvsfRUDUejk7lQ4Ildc0bVL6hZdSzI9vPb4V9NTaOQDjMtD
         c5ylkbi1FefX85NQrt+z57PiuDw6z+v7sc9/Z5OEYlYON6REwqx4jWv2rItwAR3Cq6Ui
         tJYjnZVBa7Pq8nkILxbyNrJLWhhIg5kSptdeymtg9AmuBocV6THHKSRHnYXN4/SS+MPW
         2VBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770427365; x=1771032165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w6ehWV/UdsOefVPVO/LSKgkiGRVYbFAtJfDqBHGr9NA=;
        b=Mk2UUZUemwK+JSrIDO9rw/yFO0+WshfGBrNEBUZA70yX3/xylB+Jot4WrxzgM63eN2
         fBkJf5LxTJXrofhFePRI7kLrZu/XZ8Znk/RucRlwz/zm31vEkJ7WFKC11Kx0pEEzBhex
         E8NBlXZLkvPOUM+v+u/eHkHw+92yeJb3ggnyryMan5YAtAOaKGphAENZsrMfIFvXHOro
         yx80V1lDAgVmFdRHOnibJy2/l8wpKb6Wocdgfh6v3lpLJFmggTWJ0vEFn2nwUDihrVxo
         FS+m1FRiUV/3ZzHorPy1jV2JXH3kAYAYs8f7S4lhqtPaIK1XsHapsVvkntSyqpzhL/1+
         5XKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770427365; x=1771032165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w6ehWV/UdsOefVPVO/LSKgkiGRVYbFAtJfDqBHGr9NA=;
        b=BWlxfGPr6QnsJ0c0vhzDfIKi0yLi6644v35zJVcEgwMqlwPUCArTIirMXCp2RHm6MO
         Pt1gx7XSqmZ5A/Q4rgzZpeDJp0M7GVn80MfsijtF9g/ldwU8JCjvZ6gZmH7QDWfLiFQO
         z0wTGkB3iKAgYXXBLjlB8Fsn4yS4gX9Gz8vsBOkVvGhRO7vgdQsqAMVtlK+vR5JfDWRQ
         lbyytNeKoQ3pEHs+c5aRCkhmiaHjkPegZ14W5e07jY1udrVfN86pSPy3cl63yqOlYJNy
         OXHvLjfzKHJXs2nTn5j9UEnnNbsdvp4S1haIqPCkl9a+Y1ye9MJilJESrMzTzakLk2Qn
         s4fA==
X-Forwarded-Encrypted: i=1; AJvYcCW6Ml1/bXE+4MQHqAAUoj82ur7/TWqvADH3B0t5+/3+4wHf2JEYIe47OHTQFdwuYbFtI9BQS/lLZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdcb+t3Rd913Q/IBR2WDtdZlx6RNG0IZBX22YmhoAVx+s3nBK3
	Q1/lPjawlL3rouzp+qyZlgYaW1wXtJIyURrk3HxQcNTx0f8RGT0rlPbJnKBQ5yMJ2AQKy5lZAyu
	NoZwnvuKoHxWFJvte8jojJgGE2lcHdWk=
X-Gm-Gg: AZuq6aIfCrvgBkNLRMMBM8xFOpTQ2Us1id/exi4ukSyXFxuhNziPiLEUjY3jfrSHtVG
	SgyV49aTM+cMKJc6NbrDBmNBnibCAEZKwTKT3YZJttbNQtrCAPTcHVNvgjb35d89L1fSm/hqft7
	S4hyNVm57xgexr0AmmLiPT0srRTLDOvE9bEMBBaN9IqVQ2PxRj9SvPrIkuMSNzMI5zEV27l4dms
	q6QOkqjHIzpjwtfWBGTVp4A678Ob0tYu39dZJWNsbS8myVwT+cvaTWQvPYNtmFPIw/1BA==
X-Received: by 2002:ac8:598e:0:b0:502:a1c7:4080 with SMTP id
 d75a77b69052e-5063986ae2cmr59285181cf.11.1770427365486; Fri, 06 Feb 2026
 17:22:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-4-joannelkoong@gmail.com> <20260206133950.3133771-1-safinaskar@gmail.com>
In-Reply-To: <20260206133950.3133771-1-safinaskar@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 6 Feb 2026 17:22:34 -0800
X-Gm-Features: AZwV_Qj06frHCkzPc9ihdEGHCYKBXNPzugFJmrQuHHZu6XHj5C4wvoGRD1e8Q28
Message-ID: <CAJnrk1YEw2CJb5Vv__BX7DaZXmZMfTsH3WYtQ2s4RGDWNRW4_A@mail.gmail.com>
Subject: Re: [PATCH v4 03/25] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Askar Safin <safinaskar@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12089-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,ddn.com,purestorage.com,vger.kernel.org,suse.de,szeredi.hu,infradead.org,samsung.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 8B648104759
X-Rspamd-Action: no action

On Fri, Feb 6, 2026 at 5:40=E2=80=AFAM Askar Safin <safinaskar@gmail.com> w=
rote:
>
> Joanne Koong <joannelkoong@gmail.com>:
> > Add support for kernel-managed buffer rings (kmbuf rings)
>
> Is it true that these kbufs solve same problem splice originally meant fo=
r?
> I. e. is it true that kbuf is modern uring-based replacement for splice?
>
> Linus said in 2006 in https://lore.kernel.org/all/Pine.LNX.4.64.060330085=
3190.27203@g5.osdl.org/ :
>
> > The pipe is just the standard in-kernel buffer between two arbitrary
> > points. Think of it as a scatter-gather list with a wait-queue. That's
> > what a pipe _is_. Trying to get rid of the pipe totally misses the
> > whole point of splice().
>
> So, kbuf is modern version of exactly this?

I don't think this is related to kmbufs. Zero-copying is done through
registered buffers (eg userspace registers sparse buffers for the ring
ahead of time and then on the kernel side, those sparse buffers can be
filled out by the kernel to point to relevant folios), which is
separate from kmbufs. In fuse, kmbufs are used for non-zero-copyable
payloads, and leveraged primarily as a way to minimize the memory
footprint (especially once incremental buffer consumption for kmbufs
is added, which I'm planning to do next).

Thanks,
Joanne

>
> --
> Askar Safin

