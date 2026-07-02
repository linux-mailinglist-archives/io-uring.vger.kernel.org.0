Return-Path: <io-uring+bounces-13876-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id fjXoIe2tRmrrbQsAu9opvQ
	(envelope-from <io-uring+bounces-13876-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 20:29:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1036FC0A3
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 20:29:00 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b="P63wksr/";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13876-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13876-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 82E6D3188CE9
	for <lists+io-uring@lfdr.de>; Thu,  2 Jul 2026 17:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0920034B183;
	Thu,  2 Jul 2026 17:43:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED46181334
	for <io-uring@vger.kernel.org>; Thu,  2 Jul 2026 17:43:27 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783014208; cv=pass; b=APTz0WN18SO+GZOfcMw3QycJZJupBObbWm8AJ72ZV3nqVKeNnxMy898Ei9+piONHBKAQ91xTJUZTjMolIpJgbs7HjqNMR0wr38zg3C9/yibbgojkvz8CmcUD5PBtycwl6OXyXl9iUl6UgFgBIiA0xxblN7aDQRKnD9vZpmi7F70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783014208; c=relaxed/simple;
	bh=xysqAxtMUE0jE721yfSL18mFiREUPhoj8c2wpM+qgM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l257iSYYGLjy7BgJuaH2Iy/NUnv6iPc8kc+Hx+NsVgyb+jhaUIyse3z6RrTYcKyzFNxdau5sQvJd0+sqaooHcHgfKVMVunJtsTjlDvD5Uf/Vhfzntr/Zh1PuaMkGZDK28j7ShytkKH8JAClGnDfetoch3uiyAh015glZMpiD1a8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=P63wksr/; arc=pass smtp.client-ip=209.85.210.45
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7e9ec26b85dso250476a34.2
        for <io-uring@vger.kernel.org>; Thu, 02 Jul 2026 10:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783014206; cv=none;
        d=google.com; s=arc-20260327;
        b=oSnUcvz6KQ84goAW6eSQ+vrZpB6eMbXXPdbjgCOGSOCjzINf5yfpQhS85FBoV3m2zj
         uV5QicL1iBvGRo9VUM/RhW1jWo6r4LXg0QxIsGbsOOHySTuIha/pIjYkwzcFr7RZAVY/
         aH5NCzTQ1hq3HbgKTrFIzvaqB/QwL+OUKHmYAgDZs5976ns4rqy8c1qtVm+jy0nEWwW8
         vfeJDyZJG2pIQx2a3YJ2SwOlM/3bs2Mjm7XtNVqNBp4MnyrV14uJgZbHSnlPPLi+AHEa
         /Ez7+kuLGqbGavZ6p3hLrXapklNu+IWR97A4dv0W6+6dFmK19+rXpMnLjLtugwNGRT+B
         pTSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ihostLuk2MRMN1N7TPsgfS+tXZ3aTBctmLyR/H3ZpEE=;
        fh=qN+hQU+3pu1pRjKYpKfVo9zQ5VuEGfuqJ5wUMlbrvDg=;
        b=MWvJ85QOMyXIE2ngktxPlppmDUMA7WPzz/c/h9S5xxNbQnqWT+NCG1ehBamXtmyyf9
         IlUe4jIFUK4Tus9p10HjIw69RXxt85yvDZfSX23uADoacsDXngcV31biW/XplPaBN9s6
         SdDrviI+jCQF3BQCCrPgoXiL7GVkJKxUkzS1ViPQ8pRKraNl/e28K9TNeL1ngnJgg86p
         9sUwIQAbHKsEB6tpBauPwrXP447YHVhrc2V8oEVCV3Ap7gbH9ec4rNNv6j7ISzstT4jQ
         OwKt0X0nfdvkcR3NPWyDgBmuqh+pqHSpT8LsSw8aSu1jQost2iBrSBsrvHcElxoaZcRW
         J2Aw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1783014206; x=1783619006; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ihostLuk2MRMN1N7TPsgfS+tXZ3aTBctmLyR/H3ZpEE=;
        b=P63wksr/UirV776n4WcugaTsGqZrOiBwY/CjIIFuv10D2thH4O8W0wh1JodrKobD9K
         Xeg0IZIVQBVyqdZpTNo7rFOuCFMalADPOpSywq66Xo1inUa2nLrkE3gPDDSlRCOxRhsr
         mtos8fpNnyWEdl/QIKG0wrko2UG/Yun9Nn8gw3RS3gnUNbv+8W7Lw3NXf4Z08eI8FulU
         txd9D0/vN9zHr4TWKDuznNqyZ/UU4OQeazY/ojN73KUn+ZzF72zcFBMXqtRzkWk4sWXN
         Zth8xqELZNpDFlxhS2ZKj+tLEEYO/xzPkUtCMcHMRghbPkfHN1b9r0C2Gc6qX9stGnYg
         Ft1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783014206; x=1783619006;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ihostLuk2MRMN1N7TPsgfS+tXZ3aTBctmLyR/H3ZpEE=;
        b=dednu6aRzd0xEtHCWIlSsEZFE0pCS3ZDQ4wuhyP4QpZvpgaRphgRZASRzlisyPIHIR
         Sex42g/4dZS1E0KjzxRLSZuEvjSipQqhZxROVGmlDFKqC5FnguP9cYfJ35UNDguvOaaQ
         boTlTQozDpElcT1VDRb49Uv+V18Xl/6sMOwGwV7arlU/kUo3OnM6+9ehaNZatIdVoH3K
         wCfdtuFQcxJqDdSgPrs2d8PKOqEapliFAC8oDUj9H3k+AEk1Ip3Lpwdq2MTtSLWeF/0s
         v/p/rw2Z1HlomGAQGsCRZmHNfi+Nx5eNCcbBSQ7HsXnXnI8vi8UtTzDy4wQNiAGY8neu
         06Sg==
X-Forwarded-Encrypted: i=1; AFNElJ/DV+Mc9tjv9fmUv3xIjmAEaR/kgHuQic/neChq3FTHQ5YWYHoSvNDyEqBEtIMcv+NdF/KjeIIFEg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo6cKM34rFzVqNspBQQQyFs6D4fFXvjus9x1hXVlzsIrlKPRZb
	8uymdXV06O9mu09CKnPzg4ZND+7a7To/SqhNqse9FXH4DdK62LSIpmx0R2Y4WRXIabt3DX4y/SL
	lDWKvqY/+Nqm9XQFVu1xCopQS8QvTyyTYK+BlEp+r4Q==
X-Gm-Gg: AfdE7cm7mq1C8T4/gBlCEi3XAtwZIxXk2ozMdMnLtWSiIF/f6qKnJgQKwrBXBWhjQl6
	ywiBCmoPHb0x/Z2k52QGCZMZouHv/B7UM9jgTkF0J+w6AvKyHYwWRn1947FXPIVESGU7EHpKZvR
	F9bfCCG05AODZUFd/kKM68LZ18oGHkmN+7PSiMYFrVFcPMKZ7zSiD+O6cfQk1fJGxwv8X4NW4QT
	x9ZbZXnJOgrU8dCxTgTnhsbnX//bbE6ja7W4e14I1hNOFe4onBQky00u2/+64uColOatFxA7Q==
X-Received: by 2002:a05:6830:6d48:b0:7e9:a13a:ac86 with SMTP id
 46e09a7af769-7eb4cc3d163mr2920241a34.4.1783014206128; Thu, 02 Jul 2026
 10:43:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702082937.3707134-1-yangxiuwei@kylinos.cn> <20260702082937.3707134-2-yangxiuwei@kylinos.cn>
In-Reply-To: <20260702082937.3707134-2-yangxiuwei@kylinos.cn>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 2 Jul 2026 10:43:14 -0700
X-Gm-Features: AVVi8CcBfFZ2ukGyICHJXiUa-nq1bGcr3ee6p1AH9mn3r7DumUVx6OEaFtIqrCo
Message-ID: <CADUfDZqMpc5PCai9ZeUJQCJ++Cd3PszkDxyVu6WUMBKqwu1boQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/uring_cmd: copy SQE before issue_blocking punt
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13876-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:yangxiuwei@kylinos.cn,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kylinos.cn:email,mail.gmail.com:mid,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: BF1036FC0A3

On Thu, Jul 2, 2026 at 1:41=E2=80=AFAM Yang Xiuwei <yangxiuwei@kylinos.cn> =
wrote:
>
> io_uring_cmd_issue_blocking() punts to io-wq without copying the SQE
> off the submission queue, unlike the -EAGAIN and fallback paths. Copy
> the SQE into async data before queuing the work.

Add a Fixes tag?
Fixes: ecf47d452ced ("io_uring/uring_cmd: implement ->sqe_copy() to
avoid unnecessary copies")

>
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> ---
>  io_uring/uring_cmd.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 7b25dcd9d05f..fe32311b2e51 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -326,6 +326,10 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd=
 *ioucmd)
>  {
>         struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
>
> +       if (!(req->flags & REQ_F_SQE_COPIED)) {
> +               io_uring_cmd_sqe_copy(req);
> +               req->flags |=3D REQ_F_SQE_COPIED;

Isn't this too late to copy the SQE? io_uring_cmd_issue_blocking() is
called from the blk_cmd_complete() task work, which is already
asynchronous with respect to the submission. So the kernel will
already returned the SQ slot to userspace.

Best,
Caleb

> +       }
>         io_req_queue_iowq(req);
>  }
>
> --
> 2.25.1
>
>

