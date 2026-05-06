Return-Path: <io-uring+bounces-13247-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MGUwMOMf+2kgWwMAu9opvQ
	(envelope-from <io-uring+bounces-13247-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 13:02:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F4D84D991D
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 13:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 599C13061AF4
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2026 11:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC3735294E;
	Wed,  6 May 2026 11:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYMe4wyo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37EC4266B1
	for <io-uring@vger.kernel.org>; Wed,  6 May 2026 11:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778065322; cv=pass; b=q6GRNDQUmusiTRCM2TKkPElhwRAjLASkfLCIrz8RmLKCp9xsyoXtKVHPr4ur1F7TmMD1AK1L9NaBxPKJl9OHruFRMhJkv1Aio8ecTsAjDTqJgQmLfoxfEuIiZgQI9oeA9vm+ZAC9Cimh47/hpP8TLowIWNzOB+8sCFEZ151JqCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778065322; c=relaxed/simple;
	bh=2W4xc01OCZSjdezljbpq6wDdaWMKQzCAB3GE8z39gtY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ydjk1G9toU62EvyNckeyx1ECnA7JWTkdJ5lwp8BLOCfHcZ/8dzqQWVN94E2EEEYfcWVMJlYSPJbq8cLE66Zd0X4XFujpMMsUA2o/toI2YAknZIk1xLoYhY19xX7fhrbLIutfMPnH359yEW3d5wjabPIq8RitsHKSg5pHgTJEDcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYMe4wyo; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso7671205e9.1
        for <io-uring@vger.kernel.org>; Wed, 06 May 2026 04:02:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778065319; cv=none;
        d=google.com; s=arc-20240605;
        b=iMDzvko6H/JYhzk62VotSxsVFydlxHD70ppVV/IhN8J8Yn+Q4WoiI3WCTcBsoQ0gUf
         PZ0aYzaH6d6gjesJw+/iUpgt5Qev5VTP+19E4eJHw/39RAXmWFqxzXRUesSICMhTiuTa
         uM7+iCmfCc/ZbyUfx8JDupxKPzDlojmalde1lLikdQ7UrDSyKluRrK/tM1feMf5YRPQQ
         qjK/dWcUX4LkA7BFuO2t0o3ODMUxJp4tjtdz5tTpKVglfbwCDbLTDtllhwS6z1tFfRYM
         YUHovJKJw3WJD73jvEv8L21yqHFLXSSy7v+fP1DBYmo7ddew60X+YQ4zuf7U8IK/MJoi
         BwdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2W4xc01OCZSjdezljbpq6wDdaWMKQzCAB3GE8z39gtY=;
        fh=579UN2cuQUhyB60fSFS27oPzPqCGaKcGfm7nCxJPMTo=;
        b=HgAsNc9o168uAT0LXPs4fnF8fpQOzzAcjzf9DU+jzoc1VSqUkrHXraTFUGrVU6eaRL
         4J0vwWG6Luh3TxSsIdYsqscnSX0rsV95ix1jiN7ivGzJW0W1UeVRJlybCbEQ1MZJQH4K
         XdbuJ2JvULbaPHUja3pKuXFQ8NtUscGJNe2O8n9FKqY7ZZAqc5zOvRQpjC+AyEEeQc6H
         BcGONRnZ7Mn4UZLUeM/fYYULkMY5IH12blRczeF8BiEZqquEBNjEUDBuXdzA9F8xKYJv
         +RLD0oMpUvzaHByW7JbCgTK83pWsa64YebLhANSrFuxhQbU8G21fzplMUfv3iUFjvyU2
         JsWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778065319; x=1778670119; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2W4xc01OCZSjdezljbpq6wDdaWMKQzCAB3GE8z39gtY=;
        b=lYMe4wyo3yFLsNgaLsfvHOYriQjWY1Z8f0PQGvBGgtKNhlyMArpr/fY791x1ArmZFz
         SKDlEDeJDzn2picIbiZL0hX+XOJyYqxaWl65QbBifTuEZjUJ//PnHRo01sAoCZDO7baQ
         HeDEYlT/Ev0IJJBBPurGQLFzG6Ozsc1aZs3FK3YQXHWczrxOB9lFORm4FgX+pJFoapTd
         V1LPPimtHt7WaKKGftG0S69m3Jow+US1xE6ttgct79ucoZojRkucTkYln7uH7+JD06ko
         mcAj7dmP3joo4J9WizovWA52dkkCRM+iAiL1LrqdI2kHZOSUgs3Lp8kk6+0zWH2EH6cZ
         Qc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778065319; x=1778670119;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2W4xc01OCZSjdezljbpq6wDdaWMKQzCAB3GE8z39gtY=;
        b=jYX1eLsK24oMQSw+EPnSGlktrRv+QSFonQAEzlQfVAiB+zlvafQFq3JVBOp9eHoO/d
         YXY6Yy5tm1uP9sk+Ozc8TlviUDEPZYqgFRnfmKG8K5oe+4oD4aCepb+Fd8XmtwPQqnFL
         1gGCg7m2UCFdh0q3Rdxg9N+CQqzanLsAlwkA7SZMEymZT+gR/a6xKvnYCVQp1oyTG33k
         tpHSQ0IX5T0/ouQw2SmHOJ+wKmH58r162dH41NvIHbAIom/i72Tq+FdCgVFlhtNMce8D
         FdMngPd2gb01sA0bUZBdFwpypwbe5lHL8pty+I4ndmIDBd250gSgWzStTL4mN3e0Jkyr
         0jSg==
X-Forwarded-Encrypted: i=1; AFNElJ9enfYgXqwN4ZpJlq2jgCf+Hs6aWmG5ypC8ZN0DKk8xRlJ9SK/bNcH98rcJKFXnqWE1+Btz6ELnFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyY95MUVUuAb2FVFcy5xW6KZLXELmmWNUa6NTF1DyeZKnyuh4kH
	B4+y0G4U0NzcS5SxxqTqcwHJOtptRQWkQRG51A8EURHV9+yQO/hLPsmab68LBYeggsnG+beRCYk
	Us6heLW4nBRCgANPEP3xB0ee9Zh0sQyc=
X-Gm-Gg: AeBDieuGHpSPZH5yDsiacm3US28QzSNXK7XNEeCk/4ldII5vmtfw9a7YtLO3tlyC5UP
	ECI0brmlQ/poIz/7GYJLCoDVTufeF6SNLsBRRUx5ySxMh/jdRmsggWfxN7yTBIJFY36dtrhfgtJ
	kX7k7WDCG990E51vau2WkUUsh7eB8Ju8JhH5DzibiTQzUMZIr0ofY71mFT10VoFSNgX7gnwx/4l
	fa2zubWSO9hODzo7cRqHsDaEq8oqU2NhhCaxwBnq+HduT4PKTidBF49hAGr3NKsJmIamKxKJ7OO
	D1+1mS9Jwlg3Qj0crA==
X-Received: by 2002:a05:600c:821a:b0:48a:79d8:a8d6 with SMTP id
 5b1f17b1804b1-48e52286b5dmr39571025e9.7.1778065319047; Wed, 06 May 2026
 04:01:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260504153755.1293932-1-maoyi.xie@ntu.edu.sg> <c2d26c6e-c064-4e6d-a1e2-69e84b867ba8@gmail.com>
In-Reply-To: <c2d26c6e-c064-4e6d-a1e2-69e84b867ba8@gmail.com>
From: Maoyi Xie <maoyixie.tju@gmail.com>
Date: Wed, 6 May 2026 19:01:47 +0800
X-Gm-Features: AVHnY4IKexqiQduQw4iAq6u7IzS2_J2CCmVeN3wZwyMAYQytytSkpzVlww5TCTo
Message-ID: <CAHPEe=GvCTUh2S29S2Hzjf_orh8bYJgO4B0gMkFrncM2GcdyFA@mail.gmail.com>
Subject: Re: [PATCH 0/2] io_uring: honour submitter's time namespace for ABS timeouts
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5F4D84D991D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13247-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyixietju@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,maoyixie.com:url]

Hi Pavel,

Thanks for the look. We will turn the reproducers into a
liburing test and send it shortly.

The current shape is two minimal C programs. Each forks into
a fresh user namespace plus time namespace with a -10s
monotonic offset. The child submits either IORING_OP_TIMEOUT
or io_uring_enter with IORING_ENTER_ABS_TIMER and a deadline
of now + 1s. The test asserts the call returns after the
expected ~1000ms rather than after <1ms.

We will reshape that into a single liburing test that
exercises both paths. The test will gate the unshare on
CLONE_NEWUSER | CLONE_NEWTIME availability so it skips
gracefully on kernels without time namespace support. It
will use the standard t_* helpers.

Maoyi
Nanyang Technological University
https://maoyixie.com/

