Return-Path: <io-uring+bounces-12344-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLGNDgBel2mdxQIAu9opvQ
	(envelope-from <io-uring+bounces-12344-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 20:01:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86009161D7D
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 20:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5AC20301FF95
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 19:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC26F2FC01B;
	Thu, 19 Feb 2026 19:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QuNXci6o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700FC2F747A
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771527675; cv=pass; b=DZ74yjeY6wusVqFOfzfpWVRYde+iS/OMgyazg0rjPfX6psP2/niBlBdSvG5Pp7kRXJvfnyUTuD4VMwmIkldq7Tb9nEOI1uoGkuw+ZOdaOg/i2DRNZtyygsUCPz0t0hoV28L7HFKC+vRHHFcF6B2ceP8PtsQ9AwE9TxBECnlxth8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771527675; c=relaxed/simple;
	bh=tquMu6jYPhyKiV1i8LjJLyLv/MbogEbCgjm7Io9nkKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=azDQ5vTnNPGW2amboPKnGBWd4fkp0LaMfx7NPXLM1nQk55uQmiF9jgmNDT/LzgBnjkQoZ1IxnHeNJ9+NofeNu9hiyWaV7s1RUyBLQcnhWxeQiY9QjEkv4orTtOjXb7w6S5CjjL3VSKaOVgsJIBrx835+9upMSUCXs9hJsR4rvKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QuNXci6o; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-483a233819aso8165445e9.3
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 11:01:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771527671; cv=none;
        d=google.com; s=arc-20240605;
        b=M2qAw1AX8K8C1oArUYXl9SJYX/wnzPvThwUu+CKMdKbyaMdiykwVgiS3wiEN74eFUN
         vdxOke7TCjNwRhS70PJNfPnzRDz0LDQB+RrmgjtVam1wRv73tmWtSgZHDlN409zxeNi7
         Uu3hYM/PGorUVU6ZdkA1SoX3732Hh+lGvP/ne6rOlnOwb2kFYDGrm/JlMBnU4Oz6KUx0
         /QsDuJAe6+o6gC59Cjm8mCXcWj284J0vDJ8xbN/BoX7JApBuiaG0NSoWot6m18nPIpl3
         epqkeHkEp3F+XKpPLNAE2IFR7p1tKZXLhgS4JV4N+US2OMu4THOCN4vihKApee/bLGvU
         45fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jfcXHM8vdeHdLJ0TPx+8IcJlGEwAdq3TJvZNt0rkyx8=;
        fh=/CN9mfTqvVu2uNAJ0wMLUcZBlSeaKHjQ1yN0L6YpXc0=;
        b=JuUp6A/CZs04bxLcF7+gkqH6hUrMG5Rpw+0KuZgf2JpaBHTvVd3qLutQz+nbmKiVVP
         g7zRZTAxivLVEVsFsYbFEWAt8sLUhDLuU6RVf6H80yT4pV+Er/ZzsydIsba5mHp6/42U
         F1vy+UzMX0TB+aUa3T8LaxsDgu97MDFC6e7cgiULZIEd1C/TGFCt8ViGNWX4FYe7Paug
         xkmRDDuUmF42faeW6Hyw8UXOHF20gAsxj8lg6PofzN965DSTxycUo6iwwYay5AC5jyAO
         gmvNBC3wQgMBrxi3uxsdG/0JswEbwvadqG6gcaFrxZpmuzDZhQ7a30R8NS1bjPJGZUqD
         8e9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771527671; x=1772132471; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jfcXHM8vdeHdLJ0TPx+8IcJlGEwAdq3TJvZNt0rkyx8=;
        b=QuNXci6onMnS/dus66FiRDgQd9ioInjcmqzg/w8D9kZBxRxyxRE30XI0RQA9t0UfoK
         aIUz800PMYN77/nDdloie2fg6W1nsd2yjV1P/xHuIHnxR5Zw1L3oV+uhpcU3zs6koZUV
         DlGxH+m+Scnbh2GrTiI9GI0wN6ua58aXAyPeI1zLBmOsJeiGywdhKKKJ4LLwlhQNgll1
         0G3T7SaWnMdu9GQDiUDSwQlQiPv/p5tjoCtf0T58q9BV4YhB/cIq3LOSNZYK/0/frsum
         RKXI+fRgnwRdsFuSH6FfeY/XaP+wmAl3y5TRFkK9+7lYUhC5tYsT0cEl6Oyi/XtAS1hZ
         ewLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771527671; x=1772132471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jfcXHM8vdeHdLJ0TPx+8IcJlGEwAdq3TJvZNt0rkyx8=;
        b=AbZjb1r4iv1qpKdZ3NmM0B78c1EobdwNg4tSgOCJ1iVmzqEk1KrBFvDUgIAWB2Qbt6
         /YAD+e9pR2q5UZDFvg3ARhwxMbyzSjl7h6OtHWViKODowCJlS4ccYXpDx/Zyv7OV3RtG
         eQSdMkFQGUXpO+D6jLBJ9tRiflGBo59t03mSa7q5EQc8Zl238AriBtfpo97sC2tDptRM
         kN5XHMTG5Cyl2ZxkVq+TedNx3p3Ca17UounF5lwjZ+thwURGGXePnWpQjXcUAnUajY22
         7aV+yLqdXsV4nzXlgSxtsS2ZoEimUdHkww2mKCUS4c57pCeRMbYYaOKCQ5cviofZiczr
         va6w==
X-Gm-Message-State: AOJu0Yyopnx/MlacFio0vLSvRmiWMVAuLiVZER0I1kNpAzZ2uUutdker
	nek/jVw4ZUrWdbjYtmlcv2W0vwWeqg626y2bH3INgie23x3FGs33Mg8BXA/cjyrWI6QtAecxj/l
	l5FKNUd/vV8HImxDpS6EMb9jRD1TVBGE=
X-Gm-Gg: AZuq6aKEzZOdtbcFWD91BczcxEaF1jpFzLSx1uHpywQtmHi4IJqi6IHfAaC5mPmVyZh
	dAbL/ukO5uuIrug/t5CAYhHO3wO/TGFuCpcbc0q3axHFM74qxKpc+BhI8IzoKRXTnBH1DaIKBXr
	BStg7GZ7xahwgKRLEnLBvMxzjKKw52WzjcDHFh/USQ7YGUePbiB0cFq2Prcw87J8aPuqX8Yrqpo
	XqaCtsFtWSsHRu51vuLD+Q2OW4DQpXJFqq7WZGLaDY0dx7bKCIxrl0N9DnOhoBcfU3A4C+RXyGA
	s+L0P5DkgouXY5wbjLMWdpC63OxNZeRSMQ68/rZiAdIVirpIaCqYk7xj4yNNaL2FDNoBa9SeUrr
	qGXRn+XAy
X-Received: by 2002:a05:600c:458a:b0:477:5c58:3d42 with SMTP id
 5b1f17b1804b1-48398a7e1e2mr111256305e9.10.1771527671269; Thu, 19 Feb 2026
 11:01:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771327059.git.asml.silence@gmail.com> <7cc147a959ac068c55dae4f540e38e9e4ab121e0.1771327059.git.asml.silence@gmail.com>
In-Reply-To: <7cc147a959ac068c55dae4f540e38e9e4ab121e0.1771327059.git.asml.silence@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 19 Feb 2026 11:01:00 -0800
X-Gm-Features: AaiRm537YFUuP5smuHEyCnxqI_hW-J5HXpVLTTziLuOVjoC_dPmNvZaoVrYmNHE
Message-ID: <CAADnVQK0RaOA9ZYZdYyQxOzLde9MR8HpMM0SexcW59A9u7X2Jw@mail.gmail.com>
Subject: Re: [PATCH v8 5/5] selftests/io_uring: add a bpf io_uring selftest
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12344-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alexeistarovoitov@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 86009161D7D
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 3:33=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 3);
> +       __type(key, u32);
> +       __type(value, s64);
> +} res_map SEC(".maps");
> +
> +#define t_min(a, b) ((a) < (b) ? (a) : (b))
> +
> +static inline void set_cq_wait(struct iou_loop_params *lp,
> +                              struct io_uring *cq_hdr, unsigned to_wait)
> +{
> +       lp->cq_wait_idx =3D cq_hdr->head + to_wait;
> +}
> +
> +static inline void write_result(int res)
> +{
> +       u32 key =3D SLOT_RES;
> +       u64 *val;
> +
> +       val =3D bpf_map_lookup_elem(&res_map, &key);
> +       if (val)
> +               *val =3D res;
> +}
> +
> +static inline void write_stats(int idx, unsigned int v)
> +{
> +       u32 key =3D idx;
> +       u64 *val;
> +
> +       val =3D bpf_map_lookup_elem(&res_map, &key);
> +       if (val)
> +               *val +=3D v;
> +}

Since these examples will be copied around, let's use
good coding practices. Use properly named global variables
for stats and counters, and drop this opaque array.

Also bpf_map_lookup_elem() doesn't need if (val) check
when key is a constant and lookup is from array map.

> +
> +SEC("struct_ops.s/nops_loop_step")
> +int BPF_PROG(nops_loop_step, struct io_ring_ctx *ring, struct iou_loop_p=
arams *ls)
> +{
> +       struct io_uring *sq_hdr, *cq_hdr;
> +       struct io_uring_sqe *sqes;
> +       struct io_uring_cqe *cqes;
> +       void *rings;
> +       int ret;
> +
> +       sqes =3D (void *)bpf_io_uring_get_region(ring, IOU_REGION_SQ,
> +                               SQ_ENTRIES * sizeof(struct io_uring_sqe))=
;
> +       rings =3D (void *)bpf_io_uring_get_region(ring, IOU_REGION_CQ,
> +                               cqes_offset + CQ_ENTRIES * sizeof(struct =
io_uring_cqe));
> +       if (!rings || !sqes) {
> +               write_result(-1);
> +               return IOU_LOOP_STOP;
> +       }
> +
> +       sq_hdr =3D rings + (sq_hdr_offset & 63);
> +       cq_hdr =3D rings + (cq_hdr_offset & 63);
> +       cqes =3D rings + cqes_offset;
> +
> +       unsigned to_wait =3D cq_hdr->tail - cq_hdr->head;
> +       to_wait =3D t_min(to_wait, CQ_ENTRIES);
> +       for (int i =3D 0; i < to_wait; i++) {
> +               struct io_uring_cqe *cqe =3D &cqes[cq_hdr->head & (CQ_ENT=
RIES - 1)];
> +
> +               if (cqe->user_data !=3D REQ_TOKEN) {
> +                       write_result(-3);
> +                       return IOU_LOOP_STOP;
> +               }
> +               cq_hdr->head++;
> +       }

CQ_ENTRIES is just 8.
Is it enough for real progs?
Does the above approach scale ?
I mean the above works as a bounded loop because loop
count is small, but for 100+ you want open coded iterators.

In general all progs seem to be toy progs.
Would be good to have something more realistic.

