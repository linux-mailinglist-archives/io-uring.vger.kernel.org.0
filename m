Return-Path: <io-uring+bounces-12349-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id lqZUBShpmGnkIAMAu9opvQ
	(envelope-from <io-uring+bounces-12349-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 15:01:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B37F61681C8
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 15:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 38F99301ABB7
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 14:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6D3327BF8;
	Fri, 20 Feb 2026 14:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hU7fIfBZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930083EBF39
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771596063; cv=pass; b=UGvyzmmxUOtk1pytf+jhBgsOiM5fv+6Hfxj0BCKuHmd2GaMjcTSnO25sDCiwfufahqsnTjGVWtKuci5d0HEtNgJtbI7gk3kJQMrYDWIuPgQHJKs9rji7t8iyzO8uHY9TFp6j+khxIc2J1Hv2YM31LczpvvlMBSCj9QldDXVUAjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771596063; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mKKXOo6qA12DG49SzH0A7rYTK+9nbO0iLXHrpInZZTr5UIQwlNyQQAuwYiHrMeVzteYDH4lqGloQ+n02m/4Rdo+A7jFrawLIocF/ggdIsjHFe+IpkzKDvYx1MgVZVrg6kurzm3ggV+sqmUkcwd7hZcN7ytWsF4/mNssYKJb5CZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hU7fIfBZ; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8f9568e074so398278466b.0
        for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 06:01:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771596061; cv=none;
        d=google.com; s=arc-20240605;
        b=S3o/sIegQgiZM26X2+Fany9kqeBf6aonbB2cHBhafd3a6lFl4rDCHZuq3aF2ReW8mV
         DAd64a495nKRnR241XDsOofH9brVfqgLQ3gElfTZAWY2T7a0rFbgGjmpxIMTXJBoJLKL
         nBT71IdMf8eZFZa+48qERSFKLdAu+jq3iRNuMDoUSkc0GenAP+Hm3B/tDftq10LKl5sm
         cHWCFbu5ySgdosSdHsnRJXRNUlGpWsM8AR6Y2caqsz9/SaPOB7S/D+Fv4aw1MXpu8lkt
         /IufQLzXFsPVzxW3Pm/7JqnZhAkGGdUtfBd3DKepoy78TaVxqaoq6XjV9LDHM+rYM/Uv
         7jwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=JCbZuidtfNWkGMJ82F6ewCUfoaSBOvProuw33K0OpcU=;
        b=ChYVwq87ZNHBsEbseTzToQwdmqcrKKIF/12Op+NxX4w0zwkgV5uE7vXr3BDm5Bvka1
         C4/owMHNcMFYY4LT2FS/ZxzpPR/YPD9EGPN7W/c8f306wUpt5IEwjcsjamy0P5khK/Ga
         KlxJG2Wl9hROuWf/s4P1qCS1L7TWM7MYpjSUl2ZYBQtoNtLex7zye2c6MqWSMcAUvIhv
         NOfkxNkWdSYBSoiKflH851K+6O//IfyEW4K/NwpUM1bcw2l1zXhgawgo1VIeVWLHEHgA
         WeJOQqBMTPGyj/HHM+5sIFSUE+R6BhKMHul+ENctirL/8IfMnJBNsBePL8XVFJe5KUNm
         OmvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771596061; x=1772200861; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=hU7fIfBZBT4wUI+TtlspPrpguGV5FLWodQgrFtGS+/PIoFT/uga479mzMbXDktYUnb
         lNpm6gOsjhlrWHTniE2Ilo9ldaDqvteFKaL4FKPqjqX2HqLdyTMI+Ht6WLLQdTPJHK+j
         fPE1w4r3NoIwmUdXiX2PAT4QbcZq8KiL3dJ0qHVViGFRBkR/cb7xE9d98FeA3EQH48aB
         Qo1p0/ZYu6VgBouoc8I3+LwkWPjD31c5idoH3EMliOQyvxMW5vYmYlcc2MDu1NuWPLHr
         fTtGYn3IRXE5UQEpoWY9vV4Aazbv7fvKsaXp2kGJtmkWOSTNWnIRChI5tTPLUIcaoaj8
         B5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771596061; x=1772200861;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=HsoTbh5QxKl65yI5ksxjfg1wE3KTwj5CPYLJ60mwSNambu17260dVQjQL6R26hlMIV
         ZVQuJX3Elb4H+AxpmYJx+S4JBGBdLz/8/Mv2SfmBSHkvtzyTC2VQaDFNwMfgn9pI4/BP
         zkgIEEfrTyjT8s2vgO2NbDXYWYXuNrUbf1uChtd5tmMO0DwufY1zqBD0hHIUsqOTRuv1
         il4IBHvjI2t/Z/rdwL9aKsioAiMvECo1RC6dKyaDA/jmdIdGskEBp1aqBb28ZWVSn++C
         qa2C8gaGY9USNj1K8GzdWQ8BeTMi4ETW0UcwK1WZMuAQ+c65OYEAfZhS0304nGC7Q4Oo
         uy6A==
X-Forwarded-Encrypted: i=1; AJvYcCVdlNDIw9UZ5I4oYKDspslxCEf/0YLCQ+R6xppskmmAVmRJeQk1g3FzEG6rFXpDnzSj8KdxrGzx0g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwzmDxwyLEpVDeduo5VUsoMETSqLbJeGX2LJezZKbexSzt5RRjF
	xosQdPxPG91qrnxdQ3nyiFXqJ2c6vCkMQf8HCDo/qEmsEsUkuhg+T4unAe08c/SGBftgXSnRaO0
	x5Cu9naK9yVTnGZtdjywRwMtY8seGYg==
X-Gm-Gg: AZuq6aIB71nXOv+gr0NHUnG0g2sOS5lu7ktsaaU92E/YhR/rVDgdJB5HzSxNbju7AeD
	44xYqgy7+VsJ9J7teapB8jXT5XSM0Yhq+iaG5F8YgTtuemJZ9GOV861Htn+VbGjzRGuBLKrGPnZ
	pahiZkDeEmkkCwNHJOI0CX7Z3N7rFVGXiAY0x8TqjTXBRnipUbt31oUrGOh9XdniFn13zFPeA6z
	+lI9y0CAJzwa1yTs2eWCcVS/3qkM+z0RXa9tBCEFD4uYloNPIKKBfg3xDsLu12gDJL7vf15f4av
	RN02sfokSH/WyQWa5LZ+fCxyi2ea3M4ufs3kJbuACl6WgrEG5tO1h9Q5lDZP1MwtO9ExmA==
X-Received: by 2002:a17:906:2083:b0:b90:771b:ceb7 with SMTP id
 a640c23a62f3a-b90771bd354mr75534866b.27.1771596060364; Fri, 20 Feb 2026
 06:01:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219172228.429479-1-csander@purestorage.com>
In-Reply-To: <20260219172228.429479-1-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 20 Feb 2026 19:30:23 +0530
X-Gm-Features: AaiRm52mvs-aOVGGrqp8lgGC97YH_yfaGgyVC_GHRYK1kiT8xDbzNAyi-S50V3g
Message-ID: <CACzX3AuPPOZdidqoDE0TvPChEXcNpKRFGgX6FZskOnr6f=eXuQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12349-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RSPAMD_URIBL_FAIL(0.00)[samsung.com:query timed out];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anuj1072538@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	SINGLE_SHORT_PART(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: B37F61681C8
X-Rspamd-Action: no action

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

