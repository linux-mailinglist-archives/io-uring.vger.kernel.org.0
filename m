Return-Path: <io-uring+bounces-13742-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ohExMZyXMGpJUwUAu9opvQ
	(envelope-from <io-uring+bounces-13742-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 02:23:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D9D68AE9D
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 02:23:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=CdoWi18N;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13742-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13742-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 89B513115333
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 00:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215CD233935;
	Tue, 16 Jun 2026 00:22:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AFD2475F7
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 00:22:23 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781569345; cv=pass; b=ZU+6l8uf+4l8soRl5ZWQFrFs1MSDsHjdM80fOYCkwNE1esZKfwtk5n8o7ShWIBjrYKQR/B1XAZfk58nYerCyfEGuJwBGCErs43at2Qg6lpoW7x81pilzR47zpL4nj+TL0oOQtcKyY129XvuAtogeEE9w8gChoNJUPaLQBt4zyT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781569345; c=relaxed/simple;
	bh=lIxNUnxAWr+zF+J4Gse5fX6OsChQWAdMhONlELLnUxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gkM2NluZNl7ffCr4s3+ItQgGHBBcau5EBcA17U0lBxO9JZitRpXbfF35QjiTZBSgfZq+IkTj4WIdR98em0LHrHtEkrMbkhqdjc+EMncIb/fB+2peqNUlIcHVAMN6fUqfAhZCDPYCRra/Wsnclharf1pg0dcv2XlqAoIChh6eNek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=CdoWi18N; arc=pass smtp.client-ip=209.85.160.52
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-43bf3ed9619so439866fac.3
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 17:22:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781569342; cv=none;
        d=google.com; s=arc-20240605;
        b=hyeS5m6jBItVlihrjBOz2Sjx1+7KXyR5E26m3i1FaOVp+LMNQdgxLPgCeRmUOc0hkp
         hwfvg7whu852WQUFqTUhKl3+3aOIAxlkSGoW0xHdwiEso0bcj0G4PGa07cfskjBbX5D0
         JoLEoC8y4wvaJROFRp3xiOnEAxGYs7WyNDPVo6OqhhnVdQTBr8EZyp95K4nCCWMZaBec
         qGv3tynXWEkjjROXCLOfCHzMbJvuOFSON7EVi7Mq3AIhQBrGbPL9Mg/gdG7Nhiplm/LO
         3YeNwOzDvB3dCzm3ssTYIQkRu4vE0iTFgoSdaKFOMnMQsXbqhhIIUpg/zGRrkR6pYjLk
         EjDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L8gr1eJMXQLaXN7ksW6LDLSAee3NnDxV8RbIe+nSKBQ=;
        fh=tcB1jbK5Mfh49jFaBDMFCl5E4RG50sbZDH32oaESUuc=;
        b=GrBl2rmgsNrVFf+rqOejVZ6vpXm9YU4P8b6J3gGif8op9hSeEcF+XutQ1db5Rf9r08
         2X5wu+TJzb2U/lYpJ5OuHuYtlMU2s+heiZY89AZLbQvWnHoyGs+e9oDeokdmgjqPRMYG
         aNEGct8cHAemnyKSDtqoywJScrM213j/UvnQjmdTbBG1sAaduvy1PDu56WafFbpQsEom
         QZLedZc9DK51kKa+vdGjI91D/8VoyGd9NXJB4edzH3scdtsdnU0rVZujuV3FfxCkMK+x
         nLeLGPpf1Noay41cs+FfrlZRJ8x+t+k2J8Whq2CzwRzzV5VPka8xMxA4sN3nZfJPHgVX
         g/pw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781569342; x=1782174142; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8gr1eJMXQLaXN7ksW6LDLSAee3NnDxV8RbIe+nSKBQ=;
        b=CdoWi18NyWNKryt8DWlZkFFm+BWls2Ml3sk2VZ2lOIO4Ynu03VmlXrRR2drJLaQtMf
         AULQac4oDZYt0oFiKF1E37iTh3EHy1US6I4SNhOa5T5Sf5UqR5NdGbIy29CM52nykxSD
         AKcuwTCBVNTNBcCC4C1DFrm1YOaVPX1g1FVSuAC7SyW8MT4fJ2VUwDzNNcJ2h/zgxvYp
         ZBVFFMvo5Z1aUY9PIfmnSiv+UlQITIcAVJHfsS7m1Zo1LP/wlm5Bav3DfkYEqSAtH+3U
         //5hUFqQITjVffL61oRHJUlXx6WXG079My1bB9D3BFLw0DA6xgNdobNbVLTlLwwCotIu
         8oYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781569342; x=1782174142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L8gr1eJMXQLaXN7ksW6LDLSAee3NnDxV8RbIe+nSKBQ=;
        b=by8FkfgqGTzOB+FuES8ySmqSEnC77mM/jSyfCs7X/OftFH9f1xwbHO1VPy0Mzvhr8m
         1q72FFuZlWh+nBkiuuqXQqhrrMvnay+v4EOcAkmT1DaeiLQfXYuGERmPrkV0HWFwEOjP
         CTQYyEJ0jzGUlydqM3Gis72mSik/ensHBdlHTTcCXYKmPtDJP4N7sR5L0LV0noxkhFE+
         kGTeLk/RIIFyeRvXbChiqWffClzzkbN8f4S5gVaXmPeZQX+TYY0H2QC5ROA5yce3WWEg
         YeuycPKJmWYHcNJSanpGl7podJSRroCc63QpQsYdbR+6u/4KKtS4MPgwi8mY/CIFRmf4
         TFLQ==
X-Gm-Message-State: AOJu0Yx93RddiPTu0KWeAZFPpFAfBIErX0brq5YVJfWnUhZiRYN8FMFZ
	d6bgpxFF19QM5U18ZcT0YJDgOJdlXNmDMyXyKcuJtoCZDyYXL56XqJuITkqC0nRmsF6t2+gCNpH
	AYHdKjrGXc6hZY0aq0rFAV0DYR3Fuwul1xeBhKSB8oQ==
X-Gm-Gg: Acq92OF5te9MKZ5cZUvpMNgDbVftnDC90e6oATcJ0Z02cqKAUv06icrI2tnuQF0lQJW
	RWCTlVGxE1xhIb2yi7OQ50fzCp0US7y2cMPtVI0mcpnU6rdh/A1voDeuRucI4YyRFasXumIuz/3
	Or5R2g84l2yfGvrSQ53a75RMwK6elsR+h5QkOFw6lBbeujbUN5UtRbFl03RJRNYT263HHQoMSF4
	gxas4nL0ajLPXBhR8DzPbbss7lm4Dh1ZfWP0q1q6rcdffPTjB0tD9nvmWmZ2YDv0TqgZgwc6/if
	YmbKKo2epWh/kDId+CI=
X-Received: by 2002:a05:6830:3912:b0:7e3:f809:7984 with SMTP id
 46e09a7af769-7e78469ec5cmr6359538a34.1.1781569342042; Mon, 15 Jun 2026
 17:22:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612025125.1690253-1-axboe@kernel.dk> <20260612025125.1690253-5-axboe@kernel.dk>
 <CADUfDZqrbUyJR9yn8i+eVbVwEuvs7a4mR8kfXF_umnZ9RUAc6g@mail.gmail.com>
 <f230eccc-819e-4e64-954e-a25578888c94@kernel.dk> <CADUfDZq2gkcjsQxb_M82WnuFWjF5-kA3sa8wUAJoRL_84a91HA@mail.gmail.com>
 <9785f0a4-a85c-4f2f-9209-ab7da042d97a@kernel.dk> <CADUfDZotc7tRWiYoDGu4nGdG=AR5wmZDyw8C1-Kp5BhxL=ZEmA@mail.gmail.com>
 <d0f05189-6192-46ca-9caf-2c71c07ddc4c@kernel.dk> <553cba4a-b4b1-4a2f-a484-4ef1d10b0c90@kernel.dk>
 <CADUfDZrKED1o-bEMF0hNN9R2q0Sq_OWWy8GhCwBw3w2fZJK_Bw@mail.gmail.com> <fc026d36-8831-4ff0-9b54-0a742550e128@kernel.dk>
In-Reply-To: <fc026d36-8831-4ff0-9b54-0a742550e128@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Jun 2026 17:22:10 -0700
X-Gm-Features: AVVi8CexAs703Uxe-tS6QQcq_TlTBX6f-Qzi4xF-qRBOQCK62wfnDaRXgoHXOM8
Message-ID: <CADUfDZrrL=FxkHtiD+vX-iSQpBY5-DoqJs7G4yR27CFqdkw=LQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13742-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,vger.kernel.org:from_smtp,kernel.dk:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 21D9D68AE9D

On Mon, Jun 15, 2026 at 2:51=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/15/26 2:40 PM, Caleb Sander Mateos wrote:
> >> @@ -34,10 +34,6 @@ void io_tctx_fallback_work(struct work_struct *work=
)
> >>                                                   fallback_work);
> >>         unsigned int count =3D 0;
> >>
> >> -       /* see tctx_task_work() - a set bit must always have a run com=
ing */
> >> -       clear_bit(0, &tctx->tw_pending);
> >> -       smp_mb__after_atomic();
> >> -
> >>         /*
> >>          * Run the entries directly. We're in PF_KTHRED context, hence
> >>          * io_should_terminate_tw() is true and they will be marked as
> >> @@ -101,6 +97,13 @@ void tctx_task_work_run(struct io_uring_task *tctx=
, unsigned int max_entries,
> >>                                 io_poll_task_func, io_req_rw_complete,
> >>                                 (struct io_tw_req){req}, ts);
> >>                 (*count)++;
> >> +               /*
> >> +                * Break if most recent pop emptied the queue. This he=
lps
> >> +                * bound task_work run, and also protects the regular
> >> +                * task_work addition.
> >> +                */
> >> +               if (mpscq_pop_emptied(&tctx->task_list, tctx->task_hea=
d))
> >> +                       break;
> >
> > I think we can now remove the "if (mpscq_empty(&tctx->task_list))
> > break;" above? The queue must be nonempty initially, otherwise the
> > task work wouldn't have been scheduled. And if the queue is empty
> > after an attempted pop, the previous iteration of this loop must have
> > successfully marked the queue as empty.
>
> We could, but then we'd need to special case the SQPOLL side. I think
> it's better if we just leave it somewhat defensive as-is, it's just a
> single compare anyway, non-atomic.

Fine by me.

Best,
Caleb

