Return-Path: <io-uring+bounces-13787-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id fmcYJdbwNGqNkgYAu9opvQ
	(envelope-from <io-uring+bounces-13787-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 09:33:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD0616A45B9
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 09:33:41 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eigdC/2z";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13787-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13787-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A8703028EC3
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 07:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B415831B833;
	Fri, 19 Jun 2026 07:32:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FB11E98EF
	for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 07:32:44 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854365; cv=pass; b=kg1n1LltQxqCMjzluPRNxhxIN/DnwdxA5fEvtJJ58DaZ8cKAcrvvJ2A7kihu8NNoel5RueJ/NFo7e04Z185ZWxP3rAm2Dn8/OZcilKZSDvgrOfHIZgWN27jqk+CProwwSci9tIS4KCi663Wg2kutl3PFmSYKRkd5BG8sIWBQJFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854365; c=relaxed/simple;
	bh=dWRxdLAGRYDInZQY6B2Sfv9PCyvW0LxwPrpwXkjDOU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XW6gMT0m2zlP+0jb6zdFWcPvssu4FxvgM8PEchQRJ3XnFLMRdkKgs0/W4CIMT70BT5MNZcMl/K/vqYbB0HVtREDqtM1sv30pBLe/b9v0PSYeNOlC0SRVE3UDKmVFgQf2Os9i642+vQtXs/fNVosnrfy0fwRbnCQnecd8chDyF1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eigdC/2z; arc=pass smtp.client-ip=74.125.82.176
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-30b6dad2382so3442966eec.0
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 00:32:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781854363; cv=none;
        d=google.com; s=arc-20240605;
        b=UWKgfxXd/VLKZqNWtzxZumnvn9m3lLxObejdY3eTgP2HSGahyFgl66J4x9qMLrLzI+
         v91NHsxzliuosyfDiz+merz8OHgqVlutz7sg7QM8WKxzh0H9Vltf1kVI7Cp8eJ1ZpbDw
         9fUGP3P+G9tqJJLvY23cFIZTzk2D4FxecQfZZFNhS3pzbRort3fpVG04MLu3gWHJ7sM5
         DqbmIUGw1DJ7qxSLUXUb3TAn8Xd2DrfNgpOlY2JxGapoEbzPXNM/pFo3ZSajsTbbZY7j
         1sXHfHKPLR1GDSRS0MV3xYO8g2OfBUXfdoJm8IYRF4eheWRlpF/Peq6GS+w1mXjljRNg
         HudA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5iyHnmV1Idu5SaKyMCT5H/JITEJhxNn6+mUdwznI+7U=;
        fh=4lllRbluhkZLBsBp2dHumj8G4PtsCoKvWUXhfV76BSY=;
        b=kutAOUn/z8K49tR01J6dWPG2iERI1Sdlu1TCF8Xdz7lWdnxMM6RvEFRmW2YMxLOdNd
         gsUxR1+732O0sCsPaZHpIfmXZZwzQhwUlq9O0neZ6DbInWl/vwBEy+S2sXnRxtmpVWhF
         Sm/GM/gN3+7gDbIJMdwQooQqEWxkqa7Uk4turqvDLk32UGnZT7+i7gDRaK6OOZocbSCD
         MTnDgAXtKebx6+pq7UcekODGFXk+ezigg7GYclrQ6BX0/6whKDcff7QN1nMTOBsJJ305
         SxyKCzYeuzvyrQo28pG8npsd7mdzb9VzVZ9wL0Rk3h4E2bnjk8x7SROSM4mgt+eNUvo+
         3DGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781854363; x=1782459163; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5iyHnmV1Idu5SaKyMCT5H/JITEJhxNn6+mUdwznI+7U=;
        b=eigdC/2z6EEQipKS6sexR2vhZ1AyXxBupCpC44h5uATvukhMSASnR8F2FGx518c+Z/
         T86pr+b0BZJdJ4QSRsNxMHBIbeXVJ10x7hexFC5D9ntMLkc5GmYWVJhTnzUW/c+g4sMi
         7w2OWZaSoDsytvh/BCff9q3kXLBCYMlEBwxT00V40amhtvmxM7ztYSyjpRNfT/tJ0CJC
         ybQu0OH7LtR3XqaiR+kqv+LcSRt7RyVXGwaDPJvAI77p1sfjsAQ0dcsb9n+BZr/prCrm
         1zFnm7cvPKW82DidKlVnxK6QezVOOfdAfTXePGXuugYtjM/O2nhIwQFGodjFABLWHTLn
         llWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781854363; x=1782459163;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iyHnmV1Idu5SaKyMCT5H/JITEJhxNn6+mUdwznI+7U=;
        b=cIf0RihV4gHbaSHS+5GerOEZB9gyZT5WInv1m3EnFL3/CTfjNKOtwtmAWaAqKZblPW
         5gbhU65hL7443fVI0UEgXRFR7ssnLfXKl+Bl/CAKg18Ld+xRjJ61FuM4y/meeakRtpQV
         OWx1k2LvGidlBgKGfo+K3Om8oRWXcZDjXVYYT5UL/WcBFTJFA7lB+MbsEk8qn6cHGZQE
         ageoAW9c7YfvaBc3qc93n5wpTUG2ofCdZHyhsF21o3KyAiBPXOFY53n22/OYZsdr1H9H
         idGIJq0eyvWSkrSxxGgsI/eZzX8DVElHPGwhj3CaQ0kSciFFwO0UGIKbPF1MVEJfOA7n
         IwcA==
X-Forwarded-Encrypted: i=1; AFNElJ95s1tA/6+SY2HbBBWs/WgzkL9LIs49hZOAcjTRgxtZlOydNHTxGUooh9A76/OS6rscezgoMwM0wQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTtooWjOoAm8YkgG2jwcivG/kXxGZBmu1X2NT3R+nLazv5Xe6l
	G672fPfG+EjMefaybhNoKibugtDNvCI5H8M+FRBb7UVYi5m9Md8n1RCHZvxhv9RiWaQza9UuzQV
	ulQcVoqnD/QILH3NTL2k8Qd4rGPECIGn7CN9+WJU=
X-Gm-Gg: AfdE7cn4a0dYeRu90clJnZTBFKqDQ/fBOfq7xw1ZV/vp+dGv4KKDvNxDUkx2tpPQWoh
	SJXOHLmFxJSNhn/ozrQc1UBYdHy4dqPjky71sCRpZJQJvYUH9t7c//E/I6kb9kJzUJ/GD8pV6HD
	ez2FmU81RukKP87lZN3gAJ8lzAgRt4luiATkIYTdYEHBSPEYHs+gB5QvLUUsP7bS2y9tl+z5Cfx
	tSZVOkNzGvzeTKBzbdmiD/X4hOEbKxxNis+KdqUQs+J6DZaVzLZtQb4WQ0vb5tFGi77B67FViQD
	sBikSe0OdeITg3Xl4aHd/JK+/Q3x
X-Received: by 2002:a05:7300:fd07:b0:2e2:4979:ec7 with SMTP id
 5a478bee46e88-30c0cff3be3mr746177eec.10.1781854363507; Fri, 19 Jun 2026
 00:32:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260617081622.32823-1-harshal24.chavan@gmail.com> <2d35e4d2-72ec-4ae8-90ba-8c9b1e53c58f@kernel.dk>
In-Reply-To: <2d35e4d2-72ec-4ae8-90ba-8c9b1e53c58f@kernel.dk>
From: Harshal Chavan <harshal24.chavan@gmail.com>
Date: Fri, 19 Jun 2026 13:02:31 +0530
X-Gm-Features: AVVi8CczKaIUl_9UotqYyKsDvtGpmGAExPbjHfpqkLzDrVO4kowikfq6u5cB3ys
Message-ID: <CADCAkb60QQriHJ_eZoOXpo0cNCCM5n1Lwr_tCSs2j1=gXCiqgw@mail.gmail.com>
Subject: Re: [PATCH v2] [PATCH v2] io_uring/register: add IORING_REGISTER_CLONE_FILES
 opcode
To: Jens Axboe <axboe@kernel.dk>
Cc: krisman@kernel.org, kees@kernel.org, gustavoars@kernel.org, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13787-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:krisman@kernel.org,m:kees@kernel.org,m:gustavoars@kernel.org,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-hardening@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CD0616A45B9

On 6/17/26 14:54, Jens Axboe wrote:
> Not sure the offsets and partial copies are going to be worth it, but
> I'm willing to have my mind changed. But that's a minor thing really.
>
> Also a question whether the destination should've already allocated a
> sparse table. This kind of bundles the two into one. In general, as
> mention on the GH link, I do think this should work exactly like cloning
> buffers. It'd be somewhat confusing if they don't match up, as it's
> essentially the same operation, just on a different node type.


> > +    /* Copy original dst nodes from before the cloned range */
> > +    for (i = 0; i < min(arg->dst_off, ctx->file_table.data.nr); i++) {
> > +        struct io_rsrc_node *node = ctx->file_table.data.nodes[i];
> > +
> > +        if (node) {
> > +            new_file_table.data.nodes[i] = node;
> > +            node->refs++;
> > +            io_file_bitmap_set(&new_file_table, i);
> > +        }
> > +    }
>
> This definitely won't work - I also mentioned in the GH link that nodes
> cannot be shared, you have to allocate new nodes on the destination
> side.

> The file nodes rely on non-atomic refs when being used, which is
> protected by the ctx->uring_lock as that's always held for the fast path
> issue. If you just assign the node by reference, now you have two
> different rings manipulating the same node in memory, but they don't
> agree on synchronization.

Thanks for the detailed explanation.
In v3, I have rewritten the cloning loops to utilize a new
helper function. It strictly calls io_rsrc_node_alloc(), get_file(),
and io_fixed_file_set() for every single transferred node. We no longer
share references across rings; the destination ring is fully populated
with its own newly allocated, private nodes to avoid any non-atomic
reference races.

