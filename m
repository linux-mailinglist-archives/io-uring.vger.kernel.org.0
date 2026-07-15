Return-Path: <io-uring+bounces-14025-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 67CaFyKFV2qBWAAAu9opvQ
	(envelope-from <io-uring+bounces-14025-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 15:03:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ABDCC75E6E1
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 15:03:29 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qrSF4oP4;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14025-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-14025-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D62A630C3331
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 13:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E69F47D92B;
	Wed, 15 Jul 2026 12:54:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C739647D93A
	for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 12:54:07 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784120049; cv=pass; b=rL5WFLt0MASd9YQwaL/yX+54DaHkzezhwMeOWQAszf8ym7ey9uO/m0URc3iJ1+N1mwu4N3pwHG0I3LtRaVnqj46oWi0iD0z/rgWrJhEqzGt8ct25EBGkVMDN83gR8l/uusVjGR59/jvhLTkd2sXczFxtDi7eOPBOPeccgINUVpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784120049; c=relaxed/simple;
	bh=em1N3E/WTG6TYKt1hKLZLg4BVzT79CC6h9GgUGkGOTQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lvUB4IgPkczhivZQxXpa3S6IM+QNG3fJrUUkpG9t5YaUvCImUqF83MzllmguSnk7cGVAauEBS/mrIJ67Ltj/ZBJ1a6CpNIQ0Rv4yNIdblaaUuxyT+s02TFo8sh/UffYMU2E98E44FFooU+IeogJ5CsvWsy4DLkTlLPLUPbWx3Sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qrSF4oP4; arc=pass smtp.client-ip=209.85.216.53
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-383cb94f742so4991673a91.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 05:54:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784120047; cv=none;
        d=google.com; s=arc-20260327;
        b=h/vRJX5/EK+zNgy64koh+suUfNcL9j57XGjKWY4AFpaxVKK6N5PWFN6V8/vhzaEaB/
         /VpDn5AnqAxgDARztGrUzb8U/WoTBQJhnEQwu+ZjbGPDpnHerJQ0d1YS8F+vNkB57dXn
         sdBj50AJloDsNxED28JkkeveLEnuVI1fqRSkVIS+fmc3ls0BnD8ali8ZwzNEFu/16L42
         klRhWs6QKCKPxeBBGeQ2f3WCbe95mJ/SuMOub3/I9dldgzOM78MreUXm04XuEhiiTp5p
         bXOUeqsbh6cqGanYglW0aFyvCvwnlbYn5v4rWat6xEc9tp+kCxWsym4CAFeZ/dVfIHuT
         K1DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=em1N3E/WTG6TYKt1hKLZLg4BVzT79CC6h9GgUGkGOTQ=;
        fh=n0IdOG5rm/7dblKWBT9gb5kXEZfjQeycwKp9VtucOyg=;
        b=qmk2GXNKt8+1YJCgZpPJ2eBn5KZMsIzzteDGPZOLV0+oXzgEWt7LJ366vwJHpOo2Xq
         sVLeYAKuBl5Hmh53Nbp7ZEZCv2VemJ5kKLwpMNQ6xrp78HTVyL1NJaoVVUqmH5wYsQgv
         XTOsBCTkE5TdDmtSRFiarinDCSn128/AEEjconif/FB5w8OHh35H3fbDx5568fXFhTGP
         ri7eGnc0O2rgcyNOavZhDIsQQp9qre39mBYQ7X+6cw7B22CUX1TlHYjoTdmB3J5dPU++
         eUuVlflHptKNuS20Tw6DZHTyuFVRl9OWWoJkGBF2mEsM0fxerESTFRNxqXC8KUTN7UZL
         lTgw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784120047; x=1784724847; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=em1N3E/WTG6TYKt1hKLZLg4BVzT79CC6h9GgUGkGOTQ=;
        b=qrSF4oP4bcrvEBynZseumGXxggZV3Btn/fY3AvyQcVu2G5gmxDCdc7sQRddO+nw7VS
         P+iSQlQSPUJBFEFyt2n2Ddoqmv3Be8p6asRfFOg9X5rHcuHwgwP9oCtEBt2C25eVrztb
         t4Ob4l3NxgUopgeMk6MYwvRpGsNL1DSUwEuZ03RFWsVmpxMH5gLqMj2ZztOw5O+SAKi3
         Nz+WZsSBPCLfgPKhlxjWmio2skwky5cHDTswCZ2Z/2J97A+G5lCqYTO87RqHLfCfJRhQ
         7sgcfLmNAOjKDpbIDyGLa4IxfPjFmYuqBwjyfoQoIcBuCqjjEEDhvx9aEOE5/830UY6N
         XP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784120047; x=1784724847;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=em1N3E/WTG6TYKt1hKLZLg4BVzT79CC6h9GgUGkGOTQ=;
        b=M8G9t6c74VRv/OaNQgxHqJPZRuu0mOm/EyhM9aZo7+tk6BDRZRVN1zCZOyHg6OSlJD
         q6++UWymS0kK0giYWqSEBUQnz/14nfeLwfeRtlrnY+4LQm0RqHHGk5iwJKWmp+LsBhGO
         zvtFiD+CWtscfAg0CPmNviDOwBHY+Qvrr24rATtKjtXU4vRw/wG7JzMFq27EzTWuNJup
         zJMlJhnJlCteIyjX62KqLScNUjsWTrNvdfhxp8W2aSF9RKsUyEGFiCpqHHZLHfOEKT1Y
         DFsxiCbHMGjEj58wC1rBjmZUpxKx4pMj9TESjfDRWAEOvV2pRgxHFCFGBrZu0ow5BxjK
         ED6Q==
X-Forwarded-Encrypted: i=1; AHgh+RqiPTcrZWjlDrQ7RaGE4hWBNQQWhdTAM6iD3zA9EHstRCbtwHdtlxPXRG5aw1Yq19o/vLt5P30BnA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfrD52EsN4Y7e7gOpK+Ld2v1FQnACHeWEZLcyk4xIMOkI3Ryn/
	YkIGs8/oio1MBx1jpUjfC/HiryhRA8L0/c3l1MdpNVdEGXQgow7Y3Aci3B9Czn/VAhLjcWKSi2t
	rB5CYo/H3+dvZtApu3bHy6Z+3f3DUIolg1Am2
X-Gm-Gg: AfdE7clnQHE8wO4fXJds9jM3SdVg4EGrMGkz/IKEcWI7pMfHUFUmMYsxMqaAFOGDzor
	zKeniU+9HWUF/LbUnfuN9q+2AtnKP3J2b0s6/HTvrLLeJ7F0vJDaC+h+yHvbzq7uqWJE1KBiruI
	Pzpy10ZnQ47HEyfGoxwwUw8Qs9gD5mvYm9w2ZL9eB1NGaFoNoPNb5EYnj5/4no6yfVLiXkOHcT+
	e1lpulnrhFPAfG2QCAnHjnHDhLnkV1HVYL8kw4M36V3+CjZ4KqQjzs/SoIzZQqvcICUkT5rYCED
	VNN0uhdeUHhdHcnUJPUdVDTZ8m38MA==
X-Received: by 2002:a17:90b:1652:b0:381:6466:7160 with SMTP id
 98e67ed59e1d1-38e2a0c33c5mr2314053a91.26.1784120046938; Wed, 15 Jul 2026
 05:54:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624073921.11037-1-harshal24.chavan@gmail.com>
 <20260624124019.4521-1-harshal24.chavan@gmail.com> <87fr2auzq3.fsf@mailhost.krisman.be>
 <CADCAkb6wuR7vT3chfFtBL0qma+gx-2mJM7v+JJLS00W3oyb5dg@mail.gmail.com>
In-Reply-To: <CADCAkb6wuR7vT3chfFtBL0qma+gx-2mJM7v+JJLS00W3oyb5dg@mail.gmail.com>
From: Harshal Chavan <harshal24.chavan@gmail.com>
Date: Wed, 15 Jul 2026 18:23:55 +0530
X-Gm-Features: AUfX_mx4Pt1vuEloSH-b7zneRHe1DCEtLnRCsohGnflYfyu-JmuWdQPLSoehD6c
Message-ID: <CADCAkb63_kAa0b09GAQApBqi9-oUR03beQajkSMKL6Q4bkpWWg@mail.gmail.com>
Subject: Re: [PATCH v6] io_uring/register: add IORING_REGISTER_CLONE_FILES opcode
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, gregkh@linuxfoundation.org, gustavoars@kernel.org, 
	io-uring@vger.kernel.org, kees@kernel.org, linux-hardening@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14025-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:krisman@suse.de,m:axboe@kernel.dk,m:gregkh@linuxfoundation.org,m:gustavoars@kernel.org,m:io-uring@vger.kernel.org,m:kees@kernel.org,m:linux-hardening@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: ABDCC75E6E1
X-Rspamd-Action: no action

Hello Jens,
Just a gentle ping on this patch. Gabriel has reviewed the recent
changes, and asked me to wait for your review, so we can batch it with
your review of the overall approach.
Thanks,
Harshal

