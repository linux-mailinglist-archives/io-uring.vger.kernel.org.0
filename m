Return-Path: <io-uring+bounces-13223-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wItQIvpL+GmQsQIAu9opvQ
	(envelope-from <io-uring+bounces-13223-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:34:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D96CB4B964D
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5924630166D1
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 07:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7748A2D877D;
	Mon,  4 May 2026 07:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="X0dXVbkQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4699A2857EA
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 07:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777879921; cv=none; b=PL9+cVxv1jf3OP6Yt+VxHx36KA4ixQhmTHP8fTt5a21KQ/sDRTD/067nVa8niuCktOPBj8RUI8MRGh5Jd/OnESAqo/R8iAKOdb0clFsyc++djnYTKA/DJSZWFLr9FhXss0uCEVrTBCcrw/tysuxR1XufXi3NLC3EkMhsnQfHmBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777879921; c=relaxed/simple;
	bh=TTcEXLJtLk4CTbAcKG3Mql9kufoS0JFFUurylQ87QQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uw7dekusYbScGOzS6A+VYN1CG9/EfOVvRLRlfzNVn0JXr75Wposw96L9rKh/Q3wMHDNHFovbmkJVUEkFkAOwUE4dzdoO20Nlg7cb52C8UJeEUUV0Y9JZh/VKueQhjbszE0KIv60rBq3JXt34KbLwknjzG5acO7YTnwRDNCyQzdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=X0dXVbkQ; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6443uHL22742413
	for <io-uring@vger.kernel.org>; Mon, 4 May 2026 00:31:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=ABOyuV4sRK18AIgBhGvgNDj7q7mbFrR/LPRfI3qBBs4=; b=X0dXVbkQKr2O
	282vbQG5BFSkj6UE2KbjL5D0BQjWe3sANt2ra6hqfG8A+HEDLGgnTD5rsX2pLDrE
	L32ysHOT4fPnbRKtn0LC58SdY8PlleMIyRMI/dqAV4vJFGgXk4fZyWIjM8K+LZiz
	OA4jJfIVQ4SliIkuj8jVsI6lJBQ7rvU9z9OB92nF8iqFhFrhyL9hSeOqr5dTZDom
	QJXz+Y/EZQ9lEM59Gjo78Bv/oTF1/rnieKdgB1bqWQd5VX7F3dnHTksZzvGQu9If
	ywAuj3n75KOUexcBirYNeFguLR58RzWG+9vTrVvfJS5+tiVJYXEppjon2QNRcN/L
	jZ5/+qoX6Q==
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by m0001303.ppops.net (PPS) with ESMTPS id 4dwcx97q2m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 04 May 2026 00:31:57 -0700 (PDT)
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488a17a33e9so4255565e9.1
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 00:31:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777879917; x=1778484717;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D39sxhPIzrbj0ZtT9yuLEO8uF0MNmEK8jW6NlqELD0k=;
        b=iH+w78T8yy6nB4cSE8g32eBHkk/IckaS6mKKKnLzW3oID0eDyLVXfZukwvXMLOpoSH
         ozTFY6KoeZhYKJRh8TH4ytDCpxQNU0Efqt3gUYeH11pGPsPVZmvWTxLxZdDLMDv8DNtI
         zGO59lA7qzdW5p4rkgYUhnd3+2qRHLHp8WPtnnpYOHCGMupNGsIGp8XJi9wkewGgcB3I
         TFa+f3HoIE1zb4H4B0hyaRD2ClRLfPbAIj1bdzFhz4tbRBhgnu8jNe29oR7aqe34IIZF
         yBc4YLpQZdhr7AnEACkPLJg5XFOuO/flQh3zVMzVCn6MDQS92YTyNdg1LONoGEfwokeX
         GeiA==
X-Forwarded-Encrypted: i=1; AFNElJ/yme1Idj+/5Z2cSE2ljvuYxy7ijP7NFOeyPEUh5EDxpxhR5rjx/8pmXXl5HYjVVbdhct+ms6Vvsw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQdDdtDcw/GNhGJAiyli3PzO7EzF/ftADZbUqPoFIm1iTqLbYQ
	w2qoUS51qHtYBd/T2/aC3xWklYA7b9Hmr9alhCndzlGiPqYOwXgbWZSHb34uFgQGDDA573BHc8Z
	OIiQaxU4P03Yx+ZBwYRzPAqbc2vlSqnwvfZwonfUavUfr1acKtZcRn4LBt6Y=
X-Gm-Gg: AeBDietEVTlEGgaqx7UbZJcCN4TIlE1Z2Tkr+52jAVDzfXEt4h5R3jSXNE10TY7JLH7
	BT1vDHxe/CQCv99uApbdgqzZ9zLJd5AVbpPSowWQkmDktjcKywISY+SL+TaKjMVDPjdtvJNAb6Q
	PKFPU3fZQ55rLq2rEYjaX0ZRITKTCiKPnSzwnP0tz6/WQcMoKy5i292+qf51lTBomP+Q/CXgSUy
	809As+m6NuzibC/sc5FOjS3LdGwQrzVHDBjkOIFH7QJoHqZS7HQEjtRBRziiTroFqHPUhYhTbru
	qu2wyGpUszBmyFvkuFoXe0BFs8neafiafP/BFseVjzFuIbTH5TCmMGIDOWEoucvecjh1t4rSjFf
	eFeQcCqdbXmgU5L2ZX0HCxsfIfWWoCz7Mm1qy96lomLnU+w7xdClBAlTEsENFDuK4I2NzQa37
X-Received: by 2002:a05:600c:4f94:b0:487:17d:d0bf with SMTP id 5b1f17b1804b1-48a9867c712mr60427335e9.6.1777879916509;
        Mon, 04 May 2026 00:31:56 -0700 (PDT)
X-Received: by 2002:a05:600c:4f94:b0:487:17d:d0bf with SMTP id 5b1f17b1804b1-48a9867c712mr60426935e9.6.1777879915695;
        Mon, 04 May 2026 00:31:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:3f7b:7276:a343:d339? ([2a01:e0a:e17:9700:3f7b:7276:a343:d339])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fea68b4sm73578475e9.9.2026.05.04.00.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 00:31:55 -0700 (PDT)
Message-ID: <f2e104e2-0110-4dca-a285-81b0fc63a272@meta.com>
Date: Mon, 4 May 2026 09:31:49 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/rsrc: add huge page accounting for registered
 buffers
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <d377141e-064e-48a2-9a76-8477a90e8655@kernel.dk>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>
In-Reply-To: <d377141e-064e-48a2-9a76-8477a90e8655@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: h3cvtyQycm5U-xGpVegvbpmYRXxirEw2
X-Proofpoint-GUID: h3cvtyQycm5U-xGpVegvbpmYRXxirEw2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4MSBTYWx0ZWRfXxL7Hb6oR7yPH
 sb5aXQwrmLTDrtOALLAdxCS7zOzvvwonJnuPT/8/fm9OaRuTUpZg2q3NdWqiQkaXmZai9dret1W
 0CztYhFrjrRwzlcc7isT4Jb6y1Mje9+neOBrG+ZgCg12im4KV/jhUiQ36+RLhuH5MXQKXZK3HlX
 lU/CBTm7s/nf5bWboZg+Tp/1LsFSsFJSxer0GlC+GutYkote/z9YXxFIncG7czMJsYbSfbEqFhM
 RomMe0zQXLXyTvmYy7JX+K5RKp6Mooq+BiZcA3wp03GIAeAOSYoMCPK8YlBtCmPEeh6utRMIExV
 OFTGelXy/3hjameauvegMJel61Lugdd++STQ6EQGZAPdYg5a3PHEIoc0WyniSzPuIWVuHuFwvo6
 SIj0mSbQJcRnKoOIfisH7grQYA6QJW1tRWxYzOl3SlFWKRdeE8wmlVgoKGO/su4grDjIU4eNf4G
 IhEIi39V1bwVrLwc4kw==
X-Authority-Analysis: v=2.4 cv=SoCgLvO0 c=1 sm=1 tr=0 ts=69f84b6d cx=c_pps
 a=ocXdEHcuFBd2kx0v6vcWqw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=M51BFTxLslgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=s_rhyD67zrxYuDMM86sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Rspamd-Queue-Id: D96CB4B964D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.49 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.67)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13223-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[meta.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]

On 5/2/26 04:31, Jens Axboe wrote:
> >=20
> Track huge page references in a per-ring xarray to prevent double
> accounting when the same huge page is used by multiple registered
> buffers, either within the same ring or across cloned rings.
>=20
> When registering buffers backed by huge pages, we need to account for
> RLIMIT_MEMLOCK. But if multiple buffers share the same huge page (common
> with cloned buffers), we must not account for the same page multiple
> times. Similarly, we must only unaccount when the last reference to a
> huge page is released.
>=20
> Maintain a per-ring xarray (hpage_acct) that tracks reference counts for
> each huge page. When registering a buffer, for each unique huge page,
> increment its accounting reference count, and only account pages that
> are newly added.
>=20
> When unregistering a buffer, for each unique huge page, decrement its
> refcount. Once the refcount hits zero, the page is unaccounted.
>=20
> Note: any account is done against the ctx->user that was assigned when
> the ring was setup. As before, if root is running the operation, no
> accounting is done.
>=20
> With these changes, any use of imu->acct_pages is also dead, hence kill
> it from struct io_mapped_ubuf. This shrinks it from 56b to 48b on a
> 64-bit arch. Additionally, hpage_already_acct() is gone, which was an
> O(M*M) scan over current + previous registrations.
>=20
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>=20
> ---
>=20
> See previous discussions here:
>=20
> https://lore.kernel.org/io-uring/20260119071039.2113739-1-danisjiang@gmai=
l.com/
>=20
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 244392026c6d..23b8891d5704 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -446,6 +446,9 @@ struct io_ring_ctx {
>   	/* Stores zcrx object pointers of type struct io_zcrx_ifq */
>   	struct xarray			zcrx_ctxs;
>  =20
> +	/* Used for accounting references on pages in registered buffers */
> +	struct xarray		hpage_acct;
> +
>   	u32			pers_next;
>   	struct xarray		personalities;
>  =20
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4ed998d60c09..fb6ed52bae61 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -233,6 +233,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
>   		return NULL;
>  =20
>   	xa_init(&ctx->io_bl_xa);
> +	xa_init(&ctx->hpage_acct);
>  =20
>   	/*
>   	 * Use 5 bits less than the max cq entries, that should give us around
> @@ -302,6 +303,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
>   	io_free_alloc_caches(ctx);
>   	kvfree(ctx->cancel_table.hbs);
>   	xa_destroy(&ctx->io_bl_xa);
> +	xa_destroy(&ctx->hpage_acct);
>   	kfree(ctx);
>   	return NULL;
>   }
> @@ -2198,6 +2200,7 @@ static __cold void io_ring_ctx_free(struct io_ring_=
ctx *ctx)
>   	io_napi_free(ctx);
>   	kvfree(ctx->cancel_table.hbs);
>   	xa_destroy(&ctx->io_bl_xa);
> +	xa_destroy(&ctx->hpage_acct);
>   	kfree(ctx);
>   }
>  =20
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 650303626be6..ca22e07245c4 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -28,7 +28,51 @@ struct io_rsrc_update {
>   };
>  =20
>   static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *=
ctx,
> -			struct iovec *iov, struct page **last_hpage);
> +						   struct iovec *iov);
> +
> +static int hpage_acct_ref(struct io_ring_ctx *ctx, struct page *hpage,
> +			  bool *acct_new)
> +{
> +	unsigned long key =3D (unsigned long) hpage;
> +	unsigned long count;
> +	void *entry;
> +	int ret;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	entry =3D xa_load(&ctx->hpage_acct, key);
> +	if (!entry) {
> +		ret =3D xa_reserve(&ctx->hpage_acct, key, GFP_KERNEL_ACCOUNT);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	count =3D 1;
> +	if (entry)
> +		count =3D xa_to_value(entry) + 1;

Hi Jens,

Can't most of this be merged in the previous if/else ? ie:

	entry =3D xa_load(&ctx->hpage_acct, key);>
	count =3D 1;
	if (!entry) {
		ret =3D xa_reserve(&ctx->hpage_acct, key, GFP_KERNEL_ACCOUNT);
		if (ret)
			return ret;
		*acct_new =3D true;
	} else {
		count =3D xa_to_value(entry) + 1;
		*acct_new =3D false;
	}

> +	xa_store(&ctx->hpage_acct, key, xa_mk_value(count), GFP_KERNEL_ACCOUNT);
> +	*acct_new =3D (count =3D=3D 1);
> +	return 0;
> +}
> +
> +static bool hpage_acct_unref(struct io_ring_ctx *ctx, struct page *hpage)
> +{
> +	unsigned long key =3D (unsigned long) hpage;
> +	unsigned long count;
> +	void *entry;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	entry =3D xa_load(&ctx->hpage_acct, key);
> +	if (WARN_ON_ONCE(!entry))
> +		return false;
> +	count =3D xa_to_value(entry);
> +	if (count =3D=3D 1)
> +		xa_erase(&ctx->hpage_acct, key);
> +	else
> +		xa_store(&ctx->hpage_acct, key, xa_mk_value(count - 1), GFP_KERNEL_ACC=
OUNT);
> +	return count =3D=3D 1;

Maybe something like this could easier to read ?:

	if (count =3D=3D 1) {
		xa_erase(&ctx->hpage_acct, key);
		return true;
	}
=09
	xa_store(&ctx->hpage_acct, key, xa_mk_value(count - 1),=20
GFP_KERNEL_ACCOUNT);
	return false;



> +}
>  =20
>   /* only define max */
>   #define IORING_MAX_FIXED_FILES	(1U << 20)
> @@ -124,15 +168,53 @@ static void io_free_imu(struct io_ring_ctx *ctx, st=
ruct io_mapped_ubuf *imu)
>   		kvfree(imu);
>   }
>  =20
> +static unsigned long io_buffer_unaccount_pages(struct io_ring_ctx *ctx,
> +					       struct io_mapped_ubuf *imu)
> +{
> +	struct page *seen =3D NULL;
> +	unsigned long acct =3D 0;
> +	int i;
> +
> +	if (imu->flags & IO_REGBUF_F_KBUF || !ctx->user)
> +		return 0;
> +
> +	for (i =3D 0; i < imu->nr_bvecs; i++) {
> +		struct page *page =3D imu->bvec[i].bv_page;
> +		struct page *hpage;
> +
> +		if (!PageCompound(page)) {
> +			acct++;
> +			continue;
> +		}
> +
> +		hpage =3D compound_head(page);
> +		if (hpage =3D=3D seen)
> +			continue;
> +		seen =3D hpage;
> +
> +		/* Unaccount on last reference */
> +		if (hpage_acct_unref(ctx, hpage))
> +			acct +=3D page_size(hpage) >> PAGE_SHIFT;
> +		cond_resched();
> +	}
> +
> +	return acct;
> +}
> +
>   static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_u=
buf *imu)
>   {
> +	unsigned long acct_pages =3D 0;
> +
> +	/* Always decrement, so it works for cloned buffers too */
> +	acct_pages =3D io_buffer_unaccount_pages(ctx, imu);
> +
>   	if (unlikely(refcount_read(&imu->refs) > 1)) {
>   		if (!refcount_dec_and_test(&imu->refs))
>   			return;
>   	}
>  =20
> -	if (imu->acct_pages)
> -		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
> +	if (acct_pages)
> +		io_unaccount_mem(ctx->user, ctx->mm_account, acct_pages);
>   	imu->release(imu->priv);
>   	io_free_imu(ctx, imu);
>   }
> @@ -282,7 +364,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
>   {
>   	u64 __user *tags =3D u64_to_user_ptr(up->tags);
>   	struct iovec fast_iov, *iov;
> -	struct page *last_hpage =3D NULL;
>   	struct iovec __user *uvec;
>   	u64 user_data =3D up->data;
>   	__u32 done;
> @@ -307,7 +388,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
>   			err =3D -EFAULT;
>   			break;
>   		}
> -		node =3D io_sqe_buffer_register(ctx, iov, &last_hpage);
> +		node =3D io_sqe_buffer_register(ctx, iov);
>   		if (IS_ERR(node)) {
>   			err =3D PTR_ERR(node);
>   			break;
> @@ -605,76 +686,79 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *c=
tx)
>   }
>  =20
>   /*
> - * Not super efficient, but this is just a registration time. And we do =
cache
> - * the last compound head, so generally we'll only do a full search if w=
e don't
> - * match that one.
> - *
> - * We check if the given compound head page has already been accounted, =
to
> - * avoid double accounting it. This allows us to account the full size o=
f the
> - * page, not just the constituent pages of a huge page.
> + * Undo hpage_acct_ref() calls made during io_buffer_account_pin() on fa=
ilure.
> + * This operates on the pages array since imu->bvec isn't populated yet.
>    */
> -static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page *=
*pages,
> -				  int nr_pages, struct page *hpage)
> +static void io_buffer_unaccount_hpages(struct io_ring_ctx *ctx,
> +				       struct page **pages, int nr_pages)
>   {
> -	int i, j;
> +	struct page *seen =3D NULL;
> +	int i;
> +
> +	if (!ctx->user)
> +		return;
>  =20
> -	/* check current page array */
>   	for (i =3D 0; i < nr_pages; i++) {
> +		struct page *hpage;
> +
>   		if (!PageCompound(pages[i]))
>   			continue;
> -		if (compound_head(pages[i]) =3D=3D hpage)
> -			return true;
> -	}
> -
> -	/* check previously registered pages */
> -	for (i =3D 0; i < ctx->buf_table.nr; i++) {
> -		struct io_rsrc_node *node =3D ctx->buf_table.nodes[i];
> -		struct io_mapped_ubuf *imu;
>  =20
> -		if (!node)
> +		hpage =3D compound_head(pages[i]);
> +		if (hpage =3D=3D seen)
>   			continue;
> -		imu =3D node->buf;
> -		for (j =3D 0; j < imu->nr_bvecs; j++) {
> -			if (!PageCompound(imu->bvec[j].bv_page))
> -				continue;
> -			if (compound_head(imu->bvec[j].bv_page) =3D=3D hpage)
> -				return true;
> -		}
> -	}
> +		seen =3D hpage;
>  =20
> -	return false;
> +		hpage_acct_unref(ctx, hpage);
> +		cond_resched();
> +	}
>   }
>  =20
>   static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page *=
*pages,
> -				 int nr_pages, struct io_mapped_ubuf *imu,
> -				 struct page **last_hpage)
> +				 int nr_pages)
>   {
> +	unsigned long acct_pages =3D 0;
> +	struct page *seen =3D NULL;
>   	int i, ret;
>  =20
> -	imu->acct_pages =3D 0;
> +	if (!ctx->user)
> +		return 0;
> +
>   	for (i =3D 0; i < nr_pages; i++) {
> +		struct page *hpage;
> +		bool acct_new;
> +
>   		if (!PageCompound(pages[i])) {
> -			imu->acct_pages++;
> -		} else {
> -			struct page *hpage;
> -
> -			hpage =3D compound_head(pages[i]);
> -			if (hpage =3D=3D *last_hpage)
> -				continue;
> -			*last_hpage =3D hpage;
> -			if (headpage_already_acct(ctx, pages, i, hpage))
> -				continue;
> -			imu->acct_pages +=3D page_size(hpage) >> PAGE_SHIFT;
> +			acct_pages++;
> +			continue;
>   		}
> +
> +		hpage =3D compound_head(pages[i]);
> +		if (hpage =3D=3D seen)
> +			continue;
> +		seen =3D hpage;
> +
> +		ret =3D hpage_acct_ref(ctx, hpage, &acct_new);
> +		if (ret) {
> +			io_buffer_unaccount_hpages(ctx, pages, i);
> +			return ret;
> +		}
> +		if (acct_new)
> +			acct_pages +=3D page_size(hpage) >> PAGE_SHIFT;
> +		cond_resched();
>   	}
>  =20
> -	if (!imu->acct_pages)
> -		return 0;
> +	/* Try to account the memory */
> +	if (acct_pages) {
> +		ret =3D io_account_mem(ctx->user, ctx->mm_account, acct_pages);
> +		if (ret) {
> +			/* Undo the refs we just added */
> +			io_buffer_unaccount_hpages(ctx, pages, nr_pages);
> +			return ret;
> +		}
> +	}
>  =20
> -	ret =3D io_account_mem(ctx->user, ctx->mm_account, imu->acct_pages);
> -	if (ret)
> -		imu->acct_pages =3D 0;
> -	return ret;
> +	return 0;
>   }
>  =20
>   static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
> @@ -763,8 +847,7 @@ bool io_check_coalesce_buffer(struct page **page_arra=
y, int nr_pages,
>   }
>  =20
>   static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *=
ctx,
> -						   struct iovec *iov,
> -						   struct page **last_hpage)
> +						   struct iovec *iov)
>   {
>   	struct io_mapped_ubuf *imu =3D NULL;
>   	struct page **pages =3D NULL;
> @@ -811,7 +894,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
>   		goto done;
>  =20
>   	imu->nr_bvecs =3D nr_pages;
> -	ret =3D io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
> +	ret =3D io_buffer_account_pin(ctx, pages, nr_pages);
>   	if (ret)
>   		goto done;
>  =20
> @@ -861,7 +944,6 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
>   int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>   			    unsigned int nr_args, u64 __user *tags)
>   {
> -	struct page *last_hpage =3D NULL;
>   	struct io_rsrc_data data;
>   	struct iovec fast_iov, *iov =3D &fast_iov;
>   	const struct iovec __user *uvec;
> @@ -904,7 +986,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
>   			}
>   		}
>  =20
> -		node =3D io_sqe_buffer_register(ctx, iov, &last_hpage);
> +		node =3D io_sqe_buffer_register(ctx, iov);
>   		if (IS_ERR(node)) {
>   			ret =3D PTR_ERR(node);
>   			break;
> @@ -971,7 +1053,6 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd=
, struct request *rq,
>  =20
>   	imu->ubuf =3D 0;
>   	imu->len =3D blk_rq_bytes(rq);
> -	imu->acct_pages =3D 0;
>   	imu->folio_shift =3D PAGE_SHIFT;
>   	refcount_set(&imu->refs, 1);
>   	imu->release =3D release;
> @@ -1137,6 +1218,56 @@ int io_import_reg_buf(struct io_kiocb *req, struct=
 iov_iter *iter,
>   }
>  =20
>   /* Lock two rings at once. The rings must be different! */

This comment should be before lock_two_rings().

> +static int io_buffer_acct_cloned_hpages(struct io_ring_ctx *ctx,
> +					struct io_mapped_ubuf *imu)
> +{
> +	struct page *seen =3D NULL;
> +	int i, ret =3D 0;
> +
> +	if (imu->flags & IO_REGBUF_F_KBUF || !ctx->user)
> +		return 0;
> +
> +	for (i =3D 0; i < imu->nr_bvecs; i++) {
> +		struct page *page =3D imu->bvec[i].bv_page;
> +		struct page *hpage;
> +		bool acct_new;
> +
> +		if (!PageCompound(page))
> +			continue;
> +
> +		hpage =3D compound_head(page);
> +		if (hpage =3D=3D seen)
> +			continue;
> +		seen =3D hpage;
> +
> +		/* Atomically add reference for cloned buffer */
> +		ret =3D hpage_acct_ref(ctx, hpage, &acct_new);
> +		if (ret)
> +			break;
> +
> +		cond_resched();
> +	}
> +
> +	if (!ret)
> +		return 0;
> +
> +	/* Undo refs we added for bvecs [0..i) */
> +	seen =3D NULL;
> +	for (int j =3D 0; j < i; j++) {
> +		struct page *p =3D imu->bvec[j].bv_page;
> +		struct page *hp;
> +
> +		if (!PageCompound(p))
> +			continue;
> +		hp =3D compound_head(p);
> +		if (hp =3D=3D seen)
> +			continue;
> +		seen =3D hp;
> +		hpage_acct_unref(ctx, hp);
> +	}
> +	return ret;
> +}
> +
>   static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx=
 *ctx2)
>   {
>   	if (ctx1 > ctx2)
> @@ -1218,6 +1349,14 @@ static int io_clone_buffers(struct io_ring_ctx *ct=
x, struct io_ring_ctx *src_ctx
>  =20
>   			refcount_inc(&src_node->buf->refs);
>   			dst_node->buf =3D src_node->buf;
> +			/* track compound references to clones */
> +			ret =3D io_buffer_acct_cloned_hpages(ctx, src_node->buf);
> +			if (ret) {
> +				refcount_dec(&src_node->buf->refs);
> +				io_cache_free(&ctx->node_cache, dst_node);
> +				io_rsrc_data_free(ctx, &data);
> +				return ret;
> +			}
>   		}
>   		data.nodes[off++] =3D dst_node;
>   		i++;
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 44e3386f7c1c..c0f8a18ec767 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -38,7 +38,6 @@ struct io_mapped_ubuf {
>   	unsigned int	nr_bvecs;
>   	unsigned int    folio_shift;
>   	refcount_t	refs;
> -	unsigned long	acct_pages;
>   	void		(*release)(void *);
>   	void		*priv;
>   	u8		flags;
>=20

Thanks,

Cl=C3=A9ment


