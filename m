Return-Path: <io-uring+bounces-13012-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDsQK+1w12mDOAgAu9opvQ
	(envelope-from <io-uring+bounces-13012-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 11:27:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9F63C86F5
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 11:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 886733101D12
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2026 09:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2947F3AB290;
	Thu,  9 Apr 2026 09:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iqve4XlV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968A83AA51F
	for <io-uring@vger.kernel.org>; Thu,  9 Apr 2026 09:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775726095; cv=pass; b=Kw6af5tBJ9JSZEnNghNtz0ap6ReoeCw6aQOO3rmpmzEmA0GbrtM8wrpP8xKTJTQhZu0m8gQSmdQq7wfNvPmYDkgTKgAQaDz2K+P5lDICbBHEzYeYFwnTbrCr5sRiW4AXjRa9XUv3bHq8G4kF/OTK9qBiieFCiP+r9isBvudW9lY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775726095; c=relaxed/simple;
	bh=Appj18t8IFvoF6NtnGZA4Bfdh46ik48csmz3ymT9oiQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=pobajD7bc1KoRYfv8bgO+MXi181o0UdEJGEN5TsxLIJHHMb6H5GubHdY1lBphD/oXebq/hsynzdXigo9LJC6+GS5KlyeUFtQila+8bjnYZCF1a+I9nv+Ye+fWUsRIOZJ7x67HwOAR6LulXSnQ7uYJ++3LP2jHwV7kl5gcOdoNVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iqve4XlV; arc=pass smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-4230a00de40so490393fac.1
        for <io-uring@vger.kernel.org>; Thu, 09 Apr 2026 02:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775726089; cv=none;
        d=google.com; s=arc-20240605;
        b=H6l/86pUuojo9viqqoF1UQjpR0zt8Lc6WxhL4Bh/BkqcvpNAxcR3286wbVuQg7muQq
         ZH6KOTLY6XN5OAJOhtZVFxtmLEKwHOEIeeTh8f31qVALNQjLPrGeCRi6B7y1AGY84orA
         BBgqZDTCssZWkIcsp50Y888dzSOga4Ny44ORiFXDh/sGoGvVHJJbDzGTFraXEdUBed2g
         zIQVj0wkvZ4yxNkkiuuhUvsx3gHGc1Xkb0fQQoKCr4gLMh9AvImS1m0SPF2fiCA/qNDp
         c3IxrowAaFpHLycpR9Y2+WKUOp+x9UGL6KVYermlKIBszFjPjvMV3fwVWbR6VL/ZPFqr
         jTFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=Z23ilhc8j2F7lQt5beHnbCcqZcnAy88B/Dq2hRr0wcA=;
        fh=+KWbfl82b05iT62NkgNX6qaeI6n9O50ymC+TZtTEQmg=;
        b=YPosBkf3kk0u39dZiI3k7C7fq9hV1XDYrOPIH3j8QZXInABs65OINdTPDXuSXGsusn
         0ZVXqNd0V1UsTHvQKyKu9L7yWEcjJgzLHWK3tntlnypiYFM7Ew19TnKnr2K6uWDCNPoq
         EJzko5fTi28Xajc3GoqwSUOtPbj3XlLMvFsQRgX5eoO00xsjdP53h3or0LmAQV0oJiXQ
         8D2VLYz4GrQcYeQQDPeouTZ0Jpr2+5nUGOF6henYt2GV2i6yOsVyXeoo78Yf6lZYA8lq
         QdtwYTwg3+0llqaLRNZDNP/lMoyQK33jqpgzY36vX/qwgcl9fGvMxsYXqKlgy28kS2hP
         JBfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775726089; x=1776330889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z23ilhc8j2F7lQt5beHnbCcqZcnAy88B/Dq2hRr0wcA=;
        b=Iqve4XlVUbjGZ0aeNQFpUfoCvvi938bSrCFrIMEe84qYb7Qe+XtaAtzMvOmUKDHNuB
         /NAHd5s1wnUOiAe0Yyvqmg3TsV+ca4263UgS1DSLWReMjDrIZ3odtrTRsngLHku5NxrS
         bEyp/XMX/V4gnKdbbIFPQBYAdo/qdC/LPELCw6GkkeA/UgU0HW5hgfOoZfbpdx/O8/yR
         xJiu7TX0cVSLnB6fO7s9Wt5AogEjP5vfIUZF7SpTWZ8cDbwu192MOGWJZJb63kaZOtOc
         wgT6HjIbj2NEQqYtO8THhcm8QLZd9plzX2nSH5drcdtcukm8UabYyS/mcGCnijCIy7Zs
         SI8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775726089; x=1776330889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z23ilhc8j2F7lQt5beHnbCcqZcnAy88B/Dq2hRr0wcA=;
        b=YdvkQEWAO+P2Qdg+RfTQXuLzz+v2ZmOJ+nbAdx3CXUef2/gtEld8/qvcMtNV+hNdKn
         +LXvxWzd4O3v7i4j3471i8dvztJSB4qTsfST9/G1eNG/TT0u5cP3iHmNkuLQkXwXdOUu
         Wm31Ur0t6gTbi94hY7XQS/SJrdqHZ6E3fJfyQCuckrjtFA5evwiO4uVcSoD8utikT3+n
         Dd4bnmtAS5kbF0f8II0If+lk1zyj1kx46q2QAOnFxrXmnuOdRsYJG+rqsgVigPhrgK0x
         Vu6nOwkVY893tcEGG83USfFT0E144X1BAnJ09GSygU0ijzqzS2WzuFk3ZzNJvLdNFn2D
         4gnQ==
X-Gm-Message-State: AOJu0YwKQKwXEESNd4GyUQ0VjfSI1Kew8pEKtayl/i37yJLktauIlnAu
	5iFnxxZW88jH4Avwm+FqqpKkeW9pxuybBOpYDYFVVWPzzNNqD0RwbXxOrO6ZTxuvf7o94JAiEZo
	jLxfIa5SmaOFC0RbDgger1zJ8Y7C9HWoN790m
X-Gm-Gg: AeBDievbxuBWLgMTX96xMdlvGauM9FNDUonPa+Szv+KIPWHphgrDwrAD3MoRT8D2odN
	n5o5Ta3+FqvPSMowUbzrpDU0LfDpdTbpwKEMCxzozTXMQMj3PtVAKwRDqoQ5QHRW0BRwU61mDfc
	nP/Fi2f5SXxFpboFrrx5VCi5D5NABX3UJ1kX1mt6gi0Gc9gl+vO6Ugv297vZUv4eKEEM/OKS0/p
	LrNKtHla102bgpkvaVyzULNOOLvSzZ2xhABvPtmZR2bI8NmapzYfmeO5wSpF83a8I5mu6VyAEwA
	EC69YHO+VoKZxFqxO3MlRoa3QBX8+CsPQIz5Ckcf24MyOGsoyl5V3I4Hc06lGidSFYfNSTrR9J0
	Dik7wva3hDp5lcVUsH576
X-Received: by 2002:a05:6820:6081:b0:688:96d4:61e2 with SMTP id
 006d021491bc7-68a6a5b9d4amr930113eaf.23.1775726089293; Thu, 09 Apr 2026
 02:14:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: asaf meizner <asafmeizner@gmail.com>
Date: Thu, 9 Apr 2026 12:14:37 +0300
X-Gm-Features: AQROBzCsxq-_8cKQ88ZNHhdkHdvFij7oQ7GSHNeEUbzDKe9Qi5RlMNRhL06jJk4
Message-ID: <CAEshK0=S+19B1LbamBaNOKTQyw+98QFBjHs04sByu_JL2QOBAw@mail.gmail.com>
Subject: [BUG] io_uring: 13 remaining unprotected ctx->rings accesses after 61a11cf481272
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
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
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13012-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asafmeizner@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0A9F63C86F5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Jens,

Commit 61a11cf481272 ("io_uring: protect remaining lockless ctx->rings
accesses with RCU") introduced RCU protection for ctx->rings during
ring resize, but at least 13 dereferences were not converted. The
most concerning is fdinfo.c:63 which reads ctx->rings with no lock
and no RCU protection at all.

Unprotected accesses found:

  io_uring/fdinfo.c:63
    struct io_rings *r =3D ctx->rings;
    (no lock, no RCU =E2=80=94 TOCTOU with concurrent resize)

  io_uring/tw.c:41, 253, 291, 326
    atomic_andnot/atomic_or on ctx->rings->sq_flags
    (lines 249-253 have a comment justifying no RCU for
    !DEFER_TASKRUN, but lines 41 and 291 have no such comment
    and appear to be in contexts where resize could race)

  io_uring/sqpoll.c:380, 407, 421
    atomic_or/atomic_andnot on ctx->rings->sq_flags
    (under sqd->lock, but resize takes uring_lock =E2=80=94 different locks=
)

  io_uring/io_uring.c:574, 647, 690, 1985, 1986
    CQ overflow flags and sq_dropped counter

The fdinfo case is the clearest bug: a read of
/proc/<pid>/fdinfo/<fd> concurrent with
IORING_REGISTER_RESIZE_RINGS can dereference a stale ctx->rings
pointer after the old rings are freed via RCU. This is a UAF read
that could leak kernel heap data.

The sqpoll case is also concerning because sqd->lock and uring_lock
are different locks, so the SQPOLL thread can see a stale pointer
during resize.

Minimal fix for fdinfo:

  void io_uring_show_fdinfo(struct io_ring_ctx *ctx)
  {
  -    struct io_rings *r =3D ctx->rings;
  +    struct io_rings *r;
  +    rcu_read_lock();
  +    r =3D rcu_dereference(ctx->rings);
       /* ... use r ... */
  +    rcu_read_unlock();
  }

I haven't written a full patch for all 13 sites because the right
fix depends on whether io_get_rings() or raw rcu_read_lock() is
preferred for each site, and some of the tw.c accesses may be
intentionally unprotected for !DEFER_TASKRUN. Happy to write the
full patch if you can clarify which sites actually need fixing.

Reproducer:
  Thread A: cat /proc/$(pidof target)/fdinfo/$(target_uring_fd)
  Thread B: io_uring_register(fd, IORING_REGISTER_RESIZE_RINGS, ...)

Tested against: current HEAD (7.0-rc series)

Thanks,
Asaf Meizner

