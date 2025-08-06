Return-Path: <io-uring+bounces-8890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A26FB1C9F9
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 18:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E79353A8746
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 16:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96C329AB1A;
	Wed,  6 Aug 2025 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gkpfckko"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E134529A303
	for <io-uring@vger.kernel.org>; Wed,  6 Aug 2025 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754498952; cv=none; b=DYBXD2MkhKCFsB+grF31YI8eWeyVIZpKA0csN23yDMTDOiHUJiTY6rEbzm666Z1DZBT73jYgBWrqJE3pjvUU8pVlsVeWhPNVloj0LkkGnDe84skN24IVK40bynSfBVX+K8KjFRcz3rniaqHT0X+h9k2W7ctdwiCGUuZBV93yK08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754498952; c=relaxed/simple;
	bh=ZeSXh39h6xtD2zkk9H9FdoX/x3k8q9HT+wNdGyALMGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BpcEnQExJU3tyo/dfsxZPyCdNANtRPePvRcUJme42OphPX55z0iP+eYwJaoxXJ1eMvHL5A1/P0gLfOoIV9kmcXeo5v/Bf/bVVTu4Ww4jMrcBn9YsYPJWyxec5tIpNfDBUJU640kYxt39q9ymT4IxNuirs9Dv+7EIGeX1PCFfurY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gkpfckko; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55b7bf0a8d5so211e87.0
        for <io-uring@vger.kernel.org>; Wed, 06 Aug 2025 09:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754498949; x=1755103749; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+B3mKu8ZyXZgyldx1ID9yYSp8otWO+26YrXQxjyJZvw=;
        b=gkpfckkolCpFpVjcD8liMZ9zH/viIv458SLSDPxqCMCNYq1dPlmV4N9OH6wC7qNyII
         b3IQ3zqm1KtCWnY2Co7+yQ8e+qG+THw19ryc0JDRDo/gDuCcSuxn2hZmeR7qzD9ppaF/
         Vzh5tV+XdIfEFKMqOt2WoLooZFC9tsHvjj+mhGO7YUC3mgsPcHJzCqPnUSHDVQjIyAR2
         K2NZ6OzcMH5HK/LFOzTVwZNLshJFutXVqx++6UhSb/v8h61fOcQbAAK5p2EPOqZ5Tf1O
         m+HliONRN2az34P+nKBelULmkcKdVbiIe3amgj6yK9C1f8vdjmFClfotMVjT0Xb1UCak
         7PmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754498949; x=1755103749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+B3mKu8ZyXZgyldx1ID9yYSp8otWO+26YrXQxjyJZvw=;
        b=owZ+iGQaOG4YDLB4mGho3qCNsDOYlm4rpg8VMK5+FYhEApY9utk6YzVE0zSnx/WNOm
         V/jK2zxjByWiqTdVOEN1klds/PSB+vFIUjzEflctxo4CKVyUyUFsGwv6RMB6zaAKMaoM
         FPPdFnp4MUIBTWBGATfM6NVVFSGNi96tc9JRB/sGx76qwhy870hD6Rc/IqwzMr39gdUA
         SF0bVA3CooS+AJQu9hVqjyl58hTDdArrLhpRfhnaxsWdcINaPM9bQgsZkNrlR/nuNZBs
         9LmqSUVAVH20h1l88AU9fLUFbXbohUaCc3qS2TT6fqFQI/uF2ztnCqrJCxYj2Onec1nc
         SgzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWU6sYrDl8vWEpntIFUxaIU+vsziQV3Togax+2eUOZCNnCkIuqTBsE0EOHLnyZlYkOev+uhMswEyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzryuhtYUTU1eAz4gZ7lXhZAUedkzTOHl8iT5+nTM90yIdMY5TJ
	jblcePOM8z+cUOhWe8479pYuhuocHTXY7eiiyvFyyM/NEhWjzoCIckuCsZikccCuFv0iTaDEquC
	PEN93mNebtO4JEvt2OBfaELI3vUCXZLXIFsg9LVKu
X-Gm-Gg: ASbGncvH5xfKX7ji/pZeipfzx0a4lZtbcu09ewjiUHY1HetTXOhseOqPiE/2lTbAz0u
	et1rXBU3HbdE2Tan65erRqrT+R0TzzsR+rILY5s2QNeqs/dL04CKUxYNw2ucv6sBOZgadrG2GAw
	WZsj8ZSIjJfDKbIa54E+uV0qLLBxYQ+H85hGIc7q2TTNFHST19rHkFd887PO29FMLL9W8eRiGgc
	x8nTdiUMZFhwMm8COAGUaK95SzB+Lv5LoBgnS1B0H5inf4=
X-Google-Smtp-Source: AGHT+IGOkbe9dbWGnS6+1s7Wq6OW/Qhyhn3uo+RLlUMybsqoGGjikVLHhoAhtv1rxFzxt9dArPaa1GD+Gkz5VfNZjqc=
X-Received: by 2002:a19:3844:0:b0:55b:99e4:2584 with SMTP id
 2adb3069b0e04-55cae73fc3bmr344237e87.2.1754498948708; Wed, 06 Aug 2025
 09:49:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com> <ca874424e226417fa174ac015ee62cc0e3092400.1753694914.git.asml.silence@gmail.com>
 <20250801171009.6789bf74@kernel.org> <11caecf8-5b81-49c7-8b73-847033151d51@gmail.com>
In-Reply-To: <11caecf8-5b81-49c7-8b73-847033151d51@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 6 Aug 2025 09:48:56 -0700
X-Gm-Features: Ac12FXybC97X31wROsEYSpZV1hSDgT6IyYQ4soYHYXhWxQfaz8IZ0d2rVCtC95M
Message-ID: <CAHS8izNc4oAX2n3Uj=rMu_=c2DZNY6L_YNWk24uOp2OgvDom_Q@mail.gmail.com>
Subject: Re: [RFC v1 21/22] net: parametrise mp open with a queue config
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 4, 2025 at 5:48=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 8/2/25 01:10, Jakub Kicinski wrote:
> > On Mon, 28 Jul 2025 12:04:25 +0100 Pavel Begunkov wrote:
> >> This patch allows memory providers to pass a queue config when opening=
 a
> >> queue. It'll be used in the next patch to pass a custom rx buffer leng=
th
> >> from zcrx. As there are many users of netdev_rx_queue_restart(), it's
> >> allowed to pass a NULL qcfg, in which case the function will use the
> >> default configuration.
> >
> > This is not exactly what I anticipated, TBH, I was thinking of
> > extending the config stuff with another layer.. Drivers will
> > restart their queues for most random reasons, so we need to be able
> > to reconstitute this config easily and serve it up via
>
> Yeah, also noticed the gap that while replying to Stan.
>
> > netdev_queue_config(). This was, IIUC, also Mina's first concern.
> >
> > My thinking was that the config would be constructed like this:
> >
> >    qcfg =3D init_to_defaults()
> >    drv_def =3D get_driver_defaults()
> >    for each setting:
> >      if drv_def.X.set:
> >         qcfg.X =3D drv_def.X.value
> >      if dev.config.X.set:
> >         qcfg.X =3D dev.config.X.value
> >      if dev.config.qcfg[qid].X.set:
> >         qcfg.X =3D dev.config.qcfg[qid].X.value
> >      if dev.config.mp[qid].X.set:               << this was not in my
> >         qcfg.X =3D dev.config.mp[qid].X.value     << RFC series
> >
> > Since we don't allow MP to be replaced atomically today, we don't
> > actually have to place the mp overrides in the config struct and
> > involve the whole netdev_reconfig_start() _swap() _free() machinery.
> > We can just stash the config in the queue state, and "logically"
> > do what I described above.
>
> I was thinking stashing it in struct pp_memory_provider_params and
> applying in netdev_rx_queue_restart(). Let me try to move it
> into __netdev_queue_config. Any preference between keeping just
> the size vs a qcfg pointer in pp_memory_provider_params?
>
> struct struct pp_memory_provider_params {
>         const struct memory_provider_ops *mp_ops;
>         u32 rx_buf_len;
> };
>

Is this suggesting one more place where we put rx_buf_len, so in
addition to netdev_config?

Honestly I'm in favor of de-duplicating the info as much as possible,
to reduce the headache of keeping all the copies in sync.
pp_memory_provider_params is part of netdev_rx_queue. How about we add
either all of netdev_config or just rx_buf_len there? And set the
precedent that queue configs should be in netdev_rx_queue and all
pieces that need it should grab it from there? Unless the driver needs
a copy of the param I guess.

iouring zcrx and devmem can configure netdev_rx_queue->rx_buf_len in
addition to netdev_rx_queue->mp_params in this scenario.

--=20
Thanks,
Mina

