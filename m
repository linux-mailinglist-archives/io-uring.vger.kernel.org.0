Return-Path: <io-uring+bounces-6036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D04E2A18916
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 01:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FBCE7A45C5
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 00:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D40AD4B;
	Wed, 22 Jan 2025 00:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9KMJTbg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77527175BF;
	Wed, 22 Jan 2025 00:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737506721; cv=none; b=KZYIdS9xwtqK67TzWU6AP0IYqsZv2QWU+88P82AJde7itOOpBB6WsgX1bl8/3KyPpH3Al9hLmb7uVhC+bzT2eUK4H8PCAxJJl6Kg1pe72GPxyFSMIaXLPJ5NeCMJ3iiYP2jk+SfuCZdq5uO6g9cZvNvQMN8pRya4rArQVyTM5Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737506721; c=relaxed/simple;
	bh=21RUJtcN1WGkOHf+6aenCuOoTsiL+1Qu0JcXFGYTsRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WzhjZU44zZ/9lGSkXIRJuj1C93bRATOMgQdPP4rrGWJwVMtqWD0SmIneUIM/kw5iOGvMj09jCkswReez5JDRRHZAjKreod3XxLgyKa6OHB6nvEAaerBSxfxtb2LVhbPKjw+1R++aNSAA/dr81l2/LQuBIuHZPnlg5N7MYW0yaxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C9KMJTbg; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-46901d01355so59852011cf.0;
        Tue, 21 Jan 2025 16:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737506718; x=1738111518; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQ78OaPb/ksNLbM+9kzkydl6w2SMJZ/0TbYhf3drCos=;
        b=C9KMJTbglZp8ZyH7o1jbxRI6xWWEEgT3vfVbx/pW0XKsee08A6JYIoIW3Mzfl+gHs2
         4FM3ZXbnIRVG/7dTmV/Ssrb0u7Oc98QyB2F/jI4Wv5Yakc9yPuOC++jwSVv5ppPU+5j+
         ntSHvumDrzjdqgN7+qoJe0LfnF+sWHCzxUHBpB5Ya1clO0Q+BKtnmmTQFwftstuCz82R
         SYbYGqcvyp3c19L4zeUID6mSxBk7sVYfPI74OS87QzFpJur9gmMjiv5tMhuzGmwrSBQY
         ba2hE7YQ5oc8TiROOmf408E8ix2DCxy8/hYWc7RhGAmhw4lS9gKnztx/pVyVGUjcF59l
         caRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737506718; x=1738111518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lQ78OaPb/ksNLbM+9kzkydl6w2SMJZ/0TbYhf3drCos=;
        b=Kgn8pLGhU6wnRIQoeFxwxPYq4xLtqxnBPwXeVAsoM2oeuUc1RKmEP9oLeVZWZz2kkZ
         MAEqbqYcLSMBFGQmhhhhEmyYNqGyDd3AJR2fyw+FuHqswrcMKnPKI59yqL5MP3YaGuEZ
         zEChMF6VnsU/4Gs2mhRpXlSMSmW3DS/ncB8hxOqKAnlX9p9OaTs0smRt5qTXT2ElniBK
         eEgdP4pUu2N4v6yNMtqSxTzmqTeEp4pp3bvS9SAHUePlwqrEGTBTnwPugGROipEC/JD6
         ksC78kmCBjUuEqxM+tmI4jWmUP0IJGWcKt7v3YnNio2gmqJPoWJhlqBJ1b2TJGghonL6
         BFTw==
X-Forwarded-Encrypted: i=1; AJvYcCUK2yAJXg+B4EsWqddIiYo+OJNSaorAwDaY1rHfOV38W7LK0o14gBEewBgCI2aLZFptVhtekCcKE5uBnW3q5w==@vger.kernel.org, AJvYcCWwkIobQkqbGadD0Gpq+JCtjBx+F8InPIT0iJ5A6/yNAzUmgbdUSSgE0N9b+a4BOHkUjELUuDpNMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxceLT7SzD8Tug2BZWvJturwHdlz9aaQYENcxkv2AyVU24f/Ts1
	iqcLSmvScxYxcgkioQetRX8dJUvhObZPK5eBGnmMPtPOrVoNgNQtSNJ7P3V8dAi2WPbUbR0+/IB
	LNombICn4hoDNNiuu5M+Qy+FbRQs=
X-Gm-Gg: ASbGncvwiP/te09I7gb1Xk/OhQ5/KDtHwow27biMOfgcEAF302LFxKYUmBT0zQSo2Ro
	mOI/N+FI9e+/d2SvLxbFSXfZaQMwX0RrZwT76JQgCTZgGvzDOzqD7oJERuBC3DBg=
X-Google-Smtp-Source: AGHT+IHqcA++GDYDFxIFFPF2zBEk0d8ip3zuE3o+451QfC0Izm+0PQXGhA7OnDMzYPz1OYleDZl0+jfFqmo7DKAixkw=
X-Received: by 2002:a05:622a:292:b0:467:b7de:da8a with SMTP id
 d75a77b69052e-46e12a2c4e7mr298398491cf.6.1737506718094; Tue, 21 Jan 2025
 16:45:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
 <CAJnrk1afYmo+GNRb=OF7CUQzY5ocEus0h=93ax8usA9oa_qM4Q@mail.gmail.com>
 <eafad58d-07ec-4e7f-9482-26f313f066cc@bsbernd.com> <CAJnrk1asVwkm8kG-Rfmgi-gPXjYxA8HcA_vauqVi+zjuPNtaJQ@mail.gmail.com>
 <605815bc-40ca-49c1-a727-a36f961b8ad6@bsbernd.com>
In-Reply-To: <605815bc-40ca-49c1-a727-a36f961b8ad6@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 21 Jan 2025 16:45:07 -0800
X-Gm-Features: AbW1kvbTPSeb5tKkNEomPZ6-3WQ-LWeuvO7_P_uPyiKrU9IhlxoekiLZvcPsux4
Message-ID: <CAJnrk1bg_ZwuV1w8x6to50_LYk+o6=HAzC_eQ_U4QGLkyXVwsA@mail.gmail.com>
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025 at 4:18=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
...
> >>
> >>>
> >>>> +
> >>>> +       err =3D fuse_ring_ent_set_commit(ring_ent);
> >>>> +       if (err !=3D 0) {
> >>>> +               pr_info_ratelimited("qid=3D%d commit_id %llu state %=
d",
> >>>> +                                   queue->qid, commit_id, ring_ent-=
>state);
> >>>> +               spin_unlock(&queue->lock);
> >>>> +               return err;
> >>>> +       }
> >>>> +
> >>>> +       ring_ent->cmd =3D cmd;
> >>>> +       spin_unlock(&queue->lock);
> >>>> +
> >>>> +       /* without the queue lock, as other locks are taken */
> >>>> +       fuse_uring_commit(ring_ent, issue_flags);
> >>>> +
> >>>> +       /*
> >>>> +        * Fetching the next request is absolutely required as queue=
d
> >>>> +        * fuse requests would otherwise not get processed - committ=
ing
> >>>> +        * and fetching is done in one step vs legacy fuse, which ha=
s separated
> >>>> +        * read (fetch request) and write (commit result).
> >>>> +        */
> >>>> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
> >>>
> >>> If there's no request ready to read next, then no request will be
> >>> fetched and this will return. However, as I understand it, once the
> >>> uring is registered, userspace should only be interacting with the
> >>> uring via FUSE_IO_URING_CMD_COMMIT_AND_FETCH. However for the case
> >>> where no request was ready to read, it seems like userspace would hav=
e
> >>> nothing to commit when it wants to fetch the next request?
> >>
> >> We have
> >>
> >> FUSE_IO_URING_CMD_REGISTER
> >> FUSE_IO_URING_CMD_COMMIT_AND_FETCH
> >>
> >>
> >> After _CMD_REGISTER the corresponding ring-entry is ready to get fuse
> >> requests and waiting. After it gets a request assigned and handles it
> >> by fuse server the _COMMIT_AND_FETCH scheme applies. Did you possibly
> >> miss that _CMD_REGISTER will already have it waiting?
> >>
> >
> > Sorry for the late reply. After _CMD_REGISTER and _COMMIT_AND_FETCH,
> > it seems possible that there is no fuse request waiting until a later
> > time? This is the scenario I'm envisioning:
> > a) uring registers successfully and fetches request through _CMD_REGIST=
ER
> > b) server replies to request and fetches new request through _COMMIT_AN=
D_FETCH
> > c) server replies to request, tries to fetch new request but no
> > request is ready, through _COMMIT_AND_FETCH
> >
> > maybe I'm missing something in my reading of the code, but how will
> > the server then fetch the next request once the request is ready? It
> > will have to commit something in order to fetch it since there's only
> > _COMMIT_AND_FETCH which requires a commit, no?
> >
>
> The right name would be '_COMMIT_AND_FETCH_OR_WAIT'. Please see
> fuse_uring_next_fuse_req().
>
> retry:
>         spin_lock(&queue->lock);
>         fuse_uring_ent_avail(ent, queue);           --> entry available
>         has_next =3D fuse_uring_ent_assign_req(ent);
>         spin_unlock(&queue->lock);
>
>         if (has_next) {
>                 err =3D fuse_uring_send_next_to_ring(ent, issue_flags);
>                 if (err)
>                         goto retry;
>         }
>
>
> If there is no available request, the io-uring cmd stored in ent->cmd is
> just queued/available.

Could you point me to where the wait happens?  I think that's the part
I'm missing. In my reading of the code, if there's no available
request (eg queue->fuse_req_queue is empty), then I see that has_next
will return false and fuse_uring_next_fuse_req() /
fuse_uring_commit_fetch() returns without having fetched anything.
Where does the "if there is no available request, the io-uring cmd is
just queued/available" happen?

>
> Btw, Miklos added it to linux-next.
>

Awesome, can't wait to use it.

Thanks,
Joanne
>
> Cheers,
> Bernd
>

