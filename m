Return-Path: <io-uring+bounces-13434-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yICjNrOCDGqmigUAu9opvQ
	(envelope-from <io-uring+bounces-13434-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 17:33:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FAB758183B
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 17:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AEC2D3154C1E
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 15:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49E73546C5;
	Tue, 19 May 2026 15:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cM7SmRZC"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0575D400DFC
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779203965; cv=pass; b=IiblowflOtCfl95wYtBJ6mdYE4/Jk0RWzHIUxfP8vh3RWpOtY3fe4KpnCtlYSiatbPqI49wNjcjISdIU3ipWsgoiRThcOFbnGXlWPARwD5yR7uz/pLJprV4geuXQepXTlfnPLjaGl52te1a7omjgECLqNQXmsHx/wVDvhEGZjOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779203965; c=relaxed/simple;
	bh=siQVO2sQxemf4Uiqc4EspBf0wzllhMQs3CzU+GJb51Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HAn5jaFsZDZ180mVSoGQL9LWkHHfghvWK84iMM741Bxx2ltPgyZJZkexmrZF8g9HD6h611ijxnsVY89wV42BVQDk/ZYxvD+Olld39e9RrFwsu4+R5BDa5Bt/JcwXbiiORqtj/KbWtMQDplhouuoh4dUqaADlgYjn/0IoISn+GiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cM7SmRZC; arc=pass smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 64JE4Cut1384134
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 08:19:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=cvhqFdFEaw6myv9osLkAkBoObyxXccXadGAoubACWjo=; b=cM7SmRZCYmul
	dE/iM0Q6jt9wxNUlA0u5d5+XuAUSMLKPILSBjs1Wtk2pWJq4q/uB7iE5KyZu/Tzk
	+FFx2mQdg/WXv8G1MKEBFzaOJr4dFKrUmoEFTyMKJnD3jfE3N+bP4p1KmF6yI+Mi
	x1XaLRtcehHvlTfBsngbltXdiEQIEV7rGw6tcsJcDSBenZPoZrAkQZNvE+DeP9WD
	qzCz90CS7DJglwWwBRXo2+A+o38R5pzmVY4ZqNda2DNc9z+db0ClKdSOFj9+cZBj
	f37BVjxBekdYFio13WhziXTKwLkkPVpqiJA3F05rk2z93cL8GaJAS2LC0g6icyP+
	3Acjc7fgeg==
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by m0001303.ppops.net (PPS) with ESMTPS id 4e8s9rggr2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 08:19:21 -0700 (PDT)
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-bd86cf9d900so170701266b.2
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 08:19:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779203960; cv=none;
        d=google.com; s=arc-20240605;
        b=BHPKR9ACEookV/ZjfccH8/oJ5DVI0XjmXT+zgV9YDVDf2hlgmgCchuxfi76RumW0Eu
         mVSuae7P45bMs1LpRQSjGL47p//Lfec3V3LRdqJ/WpPDif0VWlOE+W5LWRLr+SRC2TE0
         Cc7d67e7jZV1AwvQCpTV9a3k3Tx4hxcf/eMwAtfDXpi0b9X6cwksxpA6YleHXoq2wel/
         nF/9iDdS5Zwvn2pUApoocbcQzXQzK25E49Y9wnjTdjKN8eaec7iXe0yC1/QHpZlqhILd
         u81qJOyzSMFO4vEoEf4Lf1mhyYFhxc3Y8qeHd6tKhocAVdaYgyiOQnQTlXDLWjisec2q
         oRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=cvhqFdFEaw6myv9osLkAkBoObyxXccXadGAoubACWjo=;
        fh=yeuCTHGCl9pWmu7A/gBRz2KVdr53pbeF4Cgqt4X245o=;
        b=hdjuk4yJUCdlR5gtNGyPyx62P2uX/uAqZFfF8a+K5O3sTkBYAQEbdvRfQFCWyUnx4U
         9sOFH/kY2i2m7Eb4RVaf56zqDDqcuFUWZ0s9MnCw2jFQ7JKvj2PELHD9KTw5uqH8agQ1
         /4kLE+wHjvuy7VVoXRSNNrPN7iMS0RuifHYZoNGUo7SnIg3ArK2zuzzTQVAy6SatQnef
         QHr6oGOU++2TY9LI10nwLcPYW0dU9uWPSEaZqf15zeZ3gAVTkRHbmcnhULYrkK7ujTzJ
         fVc8BKFrKgi3fYN1QfaK6FRxczMV9CBeH1YfWaRcOQLovpy4QFDUxM+htxpFHrxNuy2y
         1OSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203960; x=1779808760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cvhqFdFEaw6myv9osLkAkBoObyxXccXadGAoubACWjo=;
        b=Dcr2EF8l9HZHovLHel6eUJhqv0UaZM4NvtNsF9ccSphot9kTGgRHFh1gaUS+Aindbf
         vrtk0wtBi4tIe5rv76KPOLWL8YVoC3wAAvddcbF6W3sOv7RRWbectnhmdLtvb6Jv2A80
         WaZNpZWWT/8In9r+H++cs9eaAaaUj/zGt7YsgW81USeOPEj69lVbmSgjmJF1/PIHyXIx
         5qmzW66Cy/PguGXuAd1vGb7Fo+uka7bxpIuG+0u9vJaJ1a/ja3AtebgrfCNp1UpbMd+T
         +5ECJDLN/NTqmtOzPjm40AvLuYBvswRz6nz/jH0N7u4cAQ6jv2ZD79eX8lDnocsEnMFA
         bm5w==
X-Gm-Message-State: AOJu0YxnewDUaH6Ey6eRFS5OE7qvbouTpBgoAD6FHuK75wKff+BDKYga
	ITwMLvybOHhnhHiFx58rOxbP0gkkkdQL5X265w/+aILsUGhUgH+yrr9lm6qAh3BaTyqj6YOEvE7
	tIZbLyWk1qeZJR32rbcFZE1e+xsT+yNcy3rEEiudyN1q3hxGvW0SwzVTCVMxlb3oWOvRiqxl1bN
	vojDzCf/GwNwuf++ttD7EyEXI3ccpSeof/eA==
X-Gm-Gg: Acq92OGNeQsaoKjMRMP7QzxDsYubJamHGtUoBbHtCOQq2ap93xA+NfbMIK/swkdAyKr
	aUmrWKW7odqIM+VVo68KBqvmut4PW8pEfQks/puPY1NXHWVkHrZE9ly4x5J2Ik70u7sVSVeJ3s4
	y8SCa98YSMX44hj83eOQ+LmuFnuJtZ4KwLJL+URThKC81PHIsKlJLvgNe2kcwec0Bp1I5hngNbI
	4VzeqkvbAO8SyLlKH24YFGpKj1TIcKfaL0=
X-Received: by 2002:a17:907:c714:b0:bd0:7949:a931 with SMTP id a640c23a62f3a-bd517960723mr1182042966b.27.1779203960355;
        Tue, 19 May 2026 08:19:20 -0700 (PDT)
X-Received: by 2002:a17:907:c714:b0:bd0:7949:a931 with SMTP id
 a640c23a62f3a-bd517960723mr1182039866b.27.1779203959924; Tue, 19 May 2026
 08:19:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260518153532.2835502-1-cleger@meta.com> <20260518153532.2835502-2-cleger@meta.com>
In-Reply-To: <20260518153532.2835502-2-cleger@meta.com>
From: Vishwanath Seshagiri <vishs@meta.com>
Date: Tue, 19 May 2026 08:19:07 -0700
X-Gm-Features: AVHnY4ISeSj-tWX2tmLsxva9JeDwShAViFq_TymQ9K5usF1cuLqmkszdGAaeUro
Message-ID: <CAJEWsO0hprYmXoGmkR1+yv+hM53dGVh5O=7M+xFAdqoQjKrA8w@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] io_uring/zcrx: add ctx pointer to zcrx
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDE1MiBTYWx0ZWRfX2v/bbk8K09hJ
 csj11l0eaG7hfyuj88Ho6EFXfOulmgwp6FG7aQ85plmfo6OxDtAngeTgiWoyyehBcrjbgH98US/
 2Fpc1NGXsIDuOjh4x3lBaqbSV0ljijzymMU7rqD6JCZC/fsNAqS92UIu4RLVobjNV05tLDKt+ct
 1WJmYdgRbENCfFnZkahlzmb5yCi7cshj0WSy6qbswwrLsEtDLSNv9lCu04OcTa5j4XCHdQgS5/r
 bEahTcQ/YjPM3vmhFbkXR5bTxRgFSsUm6Wq1dYcwCnqJI7Z5GTPAC2NATosY9Kt9q9rgE/UzDLS
 c0l/Yi9WZicr351Ol2ewP1xjZPlA5Kj71s3Ev+0GThcBsQ8hqAge1As4PJR+xuU6qwcwVyo6sPa
 KFZPDCwCdgddTRNIeS3kZCtWJ2g4QjR14DZFB6uylQsER3iyrn26wMwbulSGuVMI4Og5/zK8Fwq
 2+zBuW3GzGBviHZ2UvQ==
X-Proofpoint-GUID: 0BNG9oAa-U3vcEoocM_lMtQbxKD1SC6O
X-Authority-Analysis: v=2.4 cv=NuzhtcdJ c=1 sm=1 tr=0 ts=6a0c7f79 cx=c_pps
 a=D+UBI74RbQA8i2EYnbuvxw==:117 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22
 a=VabnemYjAAAA:8 a=pGLkceISAAAA:8 a=DNv30csI2qpO98t81IsA:9 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: 0BNG9oAa-U3vcEoocM_lMtQbxKD1SC6O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_04,2026-05-18_01,2025-10-01_01
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13434-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,kernel.dk,davemloft.net,google.com,kernel.org,redhat.com,lwn.net,linuxfoundation.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vishs@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,meta.com:email,meta.com:dkim]
X-Rspamd-Queue-Id: 3FAB758183B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, May 18, 2026 at 8:36=E2=80=AFAM Cl=C3=A9ment L=C3=A9ger <cleger@met=
a.com> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> zcrx will need to have a pointer to an owning ctx to communicate
> different events. Reference the ctx while it's attached to zcrx, and
> rely on zcrx termination to drop the ctx to avoid circular ref deps.
>
> Co-developed-by: Vishwanath Seshagiri <vishs@meta.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Vishwanath Seshagiri <vishs@meta.com>
> ---
>  io_uring/zcrx.c | 39 +++++++++++++++++++++++++++++++--------
>  io_uring/zcrx.h |  3 +++
>  2 files changed, 34 insertions(+), 8 deletions(-)
>
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 3f9632e7790a..34faf90423f4 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -44,6 +44,17 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area=
(const struct net_iov *nio
>         return container_of(owner, struct io_zcrx_area, nia);
>  }
>
> +static bool zcrx_set_ring_ctx(struct io_zcrx_ifq *zcrx,
> +                             struct io_ring_ctx *ctx)
> +{
> +       guard(spinlock_bh)(&zcrx->ctx_lock);
> +       if (zcrx->master_ctx)
> +               return false;
> +       percpu_ref_get(&ctx->refs);
> +       zcrx->master_ctx =3D ctx;
> +       return true;
> +}
> +
>  static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
>  {
>         struct io_zcrx_area *area =3D io_zcrx_iov_to_area(niov);
> @@ -531,6 +542,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct i=
o_ring_ctx *ctx)
>                 return NULL;
>
>         ifq->if_rxq =3D -1;
> +       spin_lock_init(&ifq->ctx_lock);
>         spin_lock_init(&ifq->rq.lock);
>         mutex_init(&ifq->pp_lock);
>         refcount_set(&ifq->refs, 1);
> @@ -580,6 +592,8 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
>                 return;
>         if (WARN_ON_ONCE(ifq->netdev !=3D NULL))
>                 return;
> +       if (WARN_ON_ONCE(ifq->master_ctx))
> +               return;
>
>         if (ifq->area)
>                 io_zcrx_free_area(ifq, ifq->area);
> @@ -656,17 +670,24 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
>         }
>  }
>
> -static void zcrx_unregister_user(struct io_zcrx_ifq *ifq)
> +static void zcrx_unregister_user(struct io_zcrx_ifq *ifq, struct io_ring=
_ctx *ctx)
>  {
> +       scoped_guard(spinlock_bh, &ifq->ctx_lock) {
> +               if (ctx && ifq->master_ctx =3D=3D ctx) {
> +                       ifq->master_ctx =3D NULL;
> +                       percpu_ref_put(&ctx->refs);
> +               }
> +       }
> +
>         if (refcount_dec_and_test(&ifq->user_refs)) {
>                 io_close_queue(ifq);
>                 io_zcrx_scrub(ifq);
>         }
>  }
>
> -static void zcrx_unregister(struct io_zcrx_ifq *ifq)
> +static void zcrx_unregister(struct io_zcrx_ifq *ifq, struct io_ring_ctx =
*ctx)
>  {
> -       zcrx_unregister_user(ifq);
> +       zcrx_unregister_user(ifq, ctx);
>         io_put_zcrx_ifq(ifq);
>  }
>
> @@ -686,7 +707,7 @@ static int zcrx_box_release(struct inode *inode, stru=
ct file *file)
>
>         if (WARN_ON_ONCE(!ifq))
>                 return -EFAULT;
> -       zcrx_unregister(ifq);
> +       zcrx_unregister(ifq, NULL);
>         return 0;
>  }
>
> @@ -711,7 +732,7 @@ static int zcrx_export(struct io_ring_ctx *ctx, struc=
t io_zcrx_ifq *ifq,
>         file =3D anon_inode_create_getfile("[zcrx]", &zcrx_box_fops,
>                                          ifq, O_CLOEXEC, NULL);
>         if (IS_ERR(file)) {
> -               zcrx_unregister(ifq);
> +               zcrx_unregister(ifq, NULL);
>                 return PTR_ERR(file);
>         }
>
> @@ -787,7 +808,7 @@ static int import_zcrx(struct io_ring_ctx *ctx,
>         scoped_guard(mutex, &ctx->mmap_lock)
>                 xa_erase(&ctx->zcrx_ctxs, id);
>  err:
> -       zcrx_unregister(ifq);
> +       zcrx_unregister(ifq, ctx);
>         return ret;
>  }
>
> @@ -932,12 +953,14 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
>                 ret =3D -EFAULT;
>                 goto err;
>         }
> +
> +       zcrx_set_ring_ctx(ifq, ctx);
>         return 0;
>  err:
>         scoped_guard(mutex, &ctx->mmap_lock)
>                 xa_erase(&ctx->zcrx_ctxs, id);
>  ifq_free:
> -       zcrx_unregister(ifq);
> +       zcrx_unregister(ifq, ctx);
>         return ret;
>  }
>
> @@ -967,7 +990,7 @@ void io_terminate_zcrx(struct io_ring_ctx *ctx)
>                         break;
>                 set_zcrx_entry_mark(ctx, id);
>                 id++;
> -               zcrx_unregister_user(ifq);
> +               zcrx_unregister_user(ifq, ctx);
>         }
>  }
>
> diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
> index 9e1a6a1b11e8..6b565d0bf6da 100644
> --- a/io_uring/zcrx.h
> +++ b/io_uring/zcrx.h
> @@ -73,6 +73,9 @@ struct io_zcrx_ifq {
>          */
>         struct mutex                    pp_lock;
>         struct io_mapped_region         rq_region;
> +
> +       spinlock_t                      ctx_lock;
> +       struct io_ring_ctx              *master_ctx;
>  };
>
>  #if defined(CONFIG_IO_URING_ZCRX)
> --
> 2.53.0-Meta
>

