Return-Path: <io-uring+bounces-11163-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CE6AFCC9F4D
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:14:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 088233030FC4
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 01:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7CA24676D;
	Thu, 18 Dec 2025 01:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b="V4YWWV3w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-05.mail-europe.com (mail-05.mail-europe.com [85.9.206.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8431B2459D9;
	Thu, 18 Dec 2025 01:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.206.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766020406; cv=none; b=rFPjdCbok0Mi4/3SSF+t+mzYz5Qp5cXFh8p7YSScVrJ/8SBuGE2EnF6A0d3MqZk5cwKx9zYA9TbQ1oZe+K38BhndIqIeiT/xwOJ7bA3mCz9EGCeX+hN3X1R1rB4MJv6VBbPa71A4KjYE41ck1CZmXaIV3ISJELcaeEQL/j6iwkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766020406; c=relaxed/simple;
	bh=H3XBVi9fjwhg1ippEIPJI/Ouo+SiqyjcmR794bqnsv4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A6s/tBJVyk+MSsB3q7XMQEHBihwAtR7acTqBSKnpDw6Lu/FRNkaArNjMuin7gVfqOUyyVQlR4aCKXtAFxsFEpVLEatVUbrQKKkNJPWrW/qDhCAhdqhBe2Zxm18hjYAevYa2XC38q55FFkEA6tDkSh7xwF6xqQ65NP4q4iVIczzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev; spf=pass smtp.mailfrom=veygax.dev; dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b=V4YWWV3w; arc=none smtp.client-ip=85.9.206.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=veygax.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=veygax.dev;
	s=protonmail; t=1766020393; x=1766279593;
	bh=H3XBVi9fjwhg1ippEIPJI/Ouo+SiqyjcmR794bqnsv4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=V4YWWV3wuEECxAAau16G+wHztwgzg86T3b7XvWg7NmgbeWe7bw24z52v2hg1K1e1n
	 cA7nNvw11OYESMf5DxQ3yklCntHelq9xq75CqnRYqClgqY34uyvKRq+her1SQNE2Pk
	 ttder1yuHqZAGMQbbfELVztPh5A0oTtPYrvPr+9Buk0NlR77r2tOyUWXKwVW9YZwje
	 nS3sRcpipsqXVdajnYceLBHqs5vdOtCEqkOKyQD45KL//F/a38BmkVGcPWMmteEM0n
	 VZNNiGii27QvzDEH6H0oZFwMtdCbaG29wi0ZPygSD9GiBOklmoQdRmfHM/nbnywBaX
	 SKoo+6Ka6LCqA==
Date: Thu, 18 Dec 2025 01:13:11 +0000
To: Keith Busch <kbusch@kernel.org>
From: veygax <veyga@veygax.dev>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Caleb Sander Mateos <csander@purestorage.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in io_buffer_register_bvec
Message-ID: <80a3a680-e42c-4d4e-b613-72385d3f46d5@veygax.dev>
In-Reply-To: <aUNRS1Qiaiqo1scX@kbusch-mbp>
References: <20251217210316.188157-3-veyga@veygax.dev> <aUNLs5g3Qed4tuYs@fedora> <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev> <aUNRS1Qiaiqo1scX@kbusch-mbp>
Feedback-ID: 160365411:user:proton
X-Pm-Message-ID: 7836ee343af64d97c5384f07ce47b11518e3473a
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 18/12/2025 00:56, Keith Busch wrote:
> I believe you're supposed to use the bio_add_page() API rather than open
> code the bvec setup.

True, but I wanted fine control to prove my theory

--=20
- Evan Lambert / veygax



