Return-Path: <io-uring+bounces-11922-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEe+NzfKdmkGWgEAu9opvQ
	(envelope-from <io-uring+bounces-11922-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 02:58:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F80083612
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 02:58:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D63763003E83
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 01:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5D71D5CDE;
	Mon, 26 Jan 2026 01:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U5AIdOGp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14821A3178
	for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 01:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769392693; cv=pass; b=KTQRnh6GjV2vEbxeGGKlqeIkH57QyebqW0yIMybxJW3n1DCQzgJzbtVKt+V8RSlY3YBun9QAAUHJlYmNcLMY+yRRQqhxxwRvJf7bTQqAtdZPm4diGlabAgSv3YZqDILbhCJua0Yeu2PXmqOsH8MIZNkQTF0jyO5wg1/LEYPPnD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769392693; c=relaxed/simple;
	bh=ylkRhRWGbu+RaJygBfOuouQ1SJMkZa4aQPoVeazBcWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W9wyMvqnRi2UgpmrFV8w8C7Y5woXYwmTNhRPvYbVRKxDtfCcF10A39yjyxzJgzrYtowxfHI85olC14MfcIm8AS6gYstVJTefjSUMVaE2pGk6Kb6EDdR+6amF3phmVtBEReapAlAgvIwTysQyuTce/4Kf5g97PTd4lWcF21FyNFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U5AIdOGp; arc=pass smtp.client-ip=209.85.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-6580ec94bcdso551834a12.1
        for <io-uring@vger.kernel.org>; Sun, 25 Jan 2026 17:58:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769392690; cv=none;
        d=google.com; s=arc-20240605;
        b=dhaCleEoSZ0xBor5ZKRNLGHawiOHulyCDsb05s+js19lo4aHRu22K1eNf+slUMqWdY
         LjMTUJsEvGU72eo165u0aeYrFSoBat989kx4oHJnxjLXy3wj+u8VPaGJ7sWBmwdjuVYW
         KrONy+GXubsZNTFk0gnN63l/DSpAJHcR13iBqxTWVVdXFRqWBi6wNNTfkj22OG5yoWT/
         G1SuLvPJNFzLFk56Ky16WfZiQGc6Nz6h1rUyjdtctI+81iYmBOaiNj2Gi8ubDp8lQVG3
         dA0m/EeOlF9CxIiKBKYLteSe2ppCC5DWZ0JsmQM7W+qm2bTbwlDwoV+0DEKnmhm0AblZ
         eZoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ylkRhRWGbu+RaJygBfOuouQ1SJMkZa4aQPoVeazBcWo=;
        fh=UjUPYjCyuUY2Mb2LfpQI9V6TSxwVKRTjKeLIVK2k6xw=;
        b=iTXkD+/SCwqvfHWlJgdKWu9owaMqBJz9QJqGCbrr3CaVdnmT7lRqSBRABZBwt5Fotb
         CZ3WiOY/2q520pShfwkpg38/ZRrm7+fNUieHpO0Efr28fMFubMJfN1IQxQX33rLfTeYI
         EkLQiNZ/EfRKYGT97bYKPC5Z4BYNqVYaEwxhMrk09qXqGT87SbtBqcsS4Xr1M4/qnxaB
         W0tI+gPzs5N5EIyr6Ft/bTAOUGmMqGGIb7mRkXDl5nrZbJ/jxCzRuS1FQ/uXWWWVfHs2
         WcxXfhfjHcW0Y4qgPeIZ0Ha5LW5hbNivGkdBtPQs0Bu10cXGw/TA2+HJ16QYe8kL9IE2
         VSag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769392690; x=1769997490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylkRhRWGbu+RaJygBfOuouQ1SJMkZa4aQPoVeazBcWo=;
        b=U5AIdOGp2/pk0AbtqQ+Z0qK5lRCN9mPt1UqBitBcv55c2Avp1waiLw7/18LSnOPtBX
         dkjX+k71pnYMoOS0YgCs3BIZEoZ7VfNklirovJwULZn5cKDUhjkv5pj49INq9FjRKM08
         Yc3A6U3IWY5dDNEFyzT+9zlsuhtGKtLfkBgyKKZTcq1jj6urjmjhhe3Q2Qh+ICm1Qgrm
         Vjqj+OVljkligkc1NCXGU/WGQA49bSgxg9K6t7jzaM/IKjmWie9u3pEFKszDnEaTBds1
         Ba3WtN91RO4PSy2y1gDTT2ush2Jyw9VeZp7Ck8jknV8hmiXTi6bddLRz8ZuX7QCETDHl
         rUsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769392690; x=1769997490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ylkRhRWGbu+RaJygBfOuouQ1SJMkZa4aQPoVeazBcWo=;
        b=MzqEhutRADNthvGemP8VPtsb66feoDP0mQyIR/KAXG1B650nzoiiRpiJbZ4ejg8vVV
         U2oq3MDtgZH8I3sw3iH0c4c6rSo0Icgf19qXqL0jmYgAJiRYa8SR0w8EM5UGqXFJ1blE
         wzN3/709BVU+KCan/6CljLUihw3VYTKjptzkHYImx1NuIb4TMWMBko6BtBkxRQIXHSgq
         sFbiFANd2T3J3qTGzlyOc8XEWIseM7FeVoixx5eOCcPm/PsaD/0Ug4K1KRD/c92Hpipr
         zbkYd/6rEW4aAW4xMAaRtSG9mSv+ifiqy/K2qObLbBoHC527d2jNTR3yfU+P/qql+VLl
         L6Qw==
X-Gm-Message-State: AOJu0Yw/O/IvYOD/SozPwdZPGwuGj6EUs34X8hZov0/YeAJfPwv+q+gJ
	GJ2LTOH/GL0W85kSQvsCc/hz2bGkLxU2cEpFifo1NXxzwS+pXRz9uhN183IiL5VU+Nu3UXVCLtW
	i5KF71fi1diMp+Z0XzQNagn5pDW0mxKo=
X-Gm-Gg: AZuq6aLS2rhHeBKlZQka5DH8acw4QNWB41Y2Vr3MycxNI63Sm2x7d0ehvLyFVLlaJpY
	kYvh00/xu89uAKvus3oLGNYYLADbTAsJVeCwwF0oKrPPNCFFy76BsJEyA3N+LXKpahtIU5NaZCn
	5eO0wDMKowQzAQndbKE2NbusJ56GK3YAVDlx1hDBysfZZQTlIBik0+ENz6qxa/Fv4xxGd9syYmv
	ZusFOWqU6ZFdyWg1xL+oUuTDPJomCeqBGrEnGYVvQEtoAcR1Ki/AVywI8rNEshQTsmSuzQ=
X-Received: by 2002:a05:6402:1ecd:b0:64d:3c91:a40e with SMTP id
 4fb4d7f45d1cf-6587071c5damr1117212a12.5.1769392689946; Sun, 25 Jan 2026
 17:58:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125075302.621785-1-1599101385@qq.com> <cea5285e-061b-4e5e-8c06-82461e8eeb62@kernel.dk>
In-Reply-To: <cea5285e-061b-4e5e-8c06-82461e8eeb62@kernel.dk>
From: clingfei <clf700383@gmail.com>
Date: Mon, 26 Jan 2026 09:57:57 +0800
X-Gm-Features: AZwV_QjVeqCMP2y42w74OhOqiz7WcILKHlLOMnQCXg0q-cI8oNehyDgCFFkBcAI
Message-ID: <CADPKJ-4HUKdt8jgsVWoecBc9qOZQ_4wXkSW8kas9mXVyWt9a+w@mail.gmail.com>
Subject: Re: [PATCH] io_uring: gate personality per opcode to fix TOCTOU check
 in io_msg_ring_prep
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11922-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clf700383@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 2F80083612
X-Rspamd-Action: no action

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2026=E5=B9=B41=E6=9C=8825=E6=97=A5=E5=
=91=A8=E6=97=A5 22:16=E5=86=99=E9=81=93=EF=BC=9A
>
> On 1/25/26 12:53 AM, clingfei wrote:
> > From: Cheng Lingfei <clf700383@gmail.com>
> >
> > Add allow_personality io_issue_def and reject personality use in
> > io_init_req for opcodes that do not permit it. This fixes a TOCTOU
> > window in the prior implementation: userspace could race-update
> > sqe->personality and bypass the __io_msg_ring_prep personality check.
>
> Please do detail what the bug is here, this looks like some kind of
> AI hallucination. The check in msg_ring prep exists just to reject
> commands with it set, for future expansion. The only thing that
> matters is the ordering and use in io_init_req(), which is fine.
>
> --
> Jens Axboe
>
Sorry, I forgot to reply to all in the previous email.

The io_init_req checks sqe->personality; if personality is not zero,
req->creds is initialized based on personality. The msg_ring prep also chec=
ks
sqe->personality and rejects non-zero personality values. However, sqe is
shared between the kernel and userspace. This means a user can submit a
msg_ring SQE with a non-zero personality. After passing the check in
io_init_req, the user process can concurrently modify personality to
set it to 0,
thus enabling it to pass the check in msg_ring prep and invalidating
its rejection
of non-zero `personality` values.

This is not an AI hallucination, and it can be demonstrated by a userspace =
PoC.

